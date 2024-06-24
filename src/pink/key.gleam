/// A module for decoding keyboard keys from JSON.
import gleam/dynamic
import gleam/function
import gleam/list
import gleam/result

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
  fn(json) {
    json
    |> dynamic.bool
    |> result.map(fn(value) {
      case value {
        True -> Ok(key)
        False -> Error(Nil)
      }
    })
  }
}

@internal
pub fn list_decoder() {
  fn(json_string) {
    dynamic.decode9(
      fn(
        up_arrow,
        down_arrow,
        left_arrow,
        right_arrow,
        page_down,
        page_up,
        return,
        escape,
        ctrl,
      ) {
        dynamic.decode5(
          fn(shift, tab, backspace, delete, meta) {
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
          },
          dynamic.field("shift", decoder(Shift)),
          dynamic.field("tab", decoder(Tab)),
          dynamic.field("backspace", decoder(Backspace)),
          dynamic.field("delete", decoder(Delete)),
          dynamic.field("meta", decoder(Meta)),
        )(json_string)
      },
      dynamic.field("upArrow", decoder(UpArrow)),
      dynamic.field("downArrow", decoder(DownArrow)),
      dynamic.field("leftArrow", decoder(LeftArrow)),
      dynamic.field("rightArrow", decoder(RightArrow)),
      dynamic.field("pageDown", decoder(PageDown)),
      dynamic.field("pageUp", decoder(PageUp)),
      dynamic.field("return", decoder(Return)),
      dynamic.field("escape", decoder(Escape)),
      dynamic.field("ctrl", decoder(Ctrl)),
    )(json_string)
    |> result.flatten
  }
}
