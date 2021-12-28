#tag Interface
Protected Interface MKRenderer
	#tag Method, Flags = &h0
		Function VisitATXHeading(atx As MKATXHeadingBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(b As MKBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlockQuote(bq As MKBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitCodeSpan(cs As MKCodeSpan) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitDocument(doc As MKDocument) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitEmphasis(e As MKEmphasis) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFencedCode(fc As MKFencedCodeBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHTMLBlock(html As MKHTMLBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIndentedCode(ic As MKBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineHTML(html As MKInlineHTML) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineImage(image As MKInlineImage) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineLink(link As MKInlineLink) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineText(it As MKInlineText) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitList(list As MKBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitListItem(item As MKBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParagraph(p As MKParagraphBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSetextHeading(stx As MKSetextHeadingBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSoftBreak(sb As MKSoftBreak) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitStrongEmphasis(se As MKStrongEmphasis) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitTextBlock(tb As MKTextBlock) As Variant
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitThematicBreak(tb As MKBlock) As Variant
		  
		End Function
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
