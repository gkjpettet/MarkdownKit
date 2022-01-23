#tag Class
Protected Class MKLinkDestination
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(startChar As MKCharacter, value As String, length As Integer, endChar As MKCharacter)
		  Self.StartCharacter = startChar
		  Self.Value = value
		  Self.Length = length
		  Self.EndCharacter = endChar
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		
		Holds data about a link destination required for rendering into source code tokens.
	#tag EndNote


	#tag Property, Flags = &h0, Description = 546865206C61737420636861726163746572206F662074686973206C696E6B2064657374696E6174696F6E2E
		EndCharacter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C656E677468206F66207468652064657374696E6174696F6E2E
		Length As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520666972737420636861726163746572206F662074686973206C696E6B2064657374696E6174696F6E2E
		StartCharacter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520756E65736361706564206C696E6B2064657374696E6174696F6E2E
		Value As String
	#tag EndProperty


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
		#tag ViewProperty
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
