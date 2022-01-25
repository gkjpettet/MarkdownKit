#tag Class
Protected Class MKInlineLinkData
	#tag Method, Flags = &h0
		Sub Constructor(isInlineImage As Boolean, type As MKLinkTypes)
		  Self.IsInlineImage = isInlineImage
		  Self.LinkType = type
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206368617261637465727320726570726573656E74696E67207468697320696E6C696E65206C696E6B2773204C696E6B54657874206F722C20696620616E20696E6C696E6520696D6167652C20697427732022616C7422206465736372697074696F6E2E
		Characters() As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6B20636C6F73696E6720627261636B6574206368617261637465722E20436F6D65732065697468657220616674657220746865206C696E6B206C6162656C206F7220746865206C696E6B20746578742028646570656E64696E67206F6E20746865206C696E6B2074797065292E
		CloserCharacter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0
		Destination As MarkdownKit.MKLinkDestination
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520706F736974696F6E20696E2074686520636F6E7461696E6572277320604368617261637465727360206172726179206F662074686520636C6F73696E6720225D222E
		EndPosition As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4966207468697320697320612066756C6C207265666572656E6365207479706520696E6C696E65206C696E6B2C20746869732069732074686520605D602063686172616374657220616674657220746865207265666572656E6365206C696E6B2773206E616D652E
		FullReferenceDestinationCloser As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4966207468697320697320612066756C6C207265666572656E6365207479706520696E6C696E65206C696E6B2C20746869732069732074686520605B6020636861726163746572206265666F726520746865207265666572656E6365206C696E6B2773206E616D652E
		FullReferenceDestinationOpener As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4966207468697320697320612066756C6C207265666572656E6365207479706520696E6C696E65206C696E6B2C207468697320697320746865206C656E677468206F6620746865207265666572656E6365206C696E6B206C6162656C2E
		FullReferenceLabelLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 547275652069662074686973206C696E6B206461746120726570726573656E747320616E20696E6C696E6520696D6167652E
		IsInlineImage As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Label As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652074797065206F66206C696E6B20746869732069732E
		LinkType As MarkdownKit.MKLinkTypes
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6B206F70656E6572206368617261637465722028605B6020666F72206C696E6B7320616E642060216020666F7220696D61676573292E2045697468657220746865207374617274206F6620746865206C696E6B206C6162656C206F7220746865206C696E6B20746578742E
		OpenerCharacter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0
		Start As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4F7074696F6E616C207469746C6520646174612E204D6179206265204E696C2E
		Title As MarkdownKit.MKLinkTitle
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
			Name="IsInlineImage"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LinkType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="MarkdownKit.MKLinkTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - CollapsedReference"
				"1 - FullReference"
				"2 - ShortcutReference"
				"3 - Standard"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
