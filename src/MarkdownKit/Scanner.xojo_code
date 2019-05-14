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
