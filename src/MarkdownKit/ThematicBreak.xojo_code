#tag Class
Protected Class ThematicBreak
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.Walker)
		  visitor.VisitThematicBreak(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Acceptslines() As Boolean
		  // Thematic breaks cannot contain lines.
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanContain(childType As MarkdownKit.BlockType) As Boolean
		  #Pragma Unused childType
		  
		  // Thematic breaks cannot contain other blocks.
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theLine As MarkdownKit.LineInfo, charPos As Integer, charCol As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor(theLine, charPos, charCol)
		  Self.Type = MarkdownKit.BlockType.ThematicBreak
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
