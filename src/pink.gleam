/// This module provides functions to create Ink components
import gleam/json.{type Json}
import pink/attribute.{type Attribute}

/// A ReactNode is a representation of a component in the Ink library.
pub type ReactNode

/// Make a ReactNode from a function
/// This is needed to use React hooks in the function
///
/// ## Examples
/// ```gleam
/// use <- component()
/// let is_loading = hook.state(False)
/// ````
@external(javascript, "./react_ffi.mjs", "component")
pub fn component(element: fn() -> ReactNode) -> ReactNode

/// Wrapper for a fragment element
@external(javascript, "./react_ffi.mjs", "fragment")
fn react_fragment(attributes: Json, children: List(ReactNode)) -> ReactNode

/// Render a ReactNode to the terminal
/// This is the main function to use to render components
///
/// ## Examples
/// ```gleam
/// render(
///   box(
///     [
///       attribute.flex_direction(attribute.FlexColumn),
///       attribute.gap(1),
///     ],
///     [
///       text([], "Hello, "),
///       text([style.underline()], "world!"),
///     ]
///   )
/// )
/// ```
@external(javascript, "./ink_ffi.mjs", "render")
pub fn render(component: ReactNode) -> Nil

/// Wrapper for a box element
@external(javascript, "./ink_ffi.mjs", "box")
fn ink_box(attributes: Json, children: List(ReactNode)) -> ReactNode

/// Wrapper for a text element
@external(javascript, "./ink_ffi.mjs", "text")
fn ink_text(attributes: Json, content: String) -> ReactNode

/// Wrapper for a text element with children elements
@external(javascript, "./ink_ffi.mjs", "text")
fn ink_text_nested(attributes: Json, children: List(ReactNode)) -> ReactNode

/// Wrapper for a newline element
@external(javascript, "./ink_ffi.mjs", "newline")
fn ink_newline(attributes: Json) -> ReactNode

/// Wrapper for a spacer element
@external(javascript, "./ink_ffi.mjs", "spacer")
fn ink_spacer() -> ReactNode

/// Wrapper for a static element
@external(javascript, "./ink_ffi.mjs", "static_")
fn ink_static(items: List(a), child: fn(a, Int) -> ReactNode) -> ReactNode

/// Spinner component for Ink. Uses [cli-spinners](https://github.com/sindresorhus/cli-spinners) for the collection of spinners.
///
/// ## Examples
/// ```gleam
/// spinner(type_: "dots")
/// ```
@external(javascript, "./ink_spinner_ffi.mjs", "spinner")
pub fn spinner(type_ type_: String) -> ReactNode

/// Wrapper for a transform element
@external(javascript, "./ink_ffi.mjs", "transform")
fn ink_transform(
  transform: fn(String, Int) -> String,
  children: List(ReactNode),
) -> ReactNode

/// This component can display text, and change its style to make it bold, underline, italic or strikethrough.
/// It only supports text content. If you need to display other components within text, use `text_nested` instead.
/// 
/// ## Examples
/// ```gleam
/// text(with: [], displaying: "Hello, world!")
/// ```
pub fn text(
  with attributes: List(Attribute),
  displaying content: String,
) -> ReactNode {
  attributes
  |> attribute.encode
  |> ink_text(content)
}

/// The same as `text`, but allows you to nest other components within text.
///
/// ## Examples
/// ```gleam
/// text_nested(attr: [], content: [
///  text([style.bold()], "Hello, "),
///  text([style.underline()], "world!"),
/// ])
/// ```
pub fn text_nested(
  attr attributes: List(Attribute),
  content children: List(ReactNode),
) -> ReactNode {
  attributes
  |> attribute.encode
  |> ink_text_nested(children)
}

/// Creates a new ReactNode with the given element and children
fn node(
  element: fn(Json, List(ReactNode)) -> ReactNode,
  attributes: List(Attribute),
  children: List(ReactNode),
) -> ReactNode {
  attributes
  |> attribute.encode
  |> element(children)
}

/// A React fragment is a way to group multiple elements together
/// without adding extra nodes to the DOM.
///
/// ## Examples
/// ```gleam
/// fragment(attr: [], elements: [
///   box([attribute.padding(1)], [pink.text([], "Hello, ")]),
///   text([style.underline()], "world!"),
/// ])
/// ```
pub fn fragment(
  attr attributes: List(Attribute),
  elements children: List(ReactNode),
) -> ReactNode {
  node(react_fragment, attributes, children)
}

/// `box` is an essential Ink component to build your layout.
///
/// It's like a `<div style="display: flex">` in the browser.
///
/// ## Examples
/// ```gleam
/// box(
///   styles: [
///     attribute.flex_direction(attribute.FlexColumn),
///     attribute.gap(1),
///   ],
///   components: [
///     text([], "Hello, "),
///     text([style.underline()], "world!"),
///   ]
/// )
/// ```
pub fn box(
  styles attributes: List(Attribute),
  components children: List(ReactNode),
) -> ReactNode {
  node(ink_box, attributes, children)
}

/// Adds one or more newline (\n) characters. Must be used within <Text> components.
///
/// ## Examples
/// ```gleam
/// text_nested([], [
///   text([], "Hello, "),
///   newline([attribute.count(2)]),
///   text([], "world!")
/// ])
/// ```
pub fn newline(settings attributes: List(Attribute)) -> ReactNode {
  attributes
  |> attribute.encode
  |> ink_newline
}

/// A flexible space that expands along the major axis of its containing layout. It's useful as a shortcut for filling all the available spaces between elements.
/// For example, using <Spacer> in a <Box> with default flex direction (row) will position "Left" on the left side and will push "Right" to the right side.
///
/// ## Examples
/// ```gleam
/// box([], [
///   text([], "Left"),
///   spacer(),
///   text([], "Right"),
/// ])
/// box(
///   [
///     attribute.flex_direction(attribute.FlexColumn),
///     attribute.height(attribute.Spaces(10)),
///   ],
///   [text([], "Top"), spacer(), text([], "Bottom")],
/// )
/// ```
pub fn spacer() -> ReactNode {
  ink_spacer()
}

/// `static` component permanently renders its output above everything else. It's useful for displaying activity like completed tasks or logs - things that are not changing after they're rendered (hence the name "Static").
/// It's preferred to use <Static> for use cases like these, when you can't know or control the amount of items that need to be rendered.
///
/// ## Examples
/// ```gleam
/// fragment([], [
///   // This part will be rendered once to the terminal
///   static(for: tests, using: fn(test_, _index) {
///     box([attribute.key(test_)], [
///       text([attribute.color("green")], "  " <> test_),
///     ])
///   }),
///   // This part keeps updating as state changes
///   box([attribute.margin_top(1)], [
///     text([],
///       "Completed tests: " <> int.to_string(list.length(tests)),
///     ),
///   ]),
/// ])
/// ```
pub fn static(
  for items: List(a),
  using callback: fn(a, Int) -> ReactNode,
) -> ReactNode {
  ink_static(items, callback)
}

/// Transform a string representation of React components before they are written to output. For example, you might want to apply a gradient to text, add a clickable link or create some text effects.
/// These use cases can't accept React nodes as input, they are expecting a string. That's what <Transform> component does, it gives you an output string of its child components and lets you transform it in any way
///
/// ## Examples
/// ```gleam
/// transform(
///   apply: fn(output, _index) { string.uppercase(output) },
///   on: [text([], "Hello, world")],
/// )
/// ```
pub fn transform(
  apply transform: fn(String, Int) -> String,
  on children: List(ReactNode),
) -> ReactNode {
  ink_transform(transform, children)
}
