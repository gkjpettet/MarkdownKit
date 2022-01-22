#tag Class
Protected Class MKInlineLink
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, absoluteStart As Integer, data As MKInlineLinkData)
		  Super.Constructor(MKBlockTypes.InlineLink, parent, absoluteStart)
		  
		  Self.Title = data.Title
		  Self.Destination = data.Destination
		  Self.Characters = data.Characters
		  
		  Self.OpenerCharacter = data.OpenerCharacter
		  Self.CloserCharacter = data.CloserCharacter
		  Self.LinkType = data.LinkType
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206C696E6B20636C6F73696E6720627261636B6574206368617261637465722E20436F6D65732065697468657220616674657220746865206C696E6B206C6162656C206F7220746865206C696E6B20746578742028646570656E64696E67206F6E20746865206C696E6B2074797065292E
		CloserCharacter As MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320696E6C696E65206C696E6B27732064657374696E6174696F6E2E
		Destination As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652074797065206F66206C696E6B20746869732069732E
		LinkType As MKLinkTypes
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C6F63616C20302D626173656420696E64657820696E2060506172656E742E43686172616374657273602074686174207468697320696E6C696E65206C696E6B20626567696E732061742E
		LocalStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6B206F70656E6572206368617261637465722028605B60292E
		OpenerCharacter As MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320696E6C696E65206C696E6B277320286F7074696F6E616C29207469746C652E
		Title As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsLastChild"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsFirstChild"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
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
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue="MKBlockTypes.Block"
			Type="MKBlockTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - AtxHeading"
				"1 - Block"
				"2 - BlockQuote"
				"3 - CodeSpan"
				"4 - Document"
				"5 - Emphasis"
				"6 - FencedCode"
				"7 - Html"
				"8 - IndentedCode"
				"9 - InlineHTML"
				"10 - InlineImage"
				"11 - InlineLink"
				"12 - InlineText"
				"13 - List"
				"14 - ListItem"
				"15 - Paragraph"
				"16 - ReferenceDefinition"
				"17 - SetextHeading"
				"18 - SoftBreak"
				"19 - StrongEmphasis"
				"20 - TextBlock"
				"21 - ThematicBreak"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsOpen"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsLastLineBlank"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsChildOfTightList"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsChildOfListItem"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
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
			Type="MKLinkTypes"
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
