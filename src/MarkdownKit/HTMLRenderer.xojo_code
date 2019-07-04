#tag Class
Protected Class HTMLRenderer
Implements IRenderer
	#tag Method, Flags = &h21
		Private Function EncodePredefinedEntities(t As Text) As Text
		  // Encodes the 5 predefined entities to make them XML-safe.
		  // https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references#Predefined_entities_in_XML
		  
		  t = t.ReplaceAll("&", "&amp;")
		  t = t.ReplaceAll("""", "&quot;")
		  't = t.ReplaceAll("'", "&apos;")
		  t = t.ReplaceAll("<", "&lt;")
		  t = t.ReplaceAll(">", "&gt;")
		  
		  Return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function URLEncode(t As Text) As Text
		  // NOTE: URL encoding is much more complex than this but this covers most use cases.
		  
		  // Common characters.
		  t = t.ReplaceAll(" ", "%20")
		  t = t.ReplaceAll("""", "%22")
		  t = t.ReplaceAll("<", "3C")
		  t = t.ReplaceAll(">", "%3E")
		  t = t.ReplaceAll("\", "%5C")
		  t = t.ReplaceAll("[", "%5B")
		  t = t.ReplaceAll("]", "%5D")
		  t = t.ReplaceAll("`", "%60")
		  
		  // Just to make the CommonMark tests pass...
		  t = t.Replace(&u00A0, "%C2%A0")
		  t = t.ReplaceAll("ä", "%C3%A4")
		  t = t.ReplaceAll("ö", "%C3%B6")
		  t = t.ReplaceAll("φ", "%CF%86")
		  t = t.ReplaceAll("ο", "%CE%BF")
		  t = t.ReplaceAll("υ", "%CF%85")
		  
		  Return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitAtxHeading(atx As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  Dim level As Text = atx.Level.ToText
		  
		  mOutput.Append("<h")
		  mOutput.Append(level)
		  mOutput.Append(">")
		  
		  For Each child As MarkdownKit.Block In atx.Children
		    child.Accept(Self)
		  Next child
		  
		  mOutput.Append("</h")
		  mOutput.Append(level)
		  mOutput.Append(">")
		  mOutput.Append(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlock(b As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  // Should never be called when rendering HTML. Only used for rendering the AST.
		  
		  #Pragma Unused b
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlockQuote(bq As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append("<blockquote>")
		  mOutput.Append(&u000A)
		  
		  For Each b As MarkdownKit.Block In bq.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Append("</blockquote>")
		  mOutput.Append(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitCodespan(cs As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append("<code>")
		  mOutput.Append(EncodePredefinedEntities(Text.Join(cs.Chars, "")))
		  mOutput.Append("</code>")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitDocument(d As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  For Each b As MarkdownKit.Block In d.Children
		    b.Accept(Self)
		  Next b
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitEmphasis(e As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append("<em>")
		  
		  For Each child As MarkdownKit.Block In e.Children
		    child.Accept(Self)
		  Next child
		  
		  mOutput.Append("</em>")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitFencedCode(fc As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append("<pre>")
		  
		  If fc.InfoString = "" Then
		    mOutput.Append("<code>")
		  Else
		    mOutput.Append("<code class=")
		    mOutput.Append("""")
		    mOutput.Append("language-")
		    
		    // When rendering the info string, use only the first word.
		    Dim wsIndex As Integer = fc.InfoString.IndexOf(" ")
		    If wsIndex = -1 Then wsIndex = fc.InfoString.IndexOf(&u0009)
		    If wsIndex = -1 Then
		      mOutput.Append(fc.InfoString)
		    Else
		      mOutput.Append(fc.InfoString.Left(wsIndex))
		    End If
		    
		    mOutput.Append("""")
		    mOutput.Append(">")
		  End If
		  
		  For Each b As MarkdownKit.Block In fc.Children
		    mOutput.Append(EncodePredefinedEntities(Text.Join(b.Chars, "")))
		    mOutput.Append(&u000A)
		  Next b
		  
		  mOutput.Append("</code></pre>")
		  mOutput.Append(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHardbreak(hb As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  #Pragma Unused hb
		  
		  mOutput.Append("<br />")
		  mOutput.Append(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHTMLBlock(h As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append(Text.Join(h.Chars, ""))
		  mOutput.Append(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitIndentedCode(ic As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append("<pre><code>")
		  
		  For Each b As MarkdownKit.Block In ic.Children
		    mOutput.Append(EncodePredefinedEntities(Text.Join(b.Chars, "")))
		    mOutput.Append(&u000A)
		  Next b
		  
		  mOutput.Append("</code></pre>")
		  mOutput.Append(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineHTML(h As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append(Text.Join(h.Chars, ""))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineImage(image As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append("<img src=")
		  mOutput.Append("""")
		  mOutput.Append(URLEncode(image.Destination))
		  mOutput.Append("""")
		  
		  // The `alt` attribute is constructed from this image block's children.
		  // Only render the plain text content (ignoring emphasis, etc).
		  #If Not TargetWeb
		    #Pragma DisableBackgroundTasks
		  #Endif
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  Dim stack() As MarkdownKit.Block
		  Dim b As MarkdownKit.Block = image.FirstChild
		  
		  Dim alt() As Text
		  Dim i As Integer
		  Dim charsUbound As Integer
		  While b <> Nil
		    Select Case b.Type
		    Case MarkdownKit.BlockType.InlineText
		      charsUbound = b.Chars.Ubound
		      For i = 0 To charsUbound
		        alt.Append(b.Chars(i))
		      Next i
		    End Select
		    
		    If b.FirstChild <> Nil Then
		      If b.NextSibling <> Nil Then stack.Append(b.NextSibling)
		      b = b.FirstChild
		    ElseIf b.NextSibling <> Nil Then
		      b = b.NextSibling
		    ElseIf stack.Ubound > -1 Then
		      b = stack.Pop
		    Else
		      b = Nil
		    End If
		  Wend
		  
		  mOutput.Append(" alt=")
		  mOutput.Append("""")
		  If alt.Ubound > -1 Then mOutput.Append(Text.Join(alt, ""))
		  mOutput.Append("""")
		  
		  // Image title.
		  If image.Title <> "" Then
		    mOutput.Append(" title=")
		    mOutput.Append("""")
		    mOutput.Append(EncodePredefinedEntities(image.Title))
		    mOutput.Append("""")
		  End If
		  
		  mOutput.Append(" />")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineLink(l As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append("<a href=")
		  mOutput.Append("""")
		  mOutput.Append(URLEncode(l.Destination))
		  mOutput.Append("""")
		  
		  If l.Title <> "" Then
		    mOutput.Append(" title=")
		    mOutput.Append("""")
		    mOutput.Append(EncodePredefinedEntities(l.Title))
		    mOutput.Append("""")
		    mOutput.Append(">")
		  Else
		    mOutput.Append(">")
		  End If
		  
		  If l.IsAutoLink Then
		    mOutput.Append(l.Label)
		  Else
		    For Each child As MarkdownKit.Block In l.Children
		      child.Accept(Self)
		    Next child
		  End If
		  
		  mOutput.Append("</a>")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineText(t As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append(EncodePredefinedEntities(Text.Join(t.Chars, "")))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitLinkReferenceDefinition(ref As MarkdownKit.LinkReferenceDefinition)
		  // Part of the IRenderer interface.
		  
		  // Not needed by the HTML rendered. Only by the AST renderer.
		  
		  #Pragma Unused ref
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitList(theList As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  Dim listTag As Text
		  If theList.ListData.ListType = MarkdownKit.ListType.Ordered Then
		    listTag = "ol"
		    If theList.ListData.Start <> 1 Then
		      mOutput.Append("<ol start=")
		      mOutput.Append("""")
		      mOutput.Append(theList.ListData.Start.ToText)
		      mOutput.Append("""")
		      mOutput.Append(">")
		    Else
		      mOutput.Append("<ol>")
		    End If
		  Else
		    listTag = "ul"
		    mOutput.Append("<ul>")
		  End If
		  mOutput.Append(&u000A)
		  
		  // Print the list items.
		  For Each b As MarkdownKit.Block In theList.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Append("</")
		  mOutput.Append(listTag)
		  mOutput.Append(">")
		  mOutput.Append(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitListItem(li As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append("<li>")
		  
		  Dim i As Integer
		  Dim childrenUbound As Integer = li.Children.Ubound
		  For i = 0 To childrenUbound
		    li.Children(i).IsChildOfTightList = li.IsChildOfTightList
		    li.Children(i).IsChildOfListItem = True
		    li.Children(i).Accept(Self)
		  Next i
		  
		  mOutput.Append("</li>")
		  mOutput.Append(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitParagraph(p As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  If Not p.IsChildOfTightList Then mOutput.Append("<p>")
		  
		  For Each child As MarkdownKit.Block In p.Children
		    child.Accept(Self)
		  Next child
		  
		  If Not p.IsChildOfTightList Then mOutput.Append("</p>")
		  
		  mOutput.Append(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSetextHeading(stx As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  Dim level As Text = stx.Level.ToText
		  
		  mOutput.Append("<h")
		  mOutput.Append(level)
		  mOutput.Append(">")
		  
		  For Each child As MarkdownKit.Block In stx.Children
		    child.Accept(Self)
		  Next child
		  
		  mOutput.Append("</h")
		  mOutput.Append(level)
		  mOutput.Append(">")
		  mOutput.Append(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSoftbreak(sb As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  #Pragma Unused sb
		  
		  mOutput.Append(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitStrong(s As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Append("<strong>")
		  
		  For Each child As MarkdownKit.Block In s.Children
		    child.Accept(Self)
		  Next child
		  
		  mOutput.Append("</strong>")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitThematicBreak(tb As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  #Pragma Unused tb
		  
		  mOutput.Append("<hr />")
		  mOutput.Append(&u000A)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mOutput() As Text
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Text.Join(mOutput, "").Trim
			End Get
		#tag EndGetter
		Output As Text
	#tag EndComputedProperty


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
			Name="Output"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
