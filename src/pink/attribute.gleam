/// Attributes for components
import gleam/int
import gleam/json.{type Json}
import gleam/list
import gleam/string

/// `Attribute` is a type that represents an attribute of an element
pub opaque type Attribute {
  Attribute(key: String, value: Json)
}

/// `Wrap` is the type the function `wrap` accepts
pub type Wrap {
  Wrap
  Truncate
  TruncateStart
  TruncateMiddle
  TruncateEnd
}

/// `Dimension` is the type some functions accept
pub type Dimension {
  Spaces(Int)
  Percent(Int)
}

/// `FlexDirection` is the type the function `flex_direction` accepts
pub type FlexDirection {
  FlexRow
  FlexColumn
  FlexRowReverse
  FlexColumnReverse
}

/// `FlexWrap` is the type the function `flex_wrap` accepts
pub type FlexWrap {
  FlexWrap
  FlexNoWrap
  FlexWrapReverse
}

/// `AlignItems` is the type the function `align_items` accepts
pub type AlignItems {
  ItemsStart
  ItemsCenter
  ItemsEnd
}

/// `AlignSelf` is the type the function `align_self` accepts
pub type AlignSelf {
  SelfAuto
  SelfStart
  SelfCenter
  SelfEnd
}

/// `JustifyContent` is the type the function `justify_content` accepts
pub type JustifyContent {
  ContentStart
  ContentCenter
  ContentEnd
  ContentSpaceBetween
  ContentSpaceAround
}

/// `Display` is the type the function `display` accepts
pub type Display {
  DisplayFlex
  DisplayNone
}

/// `Visibility` is the type the overflow functions accept
pub type Visibility {
  Visible
  Hidden
}

/// `BorderStyle` is the type the function `border_style` accepts
pub type BorderStyle {
  BorderSingle
  BorderDouble
  BorderRound
  BorderBold
  BorderSingleDouble
  BorderDoubleSingle
  BorderClassic
  BorderCustom(
    top_left: String,
    top: String,
    top_right: String,
    left: String,
    bottom_left: String,
    bottom: String,
    bottom_right: String,
    right: String,
  )
}

/// Create a custom attribute
/// Useful for passing custom data to components or for setting attributes that are not yet supported by Pink
pub fn custom(key: String, value: Json) -> Attribute {
  Attribute(key, value)
}

/// Set a unique key for the element
/// Useful for components that are rendered in a loop
pub fn key(key: String) -> Attribute {
  Attribute("key", json.string(key))
}

/// Change text background color. Ink uses chalk under the hood, so all its functionality is supported
///
/// ## Examples
/// ```gleam
/// text([background_color("green")], "Green")
/// text([background_color("#005cc5")], "Blue")
/// text([background_color("rgb(232, 131, 136)")], "Red")
/// ```
pub fn background_color(color: String) -> Attribute {
  Attribute("backgroundColor", json.string(color))
}

/// Change text color. Ink uses chalk under the hood, so all its functionality is supported
///
/// ## Examples
/// ```gleam
/// text([color("green")], "Green")
/// text([color("#005cc5")], "Blue")
/// text([color("rgb(232, 131, 136)")], "Red")
/// ```
pub fn color(color: String) -> Attribute {
  Attribute("color", json.string(color))
}

/// Dim the color (emit a small amount of light)
///
/// ## Examples
/// ```gleam
/// text([dim_color("red")], "Dimmed red")
/// ```
pub fn dim_color(color: String) -> Attribute {
  Attribute("dimColor", json.string(color))
}

/// Make the text bold
pub fn bold(is_bold: Bool) -> Attribute {
  Attribute("bold", json.bool(is_bold))
}

/// Make the text italic
pub fn italic(is_italic: Bool) -> Attribute {
  Attribute("italic", json.bool(is_italic))
}

/// Make the text underlined
pub fn underline(is_underline: Bool) -> Attribute {
  Attribute("underline", json.bool(is_underline))
}

/// Make the text crossed with a line
pub fn strikethrough(is_strikethrough: Bool) -> Attribute {
  Attribute("strikethrough", json.bool(is_strikethrough))
}

/// Inverse background and foreground colors
///
/// ## Examples
/// ```gleam
/// text([inverse(True), color("yellow")], "Inversed Yellow")
/// ```
pub fn inverse(is_inverse: Bool) -> Attribute {
  Attribute("inverse", json.bool(is_inverse))
}

