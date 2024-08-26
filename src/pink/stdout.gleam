import gleam/dynamic.{type Dynamic}

pub type Stdout

/// Get the stdout stream, where Ink renders your app.
@external(javascript, "../stdout_ffi.mjs", "useStdout")
pub fn get() -> Stdout

/// process.stdout
@external(javascript, "../stdout_ffi.mjs", "stdout_")
pub fn stdout(stdout: Stdout) -> Dynamic

/// Write any string to stdout, while preserving Ink's output.
///
/// It's useful when you want to display some external information outside of Ink's rendering and ensure there's no conflict between the two. It's similar to `static`, except it can't accept components, it only works with strings
@external(javascript, "../stdout_ffi.mjs", "write")
pub fn write(on stdout: Stdout, chunk chunk: String) -> Nil
