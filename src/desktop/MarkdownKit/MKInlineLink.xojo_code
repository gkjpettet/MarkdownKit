#tag Class
Protected Class MKInlineLink
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, absoluteStart As Integer, data As MarkdownKit.MKInlineLinkData)
		  Super.Constructor(MKBlockTypes.InlineLink, parent, absoluteStart)
		  
		  Self.Title = data.Title
		  Self.Destination = data.Destination.Value
		  Self.Characters = data.Characters
		  
		  Self.OpenerCharacter = data.OpenerCharacter
		  Self.CloserCharacter = data.CloserCharacter
		  Self.LinkType = data.LinkType
		  Self.DestinationOpenerCharacter = data.DestinationOpenerCharacter
		  Self.DestinationCloserCharacter = data.DestinationCloserCharacter
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206C696E6B20636C6F73696E6720627261636B6574206368617261637465722E20436F6D65732065697468657220616674657220746865206C696E6B206C6162656C206F7220746865206C696E6B20746578742028646570656E64696E67206F6E20746865206C696E6B2074797065292E
		CloserCharacter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320696E6C696E65206C696E6B27732064657374696E6174696F6E2E
		Destination As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520605D60206F722060296020636861726163746572207468617420656E6473207468652064657374696E6174696F6E2E204D6179206265204E696C20666F722073686F7274637574207265666572656E6365206C696E6B732E
		DestinationCloserCharacter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520605B60206F722060286020636861726163746572207468617420626567696E73207468652064657374696E6174696F6E2E204D6179206265204E696C20666F722073686F7274637574207265666572656E6365206C696E6B732E
		DestinationOpenerCharacter As MarkdownKit.MKCharacter
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

	#tag Property, Flags = &h0, Description = 5468697320696E6C696E65206C696E6B277320286F7074696F6E616C29207469746C652E
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
			Name="LocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
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
			Name="Destination"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
