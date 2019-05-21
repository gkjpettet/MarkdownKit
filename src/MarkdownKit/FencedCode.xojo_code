#tag Class
Protected Class FencedCode
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.Walker)
		  visitor.VisitFencedCode(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AcceptsLines() As Boolean
		  // Fenced code blocks can contain lines.
		  
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
		  
		  If Self.JustOpened Then
		    // We can't add a line to this fenced code block on the same line that it was 
		    // opened because the line will be the opening sequence +/- the info string.
		    Self.JustOpened = False
		    Return
		  End If
		  
		  Dim tmp() As Text
		  Dim i As Integer
		  For i = startPos To theLine.CharsUbound
		    tmp.Append(theLine.Chars(i))
		  Next i
		  
		  // If this fenced code block is the immediate child of a block quote then 
		  // Remove the opening block quote marker from the start of the line (if present).
		  If Self.Parent.Type = MarkdownKit.BlockType.BlockQuote And tmp.Ubound >= 0 And _
		    tmp(0) = ">" Then
		    tmp.Remove(0)
		    // Optional space after the block quote opener?
		    If tmp.Ubound >= 0 And tmp(0) = " " Then tmp.Remove(0)
		  End If
		  
		  // Add the raw text as the last child of this block.
		  Children.Append(New MarkdownKit.RawText(tmp, theLine, startPos, startCol))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanContain(childType As MarkdownKit.BlockType) As Boolean
		  #Pragma Unused childType
		  
		  // Fenced code blocks are NOT container blocks.
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theLine As MarkdownKit.LineInfo, charPos As Integer, charCol As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor(theLine, charPos, charCol)
		  Self.Type = MarkdownKit.BlockType.FencedCode
		  Self.NeedsClosing = False
		  Self.JustOpened = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise()
		  // Nothing to do if this block is already closed.
		  If Not Self.IsOpen Then Return
		  
		  // If the code fence is indented `Offset` spaces, then up to `Offset` spaces 
		  // of indentation are removed from each line of the content (if present).
		  // If a content line is not indented, it is preserved unchanged. 
		  // If it is indented less than `Offset` spaces, all of the indentation is removed.
		  If Self.Children.Ubound >= 0 And Self.Offset > 0 Then
		    Dim i, j, jLimit As Integer
		    Dim childrenUbound As Integer = Self.Children.Ubound
		    Dim rt As MarkdownKit.RawText
		    For i = 0 to childrenUbound
		      // For each line of raw text in the code fence...
		      rt = MarkdownKit.RawText(Self.Children(i))
		      // Remove a maximum of `Offset` contiguous spaces.
		      jLimit = Xojo.Math.Min(rt.Chars.Ubound, Self.Offset - 1)
		      For j = 0 To jLimit
		        If rt.Chars(0) = " " Then
		          rt.Chars.Remove(0)
		        Else
		          Exit
		        End If
		      Next j
		    Next i
		  End If
		  
		  // Mark the block as closed.
		  Self.IsOpen = False
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		InfoString As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		JustOpened As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		NeedsClosing As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F66207370616365732074686174207468697320636F64652066656E6365206973206F666673657420286D6178203D203329
		Offset As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520636861726163746572207573656420746F206F70656E207468697320636F64652066656E63652E2045697468657220226022206F7220227E22
		OpeningChar As Text
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662060206F72207E2063686172616374657273207468617420636F6E737469747574657320746869732066656E63656420636F646520626C6F636B2773206F70656E696E672073657175656E6365
		OpeningLength As Integer = 0
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
		#tag ViewProperty
			Name="InfoString"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="JustOpened"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NeedsClosing"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Offset"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpeningChar"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpeningLength"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
