# pink
Bindings to [Ink](https://github.com/vadimdemedes/ink)

A minimal React-like library for building terminal UIs.

[![Package Version](https://img.shields.io/hexpm/v/pink)](https://hex.pm/packages/pink)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pink/)

## Installation

This package depends on Ink and React. The specific versions listed below are recommended because they have been tested with this package. Using other versions may lead to unexpected results.

```sh
npm install ink@5.0 ink-spinner@5.0 react@18.3
```

To add the Pink package to your Gleam project, use the following command:

```sh
gleam add pink
```

Here's a basic example of how to use Pink:

```gleam
import pink
import pink/attribute
import pink/hook

pub fn main() {
    // Create a new React component (we need this to use hooks)
    use <- pink.component()

    // Initialize a state (this is React's useState hook)
    let message = hook.state("World")

    // Create a box with a border and a text component inside
    pink.box([attribute.border_style(attribute.BorderSingle)], [
        pink.text([], "Hello, " <> message.value)
    ])
}
```
