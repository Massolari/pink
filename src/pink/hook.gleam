/// This module contains hooks that are used to interact with the terminal and handle user input.
import gleam/io
import gleam/json.{type Json}
import gleam/result
import gleam/string
import pink/focus.{type Focus, type FocusOptions}
import pink/key.{type Key}

@external(javascript, "../ink_ffi.mjs", "useInput")
fn use_input(
  callback callback: fn(String, Json) -> Nil,
  options options: Json,
) -> Nil

@external(javascript, "../ink_ffi.mjs", "useFocus_")
fn use_focus(options options: Json) -> Focus

/// `effect` is a hook which allows you to perform side effects in function components.
/// This is a React hook and not a Ink hook.
/// Read more about it on [react.dev docs](https://react.dev/reference/react/useEffect)
///
/// This hook is here for convenience, so you don't have to create the bindings yourself
///
/// If you want to run a cleanup function when the component unmounts, use `effect_clean` instead
@external(javascript, "../react_ffi.mjs", "useEffect")
pub fn effect(callback: fn() -> Nil, dependencies: List(a)) -> Nil

/// This is the same as `effect`, but it also allows you to run a cleanup function when the component unmounts
@external(javascript, "../react_ffi.mjs", "useEffect")
pub fn effect_clean(callback: fn() -> fn() -> Nil, dependencies: List(a)) -> Nil

/// This hook is used for handling user input.
/// It's a more convenient alternative to using `stdin` and listening to data events.
/// The callback you pass to `input` is called for each character when user enters any input.
/// However, if user pastes text and it's more than one character, the callback will be called only once and the whole string will be passed as input.
///
/// The `is_active` option is used to enable or disable capturing of user input.
/// Useful when there are multiple `input` hooks used at once to avoid handling the same input several times
///
/// ## Examples
/// ```gleam
/// component(fn() {
///   hook.input(fn(input, keys) {
///     case input, keys {
///       "q", _ -> // Exit program
///       _, [LeftArrow] -> // Left arrow key pressed
///     }
///   }, True)
/// })
/// ```
pub fn input(callback: fn(String, List(Key)) -> Nil, is_active: Bool) {
  use_input(
    fn(input: String, json_key: Json) {
      let key =
        json_key
        |> json.to_string
        |> json.decode(key.list_decoder())
        |> result.map_error(fn(decode_error) {
          io.debug("Failed to decode key" <> string.inspect(decode_error))
          decode_error
        })
        |> result.unwrap([])

      callback(input, key)
    },
    json.object([#("isActive", json.bool(is_active))]),
  )
}

/// Component that uses the `focus` hook becomes "focusable" to Ink, so when user presses Tab, Ink will switch focus to this component.
///
/// If there are multiple components that execute useFocus hook, focus will be given to them in the order that these components are rendered in.
///
/// This hook returns a record with `is_focused` boolean field, which determines if this component is focused or not
pub fn focus(options: FocusOptions) {
  options
  |> focus.encode_options
  |> use_focus
}
