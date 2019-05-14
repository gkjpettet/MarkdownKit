#tag Interface
Protected Interface Walker
	#tag Method, Flags = &h0
		Sub VisitBlock(b As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlockQuote(bq As MarkdownKit.BlockQuote)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitDocument(d As MarkdownKit.Document)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitParagraph(p As MarkdownKit.Paragraph)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitRawText(rt As MarkdownKit.RawText)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSoftBreak(sb As MarkdownKit.SoftBreak)
		  
		End Sub
	#tag EndMethod


End Interface
#tag EndInterface
