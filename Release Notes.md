# Release Notes

## 1.0.3
_14th July 2019_
* Added an iOS test suite app for the 649 CommonMark HTML tests. The app is designed 
to run on an iPad in landscape mode. It's deliberately basic in its UI.

## 1.0.2
_10th July 2019_
* Another bug fix in `InlineScanner` that was causing a link to be created by 
a poorly formatted partial inline reference link.
* Added fixes to the `Text` based module to bring it to parity with the 
`String` based module.

## 1.0.1
_10th July 2019_
* Fixed a bug in the `InlineScanner` class that could cause an infinite loop to 
occur if a partially entered "full reference" link or image was parsed.
* `MarkdownKit.ToHTML` no longer catches exceptions. You should wrap calls 
to this method in a `Try...Catch` block yourself.

## 1.0.0
_9th July 2019_
* Initial public release.
