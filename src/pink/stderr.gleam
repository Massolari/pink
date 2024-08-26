import gleam/dynamic.{type Dynamic}

pub type Stderr

/// Get the stderr stream.
@external(javascript, "../stderr_ffi.mjs", "useStderr")
pub fn get() -> Stderr

/// process.stderr
@external(javascript, "../stderr_ffi.mjs", "stderr_")
pub fn stderr(stderr: Stderr) -> Dynamic

/// Write any string to stderr, while preserving Ink's output.
///
/// It's useful when you want to display some external information outside of Ink's rendering and ensure there's no conflict between the two. It's similar to `static`, except it can't accept components, it only works with strings
@external(javascript, "../stderr_ffi.mjs", "write")
pub fn write(on stderr: Stderr, chunk chunk: String) -> Nil
