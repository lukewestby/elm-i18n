# elm-i18n
`I18n` helps you generate a lookup function to easily internationalize your
applications. It provides a fluent API for building out sets of Strings for
different language identifiers and a helper for converting that configuration to
a convenient function that allows selection of language and keys as well as
[interpolation](https://github.com/lukewestby/elm-string-interpolate) that you
can use right in your `view` functions.

**This project is not finished!**

The API is entirely up for discussion and will definitely change before release
on `packages.elm-lang.org`. Any input and pull requests are very welcome and
encouraged. If you'd like to help or have ideas, get in touch with me at
@luke_dot_js on Twitter or @luke in the elmlang Slack!

## Example
```elm
import I18n exposing (..)
-- ...

currentLang : String
currentLang =
    "en-us"

lookup : String -> String -> List String -> String
lookup =
    I18n.create <| config
        $ "en-us"
            ~ ("favColor", "{0} is my favorite color")
        $ "en-gb"
            ~ ("favColor", "{0} is my favourite colour")

i18nText : String -> List String -> String
i18nText =
    lookup currentLang

main =
    show (i18nText "favColor" ["Blue"])
```


## Documentation

### `config : Config`
Helps you start chaining a configuration together.

### `(~) : Config -> (String, String) -> Config`
Attaches a key-value pair to the config under the current language. You must first use `($)` to attach a language before you can begin attaching key-value pairs.
```elm
config
    $ "en-us"
        ~ ("color", "color")
    $ "en-gb"
        ~ ("color", "colour")
```

### `($) : Config -> String -> Config`
Attaches all following key-value pairs to the given language identifier.
```elm
config
    $ "en-us"
        ~ ("hello", "world")
        ~ ("key", "value")
```

### `create : Config -> (String -> String -> List String -> String)`
Takes a config generated from the chaining operators and returns a lookup
function you can use in your `view`s. The function accepts a language
identifier, a key, and a list of strings to interpolate into the string value.
If the key or the language does not exist you will see an error message
returned.
