> NOTICE: This package is deprecated in favor of the pattern proposed by
> @amitaibu in [this article](http://www.gizra.com/content/elm-i18n-type-safety/).
> lukewestby/elm-i18n will not be updated for Elm 0.17 to help communicate
> deprecation.

# elm-i18n
`I18n` helps you generate a lookup function to easily internationalize your
applications. It provides a fluent API for building out sets of Strings for
different language identifiers and a helper for converting that configuration to
a convenient function that allows selection of language and keys as well as
[interpolation](https://github.com/lukewestby/elm-string-interpolate) that you
can use right in your `view` functions.

 This package is still in early stages and I'm actively seeking feedback and
thinking about additional features. Any input and pull requests are very
welcome and encouraged. If you'd like to help or have ideas, get in touch with
me at @luke_dot_js on Twitter or @luke in the elmlang Slack!

## Example
```elm
import I18n exposing (withLanguage, createLookup, Language(Language))
-- ...

english : Language
english =
    Language "en-us"

french : Language
french =
    Language "fr-fr"

german : Language
german =
    Language "de-de"

lookup : Language -> String -> List String -> String
lookup =
    createLookup
        [ withLanguage
            french
            [ ( "good day", "bonjour" )
            , ( "I am {0} years old.", "J'ai {0} ans." )
            ]
        , withLanguage
            german
            [ ( "good day", "guten tag" )
            , ( "I am {0} years old.", "Ich bin {0} Jahre alt." )
            ]
        ]

currentLang : Language
currentLang =
  french

i18nText : String -> List String -> String
i18nText =
    lookup currentLang

main =
    show (i18nText "I am {0} years old." ["24"])
```
