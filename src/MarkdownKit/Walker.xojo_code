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
		Sub VisitHardBreak(hb As MarkdownKit.HardBreak)
		  
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
	#tag EndViewBehavior
End Interface
#tag EndInterface
