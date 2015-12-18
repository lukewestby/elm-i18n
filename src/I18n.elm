module I18n (Language(Language), withLanguage, createLookup) where

{-|

@docs Language, withLanguage, createLookup

-}

import Dict exposing (Dict)
import Maybe exposing (Maybe(..))
import String.Interpolate exposing (interpolate)


{-| Type representing a language identifier
-}
type Language
    = Language String


type alias Entries =
    Dict String String


type alias LanguageConfig =
    Dict String Entries


type alias LookupFunction =
    Language -> String -> List String -> String


{-| Combines a language and a list of entries for consumption by createLookup
-}
withLanguage : Language -> List ( String, String ) -> ( Language, List ( String, String ) )
withLanguage =
    (,)


{-| Creates a function that can be used to lookup and interpolate a key for a
given language, returning the key as the value if the language or key cannot
be found in the configuration

    french =
        Language "fr-fr"

    i18nText =
        createLookup
            [ withLanguage
                french
                [ ( "good day", "bonjour" )
                , ( "I am {0} years old.", "J'ai {0} ans." )
                ]

    result =
        i18nText french "I am {0} years old." [ "24" ]

    {- result == "J'ai 24 ans." -}
-}
createLookup : List ( Language, List ( String, String ) ) -> LookupFunction
createLookup configList =
    let
        convertEntryToTuple ( language, entriesTuples ) =
            case language of
                Language name ->
                    ( name, Dict.fromList entriesTuples )

        lookupDict =
            configList
                |> List.map convertEntryToTuple
                |> Dict.fromList

        lookupFunction language key interpolations =
            case language of
                Language name ->
                    lookupDict
                        |> Dict.get name
                        |> Maybe.withDefault Dict.empty
                        |> Dict.get key
                        |> Maybe.withDefault key
                        |> (flip interpolate) interpolations
    in
        lookupFunction
