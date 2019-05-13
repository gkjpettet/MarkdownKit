#tag Class
Protected Class BlockQuoteBlock
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Function AcceptsLines() As Boolean
		  // Blockquote blocks do not accept lines.
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanContain(childType As MarkdownKit.BlockType) As Boolean
		  // Blockquote blocks can contain all blocks except for document blocks.
		  
		  If childType = MarkdownKit.BlockType.Document Then
		    Return False
		  Else
		    Return True
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theLine As MarkdownKit.LineInfo, charPos As Integer, charCol As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor(theLine, charPos, charCol)
		  Self.Type = MarkdownKit.BlockType.BlockQuote
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
