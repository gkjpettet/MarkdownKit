#tag Class
Protected Class Utilities
	#tag Method, Flags = &h0
		Shared Function CharInHeaderLevelRange(c As Text) As Boolean
		  // Returns True if `c` is 1, 2, 3, 4, 5 or 6.
		  
		  Select Case c
		  Case "1", "2", "3", "4", "5", "6"
		    Return True
		  Else
		    Return False
		  End Select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsASCIIAlphaChar(c As Text) As Boolean
		  // Returns True if the passed character `c` is A-Z or a-z.
		  
		  For Each codePoint As UInt32 In c.Codepoints
		    Select Case codePoint
		    Case 65 To 90, 97 To 122
		      Return True
		    Else
		      Return False
		    End Select
		  Next codePoint
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsDigit(c As Text) As Boolean
		  // Returns True if the passed character `c` a digit 0-9.
		  
		  For Each codePoint As UInt32 In c.Codepoints
		    Select Case codePoint
		    Case 48 To 57
		      Return True
		    Else
		      Return False
		    End Select
		  Next codePoint
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsHexDigit(c As Text) As Boolean
		  // Returns True if the passed character `c` is A-F, a-f or 0-9.
		  
		  For Each codePoint As UInt32 In c.Codepoints
		    Select Case codePoint
		    Case 65 To 70, 97 To 102, 48 To 57
		      Return True
		    Else
		      Return False
		    End Select
		  Next codePoint
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsPunctuation(char As Text) As Boolean
		  Select Case char
		  Case "!", """", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", _
		    "/", ":", ";", "<", "=", ">", "?", "@", "[", "\", "]", "^", "_", "`", _
		    "{", "|", "}", "~"
		    Return True
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsUppercaseASCIIChar(c As Text) As Boolean
		  // Returns True if the passed character `c` is an uppercase ASCII character.
		  
		  For Each codePoint As UInt32 In c.Codepoints
		    Select Case codePoint
		    Case 65 To 90
		      Return True
		    Else
		      Return False
		    End Select
		  Next codePoint
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsWhitespace(char As Text, nonBreakingSpaceIsWhitespace As Boolean = False) As Boolean
		  // Returns True if the passed character is whitespace.
		  // If the optional `nonBreakingSpaceIsWhitespace` is True then we also 
		  // consider a non-breaking space (&u0A0) to be whitespace.
		  
		  Select Case char
		  Case &u0020, &u0009, &u000A, ""
		    Return True
		  Else
		    If nonBreakingSpaceIsWhitespace And char = &u00A0 Then
		      Return True
		    Else
		      Return False
		    End If
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub ReplaceEntities(chars() As Text)
		  // Scans the characters in the passed array of characters for valid entity and numeric character 
		  // references.
		  // If one is found, the characters representing the reference are replaced with the 
		  // corresponding unicode character.
		  // The document https://html.spec.whatwg.org/multipage/entities.json is used as an authoritative 
		  // source for the valid entity references and their corresponding code points.
		  
		  // Entity reference: 
		  // "&", a valid HTML5 entity name, ";"
		  
		  // Decimal numeric character reference:
		  // &#[0-9]{1–7};
		  // Invalid Unicode code points will be replaced by the REPLACEMENT CHARACTER (&uFFFD). 
		  // For security reasons, the code point &u0000 will also be replaced by &uFFFD.
		  
		  // Hexadecimal numeric character reference:
		  // &#[Xx][a-fA-F0-9]{1-6};
		  
		  // Quick check to see if we can bail early.
		  Dim start As Integer = chars.IndexOf("&")
		  If start = -1 Or chars.IndexOf(";") = -1 Then Return
		  
		  Dim c As Text
		  Dim tmp() As Text
		  Dim i As Integer = start
		  Dim xLimit As Integer
		  While i < chars.Ubound
		    Redim tmp(-1)
		    c = chars(i)
		    
		    // Expect &
		    If chars(i) <> "&" Then Return
		    
		    i = i + 1
		    If i > chars.Ubound Then Return
		    c = chars(i)
		    
		    If c = "#" Then
		      i = i + 1
		      If i > chars.Ubound Then Return
		      c = chars(i)
		      
		      If c = "X" Then
		        // Hex reference?
		        xLimit = Xojo.Math.Min(chars.Ubound, i + 7)
		        If i + 1 > chars.Ubound Then Return
		        For x As Integer = i + 1 To xLimit
		          c = chars(x)
		          If Utilities.IsHexDigit(c) Then
		            tmp.Append(c)
		          ElseIf c = ";" Then
		            Exit
		          Else
		            // Any other potential references?
		            start = chars.IndexOf("&", i)
		            If start = -1 Then
		              Return
		            Else
		              i = start
		              Continue While
		            End If
		          End If
		        Next x
		        // `tmp` contains the hex value of the codepoint.
		        // Remove the characters in `chars` that make up this reference.
		        For x As Integer = 1 To tmp.Ubound + 5
		          chars.Remove(start)
		        Next x
		        chars.Insert(start, Text.FromUnicodeCodepoint(Integer.FromHex(Text.Join(tmp, ""))))
		        
		        // Any other potential references?
		        start = chars.IndexOf("&")
		        If start = -1 Then
		          Return
		        Else
		          i = start
		          Continue While
		        End If
		      ElseIf Utilities.IsDigit(c) Then
		        // Decimal reference?
		        xLimit = Xojo.Math.Min(chars.Ubound, i + 6)
		        If i + 1 > chars.Ubound Then Return
		        For x As Integer = i To xLimit
		          c = chars(x)
		          If Utilities.IsDigit(c) Then
		            tmp.Append(c)
		          ElseIf c = ";" Then
		            Exit
		          Else
		            // Any other potential references?
		            start = chars.IndexOf("&", i)
		            If start = -1 Then
		              Return
		            Else
		              i = start
		              Continue While
		            End If
		          End If
		        Next x
		        // `tmp` contains the decimal value of the codepoint.
		        // Remove the characters in `chars` that make up this reference.
		        For x As Integer = 1 To tmp.Ubound + 4
		          chars.Remove(start)
		        Next x
		        chars.Insert(start, Text.FromUnicodeCodepoint(Integer.FromText(Text.Join(tmp, ""))))
		        
		        // Any other potential references?
		        start = chars.IndexOf("&")
		        If start = -1 Then
		          Return
		        Else
		          i = start
		          Continue While
		        End If
		        
		      Else
		        start = chars.IndexOf("&", i)
		        If start = -1 Then
		          Return
		        Else
		          i = start
		          Continue While
		        End If
		      End If
		      
		    ElseIf Utilities.IsASCIIAlphaChar(c) Then
		      // Entity reference?
		      
		    Else
		      // Any other potential references?
		      start = chars.IndexOf("&", i)
		      If start = -1 Then
		        Return
		      Else
		        i = start
		      End If
		    End If
		    
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub Unescape(ByRef t As Text)
		  // Converts backslash escaped characters in the passed Text object to their 
		  // literal character value.
		  // Mutates the original value.
		  
		  If t.IndexOf("\") = -1 Then Return
		  
		  Dim chars() As Text = t.Split
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
		  
		  t = Text.Join(chars, "")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub Unescape(chars() As Text)
		  // Converts backslash escaped characters to their literal character value.
		  // Mutates alters the passed array.
		  
		  If chars.IndexOf("\") = -1 Then Return
		  
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
