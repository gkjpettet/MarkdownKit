#tag Class
Protected Class Block
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Create a new open block with no parent or children.
		  // Uses the default property values.
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Children() As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 496E646963617465732077686574686572207468697320626C6F636B20656C656D656E7420686173206265656E20636F6D706C657465642028616E642074687573206E6577206C696E65732063616E6E6F7420626520616464656420746F20697429206F72206974206973207374696C6C206F70656E2E2042792064656661756C7420616C6C20656C656D656E7473206172652063726561746564206173206F70656E20616E642061726520636C6F736564207768656E20746865207061727365722064657465637473206974
		IsOpen As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Return the last child for this container block or Nil if there are no children.
			  If Children.Ubound = -1 Then
			    Return Nil
			  Else
			    Return Children(Children.Ubound)
			  End If
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			  Dim err As New Xojo.Core.UnsupportedOperationException
			  err.Reason = "ContainerBlock.LastChild is read only"
			  Raise err
			  
			End Set
		#tag EndSetter
		LastChild As MarkdownKit.Block
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Parent As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As MarkdownKit.BlockType
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
			Name="IsOpen"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Group="Behavior"
			Type="MarkdownKit.BlockType"
			EditorType="Enum"
			#tag EnumValues
				"0 - Document"
				"1 - BlockQuote"
				"2 - List"
				"3 - ListItem"
				"4 - FencedCode"
				"5 - IndentedCode"
				"6 - HtmlBlock"
				"7 - Paragraph"
				"8 - AtxHeading"
				"9 - SetextHeading"
				"10 - ThematicBreak"
				"11 - ReferenceDefinition"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
