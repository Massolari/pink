/// Module for managing focus state.
import gleam/json.{type Json}
import gleam/option.{type Option, None, Some}

/// `Focus` is the type returned by the `focus` function
pub type Focus {
  Focus(is_focused: Bool)
}

/// `FocusOptions` is the type used by the `focus` function to configure the focus state.
pub opaque type FocusOptions {
  FocusOptions(auto_focus: Bool, is_active: Bool, id: Option(String))
}

/// Create a new `FocusOptions` with the default values.
pub fn options() -> FocusOptions {
  FocusOptions(auto_focus: False, is_active: True, id: None)
}

/// Set the `auto_focus` field on the `FocusOptions`.
/// Auto focus this component, if there's no active (focused) component right now
pub fn set_auto_focus(options: FocusOptions, auto_focus: Bool) {
  FocusOptions(..options, auto_focus: auto_focus)
}

/// Set the `is_active` field on the `FocusOptions`.
/// Enable or disable this component's focus, while still maintaining its position in the list of focusable components. This is useful for inputs that are temporarily disabled
pub fn set_is_active(options: FocusOptions, is_active: Bool) {
  FocusOptions(..options, is_active: is_active)
}

/// Set the `id` field on the `FocusOptions`.
/// Set a component's focus ID, which can be used to programmatically focus the component. This is useful for large interfaces with many focusable elements, to avoid having to cycle through all of them
pub fn set_id(options: FocusOptions, id: String) {
  FocusOptions(..options, id: Some(id))
}

@internal
pub fn encode_options(options: FocusOptions) -> Json {
  json.object([
    #("autoFocus", json.bool(options.auto_focus)),
    #("isActive", json.bool(options.is_active)),
    #("id", case options.id {
      Some(id) -> json.string(id)
      None -> json.null()
    }),
  ])
}
