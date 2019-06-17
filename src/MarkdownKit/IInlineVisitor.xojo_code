#tag Interface
Protected Interface IInlineVisitor
	#tag Method, Flags = &h0
		Sub VisitInline(i As MarkdownKit.Inline)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineCodespan(cs As MarkdownKit.InlineCodespan)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineText(t As MarkdownKit.InlineText)
		  
		End Sub
	#tag EndMethod


End Interface
#tag EndInterface
