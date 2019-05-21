#tag Class
Protected Class IndentedCode
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.Walker)
		  visitor.VisitIndentedCode(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AcceptsLines() As Boolean
		  // Indented code blocks can contain lines.
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddLine(theLine As MarkdownKit.LineInfo, startPos As Integer, startCol As Integer)
		  // Overriding Block.AddLine
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
		  
		  // If this indented code block is the immediate child of a block quote then 
		  // Remove the opening block quote marker from the start of the line (if present).
		  If Self.Parent.Type = MarkdownKit.BlockType.BlockQuote And tmp.Ubound >= 0 And _
		    tmp(0) = ">" Then
		    tmp.Remove(0)
		    // Optional space after the block quote opener?
		    If tmp.Ubound >= 0 And tmp(0) = " " Then tmp.Remove(0)
		  End If
		  
		  If tmp.Ubound >= 0 Then
		    // If the raw text line is preceded by a tab, remove it.
		    If tmp(0) = &u0009 Then
		      tmp.Remove(0)
		    Else
		      // If the raw text begins with <= 4 contiguous spaces, remove them.
		      Dim limit As Integer = Min(tmp.Ubound, 3)
		      For i = 0 To limit
		        If tmp(0) = " " Then
		          tmp.Remove(0)
		        Else
		          Exit
		        End If
		      Next i
		    End If
		  End If
		  
		  // Add the raw text as the last child of this block.
		  Children.Append(New MarkdownKit.RawText(tmp, theLine, startPos, startCol))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanContain(childType As MarkdownKit.BlockType) As Boolean
		  #Pragma Unused childType
		  
		  // Indented code blocks are NOT container blocks.
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theLine As MarkdownKit.LineInfo, charPos As Integer, charCol As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor(theLine, charPos, charCol)
		  Self.Type = MarkdownKit.BlockType.IndentedCode
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise()
		  // Overriding Block.Finalise
		  // Close this block correctly.
		  
		  // Nothing to do if this block is already closed.
		  If Not Self.IsOpen Then Return
		  
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
