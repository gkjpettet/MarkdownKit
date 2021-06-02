#tag Interface
Protected Interface IRenderer
	#tag Method, Flags = &h0
		Sub VisitAtxHeading(atx As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlock(b As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlockQuote(bq As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitCodespan(cs As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitDocument(d As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitEmphasis(e As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitFencedCode(fc As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHardbreak(hb As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHTMLBlock(h As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitIndentedCode(ic As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineHTML(h As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineImage(image As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineLink(l As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineText(t As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitLinkReferenceDefinition(ref As MarkdownKit.LinkReferenceDefinition)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitList(theList As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitListItem(li As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitParagraph(p As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSetextHeading(stx As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSoftbreak(sb As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitStrong(s As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitThematicBreak(tb As MarkdownKit.Block)
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Interface
#tag EndInterface
