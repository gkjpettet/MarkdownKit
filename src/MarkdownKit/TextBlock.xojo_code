#tag Class
Protected Class TextBlock
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Constructor(chars() As Text, line As MarkdownKit.LineInfo)
		  Super.Constructor(line.Number, line.Offset)
		  Self.Chars = chars
		  Self.IsOpen = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsBlank() As Boolean
		  // Returns True if this line of raw text is empty or contains only whitespace.
		  
		  Return Chars.IsBlank
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToText() As Text
		  Return Text.Join(Chars, "")
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Chars() As Text
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="HTMLBlockType"
			Group="Behavior"
			InitialValue="kHTMLBlockTypeNone"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartPosition"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartColumn"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineNumber"
			Group="Behavior"
			InitialValue="1"
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
				"12 - Block"
				"13 - TextBlock"
				"14 - Softbreak"
				"15 - Hardbreak"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsLastLineBlank"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
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
	#tag EndViewBehavior
End Class
#tag EndClass
