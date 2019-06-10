#tag Class
Protected Class InlineScanner
	#tag Method, Flags = &h0
		Shared Sub CleanLinkLabel(chars() As Text)
		  // Cleans up a label parsed by ScanLinkLabel by removing the flanking [].
		  // Mutates the passed array.
		  
		  chars.Remove(0)
		  Call chars.Pop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub CleanLinkTitle(chars() As Text)
		  // Takes an array of characters representing a link title that has been parsed by ScanLinkTitle().
		  // Removes surrounding delimiters and replaces character references.
		  // NB: Does NOT unescape special characters.
		  // Mutates the passed array.
		  
		  // Remove the flanking delimiters.
		  chars.Remove(0)
		  Call chars.Pop
		  
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

	#tag Method, Flags = &h0
		Shared Sub CollapseInternalWhitespace(chars() As Text)
		  // Collapses consecutive whitespace within the passed character array to a single space.
		  // Mutates the passed array.
		  
		  Dim i As Integer = 0
		  Dim collapse As Boolean = False
		  Dim c As Text
		  While i < chars.Ubound
		    c = chars(i)
		    
		    If IsWhitespace(c) Then
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
		          result.Finish = i
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
		    result.Length = charsUbound - startPos
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
		      If Not seenNonWhitespace Then seenNonWhitespace = Not IsWhitespace(chars(i))
		    End Select
		  Next i
		  
		  // No valid label found.
		  Return result
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
