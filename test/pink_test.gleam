import birdie
import gleam/int
import gleam/javascript/promise
import gleam/list
import gleam/string
import gleeunit
import pink.{type ReactNode}
import pink/attribute
import pink/focus
import pink/hook

pub type Timer

pub type Render {
  Render(last_frame: fn() -> String, frames: List(String))
}

@external(javascript, "./ink_test_ffi.mjs", "render")
pub fn render(component: ReactNode) -> Render

@external(javascript, "./ink_test_ffi.mjs", "setTimeout")
pub fn set_timeout(callback: fn() -> Nil, timeout: Int) -> Timer

pub fn main() {
  gleeunit.main()
}

pub fn text_test() {
  let data =
    pink.fragment([], [
      pink.text([], "Hello, world"),
      // Disable these tests for now, as they are not supported by the CI
    // pink.text([attribute.color("green")], "I am green"),
    // pink.text(
    //   [attribute.color("black"), attribute.background_color("white")],
    //   "I am black on white",
    // ),
    // pink.text([attribute.color("#ffffff")], "I am white"),
    // pink.text([attribute.bold(True)], "I am bold"),
    // pink.text([attribute.italic(True)], "I am italic"),
    // pink.text([attribute.underline(True)], "I am underline"),
    // pink.text([attribute.strikethrough(True)], "I am strikethrough"),
    // pink.text([attribute.inverse(True)], "I am inversed"),
    ])
    |> render

  data.last_frame()
  |> birdie.snap("text")
}

pub fn box_test() {
  let data =
    pink.box([attribute.flex_direction(attribute.FlexColumn)], [
      pink.box([attribute.margin(2)], [
        pink.text([], "This is a box with margin 2"),
      ]),
      pink.box([attribute.width(attribute.Spaces(4))], [
        pink.text([], "width 4"),
      ]),
      pink.box([attribute.height(attribute.Spaces(4))], [
        pink.text([], "height 4"),
      ]),
      pink.box([], [
        pink.box(
          [
            attribute.border_style(attribute.BorderSingle),
            attribute.margin_right(2),
          ],
          [pink.text([], "single")],
        ),
        pink.box(
          [
            attribute.border_style(attribute.BorderDouble),
            attribute.margin_right(2),
          ],
          [pink.text([], "double")],
        ),
        pink.box(
          [
            attribute.border_style(attribute.BorderRound),
            attribute.margin_right(2),
          ],
          [pink.text([], "round")],
        ),
        pink.box([attribute.border_style(attribute.BorderBold)], [
          pink.text([], "bold"),
        ]),
      ]),
      pink.box([], [
        pink.box(
          [
            attribute.border_style(attribute.BorderSingleDouble),
            attribute.margin_right(2),
          ],
          [pink.text([], "single double")],
        ),
        pink.box(
          [
            attribute.border_style(attribute.BorderDoubleSingle),
            attribute.margin_right(2),
          ],
          [pink.text([], "double single")],
        ),
        pink.box([attribute.border_style(attribute.BorderClassic)], [
          pink.text([], "classic"),
        ]),
      ]),
    ])
    |> render

  data.last_frame()
  |> birdie.snap("box")
}

pub fn newline_test() {
  let data =
    pink.text_nested([], [
      pink.text([], "Hello"),
      pink.newline([attribute.count(2)]),
      pink.text([], "World"),
    ])
    |> render

  data.last_frame()
  |> birdie.snap("newline")
}

pub fn spacer_test() {
  let data =
    pink.box(
      [attribute.flex_direction(attribute.FlexColumn), attribute.gap(1)],
      [
        pink.box([], [
          pink.text([], "Left"),
          pink.spacer(),
          pink.text([], "Right"),
        ]),
        pink.box(
          [
            attribute.flex_direction(attribute.FlexColumn),
            attribute.height(attribute.Spaces(10)),
          ],
          [pink.text([], "Top"), pink.spacer(), pink.text([], "Bottom")],
        ),
      ],
    )
    |> render

  data.last_frame()
  |> birdie.snap("spacer")
}

