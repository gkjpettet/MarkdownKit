#tag Class
Protected Class MKCodeSpan
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, startPosition As Integer, backtickStringLength As Integer, closingBacktickStringStart As Integer)
		  Super.Constructor(MKBlockTypes.CodeSpan, parent, 0)
		  
		  Self.Start = startPosition
		  Self.EndPosition = closingBacktickStringStart - 1
		  Self.BacktickStringLength = backtickStringLength
		  Self.ClosingBacktickStringStart = closingBacktickStringStart
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206C656E677468206F662074686520666C616E6B696E67206261636B7469636B2064656C696D69746572732061726F756E64207468697320636F6465207370616E2E
		BacktickStringLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D626173656420696E64657820696E20746865206F726967696E616C20736F75726365206F662074686520666972737420636861726163746572206F662074686520636C6F73696E67206261636B7469636B20737472696E672E
		ClosingBacktickStringStart As Integer = 0
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
				"8 - List"
				"9 - ListItem"
				"10 - Paragraph"
				"11 - ReferenceDefinition"
				"12 - SetextHeading"
				"13 - TextBlock"
				"14 - ThematicBreak"
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
			Name="BacktickStringLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClosingBacktickStringStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
