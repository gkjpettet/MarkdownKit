#tag Class
Protected Class InlineScanner
	#tag Method, Flags = &h0
		Shared Sub CleanLinkLabel(chars() As Text)
		  // Cleans up a label parsed by ScanLinkLabel by removing the flanking [].
		  // Mutates the passed array.
		  
		  chars.Remove(0)
		  Call chars.Pop
		  
		  CollapseInternalWhitespace(chars)
		  StripLeadingWhitespace(chars)
		  StripTrailingWhitespace(chars)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub CleanLinkTitle(chars() As Text)
		  // Takes an array of characters representing a link title that has been parsed by ScanLinkTitle().
		  // Removes surrounding delimiters, handles backslash-escaped characters and replaces character references.
		  // NB: Does NOT unescape special characters.
		  // Mutates the passed array.
		  
		  // Remove the flanking delimiters.
		  chars.Remove(0)
		  Call chars.Pop
		  
		  Unescape(chars)
		  ReplaceCharacterReferences(chars)
		  
		  // Remove leading whitespace from the title.
		  StripLeadingWhitespace(chars)
		  
		  // Remove a trailing newline from the title if present
		  If chars.Ubound > -1 And chars(chars.Ubound) = &u000A Then Call chars.Pop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub CleanURL(chars() As Text)
		  // Takes an array of characters representing a URL that has been parsed by ScanLinkURL().
		  // Removes surrounding whitespace, surrounding "<" and ">", handles backslash-escaped 
		  // characters and replaces character references.
		  // Mutates the passed array.
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  If charsUbound = -1 Then Return
		  
		  // Remove flanking whitespace.
		  StripLeadingWhitespace(chars)
		  StripTrailingWhitespace(chars)
		  
		  // If the URL has flanking < and > characters, remove them.
		  If charsUbound >= 1 And chars(0) = "<" And chars(charsUbound) = ">" Then
		    chars.Remove(0)
		    Call chars.Pop
		  End If
		  
		  Unescape(chars)
		  ReplaceCharacterReferences(chars)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub CloseBuffer(ByRef buffer As MarkdownKit.Inline, container As MarkdownKit.InlineContainerBlock, stripTrailingWhitespace As Boolean = False)
		  // There's an open preceding text inline. Close it.
		  buffer.Close
		  
		  If stripTrailingWhitespace Then MarkdownKit.StripTrailingWhitespace(buffer.Chars)
		  
		  // Add the buffer to the container block before the code span.
		  container.Inlines.Append(buffer)
		  
		  buffer = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub CollapseInternalWhitespace(chars() As Text)
		  // Collapses consecutive whitespace within the passed character array to a single space.
		  // Mutates the passed array.
		  
		  Dim i As Integer = 0
		  Dim collapse As Boolean = False
		  Dim c As Text
		  While i < chars.Ubound
		    c = chars(i)
		    
		    If Utilities.IsWhitespace(c) Then
		      If collapse Then
		        chars.Remove(i)
		        i = i - 1
		      Else
		        collapse = True
		      End If
		    Else
		      collapse = False
		    End If
		    
		    i = i + 1 
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Escaped(chars() As Text, pos As Integer) As Boolean
		  // Returns True if the character at zero-based position `pos` is escaped.
		  // (i.e: preceded by a backslash character).
		  
		  If pos > chars.Ubound or pos = 0 Then Return False
		  
		  Return If(chars(pos - 1) = "\", True, False)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function HandleBackticks(b As MarkdownKit.InlineContainerBlock, startPos As Integer, rawCharsUbound As Integer) As MarkdownKit.InlineCodespan
		  // We know that index `startPos` in `b.RawChars` is a backtick. 
		  // Look to see if it represents the start of a valid inline code span.
		  // If it does then it creates and returns an inline code span. Otherwise 
		  // it returns Nil.
		  
		  Dim pos As Integer
		  
		  pos = startPos + 1
		  While pos <= rawCharsUbound
		    If b.RawChars(pos) <> "`" Then Exit
		    pos = pos + 1
		  Wend
		  
		  If pos = rawCharsUbound Then Return Nil
		  
		  // `pos` now points to the first character immediately following the opening 
		  // backtick string.
		  Dim contentStartPos As Integer = pos
		  
		  Dim backtickStringLen As Integer = pos - startPos
		  
		  // Find the start position of the closing backtick string (if there is one).
		  Dim closingStartPos As Integer = ScanClosingBacktickString(b, backtickStringLen, _
		  contentStartPos, rawCharsUbound)
		  
		  If closingStartPos = - 1 Then Return Nil
		  
		  // We've found a code span.
		  Return New MarkdownKit.InlineCodespan(contentStartPos, closingStartPos - 1, b, backtickStringLen)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function HandleLeftAngleBracket(b As MarkdownKit.InlineContainerBlock, startPos As Integer, rawCharsUbound As Integer) As MarkdownKit.Inline
		  // We know that index `startPos` in `b.RawChars` is a "<".
		  // Look to see if it represents the start of inline HTML.
		  // If it does then it creates and returns an inline HTML block. Otherwise 
		  // it returns Nil.
		  // NB: The EndPos of the returned inline HTML block is the position of the closing ">"
		  
		  // Bare minimum valid HTML tag is: <a>
		  If startPos + 2 > rawCharsUbound Then Return Nil
		  
		  Dim pos As Integer = 0
		  Dim c As Text = b.RawChars(startPos + 1)
		  
		  Dim tagName As Text
		  
		  If c = "/" Then
		    // Closing tag?
		    pos = HTMLScanner.ScanClosingTag(b.RawChars, startPos + 2, tagName)
		  ElseIf c = "?" Then
		    // Processing instruction?
		    pos = HTMLScanner.ScanProcessingInstruction(b.RawChars, startPos + 2, rawCharsUbound)
		  ElseIf c = "!" Then
		    // Comment, declaration or CDATA section?
		    pos = HTMLScanner.ScanDeclarationCommentOrCData(b.RawChars, startPos + 2, rawCharsUbound)
		  Else
		    // Autolink?
		    Dim uri As Text
		    pos = ScanAutoLink(b.RawChars, startPos + 1, rawCharsUbound, uri)
		    If pos > 0 Then
		      Return New MarkdownKit.InlineLink(startPos, pos - 1, "", uri, uri, b)
		    Else
		      // Email link?
		      pos = ScanEmailLink(b.RawChars, startPos + 1, rawCharsUbound, uri)
		      If pos > 0 Then
		        Return New MarkdownKit.InlineLink(startPos, pos - 1, "", "mailto:" + uri, uri, b)
		      Else
		        // Opening tag?
		        pos = HTMLScanner.ScanOpenTag(b.RawChars, startPos + 1, tagName, False)
		      End If
		    End If
		  End If
		  
		  If pos = 0 Then
		    Return Nil
		  Else
		    Return New MarkdownKit.InlineHTML(startPos, pos - 1, b)
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
		  mEmailPartOneCharacters = New Xojo.Core.Dictionary
		  
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

	#tag Method, Flags = &h0
		Shared Sub NotInlineStarter(ByRef buffer As MarkdownKit.Inline, ByRef pos As Integer, container As MarkdownKit.InlineContainerBlock)
		  // Called when parsing the raw characters of an inline container block and we have 
		  // come across a character that does NOT represent the start of new inline content.
		  
		  If buffer <> Nil Then
		    buffer.EndPos = pos
		  Else
		    buffer = New MarkdownKit.InlineText(pos, pos, container)
		  End If
		  
		  pos = pos + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub ParseInlines(b As MarkdownKit.InlineContainerBlock, ByRef delimiterStack() As MarkdownKit.DelimiterStackNode)
		  // We know that `b` is an inline container block (i.e: a paragraph, ATX heading or 
		  // setext heading) that has at least one character of content in its `RawChars` array.
		  // This method steps through the raw characters, populating the block's Inlines() array 
		  // with any inline elements it encounters.
		  
		  Dim pos As Integer = 0
		  Dim rawCharsUbound As Integer = b.RawChars.Ubound
		  Dim c, lastChar As Text = ""
		  Dim buffer As MarkdownKit.Inline
		  Dim result As MarkdownKit.Inline
		  Dim dsn As MarkdownKit.DelimiterStackNode
		  
		  While pos <= rawCharsUbound
		    
		    lastChar = c
		    c = b.RawChars(pos)
		    
		    If c = "`" And Not Escaped(b.RawChars, pos) Then
		      // ========= Code spans =========
		      result = HandleBackticks(b, pos, rawCharsUbound)
		      If result <> Nil And lastChar <> "`" Then
		        // Found a code span.
		        If buffer <> Nil Then CloseBuffer(buffer, b)
		        // Add the code span.
		        b.Inlines.Append(result)
		        // Advance the position.
		        pos = result.EndPos + MarkdownKit.InlineCodespan(result).DelimiterLength + 1
		      Else
		        NotInlineStarter(buffer, pos, b) 
		      End If
		      
		    ElseIf c = "<" And Not Escaped(b.RawChars, pos) Then
		      // ========= Inline HTML =========
		      result = HandleLeftAngleBracket(b, pos, rawCharsUbound)
		      If result <> Nil Then
		        // Found inline HTML.
		        If buffer <> Nil Then CloseBuffer(buffer, b)
		        // Add the inline HTML.
		        b.Inlines.Append(result)
		        // Advance the position.
		        pos = result.EndPos + 1
		      Else
		        NotInlineStarter(buffer, pos, b) 
		      End If
		      
		    ElseIf c = &u000A Then // Hard or soft break?
		      If pos - 1 >= 0 And b.RawChars(pos - 1) = "\" And Not Escaped(b.RawChars, pos - 1) Then
		        If buffer <> Nil Then
		          buffer.EndPos = buffer.EndPos - 1 // Remove the trailing backslash.
		          CloseBuffer(buffer, b)
		        End If
		        b.Inlines.Append(New Hardbreak(b))
		        pos = pos + 1
		      ElseIf pos - 2 >= 0 And b.RawChars(pos - 2) = &u0020 And b.RawChars(pos - 1) = &u0020 Then
		        If buffer <> Nil Then CloseBuffer(buffer, b, True)
		        b.Inlines.Append(New Hardbreak(b))
		        pos = pos + 1
		      Else
		        If buffer <> Nil Then CloseBuffer(buffer, b, True)
		        b.Inlines.Append(New Softbreak(b))
		        pos = pos + 1
		      End If
		      
		    ElseIf (c = "*" Or c = "_") And Not Escaped(b.RawChars, pos) Then
		      // ========= Emphasis? =========
		      If buffer <> Nil Then CloseBuffer(buffer, b)
		      dsn = ScanDelimiterRun(b.RawChars, rawCharsUbound, pos, c)
		      buffer = New MarkdownKit.InlineText(pos, pos + dsn.OriginalLength - 1, b)
		      dsn.TextNodePointer = Xojo.Core.WeakRef.Create(buffer)
		      CloseBuffer(buffer, b)
		      pos = pos + dsn.OriginalLength
		      delimiterStack.Append(dsn)
		      
		    Else
		      // This character is not the start of any inline content. If there is an 
		      // open inline text block then append this character to it, otherwise create a 
		      // new open inline text block and append this character to it.
		      NotInlineStarter(buffer, pos, b)
		    End If
		  Wend
		  
		  If buffer <> Nil Then CloseBuffer(buffer, b)
		  
		  ProcessEmphasis(b, delimiterStack, -1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub ProcessEmphasis(ByRef container As MarkdownKit.InlineContainerBlock, ByRef delimiterStack() As MarkdownKit.DelimiterStackNode, stackBottom As Integer)
		  // `stackBottom` sets a lower bound to how far we descend in the delimiter stack. If it's -1, 
		  // we can go all the way to the bottom. Otherwise, we stop before visiting stackBottom.
		  
		  If delimiterStack.Ubound < 0 Then Return
		  
		  // Let currentPosition point to the element on the delimiter stack just above stackBottom 
		  // (or the first element if stackBottom = -1).
		  Dim currentPosition As Integer = If(stackBottom = -1, 0, stackBottom + 1)
		  
		  // We keep track of the openersBottom for each delimiter type (*, _) 
		  // and each length of the closing delimiter run (modulo 3). 
		  // Initialize this to stackBottom.
		  Dim openersBottomStar As Integer = stackBottom
		  Dim openersBottomUnderscore As Integer = stackBottom
		  
		  // Move currentPosition forward in the delimiter stack until we find the first potential 
		  // closer with delimiter * or _. (This will be the potential closer closest to the 
		  // beginning of the input – the first one in parse order).
		  Dim closerNode As MarkdownKit.DelimiterStackNode
		  Dim openerNode As MarkdownKit.DelimiterStackNode
		  While currentPosition <= delimiterStack.Ubound
		    closerNode = delimiterStack(currentPosition)
		    If Not closerNode.Ignore And (closerNode.Delimiter = "*" Or closerNode.Delimiter = "_") And closerNode.CanClose Then
		      // Look back in the stack (staying above stackBottom and the openersBottom for this 
		      // delimiter type) for the first matching potential opener (“matching” means same delimiter).
		      
		      // Prevent an infinite loop...
		      If (currentPosition - 1) < (stackBottom + 1) Then
		        currentPosition = currentPosition + 1
		        Continue
		      End If
		      
		      For i As Integer = currentPosition - 1 DownTo (stackBottom + 1)
		        openerNode = delimiterStack(i)
		        If i > If(openerNode.Delimiter = "*", openersBottomStar, openersBottomUnderscore) Then
		          If Not openerNode.Ignore And openerNode.CanOpen And openerNode.Delimiter = closerNode.Delimiter Then
		            // Strong or regular emphasis? If both closer and opener spans have length >= 2, 
		            // we have strong, otherwise regular.
		            Dim emphasis As MarkdownKit.Inline
		            If closerNode.CurrentLength >= 2 And openerNode.CurrentLength >= 2 Then
		              // Strong.
		              emphasis = New MarkdownKit.InlineStrong(container, openerNode.Delimiter, openerNode.CurrentLength)
		            Else
		              // Regular. 
		              emphasis = New MarkdownKit.InlineEmphasis(container, openerNode.Delimiter, openerNode.CurrentLength)
		            End If
		            // Insert the newly created emphasis node, after the text node corresponding to the opener.
		            // Get the index of the opener text node in the container's `Inlines` array.
		            Dim openerTextNodeIndex As Integer = _
		            container.Inlines.IndexOf(Markdownkit.Inline(openerNode.TextNodePointer.Value))
		            If openerTextNodeIndex = -1 Then
		              Raise New MarkdownKit.MarkdownException("Cannot locate opening emphasis delimiter run " + _
		              "text node.")
		            End If
		            container.Inlines.Insert(openerTextNodeIndex + 1, emphasis)
		            
		            // Get the index of the closer text node in the container's `Inlines` array.
		            Dim closerTextNodeIndex As Integer = _
		            container.Inlines.IndexOf(Markdownkit.Inline(closerNode.TextNodePointer.Value))
		            If closerTextNodeIndex = -1 Then
		              Raise New MarkdownKit.MarkdownException("Cannot locate closing emphasis delimiter run " + _
		              "text node.")
		            End If
		            
		            // Need to move all inline nodes that occur between `openerTextNodeIndex` and `closerTextNodeIndex` 
		            // into this emphasis node's `Children` array and remove them from the container's 
		            // `Inlines` array.
		            If emphasis IsA MarkdownKit.InlineEmphasis Then
		              For x As Integer = openerTextNodeIndex + 2 To closerTextNodeIndex - 1
		                MarkdownKit.InlineEmphasis(emphasis).Children.Append(container.Inlines(x))
		              Next x
		            ElseIf emphasis IsA MarkdownKit.InlineStrong Then
		              For x As Integer = openerTextNodeIndex + 2 To closerTextNodeIndex - 1
		                MarkdownKit.InlineStrong(emphasis).Children.Append(container.Inlines(x))
		              Next x
		            End If
		            
		            // Remove the transposed inlines from the container.
		            Dim numToTranspose As Integer = closerTextNodeIndex - openerTextNodeIndex - 2
		            While numToTranspose > 0
		              container.Inlines.Remove(openerTextNodeIndex + 2)
		              numToTranspose = numToTranspose - 1
		            Wend
		            
		            // Remove any delimiters between the opener and closer from the delimiter stack.
		            // We do this by setting their `ignore` flag to True.
		            For j As Integer = i + 1 To currentPosition - 1
		              delimiterStack(j).Ignore = True
		            Next j
		            // Remove 1 (for regular emph) or 2 (for strong emph) delimiters from the opening 
		            // and closing text nodes. 
		            If closerNode.CurrentLength >= 2 Then
		              // Strong.
		              Call MarkdownKit.InlineText(openerNode.TextNodePointer.Value).Chars.Pop
		              Call MarkdownKit.InlineText(openerNode.TextNodePointer.Value).Chars.Pop
		              Call MarkdownKit.InlineText(closerNode.TextNodePointer.Value).Chars.Pop
		              Call MarkdownKit.InlineText(closerNode.TextNodePointer.Value).Chars.Pop
		            Else
		              // Regular. 
		              Call MarkdownKit.InlineText(openerNode.TextNodePointer.Value).Chars.Pop
		              Call MarkdownKit.InlineText(closerNode.TextNodePointer.Value).Chars.Pop
		            End If
		            
		            // If the text node becomes empty as a result, remove it and 
		            // remove the corresponding element of the delimiter stack. 
		            If MarkdownKit.InlineText(openerNode.TextNodePointer.Value).Chars.Ubound < 0 Then
		              openerTextNodeIndex = _
		              container.Inlines.IndexOf(Markdownkit.Inline(openerNode.TextNodePointer.Value))
		              If openerTextNodeIndex = -1 Then
		                Raise New MarkdownKit.MarkdownException("Cannot locate opening emphasis delimiter run " + _
		                "text node.")
		              End If
		              container.Inlines.Remove(openerTextNodeIndex)
		              openerNode.Ignore = True
		            End If
		            
		            If MarkdownKit.InlineText(closerNode.TextNodePointer.Value).Chars.Ubound < 0 Then
		              closerTextNodeIndex = _
		              container.Inlines.IndexOf(Markdownkit.Inline(closerNode.TextNodePointer.Value))
		              If closerTextNodeIndex = -1 Then
		                Raise New MarkdownKit.MarkdownException("Cannot locate closing emphasis delimiter run " + _
		                "text node.")
		              End If
		              container.Inlines.Remove(closerTextNodeIndex)
		              closerNode.Ignore = True
		            End If
		            
		            Exit
		            
		          Else
		            // Set openersBottom to the element before currentPosition. 
		            // (We know that there are no openers for this kind of closer up to and including this point, 
		            // so this puts a lower bound on future searches).
		            If openerNode.Delimiter = "*" Then
		              openersBottomStar = currentPosition + 1
		            Else
		              openersBottomUnderscore = currentPosition + 1
		            End If
		            // If the closer at currentPosition is not a potential opener, remove it from the 
		            // delimiter stack (since we know it can’t be a closer either).
		            If Not closerNode.CanOpen Then closerNode.Ignore = True
		            
		            currentPosition = currentPosition + 1
		          End If
		        End If
		      Next i
		    Else
		      currentPosition = currentPosition + 1
		    End If
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub ReplaceCharacterReferences(chars() As Text)
		  // Replaces valid HTML entity and numeric character references within the 
		  // passed array of characters with their corresponding unicode character.
		  // Mutates the passed array.
		  // CommonMark 0.29 section 6.2.
		  #Pragma Warning "Needs implementing"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanAutoLink(chars() As Text, startPos As Integer, charsUbound As Integer, ByRef uri As Text) As Integer
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
		  Dim c As Text
		  For pos = pos To charsUbound
		    c = chars(pos)
		    If c = ">" Then
		      // Valid autolink. Construct the URI.
		      Dim limit As Integer = pos - 1
		      Dim tmp() As Text
		      For i As Integer = startPos To limit
		        tmp.Append(chars(i))
		      Next i
		      uri = Text.Join(tmp, "")
		      Return pos + 1
		    End If
		    If MarkdownKit.Utilities.IsWhitespace(c) Then Return 0
		    If c = "<" Then Return 0
		  Next pos
		  
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanClosingBacktickString(b As MarkdownKit.InlineContainerBlock, backtickStringLen As Integer, startPos As Integer, rawCharsUbound As Integer) As Integer
		  // Beginning at `startPos` in `b.RawChars`, scan for a closing code span backtick string 
		  // of `backtickStringLen` characters. If found, return the position of the backtick 
		  // which forms the beginning of the closing backtick string. Otherwise return -1.
		  // Assumes `startPos` points at the character immediately following the last backtick of the 
		  // opening backtick string.
		  
		  If startPos + backtickStringLen > rawCharsUbound Then Return -1
		  
		  Dim contiguousBackticks As Integer = 0
		  Dim closingBacktickStringStartPos As Integer = -1
		  For i As Integer = startPos To rawCharsUbound
		    If b.RawChars(i) = "`" Then
		      If contiguousBackticks = 0 Then
		        // Might be the beginning of the closing sequence.
		        closingBacktickStringStartPos = i
		        contiguousBackticks = contiguousBackticks + 1
		        If backtickStringLen = 1 Then
		          // We may have found the closer. Check the next character isn't a backtick.
		          If i + 1 > rawCharsUbound Or b.RawChars(i + 1) <> "`" Then
		            // Success!
		            Return closingBacktickStringStartPos
		          End If
		        End If
		      Else
		        // We already have a potential closing sequence.
		        contiguousBackticks = contiguousBackticks + 1
		        If contiguousBackticks = backtickStringLen Then
		          // We may have found the closer. Check the next character isn't a backtick.
		          If i + 1 > rawCharsUbound Or b.RawChars(i + 1) <> "`" Then
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
		Private Shared Function ScanDelimiterRun(chars() As Text, charsUbound As Integer, pos As Integer, delimiter As Text) As MarkdownKit.DelimiterStackNode
		  // Scan the passed array of characters for a run of emphasis.
		  // `pos` points to the begining of the emphasis run.
		  // `delimiter` is either "*" or "_".
		  // Returns a DelimiterStackElement which contains information about the 
		  // delimiter type, delimiter length and whether it's a potential opener, closer 
		  // or both.
		  
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
		    beforeIsWhitespace = If(Utilities.IsWhitespace(chars(startPos- 1 )), True, False)
		  End If
		  
		  Dim afterIsWhitespace As Boolean
		  If pos >= charsUbound Then
		    afterIsWhitespace = True
		  Else
		    afterIsWhitespace = If(Utilities.IsWhitespace(chars(pos)), True, False)
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
		Private Shared Function ScanEmailLink(chars() As Text, startPos As Integer, charsUbound As Integer, ByRef uri As Text) As Integer
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
		  
		  uri = ""
		  
		  Dim pos As Integer = startPos
		  
		  // Match between 1 and unlimited times, as many times as possible, a character 
		  // in the set: a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-
		  Dim c As Text
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
		  Do
		    // Have we found a valid email?
		    If chars(pos) = ">" Then
		      If Valid Then
		        // Construct the URI.
		        Dim limit As Integer = pos - 1
		        Dim tmp() As Text
		        For i As Integer = startPos To limit
		          tmp.Append(chars(i))
		        Next i
		        uri = Text.Join(tmp, "")
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

	#tag Method, Flags = &h0
		Shared Function ScanLinkDestination(chars() As Text, startPos As Integer, isReferenceLink As Boolean) As MarkdownKit.CharacterRun
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
		  
		  Dim charsUbound As Integer = chars.Ubound
		  Dim i As Integer
		  Dim c As Text
		  
		  Dim result As New MarkdownKit.CharacterRun(startPos, -1, -1)
		  
		  // Scenario 1:
		  If chars(startPos) = "<" Then
		    i = startPos + 1
		    While i <= charsUbound
		      c = chars(i)
		      If c = ">" And Not Escaped(chars, i) Then
		        result.Length = i - startPos + 1
		        result.Finish = i
		        Return result
		      End If
		      If c = "<" And Not Escaped(chars, i) Then Return result
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
		      If Not Escaped(chars, i) Then openParensCount = openParensCount + 1
		    Case ")"
		      If Not Escaped(chars, i) Then closeParensCount = closeParensCount + 1
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
		Shared Function ScanLinkLabel(chars() As Text) As MarkdownKit.CharacterRun
		  // Scans the contents of `chars` for a link reference definition label.
		  // Assumes chars starts with a "[".
		  // Assumes chars.Ubound >=3.
		  // Returns a CharacterRun. If no valid label is found then the CharacterRun's
		  // `start` and `finish` properties will be set to -1.
		  // Does NOT mutate the passed array.
		  
		  // Note the precedence: code backticks have precedence over label bracket
		  // markers, which have precedence over *, _, and other inline formatting
		  // markers. So, (2) below contains a link whilst (1) does not:
		  // (1) [a link `with a ](/url)` character
		  // (2) [a link *with emphasized ](/url) text*
		  
		  Dim result As New MarkdownKit.CharacterRun(0, -1, -1)
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  If charsUbound > kMaxReferenceLabelLength + 1 Then Return result
		  
		  // Find the first "]" that is not backslash-escaped.
		  Dim limit As Integer = Xojo.Math.Min(charsUbound, kMaxReferenceLabelLength + 1)
		  Dim i As Integer
		  Dim seenNonWhitespace As Boolean = False
		  For i = 1 To limit
		    Select Case chars(i)
		    Case "["
		      // Unescaped square brackets are not allowed.
		      If Not Escaped(chars, i) Then Return result
		      seenNonWhitespace = True
		    Case "]"
		      If Escaped(chars, i) Then
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
		Private Shared Function ScanLinkScheme(chars() As Text, pos As Integer, charsUbound As Integer) As Integer
		  // Scans the passed character array for a valid inline link scheme.
		  // Returns the position of the character immediately following the scheme if 
		  // found, otherwise returns 0.
		  // Valid scheme = [A-Za-z]{1}[A-Za-z0-9\+\.\-]{1, 31}
		  
		  // Min valid scheme: aa
		  If pos + 1 > charsUbound Then Return 0
		  
		  If Not Utilities.IsASCIIAlphaChar(chars(pos)) Then Return 0
		  
		  Dim c As Text = chars(pos + 1)
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
		Shared Function ScanLinkTitle(chars() As Text, startPos As Integer) As MarkdownKit.CharacterRun
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
		  
		  Dim result As New MarkdownKit.CharacterRun(startPos, -1, -1)
		  result.Invalid = True
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  // Sanity check.
		  If startPos < 0 Or startPos > charsUbound Or _
		    (startPos + 1) > charsUbound Then
		    Return result
		  End If
		  
		  Dim c As Text = chars(startPos)
		  
		  Dim delimiter As Text
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
		    If c = delimiter And Not Escaped(chars, i) Then
		      result.Length = i - startPos + 1
		      result.Finish = i
		      result.Invalid = False
		      Return result
		    End If
		  Next i
		  
		  Return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub Unescape(chars() As Text)
		  // Converts backslash escaped characters to their literal character value.
		  // Mutates alters the passed array.
		  
		  Dim pos As Integer = 0
		  Dim c As Text
		  Do Until pos > chars.Ubound
		    c = chars(pos)
		    If c = "\" And pos < chars.Ubound And _
		      MarkdownKit.IsEscapable(chars(pos + 1)) Then
		      // Remove the backslash from the array.
		      chars.Remove(pos)
		    End If
		    pos = pos + 1
		  Loop
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		#tag Note
			Stores the characters that are valid for the first part of an email autolink:
			a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-
		#tag EndNote
		Private Shared mEmailPartOneCharacters As Xojo.Core.Dictionary
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
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