pub fn static_test() {
  promise.new(fn(resolve) {
    let data =
      pink.component(fn() {
        let tests = hook.state([])

        let run = fn() {
          tests.set_with(fn(previous_tests) {
            list.append(previous_tests, [
              "Test " <> int.to_string(list.length(previous_tests) + 1),
            ])
          })
        }

        hook.effect(
          fn() {
            list.range(1, 10)
            |> list.each(fn(n) { set_timeout(run, n * 100) })
          },
          [],
        )

        pink.fragment([], [
          pink.static(for: tests.value, using: fn(test_, _index) {
            pink.box([attribute.key(test_)], [pink.text([], "  " <> test_)])
          }),
          pink.box([attribute.margin_top(1)], [
            pink.text(
              [],
              "Completed tests: " <> int.to_string(list.length(tests.value)),
            ),
          ]),
        ])
      })
      |> render

    set_timeout(fn() { resolve(data) }, 1100)

    Nil
  })
  |> promise.await(fn(data) {
    data.last_frame()
    |> birdie.snap("static")
    |> promise.resolve
  })
}

pub fn transform_test() {
  let data =
    pink.transform(apply: fn(output, _index) { string.uppercase(output) }, on: [
      pink.text([], "Hello, world"),
    ])
    |> render

  data.last_frame()
  |> birdie.snap("transform")
}

pub fn spinner_test() {
  let data =
    pink.spinner("dots")
    |> render

  data.last_frame()
  |> birdie.snap("spinner")
}

pub fn use_state_test() {
  promise.new(fn(resolve) {
    let data =
      pink.component(fn() {
        let message = hook.state("Hello, world")

        hook.effect(
          fn() {
            message.set("Changed")
            set_timeout(
              fn() { message.set_with(fn(previous) { previous <> " 2" }) },
              0,
            )
            Nil
          },
          [],
        )

        pink.text([], message.value)
      })
      |> render
    set_timeout(fn() { resolve(data) }, 10)

    Nil
  })
  |> promise.await(fn(data) {
    data.frames
    |> string.join("\n---\n")
    |> birdie.snap("hook state")
    |> promise.resolve
  })
}

pub fn use_input_test() {
  let data =
    pink.component(fn() {
      hook.input(fn(_input, _keys) { Nil }, True)

      pink.text([], "Type something")
    })
    |> render

  data.last_frame()
  |> birdie.snap("hook input")
}

pub fn use_app_test() {
  let data =
    pink.component(fn() {
      let app = hook.app()

      hook.effect(fn() { app.exit() }, [])

      pink.text([], "Hello, world")
    })
    |> render

  data.last_frame()
  |> birdie.snap("hook app")
}

pub fn use_stdin_test() {
  let data =
    pink.component(fn() {
      let stdin = hook.stdin()

      hook.effect(
        fn() {
          case stdin.is_raw_mode_supported {
            True -> stdin.set_raw_mode(True)
            False -> Nil
          }
        },
        [],
      )

      pink.text(
        [],
        "is_raw_mode_supported: " <> string.inspect(stdin.is_raw_mode_supported),
      )
    })
    |> render

  data.last_frame()
  |> birdie.snap("hook stdin")
}

pub fn use_stdout_test() {
  promise.new(fn(resolve) {
    let data =
      pink.component(fn() {
        let stdout = hook.stdout()

        hook.effect(fn() { stdout.write("Hello from stdout") }, [])

        pink.text([], "Hello from text")
      })
      |> render

    set_timeout(fn() { resolve(data) }, 100)

    Nil
  })
  |> promise.await(fn(data) {
    data.last_frame()
    |> birdie.snap("hook stdout")
    |> promise.resolve
  })
}

pub fn use_focus_test() {
  let data =
    pink.component(fn() {
      let focus =
        hook.focus(
          focus.options()
          |> focus.set_auto_focus(True),
        )

      pink.text([], case focus.is_focused {
        True -> "I am focused"
        False -> "I am not focused"
      })
    })
    |> render

  data.last_frame()
  |> birdie.snap("hook focus")
}

pub fn use_manager_test() {
  let focusable_component =
    pink.component(fn() {
      let focus = hook.focus(focus.options())
      pink.text([], case focus.is_focused {
        True -> "I am focused"
        False -> "I am not focused"
      })
    })
  promise.new(fn(resolve) {
    let data =
      pink.component(fn() {
        let manager = hook.focus_manager()
        hook.effect(
          fn() {
            manager.disable_focus()
            manager.enable_focus()
            manager.focus_next()
            set_timeout(fn() { manager.focus_previous() }, 0)
            Nil
          },
          [],
        )
        pink.box([attribute.flex_direction(attribute.FlexColumn)], [
          focusable_component,
          focusable_component,
        ])
      })
      |> render

    set_timeout(fn() { resolve(data) }, 10)

    Nil
  })
  |> promise.await(fn(data) {
    data.frames
    |> string.join("\n---\n")
    |> birdie.snap("hook focus_manager")
    |> promise.resolve
  })
}
