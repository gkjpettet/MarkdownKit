## About MarkdownKit

MarkdownKit is a 100% CommonMark compliant Markdown parser for Xojo written in pure Xojo code. I needed a fast and robust parser that not only would reliably generate the correct output but would also run on iOS. After looking around I realised that there was no other solution available for Xojo and so I decided to write one myself. MarkdownKit is a labour love, taking months of hard work and containing over 8500 lines of code.

MarkdownKit takes Markdown as input and generates a Markdown `MKDocument` which is essentially an _abstract syntax tree_ (AST). From the AST, it is then able to render the input as HTML.

This repo contains the following components:

1. The `MarkdownKit` module.
2. Test suites
3. A simple HTML rendering demo

### Simple HTML Rendering Demonstration

The demo has two windows and by default opens the HTML rendering window. Simply type Markdown in the left hand text area and click the `Render` button. This will display the generated HTML and the rendered HTML in the tab panel on the right. I've deliberately kept the demo light on features as its purpose is really just to demonstrate what can be achieved with MarkdownKit.

### The Desktop Test Suite

The demo application a test suite window. Clicking the "Run" button on the toolbar for test windows will run all 649 tests from the [CommonMark 0.29 specification][cm spec], as well as additional edge case tests I came across whilst developing the parser. These tests prove the compliance of the parser. Feel free to click on an individual test to see the provided input, the expected output and the generated output.

## A word about API 2.0

Xojo 2019 Release 2 introduced the new Xojo framework, known as _API 2.0_. API 2.0 is an attempt by Xojo to unify code between their platforms and make method naming more consistent as well as move everything to 0-based offsets. The master branch is fully API 2.0 compliant. 

## Dependencies

MarkdownKit is 100% Xojo code and is self contained in its own module. It does not depend on any third party plugins but it does require three open source components I authored:

1. [`StringKit`][stringkit]
2. `TextLine`
3. `LineToken`

`TextLine` and `LineToken` are provided in this repo. I use MarkdownKit in other internal projects and they share these two classes.

`StringKit` is a module that provides a bunch of `String` manipulation methods. You will need to download it from its [GitHub repo][stringkit]. The Xojo IDE will ask you to locate it when it loads the Markdown project.

## Quick Start

To use MarkdownKit in your own projects just follow these steps:

1. Open the `MarkdownKit.xojo_project` file in the IDE (in `src/destkop`).
2. Copy the `MarkdownKit` module from the navigator and paste it into your own project.
3. Copy the `StringKit` module into your project (having downloaded it from its [repo][stringkit]).
4. Copy the `LineToken` and `TextLine` classes to your project.
5. Convert Markdown source to HTML with the `MarkdownKit.ToHTML()` method:

```xojo
Var html As String = MarkdownKit.ToHTML("Some **bold** text")
```

## Advanced Use

I imagine that most people will only ever need to use the simple `MarkdownKit.ToHTML()` method. However, if you want access to the abstract syntax tree created by `MarkdownKit` during parsing then you can, like so:

```xojo
Var ast As MarkdownKit.MKDocument = MarkdownKit.ToDocument("Some **bold** text")

// You can now visit the AST to render it using a class that implements `MKRenderer`:
Var htmlRenderer As New MKHTMLRenderer // Or your own class.
Call htmlRenderer.VisitDocument(ast)
```

Why might you want access to the AST? Well, maybe you want to do something as simple as render every soft line break in a document as a hard line break. Perhaps you want to output the Markdown source as something other than HTML.

`MarkdownKit` provides a class interface called `MKRenderer` which must be implemented by any custom renderer you write. I use the AST in a custom Markdown code editor I'm writing to colour the components of the source code. The built-in `MarkdownKit.MKHTMLRenderer` is an example of a renderer which implements this interface. Take a look at its well-documented methods to learn how to write your own renderer.

[forums]: https://forum.xojo.com
[cm spec]: https://spec.commonmark.org/0.29/
[stringkit]: https://github.com/gkjpettet/StringKit