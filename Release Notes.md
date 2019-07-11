# Release Notes

## 1.0.1
_10th July 2019_
* Fixed a bug in the `InlineScanner` class that could cause an infinite loop to 
occur if a partially entered "full reference" link or image was parsed.
* `MarkdownKit.ToHTML` no longer catches exceptions. You should wrap calls 
to this method in a `Try...Catch` block yourself.

## 1.0.0
_9th July 2019_
* Initial public release.
