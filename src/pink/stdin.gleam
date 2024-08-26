import gleam/dynamic.{type Dynamic}

pub type Stdin

/// Get the stdin stream
@external(javascript, "../stdin_ffi.mjs", "useStdin")
pub fn get() -> Stdin

/// Get the process.stdin. Useful if your app needs to handle user input
@external(javascript, "../stdin_ffi.mjs", "stdin_")
pub fn stdin(stdin: Stdin) -> Dynamic

/// A boolean flag determining if the current stdin supports `set_raw_mode`.
///
/// A component using `set_raw_mode` might want to use `is_raw_mode_supported` to nicely fall back in environments where raw mode is not supported
@external(javascript, "../stdin_ffi.mjs", "isRawModeSupported")
pub fn is_raw_mode_supported(stdin: Stdin) -> Bool

/// See [setRawMode](https://nodejs.org/api/tty.html#tty_readstream_setrawmode_mode).
///
/// Ink exposes this function to be able to handle Ctrl+C, that's why you should use Ink's `set_raw_mode` instead of `process.stdin.setRawMode`
@external(javascript, "../stdin_ffi.mjs", "setRawMode")
pub fn set_raw_mode(stdin: Stdin, raw_mode: Bool) -> Nil
