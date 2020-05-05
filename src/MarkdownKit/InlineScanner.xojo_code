#tag Class
Protected Class InlineScanner
	#tag Method, Flags = &h0
		Shared Sub CleanLinkLabel(chars() As String)
		  // Cleans up a label parsed by ScanLinkLabel by removing the flanking [].
		  // Mutates the passed array.
		  
		  chars.RemoveRowAt(0)
		  Call chars.Pop
		  
		  CollapseInternalWhitespace(chars)
		  StripLeadingWhitespace(chars)
		  StripTrailingWhitespace(chars)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub CleanLinkTitle(chars() As String)
		  // Takes an array of characters representing a link title that has been parsed by ScanLinkTitle().
		  // Removes surrounding delimiters, handles backslash-escaped characters and replaces character references.
		  // NB: Does NOT unescape special characters.
		  // Mutates the passed array.
		  
		  // Remove the flanking delimiters.
		  chars.RemoveRowAt(0)
		  Call chars.Pop
		  
		  Utilities.Unescape(chars)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub CleanURL(chars() As String)
		  // Takes an array of characters representing a URL that has been parsed by ScanLinkURL().
		  // Removes surrounding whitespace, surrounding "<" and ">", handles backslash-escaped 
		  // characters and replaces character references.
		  // Mutates the passed array.
		  
		  Dim charsUbound As Integer = chars.LastRowIndex
		  
		  If charsUbound = -1 Then Return
		  
		  // Remove flanking whitespace.
		  StripLeadingWhitespace(chars)
		  StripTrailingWhitespace(chars)
		  
		  // If the URL has flanking < and > characters, remove them.
		  If charsUbound >= 1 And chars(0) = "<" And chars(charsUbound) = ">" Then
		    chars.RemoveRowAt(0)
		    Call chars.Pop
		  End If
		  
		  Utilities.Unescape(chars)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub CloseBuffer(ByRef buffer As MarkdownKit.Block, container As MarkdownKit.Block, stripTrailingWhitespace As Boolean = False)
		  // There's an open preceding text inline. Close it.
		  buffer.Close
		  
		  If stripTrailingWhitespace Then MarkdownKit.StripTrailingWhitespace(buffer.Chars)
		  
		  // Add the buffer to the container block before the code span.
		  container.Children.AddRow(buffer)
		  
		  buffer = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub CollapseInternalWhitespace(chars() As String)
		  // Collapses consecutive whitespace within the passed character array to a single space.
		  // Mutates the passed array.
		  
		  #If Not TargetWeb
		    #Pragma DisableBackgroundTasks
		  #Endif
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim i As Integer = 0
		  Dim collapse As Boolean = False
		  Dim c As String
		  While i < chars.LastRowIndex
		    c = chars(i)
		    
		    If Utilities.IsWhitespace(c) Then
		      If collapse Then
		        chars.RemoveRowAt(i)
		        i = i - 1
		      Else
		        If c <> " "  Then chars(i) = " " // Convert newlines, tabs, etc to spaces.
		        collapse = True
		      End If
		    Else
		      collapse = False
		    End If
		    
		    i = i + 1 
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CreateInlineImageData(imageDescriptionChars() As String, destination As String, title As String, endPos As Integer) As MarkdownKit.InlineImageData
		  // `endPos` is the position in `container.Chars` of the closing ")".
		  // The contents of `imageDescriptionChars` are used as the images's 
		  // `alt` attribute text and need to be parsed as inlines.
		  
		  Dim data As New MarkdownKit.InlineImageData
		  
		  data.EndPos = endPos
		  data.Destination = destination
		  data.LinkTitle = title
		  data.ImageDescriptionChars = imageDescriptionChars
		  
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CreateInlineLinkData(linkTextChars() As String, destination As String, title As String, endPos As Integer) As MarkdownKit.InlineLinkData
		  // `endPos` is the position in `container.Chars` of the closing ")".
		  // The contents of `linkTextChars` are used as the link's text and need to be parsed 
		  // as inlines.
		  
		  Dim data As New MarkdownKit.InlineLinkData
		  
		  data.EndPos = endPos
		  data.Destination = destination
		  data.LinkTitle = title
		  data.LinkTextChars = linkTextChars
		  
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CreateReferenceImageData(ByRef container As MarkdownKit.Block, linkLabel As String, descriptionChars() As String, endPos As Integer) As MarkdownKit.InlineImageData
		  // linkLabelChars is a character array containing a validated link label (excluding the 
		  // flanking "[" and "]"). 
		  // `endPos` is the position in `container.Chars` of the closing "]".
		  // The contents of `descriptionChars` are used as the images's `alt` attrubute 
		  // and need to be parsed as inlines.
		  
		  Dim data As New MarkdownKit.InlineImageData
		  data.EndPos = endPos
		  
		  // Get the reference destination and title from the document's reference map.
		  Dim ref As MarkdownKit.LinkReferenceDefinition = _
		  MarkdownKit.LinkReferenceDefinition(container.Root.ReferenceMap.Value(linkLabel.Lowercase))
		  data.Destination = ref.Destination
		  data.LinkTitle = ref.Title
		  
		  data.ImageDescriptionChars = descriptionChars
		  
		  Return data
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function CreateReferenceLinkData(ByRef container As MarkdownKit.Block, linkLabel As String, linkTextChars() As String, endPos As Integer) As MarkdownKit.InlineLinkData
		  // linkLabelChars is a character array containing a validated link label (excluding the 
		  // flanking "[" and "]"). 
		  // `endPos` is the position in `container.Chars` of the closing "]".
		  // The contents of `linkTextChars` are used as the link's text and need to be parsed 
		  // as inlines.
		  
		  Dim data As New MarkdownKit.InlineLinkData
		  data.EndPos = endPos
		  
		  // Get the reference destination and title from the document's reference map.
		  Dim ref As MarkdownKit.LinkReferenceDefinition = _
		  MarkdownKit.LinkReferenceDefinition(container.Root.ReferenceMap.Value(linkLabel.Lowercase))
		  data.Destination = ref.Destination
		  data.LinkTitle = ref.Title
		  
		  data.LinkTextChars = linkTextChars
		  
		  Return data
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function FullReferenceImageData(ByRef container As markdownKit.Block, chars() As String, charsUbound As Integer, imageDescriptionChars() As String, startPos As Integer) As MarkdownKit.InlineImageData
		  // Returns either an inline image or Nil if a valid full reference image cannot be constructed.
		  // `imageDescriptionChars` are the raw characters representing this images's 
		  // `alt` attribute. They are to be parsed as inlines.
		  // `startPos` points to the index of the "[" immediately after the closing imageDescription "]".
		  // Full reference image: imageDescription, VALID linkLabel
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // We know that `startPos` points to a "[".
		  If startPos + 1 > charsUbound Then Return Nil
		  
		  // Scan for a valid link label.
		  Dim c, linkLabelChars() As String
		  Dim indexOfClosingBracket As Integer = -1
		  For i As Integer = startPos + 1 To charsUbound
		    c = chars(i)
		    If c = "]" And Not Utilities.Escaped(chars, i) Then
		      indexOfClosingBracket = i
		      Exit
		    Else
		      linkLabelChars.AddRow(c)
		    End If
		  Next i
		  If indexOfClosingBracket = -1 Then Return Nil
		  
		  // A valid label must contain at least one non-whitespace character.
		  Dim seenNonWhitespace As Boolean = False
		  Dim linkLabelCharsUbound As Integer = linkLabelChars.LastRowIndex
		  For i As Integer = 0 To linkLabelCharsUbound
		    If Not Utilities.IsWhitespace(linkLabelChars(i)) Then
		      seenNonWhitespace = True
		      Exit
		    End If
		  Next i
		  If Not seenNonWhitespace Then Return Nil
		  
		  // Does the document's reference map contain a reference with the same label?
		  Dim linkLabel As String = Join(linkLabelChars, "")
		  If Not container.Root.ReferenceMap.HasKey(linkLabel.Lowercase) Then Return Nil
		  
		  // Construct this reference image.
		  Return CreateReferenceImageData(container, linkLabel, imageDescriptionChars, indexOfClosingBracket)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function FullReferenceLinkData(ByRef container As markdownKit.Block, chars() As String, charsUbound As Integer, linkTextChars() As String, startPos As Integer) As MarkdownKit.InlineLinkData
		  // Returns either an inline link or Nil if a valid full reference link cannot be constructed.
		  // `linkTextChars` are the raw characters representing this link's text. They are to 
		  // be parsed as inlines.
		  // `startPos` points to the index of the "[" immediately after the closing linkText "]".
		  // Full reference link: linkText, VALID linkLabel
		  // The contents of linkText are parsed as inlines and used as the link's text.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // We know that `startPos` points to a "[".
		  If startPos + 1 > charsUbound Then Return Nil
		  
		  // Scan for a valid link label.
		  Dim c, linkLabelChars() As String
		  Dim indexOfClosingBracket As Integer = -1
		  For i As Integer = startPos + 1 To charsUbound
		    c = chars(i)
		    If c = "]" And Not Utilities.Escaped(chars, i) Then
		      indexOfClosingBracket = i
		      Exit
		    Else
		      linkLabelChars.AddRow(c)
		    End If
		  Next i
		  If indexOfClosingBracket = -1 Then Return Nil
		  
		  // A valid label must contain at least one non-whitespace character.
		  Dim seenNonWhitespace As Boolean = False
		  Dim linkLabelCharsUbound As Integer = linkLabelChars.LastRowIndex
		  For i As Integer = 0 To linkLabelCharsUbound
		    If Not Utilities.IsWhitespace(linkLabelChars(i)) Then
		      seenNonWhitespace = True
		      Exit
		    End If
		  Next i
		  If Not seenNonWhitespace Then Return Nil
		  
		  // Does the document's reference map contain a reference with the same label?
		  Dim linkLabel As Text = Join(linkLabelChars, "").ToText
		  If Not container.Root.ReferenceMap.HasKey(linkLabel.Lowercase) Then Return Nil
		  
		  // Construct this reference link.
		  Return CreateReferenceLinkData(container, linkLabel, linkTextChars, indexOfClosingBracket)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function HandleBackticks(b As MarkdownKit.Block, startPos As Integer, charsUbound As Integer) As MarkdownKit.Block
		  // We know that index `startPos` in `b.RawChars` is a backtick. 
		  // Look to see if it represents the start of a valid inline code span.
		  // If it does then it creates and returns an inline code span. Otherwise 
		  // it returns Nil.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim pos As Integer
		  
		  pos = startPos + 1
		  While pos <= charsUbound
		    If b.Chars(pos) <> "`" Then Exit
		    pos = pos + 1
		  Wend
		  
		  If pos = charsUbound Then Return Nil
		  
		  // `pos` now points to the first character immediately following the opening 
		  // backtick string.
		  Dim contentStartPos As Integer = pos
		  
		  Dim backtickStringLen As Integer = pos - startPos
		  
		  // Find the start position of the closing backtick string (if there is one).
		  Dim closingStartPos As Integer = ScanClosingBacktickString(b, backtickStringLen, _
		  contentStartPos, charsUbound)
		  
		  If closingStartPos = - 1 Then Return Nil
		  
		  // We've found a code span.
		  Dim result As New MarkdownKit.Block(BlockType.Codespan, Xojo.Core.WeakRef.Create(b))
		  result.StartPos = contentStartPos
		  result.EndPos = closingStartPos - 1
		  result.DelimiterLength = backtickStringLen
		  result.Close
		  Return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function HandleLeftAngleBracket(b As MarkdownKit.Block, startPos As Integer, charsUbound As Integer) As MarkdownKit.Block
		  // We know that index `startPos` in `b.RawChars` is a "<".
		  // Look to see if it represents the start of inline HTML.
		  // If it does then it creates and returns an inline HTML block. Otherwise 
		  // it returns Nil.
		  // NB: The EndPos of the returned inline HTML block is the position of the closing ">"
		  
		  // Bare minimum valid HTML tag is: <a>
		  If startPos + 2 > charsUbound Then Return Nil
		  
		  Dim result As MarkdownKit.Block
		  
		  Dim pos As Integer = 0
		  Dim c As String = b.Chars(startPos + 1)
		  
		  Dim tagName As String
		  
		  If c = "/" Then
		    // Closing tag?
		    pos = HTMLScanner.ScanClosingTag(b.Chars, startPos + 2, tagName)
		  ElseIf c = "?" Then
		    // Processing instruction?
		    pos = HTMLScanner.ScanProcessingInstruction(b.Chars, startPos + 2, charsUbound)
		  ElseIf c = "!" Then
		    // Comment, declaration or CDATA section?
		    pos = HTMLScanner.ScanDeclarationCommentOrCData(b.Chars, startPos + 2, charsUbound)
		  Else
		    // Autolink?
		    Dim uri As String
		    pos = ScanAutoLink(b.Chars, startPos + 1, charsUbound, uri)
		    If pos > 0 Then
		      result = New MarkdownKit.Block(BlockType.InlineLink, Xojo.Core.WeakRef.Create(b))
		      result.IsAutoLink = True
		      result.StartPos = startPos
		      result.EndPos = pos - 1
		      result.Title = ""
		      result.Destination = uri
		      result.Label = uri
		      result.Close
		      Return result
		    Else
		      // Email link?
		      pos = ScanEmailLink(b.Chars, startPos + 1, charsUbound, uri)
		      If pos > 0 Then
		        result = New MarkdownKit.Block(BlockType.InlineLink, Xojo.Core.WeakRef.Create(b))
		        result.IsAutoLink = True
		        result.StartPos = startPos
		        result.EndPos = pos - 1
		        result.Title = ""
		        result.Destination = "mailto:" + uri
		        result.Label = uri
		        result.Close
		        Return result
		      Else
		        // Opening tag?
		        pos = HTMLScanner.ScanOpenTag(b.Chars, startPos + 1, tagName, False)
		      End If
		    End If
		  End If
		  
		  If pos = 0 Then
		    Return Nil
		  Else
		    result = New MarkdownKit.Block(BlockType.InlineHTML, Xojo.Core.WeakRef.Create(b))
		    result.StartPos = startPos
		    result.EndPos = pos - 1
		    result.Close
		    Return result
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub Initialise()
		  If mInitialised Then Return
		  
		  InitialiseEmailPartOneDictionary
		  
		  mInitialised = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitialiseEmailPartOneDictionary()
		  mEmailPartOneCharacters = New Dictionary
		  
		  mEmailPartOneCharacters.Value("a") = 0
		  mEmailPartOneCharacters.Value("b") = 0
		  mEmailPartOneCharacters.Value("c") = 0
		  mEmailPartOneCharacters.Value("d") = 0
		  mEmailPartOneCharacters.Value("e") = 0
		  mEmailPartOneCharacters.Value("f") = 0
		  mEmailPartOneCharacters.Value("g") = 0
		  mEmailPartOneCharacters.Value("h") = 0
		  mEmailPartOneCharacters.Value("i") = 0
		  mEmailPartOneCharacters.Value("j") = 0
		  mEmailPartOneCharacters.Value("k") = 0
		  mEmailPartOneCharacters.Value("l") = 0
		  mEmailPartOneCharacters.Value("m") = 0
		  mEmailPartOneCharacters.Value("n") = 0
		  mEmailPartOneCharacters.Value("o") = 0
		  mEmailPartOneCharacters.Value("p") = 0
		  mEmailPartOneCharacters.Value("q") = 0
		  mEmailPartOneCharacters.Value("r") = 0
		  mEmailPartOneCharacters.Value("s") = 0
		  mEmailPartOneCharacters.Value("t") = 0
		  mEmailPartOneCharacters.Value("u") = 0
		  mEmailPartOneCharacters.Value("v") = 0
		  mEmailPartOneCharacters.Value("w") = 0
		  mEmailPartOneCharacters.Value("x") = 0
		  mEmailPartOneCharacters.Value("y") = 0
		  mEmailPartOneCharacters.Value("z") = 0
		  mEmailPartOneCharacters.Value("0") = 0
		  mEmailPartOneCharacters.Value("1") = 0
		  mEmailPartOneCharacters.Value("2") = 0
		  mEmailPartOneCharacters.Value("3") = 0
		  mEmailPartOneCharacters.Value("4") = 0
		  mEmailPartOneCharacters.Value("5") = 0
		  mEmailPartOneCharacters.Value("6") = 0
		  mEmailPartOneCharacters.Value("7") = 0
		  mEmailPartOneCharacters.Value("8") = 0
		  mEmailPartOneCharacters.Value("9") = 0
		  mEmailPartOneCharacters.Value(".") = 0
		  mEmailPartOneCharacters.Value("!") = 0
		  mEmailPartOneCharacters.Value("#") = 0
		  mEmailPartOneCharacters.Value("$") = 0
		  mEmailPartOneCharacters.Value("%") = 0
		  mEmailPartOneCharacters.Value("&") = 0
		  mEmailPartOneCharacters.Value("'") = 0
		  mEmailPartOneCharacters.Value("*") = 0
		  mEmailPartOneCharacters.Value("+") = 0
		  mEmailPartOneCharacters.Value("/") = 0
		  mEmailPartOneCharacters.Value("=") = 0
		  mEmailPartOneCharacters.Value("?") = 0
		  mEmailPartOneCharacters.Value("^") = 0
		  mEmailPartOneCharacters.Value("_") = 0
		  mEmailPartOneCharacters.Value("`") = 0
		  mEmailPartOneCharacters.Value("{") = 0
		  mEmailPartOneCharacters.Value("|") = 0
		  mEmailPartOneCharacters.Value("}") = 0
		  mEmailPartOneCharacters.Value("~") = 0
		  mEmailPartOneCharacters.Value("-") = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function InlineImageData(chars() As String, charsUbound As Integer, imageDescriptionChars() As String, startPos As Integer) As MarkdownKit.InlineImageData
		  // Returns either an inline image or Nil if a valid inline image cannot be constructed.
		  // `imageDescriptionChars` are the raw characters representing this images's 
		  // `alt` attribute. They are to be parsed as inlines.
		  // `startPos` points to the index of the "(" immediately after the closing imageDescription "]".
		  
		  // Inline image: imageDescription, "(", optional whitespace, optional link destination, 
		  //              optional linkTitle, optional whitespace, ")"
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // We know that `startPos` points at the opening "(" so move past it.
		  Dim pos As Integer = startPos + 1
		  
		  If pos > charsUbound Then Return Nil
		  
		  // Advance past any optional whitespace.
		  While pos <= charsUbound And Utilities.IsWhitespace(chars(pos))
		    pos = pos + 1
		  Wend
		  
		  // Optional link destination?
		  Dim destination As String = ScanInlineLinkDestination(chars, charsUbound, pos)
		  Utilities.Unescape(destination)
		  
		  If pos >= charsUbound Then
		    Return CreateInlineImageData(imageDescriptionChars, destination, "", pos)
		  End If
		  
		  Dim seenWhiteSpace As Boolean = False
		  // Advance past any optional whitespace.
		  While pos <= charsUbound And Utilities.IsWhitespace(chars(pos))
		    seenWhiteSpace = True
		    pos = pos + 1
		  Wend
		  
		  // Optional link title?
		  Dim title As String = ScanInlineLinkTitle(chars, charsUbound, pos)
		  Utilities.Unescape(title)
		  
		  // Advance past any optional whitespace.
		  While pos <= charsUbound And Utilities.IsWhitespace(chars(pos))
		    pos = pos + 1
		  Wend
		  
		  // Need to see the closing ")".
		  If pos > charsUbound Then Return Nil
		  If chars(pos) <> ")" Then Return Nil
		  
		  // We've found a valid inline link.
		  Return CreateInlineImageData(imageDescriptionChars, destination, title, pos)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function InlineLinkData(chars() As String, charsUbound As Integer, linkTextChars() As String, startPos As Integer) As MarkdownKit.InlineLinkData
		  // Returns either an inline link or Nil if a valid inline link cannot be constructed.
		  // `linkTextChars` are the raw characters representing this link's text. They are to 
		  // be parsed as inlines.
		  // `startPos` points to the index of the "(" immediately after the closing linkText "]".
		  
		  // Inline link: linkText, "(", optional whitespace, optional link destination, 
		  //              optional linkTitle, optional whitespace, ")"
		  
		  // The contents of linkText are parsed as inlines and used as the link's text.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // We know that `startPos` points at the opening "(" so move past it.
		  Dim pos As Integer = startPos + 1
		  
		  If pos > charsUbound Then Return Nil
		  
		  // Advance past any optional whitespace.
		  While pos <= charsUbound And Utilities.IsWhitespace(chars(pos))
		    pos = pos + 1
		  Wend
		  
		  // Optional link destination?
		  Dim destination As String = ScanInlineLinkDestination(chars, charsUbound, pos)
		  Utilities.Unescape(destination)
		  
		  If pos >= charsUbound Then
		    Return CreateInlineLinkData(linkTextChars, destination, "", pos)
		  End If
		  
		  Dim seenWhiteSpace As Boolean = False
		  // Advance past any optional whitespace.
		  While pos <= charsUbound And Utilities.IsWhitespace(chars(pos))
		    seenWhiteSpace = True
		    pos = pos + 1
		  Wend
		  
		  // Optional link title?
		  Dim title As String = ScanInlineLinkTitle(chars, charsUbound, pos)
		  Utilities.Unescape(title)
		  
		  // Advance past any optional whitespace.
		  While pos <= charsUbound And Utilities.IsWhitespace(chars(pos))
		    pos = pos + 1
		  Wend
		  
		  // Need to see the closing ")".
		  If pos > charsUbound Then Return Nil
		  If chars(pos) <> ")" Then Return Nil
		  
		  // We've found a valid inline link.
		  Return CreateInlineLinkData(linkTextChars, destination, title, pos)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function LookForLinkOrImage(ByRef container As MarkdownKit.Block, ByRef delimiterStack() As MarkdownKit.DelimiterStackNode, ByRef pos As Integer) As Boolean
		  // We have just hit a "]" whilst parsing inlines.
		  // This method returns True if we find a valid inline link or image leading up 
		  // to this "]" or False if we don't.
		  // If a valid link/image is found the a new block is created of the appropriate 
		  // type, inserted into the container and any inlines it containes are handled.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // Starting at the top of the delimiter stack, we look backwards through 
		  // for an opening "[" or "![" delimiter.
		  Dim delimiterStackUbound As Integer = delimiterStack.LastRowIndex
		  Dim dsn As MarkdownKit.DelimiterStackNode
		  Dim linkData As MarkdownKit.InlineLinkData
		  Dim imageData As MarkdownKit.InlineImageData
		  Dim openerIndex, openerPos As Integer
		  Dim link, openerTextNode, image As MarkdownKit.Block
		  Dim limit As Integer
		  For i As Integer = delimiterStackUbound DownTo 0
		    dsn = delimiterStack(i)
		    
		    If dsn.Ignore Then Continue
		    If Not (dsn.Delimiter = "[" Or dsn.Delimiter = "![") Then Continue
		    If Not dsn.Active Then
		      dsn.Ignore = True
		      Return False
		    End If
		    
		    // We know that `dsn` is a potential opener node. Get the position of its
		    // text node.
		    openerPos = MarkdownKit.Block(dsn.TextNodePointer.Value).StartPos
		    
		    If dsn.Delimiter = "[" Then
		      // Parse ahead to see if we have an inline link, reference link, 
		      // compact reference link, or shortcut reference link.
		      linkData = ScanForInlineLinkOfAnyType(container.Chars, openerPos, container, pos)
		      If linkData = Nil Then
		        // Didn't find a valid link. Remove the opening delimiter from the stack.
		        dsn.Ignore = True
		        Return False
		      Else
		        // Create a new link node with the container as its parent.
		        link = New MarkdownKit.Block(BlockType.InlineLink, _ 
		        Xojo.Core.WeakRef.Create(container))
		        link.Title = linkData.LinkTitle
		        link.Destination = linkData.Destination
		        link.Chars = linkData.LinkTextChars
		        
		        // The children of this link are the child blocks of this container 
		        // AFTER the text node pointed to by the opening delimiter.
		        openerTextNode = MarkdownKit.Block(dsn.TextNodePointer.Value)
		        openerIndex = container.Children.IndexOf(openerTextNode)
		        If openerIndex = -1 Then
		          Raise New MarkdownKit.MarkdownException("Could not find the opener text node " + _
		          "in the container's children.")
		        End if
		        limit = container.Children.LastRowIndex
		        For x As Integer = openerIndex + 1 To limit
		          link.Children.AddRow(container.Children(x))
		          link.Children(link.Children.LastRowIndex).Parent = link
		        Next x
		        // For x As Integer = openerIndex + 1 To limit
		        For x As Integer = openerIndex + 1 To limit
		          Call container.Children.Pop
		        Next x
		        
		        // Add this link as the last child of this container.
		        container.Children.AddRow(link)
		        
		        // Process emphasis on the link's children.
		        ProcessEmphasis(link, delimiterStack, i)
		        
		        // Remove the opening delimiter.
		        container.Children.RemoveRowAt(openerIndex)
		        dsn.Ignore = True
		        
		        // Set all "[" delimiters before the opening delimiter to inactive.
		        // This prevents links within links.
		        For x As Integer = 0 to i - 1
		          If delimiterStack(x).Delimiter = "[" Then delimiterStack(x).Active = False
		        Next x
		        
		        // Update the position.
		        pos = linkData.EndPos + 1
		        
		        Return True
		      End If
		      
		    ElseIf dsn.Delimiter = "![" Then
		      // Parse ahead to see if we have an inline image, reference image, 
		      // compact reference image, or shortcut reference image.
		      imageData = ScanForInlineImageOfAnyType(container.Chars, openerPos, container, pos)
		      If imageData = Nil Then
		        // Didn't find a valid image. Remove the opening delimiter from the stack.
		        dsn.Ignore = True
		        Return False
		      Else
		        // Create a new image node with the container as its parent.
		        image = New MarkdownKit.Block(BlockType.InlineImage, _ 
		        Xojo.Core.WeakRef.Create(container))
		        image.Title = imageData.LinkTitle
		        image.Destination = imageData.Destination
		        image.Chars = imageData.ImageDescriptionChars
		        
		        // The children of this image are the child blocks of this container 
		        // AFTER the text node pointed to by the opening delimiter.
		        openerTextNode = MarkdownKit.Block(dsn.TextNodePointer.Value)
		        openerIndex = container.Children.IndexOf(openerTextNode)
		        If openerIndex = -1 Then
		          Raise New MarkdownKit.MarkdownException("Could not find the opener text node " + _
		          "in the container's children.")
		        End if
		        limit = container.Children.LastRowIndex
		        For x As Integer = openerIndex + 1 To limit
		          image.Children.AddRow(container.Children(x))
		          image.Children(image.Children.LastRowIndex).Parent = image
		        Next x
		        For x As Integer = openerIndex + 1 To limit
		          Call container.Children.Pop
		        Next x
		        
		        // Add this image as the last child of this container.
		        container.Children.AddRow(image)
		        
		        // Process emphasis on the image's children.
		        ProcessEmphasis(image, delimiterStack, i)
		        
		        // Remove the opening delimiter.
		        container.Children.RemoveRowAt(openerIndex)
		        dsn.Ignore = True
		        
		        // Update the position.
		        pos = imageData.EndPos + 1
		        
		        Return True
		      End If
		      
		      
		    End If
		  Next i
		  
		  // Didn't find an opener.
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub ParseInlines(b As MarkdownKit.Block, ByRef delimiterStack() As MarkdownKit.DelimiterStackNode)
		  // We know that `b` is an inline container block (i.e: a paragraph, ATX heading or 
		  // setext heading) that has at least one character of content in its `RawChars` array.
		  // This method steps through the raw characters, populating the block's Inlines() array 
		  // with any inline elements it encounters.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim pos As Integer = 0
		  Dim charsUbound As Integer = b.Chars.LastRowIndex
		  Dim c, lastChar As String = ""
		  Dim buffer, result As MarkdownKit.Block
		  Dim dsn As MarkdownKit.DelimiterStackNode
		  
		  While pos <= charsUbound
		    
		    lastChar = c
		    c = b.Chars(pos)
		    
		    If c = "`" And Not Utilities.Escaped(b.Chars, pos) Then
		      // ========= Code spans =========
		      result = HandleBackticks(b, pos, charsUbound)
		      If result <> Nil And lastChar <> "`" Then
		        // Found a code span.
		        If buffer <> Nil Then CloseBuffer(buffer, b)
		        // Add the code span.
		        b.Children.AddRow(result)
		        // Advance the position.
		        pos = result.EndPos + result.DelimiterLength + 1
		      Else
		        If buffer <> Nil Then
		          buffer.EndPos = pos
		        Else
		          buffer = New MarkdownKit.Block(BlockType.InlineText, Xojo.Core.WeakRef.Create(b))
		          buffer.StartPos = pos
		          buffer.EndPos = pos
		        End If
		        pos = pos + 1
		      End If
		      
		    ElseIf c = "<" And Not Utilities.Escaped(b.Chars, pos) Then
		      // ========= Inline HTML =========
		      result = HandleLeftAngleBracket(b, pos, charsUbound)
		      If result <> Nil Then
		        // Found inline HTML.
		        If buffer <> Nil Then CloseBuffer(buffer, b)
		        // Add the inline HTML.
		        b.Children.AddRow(result)
		        // Advance the position.
		        pos = result.EndPos + 1
		      Else
		        If buffer <> Nil Then
		          buffer.EndPos = pos
		        Else
		          buffer = New MarkdownKit.Block(BlockType.InlineText, Xojo.Core.WeakRef.Create(b))
		          buffer.StartPos = pos
		          buffer.EndPos = pos
		        End If
		        pos = pos + 1
		      End If
		      
		    ElseIf c = &u000A Then // Hard or soft break?
		      If pos - 1 >= 0 And b.Chars(pos - 1) = "\" And Not Utilities.Escaped(b.Chars, pos - 1) Then
		        If buffer <> Nil Then
		          buffer.EndPos = buffer.EndPos - 1 // Remove the trailing backslash.
		          CloseBuffer(buffer, b)
		        End If
		        b.Children.AddRow(New MarkdownKit.Block(BlockType.Hardbreak, Xojo.Core.WeakRef.Create(b)))
		        pos = pos + 1
		      ElseIf pos - 2 >= 0 And b.Chars(pos - 2) = &u0020 And b.Chars(pos - 1) = &u0020 Then
		        If buffer <> Nil Then CloseBuffer(buffer, b, True)
		        b.Children.AddRow(New MarkdownKit.Block(BlockType.Hardbreak, Xojo.Core.WeakRef.Create(b)))
		        pos = pos + 1
		      Else
		        If buffer <> Nil Then CloseBuffer(buffer, b, True)
		        b.Children.AddRow(New MarkdownKit.Block(BlockType.Softbreak, Xojo.Core.WeakRef.Create(b)))
		        pos = pos + 1
		      End If
		      
		    ElseIf c = "[" And Not Utilities.Escaped(b.Chars, pos) Then
		      // ========= Start of inline link? =========
		      If buffer <> Nil Then CloseBuffer(buffer, b)
		      buffer = New MarkdownKit.Block(BlockType.InlineText, Xojo.Core.WeakRef.Create(b))
		      buffer.StartPos = pos
		      buffer.EndPos = pos // One character long.
		      dsn = New MarkdownKit.DelimiterStackNode
		      dsn.Delimiter = "["
		      dsn.OriginalLength = 1
		      dsn.TextNodePointer = Xojo.Core.WeakRef.Create(buffer)
		      CloseBuffer(buffer, b)
		      pos = pos + 1
		      delimiterStack.AddRow(dsn)
		      
		    ElseIf c = "!" And Not Utilities.Escaped(b.Chars, pos) And Peek(b.Chars, pos + 1, "[") Then
		      // ========= Start of inline image? =========
		      If buffer <> Nil Then CloseBuffer(buffer, b)
		      buffer = New MarkdownKit.Block(BlockType.InlineText, Xojo.Core.WeakRef.Create(b))
		      buffer.StartPos = pos
		      buffer.EndPos = pos + 1 // Two characters long.
		      dsn = New MarkdownKit.DelimiterStackNode
		      dsn.Delimiter = "!["
		      dsn.OriginalLength = 2
		      dsn.TextNodePointer = Xojo.Core.WeakRef.Create(buffer)
		      CloseBuffer(buffer, b)
		      pos = pos + 2
		      delimiterStack.AddRow(dsn)
		      
		    ElseIf c = "]" And Not Utilities.Escaped(b.Chars, pos) Then
		      // ========= End of inline link or image? =========
		      If buffer <> Nil Then CloseBuffer(buffer, b)
		      If Not LookForLinkOrImage(b, delimiterStack, pos) Then
		        // Add a literal "]" text node.
		        If buffer <> Nil Then
		          buffer.EndPos = pos
		        Else
		          buffer = New MarkdownKit.Block(BlockType.InlineText, Xojo.Core.WeakRef.Create(b))
		          buffer.StartPos = pos
		          buffer.EndPos = pos
		        End If
		        pos = pos + 1
		      End If
		      
		    ElseIf (c = "*" Or c = "_") And Not Utilities.Escaped(b.Chars, pos) Then
		      // ========= Emphasis? =========
		      If buffer <> Nil Then CloseBuffer(buffer, b)
		      dsn = ScanDelimiterRun(b.Chars, charsUbound, pos, c)
		      buffer = New MarkdownKit.Block(BlockType.InlineText, Xojo.Core.WeakRef.Create(b))
		      buffer.StartPos = pos
		      buffer.EndPos = pos + dsn.OriginalLength - 1
		      dsn.TextNodePointer = Xojo.Core.WeakRef.Create(buffer)
		      CloseBuffer(buffer, b)
		      pos = pos + dsn.OriginalLength
		      delimiterStack.AddRow(dsn)
		      
		    Else
		      // This character is not the start of any inline content. If there is an 
		      // open inline text block then append this character to it, otherwise create a 
		      // new open inline text block and append this character to it.
		      If buffer <> Nil Then
		        buffer.EndPos = pos
		      Else
		        buffer = New MarkdownKit.Block(BlockType.InlineText, Xojo.Core.WeakRef.Create(b))
		        buffer.StartPos = pos
		        buffer.EndPos = pos
		      End If
		      pos = pos + 1
		    End If
		  Wend
		  
		  If buffer <> Nil Then CloseBuffer(buffer, b)
		  
		  ProcessEmphasis(b, delimiterStack, -1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub ProcessEmphasis(ByRef container As MarkdownKit.Block, ByRef delimiterStack() As MarkdownKit.DelimiterStackNode, stackBottom As Integer)
		  // `stackBottom` sets a lower bound to how far we descend in the delimiter stack. If it's -1, 
		  // we can go all the way to the bottom. Otherwise, we stop before visiting stackBottom.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  If delimiterStack.LastRowIndex < 0 Then Return
		  
		  // Let currentPosition point to the element on the delimiter stack just above stackBottom 
		  // (or the first element if stackBottom = -1).
		  Dim currentPosition As Integer = If(stackBottom = -1, 0, stackBottom + 1)
		  
		  // Move currentPosition forward in the delimiter stack until we find the first potential 
		  // closer with delimiter * or _. (This will be the potential closer closest to the 
		  // beginning of the input – the first one in parse order).
		  Dim closerNode As MarkdownKit.DelimiterStackNode
		  Dim openerNode As MarkdownKit.DelimiterStackNode
		  
		  Dim incrementCurrentPosition As Boolean = False
		  
		  Dim openerTextNode, closerTextNode, emphasis As MarkdownKit.Block
		  Dim openerTextNodeIndex, closerTextNodeIndex, numToTranspose, limit As Integer
		  
		  While currentPosition <= delimiterStack.LastRowIndex
		    
		    closerNode = delimiterStack(currentPosition)
		    If Not closerNode.Ignore And (closerNode.Delimiter = "*" Or closerNode.Delimiter = "_") And closerNode.CanClose Then
		      // Look back in the stack (staying above stackBottom and the openersBottom for this 
		      // delimiter type) for the first matching potential opener (“matching” means same delimiter).
		      
		      // Prevent an infinite loop...
		      If currentPosition < stackBottom + 2 Then
		        currentPosition = currentPosition + 1
		        Continue
		      End If
		      
		      For i As Integer = currentPosition - 1 DownTo stackBottom + 1
		        openerNode = delimiterStack(i)
		        If Not openerNode.Ignore And openerNode.CanOpen And openerNode.Delimiter = closerNode.Delimiter Then
		          
		          // Can this opener and closer delimiter pair combination open emphasis?
		          If (openerNode.CanClose And openerNode.CanOpen) Or _
		            (closerNode.CanClose And closerNode.CanOpen) Then
		            If (openerNode.OriginalLength + closerNode.OriginalLength) Mod 3 = 0 Then
		              If openerNode.OriginalLength Mod 3 <> 0 Or closerNode.OriginalLength Mod 3 <> 0 Then
		                // If the closer at currentPosition is not a potential opener, remove it from the 
		                // delimiter stack (since we know it can’t be a closer either).
		                If Not closerNode.CanOpen Then closerNode.Ignore = True
		                currentPosition = currentPosition + 1
		                Continue
		              End If
		            End If
		          End If
		          
		          // Strong or regular emphasis? If both closer and opener spans have length >= 2, 
		          // we have strong, otherwise regular.
		          If closerNode.CurrentLength >= 2 And openerNode.CurrentLength >= 2 Then
		            // Strong.
		            emphasis = New MarkdownKit.Block(BlockType.Strong, Xojo.Core.WeakRef.Create(container))
		            emphasis.Delimiter = openerNode.Delimiter
		            emphasis.DelimiterLength = openerNode.CurrentLength
		          Else
		            // Regular. 
		            emphasis = New MarkdownKit.Block(BlockType.Emphasis, Xojo.Core.WeakRef.Create(container))
		            emphasis.Delimiter = openerNode.Delimiter
		            emphasis.DelimiterLength = openerNode.CurrentLength
		          End If
		          // Insert the newly created emphasis node, after the text node corresponding to the opener.
		          // Get the index of the opener text node in the container's `Inlines` array.
		          openerTextNode = MarkdownKit.Block(openerNode.TextNodePointer.Value)
		          openerTextNodeIndex = openerTextNode.Parent.Children.IndexOf(openerTextNode)
		          If openerTextNodeIndex = -1 Then
		            Raise New MarkdownKit.MarkdownException("Cannot locate opening emphasis delimiter run " + _
		            "text node.")
		          End If
		          openerTextNode.Parent.Children.AddRowAt(openerTextNodeIndex + 1, emphasis)
		          
		          // Get the index of the closer text node in the container's `Children` array.
		          closerTextNode = MarkdownKit.Block(closerNode.TextNodePointer.Value)
		          closerTextNodeIndex = closerTextNode.Parent.Children.IndexOf(closerTextNode)
		          If closerTextNodeIndex = -1 Then
		            Raise New MarkdownKit.MarkdownException("Cannot locate closing emphasis delimiter run " + _
		            "text node.")
		          End If
		          
		          // ===========================================================================
		          // Block start offsets.
		          // Compute the character position in the original source code that this block begins at.
		          If MarkdownKit.Document(emphasis.Root).TrackCharacterOffsets Then
		            Select Case openerTextNode.Parent.Type
		            Case MarkdownKit.BlockType.Paragraph
		              emphasis.StartPos = openerTextNode.Parent.OffsetOfLineStart + openerTextNode.StartPos
		              emphasis.EndPos = openerTextNode.Parent.OffsetOfLineStart + closerTextNode.EndPos + 1
		            Case MarkdownKit.BlockType.AtxHeading
		              // Account for the #s and single separating space at the start of the line.
		              emphasis.StartPos = openerTextNode.Parent.OffsetOfLineStart + openerTextNode.StartPos + _
		              openerTextNode.Parent.Level + 1
		              #Pragma Warning "Need to check the +2 offset"
		              emphasis.EndPos = openerTextNode.Parent.OffsetOfLineStart + closerTextNode.EndPos + _
		              openerTextNode.Parent.Level + 2 // ? + 1 or +2 for * vs **
		            End Select
		          End If
		          // ===========================================================================
		          
		          // Need to move all blocks that occur between `openerTextNodeIndex` and `closerTextNodeIndex` 
		          // into this emphasis node's `Children` array and remove them from the container's 
		          // `Inlines` array.
		          For x As Integer = openerTextNodeIndex + 2 To closerTextNodeIndex - 1
		            emphasis.Children.AddRow(container.Children(x))
		            emphasis.Children(emphasis.Children.LastRowIndex).Parent = emphasis
		          Next x
		          
		          // Remove the transposed inlines from the container.
		          numToTranspose = closerTextNodeIndex - openerTextNodeIndex - 2
		          While numToTranspose > 0
		            openerTextNode.Parent.Children.RemoveRowAt(openerTextNodeIndex + 2)
		            numToTranspose = numToTranspose - 1
		          Wend
		          
		          // Remove any delimiters between the opener and closer from the delimiter stack.
		          // We do this by setting their `ignore` flag to True.
		          limit = delimiterStack.IndexOf(closerNode) - 1
		          For j As Integer = i + 1 To limit
		            delimiterStack(j).Ignore = True
		          Next j
		          // Remove 1 (for regular emph) or 2 (for strong emph) delimiters from the opening 
		          // and closing text nodes. 
		          If emphasis.Type = BlockType.Strong Then
		            // Strong.
		            Call MarkdownKit.Block(openerNode.TextNodePointer.Value).Chars.Pop
		            Call MarkdownKit.Block(openerNode.TextNodePointer.Value).Chars.Pop
		            Call MarkdownKit.Block(closerNode.TextNodePointer.Value).Chars.Pop
		            Call MarkdownKit.Block(closerNode.TextNodePointer.Value).Chars.Pop
		          Else
		            // Regular. 
		            Call MarkdownKit.Block(openerNode.TextNodePointer.Value).Chars.Pop
		            Call MarkdownKit.Block(closerNode.TextNodePointer.Value).Chars.Pop
		          End If
		          
		          // If the text node becomes empty as a result, remove it and 
		          // remove the corresponding element of the delimiter stack.
		          openerTextNode = MarkdownKit.Block(openerNode.TextNodePointer.Value)
		          If openerTextNode.Chars.LastRowIndex < 0 Then
		            openerTextNodeIndex = openerTextNode.Parent.Children.IndexOf(openerTextNode)
		            If openerTextNodeIndex = -1 Then
		              Raise New MarkdownKit.MarkdownException("Cannot locate opening emphasis delimiter run " + _
		              "text node.")
		            End If
		            openerTextNode.Parent.Children.RemoveRowAt(openerTextNodeIndex)
		            openerNode.Ignore = True
		          End If
		          
		          closerTextNode = MarkdownKit.Block(closerNode.TextNodePointer.Value)
		          If closerTextNode.Chars.LastRowIndex < 0 Then
		            closerTextNodeIndex = closerTextNode.Parent.Children.IndexOf(closerTextNode)
		            If closerTextNodeIndex = -1 Then
		              Raise New MarkdownKit.MarkdownException("Cannot locate closing emphasis delimiter run " + _
		              "text node.")
		            End If
		            closerTextNode.Parent.Children.RemoveRowAt(closerTextNodeIndex)
		            closerNode.Ignore = True
		          End If
		          
		          Exit
		          
		        Else
		          // If the closer at currentPosition is not a potential opener, remove it from the 
		          // delimiter stack (since we know it can’t be a closer either).
		          If Not closerNode.CanOpen Then closerNode.Ignore = True
		          incrementCurrentPosition = True
		        End If
		      Next i
		    Else
		      currentPosition = currentPosition + 1
		    End If
		    
		    If incrementCurrentPosition Then
		      currentPosition = currentPosition + 1
		      incrementCurrentPosition = False
		    End If
		  Wend
		  
		  // Remove all delimiters above stackBottom from the delimiter stack.
		  For i As Integer = stackBottom + 1 To delimiterStack.LastRowIndex
		    delimiterStack(i).Ignore = True
		  Next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanAutoLink(chars() As String, startPos As Integer, charsUbound As Integer, ByRef uri As String) As Integer
		  // Scan the passed array of characters for a valid autolink.
		  // `pos` points to the character immediately after the opening "<"
		  // Returns the index in `chars` of the character immediately following a 
		  // valid autolink or 0 if no match is found.
		  // Sets the ByRef parameter `uri` to the absolute URI.
		  // Valid autolink:
		  // --------------
		  // "<", absolute URI, ">"
		  // Absolute URI = scheme, :, >=0 characters (not WS, <, >)
		  // Scheme = [A-Za-z]{1}[A-Za-z0-9\+\.\-]{1, 31}
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  uri = ""
		  
		  // Min valid autolink: <aa:>
		  If startPos + 3 > charsUbound Then Return 0
		  
		  // Check for a valid scheme.
		  Dim pos As Integer = ScanLinkScheme(chars, startPos, charsUbound)
		  If pos = 0 Or pos >= charsUbound Then Return 0
		  
		  // Check for a colon.
		  If chars(pos) <> ":" Then Return 0
		  pos = pos +1
		  
		  // Skip over any characters that aren't whitespace, "<" or ">"
		  If pos >= charsUbound Then Return 0
		  Dim c As String
		  Dim limit As Integer
		  For pos = pos To charsUbound
		    c = chars(pos)
		    If c = ">" Then
		      // Valid autolink. Construct the URI.
		      limit = pos - 1
		      Dim tmp() As String
		      For i As Integer = startPos To limit
		        tmp.AddRow(chars(i))
		      Next i
		      uri = Join(tmp, "")
		      Return pos + 1
		    End If
		    If MarkdownKit.Utilities.IsWhitespace(c) Then Return 0
		    If c = "<" Then Return 0
		  Next pos
		  
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanClosingBacktickString(b As MarkdownKit.Block, backtickStringLen As Integer, startPos As Integer, charsUbound As Integer) As Integer
		  // Beginning at `startPos` in `b.RawChars`, scan for a closing code span backtick string 
		  // of `backtickStringLen` characters. If found, return the position of the backtick 
		  // which forms the beginning of the closing backtick string. Otherwise return -1.
		  // Assumes `startPos` points at the character immediately following the last backtick of the 
		  // opening backtick string.
		  
		  #If Not TargetWeb
		    #Pragma DisableBackgroundTasks
		  #Endif
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  If startPos + backtickStringLen > charsUbound Then Return -1
		  
		  Dim contiguousBackticks As Integer = 0
		  Dim closingBacktickStringStartPos As Integer = -1
		  For i As Integer = startPos To charsUbound
		    If b.Chars(i) = "`" Then
		      If contiguousBackticks = 0 Then
		        // Might be the beginning of the closing sequence.
		        closingBacktickStringStartPos = i
		        contiguousBackticks = contiguousBackticks + 1
		        If backtickStringLen = 1 Then
		          // We may have found the closer. Check the next character isn't a backtick.
		          If i + 1 > charsUbound Or b.Chars(i + 1) <> "`" Then
		            // Success!
		            Return closingBacktickStringStartPos
		          End If
		        End If
		      Else
		        // We already have a potential closing sequence.
		        contiguousBackticks = contiguousBackticks + 1
		        If contiguousBackticks = backtickStringLen Then
		          // We may have found the closer. Check the next character isn't a backtick.
		          If i + 1 > charsUbound Or b.Chars(i + 1) <> "`" Then
		            // Success!
		            Return closingBacktickStringStartPos
		          End If
		        End If
		      End If
		    Else
		      contiguousBackticks = 0
		      closingBacktickStringStartPos = -1
		    End If
		  Next i
		  
		  If contiguousBackticks = backtickStringLen Then
		    Return closingBacktickStringStartPos
		  Else
		    Return -1
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanDelimiterRun(chars() As String, charsUbound As Integer, pos As Integer, delimiter As String) As MarkdownKit.DelimiterStackNode
		  // Scan the passed array of characters for a run of emphasis.
		  // `pos` points to the begining of the emphasis run.
		  // `delimiter` is either "*" or "_".
		  // Returns a DelimiterStackElement which contains information about the 
		  // delimiter type, delimiter length and whether it's a potential opener, closer 
		  // or both.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim startPos As integer = pos
		  
		  Dim dsn As New MarkdownKit.DelimiterStackNode
		  dsn.Delimiter = delimiter
		  dsn.Active = True
		  
		  dsn.OriginalLength = 1
		  For pos = pos + 1 To charsUbound
		    If chars(pos) = delimiter Then
		      dsn.OriginalLength = dsn.OriginalLength + 1
		    Else
		      Exit
		    End If
		  Next pos
		  
		  // `pos` currently points at the character following the end of the run.
		  Dim beforeIsWhitespace As Boolean
		  If startPos = 0 Then
		    beforeIsWhitespace = True
		  Else
		    beforeIsWhitespace = If(Utilities.IsWhitespace(chars(startPos - 1 ), True), True, False)
		  End If
		  
		  Dim afterIsWhitespace As Boolean
		  If pos >= charsUbound Then
		    afterIsWhitespace = True
		  Else
		    afterIsWhitespace = If(Utilities.IsWhitespace(chars(pos), True), True, False)
		  End If
		  
		  Dim beforeIsPunctuation As Boolean = If(startPos = 0 Or Not Utilities.IsPunctuation(chars(startPos - 1)), False, True)
		  Dim afterIsPunctuation As Boolean = If(pos >= charsUbound Or Not Utilities.IsPunctuation(chars(pos)), False, True)
		  
		  // Left flanking?
		  Dim leftFlanking As Boolean = Not afterIsWhitespace And _
		  (Not afterIsPunctuation Or (afterIsPunctuation And (beforeIsWhitespace Or beforeIsPunctuation)))
		  
		  // Right flanking?
		  Dim rightFlanking As Boolean = Not beforeIsWhitespace And _
		  (Not beforeIsPunctuation Or (beforeIsPunctuation And (afterIsWhitespace Or afterIsPunctuation)))
		  
		  // Opener?
		  If delimiter = "*" Then
		    dsn.CanOpen = leftFlanking
		  Else // _
		    dsn.CanOpen = leftFlanking And (Not rightFlanking Or (rightFlanking And beforeIsPunctuation))
		  End If
		  
		  // Closer?
		  If delimiter = "*" Then
		    dsn.CanClose = rightFlanking
		  Else // _
		    dsn.CanClose = rightFlanking And (Not leftFlanking Or (leftFlanking And afterIsPunctuation))
		  End If
		  
		  Return dsn
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanEmailLink(chars() As String, startPos As Integer, charsUbound As Integer, ByRef uri As String) As Integer
		  // Scan the passed array of characters for a valid email autolink.
		  // `pos` points to the character immediately after the opening "<"
		  // Returns the index in `chars` of the character immediately following a 
		  // valid email autolink or 0 if no match is found.
		  // Sets the ByRef parameter `uri` to the absolute URI.
		  // Valid email autolink:
		  // --------------------
		  // "<", email address, ">"
		  // Email address:
		  '      [a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?
		  '      (?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*
		  // name@
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  uri = ""
		  
		  Dim pos As Integer = startPos
		  
		  // Match between 1 and unlimited times, as many times as possible, a character 
		  // in the set: a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-
		  Dim c As String
		  Dim done As Boolean = False
		  While pos < charsUbound
		    If Not mEmailPartOneCharacters.HasKey(chars(pos)) Then
		      Exit
		    Else
		      done = True
		    End If
		    pos = pos + 1
		  Wend
		  If Not done Then Return 0
		  
		  If chars(pos) <> "@" Then Return 0
		  pos = pos + 1
		  
		  // [a-zA-Z0-9]
		  If pos > charsUbound Then Return 0
		  c = chars(pos)
		  If Not Utilities.IsASCIIAlphaChar(c) And Not Utilities.IsDigit(c) Then Return 0
		  pos = pos + 1
		  
		  If pos > charsUbound Then Return 0
		  
		  // Is there a dot next?
		  c = chars(pos)
		  Dim hadDot As Boolean = If(c = ".", True, False)
		  Dim dotPosition As Integer = If(hadDot, pos, -1)
		  
		  Dim count As Integer
		  If Not hadDot Then
		    // Match zero or one times: [a-zA-Z0-9-]{0,61}[a-zA-Z0-9]
		    count = HTMLScanner.MatchASCIILetterOrDigitOrHyphen(chars, charsUbound, pos, 62)
		    pos = pos + count
		    // Need a dot.
		    If pos > charsUbound Then Return 0
		    If chars(pos) <> "." Then Return 0
		    dotPosition = pos
		    pos = pos + 1
		  End If
		  
		  pos = dotPosition
		  
		  
		  Dim valid As Boolean = False
		  Dim limit As Integer
		  Dim tmp() As String
		  Do
		    // Have we found a valid email?
		    If chars(pos) = ">" Then
		      If Valid Then
		        // Construct the URI.
		        limit = pos - 1
		        Redim tmp(-1)
		        For i As Integer = startPos To limit
		          tmp.AddRow(chars(i))
		        Next i
		        uri = Join(tmp, "")
		        Return pos + 1
		      Else
		        Return 0
		      End If
		    End If
		    
		    // Match dot.
		    If chars(pos) <> "." Then Return 0
		    pos = pos + 1
		    
		    // Match once: [a-zA-Z0-9]
		    If pos > charsUbound Then Return 0
		    c = chars(pos)
		    If Not Utilities.IsASCIIAlphaChar(c) And Not Utilities.IsDigit(c) Then Return 0
		    pos = pos + 1
		    If pos > charsUbound Then Return 0
		    
		    // Match zero or one times: [a-zA-Z0-9-]{0,61}[a-zA-Z0-9]
		    count = HTMLScanner.MatchASCIILetterOrDigitOrHyphen(chars, charsUbound, pos, 62)
		    pos = pos + count
		    If pos > charsUbound Then Return 0
		    valid = True
		  Loop
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanForInlineImageOfAnyType(chars() As String, startPos As Integer, ByRef container As MarkdownKit.Block, closerCharPos As Integer) As MarkdownKit.InlineImageData
		  // Scans through the passed array of characters for a valid inline image.
		  // Assumes `startPos` points to the beginning "!".
		  // Returns Nil if no valid image is found, otherwise creates and returns a new 
		  // inline image block with the passed container as its parent.
		  // `closerCharPos` is the index in chars() of the closing "]" character.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim pos As Integer = startPos
		  Dim charsUbound As Integer = chars.LastRowIndex
		  
		  // Skip past the opening "![".
		  pos = pos + 2
		  If pos > charsUbound Then Return Nil
		  
		  // Valid images start with either an imageDescription or a linkLabel.
		  // linkLabels are not allowed to contain unescaped brackets and 
		  // must contain at least one non-whitespace character.
		  Dim part1RawChars() As String
		  Dim indexOfLastClosingSquareBracket As Integer = -1
		  Dim openSquareBracketCount As Integer = 1
		  Dim closeSquareBracketCount As Integer = 0
		  Dim hasUnescapedBracket As Boolean = False
		  Dim c As String
		  For i As Integer = 0 To closerCharPos
		    c = chars(i)
		    If c = "]" And Not Utilities.Escaped(chars, i) Then
		      hasUnescapedBracket = True
		      indexOfLastClosingSquareBracket = i
		      closeSquareBracketCount = closeSquareBracketCount + 1
		    ElseIf c = "[" And Not Utilities.Escaped(chars, i) Then
		      hasUnescapedBracket = True
		      openSquareBracketCount = openSquareBracketCount + 1
		    ElseIf i > startPos + 1 Then // Only add characters occurring after the start position.
		      part1RawChars.AddRow(c)
		    End If
		  Next i
		  
		  If indexOfLastClosingSquareBracket = -1 Then Return Nil
		  If Not hasUnescapedBracket And openSquareBracketCount <> closeSquareBracketCount Then Return Nil
		  
		  // Remove characters from `part1RawChars` from the closing "]" onwards.
		  Dim charsToRemove As Integer = closerCharPos - indexOfLastClosingSquareBracket
		  For i As Integer = 1 To charsToRemove
		    Call part1RawChars.Pop
		  Next i
		  
		  // Is part1 a valid linkLabel?
		  Dim validLinkLabel As Boolean = False
		  If part1RawChars.LastRowIndex > -1 Then
		    If container.Root.ReferenceMap.HasKey(Join(part1RawChars, "")) Then
		      validLinkLabel = True
		    End If
		  End If
		  
		  // Move past the closing part1 square bracket.
		  pos = indexOfLastClosingSquareBracket + 1
		  
		  // Shortcut reference image?
		  If validLinkLabel And Not Peek(chars, pos, "(") Then
		    If pos >= charsUbound Or pos + 1 > charsUbound Then
		      // Found a shortcut reference image.
		      Return CreateReferenceImageData(container, Join(part1RawChars, ""), part1RawChars, pos - 1)
		    ElseIf chars(pos) <> "[" And chars(pos + 1) <> "]" Then
		      // Found a shortcut reference link.
		      Return CreateReferenceImageData(container, Join(part1RawChars, ""), part1RawChars, pos - 1)
		    End If
		  End If
		  
		  // Collapsed reference image?
		  If validLinkLabel Then
		    If pos + 1 <= charsUbound And chars(pos) = "[" And chars(pos + 1) = "]" Then
		      // Found a collapsed reference image.
		      Return CreateReferenceImageData(container, Join(part1RawChars, ""), part1RawChars, pos + 1)
		    End If
		  End If
		  
		  // At this point, we know that part1 must represent an imageDescription rather than a linkLabel.
		  If pos > charsUbound Then Return Nil
		  If chars(pos) = "(" Then
		    // Could be an inline image.
		    Dim result As MarkdownKit.InlineImageData = _
		    InlineImageData(chars, charsUbound, part1RawChars, pos)
		    If result = Nil And validLinkLabel Then
		      // Edge case: Could still be a shortcut reference image immediately followed by a "(".
		      Return CreateReferenceImageData(container, Join(part1RawChars, ""), part1RawChars, pos - 1)
		    Else
		      Return result
		    End If
		  ElseIf chars(pos) = "[" Then
		    // Could be a full reference image.
		    Return FullReferenceImageData(container, chars, charsUbound, part1RawChars, pos)
		  Else
		    Return Nil
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanForInlineLinkOfAnyType(chars() As String, startPos As Integer, ByRef container As MarkdownKit.Block, closerCharPos As Integer) As MarkdownKit.InlineLinkData
		  // Scans through the passed array of characters for a valid inline link.
		  // Assumes `startPos` points to the beginning "[".
		  // Returns Nil if no valid link is found, otherwise creates and returns a new 
		  // inline link block with the passed container as its parent.
		  // `closerCharPos` is the index in chars() of the closing "]" character.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim pos As Integer = startPos
		  Dim charsUbound As Integer = chars.LastRowIndex
		  
		  // Skip past the opening "[".
		  pos = pos + 1
		  If pos > charsUbound Then Return Nil
		  
		  // Valid links start with either linkText or a linkLabel.
		  // linkLabels are not allowed to contain unescaped brackets and 
		  // must contain at least one non-whitespace character.
		  
		  Dim part1RawChars() As String
		  Dim indexOfLastClosingSquareBracket As Integer = -1
		  Dim openSquareBracketCount As Integer = 1
		  Dim closeSquareBracketCount As Integer = 0
		  Dim hasUnescapedBracket As Boolean = False
		  Dim c As String
		  For i As Integer = 0 To closerCharPos
		    c = chars(i)
		    If c = "]" And Not Utilities.Escaped(chars, i) Then
		      hasUnescapedBracket = True
		      indexOfLastClosingSquareBracket = i
		      closeSquareBracketCount = closeSquareBracketCount + 1
		    ElseIf c = "[" And Not Utilities.Escaped(chars, i) Then
		      hasUnescapedBracket = True
		      openSquareBracketCount = openSquareBracketCount + 1
		    ElseIf i > startPos Then // Only add characters occurring after the start position.
		      part1RawChars.AddRow(c)
		    End If
		  Next i
		  
		  If indexOfLastClosingSquareBracket = -1 Then Return Nil
		  If Not hasUnescapedBracket And openSquareBracketCount <> closeSquareBracketCount Then Return Nil
		  
		  // Remove characters from `part1RawChars` from the closing "]" onwards.
		  Dim charsToRemove As Integer = closerCharPos - indexOfLastClosingSquareBracket
		  For i As Integer = 1 To charsToRemove
		    Call part1RawChars.Pop
		  Next i
		  
		  // Is part1 a valid linkLabel?
		  Dim linkLabelAsText As Text // Must be text to permit case-sensitive lookups.
		  Dim validLinkLabel As Boolean = False
		  If part1RawChars.LastRowIndex > -1 Then
		    linkLabelAsText = Join(part1RawChars, "").ToText
		    If container.Root.ReferenceMap.HasKey(linkLabelAsText.Lowercase) Then
		      validLinkLabel = True
		    End If
		  End If
		  
		  // Move past the closing part1 square bracket.
		  pos = indexOfLastClosingSquareBracket + 1
		  
		  // Shortcut reference link?
		  If validLinkLabel And Not Peek(chars, pos, "(") Then
		    If pos >= charsUbound Or pos + 1 > charsUbound Then
		      // Found a shortcut reference link.
		      Return CreateReferenceLinkData(container, linkLabelAsText, part1RawChars, pos - 1)
		    ElseIf chars(pos) <> "[" And chars(pos + 1) <> "]" Then
		      // Found a shortcut reference link.
		      Return CreateReferenceLinkData(container, linkLabelAsText, part1RawChars, pos - 1)
		    End If
		  End If
		  
		  // Collapsed reference link?
		  If validLinkLabel Then
		    If pos + 1 <= charsUbound And chars(pos) = "[" And chars(pos + 1) = "]" Then
		      // Found a collapsed reference link.
		      Return CreateReferenceLinkData(container,linkLabelAsText, part1RawChars, pos + 1)
		    End If
		  End If
		  
		  // At this point, we know that part1 must represent linkText rather than a linkLabel.
		  If pos > charsUbound Then Return Nil
		  If chars(pos) = "(" Then
		    // Could be an inline link.
		    Dim result As MarkdownKit.InlineLinkData = _
		    InlineLinkData(chars, charsUbound, part1RawChars, pos)
		    If result = Nil And validLinkLabel Then
		      // Edge case: Could still be a shortcut reference link immediately followed by a "(".
		      Return CreateReferenceLinkData(container, linkLabelAsText, part1RawChars, pos - 1)
		    Else
		      Return result
		    End If
		  ElseIf chars(pos) = "[" Then
		    // Could be a full reference link.
		    Return FullReferenceLinkData(container, chars, charsUbound, part1RawChars, pos)
		  Else
		    Return Nil
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanInlineLinkDestination(chars() As String, charsUbound As Integer, ByRef pos As Integer) As String
		  // Scans the passed array of characters for a valid link URL.
		  // Begins at the zero-based `pos` (passed by reference).
		  // Returns the URL or "".
		  // If the URL is flanked by <> (scenario 1) they are removed from the URL before returning.
		  
		  // Two kinds of link destinations:
		  // 1. A sequence of zero or more characters between an opening < and a closing > 
		  //    that contains no line breaks or unescaped < or > characters.
		  // 2. A non-empty sequence of characters that does not start with <, does not 
		  //    include ASCII space or control characters, and includes parentheses only 
		  //    if (a) they are backslash-escaped or (b) they are part of a balanced pair 
		  //    of unescaped parentheses.
		  
		  // Since we are looking for an inline link destination, we may encounter either a 
		  // closing ")" (representing the end of the inline link definition without providing 
		  // a title) or whitespace followed by the " character (indicating a trailing title).
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim i As Integer
		  Dim c As String
		  
		  Dim startPos As Integer = pos
		  
		  // Sanity check.
		  If pos > charsUbound Then Return ""
		  
		  // Scenario 1:
		  If chars(pos) = "<" Then
		    i = pos + 1
		    While i <= charsUbound
		      c = chars(i)
		      If c = ">" And Not Utilities.Escaped(chars, i) Then
		        pos = i + 1
		        Return chars.ToString(startPos + 1, i - startPos - 1)
		      End If
		      If c = "<" And Not Utilities.Escaped(chars, i) Then Return ""
		      If c = &u000A Then Return ""
		      i = i + 1
		    Wend
		    Return ""
		  End If
		  
		  // Scenario 2:
		  Dim unmatchedOpenParens As Integer = 1 // Account for the opening parens we've already seen.
		  For i = startPos To charsUbound
		    c = chars(i)
		    Select Case c
		    Case "("
		      If Utilities.Escaped(chars, i) Then Continue
		      unmatchedOpenParens = unmatchedOpenParens + 1
		    Case ")"
		      If Utilities.Escaped(chars, i) Then Continue
		      unmatchedOpenParens = unmatchedOpenParens - 1
		      If i = charsUbound Or chars(i + 1) = &u000A Then
		        If unmatchedOpenParens = 0 Then
		          pos = i
		          Dim destination As String = chars.ToString(startPos, i - startPos)
		          Return Utilities.ReplaceEntities(destination)
		        Else
		          Return ""
		        End If
		      End If
		      If unmatchedOpenParens = 0 Then
		        pos = i
		        Dim destination As String = chars.ToString(startPos, i - startPos)
		        Return Utilities.ReplaceEntities(destination)
		      End If
		    Case &u0000, &u0009
		      Return ""
		    Case &u000A
		      pos = i
		      Return chars.ToString(startPos, i - startPos)
		    Case " "
		      If unmatchedOpenParens = 1 Then
		        pos = i
		        Dim destination As String = chars.ToString(startPos, i - startPos)
		        Return Utilities.ReplaceEntities(destination)
		      Else
		        Return ""
		      End If
		    End Select
		  Next i
		  
		  If unmatchedOpenParens = 0 Then
		    pos = i
		    Dim destination As String = chars.ToString(startPos, pos - startPos)
		    Return Utilities.ReplaceEntities(destination)
		  Else
		    Return ""
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanInlineLinkTitle(chars() As String, charsUbound As Integer, ByRef pos As Integer) As String
		  // Scans the passed array of characters for a valid link title.
		  // Begins at the zero-based `pos` (passed by reference).
		  // Returns the title or "".
		  
		  // There are 3 valid types of link title:
		  // 1. >= 0 characters between straight " characters including a " character 
		  //    only if it is backslash-escaped.
		  // 2. >= 0 characters between ' characters, including a ' character only if 
		  //    it is backslash-escaped
		  // 3. >= 0 characters between matching parentheses ((...)), 
		  //    including a ( or ) character only if it is backslash-escaped.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim startPos As Integer = pos
		  
		  // Sanity check.
		  If startPos > charsUbound Or (startPos + 1) > charsUbound Then
		    Return ""
		  End If
		  
		  Dim c As String = chars(pos)
		  
		  Dim delimiter As String
		  Select Case c
		  Case """", "'"
		    delimiter = c
		  Case "("
		    delimiter = ")"
		  End Select
		  
		  For i As Integer = pos + 1 To charsUbound
		    c = chars(i)
		    If c = delimiter And Not Utilities.Escaped(chars, i) Then
		      pos = i + 1
		      Dim title As String = chars.ToString(startPos + 1, i - startPos - 1)
		      Return Utilities.ReplaceEntities(title)
		    End If
		  Next i
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanLinkDestination(chars() As String, startPos As Integer, isReferenceLink As Boolean) As MarkdownKit.CharacterRun
		  // Scans the passed array of characters for a valid link URL.
		  // Begins at the zero-based `startPos`.
		  // Returns a CharacterRun representing the url.
		  // The returned CharacterRun.Length will be -1 if no valid URL is found.
		  
		  // Two kinds of link destinations:
		  // 1. A sequence of zero or more characters between an opening < and a closing > 
		  //    that contains no line breaks or unescaped < or > characters.
		  // 2. A non-empty sequence of characters that does not start with <, does not 
		  //    include ASCII space or control characters, and includes parentheses only 
		  //    if (a) they are backslash-escaped or (b) they are part of a balanced pair 
		  //    of unescaped parentheses.
		  
		  // NB: If isReferenceLink is True then we are scanning for a reference link 
		  // destination. In this case, we regard a newline character as marking the 
		  // end of the line (whereas inline link destinations cannot contain a newline).
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim charsUbound As Integer = chars.LastRowIndex
		  Dim i As Integer
		  Dim c As String
		  
		  Dim result As New MarkdownKit.CharacterRun(startPos, -1, -1)
		  
		  // Sanity check.
		  If startPos > charsUbound Then Return result
		  
		  // Scenario 1:
		  If chars(startPos) = "<" Then
		    i = startPos + 1
		    While i <= charsUbound
		      c = chars(i)
		      If c = ">" And Not Utilities.Escaped(chars, i) Then
		        result.Length = i - startPos + 1
		        result.Finish = i
		        Return result
		      End If
		      If c = "<" And Not Utilities.Escaped(chars, i) Then Return result
		      If c = &u000A Then Return result
		      i = i + 1
		    Wend
		    Return result
		  End If
		  
		  // Scenario 2:
		  Dim openParensCount, closeParensCount As Integer = 0
		  For i = startPos To charsUbound
		    c = chars(i)
		    Select Case c
		    Case "("
		      If Not Utilities.Escaped(chars, i) Then openParensCount = openParensCount + 1
		    Case ")"
		      If Not Utilities.Escaped(chars, i) Then closeParensCount = closeParensCount + 1
		    Case &u0000, &u0009
		      Return result
		    Case &u000A
		      If isReferenceLink Then
		        If openParensCount <> closeParensCount Then
		          Return result
		        Else
		          result.Length = i - startPos
		          result.Finish = i - 1
		          Return result
		        End If
		      Else
		        Return result
		      End If
		    Case " "
		      If openParensCount <> closeParensCount Then
		        Return result
		      Else
		        result.Length = i - startPos
		        result.Finish = i
		        Return result
		      End If
		    End Select
		  Next i
		  
		  If openParensCount <> closeParensCount Then
		    Return result
		  Else
		    result.Length = charsUbound - startPos + 1
		    result.Finish = charsUbound
		    Return result
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanLinkLabelDefinition(chars() As String, pos As Integer) As MarkdownKit.CharacterRun
		  // Scans the contents of `chars` for a link reference definition label.
		  // Assumes chars(pos) = "[".
		  // Assumes `chars.LastRowIndex` >=3.
		  // Returns a CharacterRun. If no valid label is found then the CharacterRun's
		  // `start` and `finish` properties will be set to -1.
		  // Does NOT mutate the passed array.
		  
		  // Note the precedence: code backticks have precedence over label bracket
		  // markers, which have precedence over *, _, and other inline formatting
		  // markers. So, (2) below contains a link whilst (1) does not:
		  // (1) [a link `with a ](/url)` character
		  // (2) [a link *with emphasized ](/url) text*
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim result As New MarkdownKit.CharacterRun(0, -1, -1)
		  
		  Dim charsUbound As Integer = chars.LastRowIndex
		  
		  If charsUbound > kMaxReferenceLabelLength + 1 Then Return result
		  
		  // Find the first "]" that is not backslash-escaped.
		  Dim limit As Integer = Xojo.Math.Min(charsUbound, kMaxReferenceLabelLength + 1)
		  Dim i As Integer
		  Dim seenNonWhitespace As Boolean = False
		  For i = (pos + 1) To limit
		    Select Case chars(i)
		    Case "["
		      // Unescaped square brackets are not allowed.
		      If Not Utilities.Escaped(chars, i) Then Return result
		      seenNonWhitespace = True
		    Case "]"
		      If Utilities.Escaped(chars, i) Then
		        seenNonWhitespace = True
		        Continue
		      ElseIf seenNonWhitespace Then
		        // This is the end of a valid label.
		        result.Length = i + 1
		        result.Finish = i
		        Return result
		      Else // No non-whitespace characters in this label.
		        Return result
		      End If
		    Else
		      // A valid label needs at least one non-whitespace character.
		      If Not seenNonWhitespace Then seenNonWhitespace = Not Utilities.IsWhitespace(chars(i))
		    End Select
		  Next i
		  
		  // No valid label found.
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanLinkScheme(chars() As String, pos As Integer, charsUbound As Integer) As Integer
		  // Scans the passed character array for a valid inline link scheme.
		  // Returns the position of the character immediately following the scheme if 
		  // found, otherwise returns 0.
		  // Valid scheme = [A-Za-z]{1}[A-Za-z0-9\+\.\-]{1, 31}
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // Min valid scheme: aa
		  If pos + 1 > charsUbound Then Return 0
		  
		  If Not Utilities.IsASCIIAlphaChar(chars(pos)) Then Return 0
		  
		  Dim c As String = chars(pos + 1)
		  If Not Utilities.IsASCIIAlphaChar(c) And Not Utilities.IsDigit(c) And _
		    c <> "+" And c<> "." And c <> "-" Then
		    Return 0
		  End If
		  
		  pos = pos + 2
		  
		  // Up to 30 more ASCII letters, digits, +, . or -
		  Dim count As Integer = 1
		  
		  While pos <= charsUbound And count <= 30
		    c = chars(pos)
		    
		    If Not Utilities.IsASCIIAlphaChar(c) And Not Utilities.IsDigit(c) And _
		      c <> "+" And c <> "." And c <> "-" Then
		      Return pos
		    End If
		    
		    pos = pos + 1
		    count = count + 1
		  Wend
		  
		  Return pos
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanLinkTitle(chars() As String, startPos As Integer) As MarkdownKit.CharacterRun
		  // Scans the passed array of characters beginning at `startPos` for a valid 
		  // link title.
		  // Returns a CharacterRun containing the start index and length of the title 
		  // if one is found. Otherwise it returns an empty character with a length of -1.
		  
		  // There are 3 valid types of link title:
		  // 1. >= 0 characters between straight " characters including a " character 
		  //    only if it is backslash-escaped.
		  // 2. >= 0 characters between ' characters, including a ' character only if 
		  //    it is backslash-escaped
		  // 3. >= 0 characters between matching parentheses ((...)), 
		  //    including a ( or ) character only if it is backslash-escaped.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim result As New MarkdownKit.CharacterRun(startPos, -1, -1)
		  result.Invalid = True
		  
		  Dim charsUbound As Integer = chars.LastRowIndex
		  
		  // Sanity check.
		  If startPos < 0 Or startPos > charsUbound Or _
		    (startPos + 1) > charsUbound Then
		    Return result
		  End If
		  
		  Dim c As String = chars(startPos)
		  
		  Dim delimiter As String
		  Select Case c
		  Case """", "'"
		    delimiter = c
		  Case "("
		    delimiter = ")"
		  Else
		    If startPos > 0 And chars(startPos - 1) = &u000A Then result.Invalid = False
		    Return result
		  End Select
		  
		  For i As Integer = startPos + 1 To charsUbound
		    c = chars(i)
		    If c = delimiter And Not Utilities.Escaped(chars, i) Then
		      result.Length = i - startPos + 1
		      result.Finish = i
		      result.Invalid = False
		      Return result
		    End If
		  Next i
		  
		  Return result
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		#tag Note
			Stores the characters that are valid for the first part of an email autolink:
			a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-
		#tag EndNote
		Private Shared mEmailPartOneCharacters As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mInitialised As Boolean = False
	#tag EndProperty


	#tag Constant, Name = kMaxReferenceLabelLength, Type = Double, Dynamic = False, Default = \"999", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
