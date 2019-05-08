#tag Class
Protected Class DocumentBlock
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Constructor(markdown As Text)
		  // Standardise the line endings in the passed Markdown to line feeds.
		  markdown = ReplaceLineEndings(markdown, MarkdownKit.kLF)
		  
		  // Replace insecure characters (spec 0.29 2.3).
		  markdown = markdown.ReplaceAll(&u0000, &uFFFD)
		  
		  // Split the Markdown into lines.
		  Lines = markdown.Split(MarkdownKit.kLF)
		  
		  // The root starts open.
		  IsOpen = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReplaceLineEndings(t As Text, what As Text) As Text
		  // Normalize the line endings first.
		  t = t.ReplaceAll(MarkdownKit.kCRLF, MarkdownKit.kLF)
		  t = t.ReplaceAll(MarkdownKit.kCR, MarkdownKit.kLF)
		  
		  // Now replace them.
		  t = t.ReplaceAll(MarkdownKit.kLF, what)
		  
		  Return t
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Lines() As Text
	#tag EndProperty


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
		#tag ViewProperty
			Name="IsOpen"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
