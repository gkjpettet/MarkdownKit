#tag Class
Protected Class MKLinkScanner
	#tag Method, Flags = &h21, Description = 5072697661746520746F2070726576656E7420696E7374616E746174696F6E2E
		Private Sub Constructor()
		  /// Private to prevent instantation.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 547269657320746F2070617273652061206C696E6B2064657374696E6174696F6E20696E205B63686172735D20626567696E6E696E67206174205B706F735D2E2049662061626C652069742072657475726E7320547275652C2075706461746573205B706F735D20746F2074686520656E64206F66207468652064657374696E6174696F6E20616E6420706F70756C61746573205B646174615D2E
		Shared Function ParseLinkDestination(chars() As String, ByRef pos As Integer, ByRef data As Dictionary) As Boolean
		  /// Tries to parse a link destination in [chars] beginning at [pos]. If able it returns True, 
		  /// updates [pos] to the end of the destination and populates [data].
		  ///
		  /// Sets [data.Value("linkDestination")] to the link destination (if found).
		  /// Sets [data.Value("linkDestinationStart")] to the original value of [pos].
		  /// Note that [pos] is passed ByRef.
		  ///
		  /// A "link destination" consists of either:
		  /// 1. >= 0 characters between an opening `<` and a closing `>` that contains no line endings or 
		  ///    unescaped `<` or `>` characters, or
		  /// 2. > 0 characters that does not start with `<`, does not include ASCII control characters or space 
		  /// character, and includes parentheses only if:
		  ///    (a) they are backslash-escaped
		  ///    (b) they are part of a balanced pair of unescaped parentheses. At least 3 levels must be supported.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  If pos > charsLastIndex Then Return False
		  
		  data = New Dictionary
		  Var i As Integer
		  Var c As String
		  Var startPos As Integer = pos
		  
		  // Scenario 1:
		  If chars(pos) = "<" Then
		    i = pos + 1
		    While i <= charsLastIndex
		      c = chars(i)
		      If c = ">" And Not IsMarkdownEscaped(chars, i) Then
		        data.Value("linkDestination") = StringKit.FromArray(chars, pos + 1, i - pos - 2)
		        data.Value("linkDestinationStart") = startPos
		        pos = i
		        Return True
		      End If
		      If c = "<" And Not IsMarkdownEscaped(chars, i) Then Return False
		      i = i + 1
		    Wend
		    Return False
		  End If
		  
		  // Scenario 2:
		  Var openParensCount, closeParensCount As Integer = 0
		  For i = pos To charsLastIndex
		    c = chars(i)
		    Select Case c
		    Case "("
		      If Not IsMarkdownEscaped(chars, i) Then openParensCount = openParensCount + 1
		    Case ")"
		      If Not IsMarkdownEscaped(chars, i) Then closeParensCount = closeParensCount + 1
		    Case &u0000, &u0009
		      Return False
		    Case " "
		      If openParensCount <> closeParensCount Then
		        Return False
		      Else
		        data.Value("linkDestination") = StringKit.FromArray(chars, pos, i - pos)
		        data.Value("linkDestinationStart") = startPos
		        pos = i
		        Return True
		      End If
		    End Select
		  Next i
		  
		  If openParensCount <> closeParensCount Then
		    Return False
		  Else
		    data.Value("linkDestination") = StringKit.FromArray(chars, pos)
		    data.Value("linkDestinationStart") = startPos
		    pos = i
		    Return True
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 547269657320746F2070617273652061206C696E6B206C6162656C20696E205B63686172735D20626567696E6E696E67206174205B706F735D2E2049662061626C652069742072657475726E7320547275652C2075706461746573205B706F735D20746F2074686520656E64206F6620746865206C6162656C20616E6420706F70756C61746573205B646174615D2E
		Shared Function ParseLinkLabel(chars() As String, ByRef pos As Integer, ByRef data As Dictionary) As Boolean
		  /// Tries to parse a link label in [chars] beginning at [pos]. If able it returns True, updates [pos] to 
		  /// the end of the label and populates [data].
		  ///
		  /// Sets [data.Value("linkLabel")] to the link label (if found).
		  /// Sets [data.Value("linkLabelStart")] to the original [pos] value.
		  /// Note that [pos] is passed ByRef.
		  ///
		  /// A "link label" begins with a left bracket (`[`) and ends with the first right bracket (`]`) that is not 
		  /// backslash-escaped. 
		  /// Between these brackets there must be at least one character that is not a space, tab, or line ending. 
		  /// Unescaped square bracket characters are not allowed inside the opening and closing square brackets of 
		  /// link labels. A link label can have at most 999 characters inside the square brackets.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  If pos + 3 > charsLastIndex Then Return False
		  If chars(pos) <> "[" Then Return False
		  
		  data = New Dictionary
		  
		  Var labelStart As Integer = pos
		  
		  Var limit As Integer = Min(chars.LastIndex, MarkdownKit.MAX_REFERENCE_LABEL_LENGTH + 1)
		  Var seenNonWhitespace As Boolean = False
		  For i As Integer = pos + 1 To limit
		    Select Case chars(i)
		    Case "["
		      // Unescaped square brackets are not allowed.
		      If Not IsMarkdownEscaped(chars, i) Then Return False
		      seenNonWhitespace = True
		    Case "]"
		      If IsMarkdownEscaped(chars, i) Then
		        seenNonWhitespace = True
		        Continue
		      ElseIf seenNonWhitespace Then
		        // This is the end of a valid label.
		        data.Value("linkLabel") = StringKit.FromArray(chars, pos + 1, i - pos - 1)
		        data.Value("linkLabelStart") = labelStart
		        pos = i
		        Return True
		      Else // No non-whitespace characters in this label.
		        Return False
		      End If
		    Else
		      // A valid label needs at least one non-whitespace character.
		      If Not seenNonWhitespace Then seenNonWhitespace = Not chars(i).IsMarkdownWhitespace
		    End Select
		  Next i
		  
		  // No valid label found.
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 547269657320746F2070617273652061206C696E6B207469746C6520696E205B63686172735D20626567696E6E696E67206174205B706F735D2E2049662061626C652069742072657475726E7320547275652C2075706461746573205B706F735D20746F2074686520656E64206F6620746865206C696E6B207469746C6520616E6420706F70756C61746573205B646174615D2E
		Shared Function ParseLinkTitle(chars() As String, ByRef startPos As Integer, ByRef data As Dictionary) As Boolean
		  /// Tries to parse a link title in [chars] beginning at [pos]. If able it returns True, updates [pos] to 
		  /// the end of the link title and populates [data].
		  ///
		  /// Sets [data.Value("linkTitle")] to the link title (if found).
		  /// Sets [data.Value("linkTitleStart")] to the original value of [pos].
		  /// Note that [pos] is passed ByRef.
		  ///
		  /// A "link title" consists of either:
		  /// 1. >= 0 characters between `"` characters, including a `"` character only if it is backslash-escaped.
		  /// 2. >= 0 characters between `'` characters, including a `'` character only if it is backslash-escaped
		  /// 3. >= 0 characters between matching parentheses, including a `(` or `)` only if it's backslash-escaped.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Sanity check.
		  If startPos < 0 Or startPos > charsLastIndex Or (startPos + 1) > charsLastIndex Then Return False
		  
		  data = New Dictionary
		  
		  Var c As String = chars(startPos)
		  Var delimiter As String
		  Select Case c
		  Case """", "'"
		    delimiter = c
		  Case "("
		    delimiter = ")"
		  End Select
		  
		  For i As Integer = startPos + 1 To charsLastIndex
		    c = chars(i)
		    If c = delimiter And Not IsMarkdownEscaped(chars, i) Then
		      data.Value("linkTitle") = StringKit.FromArray(chars, startPos + 1, i - startPos - 1)
		      data.Value("linkTitleStart") = startPos
		      startPos = i
		      Return True
		    End If
		  Next i
		  
		  Return False
		  
		End Function
	#tag EndMethod


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
