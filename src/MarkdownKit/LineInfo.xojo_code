#tag Class
Protected Class LineInfo
	#tag Method, Flags = &h0
		Sub Constructor(lineContent As Text, lineNumber As Integer)
		  Self.Chars = lineContent.Split
		  Self.Number = lineNumber
		  Self.CharsUbound = Self.Chars.Ubound
		  IsEmpty = If(lineContent = "", True, False)
		  
		  If IsEmpty Then
		    // Empty lines are also considered blank lines.
		    IsBlank = True
		    // Nothing more to do for blank lines.
		    Return
		  End If
		  
		  // A line containing no characters, or a line containing only spaces (U+0020) 
		  // or tabs (U+0009), is considered a blank line.
		  IsBlank = True
		  For i As Integer = 0 To CharsUbound
		    If Chars(i) <> &u0020 And Chars(i) <> &u0009 Then
		      IsBlank = False
		      Exit
		    End If
		  Next i
		  
		  // A line that begins with a tab or at least 4 contiguous spaces is indented.
		  Indented = False
		  If Chars(0) = &u0009 Then
		    Indented = True
		  Else
		    Dim count As Integer = 0
		    Dim limit As Integer = Min(CharsUbound, 3)
		    For i As Integer = 0 To limit
		      If Chars(i) = &u0009 Then
		        Indented = True
		        Exit
		      ElseIf Chars(i) = " " Then
		        count = count + 1
		        If count = 4 Then
		          Indented = True
		          Exit
		        End If
		      Else
		        Exit
		      End If
		    Next i
		  End If
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Chars() As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		CharsUbound As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		Indented As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		IsBlank As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0
		IsEmpty As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F6E652D6261736564206C696E65206E756D62657220696E20746865206F726967696E616C204D61726B646F776E20736F7572636520746861742074686973204C696E65496E666F20646572697665642066726F6D
		#tag Note
			Zero-based.
		#tag EndNote
		Number As Integer = 1
	#tag EndProperty


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
		#tag ViewProperty
			Name="Number"
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CharsUbound"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsEmpty"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsBlank"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
