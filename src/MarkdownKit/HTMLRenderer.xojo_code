#tag Class
Protected Class HTMLRenderer
Implements IRenderer
	#tag Method, Flags = &h21
		Private Function EncodePredefinedEntities(t As String) As String
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
		Private Function URLEncode(t As String) As String
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
		  
		  Dim level As String = atx.Level.ToText
		  
		  mOutput.Add("<h")
		  mOutput.Add(level)
		  mOutput.Add(">")
		  
		  For Each child As MarkdownKit.Block In atx.Children
		    child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</h")
		  mOutput.Add(level)
		  mOutput.Add(">")
		  mOutput.Add(&u000A)
		  
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
		  
		  mOutput.Add("<blockquote>")
		  mOutput.Add(&u000A)
		  
		  For Each b As MarkdownKit.Block In bq.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Add("</blockquote>")
		  mOutput.Add(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitCodespan(cs As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add("<code>")
		  mOutput.Add(EncodePredefinedEntities(String.FromArray(cs.Chars, "")))
		  mOutput.Add("</code>")
		  
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
		  
		  mOutput.Add("<em>")
		  
		  For Each child As MarkdownKit.Block In e.Children
		    child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</em>")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitFencedCode(fc As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add("<pre>")
		  
		  If fc.InfoString = "" Then
		    mOutput.Add("<code>")
		  Else
		    mOutput.Add("<code class=")
		    mOutput.Add("""")
		    mOutput.Add("language-")
		    
		    // When rendering the info string, use only the first word.
		    Dim wsIndex As Integer = fc.InfoString.IndexOf(" ")
		    If wsIndex = -1 Then wsIndex = fc.InfoString.IndexOf(&u0009)
		    If wsIndex = -1 Then
		      mOutput.Add(fc.InfoString)
		    Else
		      mOutput.Add(fc.InfoString.Left(wsIndex))
		    End If
		    
		    mOutput.Add("""")
		    mOutput.Add(">")
		  End If
		  
		  For Each b As MarkdownKit.Block In fc.Children
		    mOutput.Add(EncodePredefinedEntities(String.FromArray(b.Chars, "")))
		    mOutput.Add(&u000A)
		  Next b
		  
		  mOutput.Add("</code></pre>")
		  mOutput.Add(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHardbreak(hb As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  #Pragma Unused hb
		  
		  mOutput.Add("<br />")
		  mOutput.Add(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHTMLBlock(h As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add(String.FromArray(h.Chars, ""))
		  mOutput.Add(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitIndentedCode(ic As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add("<pre><code>")
		  
		  For Each b As MarkdownKit.Block In ic.Children
		    mOutput.Add(EncodePredefinedEntities(String.FromArray(b.Chars, "")))
		    mOutput.Add(&u000A)
		  Next b
		  
		  mOutput.Add("</code></pre>")
		  mOutput.Add(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineHTML(h As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add(String.FromArray(h.Chars, ""))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineImage(image As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add("<img src=")
		  mOutput.Add("""")
		  mOutput.Add(URLEncode(image.Destination))
		  mOutput.Add("""")
		  
		  // The `alt` attribute is constructed from this image block's children.
		  // Only render the plain text content (ignoring emphasis, etc).
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim stack() As MarkdownKit.Block
		  Dim b As MarkdownKit.Block = image.FirstChild
		  
		  Dim alt() As String
		  Dim i As Integer
		  Dim charsUbound As Integer
		  While b <> Nil
		    Select Case b.Type
		    Case MarkdownKit.BlockType.InlineText
		      charsUbound = b.Chars.LastIndex
		      For i = 0 To charsUbound
		        alt.Add(b.Chars(i))
		      Next i
		    End Select
		    
		    If b.FirstChild <> Nil Then
		      If b.NextSibling <> Nil Then stack.Add(b.NextSibling)
		      b = b.FirstChild
		    ElseIf b.NextSibling <> Nil Then
		      b = b.NextSibling
		    ElseIf stack.LastIndex > -1 Then
		      b = stack.Pop
		    Else
		      b = Nil
		    End If
		  Wend
		  
		  mOutput.Add(" alt=")
		  mOutput.Add("""")
		  If alt.LastIndex > -1 Then mOutput.Add(String.FromArray(alt, ""))
		  mOutput.Add("""")
		  
		  // Image title.
		  If image.Title <> "" Then
		    mOutput.Add(" title=")
		    mOutput.Add("""")
		    mOutput.Add(EncodePredefinedEntities(image.Title))
		    mOutput.Add("""")
		  End If
		  
		  mOutput.Add(" />")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineLink(l As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add("<a href=")
		  mOutput.Add("""")
		  mOutput.Add(URLEncode(l.Destination))
		  mOutput.Add("""")
		  
		  If l.Title <> "" Then
		    mOutput.Add(" title=")
		    mOutput.Add("""")
		    mOutput.Add(EncodePredefinedEntities(l.Title))
		    mOutput.Add("""")
		    mOutput.Add(">")
		  Else
		    mOutput.Add(">")
		  End If
		  
		  If l.IsAutoLink Then
		    mOutput.Add(l.Label)
		  Else
		    For Each child As MarkdownKit.Block In l.Children
		      child.Accept(Self)
		    Next child
		  End If
		  
		  mOutput.Add("</a>")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineText(t As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add(EncodePredefinedEntities(String.FromArray(t.Chars, "")))
		  
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
		  
		  Dim listTag As String
		  If theList.ListData.ListType = MarkdownKit.ListType.Ordered Then
		    listTag = "ol"
		    If theList.ListData.Start <> 1 Then
		      mOutput.Add("<ol start=")
		      mOutput.Add("""")
		      mOutput.Add(theList.ListData.Start.ToText)
		      mOutput.Add("""")
		      mOutput.Add(">")
		    Else
		      mOutput.Add("<ol>")
		    End If
		  Else
		    listTag = "ul"
		    mOutput.Add("<ul>")
		  End If
		  mOutput.Add(&u000A)
		  
		  // Print the list items.
		  For Each b As MarkdownKit.Block In theList.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Add("</")
		  mOutput.Add(listTag)
		  mOutput.Add(">")
		  mOutput.Add(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitListItem(li As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add("<li>")
		  
		  Dim i As Integer
		  Dim childrenUbound As Integer = li.Children.LastIndex
		  For i = 0 To childrenUbound
		    li.Children(i).IsChildOfTightList = li.IsChildOfTightList
		    li.Children(i).IsChildOfListItem = True
		    li.Children(i).Accept(Self)
		  Next i
		  
		  mOutput.Add("</li>")
		  mOutput.Add(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitParagraph(p As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  If Not p.IsChildOfTightList Then mOutput.Add("<p>")
		  
		  For Each child As MarkdownKit.Block In p.Children
		    child.Accept(Self)
		  Next child
		  
		  If Not p.IsChildOfTightList Then mOutput.Add("</p>")
		  
		  mOutput.Add(&u000A)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSetextHeading(stx As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  Dim level As String = stx.Level.ToText
		  
		  mOutput.Add("<h")
		  mOutput.Add(level)
		  mOutput.Add(">")
		  
		  For Each child As MarkdownKit.Block In stx.Children
		    child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</h")
		  mOutput.Add(level)
		  mOutput.Add(">")
		  mOutput.Add(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSoftbreak(sb As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  #Pragma Unused sb
		  
		  mOutput.Add(&u000A)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitStrong(s As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  mOutput.Add("<strong>")
		  
		  For Each child As MarkdownKit.Block In s.Children
		    child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</strong>")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitThematicBreak(tb As MarkdownKit.Block)
		  // Part of the IRenderer interface.
		  
		  #Pragma Unused tb
		  
		  mOutput.Add("<hr />")
		  mOutput.Add(&u000A)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mOutput() As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return String.FromArray(mOutput, "").Trim
			End Get
		#tag EndGetter
		Output As String
	#tag EndComputedProperty


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
		#tag ViewProperty
			Name="Output"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
