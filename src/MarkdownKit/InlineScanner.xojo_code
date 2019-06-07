#tag Class
Protected Class InlineScanner
	#tag Method, Flags = &h0
		Shared Sub CleanURL(chars() As Text)
		  // Takes an array of characters representing a URL that has been parsed by ScanLinkURL().
		  // Removes surrounding whitespace, surrounding "<" and ">" and removes any 
		  // escaping "\" characters.
		  // Mutates the passed array.
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  If charsUbound = -1 Then Return
		  
		  // Remove flanking whitespace.
		  StripLeadingWhitespace(chars)
		  StripTrailingWhitespace(chars)
		  
		  // If the URL has flanking < and > characters, remove them.
		  If charsUbound >=1 And chars(0) = "<" And chars(charsUbound - 1) = ">" Then
		    chars.Remove(0)
		    Call chars.Pop
		  End If
		  
		  Unescape(chars)
		  ReplaceCharacterReferences(chars)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Escaped(chars() As Text, pos As Integer) As Boolean
		  // Returns True if the character at zero-based position `pos` is escaped.
		  // I.e: is preceded by a backslash character.
		  
		  If pos > chars.Ubound or pos = 0 Then Return False
		  
		  Return If(chars(pos - 1) = "\", True, False)
		  
		End Function
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

	#tag Method, Flags = &h0
		Shared Function ScanLinkDestination(chars() As Text, startPos As Integer) As MarkdownKit.CharacterRun
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
		  
		  Dim charsUbound As Integer = chars.Ubound
		  Dim i As Integer
		  Dim c As Text
		  
		  Dim result As New MarkdownKit.CharacterRun(startPos, -1)
		  
		  // Scenario 1:
		  If chars(startPos) = "<" Then
		    i = startPos + 1
		    While i <= charsUbound
		      c = chars(i)
		      If c = ">" And Not Escaped(chars, i) Then
		        result.Length = i - startPos + 1
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
		    Case &u0000, &u0009, &u000A
		      Return result
		    Case " "
		      If openParensCount <> closeParensCount Then
		        Return result
		      Else
		        result.Length = i - startPos
		        Return result
		      End If
		    End Select
		  Next i
		  
		  If openParensCount <> closeParensCount Then
		    Return result
		  Else
		    result.Length = charsUbound - startPos
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
		  
		  Dim result As New MarkdownKit.CharacterRun(0, -1)
		  
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
		        Return result
		      Else // No non-whitespace characters in this label.
		        Return result
		      End If
		    Else
		      // A valid label needs at least one non-whitespace character.
		      If Not seenNonWhitespace Then seenNonWhitespace = Not IsWhitespace(chars(i))
		    End Select
		  Next i
		  
		  // No valid label found.
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub ScanLinkReferenceDefinition(chars() As Text, doc As MarkdownKit.Document)
		  // Takes an array of characters representing the raw text of a paragraph.
		  // Assumes that there are at least 4 characters and chars(0) = "[".
		  // If we find a valid link reference definition then we remove it from the 
		  // character array (which is passed by reference) and we add it to the passed 
		  // Document's reference map dictionary.
		  // If we don't find a valid reference then we leave chars alone.
		  // Assumes doc <> Nil.
		  
		  Dim charsUbound As Integer = chars.Ubound
		  Dim pos As Integer = 0
		  
		  // Parse the label.
		  Dim label As New MarkdownKit.CharacterRun
		  label = InlineScanner.ScanLinkLabel(chars)
		  If label.Length = -1 Then Return // Invalid.
		  
		  pos = label.Start + label.Length
		  If pos > charsUbound Then Return
		  
		  // Colon?
		  If chars(pos) <> ":" Then
		    Return
		  Else
		    pos = pos + 1
		    If pos > charsUbound Then Return
		  End If
		  
		  // Advance optional whitespace following the colon (including up to one newline).
		  Dim i As Integer
		  Dim seenNewline As Boolean = False
		  For i = pos To charsUbound
		    Select Case chars(i)
		    Case &u000A
		      If seenNewline Then Return // Invalid.
		      seenNewline = True
		    Case " ", &u0009
		      Continue
		    Else
		      Exit
		    End Select
		  Next i
		  pos = i
		  
		  // Parse the link destination.
		  Dim destination As MarkdownKit.CharacterRun = ScanLinkDestination(chars, pos)
		  If destination.Length = -1 Then Return // Invalid.
		  
		  // Convert the destination URL character run to an array of characters.
		  Dim url() As Text = destination.ToArray(chars)
		  
		  // Clean the URL.
		  CleanURL(url)
		  
		  // Parse optional link title.
		  pos = pos + destination.Length
		  If pos = charsUbound Then GoTo Done // No title.
		  
		  // Advance optional whitespace following the destination (including up to one newline).
		  seenNewline = False
		  For i = pos To charsUbound
		    Select Case chars(i)
		    Case &u000A
		      If seenNewline Then Return // Invalid.
		      seenNewline = True
		    Case " ", &u0009
		      Continue
		    Else
		      Exit
		    End Select
		  Next i
		  pos = i
		  
		  If pos = charsUbound Then GoTo Done // No title.
		  Dim titleCR As MarkdownKit.CharacterRun = ScanLinkTitle(chars, pos)
		  If titleCR.Length = -1 Then Return // Invalid.
		  
		  // Convert the title to an array of characters.
		  Dim title() As Text = titleCR.ToArray(chars)
		  
		  // Unescape and substitute character references in the title.
		  Unescape(title)
		  ReplaceCharacterReferences(title)
		  
		  // Ensure that there are no further non-whitespace characters on this line.
		  pos = pos + titleCR.Length
		  If pos < charsUbound Then
		    For i = pos To charsUbound
		      If Not IsWhitespace(chars(i)) Then Return
		    Next i
		  End If
		  
		  Done:
		  
		End Sub
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
		  
		  Dim result As New MarkdownKit.CharacterRun(0, -1)
		  
		  Dim charsUbound As Integer = chars.Ubound
		  
		  // Sanity check.
		  If startPos < 0 Or startPos > charsUbound Or _
		    (startPos + 1) > charsUbound Then
		    Return result
		  End If
		  
		  #Pragma Error "Needs finishing"
		  // Dim c As Text = chars(startPos)
		  // If c = """" Then
		  // 
		  // ElseIf c = "'" Then
		  // 
		  // ElseIf c = "(" Then
		  // 
		  // Else // Invalid starting character.
		  // Return result
		  // End If
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
