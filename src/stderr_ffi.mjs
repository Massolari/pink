export { useStderr } from "ink";

export const stderr_ = (stderr) => stderr.stderr

export const write = (stderr, chunk) => stderr.write(chunk)