/// This property tells Ink to wrap or truncate text if its width is larger than container
/// If wrap is passed (by default), Ink will wrap text and split it into multiple lines. If Truncate* is passed, Ink will truncate text instead, which will result in one line of text with the rest cut off
///
/// ## Examples
/// ```gleam
/// box([width(7)], [text([], "Hello World")])
/// // -> "Hello\nWorld"
/// ```
/// ```gleam
/// // Truncate is an alias to TruncateEnd
/// box([width(7)], [text([wrap(Truncate)], "Hello World")])
/// // -> "Hello…"
/// ```
/// ```gleam
/// box([width(7)], [text([wrap(TruncateMiddle)], "Hello World")])
/// // -> "He…ld"
/// ```
/// ```gleam
/// box([width(7)], [text([wrap(TruncateStart)], "Hello World")])
/// // -> "…World"
/// ```
pub fn wrap(wrap: Wrap) -> Attribute {
  Attribute(
    "wrap",
    json.string(case wrap {
      Wrap -> "wrap"
      Truncate -> "truncate"
      TruncateStart -> "truncate-start"
      TruncateMiddle -> "truncate-middle"
      TruncateEnd -> "truncate-end"
    }),
  )
}

/// Sets a minimum width of the element
pub fn min_width(width: Int) -> Attribute {
  Attribute("minWidth", json.int(width))
}

/// Sets a minimum height of the element
pub fn min_height(height: Int) -> Attribute {
  Attribute("minHeight", json.int(height))
}

/// Top padding
pub fn padding_top(padding: Int) -> Attribute {
  Attribute("paddingTop", json.int(padding))
}

/// Bottom padding
pub fn padding_bottom(padding: Int) -> Attribute {
  Attribute("paddingBottom", json.int(padding))
}

/// Left padding
pub fn padding_left(padding: Int) -> Attribute {
  Attribute("paddingLeft", json.int(padding))
}

/// Right padding
pub fn padding_right(padding: Int) -> Attribute {
  Attribute("paddingRight", json.int(padding))
}

/// Horizontal padding. Equivalent to setting padding_left and padding_right
pub fn padding_x(padding: Int) -> Attribute {
  Attribute("paddingX", json.int(padding))
}

/// Vertical padding. Equivalent to setting padding_top and padding_bottom
pub fn padding_y(padding: Int) -> Attribute {
  Attribute("paddingY", json.int(padding))
}

/// Padding on all sides. Equivalent to setting padding_top, padding_bottom, padding_left and padding_right
pub fn padding(padding: Int) -> Attribute {
  Attribute("padding", json.int(padding))
}

/// Top margin
pub fn margin_top(margin: Int) -> Attribute {
  Attribute("marginTop", json.int(margin))
}

/// Bottom margin
pub fn margin_bottom(margin: Int) -> Attribute {
  Attribute("marginBottom", json.int(margin))
}

/// Left margin
pub fn margin_left(margin: Int) -> Attribute {
  Attribute("marginLeft", json.int(margin))
}

/// Right margin
pub fn margin_right(margin: Int) -> Attribute {
  Attribute("marginRight", json.int(margin))
}

/// Horizontal margin. Equivalent to setting margin_left and margin_right
pub fn margin_x(margin: Int) -> Attribute {
  Attribute("marginX", json.int(margin))
}

/// Vertical margin. Equivalent to setting margin_top and margin_bottom
pub fn margin_y(margin: Int) -> Attribute {
  Attribute("marginY", json.int(margin))
}

/// Margin on all sides. Equivalent to setting margin_top, margin_bottom, margin_left and margin_right
pub fn margin(margin: Int) -> Attribute {
  Attribute("margin", json.int(margin))
}

/// Size of the gap between an element's columns and rows. Shorthand for column_gap and row_gap
///
/// ## Examples
/// ```gleam
/// box([gap(1), width(3), flex_wrap(FlexWrap)], [
///   text([], "A"),
///   text([], "B"),
///   text([], "C")
/// ])
/// // -> A B
/// // ->
/// // -> C
/// ```
pub fn gap(gap: Int) -> Attribute {
  Attribute("gap", json.int(gap))
}

/// Size of the gap between an element's columns
///
/// ## Examples
/// ```gleam
/// box([column_gap(1)], [
///   text([], "A"),
///   text([], "B"),
/// ])
/// // -> A B
/// ```
pub fn column_gap(gap: Int) -> Attribute {
  Attribute("columnGap", json.int(gap))
}

