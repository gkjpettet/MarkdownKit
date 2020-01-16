## About MarkdownKit

MarkdownKit is a 100% CommonMark compliant Markdown parser for Xojo written in pure Xojo code. I needed a fast and robust parser that not only would reliably generate the correct output but would also run on iOS. After looking around I realised that there was no other solution available for Xojo and so I decided to write one myself. MarkdownKit is a labour love, taking months of hard work and containing over 6000 lines of code.

MarkdownKit takes Markdown as input and generates an _abstract syntax tree_ (AST). From the AST, it is then able to render the input as HTML.

## Package Contents

This repo contains the following components:

1. The `MarkdownKit` module.
2. Demo application
3. Test suites

### The Demo Application

The demo app is a fully functioning Markdown editor with a live preview. It has light and dark themes (user-selectable) and will even highlight syntax within code blocks in the provided Markdown input. I have deliberately kept it light on features as its purpose is really just to demonstrate what can be achieved with MarkdownKit.

### The Desktop Test Suite

This application contains three windows: one for running the HTML tests, one for the AST tests and a third as a simple editor. Clicking the "Run" button on the toolbar for test windows will run all 649 tests from the [CommonMark 0.29 specification][cm spec], proving the compliance of the parser. Feel free to click on an individual test to see the provided input, the expected output and the generated output.

## A word about API 2.0

Xojo 2019 Release 2 introduced the new Xojo framework, known as _API 2.0_. API 2.0 is an attempt by Xojo to unify code between their platforms and make method naming more consistent as well as move everything to 0-based offsets. The master branch is API 2.0 compliant. Use either the API 1.0 branch if you need to support Xojo 2019 release 1.1 or earlier or the iOS branch if you need to support iOS. You can continue to use the API 1.0 branch in projects created from Xojo 2019 Release 2 onwards but you will get deprecation warnings in the analyze project pane. 

Going forwards, I will no longer support API 1.0, only API 2.0. 

## Quick Start

1. Open the `MarkdownKit.xojo_project` file in the IDE (in `src/`). Copy the `MarkdownKit` module from the navigator and paste it into your own project.
2. Convert Markdown source to HTML with the `MarkdownKit.ToHTML()` method:

```xojo
Dim html As String = MarkdownKit.ToHTML("Some **bold** text")
```

## Advanced Use

I imagine that most people will only ever need to use the simple `MarkdownKit.ToHTML()` method. However, if you want access to the abstract syntax tree created by `MarkdownKit` during parsing then you can, like so:

```xojo
Dim ast As New MarkdownKit.Document("Some **bold** text")

// Parsing Markdown is done in two phases. First the block structure is 
// determined and then inlines are parsed.
ast.ParseBlockStructure
ast.ParseInlines
```

Why might you want access to the AST? Well, maybe you want to do something as simple as render every soft linebreak in a document as a hard linebreak. Perhaps you want to output the Markdown source as something other than HTML.

`MarkdownKit` provides a class interface called `IRenderer` which must be implemented by any custom renderer you write. The built-in `MarkdownKit.HTMLRenderer` and `MarkdownKit.ASTRenderer` classes are examples of renderers which implement this interface. Take a look at their well-documented methods to learn how to write your own renderer.

[forums]: https://forum.xojo.com
[cm spec]: https://spec.commonmark.org/0.29/