export { useStdin } from "ink";

export const stdin_ = (stdin) => stdin.stdin

export const isRawModeSupported = (stdin) => stdin.isRawModeSupported

export const setRawMode = (stdin, value) => stdin.setRawMode(value)
