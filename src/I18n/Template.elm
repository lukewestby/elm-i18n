module I18n.Template where

type Component record
  = Literal String
  | Interpolation (record -> String)


type alias Template record =
  List (Component record)


template : String -> Template record
template firstString =
  [ Literal firstString ]


(<%) : Template record -> (record -> String) -> Template record
(<%) template interpolator =
  (Interpolation interpolator) :: template


(%>) : Template record -> String -> Template record
(%>) template string =
  (Literal string) :: template


renderComponent : record -> Component record -> String -> String
renderComponent record component output =
  case component of
    Literal string ->
      (++) output string
    Interpolation accessor ->
      (++) output <| accessor record


render : Template record -> record -> String
render template record =
  List.foldr (renderComponent record) "" template


myTemplate : Template { hello : String, world : String }
myTemplate =
  template "hello: " <% .hello %> ", world: " <% .world %> ""


myString : String
myString =
  render myTemplate { hello = "hello", world = "world" }
