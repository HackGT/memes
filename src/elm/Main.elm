import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import Random.List as RList
import Random
import Array
import Regex
import Json.Decode as J
import Http
import Dict


update_list : Cmd Msg
update_list =
    let
        url = "https://api.github.com/repos/HackGT/biodomes/contents/memes"
        decoder = J.array (J.field "name" J.string)
        request = Http.get url decoder
    in
        Http.send UpdateList request


files_to_links : Array.Array String -> Dict.Dict String Link
files_to_links links =
    let basename =
        Regex.replace Regex.All (Regex.regex "\\.ya?ml$") (\_ -> "")
    in
    let to_link text =
            { text = text
            , href = "https://" ++ text ++ ".memes.hack.gt"
            , ping = False
            , alive = False
            }
    in
    Array.map basename links
    |> Array.map to_link
    |> Array.toList
    |> List.map (\l -> (l.text, l))
    |> Dict.fromList


verify_next : Links -> Cmd Msg
verify_next links =
    let
        ping (t, l) = Http.send (Verify t) (Http.getString l.href)
    in
    Dict.toList links
    |> List.filter (\(_, l) -> not l.ping)
    |> List.head
    |> Maybe.map ping
    |> Maybe.withDefault Cmd.none


titles : List String
titles = [ "Deployed Memes Explorer"
         , "etherscan.io"
         , "explorer.exe"
         , "Firefox OS"
         ]


--
-- MODEL
--
type alias Link =
    { text: String
    , href: String
    , ping: Bool
    , alive: Bool
    }

type alias Links = Dict.Dict String Link

type alias Model =
    { memes: Links
    , error_update: Maybe Http.Error
    , title: Maybe String
    }


init : (Model, Cmd Msg)
init =
    (
     { memes = Dict.empty
     , error_update = Nothing
     , title = Nothing
     }
    , Random.generate NewTitle (RList.choose titles)
    )

--
-- UPDATE
--
type Msg = UpdateList (Result Http.Error (Array.Array String))
         | Verify String (Result Http.Error String)
         | RequestUpdate
         | NewTitle (Maybe String, List String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UpdateList (Ok updated) ->
            let new_model = { model | memes = files_to_links updated } in
            (new_model, verify_next new_model.memes)

        UpdateList (Err err) ->
            ({ model | error_update = Just err }, Cmd.none)

        Verify tag result ->
            let
                alive = Result.map (\_ -> True) result |> Result.withDefault False

                update = Maybe.map (\m -> { m | ping = True, alive = alive })

                new_memes = Dict.update tag update model.memes
            in
            ({ model | memes = new_memes }, verify_next new_memes)

        RequestUpdate -> (model, update_list)

        NewTitle (title, _) -> ({ model | title = title }, update_list)


--
-- VIEW
--
view : Model -> Html Msg
view model =
    div []
    [ h1 [class "title"] [text (Maybe.withDefault ";0" model.title)]
    , div [class "links"] (List.map link_to_html (Dict.values model.memes))
    , button [onClick RequestUpdate, class "refresh"] [text "Refresh"]
    ]


link_to_html : Link -> Html Msg
link_to_html link =
    div [classList [("alive", link.alive), ("ping", link.ping)]]
    [ a [href link.href]
        [text link.text]
    ]


main : Program Never Model Msg
main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = (always Sub.none)
       }
