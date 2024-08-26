pub type App

/// Get the current app instance
@external(javascript, "../app_ffi.mjs", "useApp")
pub fn get() -> App

/// Exit the app (unmount)
@external(javascript, "../app_ffi.mjs", "exit")
pub fn exit(app: App) -> Nil
