#tag Class
Protected Class MKInlineLinkData
	#tag Method, Flags = &h0
		Sub Constructor(isInlineImage As Boolean)
		  Self.IsInlineImage = isInlineImage
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206368617261637465727320726570726573656E74696E67207468697320696E6C696E65206C696E6B2773204C696E6B54657874206F722C20696620616E20696E6C696E6520696D6167652C20697427732022616C7422206465736372697074696F6E2E
		Characters() As MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0
		Destination As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520706F736974696F6E20696E2074686520636F6E7461696E6572277320604368617261637465727360206172726179206F662074686520636C6F73696E6720225D222E
		EndPosition As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 547275652069662074686973206C696E6B206461746120726570726573656E747320616E20696E6C696E6520696D6167652E
		IsInlineImage As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Label As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Start As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		Title As String
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
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EndPosition"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Label"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Destination"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsInlineImage"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
