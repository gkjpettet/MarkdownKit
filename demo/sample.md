H1 header
============

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

  * this one
  * that one
  * the other one

Note that (not considering the asterisk) the actual text
content starts at 4-columns in.

> Block quotes are
> written like so.
>
> They can span multiple paragraphs,
> if you like.

Full unicode character support 😀👍

H2 header
------------

Here's a numbered list:

 1. first item
 2. second item
 3. third item

Note again how the actual text starts at 4 columns in (4 characters
from the left side). Here's a code sample:

    // A little loop.
    For i As Integer = 0 To 10
      MsgBox(Str(i))
    Next i

As you probably guessed, indented 4 spaces. By the way, instead of
indenting the block, you can use delimited blocks, if you like:

Roo Code:
```roo
# A comment.
12 # Inline comment.
100.54
3e10
4.5e-10
0xffaa00
0b1001
0o2345

var a = 100
var b = "Double quoted string"
var c = 'Single quoted string'
var d = "Single 'quotes' inside"
var e = 'Double "quotes" inside'

# Operators.
# +, -, /, *, %, &, =>, !, ^, : ,
# ., =, ==, >, <>, <, >=, <=, -=
# +=, /=, *=, %=, |, &, >>, >>

# Keywords.
# and, break, class, def, else, exit, for, if
# module, not, or, pass, quit, require, return
# self, static, super, var, while

def test(a, b):
  pass

class Doctor < Person:
  def init(name):
    pass

module Sonos:
  class Player:
    pass

print("Test")

if a.length > 100:
  pass

if name.starts_with?("Dr")
```

Xojo Code:
~~~xojo
Dim f As Xojo.IO.FolderItem // Comment
t = "Hello"
1 + 100.5
If write("something") Then
  Break
End If
#Pragma Warning "TODO"
Dim c As Color = &cFF0022
~~~

(which makes copying & pasting easier). Note that you can also optionally mark the
delimited block for syntax highlighters (seen above and below):

```python
import time
# Quick, count to ten!
for i in range(10):
    # (but not *too* quick)
    time.sleep(0.5)
    print(i)
```

Note how I used ` ``` ` to fence out the code block instead of `~~~`. Either works fine. Flanking text between backticks results in a `code span`.


### H3 ATX-style header ###

Now a nested list:

 1. First, get these ingredients:

      * carrots
      * celery
      * lentils

 2. Boil some water.

 3. Dump everything in the pot and follow
    this algorithm:

        find wooden spoon
        uncover pot
        stir
        cover pot
        balance wooden spoon precariously on pot handle
        wait 10 minutes
        goto first step (or shut off burner when done)

    Do not bump wooden spoon or it will fall.

Notice again how text always lines up on 4-space indents (including
that last line which continues item 3 above).

Here's a link to [a website](https://garrypettet.com). Here's a reference [style link][ref]. Typing a link between `<` and `>` will create an autolink: <https://google.com>.

[ref]: https://xojo.com

A horizontal rule follows.

***

Images can be specified like so:

![xojo image](https://www.xojo.com/account/mwx/mwx_long.png "Made with Xojo")

Note that you can backslash-escape any punctuation characters
which you wish to be displayed literally, e.g: \`foo\`, \*bar\*, etc.

You can use valid HTML entity references inline: &amp;, &copy;, &ouml;. This includes decimal character references (&#1234;) and hexadecimal references (&#xcab;).

Raw HTML can be included as a block:

<aside>
<p>Some Text</p>
</aside>

And inline <del>like this</del>