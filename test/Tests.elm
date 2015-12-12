module Tests where

import ElmTest exposing (..)
import I18n exposing (..)

i18nText =
  I18n.create <| config
    $ "en-us"
      ~ ("hello", "world")
      ~ ("age", "I am {0} years old.")
    $ "fr-fr"
      ~ ("hello", "monde")
      ~ ("age", "J'ai {0} ans.")

invalid =
  I18n.create <| config
    ~ ("this", "isn't allowed")


all : Test
all =
    suite "A Test Suite"
        [ test "Existing key lookup" <|
            assertEqual (i18nText "en-us" "hello" []) "world"
        , test "Other existing key lookup" <|
            assertEqual (i18nText "fr-fr" "hello" []) "monde"
        , test "Templated" <|
            assertEqual (i18nText "en-us" "age" ["24"]) "I am 24 years old."
        , test "Key doesn't exist" <|
            assertEqual (i18nText "en-us" "nope" []) "<I18n -- KEY nope NOT FOUND FOR LANG en-us>"
        , test "Lang doesn't exist" <|
            assertEqual (i18nText "no-pe" "age" []) "<I18n -- KEY age NOT FOUND FOR LANG no-pe>"
        , test "Invalid config" <|
            assertEqual (invalid "doesn't matter" "doesn't matter" []) "<I18n -- CONFIG IS INVALID>"
        ]
