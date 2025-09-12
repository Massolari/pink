/// A module for decoding keyboard keys from JSON.
import gleam/dynamic/decode
import gleam/function
import gleam/list

/// A key on the keyboard.
pub type Key {
  UpArrow
  DownArrow
  LeftArrow
  RightArrow
  PageDown
  PageUp
  Return
  Escape
  Ctrl
  Shift
  Tab
  Backspace
  Delete
  Meta
}

fn decoder(key) {
  use value <- decode.then(decode.bool)

  case value {
    True -> Ok(key)
    False -> Error(Nil)
  }
  |> decode.success
}

@internal
pub fn list_decoder() {
  use up_arrow <- decode.field("upArrow", decoder(UpArrow))
  use down_arrow <- decode.field("downArrow", decoder(DownArrow))
  use left_arrow <- decode.field("leftArrow", decoder(LeftArrow))
  use right_arrow <- decode.field("rightArrow", decoder(RightArrow))
  use page_down <- decode.field("pageDown", decoder(PageDown))
  use page_up <- decode.field("pageUp", decoder(PageUp))
  use return <- decode.field("return", decoder(Return))
  use escape <- decode.field("escape", decoder(Escape))
  use ctrl <- decode.field("ctrl", decoder(Ctrl))
  use shift <- decode.field("shift", decoder(Shift))
  use tab <- decode.field("tab", decoder(Tab))
  use backspace <- decode.field("backspace", decoder(Backspace))
  use delete <- decode.field("delete", decoder(Delete))
  use meta <- decode.field("meta", decoder(Meta))

  list.filter_map(
    [
      up_arrow,
      down_arrow,
      left_arrow,
      right_arrow,
      page_down,
      page_up,
      return,
      escape,
      ctrl,
      shift,
      tab,
      backspace,
      delete,
      meta,
    ],
    function.identity,
  )
  |> decode.success
}
