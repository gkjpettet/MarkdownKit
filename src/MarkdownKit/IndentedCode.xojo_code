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
		  
		  If startPos <> 0 Then
		    Raise New MarkdownKit.MarkdownException("The entire line should always be added in " + _
		    "indented code blocks")
		  End If
		  
		  // Get the relevant characters from the line that represent this code 
		  // block's line. It is dependant upon this code block's container.
		  startPos = Self.Parent.FirstCharPos
		  Dim chars() As Text
		  Dim i As Integer
		  For i = startPos To theLine.CharsUbound
		    chars.Append(theLine.Chars(i))
		  Next i
		  
		  // Remove up to 4 leading spaces from the line.
		  Dim numSpaces As Integer = NumberOfLeadingSpaces(chars)
		  Dim limit As Integer = Min(numSpaces - 1, 3)
		  limit = Min(chars.Ubound, limit)
		  If limit > -1 Then
		    For i = 0 To limit
		      chars.Remove(0)
		    Next i
		  End If
		  
		  // If we have removed less than 4 spaces, we should remove a leading tab if present.
		  If numSpaces < 4 And chars.Ubound >= 0 And chars(0) = &u0009 Then chars.Remove(0)
		  
		  // Expand the optional tab.
		  If Self.Parent.Type = MarkdownKit.BlockType.BlockQuote Then
		    If Self.Parent.OpeningMarkerHasOptionalTab Then
		      chars.Insert(0, " ")
		      chars.Insert(0, " ")
		    End If
		  End If
		  
		  // Add the raw text as the last child of this block.
		  Children.Append(New MarkdownKit.RawText(chars, theLine, startPos, startCol))
		  
		  
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
		  
		  // Blank lines preceding or following an indented code block are not included in it.
		  Dim i As Integer
		  Dim limit As Integer = Children.Ubound
		  Dim rt As MarkdownKit.RawText
		  // Leading blank lines...
		  For i = 0 to limit
		    rt = MarkdownKit.RawText(Children(i))
		    If rt.IsBlank Then
		      Children.Remove(0)
		    Else
		      Exit
		    End If
		  Next i
		  // Trailing blank lines...
		  If Children.Ubound > -1 Then
		    For i  = Children.Ubound DownTo 0
		      rt = MarkdownKit.RawText(Children(i))
		      If rt.IsBlank Then
		        Children.Remove(i)
		      Else
		        Exit
		      End If
		    Next i
		  End If
		  
		  // Mark the block as closed.
		  Self.IsOpen = False
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function NumberOfLeadingSpaces(chars() As Text) As Integer
		  // Returns the number of contiguous leading spaces in this array.
		  
		  If chars.Ubound = -1 Then Return 0
		  
		  Dim limit As Integer = chars.Ubound
		  Dim i As Integer
		  Dim count As Integer = 0
		  For i = 0 To limit
		    If chars(i) = " " Then
		      count = count + 1
		    Else
		      Exit
		    End If
		  Next i
		  
		  Return count
		  
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="OpeningMarkerHasOptionalTab"
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
