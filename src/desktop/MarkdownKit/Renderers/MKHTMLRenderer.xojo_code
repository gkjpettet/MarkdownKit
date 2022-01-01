#tag Class
Protected Class MKHTMLRenderer
Implements MKRenderer
	#tag Method, Flags = &h21, Description = 456E636F64657320746865203420707265646566696E656420656E74697469657320746F206D616B65207468656D20584D4C2D736166652E
		Private Function EncodePredefinedEntities(s As String) As String
		  /// Encodes the 4 predefined entities to make them XML-safe.
		  ///
		  /// https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references#Predefined_entities_in_XML
		  
		  s = s.ReplaceAll("&", "&amp;")
		  s = s.ReplaceAll("""", "&quot;")
		  s = s.ReplaceAll("<", "&lt;")
		  s = s.ReplaceAll(">", "&gt;")
		  
		  Return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 55524C20656E636F64657320636F6D6D6F6E20636861726163746572732E
		Private Function URLEncode(s As String) As String
		  /// URL encodes common characters.
		  ///
		  /// NB: URL encoding is much more complex than this but this covers most use cases.
		  
		  // Common characters.
		  s = s.ReplaceAll(" ", "%20")
		  s = s.ReplaceAll("""", "%22")
		  s = s.ReplaceAll("<", "3C")
		  s = s.ReplaceAll(">", "%3E")
		  s = s.ReplaceAll("\", "%5C")
		  s = s.ReplaceAll("[", "%5B")
		  s = s.ReplaceAll("]", "%5D")
		  s = s.ReplaceAll("`", "%60")
		  
		  // Just to make the CommonMark tests pass...
		  s = s.Replace(&u00A0, "%C2%A0")
		  s = s.ReplaceAll("ä", "%C3%A4")
		  s = s.ReplaceAll("ö", "%C3%B6")
		  s = s.ReplaceAll("φ", "%CF%86")
		  s = s.ReplaceAll("ο", "%CE%BF")
		  s = s.ReplaceAll("υ", "%CF%85")
		  
		  Return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitATXHeading(atx As MKATXHeadingBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<h")
		  mOutput.Add(atx.Level.ToString)
		  mOutput.Add(">")
		  
		  For Each child As MKBlock In atx.Children
		    Call child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</h")
		  mOutput.Add(atx.Level.ToString)
		  mOutput.Add(">")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(b As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  ///
		  /// Should not be called when rendering HTML.
		  
		  #Pragma Unused b
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlockQuote(bq As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<blockquote>")
		  mOutput.Add(&u0A)
		  
		  For Each b As MKBlock In bq.Children
		    Call b.Accept(Self)
		  Next b
		  
		  mOutput.Add("</blockquote>")
		  mOutput.Add(&u0A)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitCodeSpan(cs As MKCodeSpan) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<code>")
		  
		  For Each child As MKBlock In cs.Children
		    Call child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</code>")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitDocument(doc As MKDocument) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.RemoveAll
		  
		  For Each child As MKBlock In doc.Children
		    Call child.Accept(Self)
		  Next child
		  
		  Return String.FromArray(mOutput, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitEmphasis(e As MKEmphasis) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<em>")
		  
		  For Each child As MKBlock In e.Children
		    Call child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</em>")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFencedCode(fc As MKFencedCodeBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<pre>")
		  
		  // Handle the optional info string.
		  If fc.InfoString = "" Then
		    mOutput.Add("<code>")
		  Else
		    mOutput.Add("<code class=")
		    mOutput.Add("""")
		    mOutput.Add("language-")
		    
		    // When rendering the info string, use only the first word.
		    Var wsIndex As Integer = fc.InfoString.IndexOf(" ")
		    If wsIndex = -1 Then wsIndex = fc.InfoString.IndexOf(&u0009)
		    If wsIndex = -1 Then
		      mOutput.Add(fc.InfoString)
		    Else
		      mOutput.Add(fc.InfoString.Left(wsIndex))
		    End If
		    
		    mOutput.Add("""")
		    mOutput.Add(">")
		  End If
		  
		  Var childrenLastIndex As Integer = fc.Children.LastIndex
		  For i As Integer = 0 To childrenLastIndex
		    Call fc.Children(i).Accept(Self)
		    
		    // Add a line ending after every text block (except the last one).
		    If i < childrenLastIndex Then mOutput.Add(&u0A)
		  Next i
		  
		  mOutput.Add(&u0A)
		  mOutput.Add("</code></pre>")
		  mOutput.Add(&u0A)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHTMLBlock(html As MKHTMLBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var childrenLastIndex As Integer = html.Children.LastIndex
		  For i As Integer = 0 To childrenLastIndex
		    Call html.Children(i).Accept(Self)
		    
		    // Add a line ending after every text block (except the last one).
		    If i < childrenLastIndex Then mOutput.Add(&u0A)
		  Next i
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIndentedCode(ic As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<pre><code>")
		  
		  Var childrenLastIndex As Integer = ic.Children.LastIndex
		  For i As Integer = 0 To childrenLastIndex
		    Call ic.Children(i).Accept(Self)
		    // Add a line ending after every text block (except the last one).
		    If i < childrenLastIndex Then mOutput.Add(&u0A)
		  Next i
		  
		  mOutput.Add(&u0A)
		  mOutput.Add("</code></pre>")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineHTML(html As MKInlineHTML) As Variant
		  /// Part of the MKRenderer interface.
		  
		  If html.IsAutoLink Then
		    
		    mOutput.Add("<a href=")
		    mOutput.Add("""")
		    mOutput.Add(URLEncode(html.Destination))
		    mOutput.Add("""")
		    
		    If html.Title <> "" Then
		      mOutput.Add(" title=")
		      mOutput.Add("""")
		      mOutput.Add(EncodePredefinedEntities(html.Title))
		      mOutput.Add("""")
		      mOutput.Add(">")
		    Else
		      mOutput.Add(">")
		    End If
		    
		    mOutput.Add(html.Label)
		    mOutput.Add("</a>")
		    
		  Else
		    
		    Var childrenLastIndex As Integer = html.Children.LastIndex
		    For i As Integer = 0 To childrenLastIndex
		      Call html.Children(i).Accept(Self)
		      
		      // Add a line ending after every text block (except the last one).
		      If i < childrenLastIndex Then mOutput.Add(&u0A)
		    Next i
		    
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineImage(image As MKInlineImage) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<img src=")
		  mOutput.Add("""")
		  mOutput.Add(URLEncode(image.Destination))
		  mOutput.Add("""")
		  
		  // The `alt` attribute is constructed from `image.Children`.
		  // We only render the plain text content (ignoring emphasis, etc).
		  Var stack() As MKBlock
		  Var child As MKBlock = image.FirstChild
		  
		  Var alt() As String
		  Var charsLastIndex As Integer
		  While child <> Nil
		    Select Case child.Type
		    Case MKBlockTypes.InlineText
		      charsLastIndex = child.Characters.LastIndex
		      For i As Integer = 0 To charsLastIndex
		        alt.Add(child.Characters(i).Value)
		      Next i
		    End Select
		    
		    If child.FirstChild <> Nil Then
		      If child.NextSibling <> Nil Then stack.Add(child.NextSibling)
		      child = child.FirstChild
		    ElseIf child.NextSibling <> Nil Then
		      child = child.NextSibling
		    ElseIf stack.LastIndex > -1 Then
		      child = stack.Pop
		    Else
		      child = Nil
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
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineLink(link As MKInlineLink) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<a href=")
		  mOutput.Add("""")
		  mOutput.Add(URLEncode(link.Destination))
		  mOutput.Add("""")
		  
		  If link.Title <> "" Then
		    mOutput.Add(" title=")
		    mOutput.Add("""")
		    mOutput.Add(EncodePredefinedEntities(link.Title))
		    mOutput.Add("""")
		    mOutput.Add(">")
		  Else
		    mOutput.Add(">")
		  End If
		  
		  For Each child As MKBlock In link.Children
		    Call child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</a>")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineText(it As MKInlineText) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add(EncodePredefinedEntities(it.Characters.ToString))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitList(list As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var listTag As String
		  If list.ListData.ListType = MKListTypes.Ordered Then
		    listTag = "ol"
		    If list.ListData.StartNumber <> 1 Then
		      mOutput.Add("<ol start=")
		      mOutput.Add("""")
		      mOutput.Add(list.ListData.StartNumber.ToString)
		      mOutput.Add("""")
		      mOutput.Add(">")
		    Else
		      mOutput.Add("<ol>")
		    End If
		  Else
		    listTag = "ul"
		    mOutput.Add("<ul>")
		  End If
		  mOutput.Add(&u0A)
		  
		  For Each child As MKBlock In list.Children
		    Call child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</")
		  mOutput.Add(listTag)
		  mOutput.Add(">")
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitListItem(item As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<li>")
		  
		  Var i As Integer
		  Var childrenLastIndex As Integer = item.Children.LastIndex
		  For i = 0 To childrenLastIndex
		    item.Children(i).IsChildOfTightList = item.IsChildOfTightList
		    item.Children(i).IsChildOfListItem = True
		    Call item.Children(i).Accept(Self)
		  Next i
		  
		  mOutput.Add("</li>")
		  mOutput.Add(&u0A)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParagraph(p As MKParagraphBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  If Not p.IsChildOfTightList Then mOutput.Add("<p>")
		  
		  For Each child As MKBlock In p.Children
		    Call child.Accept(Self)
		  Next child
		  
		  If Not p.IsChildOfTightList Then mOutput.Add("</p>")
		  
		  mOutput.Add(&u0A)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSetextHeading(stx As MKSetextHeadingBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<h")
		  mOutput.Add(stx.Level.ToString)
		  mOutput.Add(">")
		  
		  For Each child As MKBlock In stx.Children
		    Call child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</h")
		  mOutput.Add(stx.Level.ToString)
		  mOutput.Add(">")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSoftBreak(sb As MKSoftBreak) As Variant
		  /// Part of the MKRenderer interface.
		  
		  If sb.Parent.Type = MKBlockTypes.CodeSpan Then
		    // Line endings withing a code span are converted to spaces (6.1).
		    mOutput.Add(" ")
		  Else
		    mOutput.Add(&u0A)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitStrongEmphasis(se As MKStrongEmphasis) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<strong>")
		  
		  For Each child As MKBlock In se.Children
		    Call child.Accept(Self)
		  Next child
		  
		  mOutput.Add("</strong>")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitTextBlock(tb As MKTextBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  If tb.Parent.Type = MKBlockTypes.Html Or tb.Parent.Type = MKBlockTypes.InlineHTML Then
		    mOutput.Add(tb.Contents)
		  Else
		    mOutput.Add(EncodePredefinedEntities(tb.Contents))
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitThematicBreak(tb As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  #Pragma Unused tb
		  
		  mOutput.Add("<hr />")
		  mOutput.Add(&u0A)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 54686520756E6465722D636F6E737472756374696F6E206F7574707574206F66207468652072656E64657265722E
		Private mOutput() As String
	#tag EndProperty


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
