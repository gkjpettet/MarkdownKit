#tag Class
Protected Class HTMLScanner
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetHtmlTagName(chars() As Text, ByRef pos As Integer) As Text
		  // Starting at `pos`, read a HTML tag name from the passed character array and return it.
		  // Increment `pos` so that at the end of the method, it points to the character immediately 
		  // after the tag name. 
		  // NB: `pos` is passed ByRef.
		  // tagName: ASCII letter, >= 0 ASCII letter|digit|-
		  // Returns "" If no valid tagName is found.
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  If pos > charsUbound Or Not Utilities.IsASCIIAlphaChar(chars(pos)) Then Return ""
		  
		  Dim c As Text
		  Dim tmp() As Text
		  Dim start As Integer = pos
		  For pos = start To charsUbound
		    c = chars(pos)
		    If Utilities.IsASCIIAlphaChar(c) Or Utilities.IsDigit(c) Or c= "-" Then
		      tmp.Append(c)
		    Else
		      Exit
		    End If
		  Next pos
		  
		  Return Text.Join(tmp, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function MatchAnythingExcept(chars() As Text, charsUbound As Integer, ByRef pos As Integer, ByRef currentChar As Text, invalidChar As Text) As Boolean
		  Dim matched As Boolean = False
		  
		  While currentChar <> invalidChar And pos < charsUbound
		    pos = pos + 1
		    currentChar = chars(pos)
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function MatchAnythingExceptWhitespace(chars() As Text, charsUbound As Integer, ByRef pos As Integer, ByRef currentChar As Text, invalid1 As Text, invalid2 As Text, invalid3 As Text, invalid4 As Text, invalid5 As Text, invalid6 As Text) As Boolean
		  Dim matched As Boolean = False
		  
		  While currentChar <> invalid1 And _
		    currentChar <> invalid2 And _
		    currentChar <> invalid3 And _
		    currentChar <> invalid4 And _
		    currentChar <> invalid5 And _
		    currentChar <> invalid6 And _
		    (currentChar <> " " And currentChar <> &u000A) And _
		    pos < charsUbound
		    
		    pos = pos + 1
		    currentChar = chars(pos)
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function MatchASCIILetter(chars() As Text, charsUbound As Integer, ByRef pos As Integer, ByRef currentChar As Text, valid1 As Text, valid2 As Text) As Boolean
		  // Moves along the given array as long as the current character is an ASCII letter 
		  // or one of the given additional valid characters.
		  
		  Dim matched As Boolean = False
		  
		  While (currentChar = valid1 Or _
		    currentChar = valid2 Or _
		    Utilities.IsASCIIAlphaChar(currentChar)) And _
		    pos < charsUbound
		    
		    pos = pos + 1
		    currentChar = chars(pos)
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function MatchASCIILetterOrDigit(chars() As Text, charsUbound As Integer, ByRef pos As Integer, ByRef currentChar As Text, valid1 As Text, valid2 As Text, valid3 As Text, valid4 As Text) As Boolean
		  // Moves along the given array as long as the current character is an ASCII letter 
		  // or digit or one of the given additional valid characters.
		  
		  Dim matched As Boolean = False
		  
		  While (currentChar = valid1 Or _
		    currentChar = valid2 Or _
		    currentChar = valid3 Or _
		    currentChar = valid4 Or _
		    Utilities.IsASCIIAlphaChar(currentChar) Or _
		    Utilities.IsDigit(currentChar)) And _
		    pos < charsUbound
		    
		    pos = pos + 1
		    currentChar = chars(pos)
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function MatchASCIILetterOrDigitOrHyphen(chars() As Text, charsUbound As Integer, pos As Integer, maxCount As Integer) As Integer
		  // Moves along the given array as long as the current character is an ASCII letter 
		  // or digit or hyphen ("-").
		  // Returns the number of matched characters.
		  // Stops skipping if we match maxCount characters.
		  
		  If pos > charsUbound Then Return 0
		  Dim c As Text = chars(pos)
		  
		  Dim matched As Integer = 0
		  
		  While (c = "-" Or _
		    Utilities.IsASCIIAlphaChar(c) Or _
		    Utilities.IsDigit(c)) And _
		    pos < charsUbound And matched <= maxCount
		    
		    pos = pos + 1
		    c = chars(pos)
		    matched = matched + 1
		  Wend
		  
		  Return matched
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanClosingTag(chars() As Text, pos As integer, ByRef tagName As Text) As Integer
		  // Scans the passed line beginning at `pos` for a valid HTML closingTag.
		  // Returns the zero-based index in line.Chars where the closingTag ends.
		  // Returns 0 if no valid closingTag is found.
		  // NB: Assumes that `pos` points to the character immediately following "</"
		  // closingTag: </, tagName, optional whitespace, >
		  // tagName: ASCII letter, >= 0 ASCII letter|digit|-
		  // Also sets the ByRef tagName parameter to the detected tagName (if present) 
		  // or "" if no valid tagName is found.
		  
		  // Reset `tagName`.
		  tagName = ""
		  
		  Dim charsUbound As Integer = chars.Ubound
		  If pos + 1 > charsUbound Then Return 0
		  
		  // The tag name must start with an ASCII letter.
		  If Not Utilities.IsASCIIAlphaChar(chars(pos)) Then Return 0
		  
		  // Get the tag name and move `pos` to the position immediately following the tag name.
		  tagName = HTMLScanner.GetHtmlTagName(chars, pos)
		  If pos > charsUbound Then Return 0
		  If tagName = "" Then Return 0
		  
		  // Get the current character.
		  Dim c As Text = chars(pos)
		  
		  // Skip optional whitespace.
		  Call HTMLScanner.SkipWhitespace(chars, charsUbound, pos, c)
		  If pos > charsUbound Then Return 0
		  
		  // Check for the tag closing delimiter.
		  If c = ">" Then
		    Return pos + 1
		  Else
		    Return 0
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanDeclarationCommentOrCData(chars() As Text, startPos As Integer, charsUbound As Integer) As Integer
		  // Scans the passed character array `chars` for a valid HTML declaration, comment or CDATA section.
		  // Assumes `startPos` points at the index of the character immediately following "<!".
		  // Returns the index of the character immediately after the close of the inline HTML element or 
		  // 0 if no match is found.
		  
		  // CDATA:
		  // -----
		  // "<![CDATA[", >= 0 characters, then "]]>"
		  
		  // Declaration:
		  // -----------
		  // "<!", >= 1 uppercase ASCII letters, whitespace, >= 1 characters not including ">", then ">"
		  
		  // Comment:
		  // -------
		  // "<!--" + text + "-->"
		  // Where text does not start with ">" or "->", does not end with "-", and does not contain "--"
		  
		  ' <![CDATA[X]]>
		  ' 0123456789012
		  '   ^
		  
		  ' <!X X>
		  ' 012345
		  '   ^
		  
		  ' <!--a-->
		  ' 01234567
		  '   ^
		  
		  // Shortest valid: <!A A>
		  If startPos + 3 > charsUbound Then Return 0
		  
		  Dim c As Text = chars(startPos)
		  
		  Dim pos As Integer
		  If c = "-" Then
		    // Comment?
		    If chars(startPos + 1) <> "-" Then Return 0
		    If chars(startPos + 2) = ">" Then Return 0 // Text can't start with ">"
		    If chars(startPos + 2) = "-" And chars(startPos + 3) = ">" Then Return 0 // Or "->"
		    
		    For pos = startPos + 2 To charsUbound
		      If chars(pos) = "-" And pos + 2 <= charsUbound And chars(pos + 1) = "-" Then
		        If chars(pos + 2) = ">" Then
		          Return pos + 3
		        Else // The contents can't contain "--"
		          Return 0
		        End If
		      End If
		    Next pos
		    Return 0
		    
		  ElseIf c = "[" Then
		    // CDATA?
		    If startPos + 10 > charsUbound Then Return 0
		    If chars(startPos + 1) <> "C" And chars(startPos + 2) <> "D" And _
		    chars(startPos + 3) <> "A" And chars(startPos + 4) <> "T" And _
		    chars(startPos + 5) <> "A" And chars(startPos + 5) <>"[" Then Return 0
		    // Skip over the contents until we hit "]]>"
		    For pos = startPos + 6 To charsUbound
		      If chars(pos) = "]" And pos + 2 <= charsUbound And chars(pos + 1) = "]" And _
		      chars(pos + 2) = ">" Then Return pos + 3
		    Next pos
		    Return 0
		    
		  ElseIf Utilities.IsUppercaseASCIIChar(c) Then
		    // Declaration?
		    // Consume the uppercase ASCII letters.
		    
		    For pos = startPos + 1 To charsUbound
		      If Not Utilities.IsUppercaseASCIIChar(chars(pos)) Then Exit
		    Next pos
		    
		    // Must see whitespace at `pos`.
		    If Not MarkdownKit.IsWhitespace(chars(pos)) Then Return 0
		    // Consume the contiguous whitespace.
		    For pos = pos + 1 to charsUbound
		      If Not MarkdownKit.IsWhitespace(chars(pos)) Then Exit
		    Next pos
		    
		    If pos >= charsUbound Then Return 0
		    
		    // Must see at least one character that's not ">"
		    If chars(pos) = ">" Then Return 0
		    
		    // Consume characters until we get to ">"
		    For pos = pos + 1 To charsUbound
		      If chars(pos) = ">" Then Return pos + 1
		    Next pos
		    Return 0
		    
		  Else
		    Return 0
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanHtmlBlockType1End(line As MarkdownKit.LineInfo, pos As Integer) As Boolean
		  // HTML block type 1:
		  // End condition:   line contains an end tag </script>, </pre>, or </style> 
		  //                  (case-insensitive; it need not match the start tag).
		  
		  Dim t As Text = Text.Join(line.Chars, "")
		  If t.IndexOf(pos, "</pre>") <> -1 Then Return True
		  If t.IndexOf(pos, "</style>") <> -1 Then Return True
		  If t.IndexOf(pos, "</script>") <> -1 Then Return True
		  
		  Return False
		  
		  Exception e
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanHtmlBlockType2End(line As MarkdownKit.LineInfo, pos As Integer) As Boolean
		  // HTML block type 2:
		  // End condition: line contains the string "-->"
		  
		  Dim t As Text = Text.Join(line.Chars, "")
		  Return If(t.IndexOf(pos, "-->") <> -1, True, False)
		  
		  Exception e
		    Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanHtmlBlockType3End(line As MarkdownKit.LineInfo, pos As Integer) As Boolean
		  // HTML block type 3:
		  // End condition: line contains the string "?>"
		  
		  Dim t As Text = Text.Join(line.Chars, "")
		  Return If(t.IndexOf(pos, "?>") <> -1, True, False)
		  
		  Exception e
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanHtmlBlockType4End(line As MarkdownKit.LineInfo, pos As Integer) As Boolean
		  // HTML block type 4:
		  // End condition: line contains the character ">".
		  
		  Dim t As Text = Text.Join(line.Chars, "")
		  Return If(t.IndexOf(pos, ">") <> -1, True, False)
		  
		  Exception e
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanHtmlBlockType5End(line As MarkdownKit.LineInfo, pos As Integer) As Boolean
		  // HTML block type 5:
		  // End condition: line contains the string "]]>".
		  
		  Dim t As Text = Text.Join(line.Chars, "")
		  Return If(t.IndexOf(pos, "]]>") <> -1, True, False)
		  
		  Exception e
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanOpenTag(chars() As Text, pos As Integer, ByRef tagName As Text, type7Only As Boolean = True) As Integer
		  // Scans the passed line beginning at `pos` for a valid HTML open tag.
		  // Returns the zero-based index in line.Chars where the openTag ends.
		  // Returns 0 if no valid openTag is found.
		  // NB: Assumes that `pos` points to the character immediately following "<"
		  // Sets the ByRef parameter `tagName` to the detected tag name (if present) 
		  // or "" if no valid tag is found.
		  
		  // openTag: "<", a tagname, >= 0 attributes, optional whitespace, optional "/", and a ">".
		  // tagName: ASCII letter, >= 0 ASCII letter|digit|-
		  // attribute: whitespace, attributeName, optional attributeValueSpec
		  // attributeName: ASCII letter|-|:, >=0 ASCII letter|digit|_|.|:|-
		  // attributeValueSpec: optional whitespace, =, optional whitespace, attributeValue
		  // attributeValue: unQuotedAttValue | singleQuotedAttValue | doubleQuotedAttValue
		  // unQuotedAttValue: > 0 characters NOT including whitespace, ", ', =, <, >, or `.
		  // singleQuotedAttValue: ', >= 0 characters NOT including ', then a final '
		  // doubleQuotedAttValue: ", >= 0 characters NOT including ", then a final "
		  
		  // Reset `tagName`.
		  tagName = ""
		  
		  Dim charsUbound As Integer = chars.Ubound
		  If pos + 1 > charsUbound Then Return 0
		  
		  // The tag name must start with an ASCII letter.
		  If Not Utilities.IsASCIIAlphaChar(chars(pos)) Then Return 0
		  
		  // Get the tag name and move `pos` to the position immediately following the tag name.
		  tagName = HTMLScanner.GetHtmlTagName(chars, pos)
		  If pos > charsUbound Then Return 0
		  If tagName = "" Then Return 0
		  
		  If type7Only Then
		    // For a valid type 7 HTML block start, "script", "pre" and "style" are not valid tag names.
		    If tagName = "script" Or tagName = "pre" Or tagName = "style" Then Return 0
		  End If
		  
		  // Loop until the end of the line is reached or the tag is closed.
		  Dim hadWhitespace As Boolean = False
		  Dim hadAttribute As Boolean = False
		  Dim tmpChar As Text
		  Dim currentChar As Text = chars(pos)
		  While pos <= charsUbound
		    // Skip whitespace.
		    hadWhitespace = HTMLScanner.SkipWhitespace(chars, charsUbound, pos, currentChar)
		    
		    // Has the end of the tag been reached?
		    If currentChar = ">" Then
		      Return pos + 1
		    Else
		      If currentChar = "/" Then
		        If pos + 1 <= charsUbound And chars(pos + 1) = ">" Then
		          Return pos + 2
		        Else
		          Return 0
		        End If
		      End If
		    End If
		    
		    // Have we arrived at an attribute value?
		    If currentChar = "=" Then
		      If Not hadAttribute Or pos >= charsUbound Then Return 0
		      
		      // Move past the "=" symbol and any whitespace.
		      pos = pos + 1
		      currentChar = chars(pos)
		      Call HTMLScanner.SkipWhitespace(chars, charsUbound, pos, currentChar)
		      
		      If currentChar = "'" Or currentChar = """" Then
		        tmpChar = currentChar
		        pos = pos + 1
		        If pos > charsUbound Then Return 0
		        currentChar = chars(pos)
		        Call HTMLScanner.MatchAnythingExcept(chars, charsUbound, pos, currentChar, tmpChar)
		        If currentChar <> tmpChar Or pos >= charsUbound Then Return 0
		        
		        pos = pos + 1
		        If pos > charsUbound Then Return 0
		        currentChar = chars(pos)
		      Else
		        // Unquoted atrribute values must have at least one character.
		        If Not HTMLScanner.MatchAnythingExceptWhitespace(chars, charsUbound, pos, currentChar, """", "'", "=", "<", ">", "`") Then
		          Return 0
		        End If
		      End If
		      
		      hadAttribute = False
		      Continue
		    End If
		    
		    // The attribute must be preceded by whitespace.
		    If Not hadWhitespace Then Return 0
		    
		    // If the end has not been found then there is just one possible alternative - an attribute.
		    // Ensure that the attribute name starts with a correct character
		    If Not HTMLScanner.MatchASCIILetter(chars, charsUbound, pos, currentChar, "_", ":") Then
		      Return 0
		    End If
		    
		    // Match any remaining characters in the attribute name.
		    Call HTMLScanner.MatchASCIILetterOrDigit(chars, charsUbound, pos, currentChar, "_", ":", ".", "-")
		    hadAttribute = True
		  Wend
		  
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanProcessingInstruction(chars() As Text, startPos As Integer, charsUbound As Integer) As Integer
		  // Scans for a complete inline HTML "processing instruction":
		  // A processing instruction consists of the string "<?", a string of 
		  // characters not including the string "?>" and the string "?>".
		  // Assumes `startPos` points at the index in `chars` of the character immediately 
		  // following the opening "<?".
		  // Returns the index in `chars` of the character immediately following the closing "?>" 
		  // or 0 if no match is found.
		  
		  // Min valid format: <??>
		  If startPos + 2 > charsUbound Then Return 0
		  
		  For i As Integer = startPos To charsUbound
		    If chars(i) = "?" And i + 1 <= charsUbound And chars(i + 1) = ">" Then
		      Return i + 2
		    ElseIf chars(i) = &u000A Then
		      Return 0
		    End If
		  Next i
		  
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function SkipWhitespace(chars() As Text, charsUbound As Integer, ByRef pos As Integer, ByRef currentChar As Text) As Boolean
		  Dim matched As Boolean = False
		  
		  While IsWhitespace(currentChar) And pos < charsUbound
		    pos = pos + 1
		    currentChar = chars(pos)
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod


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
