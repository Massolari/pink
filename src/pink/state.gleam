/// A reference to a state value in a React component.
pub type State(a)

/// Initialize a stateful value.
///
/// This is a React hook.
/// Read more about it on [react.dev docs](https://react.dev/reference/react/useState)
///
/// Note: This hook is here for convenience, so you don't have to create the bindings yourself
@external(javascript, "../react_ffi.mjs", "useState")
pub fn init(value value: a) -> State(a)

/// Get the current value of a state.
@external(javascript, "../react_ffi.mjs", "getState")
pub fn get(state: State(a)) -> a

/// Set the value of a state.
@external(javascript, "../react_ffi.mjs", "setState")
pub fn set(on state: State(a), value value: a) -> Nil

/// Update the value of a state using a function.
@external(javascript, "../react_ffi.mjs", "setState")
pub fn set_with(on state: State(a), with setter: fn(a) -> a) -> Nil
