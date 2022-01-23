#tag Class
Protected Class ASTTreeViewRenderer
Implements MarkdownKit.MKRenderer
	#tag Method, Flags = &h21, Description = 437265617465732061206E6F64652066726F6D20616E206172726179206F66206368617261637465727320776974682074686520737065636966696564205B6E6F64655469746C655D2E
		Private Function CreateNodeFromCharacters(nodeTitle As String, chars() As MarkdownKit.MKCharacter) As TreeViewNode
		  /// Creates a node from an array of characters with the specified [nodeTitle].
		  
		  Var node As New TreeViewNode(nodeTitle)
		  
		  Var s() As String
		  For i As Integer = 0 To chars.LastIndex
		    Var char As MarkdownKit.MKCharacter = chars(i)
		    If char.IsLineEnding Then
		      node.AppendNode(New TreeViewNode(String.FromArray(s, "")))
		      s.RemoveAll
		    Else
		      s.Add(char.Value)
		    End If
		  Next i
		  
		  If s.Count > 0 Then node.AppendNode(New TreeViewNode(String.FromArray(s, "")))
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitATXHeading(atx As MarkdownKit.MKATXHeadingBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("ATX Heading")
		  
		  node.AppendNode(New TreeViewNode("Start: " + atx.Start.ToString))
		  node.AppendNode(New TreeViewNode("Level: " + atx.Level.ToString))
		  node.AppendNode(New TreeViewNode("Opening Sequence Length: " + atx.OpeningSequenceLength.ToString))
		  
		  If atx.HasClosingSequence Then
		    node.AppendNode(New TreeViewNode("Closing Sequence Start: " + atx.ClosingSequenceAbsoluteStart.ToString))
		    node.AppendNode(New TreeViewNode("Closing Sequence Count: " + atx.ClosingSequenceCount.ToString))
		  End If
		  
		  node.AppendNode(CreateNodeFromCharacters("Raw Title", atx.Characters))
		  Var titleNode As New TreeViewNode("Title")
		  For Each child As MarkdownKit.MKBlock In atx.Children
		    titleNode.AppendNode(child.Accept(Self))
		  Next child
		  node.AppendNode(titleNode)
		  
		  Return node
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(b As MarkdownKit.MKBlock) As Variant
		  Var node As New TreeViewNode("Generic Block")
		  
		  For Each child As MarkdownKit.MKBlock In b.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlockQuote(bq As MarkdownKit.MKBlockQuote) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Block Quote (start: " + bq.Start.ToString + ")")
		  
		  For Each child As MarkdownKit.MKBlock In bq.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitCodeSpan(cs As MarkdownKit.MKCodeSpan) As Variant
		  Var node As New TreeViewNode("Code Span")
		  node.AppendNode(New TreeViewNode("Start: " + cs.Start.ToString))
		  node.AppendNode(New TreeViewNode("Delimiter Length: " + cs.BacktickStringLength.ToString))
		  node.AppendNode(New TreeViewNode("Closing Delimiter Start: " + cs.ClosingBacktickStringStart.ToString))
		  
		  // Code spans contain text blocks as their children.
		  For Each child As MarkdownKit.MKBlock In cs.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 57616C6B732074686520706173736564204D61726B646F776E20646F63756D656E7420616E6420637265617465732061206054726565566965774E6F64656020726570726573656E74696E672069742E
		Function VisitDocument(doc As MarkdownKit.MKDocument) As Variant
		  /// Walks the passed Markdown document and creates a `TreeViewNode` representing it.
		  ///
		  /// Part of the MKRenderer interface.
		  
		  Var docNode As New TreeViewNode("Document")
		  
		  // Link reference definitions.
		  If doc.References.KeyCount > 0 Then
		    Var defsNode As New TreeViewNode("Link Reference Definitions")
		    For Each entry As DictionaryEntry In doc.References
		      Var lrd As MarkdownKit.MKLinkReferenceDefinition = MarkdownKit.MKLinkReferenceDefinition(entry.Value)
		      Var lrdNode As New TreeViewNode("Definition")
		      // Link label.
		      lrdNode.AppendNode(New TreeViewNode("Label (" + lrd.LinkLabelStart.ToString + ", " + _
		      lrd.LinkLabelLength.ToString + "): " + lrd.LinkLabel))
		      
		      // Link destination.
		      lrdNode.AppendNode(New TreeViewNode("Destination (" + _
		      lrd.LinkDestination.StartCharacter.AbsolutePosition.ToString + ", " + _
		      lrd.LinkDestination.Length.ToString + "): " + lrd.LinkDestination.Value))
		      
		      // Optional link title.
		      If lrd.HasTitle Then
		        lrdNode.AppendNode(New TreeViewNode("Title (" + lrd.LinkTitleStart.ToString + ", " + _
		        lrd.LinkTitleLength.ToString + "): " + lrd.LinkTitle))
		      End If
		      
		      defsNode.AppendNode(lrdNode)
		    Next entry
		    
		    docNode.AppendNode(defsNode)
		  End If
		  
		  For Each b As MarkdownKit.MKBlock In doc.Children
		    
		    docNode.AppendNode(b.Accept(Self))
		    
		  Next b
		  
		  Return docNode
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitEmphasis(e As MarkdownKit.MKEmphasis) As Variant
		  Var node As New TreeViewNode("Emphasis")
		  node.AppendNode(New TreeViewNode("Start: " + e.Start.ToString))
		  
		  For Each child As MarkdownKit.MKBlock In e.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFencedCode(fc As MarkdownKit.MKFencedCodeBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Fenced Code")
		  
		  If fc.FenceChar = "`" Then
		    node.AppendNode(New TreeViewNode("Fence Char: backtick ""`"""))
		  Else
		    node.AppendNode(New TreeViewNode("Fence Char: tilde ""~"""))
		  End If
		  
		  node.AppendNode(New TreeViewNode("Opening Fence Start (abs, local): " + _
		  fc.Start.ToString + ", " + fc.OpeningFenceLocalStart.ToString))
		  
		  node.AppendNode(New TreeViewNode("Opening Fence Length: " + fc.FenceLength.ToString))
		  
		  node.AppendNode(New TreeViewNode("Closing Fence Start (abs, local): " + _
		  fc.ClosingFenceStart.ToString + ", " + fc.ClosingFenceLocalStart.ToString))
		  
		  If fc.HasInfoString Then
		    Var infoStringNode As New TreeViewNode("Info String")
		    infoStringNode.AppendNode(New TreeViewNode("Start(abs, local): " + _
		    fc.InfoStringStart.ToString + ", " + fc.InfoStringLocalStart.ToString))
		    infoStringNode.AppendNode(New TreeViewNode("Length: " + fc.InfoStringLength.ToString))
		    infoStringNode.AppendNode(New TreeViewNode("Value: " + fc.InfoString))
		    node.AppendNode(infoStringNode)
		  End If
		  
		  For Each child As MarkdownKit.MKBlock In fc.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHTMLBlock(html As MarkdownKit.MKHTMLBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("HTML Block (start: " + html.Start.ToString + ")")
		  
		  For Each child As MarkdownKit.MKBlock In html.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIndentedCode(ic As MarkdownKit.MKIndentedCodeBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Indented Code")
		  
		  For Each child As MarkdownKit.MKBlock In ic.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineHTML(html As MarkdownKit.MKInlineHTML) As Variant
		  Var node As New TreeViewNode("InlineHTML")
		  
		  node.AppendNode(New TreeViewNode("Start: " + html.Start.ToString))
		  node.AppendNode(New TreeViewNode("End: " + html.EndPosition.ToString))
		  
		  If html.IsAutoLink Then
		    Var autoLinkNode As New TreeViewNode("IsAutoLink: True")
		    autoLinkNode.AppendNode(New TreeViewNode("Destination: " + html.Destination))
		    autoLinkNode.AppendNode(New TreeViewNode("Label: " + html.Label))
		    If html.Title <> "" Then autoLinkNode.AppendNode(New TreeViewNode("Title: " + html.Title))
		    node.AppendNode(autoLinkNode)
		  Else
		    node.AppendNode(New TreeViewNode("IsAutoLink: False"))
		  End If
		  
		  // Inline HTML contain text blocks as their children.
		  For Each child As MarkdownKit.MKBlock In html.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineImage(image As MarkdownKit.MKInlineImage) As Variant
		  Var node As New TreeViewNode("Inline Image")
		  node.AppendNode(New TreeViewNode("Start: " + image.Start.ToString))
		  node.AppendNode(New TreeViewNode("Destination: " + image.Destination))
		  If image.Title <> "" Then
		    node.AppendNode(New TreeViewNode("Title: " + image.Title))
		  End If
		  node.AppendNode(CreateNodeFromCharacters("Characters", image.Characters))
		  
		  For Each child As MarkdownKit.MKBlock In image.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineLink(link As MarkdownKit.MKInlineLink) As Variant
		  Var node As New TreeViewNode("Inline Link")
		  node.AppendNode(New TreeViewNode("Start: " + link.Start.ToString))
		  node.AppendNode(New TreeViewNode("Destination: " + link.Destination))
		  If link.Title <> "" Then
		    node.AppendNode(New TreeViewNode("Title: " + link.Title))
		  End If
		  node.AppendNode(CreateNodeFromCharacters("Characters", link.Characters))
		  
		  For Each child As MarkdownKit.MKBlock In link.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineText(it As MarkdownKit.MKInlineText) As Variant
		  Var node As New TreeViewNode("Inline Text")
		  node.AppendNode(CreateNodeFromCharacters("Contents", it.Characters))
		  node.AppendNode(New TreeViewNode("Start: " + it.Start.ToString))
		  node.AppendNode(New TreeViewNode("End Position: " + it.EndPosition.ToString))
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitList(list As MarkdownKit.MKListBlock) As Variant
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
		  For Each child As MarkdownKit.MKBlock In list.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitListItem(item As MarkdownKit.MKListItemBlock) As Variant
		  Var node As New TreeViewNode("List Item")
		  
		  node.AppendNode(New TreeViewNode("Start: " + item.Start.ToString))
		  node.AppendNode(New TreeViewNode("Line Position: " + item.ListData.LinePosition.ToString))
		  node.AppendNode(New TreeViewNode("Marker Offset: " + item.ListData.MarkerOffset.ToString))
		  node.AppendNode(New TreeViewNode("Marker Width: " + item.ListData.MarkerWidth.ToString))
		  
		  For Each child As MarkdownKit.MKBlock In item.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParagraph(p As MarkdownKit.MKParagraphBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Paragraph")
		  
		  node.AppendNode(CreateNodeFromCharacters("Raw Text", p.Characters))
		  node.AppendNode(New TreeViewNode("IsChildOfTightList: " + If(p.IsChildOfTightList, "True", "False")))
		  
		  For Each child As MarkdownKit.MKBlock In p.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSetextHeading(stx As MarkdownKit.MKSetextHeadingBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Setext Heading")
		  
		  node.AppendNode(CreateNodeFromCharacters("Title", stx.Characters))
		  node.AppendNode(New TreeViewNode("Start: " + stx.Start.ToString))
		  node.AppendNode(New TreeViewNode("Level: " + stx.Level.ToString))
		  node.AppendNode(New TreeViewNode("Underline Start (line, abs, local): " + _
		  stx.UnderlineLineNumber.ToString + ", " + stx.UnderlineStart.ToString + _
		  ", " + stx.UnderlineLocalStart.ToString))
		  node.AppendNode(New TreeViewNode("Underline Length: " + stx.UnderlineLength.ToString))
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSoftBreak(sb As MarkdownKit.MKSoftBreak) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Return New TreeViewNode("Soft Break (pos: " + sb.Start.ToString + ")")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitStrongEmphasis(se As MarkdownKit.MKStrongEmphasis) As Variant
		  Var node As New TreeViewNode("Strong Emphasis")
		  node.AppendNode(New TreeViewNode("Start: " + se.Start.ToString))
		  
		  For Each child As MarkdownKit.MKBlock In se.Children
		    node.AppendNode(child.Accept(Self))
		  Next child
		  
		  Return node
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitTextBlock(tb As MarkdownKit.MKTextBlock) As Variant
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
		Function VisitThematicBreak(tb As MarkdownKit.MKThematicBreak) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var node As New TreeViewNode("Thematic Break (abs: " + tb.Start.ToString + ", " + _
		  "local: " + tb.LocalStart.ToString + ", length: " + tb.Length.ToString + ")")
		  
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
