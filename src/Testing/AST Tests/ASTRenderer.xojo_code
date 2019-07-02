#tag Class
Protected Class ASTRenderer
Implements Global.MarkdownKit.IRenderer
	#tag Method, Flags = &h21
		Private Function CurrentIndent() As Text
		  // Given the current indentation level (specified by mCurrentIndent), this 
		  // method returns mCurrentIndent * 4 number of spaces as Text.
		  
		  If Not Pretty Then Return ""
		  
		  Dim numSpaces As Integer = mCurrentIndent * kSpacesPerIndent
		  Dim tmp() As Text
		  For i As Integer = 1 To numSpaces
		    tmp.Append(" ")
		  Next i
		  Return Text.Join(tmp, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DecreaseIndent()
		  mCurrentIndent = mCurrentIndent - 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodePredefinedEntities(t As Text) As Text
		  // Encodes the 5 predefined entities to make them XML-safe.
		  // https://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references#Predefined_entities_in_XML
		  
		  t = t.ReplaceAll("&", "&amp;")
		  t = t.ReplaceAll("""", "&quot;")
		  //t = t.ReplaceAll("'", "&apos;") ' Not used in the AST output from the CommonMark Dingus.
		  t = t.ReplaceAll("<", "&lt;")
		  t = t.ReplaceAll(">", "&gt;")
		  
		  Return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub IncreaseIndent()
		  mCurrentIndent = mCurrentIndent + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TransformWhitespace(t As Text) As Text
		  t = t.ReplaceAll(" ", "•")
		  t = t.ReplaceAll(&u0009, "→")
		  t = t.ReplaceAll(&u000A, "⮐")
		  
		  Return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitAtxHeading(atx As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + _
		  "<heading level=" + """" + atx.Level.ToText + """" +  ">")
		  mOutput.Append(EOL)
		  
		  For Each child As MarkdownKit.Block In atx.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Append(CurrentIndent + "</heading>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlock(b As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<block>")
		  mOutput.Append(EOL)
		  
		  For Each child As MarkdownKit.Block In b.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Append(CurrentIndent + "</block>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlockQuote(bq As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<block_quote>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In bq.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</block_quote>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitCodespan(cs As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<code>")
		  mOutput.Append(Text.Join(cs.Chars, ""))
		  mOutput.Append("</code>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitDocument(d As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<document>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In d.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</document>")
		  
		  // Display the reference link map.
		  If ListReferences And d.ReferenceMap.Count > 0 Then
		    // Since iterating through a dictionary does not guarantee order, 
		    // we will get the keys (definition names) as an array and sort 
		    // them alphabetically.
		    Dim keys() As Text
		    For Each entry As Xojo.Core.DictionaryEntry In d.ReferenceMap
		      keys.Append(entry.Key)
		    Next entry
		    keys.Sort
		    
		    mOutput.Append(EOL)
		    mOutput.Append(EOL)
		    DecreaseIndent
		    For i As Integer = 0 To keys.Ubound
		      IncreaseIndent
		      MarkdownKit.LinkReferenceDefinition(d.ReferenceMap.Value(keys(i))).Accept(Self)
		      DecreaseIndent
		    Next i
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitEmphasis(e As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<emph>")
		  mOutput.Append(EOL)
		  
		  For Each child As MarkdownKit.Block In e.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Append(CurrentIndent + "</emph>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitFencedCode(fc As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  Dim info As Text = If(fc.InfoString <> "", " info=" + """" + fc.InfoString + """", "")
		  
		  mOutput.Append(CurrentIndent + "<fenced_code_block" + _
		  If(info <> "", info, "") + ">")
		  mOutput.Append(EOL)
		  
		  Dim content As Text
		  For Each b As MarkdownKit.Block In fc.Children
		    IncreaseIndent
		    
		    mOutput.Append("<text>")
		    content = Text.Join(b.Chars, "")
		    If ShowWhitespace Then content = TransformWhitespace(content)
		    mOutput.Append(content)
		    mOutput.Append("</text>")
		    mOutput.Append(EOL)
		    
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</fenced_code_block>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHardbreak(hb As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  #Pragma Unused hb
		  
		  mOutput.Append(CurrentIndent + "<linebreak />")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHTMLBlock(h As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<html_block>")
		  
		  Dim content As Text = Text.Join(h.Chars, "")
		  
		  // Since the reference AST ( https://spec.commonmark.org/dingus/ ) uses XML, we 
		  // encode the predefined entities in the content to to match.
		  content = EncodePredefinedEntities(content)
		  mOutput.Append(content)
		  
		  mOutput.Append("</html_block>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitIndentedCode(ic As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<indented_code_block>")
		  mOutput.Append(EOL)
		  
		  Dim content As Text
		  For Each b As MarkdownKit.Block In ic.Children
		    IncreaseIndent
		    
		    mOutput.Append("<text>")
		    content = Text.Join(b.Chars, "")
		    If ShowWhitespace Then content = TransformWhitespace(content)
		    mOutput.Append(content)
		    mOutput.Append("</text>")
		    mOutput.Append(EOL)
		    
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</indented_code_block>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineHTML(h As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<html_inline>")
		  
		  // Since the reference AST ( https://spec.commonmark.org/dingus/ ) uses XML, we 
		  // encode the predefined entities in the content to to match.
		  Dim content As Text = Text.Join(h.Chars, "")
		  content = EncodePredefinedEntities(content)
		  mOutput.Append(content)
		  
		  mOutput.Append("</html_inline>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineImage(image As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<image destination=")
		  mOutput.Append("""")
		  mOutput.Append(EncodePredefinedEntities(image.Destination) + """" + " title=")
		  mOutput.Append("""" + EncodePredefinedEntities(image.Title) + """" + ">")
		  mOutput.Append(EOL)
		  
		  For Each child As MarkdownKit.Block In image.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Append(CurrentIndent + "</image>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineLink(l As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<link destination=")
		  mOutput.Append("""")
		  mOutput.Append(EncodePredefinedEntities(l.Destination) + """" + " title=")
		  mOutput.Append("""" + EncodePredefinedEntities(l.Title) + """" + ">")
		  mOutput.Append(EOL)
		  
		  If l.IsAutoLink Then
		    // The contents of autolinks are not inlines and are stored in the `Label` property of the link.
		    mOutput.Append(CurrentIndent + "<text>" + EncodePredefinedEntities(l.Label) + "</text>")
		    mOutput.Append(EOL)
		  Else
		    For Each child As MarkdownKit.Block In l.Children
		      IncreaseIndent
		      child.Accept(Self)
		      DecreaseIndent
		    Next child
		  End If
		  
		  mOutput.Append(CurrentIndent + "</link>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineText(t As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<text>")
		  mOutput.Append(Text.Join(t.Chars, ""))
		  mOutput.Append("</text>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitLinkReferenceDefinition(ref As MarkdownKit.LinkReferenceDefinition)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<reference_definition>")
		  mOutput.Append(EOL)
		  IncreaseIndent
		  mOutput.Append(CurrentIndent + "<name>" + ref.Name + "</name>")
		  mOutput.Append(EOL)
		  mOutput.Append(CurrentIndent + "<destination>" + ref.Destination + "</destination>")
		  mOutput.Append(EOL)
		  If ref.Title <> "" Then
		    mOutput.Append(CurrentIndent + "<title>" + ref.Title + "</title>")
		    mOutput.Append(EOL)
		  End If
		  DecreaseIndent
		  mOutput.Append(CurrentIndent + "</reference_definition>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitList(theList As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  Const Q = """"
		  
		  // Construct the list header.
		  Dim header As Text
		  If theList.ListData.ListType = MarkdownKit.ListType.Ordered Then
		    header = "type=" + Q + "ordered" + Q + " start=" + Q + _
		    thelist.ListData.Start.ToText + Q + " tight=" + Q + _
		    If(theList.ListData.IsTight, "true", "false") + Q + " delimiter=" + _
		    Q + If(theList.ListData.ListDelimiter = MarkdownKit.ListDelimiter.Period, "period", "paren") + Q
		  ElseIf theList.ListData.ListType = MarkdownKit.ListType.Bullet Then
		    header = "type=" + Q + "bullet" + Q + " tight=" + Q + _
		    If(theList.ListData.IsTight, "true", "false") + Q
		  End If
		  
		  mOutput.Append(CurrentIndent + "<list " + header + ">")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In theList.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</list>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitListItem(li As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<item>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In li.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</item>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitParagraph(p As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<paragraph>")
		  mOutput.Append(EOL)
		  
		  For Each child As MarkdownKit.Block In p.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Append(CurrentIndent + "</paragraph>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSetextHeading(stx As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + _
		  "<heading level=" + """" + stx.Level.ToText + """" +  ">")
		  mOutput.Append(EOL)
		  
		  For Each child As MarkdownKit.Block In stx.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Append(CurrentIndent + "</heading>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSoftbreak(sb As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  #Pragma Unused sb
		  
		  mOutput.Append(CurrentIndent + "<softbreak />")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitStrong(s As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Append(CurrentIndent + "<strong>")
		  mOutput.Append(EOL)
		  
		  For Each child As MarkdownKit.Block In s.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Append(CurrentIndent + "</strong>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitTextBlock(tb As MarkdownKit.Block)
		  mOutput.Append(CurrentIndent + "<text>")
		  mOutput.Append(Text.Join(tb.Chars, ""))
		  mOutput.Append("</text>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitThematicBreak(tb As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  #Pragma Unused tb
		  
		  mOutput.Append(CurrentIndent + "<thematic_break />")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  Return &u000A
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			End Set
		#tag EndSetter
		Private EOL As Text
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		ListReferences As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentIndent As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOutput() As Text
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Text.Join(mOutput, "").Trim
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			  
			End Set
		#tag EndSetter
		Output As Text
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Pretty As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ShowWhitespace As Boolean = False
	#tag EndProperty


	#tag Constant, Name = kSpacesPerIndent, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant


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
		#tag ViewProperty
			Name="Pretty"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowWhitespace"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ListReferences"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
