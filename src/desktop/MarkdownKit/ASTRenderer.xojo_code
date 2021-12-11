#tag Class
Protected Class ASTRenderer
Implements MKRenderer
	#tag Method, Flags = &h0
		Function VisitATXHeading(atx As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("ATX Heading")
		  node.AddSubItem("Start: " + atx.Start.ToString)
		  node.AddSubItem("Level: " + atx.Level.ToString)
		  For Each line As TextLine In atx.Lines
		    node.AddSubItem(line.Value)
		  Next line
		  
		  Return node
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlockQuote(bq As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Block Quote (start: " + bq.Start.ToString + ")")
		  
		  For Each child As MKBlock In bq.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 57616C6B732074686520706173736564204D61726B646F776E20646F63756D656E7420616E6420637265617465732061206054726565566965774E6F64656020726570726573656E74696E672069742E
		Function VisitDocument(doc As MKBlock) As Variant
		  /// Walks the passed Markdown document and creates a `TreeViewNode` representing it.
		  ///
		  /// Part of the MKRenderer interface.
		  
		  Var docNode As New TreeViewNode("Document")
		  
		  For Each b As MKBlock In doc.Children
		    
		    docNode.AppendNode(b.Accept(Self))
		    
		  Next b
		  
		  Return docNode
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFencedCode(fc As MKFencedCodeBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Fenced Code")
		  node.AppendNode(New TreeViewNode("Fence Char: " + fc.FenceChar))
		  node.AppendNode(New TreeViewNode("Fence Length: " + fc.FenceLength.ToString))
		  node.AppendNode(New TreeViewNode("Info string: " + fc.InfoString))
		  
		  For Each child As MKBlock In fc.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHTMLBlock(html As MKHTMLBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("HTML Block (start: " + html.Start.ToString + ")")
		  
		  For Each child As MKBlock In html.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIndentedCode(ic As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Indented Code")
		  
		  For Each child As MKBlock In ic.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParagraph(p As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Paragraph")
		  
		  For Each line As TextLine In p.Lines
		    
		    Var lineNode As New TreeViewNode("Start:" + line.Start.ToString + _
		    ",len:" + line.Length.ToString + _
		    ",Contents:" + line.Value)
		    
		    node.AppendNode(lineNode)
		    
		  Next line
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitTextBlock(tb As MKTextBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var title As String = If(tb.IsBlank, "Blank ", "") + "Text Block (start:" + tb.Start.ToString + ")"
		  
		  Var node As New TreeViewNode(title)
		  
		  If Not tb.IsBlank Then
		    For Each line As TextLine In tb.Lines
		      
		      Var lineNode As New TreeViewNode("Start:" + line.Start.ToString + _
		      ",len:" + line.Length.ToString + _
		      ",Contents:" + line.Value)
		      
		      node.AppendNode(lineNode)
		      
		    Next line
		  End If
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitThematicBreak(tb As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Thematic Break (start:" + tb.Start.ToString + ")")
		  Return node
		  
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
End Class
#tag EndClass
