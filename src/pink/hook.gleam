/// This module contains hooks that are used to interact with the terminal and handle user input.
import gleam/dynamic.{type Dynamic}
import gleam/io
import gleam/json.{type Json}
import gleam/result
import gleam/string
import pink/focus.{type Focus, type FocusOptions}
import pink/key.{type Key}

/// `App` is a record that is returned by the `app` hook.
pub type App {
  App(exit: fn() -> Nil)
}

/// `Stdin` is a record that is returned by the `stdin` hook.
pub type Stdin {
  Stdin(
    stdin: Dynamic,
    is_raw_mode_supported: Bool,
    set_raw_mode: fn(Bool) -> Nil,
  )
}

/// `Stdout` is a record that is returned by the `stdout` hook.
pub type Stdout {
  Stdout(stdout: Dynamic, write: fn(String) -> Nil)
}

/// `Stderr` is a record that is returned by the `stderr` hook.
pub type Stderr {
  Stderr(stderr: Dynamic, write: fn(String) -> Nil)
}

/// `State` is a record that is returned by the `state` hook.
pub type State(a) {
  State(value: a, set: fn(a) -> Nil, set_with: fn(fn(a) -> a) -> Nil)
}

/// `FocusManager` is a record that is returned by the `focus_manager` hook.
pub type FocusManager {
  FocusManager(
    enable_focus: fn() -> Nil,
    disable_focus: fn() -> Nil,
    focus_next: fn() -> Nil,
    focus_previous: fn() -> Nil,
    focus: fn(String) -> Nil,
  )
}

/// `app` is a hook which exposes a function to manually exit the app (unmount).
@external(javascript, "../ink_ffi.mjs", "useApp")
pub fn app() -> App

/// `stdin` is a hook which exposes stdin stream
///
/// The `Stdin` record contains the following fields:
/// - `stdin` - process.stdin. Useful if your app needs to handle user input
/// - `is_raw_mode_supported` - A boolean flag determining if the current stdin supports `set_raw_mode`. A component using `set_raw_mode` might want to use `is_raw_mode_supported` to nicely fall back in environments where raw mode is not supported
/// - `set_raw_mode` - See [setRawMode](https://nodejs.org/api/tty.html#tty_readstream_setrawmode_mode). Ink exposes this function to be able to handle Ctrl+C, that's why you should use Ink's `set_raw_mode` instead of `process.stdin.setRawMode`
@external(javascript, "../ink_ffi.mjs", "useStdin_")
pub fn stdin() -> Stdin

/// `stdout` is a hook which exposes stdout stream, where Ink renders your app.
///
/// The `Stdout` record contains the following fields:
/// - `stdout` - process.stdout
/// - `write` - Write any string to stdout, while preserving Ink's output. It's useful when you want to display some external information outside of Ink's rendering and ensure there's no conflict between the two. It's similar to `static`, except it can't accept components, it only works with strings
@external(javascript, "../ink_ffi.mjs", "useStdout")
pub fn stdout() -> Stdout

/// `stderr` is a hook which exposes stderr stream.
///
/// The `Stderr` record contains the following fields:
/// - `stderr` - process.stderr
/// - `write` - Write any string to stderr, while preserving Ink's output. It's useful when you want to display some external information outside of Ink's rendering and ensure there's no conflict between the two. It's similar to `static`, except it can't accept components, it only works with strings
@external(javascript, "../ink_ffi.mjs", "useStderr")
pub fn stderr() -> Stderr

@external(javascript, "../ink_ffi.mjs", "useInput")
fn use_input(
  callback callback: fn(String, Json) -> Nil,
  options options: Json,
) -> Nil

@external(javascript, "../ink_ffi.mjs", "useFocus_")
fn use_focus(options options: Json) -> Focus

/// This hook exposes methods to enable or disable focus management for all components or manually switch focus to next or previous components.
///
/// The `FocusManager` record contains the following fields:
/// - `enable_focus` - Enable focus management for all components
/// Note: You don't need to call this method manually, unless you've disabled focus management. Focus management is enabled by default
/// - `disable_focus` - Disable focus management for all components. Currently active component (if there's one) will lose its focus.
/// - `focus_next` - Switch focus to the next focusable component. If there's no active component right now, focus will be given to the first focusable component. If active component is the last in the list of focusable components, focus will be switched to the first active component.
/// Note: Ink calls this method when user presses Tab.
/// - `focus_previous` - Switch focus to the previous focusable component. If there's no active component right now, focus will be given to the last focusable component. If active component is the first in the list of focusable components, focus will be switched to the last active component.
/// Note: Ink calls this method when user presses Shift+Tab.
/// - `focus` - Switch focus to the component with the specified id. If there's no component with that ID, focus will be given to the next focusable component.
@external(javascript, "../ink_ffi.mjs", "useFocusManager_")
pub fn focus_manager() -> FocusManager

@external(javascript, "../react_ffi.mjs", "useState")
fn use_state(initial initial: a) -> #(a, fn(fn(a) -> a) -> Nil)

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

/// Component that uses useFocus hook becomes "focusable" to Ink, so when user presses Tab, Ink will switch focus to this component.
/// If there are multiple components that execute useFocus hook, focus will be given to them in the order that these components are rendered in.
///
/// This hook returns a record with `is_focused` boolean field, which determines if this component is focused or not
pub fn focus(options: FocusOptions) {
  options
  |> focus.encode_options
  |> use_focus
}

/// `state` is a hook which allows you to create a stateful value.
/// This is a React hook and not a Ink hook.
/// Read more about it on [react.dev docs](https://react.dev/reference/react/useState)
///
/// This hook is here for convenience, so you don't have to create the bindings yourself
///
/// `state` returns a record with the following fields:
/// - `value` - The current state value
/// - `set` - A function to update the state value.
/// - `set_with` - A function to update the state value. It accepts a function which receives the current state value and returns a new state value.
pub fn state(initial: a) -> State(a) {
  let #(state, set_state) = use_state(initial)

  State(
    value: state,
    set: fn(a) { set_state(fn(_) { a }) },
    set_with: set_state,
  )
}