/// Size of the gap between an element's rows
///
/// ## Examples
/// ```gleam
/// box([flex_direction(FlexColumn), row_gap(1)], [
///   text([], "A"),
///   text([], "B"),
/// ])
/// // -> A
/// // ->
/// // -> B
/// ```
pub fn row_gap(gap: Int) -> Attribute {
  Attribute("rowGap", json.int(gap))
}

/// Defines the ability for a flex item to grow if necessary. It accepts a unitless value that serves as a proportion. It dictates what amount of the available space inside the flex container the item should take up
/// For more information, see [flex-grow](https://css-tricks.com/almanac/properties/f/flex-grow/)
///
/// ## Examples
/// ```gleam
/// box([], [
///   text([], "Label"),
///   box([flex_grow(1)], [
///     text([], "Fills all remaining space")
///   ])
/// ])
/// ```
pub fn flex_grow(grow: Int) -> Attribute {
  Attribute("flexGrow", json.int(grow))
}

/// Specifies the “flex shrink factor” which determines how much the flex item will shrink relative to the rest of the flex items in the flex container when there isn’t enough space on the row
/// For more information, see [flex-shrink](https://css-tricks.com/almanac/properties/f/flex-shrink/)
///
/// ## Examples
/// ```gleam
/// box([width(20)], [
///   box([flex_shrink(2), width(10)], [
///     text([], "Will be 1/4")
///   ]),
///   box([width(10)], [
///     text([], "Will be 3/4")
///   ]),
/// ])
/// ```
pub fn flex_shrink(shrink: Int) -> Attribute {
  Attribute("flexShrink", json.int(shrink))
}

/// Specifies the initial size of the flex item, before any available space is distributed according to the flex factors.
/// When omitted from the flex shorthand, its specified value is the length zero
/// For more information, see [flex-basis](https://css-tricks.com/almanac/properties/f/flex-basis/)
///
/// ## Examples
/// ```gleam
/// box([width(6)], [
///   box([flex_basis(Spaces(3))], [
///     text([], "X")
///   ]),
///   text([], "Y")
/// ])
/// // -> X  Y
/// ```
/// ```gleam
/// box([width(6)], [
///   box([flex_basis(Percent(50))], [
///     text([], "X")
///   ]),
///   text([], "Y")
/// ])
/// // -> X  Y
/// ```
pub fn flex_basis(basis: Dimension) -> Attribute {
  Attribute("flexBasis", dimension_encoder(basis))
}

/// Establishes the main-axis, thus defining the direction flex items are placed in the flex container
/// For more information, see [flex-direction](https://css-tricks.com/almanac/properties/f/flex-direction/)
///
/// ## Examples
/// ```gleam
/// box([], [
///   box([margin_right(1)], [
///     text([], "X")
///   ]),
///   text([], "Y")
/// ])
/// // -> X Y
/// ```
/// ```gleam
/// box([flex_direction(FlexRowReverse)], [
///   text([], "X"),
///   box([margin_right(1)], [
///     text([], "Y")
///   ])
/// ])
/// // -> Y X
/// ```
/// ```gleam
/// box([flex_direction(FlexColumn)], [
///   text([], "X"),
///   text([], "Y")
/// ])
/// // -> X
/// // -> Y
/// ```
/// ```gleam
/// box([flex_direction(FlexColumnReverse)], [
///   text([], "X"),
///   text([], "Y")
/// ])
/// // -> Y
/// // -> X
/// ```
pub fn flex_direction(direction: FlexDirection) -> Attribute {
  Attribute(
    "flexDirection",
    json.string(case direction {
      FlexRow -> "row"
      FlexColumn -> "column"
      FlexRowReverse -> "row-reverse"
      FlexColumnReverse -> "column-reverse"
    }),
  )
}

