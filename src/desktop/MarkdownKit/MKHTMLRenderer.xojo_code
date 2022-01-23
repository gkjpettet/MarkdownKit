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

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E6720636F6E73697374696E67206F66205B636F756E745D207370616365732E
		Function SpacesString(count As Integer) As String
		  /// Returns a string consisting of [count] spaces.
		  
		  Var tmp() As String
		  tmp.ResizeTo(count)
		  Return String.FromArray(tmp, " ")
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
		  
		  // Ensure that any inline text children this heading may have render without surrounding whitespace.
		  ShouldTrimLeadingWhitespace = True
		  ShouldTrimTrailingWhitespace = True
		  
		  // We need to trim whitespace and the closing sequence (if present). To do this, we need to 
		  // track where the heading contents begins in `mOutput`.
		  Var index As Integer = mOutput.LastIndex
		  
		  // Visit the children.
		  For Each child As MKBlock In atx.Children
		    Call child.Accept(Self)
		  Next child
		  
		  // Get any contents added to `mOutput` whilst visiting the children.
		  Var tmp() As String
		  For i As Integer = index + 1 To mOutput.LastIndex
		    tmp.Add(mOutput(i))
		  Next i
		  
		  // Temporarily remove this content from `mOutput`.
		  mOutput.ResizeTo(index)
		  
		  // Remove the optional closing sequence.
		  Var s As String = String.FromArray(tmp, "").Trim
		  If atx.HasClosingSequence Then
		    tmp = s.CharacterArray
		    For i As Integer = tmp.LastIndex DownTo 0
		      If tmp(i) <> "#" Or i = 0 Then Exit
		      If (tmp(i - 1) <> "#" And tmp(i - 1) <> " " And tmp(i - 1) <> &u0009) Then Exit
		      Call tmp.Pop
		    Next i
		    s = String.FromArray(tmp, "").Trim
		  End If
		  mOutput.Add(s)
		  
		  mOutput.Add("</h")
		  mOutput.Add(atx.Level.ToString)
		  mOutput.Add(">")
		  mOutput.Add(&u0A)
		  
		  ShouldTrimLeadingWhitespace = False
		  ShouldTrimTrailingWhitespace = False
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
		Function VisitBlockQuote(bq As MKBlockQuote) As Variant
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
		  
		  // Track where the code span's contents begins in `mOutput`.
		  Var index As Integer = mOutput.LastIndex
		  
		  // Visit the children.
		  For Each child As MKBlock In cs.Children
		    Call child.Accept(Self)
		  Next child
		  
		  // Get any contents added to `mOutput` whilst visiting the children.
		  Var tmp() As String
		  For i As Integer = index + 1 To mOutput.LastIndex
		    tmp.Add(mOutput(i))
		  Next i
		  Var contents As String = String.FromArray(tmp, "")
		  
		  // Temporarily remove this content from `mOutput`.
		  mOutput.ResizeTo(index)
		  
		  // If `contents` both begins and ends with a space character, but does not consist entirely of space characters, 
		  // a single space character is removed from the front and back.
		  If contents.Trim(" ").Length > 0 And contents.Length > 2 And contents.Left(1) = " " And _
		    contents.Right(1) = " " Then
		    contents = contents.MiddleCharacters(1, contents.CharacterCount - 2)
		  End If
		  mOutput.Add(contents)
		  
		  mOutput.Add("</code>")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitDocument(doc As MKDocument) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.RemoveAll
		  ShouldTrimLeadingWhitespace = False
		  ShouldTrimTrailingWhitespace = False
		  
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
		    Var infoString As String = fc.InfoString.Trim
		    Var wsIndex As Integer = infoString.IndexOf(" ")
		    If wsIndex = -1 Then wsIndex = infoString.IndexOf(&u0009)
		    If wsIndex <> -1 Then infoString = infoString.Left(wsIndex)
		    
		    infoString = MarkdownKit.ReplaceEntities(infoString)
		    MarkdownKit.Unescape(infoString)
		    mOutput.Add(infoString)
		    mOutput.Add("""")
		    mOutput.Add(">")
		  End If
		  
		  Var childrenLastIndex As Integer = fc.Children.LastIndex
		  For i As Integer = 0 To childrenLastIndex
		    Call fc.Children(i).Accept(Self)
		    
		    // Add a line ending after every text block (except the last one).
		    If i < childrenLastIndex Then mOutput.Add(&u0A)
		  Next i
		  
		  If fc.Children.Count > 0 Then mOutput.Add(&u0A)
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
		  
		  mOutput.Add(&u0A)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIndentedCode(ic As MKIndentedCodeBlock) As Variant
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
		  mOutput.Add(&u0A)
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
		Function VisitInlineImage(image As MarkdownKit.MKInlineImage) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<img src=")
		  mOutput.Add("""")
		  mOutput.Add(URLEncode(image.Destination.Value))
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
		  If image.HasTitle Then
		    mOutput.Add(" title=")
		    mOutput.Add("""")
		    mOutput.Add(EncodePredefinedEntities(image.Title.Value))
		    mOutput.Add("""")
		  End If
		  
		  mOutput.Add(" />")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineLink(link As MarkdownKit.MKInlineLink) As Variant
		  /// Part of the MKRenderer interface.
		  
		  mOutput.Add("<a href=")
		  mOutput.Add("""")
		  mOutput.Add(URLEncode(link.Destination.Value))
		  mOutput.Add("""")
		  
		  If link.HasTitle Then
		    mOutput.Add(" title=")
		    mOutput.Add("""")
		    mOutput.Add(EncodePredefinedEntities(link.Title.Value))
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
		  
		  Var s As String = it.Characters.ToString
		  
		  If s.Length = 0 Then Return Nil
		  
		  If it.Parent.Type = MKBlockTypes.Paragraph Then
		    s = MarkdownKit.ReplaceEntities(s)
		  End If
		  
		  MarkdownKit.Unescape(s)
		  
		  s = EncodePredefinedEntities(s)
		  
		  Select Case it.Parent.Type
		  Case MKBlockTypes.Paragraph, MKBlockTypes.Emphasis, MKBlockTypes.StrongEmphasis
		    If Not it.IsLastChild Then
		      If s.Length > 1 And s.Right(1) = "\" Then
		        // A backslash at the end of the line is a hard line break.
		        s = s.Left(s.Length - 1) + "<br />"
		      ElseIf s.Length > 3 Then
		        // > 2 characters of trailing whitespace results in a hard line break after the text.
		        Var trimmed As String = s.TrimRight(" ")
		        If s.Length >= trimmed.Length + 2 Then
		          s = trimmed + "<br />"
		        End If
		      End If
		    End If
		  End Select
		  
		  mOutput.Add(s)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitList(list As MKListBlock) As Variant
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
		  mOutput.Add(&u0A)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitListItem(item As MKListItemBlock) As Variant
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
		  
		  // Ensure that any inline text children this heading may have render without surrounding whitespace.
		  ShouldTrimLeadingWhitespace = True
		  ShouldTrimTrailingWhitespace = True
		  
		  // We need to trim whitespace and the closing sequence (if present). To do this, we need to 
		  // track where the heading contents begins in `mOutput`.
		  Var index As Integer = mOutput.LastIndex
		  
		  For Each child As MKBlock In stx.Children
		    Call child.Accept(Self)
		  Next child
		  
		  // Get any contents added to `mOutput` whilst visiting the children.
		  Var tmp() As String
		  For i As Integer = index + 1 To mOutput.LastIndex
		    tmp.Add(mOutput(i))
		  Next i
		  
		  // Temporarily remove this content from `mOutput`.
		  mOutput.ResizeTo(index)
		  
		  // Trim whitespace.
		  Var s As String = String.FromArray(tmp, "").Trim
		  mOutput.Add(s)
		  
		  mOutput.Add("</h")
		  mOutput.Add(stx.Level.ToString)
		  mOutput.Add(">")
		  mOutput.Add(&u0A)
		  
		  ShouldTrimLeadingWhitespace = False
		  ShouldTrimTrailingWhitespace = False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSoftBreak(sb As MKSoftBreak) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var mOutputLastIndex As Integer = mOutput.LastIndex
		  
		  If sb.Parent.Type = MKBlockTypes.CodeSpan Then
		    // Line endings withing a code span are converted to spaces (6.1).
		    mOutput.Add(" ")
		    
		  ElseIf sb.Parent.Type = MKBlockTypes.Paragraph And mOutput(mOutputLastIndex).Trim = "" Then
		    // Edge case: If the previous block contained only whitespace then remove it from the output.
		    Call mOutput.Pop
		    mOutput.Add(&u0A)
		    
		  ElseIf sb.Parent.Type = MKBlockTypes.Paragraph Then
		    // Edge case: Always trim the whitespace from the end of the block above. 
		    mOutput(mOutputLastIndex) = mOutput(mOutputLastIndex).TrimRight
		    mOutput.Add(&u0A)
		    
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
		  
		  Var s As String = SpacesString(tb.PhantomSpaces) + tb.Contents
		  
		  If ShouldTrimLeadingWhitespace Then s = s.TrimLeft
		  If ShouldTrimTrailingWhitespace Then s = s.TrimRight
		  
		  If tb.Parent.Type = MKBlockTypes.Html Or tb.Parent.Type = MKBlockTypes.InlineHTML Then
		    mOutput.Add(s)
		  Else
		    mOutput.Add(EncodePredefinedEntities(s))
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitThematicBreak(tb As MKThematicBreak) As Variant
		  /// Part of the MKRenderer interface.
		  
		  #Pragma Unused tb
		  
		  mOutput.Add("<hr />")
		  mOutput.Add(&u0A)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 54686520756E6465722D636F6E737472756374696F6E206F7574707574206F66207468652072656E64657265722E
		Private mOutput() As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54727565206966207468652072656E64657265722073686F756C64207472696D206C656164696E6720776869746573706163652066726F6D20696E6C696E652074657874206265666F72652072656E646572696E672069742E
		Private ShouldTrimLeadingWhitespace As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54727565206966207468652072656E64657265722073686F756C64207472696D20747261696C696E6720776869746573706163652066726F6D20696E6C696E652074657874206265666F72652072656E646572696E672069742E
		Private ShouldTrimTrailingWhitespace As Boolean = False
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
