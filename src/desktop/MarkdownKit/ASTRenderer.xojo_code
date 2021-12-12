#tag Class
Protected Class ASTRenderer
Implements MKRenderer
	#tag Method, Flags = &h0
		Function VisitATXHeading(atx As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("ATX Heading")
		  node.AppendNode(New TreeViewNode("Start: " + atx.Start.ToString))
		  node.AppendNode(New TreeViewNode("Level: " + atx.Level.ToString))
		  
		  For Each child As MKBlock In atx.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(b As MKBlock) As Variant
		  Var node As New TreeViewNode("Generic Block")
		  
		  For Each child As MKBlock In b.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
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
		  
		  Var node As New TreeViewNode("Fenced Code (start: " + fc.Start.ToString + ")")
		  
		  If fc.FenceChar = "`" Then
		    node.AppendNode(New TreeViewNode("Fence Char: backtick ""`"""))
		  Else
		    node.AppendNode(New TreeViewNode("Fence Char: tilde ""~"""))
		  End If
		  node.AppendNode(New TreeViewNode("Opening Fence Length: " + fc.FenceLength.ToString))
		  node.AppendNode(New TreeViewNode("Closing Fence Start: " + fc.ClosingFenceStart.ToString))
		  node.AppendNode(New TreeViewNode("Info String: " + fc.InfoString))
		  
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
		Function VisitList(list As MKBlock) As Variant
		  // Title.
		  Var title As String
		  Var tight As String = If(list.ListData.IsTight, "Tight", "Loose")
		  If list.ListData.ListType = MKListTypes.Bullet Then
		    title = tight + " Unordered List"
		  Else
		    title = tight + " Ordered List (begins at " + list.ListData.StartNumber.ToString + ")"
		  End If
		  
		  Var node As New TreeViewNode(title)
		  
		  // Delimiter type if ordered list.
		  If list.ListData.ListType = MKListTypes.Ordered Then
		    Var delimiter As String
		    If list.ListData.ListDelimiter = MKListDelimiters.Parenthesis Then
		      delimiter = ")"
		    Else
		      delimiter = "."
		    End If
		    node.AppendNode(New TreeViewNode("Delimiter: " + delimiter))
		  End If
		  
		  // Bullet character if unordered list.
		  If list.ListData.ListType = MKListTypes.Bullet Then
		    node.AppendNode(New TreeViewNode("Bullet: " + list.ListData.BulletCharacter))
		  End If
		  
		  // List items.
		  For Each child As MKBlock In list.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitListItem(item As MKBlock) As Variant
		  Var node As New TreeViewNode("List Item")
		  
		  node.AppendNode(New TreeViewNode("Start: " + item.Start.ToString))
		  node.AppendNode(New TreeViewNode("Line Position: " + item.ListData.LinePosition.ToString))
		  node.AppendNode(New TreeViewNode("Marker Offset: " + item.ListData.MarkerOffset.ToString))
		  node.AppendNode(New TreeViewNode("Marker Width: " + item.ListData.MarkerWidth.ToString))
		  
		  For Each child As MKBlock In item.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParagraph(p As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Paragraph")
		  
		  For Each child As MKBlock In p.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSetextHeading(stx As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Setext Heading")
		  node.AppendNode(New TreeViewNode("Start: " + stx.Start.ToString))
		  node.AppendNode(New TreeViewNode("Level: " + stx.Level.ToString))
		  node.AppendNode(New TreeViewNode("Underline Start: " + stx.SetextUnderlineStart.ToString))
		  node.AppendNode(New TreeViewNode("Underline Length: " + stx.SetextUnderlineLength.ToString))
		  
		  For Each child As MKBlock In stx.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitTextBlock(tb As MKTextBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var title As String = If(tb.IsBlank, "Blank ", "") + _
		  "Text Block (start:" + tb.Start.ToString + ", length: " + tb.Contents.CharacterCount.ToString + ")"
		  
		  Var node As New TreeViewNode(title)
		  
		  If Not tb.IsBlank Then
		    node.AppendNode(New TreeViewNode(tb.Contents))
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
