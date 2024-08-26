export { useStdout } from "ink";

export const stdout_ = (stdout) => stdout.stdout

export const write = (stdout, chunk) => stdout.write(chunk)