/// Defines whether the flex items are forced in a single line or can be flowed into multiple lines.
/// If set to multiple lines, it also defines the cross-axis which determines the direction new lines are stacked in, aiding responsiveness layout behavior without CSS media queries
/// For more information, see [flex-wrap](https://css-tricks.com/almanac/properties/f/flex-wrap/)
///
/// ## Examples
/// ```gleam
/// box([width(2), flex_wrap(FlexWrap)], [
///   text([], "A"),
///   text([], "BC")
/// ])
/// // -> A
/// // -> BC
/// ```
/// ```gleam
/// box([flex_direction(FlexColumn), height(2), flex_wrap(FlexWrap)], [
///   text([], "A"),
///   text([], "B"),
///   text([], "C")
/// ])
/// // -> AC
/// // -> B
/// ```
pub fn flex_wrap(wrap: FlexWrap) -> Attribute {
  Attribute(
    "flexWrap",
    json.string(case wrap {
      FlexWrap -> "wrap"
      FlexNoWrap -> "nowrap"
      FlexWrapReverse -> "wrap-reverse"
    }),
  )
}

/// Effects how elements are aligned both in Flexbox and Grid layouts
/// For more information, see [align-items](https://css-tricks.com/almanac/properties/a/align-items/)
///
/// ## Examples
/// ```gleam
/// box([align_items(ItemsStart)], [
///   box([margin_right(1)], [text([], "X")]),
///   text_nested([], [
///      text([], "A"),
///      newline([]),
///      text([], "B"),
///      newline([]),
///      text([], "C"),
///   ]),
/// ])
/// // -> X A
/// // ->   B
/// // ->   C
/// ```
/// ```gleam
/// box([align_items(ItemsCenter)], [
///   box([margin_right(1)], [text([], "X")]),
///   text_nested([], [
///      text([], "A"),
///      newline([]),
///      text([], "B"),
///      newline([]),
///      text([], "C"),
///   ]),
/// ])
/// // ->   A
/// // -> X B
/// // ->   C
/// ```
/// ```gleam
/// box([align_items(ItemsEnd)], [
///   box([margin_right(1)], [text([], "X")]),
///   text_nested([], [
///      text([], "A"),
///      newline([]),
///      text([], "B"),
///      newline([]),
///      text([], "C"),
///   ]),
/// ])
/// // ->   A
/// // ->   B
/// // -> X C
/// ```
pub fn align_items(align: AlignItems) -> Attribute {
  Attribute(
    "alignItems",
    json.string(case align {
      ItemsStart -> "flex-start"
      ItemsCenter -> "center"
      ItemsEnd -> "flex-end"
    }),
  )
}

/// Makes possible to override the align-items value for specific flex items
/// For more information, see [align-self](https://css-tricks.com/almanac/properties/a/align-self/)
///
/// ## Examples
/// ```gleam
/// box([height(Spaces(3))], [
///   box([align_self(SelfStart)], [text([], "X")]),
/// ])
/// // -> X
/// // ->
/// // ->
/// ```
/// ```gleam
/// box([height(Spaces(3))], [
///   box([align_self(SelfCenter)], [text([], "X")]),
/// ])
/// // ->
/// // -> X
/// // ->
/// ```
/// ```gleam
/// box([height(Spaces(3))], [
///   box([align_self(SelfEnd)], [text([], "X")]),
/// ])
/// // ->
/// // ->
/// // -> X
/// ```
pub fn align_self(align: AlignSelf) -> Attribute {
  Attribute(
    "alignSelf",
    json.string(case align {
      SelfAuto -> "auto"
      SelfStart -> "flex-start"
      SelfCenter -> "center"
      SelfEnd -> "flex-end"
    }),
  )
}

/// Defines the alignment along the main axis.
/// It helps distribute extra free space leftover when either all the flex items on a line are inflexible, or are flexible but have reached their maximum size.
/// It also exerts some control over the alignment of items when they overflow the line
/// For more information, see [justify-content](https://css-tricks.com/almanac/properties/j/justify-content/)
///
/// ## Examples
/// ```gleam
/// box([justify_content(ContentStart)], [
///   text([], "X")
/// ])
/// // -> "X      "
/// ```
/// ```gleam
/// box([justify_content(ContentCenter)], [
///   text([], "X")
/// ])
/// // -> "   X   "
/// ```
/// ```gleam
/// box([justify_content(ContentEnd)], [
///   text([], "X")
/// ])
/// // -> "      X"
/// ```
/// ```gleam
/// box([justify_content(ContentSpaceBetween)], [
///   text([], "X"),
///   text([], "Y")
/// ])
/// // -> "X     Y"
/// ```
/// ```gleam
/// box([justify_content(ContentSpaceAround)], [
///   text([], "X"),
///   text([], "Y")
/// ])
/// // -> "  X   Y  "
/// ```
pub fn justify_content(justify: JustifyContent) -> Attribute {
  Attribute(
    "justifyContent",
    json.string(case justify {
      ContentStart -> "flex-start"
      ContentCenter -> "center"
      ContentEnd -> "flex-end"
      ContentSpaceBetween -> "space-between"
      ContentSpaceAround -> "space-around"
    }),
  )
}

