module Tests (..) where

import ElmTest exposing (..)
import I18n exposing (createLookup, withLanguage, Language(Language))


english : Language
english =
    Language "en-us"


french : Language
french =
    Language "fr-fr"


german : Language
german =
    Language "de-de"


i18nText =
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


all : Test
all =
    suite
        "A Test Suite"
        [ test "Existing key with existing language succesfully looks up text"
            <| assertEqual (i18nText french "good day" []) "bonjour"
        , test "Existing key with non-existing language returns key as default"
            <| assertEqual (i18nText english "good day" []) "good day"
        , test "Non-existing key with existing language returns key as default"
            <| assertEqual (i18nText german "Hello {0}!" [ "world" ]) "Hello world!"
        , test "Non-existing key with non-existing language returns key as default"
            <| assertEqual (i18nText english "Hello {0}!" [ "world" ]) "Hello world!"
        ]
