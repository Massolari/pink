import React from "react"
import { Text, Box, Newline, Spacer, useStdin, Static, Transform, useFocus, useFocusManager } from "ink";
export { render, useInput, useApp, useStderr, useStdout } from "ink";

export function element(element, props, children) {
  const parsedChildren = typeof children === "object" ? children.toArray() : [children]
  return React.createElement(element, props, ...parsedChildren);
}

export const text = (props, content) => element(Text, props, content);
export const box = (props, children) => element(Box, props, children);
export const newline = (props) => React.createElement(Newline, props, null);
export const spacer = () => React.createElement(Spacer, null, null);
export const static_ = (items, childFunc) => element(Static, { items: items.toArray() }, childFunc);
export const transform = (transform, children) => element(Transform, { transform }, children);

export const useStdin_ = () => {
  const stdin = useStdin()

  return {
    stdin: stdin.stdin,
    is_raw_mode_supported: stdin.isRawModeSupported,
    set_raw_mode: stdin.setRawMode,
  }
}

export const useFocus_ = (options) => {
  const focus = useFocus(options)

  return {
    is_focused: focus.isFocused,
  }
}

export const useFocusManager_ = () => {
  const manager = useFocusManager()

  return {
    enable_focus: manager.enableFocus,
    disable_focus: manager.disableFocus,
    focus_next: manager.focusNext,
    focus_previous: manager.focusPrevious,
    focus: manager.focus,
  }
}