/// Set this property to `DisplayNone` to hide the element
pub fn display(display: Display) -> Attribute {
  Attribute(
    "display",
    json.string(case display {
      DisplayFlex -> "flex"
      DisplayNone -> "none"
    }),
  )
}

/// Add a border with a specified style.
/// If `border_style` is not set, no border will be added.
/// Ink uses border styles from [cli-boxes](https://github.com/sindresorhus/cli-boxes) module.
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderSingle)], [text([], "single")])
/// // -> ┌──────┐
/// // -> │single│
/// // -> └──────┘
/// ```
/// ```gleam
/// box([border_style(BorderDouble)], [text([], "double")])
/// // -> ╔══════╗
/// // -> ║double║
/// // -> ╚══════╝
/// ```
/// ```gleam
/// box([border_style(BorderRound)], [text([], "round")])
/// // -> ╭─────╮
/// // -> │round│
/// // -> ╰─────╯
/// ```
/// ```gleam
/// box([border_style(BorderBold)], [text([], "bold")])
/// // -> ┏━━━━┓
/// // -> ┃bold┃
/// // -> ┗━━━━┛
/// ```
/// ```gleam
/// box([border_style(BorderSingleDouble)], [text([], "single double")])
/// // -> ╓─────────────╖
/// // -> ║single double║
/// // -> ╙─────────────╜
/// ```
/// ```gleam
/// box([border_style(BorderDoubleSingle)], [text([], "double single")])
/// // -> ╒═════════════╕
/// // -> │double single│
/// // -> ╘═════════════╛
/// ```
/// ```gleam
/// box([border_style(BorderClassic)], [text([], "classic")])
/// // -> +-------+
/// // -> |classic|
/// // -> +-------+
/// ```
pub fn border_style(style: BorderStyle) -> Attribute {
  Attribute("borderStyle", case style {
    BorderSingle -> json.string("single")
    BorderDouble -> json.string("double")
    BorderRound -> json.string("round")
    BorderBold -> json.string("bold")
    BorderSingleDouble -> json.string("singleDouble")
    BorderDoubleSingle -> json.string("doubleSingle")
    BorderClassic -> json.string("classic")
    BorderCustom(
      top_left,
      top,
      top_right,
      left,
      bottom_left,
      bottom,
      bottom_right,
      right,
    ) -> {
      json.object([
        #("topLeft", json.string(top_left)),
        #("top", json.string(top)),
        #("topRight", json.string(top_right)),
        #("left", json.string(left)),
        #("bottomLeft", json.string(bottom_left)),
        #("bottom", json.string(bottom)),
        #("bottomRight", json.string(bottom_right)),
        #("right", json.string(right)),
      ])
    }
  })
}

