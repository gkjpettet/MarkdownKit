#tag Class
Protected Class MKInlineLink
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, absoluteStart As Integer, data As MarkdownKit.MKInlineLinkData)
		  Super.Constructor(MKBlockTypes.InlineLink, parent, absoluteStart)
		  
		  Self.Label = data.Label
		  Self.Title = data.Title
		  Self.Destination = data.Destination
		  Self.Characters = data.Characters
		  
		  Self.OpenerCharacter = data.OpenerCharacter
		  Self.CloserCharacter = data.CloserCharacter
		  Self.LinkType = data.LinkType
		  
		  Self.FullReferenceDestinationOpener = data.FullReferenceDestinationOpener
		  Self.FullReferenceDestinationCloser = data.FullReferenceDestinationCloser
		  Self.FullReferenceLabelLength = data.FullReferenceLabelLength
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206C696E6B20636C6F73696E6720627261636B6574206368617261637465722E20436F6D65732065697468657220616674657220746865206C696E6B206C6162656C206F7220746865206C696E6B20746578742028646570656E64696E67206F6E20746865206C696E6B2074797065292E
		CloserCharacter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320696E6C696E65206C696E6B27732064657374696E6174696F6E2E
		Destination As MarkdownKit.MKLinkDestination
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

	#tag ComputedProperty, Flags = &h0, Description = 547275652069662074686973206C696E6B2068617320612064657374696E6174696F6E2E
		#tag Getter
			Get
			  Return Destination <> Nil And Destination.Length > 0
			End Get
		#tag EndGetter
		HasDestination As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 547275652069662074686973206C696E6B206861732061207469746C6520646566696E656420286D617920626520656D707479206275742064656C696D69746564292E
		#tag Getter
			Get
			  Return Title <> Nil And Title.Length > 0
			End Get
		#tag EndGetter
		HasTitle As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5468697320696E6C696E65206C696E6B2773206C6162656C2E204D6179206265204E696C2E
		Label As MarkdownKit.MKLinkLabel
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652074797065206F66206C696E6B20746869732069732E
		LinkType As MarkdownKit.MKLinkTypes
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C6F63616C20302D626173656420696E64657820696E2060506172656E742E43686172616374657273602074686174207468697320696E6C696E65206C696E6B20626567696E732061742E
		LocalStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6B206F70656E6572206368617261637465722028605B60292E
		OpenerCharacter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320696E6C696E65206C696E6B2773206F7074696F6E616C207469746C652E204D6179206265204E696C2E
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
			Name="LocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
		#tag ViewProperty
			Name="HasDestination"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasTitle"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FullReferenceLabelLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
