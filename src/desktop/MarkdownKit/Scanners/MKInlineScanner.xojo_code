#tag Class
Protected Class MKInlineScanner
	#tag Method, Flags = &h21, Description = 5072697661746520746F2070726576656E7420696E7374616E74696174696F6E2E
		Private Sub Constructor()
		  /// Private to prevent instantiation.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 46696E616C69736573207468652063757272656E7420696E6C696E652070617273696E67206275666665722E
		Private Shared Sub FinaliseBuffer(ByRef buffer As MKInlineText, container As MKBlock)
		  /// Finalises the current inline parsing buffer.
		  ///
		  /// As we parse inlines, we perodically keep an open inline text buffer to add characters to
		  /// until we hit a different type of inline element (e.g. a backtick for a code span).
		  /// This method is called when we need to close / finalise that open buffer.
		  
		  buffer.Finalise
		  
		  // Add the buffer to the container block.
		  container.Children.Add(buffer)
		  
		  buffer = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 49662074686520636861726163746572206174205B7374617274506F735D20696E205B63686172735D20626567696E7320612076616C696420696E6C696E6520636F6465207370616E207468656E206F6E65206973206372656174656420616E642072657475726E65642C206F7468657277697365204E696C2069732072657475726E65642E
		Shared Function HandleBackticks(parent As MKBlock, chars() As MKCharacter, startPos As Integer) As MKCodeSpan
		  /// If the character at [startPos] in [chars] begins a valid inline code span then one is created and 
		  /// returned, otherwise Nil is returned.
		  /// 
		  /// Assumes [startPos] in [chars] is a backtick.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Compute the length of the backtickString and the index of the first character after the 
		  // opening backtickString.
		  Var contentStartPos As Integer = startPos + 1
		  While contentStartPos <= charsLastIndex
		    If chars(contentStartPos).Value <> "`" Then Exit
		    contentStartPos = contentStartPos + 1
		  Wend
		  If contentStartPos = charsLastIndex Then Return Nil
		  Var backtickStringLen As Integer = contentStartPos - startPos
		  
		  // Find the start position of the closing backtick string (if there is one).
		  Var contentEndPos, localClosingBacktickStringStart As Integer
		  Var contiguousBackticks As Integer = 0
		  Var foundClosingBacktickString As Boolean = False
		  For i As Integer = contentStartPos To charsLastIndex
		    If chars(i).Value = "`" Then
		      contiguousBackticks = contiguousBackticks + 1
		      If contiguousBackticks = backtickStringLen Then
		        // Done so long as the next character isn't a backtick.
		        If i = charsLastIndex Or (i < charsLastIndex And chars(i + 1).Value <> "`") Then
		          contentEndPos = chars(i).Position - backtickStringLen
		          localClosingBacktickStringStart = i
		          foundClosingBacktickString = True
		          Exit
		        End If
		      End If
		    Else
		      contiguousBackticks = 0
		    End If
		  Next i
		  If Not foundClosingBacktickString Then Return Nil
		  
		  // We've found a code span.
		  Var cs As New MKCodeSpan(parent, parent.Start + startPos, startPos, _
		  backtickStringLen, contentEndPos + 1, localClosingBacktickStringStart)
		  cs.Finalise
		  
		  Return cs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 49662074686520636861726163746572206174205B7374617274506F735D20696E205B63686172735D20626567696E7320612076616C696420696E6C696E652048544D4C207370616E207468656E206F6E65206973206372656174656420616E642072657475726E65642C206F7468657277697365204E696C2069732072657475726E65642E
		Shared Function HandleLeftAngleBracket(parent As MKBlock, chars() As MKCharacter, startPos As Integer) As MKInlineHTML
		  /// If the character at [startPos] in [chars] begins a valid inline HTML span then one is created and 
		  /// returned, otherwise Nil is returned.
		  ///
		  /// Assumes `chars(startPos) = "<"`.
		  
		  #Pragma Warning "TODO: Inline HTML parsing"
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Bare minimum valid inline HTML tag 3 characters long (e.g: `<a>`).
		  If startPos + 2 > charsLastIndex Then Return Nil
		  
		  Var html As MKInlineHTML
		  Var pos As Integer = 0
		  Var c As String = chars(startPos + 1).Value
		  Var tagName As String
		  
		  If c = "/" Then
		    // Does this mark a closing tag?
		    pos = MKInlineHTMLScanner.FindClosingTag(chars, startPos + 2, tagName)
		    
		  ElseIf c = "?" Then
		    // Processing instruction?
		    pos = MKInlineHTMLScanner.ScanProcessingInstruction(chars, startPos + 2)
		    
		  ElseIf c = "!" Then
		    // Comment, declaration or CDATA section?
		    pos = MKInlineHTMLScanner.ScanDeclarationCommentOrCData(chars, startPos + 2)
		    
		  Else
		    // Autolink?
		    Var uri As String
		    pos = MKInlineHTMLScanner.ScanAutoLink(chars, startPos + 1, uri)
		    If pos > 0 Then
		      html = New MKInlineHTML(parent, parent.Start + startPos, startPos, parent.Start + pos - 1, pos - 1)
		      html.IsAutoLink = True
		      html.Title = ""
		      html.Destination = uri
		      html.Label = uri
		      html.Finalise
		      Return html
		      
		    Else
		      // Email link?
		      pos = MKInlineHTMLScanner.ScanEmailLink(chars, startPos + 1, uri)
		      If pos > 0 Then
		        html = New MKInlineHTML(parent, parent.Start + startPos, startPos, parent.Start + pos - 1, pos - 1)
		        html.IsAutoLink = True
		        html.Title = ""
		        html.Destination = "mailto:" + uri
		        html.Label = uri
		        html.Finalise
		        Return html
		      Else
		        // Opening tag?
		        pos = MKInlineHTMLScanner.FindOpenTag(chars, startPos + 1, tagName)
		      End If
		    End If
		  End If
		  
		  If pos = 0 Then
		    Return Nil
		  Else
		    html = New MKInlineHTML(parent, parent.Start + startPos, startPos, parent.Start + pos - 1, pos - 1)
		    html.Finalise
		    Return html
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5374657073207468726F7567682074686520636F6E74656E7473206F662074686520696E6C696E6520636F6E7461696E6572205B626C6F636B5D2C2068616E646C696E6720616E7920696E6C696E6520656C656D656E747320697420656E636F756E746572732E
		Shared Sub ParseInlines(block As MKBlock)
		  /// Steps through the contents of the inline container [block], handling any inline elements it encounters.
		  ///
		  /// Assumes [block] is an inline container block (i.e: a paragraph, ATX heading or setext heading).
		  
		  #Pragma Warning "TODO"
		  
		  Var pos As Integer = 0
		  Var chars() As MKCharacter = block.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  Var buffer As MKInlineText
		  
		  While pos <= charsLastIndex
		    Var c As MKCharacter = chars(pos)
		    
		    If c.Value = "`" And Not chars.IsEscaped(pos) Then
		      // ============
		      // CODE SPAN
		      // ============
		      Var cs As MKCodeSpan = HandleBackticks(block, chars, pos)
		      If cs <> Nil Then
		        // Found a code span.
		        If buffer <> Nil Then FinaliseBuffer(buffer, block)
		        // Add the code span.
		        block.Children.Add(cs)
		        // Advance the position.
		        pos = cs.LocalClosingBacktickStringStart + cs.BacktickStringLength
		      Else
		        If buffer <> Nil Then
		          buffer.EndPosition = pos + block.Start
		        Else
		          buffer = New MKInlineText(block)
		          buffer.Start = pos + block.Start
		          buffer.LocalStart = pos
		          buffer.EndPosition = pos + block.Start
		        End If
		        pos = pos + 1
		      End If
		      
		    ElseIf c.Value = "<" And Not chars.IsEscaped(pos) Then
		      // ============
		      // INLINE HTML
		      // ============
		      Var html As MKInlineHTML = HandleLeftAngleBracket(block, chars, pos)
		      If html <> Nil Then
		        // Found inline HTML.
		        If buffer <> Nil Then FinaliseBuffer(buffer, block)
		        // Add the inline HTML.
		        block.Children.Add(html)
		        // Advance the position.
		        pos = html.EndPosition - block.Start + 1
		      Else
		        If buffer <> Nil Then
		          buffer.EndPosition = pos + block.Start
		        Else
		          buffer = New MKInlineText(block)
		          buffer.Start = pos + block.Start
		          buffer.LocalStart = pos
		          buffer.EndPosition = pos + block.Start
		        End If
		        pos = pos + 1
		      End If
		      
		      
		      // ============
		      // LINE ENDING
		      // ============
		    ElseIf c.IsLineEnding Then
		      If buffer <> Nil Then FinaliseBuffer(buffer, block)
		      pos = pos + 1
		      Continue
		      
		    Else
		      // This character is not the start of any inline content. If there is an 
		      // open inline text block then append this character to it, otherwise create a 
		      // new open inline text block and append this character to it.
		      If buffer <> Nil Then
		        buffer.EndPosition = pos + block.Start
		      Else
		        buffer = New MKInlineText(block)
		        buffer.Start = pos + block.Start
		        buffer.LocalStart = pos
		        buffer.EndPosition = pos + block.Start
		      End If
		      pos = pos + 1
		    End If
		  Wend
		  
		  If buffer <> Nil Then
		    FinaliseBuffer(buffer, block)
		  End If
		  
		  ' 'ProcessEmphasis(b, delimiterStack, -1)
		End Sub
	#tag EndMethod


End Class
#tag EndClass
