#tag Class
Protected Class MKInlineHTML
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, absoluteStartPos As Integer, localStartPos As Integer, absoluteRightAnglePos As Integer, localRightAnglePos As Integer)
		  Super.Constructor(MKBlockTypes.CodeSpan, parent, absoluteStartPos)
		  
		  Self.LocalStart = localStartPos
		  Self.EndPosition = absoluteRightAnglePos
		  Self.LocalRightAnglePos = localRightAnglePos
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520302D626173656420706F736974696F6E20696E2060506172656E742E4368617261637465727360206F662074686520636C6F73696E6720726967687420616E676C6520627261636B65742E
		LocalRightAnglePos As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D626173656420696E64657820696E2060506172656E742E4368617261637465727360206F6620746865206F70656E696E67206C65667420616E676C6520627261636B6574206F66207468697320696E6C696E652048544D4C2E
		LocalStart As Integer = 0
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
				"3 - CodeSpan"
				"4 - Document"
				"5 - FencedCode"
				"6 - Html"
				"7 - IndentedCode"
				"8 - InlineText"
				"9 - List"
				"10 - ListItem"
				"11 - Paragraph"
				"12 - ReferenceDefinition"
				"13 - SetextHeading"
				"14 - TextBlock"
				"15 - ThematicBreak"
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
			Name="LocalRightAnglePos"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
