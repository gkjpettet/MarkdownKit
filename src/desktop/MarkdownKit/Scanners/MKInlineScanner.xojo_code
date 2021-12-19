#tag Class
Protected Class MKInlineScanner
	#tag Method, Flags = &h21, Description = 436C6F736573207468652063757272656E7420696E6C696E652070617273696E67206275666665722E
		Private Shared Sub CloseBuffer(buffer As MKBlock, container As MKBlock, stripTrailingWhitespace As Boolean = False)
		  /// Closes the current inline parsing buffer.
		  
		  // There's an open preceding text inline. Close it.
		  'buffer.Close
		  
		  'If stripTrailingWhitespace Then MarkdownKit.StripTrailingWhitespace(buffer.Chars)
		  
		  // Add the buffer to the container block.
		  container.Children.Add(buffer)
		  
		  buffer = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5072697661746520746F2070726576656E7420696E7374616E74696174696F6E2E
		Private Sub Constructor()
		  /// Private to prevent instantiation.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 49662074686520636861726163746572206174205B7374617274506F735D20696E205B63686172735D20697320612076616C696420696E6C696E6520636F6465207370616E207468656E206F6E65206973206372656174656420616E642072657475726E65642C206F7468657277697365204E696C2069732072657475726E65642E
		Shared Function HandleBackticks(parent As MKBlock, chars() As MKCharacter, startPos As Integer) As MKCodeSpan
		  /// If the character at [startPos] in [chars] is a valid inline code span then one is created and returned, 
		  /// otherwise Nil is returned.
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
		  Var contentEndPos As Integer
		  Var contiguousBackticks As Integer = 0
		  Var foundClosingBacktickString As Boolean = False
		  For i As Integer = contentStartPos To charsLastIndex
		    If chars(i).Value = "`" Then
		      contiguousBackticks = contiguousBackticks + 1
		      If contiguousBackticks = backtickStringLen Then
		        // Done so long as the next character isn't a backtick.
		        If i = charsLastIndex Or (i < charsLastIndex And chars(i + 1).Value <> "`") Then
		          contentEndPos = chars(i).Position - backtickStringLen
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
		  Return New MKCodeSpan(parent, startPos, backtickStringLen, contentEndPos + 1)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5374657073207468726F7567682074686520636F6E74656E7473206F662074686520696E6C696E6520636F6E7461696E6572205B626C6F636B5D2C2068616E646C696E6720616E7920696E6C696E6520656C656D656E747320697420656E636F756E746572732E
		Shared Sub ParseInlines(block As MKBlock)
		  /// Steps through the contents of the inline container [block], handling any inline elements it encounters.
		  ///
		  /// Assumes [block] is an inline container block (i.e: a paragraph, ATX heading or setext heading).
		  
		  #Pragma Warning "TODO"
		  
		  ' #Pragma Warning "Bug: Infinite loop"
		  ' ' This code is causing a circular loop with NextSibling:
		  ' '        Hello `Xojo code` cool"
		  ' 
		  ' // Remove all children from this block as they will be reconstructed from the the block's characters.
		  ' block.Children.RemoveAll
		  ' 
		  ' Var pos As Integer = 0
		  ' Var chars() As MKCharacter = MKCharacterContainer(block).AllCharacters
		  ' Var charsLastIndex As Integer = chars.LastIndex
		  ' Var buffer As MKBlock
		  ' 
		  ' While pos <= charsLastIndex
		  ' Var c As MKCharacter = chars(pos)
		  ' 
		  ' If c.Value = "`" And Not chars.IsEscaped(pos) Then
		  ' // ============
		  ' // CODE SPAN
		  ' // ============
		  ' Var cs As MKCodeSpan = HandleBackticks(block, chars, pos)
		  ' If cs <> Nil And (pos - 1 >= 0 And chars(pos - 1).Value <> "`") Then
		  ' // Found a code span.
		  ' If buffer <> Nil Then CloseBuffer(buffer, block)
		  ' // Add the code span.
		  ' block.Children.Add(cs)
		  ' // Advance the position.
		  ' pos = cs.EndPosition + cs.BacktickStringLength + 1 - block.Start
		  ' Else
		  ' If buffer <> Nil Then
		  ' buffer.EndPosition = pos
		  ' Else
		  ' buffer = New MKInlineText(block)
		  ' buffer.Start = pos + block.Start
		  ' buffer.EndPosition = pos + block.Start
		  ' End If
		  ' pos = pos + 1
		  ' End If
		  ' 
		  ' Else
		  ' // This character is not the start of any inline content. If there is an 
		  ' // open inline text block then append this character to it, otherwise create a 
		  ' // new open inline text block and append this character to it.
		  ' If buffer <> Nil Then
		  ' buffer.EndPosition = pos + block.Start
		  ' Else
		  ' buffer = New MKBlock(MKBlockTypes.InlineText, block)
		  ' buffer.Start = pos + block.Start
		  ' buffer.EndPosition = pos + block.Start
		  ' End If
		  ' pos = pos + 1
		  ' End If
		  ' Wend
		  ' 
		  ' If buffer <> Nil Then
		  ' CloseBuffer(buffer, block)
		  ' End If
		  ' 
		  ' 'ProcessEmphasis(b, delimiterStack, -1)
		End Sub
	#tag EndMethod


End Class
#tag EndClass