/// Change border color.
/// Shorthand for setting `border_top_color`, `border_right_color`, `border_bottom_color` and `border_left_color`.
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_color("green")], [
///   text([], "Green Rounded Box")
/// ])
/// ```
pub fn border_color(color: String) -> Attribute {
  Attribute("borderColor", json.string(color))
}

/// Change top border color. Accepts the same values as `color` in `text` function
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_top_color("green")], [
///   text([], "Hello world")
/// ])
/// ```
pub fn border_top_color(color: String) -> Attribute {
  Attribute("borderTopColor", json.string(color))
}

/// Change right border color. Accepts the same values as `color` in `text` function
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_right_color("green")], [
///   text([], "Hello world")
/// ])
/// ```
pub fn border_right_color(color: String) -> Attribute {
  Attribute("borderRightColor", json.string(color))
}

/// Change bottom border color. Accepts the same values as `color` in `text` function
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_bottom_color("green")], [
///   text([], "Hello world")
/// ])
/// ```
pub fn border_bottom_color(color: String) -> Attribute {
  Attribute("borderBottomColor", json.string(color))
}

/// Change left border color. Accepts the same values as `color` in `text` function
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_left_color("green")], [
///   text([], "Hello world")
/// ])
/// ```
pub fn border_left_color(color: String) -> Attribute {
  Attribute("borderLeftColor", json.string(color))
}

/// Dim the border color.
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_dim_color(True)], [
///   text([], "Hello world")
/// ])
/// ```
pub fn border_dim_color(has_color: Bool) -> Attribute {
  Attribute("borderDimColor", json.bool(has_color))
}

/// Dim the top border color.
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_top_dim_color(True)], [
///   text([], "Hello world")
/// ])
/// ```
pub fn border_top_dim_color(has_color: Bool) -> Attribute {
  Attribute("borderTopDimColor", json.bool(has_color))
}

/// Dim the bottom border color.
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_bottom_dim_color(True)], [
///   text([], "Hello world")
/// ])
/// ```
pub fn border_bottom_dim_color(has_color: Bool) -> Attribute {
  Attribute("borderBottomDimColor", json.bool(has_color))
}

/// Dim the left border color.
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_left_dim_color(True)], [
///   text([], "Hello world")
/// ])
/// ```
pub fn border_left_dim_color(has_color: Bool) -> Attribute {
  Attribute("borderLeftDimColor", json.bool(has_color))
}

/// Dim the right border color.
///
/// ## Examples
/// ```gleam
/// box([border_style(BorderRound), border_right_dim_color(True)], [
///   text([], "Hello world")
/// ])
/// ```
pub fn border_right_dim_color(has_color: Bool) -> Attribute {
  Attribute("borderRightDimColor", json.bool(has_color))
}

/// Determines whether top border is visible
pub fn border_top(has_border: Bool) -> Attribute {
  Attribute("borderTop", json.bool(has_border))
}

/// Determines whether right border is visible
pub fn border_right(has_border: Bool) -> Attribute {
  Attribute("borderRight", json.bool(has_border))
}

/// Determines whether bottom border is visible
pub fn border_bottom(has_border: Bool) -> Attribute {
  Attribute("borderBottom", json.bool(has_border))
}

/// Determines whether left border is visible
pub fn border_left(has_border: Bool) -> Attribute {
  Attribute("borderLeft", json.bool(has_border))
}

/// Number of newlines to insert
pub fn count(count: Int) -> Attribute {
  Attribute("count", json.int(count))
}

/// Width of the element.
/// You can set it in `Spaces` or in `Percent`, which will calculate the width based on the width of parent element.
/// ## Examples
/// ```gleam
/// box([width(Spaces(4))], [text([], "X")])
/// // -> X
/// ```
/// ```gleam
/// box([width(Spaces(10))], [
///   box([width(Percent(50))], [text([], "X")]),
///   text([], "Y")
/// ])
/// // -> X    Y
/// ```
pub fn width(width: Dimension) -> Attribute {
  Attribute("width", dimension_encoder(width))
}

/// Height of the element.
/// You can set it in lines (rows) or in percent, which will calculate the height based on the height of parent element
/// ## Examples
/// ```gleam
/// box([height(Spaces(4))], [text([], "X")])
/// // -> X\n\n\n
/// ```
/// ```gleam
/// box([height(Spaces(6)), flex_direction(FlexColumn)], [
///   box([width(Percent(50))], [text([], "X")]),
///   text([], "Y")
/// ])
/// // -> X\n\n\nY\n\n\n
/// ```
pub fn height(height: Dimension) -> Attribute {
  Attribute("height", dimension_encoder(height))
}

/// Behavior for an element's overflow in horizontal direction.
pub fn overflow_x(overflow: Visibility) -> Attribute {
  Attribute("overflowX", visibility_encoder(overflow))
}

/// Behavior for an element's overflow in vertical direction.
pub fn overflow_y(overflow: Visibility) -> Attribute {
  Attribute("overflowY", visibility_encoder(overflow))
}

/// Shortcut for setting `overflow_x` and `overflow_y` at the same time
pub fn overflow(overflow: Visibility) -> Attribute {
  Attribute("overflow", visibility_encoder(overflow))
}

pub fn encode(attributes: List(Attribute)) -> Json {
  attributes
  |> list.map(fn(attribute) { #(attribute.key, attribute.value) })
  |> json.object
}

fn dimension_encoder(dimension: Dimension) -> Json {
  case dimension {
    Spaces(spaces) -> json.int(spaces)
    Percent(percent) ->
      percent
      |> int.to_string
      |> string.append("%")
      |> json.string
  }
}

fn visibility_encoder(visibility: Visibility) -> Json {
  case visibility {
    Visible -> "visible"
    Hidden -> "hidden"
  }
  |> json.string
}
