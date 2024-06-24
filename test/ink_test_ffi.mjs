import { render as inkRender } from "ink-testing-library"

export const render = (component) => {
  const result = inkRender(component)
  return {
    ...result,
    last_frame: result.lastFrame
  }
}

export const setTimeout = (callback, ms) =>
  globalThis.setTimeout(callback, ms)


