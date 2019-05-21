#tag Class
Protected Class Scanner
	#tag Method, Flags = &h0
		Function ValidAtxHeadingStart(line As MarkdownKit.LineInfo, startPos As Integer, ByRef level As Integer) As Boolean
		  // Returns True if there is a valid ATX heading start in the passed line 
		  // beginning at startPos (zero-based).
		  // Returns False if there's not.
		  // NB: Alters the value of the ByRef `level` parameter, setting it to the 
		  // header level.
		  
		  // Reset the ByRef `level` parameter.
		  level = 0
		  
		  If startPos > line.CharsUbound Or startPos < 0 Then Return False
		  
		  // An ATX heading consists of a string of characters, starting with an 
		  // opening sequence of 1–6 unescaped # characters.
		  Dim i As Integer
		  For i = startPos To line.CharsUbound
		    If line.Chars(i) = "#" Then
		      level = level + 1
		      If level > 6 Then Return False
		    Else
		      Exit
		    End If
		  Next i
		  If level = 0 Then Return False
		  
		  // The opening sequence of # characters must be followed by a space or the EOL.
		  // Add the start position and the number of hashes found together. If that 
		  // equals the last character in the line then the run of hashes must run up 
		  // to the end of the line.
		  If startPos + level = (line.CharsUbound + 1) Then Return True
		  
		  // Is there a space following the run of hashes?
		  If startPos + level > line.CharsUbound Then Return False
		  If line.Chars(startPos + level) = " " Then Return True
		  
		  // Invalid.
		  Return False
		  
		  Exception e As OutOfBoundsException
		    Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidCodeFenceEnd(line As MarkdownKit.LineInfo, startPos As Integer, f As MarkdownKit.FencedCode) As Boolean
		  // Returns True if there is a valid code fence end sequence in the passed line 
		  // beginning at startPos (zero-based).
		  // Returns False if there's not.
		  
		  // Simple checks.
		  If startPos < 0 Or startPos > line.CharsUbound Or _
		  startPos + (f.OpeningLength - 1) > line.CharsUbound Then Return False
		  
		  // make sure the first `f.OpeningLength` characters beginning at `startPos` match the passed 
		  // fenced code block's opening character.
		  Dim i As Integer
		  Dim limit As Integer = startPos + (f.OpeningLength - 1)
		  For i = startPos To limit
		    If line.Chars(i) <> f.OpeningChar Then Return False
		  Next i
		  
		  // If there's nothing else on the line, we're done.
		  If line.CharsUbound = limit then Return True
		  
		  // Since closing sequences can be any number of "`" or "~", we need to skip to the 
		  // position after the last "`" or "~" (if any).
		  Dim lastClosingSequenceCharPos As Integer
		  For i = startPos To line.CharsUbound
		    If line.Chars(i) = f.OpeningChar Then
		      lastClosingSequenceCharPos = i
		    Else
		      Exit
		    End If
		  Next i
		  
		  // Make sure that the only characters left after the closing sequence are spaces.
		  Dim begin As Integer = lastClosingSequenceCharPos + 1
		  If begin > line.CharsUbound Then Return True
		  
		  For i = begin To line.CharsUbound
		    If line.Chars(i) <> " " Then Return False
		  Next i
		  
		  // Must be valid.
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidCodeFenceStart(line As MarkdownKit.LineInfo, startPos As Integer, ByRef infoString As Text, ByRef openingChar As Text, ByRef fenceOffset As Integer, ByRef openingLength As Integer) As Boolean
		  // Returns True if there is a valid code fence start in the passed line 
		  // beginning at startPos (zero-based).
		  // Returns False if there's not.
		  // NB: Alters the value of the ByRef `infoString` parameter, setting it to the 
		  // optional (trimmed) info string.
		  // Is passed (ByRef) a variable to store the character used to open the 
		  // code fence (will be either "`" or "~"). We need this variable because should this 
		  // be a valid opening sequence for a new code fence, we need to know the character 
		  // sequence that triggered the opening so we can subsequently figure out when to close it.
		  // Is passeed (ByRef) an integer variable to store the number of spaces offsetting 
		  // the fence's opening sequence (maximum of 3).
		  // Is passed (ByRef) an integer variable to store the number of "`" or "~" characters 
		  // that make up the opening sequence. This is required because a valid closing sequence 
		  // must contain at least the same number.
		  
		  // Reset the passed ByRef parameters.
		  infoString = ""
		  openingChar = ""
		  fenceOffset = 0
		  openingLength = 0
		  
		  // Simple checks.
		  If startPos > line.CharsUbound Or startPos < 0 Or _
		  (startPos + 2) > line.CharsUbound Then Return False
		  openingChar = line.Chars(startPos)
		  If openingChar <> "`" And openingChar <> "~" Then Return False
		  
		  // Check that at least the next two characters are the same as the first.
		  // Keep scanning the available characters to determine the number of contiguous 
		  // matching characters.
		  Dim i As Integer
		  For i = startPos To line.CharsUbound
		    If line.Chars(i) = openingChar Then
		      openingLength = openingLength + 1
		    Else
		      If openingLength < 3 Then Return False
		      Exit
		    End If
		  Next i
		  
		  // OK. We have `openingLength` matching consecutive opening characters.
		  // Is there an offset to the opening sequence? Up to 3 spaces are allowed to 
		  // prefix the opening sequence. We need to know this as this number of spaces 
		  // will subsequently be removed from all lines of code in the fenced code block.
		  For i = 0 To 2
		    If line.Chars(i) = " " Then
		      fenceOffset = fenceOffset + 1
		    End If
		  Next i
		  
		  // Is there an info string?
		  infoString = ""
		  If line.CharsUbound = startPos + (openingLength - 1) Then
		    // No info string so we're done.
		    Return True
		  End If
		  
		  // Get the info string.
		  Dim begin As Integer = startPos + openingLength
		  Dim tmpText() As Text
		  For i = begin To line.CharsUbound
		    tmpText.Append(line.Chars(i))
		  Next i
		  
		  // Strip leading and trailing whitespace.
		  StripLeadingWhiteSpace(tmpText)
		  StripTrailingWhiteSpace(tmpText)
		  
		  // Backticks are not permitted in info strings unless the opening character is a "~".
		  // If one is present then this is not a valid code fence opening.
		  If openingChar = "`" Then
		    Dim tmpTextUbound As Integer = tmpText.Ubound
		    For i = 0 To tmpTextUbound
		      If tmpText(i) = "`" Then Return False
		    Next i
		  End If
		  
		  // Valid.
		  infoString = Text.Join(tmpText, "")
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidSetextHeadingUnderline(line As MarkdownKit.LineInfo, ByRef level As Integer) As Boolean
		  // Returns True if `line` is a valid Setext heading underline.
		  // NB: Alters the value of the ByRef `level` parameter, setting it to the 
		  // header level.
		  
		  // Reset the ByRef `level` parameter.
		  level = 0
		  
		  If line.IsBlank Then Return False
		  
		  Dim limit As Integer = Min(line.CharsUbound, 2)
		  Dim firstNWSIndex As Integer = 0
		  For i As Integer = 0 To limit
		    If line.Chars(i) = " " Then
		      firstNWSIndex = firstNWSIndex + 1
		    Else
		      Exit
		    End If
		  Next i
		  
		  // Get the underline character.
		  If firstNWSIndex > line.CharsUbound Then Return False
		  Dim underlineChar As Text = line.Chars(firstNWSIndex)
		  If underlineChar <> "=" And underlineChar <> "-" Then Return False
		  
		  // Since valid Setext underlines can have any number of trailing spaces, 
		  // Find the index of the last non-space character.
		  Dim lastNWSIndex As Integer = line.CharsUbound
		  For i As Integer = line.CharsUbound DownTo firstNWSIndex
		    If line.Chars(i) <> " " Then
		      lastNWSIndex = i
		      Exit
		    End If
		  Next i
		  
		  // Check that every character between these two indexes matches the underlineChar.
		  For i As Integer = firstNWSIndex To lastNWSIndex
		    If line.Chars(i) <> underlineChar Then Return False
		  Next i
		  
		  level = If(underlineChar = "=", 1, 2)
		  Return True
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
