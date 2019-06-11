#tag Class
Protected Class ScannerCharacterMatcher
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetHtmlTagName(chars() As Text, ByRef pos As Integer, tagName As Text) As Text
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
