#tag Class
Protected Class Scanner
	#tag Method, Flags = &h0
		Shared Function ParseListMarker(chars() As Text, pos As Integer, interruptsParagraph As Boolean, ByRef data As MarkdownKit.ListData, ByRef length As Integer) As Integer
		  // Attempts to parse a ListItem marker (bullet or enumerated).
		  // On success, it returns the length of the marker, and populates
		  // data with the details.  On failure it returns 0.
		  // Also populates the ByRef `length` parameter to the computed length.
		  
		  '#Pragma Error "Example 255 fails"
		  
		  Dim c As Text
		  Dim startPos As Integer
		  data = Nil
		  length = 0
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  If pos > charsUbound Then Return 0
		  
		  startPos = pos
		  c = chars(pos)
		  
		  If c = "+" Or c = "•" Or ((c = "*" Or c = "-") And _
		    0 = Scanner.ScanThematicBreak(chars, pos)) Then
		    pos = pos + 1
		    
		    If pos <= charsUbound And Not IsWhitespace(chars(pos)) Then Return 0
		    
		    // If interruptsParagraph And _
		    // Scanner.ScanSpaceChars(chars, pos + 1) = (charsUbound + 1) - pos - 1 Then Return 0
		    If interruptsParagraph And _
		    Scanner.ScanSpaceChars(chars, pos + 1) = (charsUbound + 1) - pos Then Return 0
		    
		    data = New MarkdownKit.ListData
		    data.BulletChar = c
		    data.Start = 1
		    
		  ElseIf c = "0" Or c = "1" Or c = "2" Or c = "3" Or c = "4" Or c = "5" Or _
		    c = "6" Or c = "7" Or c = "8" Or c = "9" Then
		    Dim numDigits As Integer = 0
		    Dim startText As Text
		    Dim limit As Integer = Min(chars.Ubound, startPos + 8)
		    For i As Integer = startPos To limit
		      c = chars(i)
		      Select Case c
		      Case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
		        // Max 9 digits to avoid integer overflows in some browsers.
		        If numDigits = 9 Then Return 0
		        numDigits = numDigits + 1
		        startText = startText + c
		      Else
		        Exit
		      End Select
		    Next i
		    Dim start As Integer = Integer.FromText(startText)
		    pos = pos + numDigits
		    // pos now points to the character after the last digit.
		    If pos > charsUbound Then Return 0
		    
		    // Need to find a period or parenthesis.
		    c = chars(pos)
		    If c <> "." And c <> ")" Then Return 0
		    pos = pos + 1
		    
		    // The next character must be whitespace (unless this is the EOL).
		    If pos <= charsUbound And Not IsWhiteSpace(chars(pos)) Then Return 0
		    
		    // If interruptsParagraph And _
		    // (start <> 1 Or _
		    // Scanner.ScanSpaceChars(chars, pos + 1) = (charsUbound + 1) - pos - 1) Then
		    // Return 0
		    // End If
		    If interruptsParagraph And _
		      (start <> 1 Or _
		      Scanner.ScanSpaceChars(chars, pos + 1) = (charsUbound + 1) - pos) Then
		      Return 0
		    End If
		    
		    data = New MarkdownKit.ListData
		    data.ListType = MarkdownKit.ListType.Ordered
		    data.BulletChar = ""
		    data.Start = start
		    data.ListDelimiter = If(c = ".", _
		    MarkdownKit.ListDelimiter.Period, MarkdownKit.ListDelimiter.Parenthesis)
		  Else
		    Return 0
		    
		  End If
		  
		  length = pos - startPos
		  Return pos - startPos
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanATXHeadingStart(chars() As Text, pos As Integer, ByRef headingLevel As Integer, ByRef length As Integer) As Integer
		  // Checks to see if there is a valid ATX heading start.
		  // We are passed the characters of the line as an array and the position we 
		  // should consider to be the first character. 
		  // The method assumes that leading spaces have been skipped over during 
		  // calculation of `pos` so the first character should be a #.
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  // Reset the ByRef variables.
		  length = 0
		  headingLevel = 0
		  
		  // Sanity check.
		  If pos > charsUbound Then Return 0
		  If chars(pos) <> "#" Then Return 0
		  
		  // An ATX heading consists of a string of characters, starting with an 
		  // opening sequence of 1–6 unescaped # characters.
		  Dim i As Integer
		  For i = pos To charsUbound
		    If chars(i) = "#" Then
		      headingLevel = headingLevel + 1
		      If headingLevel > 6 Then Return 0
		    Else
		      Exit
		    End If
		  Next i
		  If headingLevel = 0 Then Return 0
		  
		  // The opening sequence of #s must be followed by a space, a tab or the EOL.
		  If (pos + headingLevel) > charsUbound Then
		    length = headingLevel
		    Return length
		  ElseIf chars(pos + headingLevel) = " " Or chars(pos + headingLevel) = &u0009 Then
		    // This is a valid opening sequence. Keep consuming whitespace to determine 
		    // the full length of the opening sequence.
		    length = headingLevel
		    For i = pos + headingLevel To charsUbound
		      Select Case chars(i)
		      Case " ", &u0009
		        length = length + 1
		      Else
		        Exit
		      End Select
		    Next i
		    Return length
		  Else
		    Return 0
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanCloseCodeFence(chars() As Text, pos As Integer, length As Integer) As Integer
		  // Scan for a closing fence of at least length `length`.
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  If pos + (length - 1) > charsUbound Then Return 0
		  
		  Dim c1 As Text = chars(pos)
		  If c1 <> "`" And c1 <> "~" Then Return 0
		  
		  Dim cnt As Integer = 1
		  Dim spaces As Boolean = False
		  
		  Dim i As Integer
		  Dim c As Text
		  For i = pos + 1 To charsUbound
		    c = chars(i)
		    
		    If c = c1 And Not spaces Then
		      cnt = cnt + 1
		    ElseIf c = " " Then
		      spaces = True
		    Else
		      Return 0
		    End If
		  Next i
		  
		  Return If(cnt < length, 0, cnt)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanOpenCodeFence(chars() As Text, pos As Integer, ByRef length As Integer) As Integer
		  // Scans the passed array of characters for an opening code fence.
		  // Returns the length of the fence if found (0 if not found).
		  // Additionally mutates the ByRef `length` variable to the length of the 
		  // found (or not found) code fence length.
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  length = 0
		  
		  If pos + 2 > charsUbound Then Return 0
		  
		  Dim fchar As Text = chars(pos)
		  If fchar <> "`" And fchar <> "~" Then Return 0
		  
		  length = 1
		  Dim fenceDone As Boolean = False
		  
		  Dim i As Integer
		  Dim c As Text
		  For i = pos + 1 to charsUbound
		    c = chars(i)
		    
		    If c = fchar Then
		      If fenceDone Then
		        // Backticks are permitted in tilde-declared fences.
		        If fchar = "~" Then Continue 
		        Return 0
		      End If
		      length = length + 1
		      Continue
		    End If
		    
		    fenceDone = True
		    If length < 3 Then Return 0
		    
		    If c = "" Then Return length
		  Next i
		  
		  If length < 3 Then Return 0
		  
		  Return length
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanSetextHeadingLine(chars() As Text, pos As Integer, ByRef level As Integer) As Integer
		  // Attempts to match a setext heading line. 
		  // Returns the heading level (1 or 2) or 0 if this is not a setext heading line.
		  // We also set the ByRef `level` variable to the heading level or 0.
		  ' ^[=]+[ ]*$
		  ' ^[-]+[ ]*$
		  
		  // Reset the ByRef parameter.
		  level = 0
		  
		  Dim charsUbound As Integer = chars.Ubound
		  If pos > charsUbound Then Return 0
		  
		  Dim c As Text = chars(pos)
		  Dim stxChar As Text
		  If c <> "=" And c <> "-" Then
		    Return 0
		  Else
		    stxChar = c
		  End If
		  If pos + 1 > charsUbound Then
		    level = If(c = "=", 1, 2)
		    Return level
		  End If
		  
		  Dim i As Integer
		  Dim done As Boolean = False
		  For i = pos + 1 To charsUbound
		    c = chars(i)
		    
		    If c = stxChar And Not Done Then Continue
		    
		    // Not a  "=" or "-" character.
		    done = True
		    
		    If c = " " Or c = &u0009 Then Continue
		    
		    level = 0
		    Return 0
		  Next i
		  
		  level = If(c = "=", 1, 2)
		  Return level
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanSpaceChars(chars() As Text, pos As Integer) As Integer
		  // Match space and tab characters.
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  If pos > charsUbound Then Return 0
		  
		  Dim i As Integer
		  For i = pos To charsUbound
		    If Not IsWhiteSpace(chars(pos)) Then Return i - pos
		  Next i
		  
		  Return (charsUbound + 1)- pos
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanThematicBreak(chars() As Text, pos As Integer) As Integer
		  // Scan for a thematic break line.
		  // Valid thematic break lines consist of >= 3 dashes, underscores or asterixes 
		  // which may be optionally separated by any amount of spaces or tabs whitespace.
		  // The characters must match.
		  ' ^([-][ ]*){3,}[\s]*$"
		  ' ^([_][ ]*){3,}[\s]*$"
		  ' ^([\*][ ]*){3,}[\s]*$"
		  // Returns the length of the matching thematic break.
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  Dim count As Integer = 0
		  Dim i As Integer
		  Dim c, tbChar As Text
		  
		  For i = pos To charsUbound
		    c = chars(i)
		    If c = " " Or c = &u0009 Then
		      Continue
		    ElseIf count = 0 Then
		      Select Case c
		      Case "-", "_", "*"
		        tbChar = c
		        count = count + 1
		      Else
		        Return 0
		      End Select
		    ElseIf c = tbChar Then
		      count = count + 1
		    Else
		      Return 0
		    End If
		  Next i
		  
		  If count < 3 Then
		    Return 0
		  Else
		    Return charsUbound + 1 - pos
		  End If
		  
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
