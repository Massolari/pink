pub type FocusManager

/// Get the Focus Manager that is able to enable or disable focus management for all components or manually switch focus to next or previous components.
@external(javascript, "../ink_ffi.mjs", "useFocusManager")
pub fn get() -> FocusManager

/// Enable focus management for all components
///
/// Note: You don't need to call this method manually, unless you've disabled focus management. Focus management is enabled by default
@external(javascript, "../focus_manager_ffi.mjs", "enableFocus")
pub fn enable_focus(manager: FocusManager) -> Nil

/// Disable focus management for all components. Currently active component (if there's one) will lose its focus.
@external(javascript, "../focus_manager_ffi.mjs", "disableFocus")
pub fn disable_focus(manager: FocusManager) -> Nil

/// Switch focus to the next focusable component.
///
/// If there's no active component right now, focus will be given to the first focusable component. If active component is the last in the list of focusable components, focus will be switched to the first active component.
///
/// Note: Ink calls this method when user presses Tab.
@external(javascript, "../focus_manager_ffi.mjs", "focusNext")
pub fn focus_next(manager: FocusManager) -> Nil

/// Switch focus to the previous focusable component.
///
/// If there's no active component right now, focus will be given to the last focusable component. If active component is the first in the list of focusable components, focus will be switched to the last active component.
///
/// Note: Ink calls this method when user presses Shift+Tab.
@external(javascript, "../focus_manager_ffi.mjs", "focusPrevious")
pub fn focus_previous(manager: FocusManager) -> Nil

/// Switch focus to the component with the specified id. If there's no component with that ID, focus will be given to the next focusable component.
@external(javascript, "../focus_manager_ffi.mjs", "focus")
pub fn focus(manager: FocusManager, id: String) -> Nil
