#tag Class
Protected Class MKFencedCodeBlock
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStartOffset As Integer = 0)
		  Super.Constructor(MKBlockTypes.FencedCode, parent, blockStartOffset)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 302D626173656420706F736974696F6E20696E2074686520736F75726365206F6620746865207374617274206F6620746869732066656E63656420636F646520626C6F636B277320636C6F73696E672066656E63652E
		ClosingFenceStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652066656E6365206368617261637465722E
		FenceChar As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662066656E63652063686172616374657273206D616B696E6720757020746865206F70656E696E672066656E63652E
		FenceLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FenceOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520286F7074696F6E616C2920696E666F20737472696E672E
		InfoString As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 53657420746F205472756520696E206050726F6365737352656D61696E6465724F664C696E656020696620746869732066656E63656420636F646520626C6F636B206E6565647320636C6F73696E672E
		ShouldClose As Boolean = False
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
				"3 - Document"
				"4 - FencedCode"
				"5 - Html"
				"6 - IndentedCode"
				"7 - List"
				"8 - ListItem"
				"9 - Paragraph"
				"10 - ReferenceDefinition"
				"11 - SetextHeading"
				"12 - TextBlock"
				"13 - ThematicBreak"
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
			Name="Level"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceChar"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
