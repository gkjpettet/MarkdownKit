#tag Interface
Protected Interface IInlineVisitor
	#tag Method, Flags = &h0
		Sub VisitHardbreak(hb As MarkdownKit.Hardbreak)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInline(i As MarkdownKit.Inline)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineCodespan(cs As MarkdownKit.InlineCodespan)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineHTML(h As MarkdownKit.InlineHTML)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineText(t As MarkdownKit.InlineText)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSoftbreak(sb As MarkdownKit.Softbreak)
		  
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
