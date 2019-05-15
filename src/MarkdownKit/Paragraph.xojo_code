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
		Sub AddLine(theLine As MarkdownKit.LineInfo, startPos As Integer, startCol As Integer)
		  // Get the remaining characters from `startPos` on this line until the end.
		  
		  If Not Self.IsOpen Then
		    Raise New MarkdownKit.MarkdownException("Attempted to add line " + theLine.Number.ToText + _
		    " to closed container " + Self.Type.ToText)
		  End If
		  
		  Dim tmp() As Text
		  
		  Dim i As Integer
		  For i = startPos To theLine.CharsUbound
		    tmp.Append(theLine.Chars(i))
		  Next i
		  
		  // Determine if there is a prepending hard or a soft break?
		  If Children.Ubound >=0 Then
		    Dim rt As MarkdownKit.RawText = MarkdownKit.RawText(Children(Children.Ubound))
		    If rt.Chars.Ubound > 2 And rt.Chars(rt.Chars.Ubound) = " " And _
		      rt.Chars(rt.Chars.Ubound - 1) = " " Then
		      // The preceding raw text line ended with two spaces. This should be interpreted as a hard line break.
		      Children.Append(New MarkdownKit.HardBreak(theLine))
		    ElseIf rt.Chars(rt.Chars.Ubound) = "\" Then
		      // A backslash at the end of the line is a hard line break.
		      Children.Append(New MarkdownKit.HardBreak(theLine))
		      // Remove the trailing backslash.
		      rt.Chars.Remove(rt.Chars.Ubound)
		    Else
		      // Soft line break
		      Children.Append(New MarkdownKit.SoftBreak(theLine))
		    End If
		    // Strip the trailing whitespace from the end of the preceding line.
		    StripTrailingWhitespace(rt.Chars)
		  End If
		  
		  // Add the raw text as the last child of this block.
		  Children.Append(New MarkdownKit.RawText(tmp, theLine, startPos, startCol))
		  
		End Sub
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
