#tag Class
Protected Class ParagraphBlock
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Function AcceptsLines() As Boolean
		  // Paragraph blocks can contain lines.
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanContain(childType As MarkdownKit.BlockType) As Boolean
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


End Class
#tag EndClass
