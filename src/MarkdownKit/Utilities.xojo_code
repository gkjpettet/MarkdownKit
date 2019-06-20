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
		Shared Function IsWhitespace(char As Text) As Boolean
		  Select Case char
		  Case " ", &u0009, &u000A, ""
		    Return True
		  Else
		    Return False
		  End Select
		  
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
