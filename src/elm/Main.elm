import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List exposing (..)
import Dict
import Tuple
import Debug


--
-- MODEL
--
type alias Model =
    {
    }


init : (Model, Cmd Msg)
init =
    (
     {
     }
    , Cmd.none
    )

--
-- UPDATE
--
type Msg = None

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = (model, Cmd.none)


--
-- VIEW
--
view : Model -> Html Msg
view model = div []
             [
             ]

main : Program Never Model Msg
main = Html.program
       { init = init
       , view = view
       , update = update
       , subscriptions = (always Sub.none)
       }
