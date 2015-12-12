module I18n
    ( create
    , config
    , ($)
    , (~)
    ) where

{-| Internationalization DSL for Elm

# Entries
@docs config, ($), (~)

# Lookup
@docs create

-}

import Maybe exposing (Maybe(..))
import Dict exposing (Dict)
import String.Interpolate exposing (interpolate)


type Config
    = ValidConfig (Maybe String) (List Entry)
    | InvalidConfig


type alias Entry =
    { lang : String
    , key : String
    , value : String
    }


group : (a -> comparable) -> List a -> Dict comparable (List a)
group grouper list =
    let
        folder entry dict =
            let
                entryIdentifier =
                    grouper entry

                lookedUp =
                    Dict.get entryIdentifier dict
            in
                case lookedUp of
                    Just groupedEntries ->
                        Dict.insert entryIdentifier (entry :: groupedEntries) dict

                    Nothing ->
                        Dict.insert entryIdentifier [ entry ] dict
    in
        List.foldl folder Dict.empty list


{-| An empty config from which to start buiding your own
-}
config : Config
config =
    ValidConfig Nothing []

{-| Attaches a language identifier to any following key value declarations.
    config
        $ "en-us"
            ~ ("hello", "world")
            ~ ("key", "value")
-}
($) : Config -> String -> Config
($) config lang =
    case config of
        ValidConfig activeLang entries ->
            ValidConfig (Just lang) entries

        InvalidConfig ->
            InvalidConfig

{-| Attaches a key value pair to the configuration chain. You cannot attach
key value configurations without first providing a language id to attach to.
    config
        $ "en-us"
            ~ ("hello", "world")
            ~ ("key", "value")
-}
(~) : Config -> ( String, String ) -> Config
(~) config ( key, value ) =
    case config of
        ValidConfig activeLang entries ->
            case activeLang of
                Just lang ->
                    Entry lang key value
                        |> flip (::) entries
                        |> ValidConfig (Just lang)

                Nothing ->
                    InvalidConfig

        InvalidConfig ->
            InvalidConfig


invalidConfigMessage : String
invalidConfigMessage =
    "<I18n -- CONFIG IS INVALID>"

keyNotFoundMessage : String -> String -> String
keyNotFoundMessage key lang =
    interpolate "<I18n -- KEY {0} NOT FOUND FOR LANG {1}>" [key, lang]

{-| Creates a lookup function from a config that you can call to retrieve
formatted String values for keys based on the current language, or curry with
the current language for easier access.
    i18nText =
        create <| config
            $ "en-us"
                ~ ("hello", "world{0}")

    i18nText "en-us" "hello" ["!"] == "world!"
    i18nText "nope" "hello" ["!"] == "<KEY notThere NOT FOUND FOR LANG nope>"
-}
create : Config -> String -> String -> List String -> String
create config =
    case config of
        InvalidConfig ->
            \a b c -> invalidConfigMessage

        ValidConfig _ entries ->
            let
                mapEntryToKeyValue entry =
                    ( .key entry, .value entry )

                lookupDict =
                    entries
                        |> group .lang
                        |> Dict.map (\_ entry -> List.map mapEntryToKeyValue entry)
                        |> Dict.map (\_ entry -> Dict.fromList entry)

                findEntry lang key interpolations =
                    Dict.get lang lookupDict
                        |> Maybe.withDefault Dict.empty
                        |> Dict.get key
                        |> Maybe.withDefault (keyNotFoundMessage key lang)
                        |> flip interpolate interpolations
            in
                findEntry
