#tag Class
Protected Class InlineContainerBlock
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Function LastInline() As MarkdownKit.Inline
		  If Inlines.Ubound < 0 Then
		    Return Nil
		  Else
		    Return Inlines(Inlines.Ubound)
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastInlineIsTextual() As Boolean
		  Dim tmp As Inline = LastInline
		  If tmp <> Nil And tmp IsA MarkdownKit.InlineText Then
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Inlines() As MarkdownKit.Inline
	#tag EndProperty


End Class
#tag EndClass
