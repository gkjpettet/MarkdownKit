#tag Class
Protected Class MKHTMLBlock
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStart As Integer = 0)
		  Super.Constructor(MKBlockTypes.Html, parent, blockStart)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 5468652074797065206F662048544D4C20626C6F636B20746869732069732E
		HTMLBlockType As MKHTMLBlockTypes = MKHTMLBlockTypes.None
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 5472756520696620746869732048544D4C20626C6F636B20697320747970652036206F7220372E
		#tag Getter
			Get
			  Return Self.HTMLBlockType = MKHTMLBlockTypes.InterruptingBlock Or _
			  Self.HTMLBlockType = MKHTMLBlockTypes.NonInterruptingBlock
			  
			End Get
		#tag EndGetter
		IsType6Or7 As Boolean
	#tag EndComputedProperty


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
			Name="HTMLBlockType"
			Visible=false
			Group="Behavior"
			InitialValue="MKHTMLBlockTypes.None"
			Type="MKHTMLBlockTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - None"
				"1 - InterruptingBlockWithEmptyLines"
				"2 - Comment"
				"3 - ProcessingInstruction"
				"4 - Document"
				"5 - CData"
				"6 - InterruptingBlock"
				"7 - NonInterruptingBlock"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsType6Or7"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
