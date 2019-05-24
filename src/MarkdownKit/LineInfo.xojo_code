#tag Class
Protected Class LineInfo
	#tag Method, Flags = &h0
		Sub Constructor(lineText As Text, lineNumber As Integer)
		  Value = lineText
		  Chars = lineText.Split
		  CharsUbound = Chars.Ubound
		  Number = lineNumber
		  
		  IsEmpty = If(Value = "", True, False)
		  
		  If IsEmpty Then
		    IsBlank = True
		    Return
		  End If
		  
		  // A line containing no characters, or a line containing only spaces or
		  // tabs, is considered blank (spec 0.29 2.1).
		  Dim i As Integer
		  IsBlank = True
		  For i = 0 To CharsUbound
		    Select Case Chars(i)
		    Case &u0020, &u0009
		      // Keep searching.
		    Else
		      IsBlank = False
		    End Select
		  Next i
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 416E206172726179206F662074686520696E646976696475616C2063686172616374657273206F662074686973206C696E652E
		Chars() As Text
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520757070657220626F756E6473206F662074686973206C696E6527732043686172732061727261792E20
		CharsUbound As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 41206C696E6520697320636F6E7369646572656420626C616E6B20696620697420697320656D707479206F72206F6E6C7920636F6E7461696E7320776869746573706163652E
		IsBlank As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662074686973206C696E6520636F6E7461696E73206E6F207465787420617420616C6C2C20697420697320636F6E7369646572656420656D7074792E
		IsEmpty As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E65206E756D626572206F662074686973206C696E6520696E20746865206F726967696E616C204D61726B646F776E20736F757263652E204C696E65206E756D6265727320617265206F6E652D62617365642E
		Number As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F726967696E616C20746578742076616C7565206F662074686973206C696E652E
		Value As Text
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
			Name="Value"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
