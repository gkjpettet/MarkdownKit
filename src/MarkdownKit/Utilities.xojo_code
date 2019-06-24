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
