#tag Class
Protected Class Paragraph
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.Walker)
		  visitor.VisitParagraph(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AcceptsLines() As Boolean
		  // Paragraph blocks can contain lines.
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanContain(childType As MarkdownKit.BlockType) As Boolean
		  #Pragma Unused childType
		  
		  // Paragraph blocks are NOT container blocks.
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theLine As MarkdownKit.LineInfo, charPos As Integer, charCol As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor(theLine, charPos, charCol)
		  Self.Type = MarkdownKit.BlockType.Paragraph
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise()
		  // Nothing to do if this block is already closed.
		  If Not Self.IsOpen Then Return
		  
		  // Final spaces are stripped before inline parsing, so a 
		  // paragraph that ends with two or more spaces will not end with
		  // a hard line break.
		  If Children.Ubound >= 0 And Children(Children.Ubound) IsA MarkdownKit.RawText Then
		    // Stip trailing whitespace from this last child.
		    Dim rt As MarkdownKit.RawText = MarkdownKit.RawText(Children(Children.Ubound))
		    StripTrailingWhitespace(rt.Chars)
		  End If
		  
		  // Mark the block as closed.
		  Self.IsOpen = False
		  
		End Sub
	#tag EndMethod


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
		#tag ViewProperty
			Name="IsLastLineBlank"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstCharPos"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstCharCol"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
