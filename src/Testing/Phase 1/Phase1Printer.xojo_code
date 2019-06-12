#tag Class
Protected Class Phase1Printer
Implements Global.MarkdownKit.IWalker
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
		  t = t.ReplaceAll("'", "&apos;")
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
		Sub VisitAtxHeading(atx As MarkdownKit.AtxHeading)
		  // Part of the MarkdownKit.IWalker interface.
		  
		  mOutput.Append(CurrentIndent + _
		  "<heading level=" + """" + atx.Level.ToText + """" +  ">")
		  mOutput.Append(EOL)
		  
		  If atx.RawChars.Ubound > -1 Then
		    IncreaseIndent
		    mOutput.Append(CurrentIndent + "<raw_text>")
		    
		    Dim content As Text = Text.Join(atx.RawChars, "")
		    If ShowWhitespace Then content = TransformWhitespace(content)
		    
		    mOutput.Append(content)
		    mOutput.Append("</raw_text>")
		    mOutput.Append(EOL)
		    DecreaseIndent
		  End If
		  
		  mOutput.Append(CurrentIndent + "</heading>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlock(b As MarkdownKit.Block)
		  // Part of the IWalker interface.
		  
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
		Sub VisitBlockQuote(bq As MarkdownKit.BlockQuote)
		  // Part of the IWalker interface.
		  
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
		Sub VisitDocument(d As MarkdownKit.Document)
		  // Part of the IWalker interface.
		  
		  mOutput.Append(CurrentIndent + "<document>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In d.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</document>")
		  
		  // Display the reference link map.
		  If d.ReferenceMap.Count > 0 Then
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
		Sub VisitFencedCode(f As MarkdownKit.FencedCode)
		  // Part of the IWalker interface.
		  
		  Dim info As Text = If(f.InfoString <> "", " info=" + """" + f.InfoString + """", "")
		  
		  mOutput.Append(CurrentIndent + "<fenced_code_block" + _
		  If(info <> "", info, "") + ">")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In f.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</fenced_code_block>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHTML(h As MarkdownKit.HTML)
		  // Part of the IWalker interface.
		  
		  mOutput.Append(CurrentIndent + "<html_block>")
		  
		  Dim content As Text = Text.Join(h.RawChars, "")
		  
		  // Since the reference AST ( https://spec.commonmark.org/dingus/ ) uses XML, we 
		  // encode the predefined entities in the content to to match.
		  content = EncodePredefinedEntities(content)
		  mOutput.Append(content)
		  
		  mOutput.Append("</html_block>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitIndentedCode(i As MarkdownKit.IndentedCode)
		  // Part of the IWalker interface.
		  
		  mOutput.Append(CurrentIndent + "<indented_code_block>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In i.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</indented_code_block>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitLinkReferenceDefinition(ref As MarkdownKit.LinkReferenceDefinition)
		  // Part of the IWalker interface.
		  
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
		Sub VisitList(theList As MarkdownKit.List)
		  // Part of the MarkdownKit.IWalker interface.
		  
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
		Sub VisitListItem(li As MarkdownKit.ListItem)
		  // Part of the MarkdownKit.IWalker interface.
		  
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
		Sub VisitParagraph(p As MarkdownKit.Paragraph)
		  // Part of the IWalker interface.
		  
		  mOutput.Append(CurrentIndent + "<paragraph>")
		  mOutput.Append(EOL)
		  
		  IncreaseIndent
		  mOutput.Append(CurrentIndent + "<raw_text>")
		  
		  Dim content As Text = Text.Join(p.RawChars, "")
		  If ShowWhitespace Then content = TransformWhitespace(content)
		  
		  mOutput.Append(content)
		  mOutput.Append("</raw_text>")
		  mOutput.Append(EOL)
		  DecreaseIndent
		  
		  mOutput.Append(CurrentIndent + "</paragraph>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSetextHeading(stx As MarkdownKit.SetextHeading)
		  // Part of the MarkdownKit.IWalker interface.
		  
		  mOutput.Append(CurrentIndent + _
		  "<heading level=" + """" + stx.Level.ToText + """" +  ">")
		  mOutput.Append(EOL)
		  
		  IncreaseIndent
		  mOutput.Append(CurrentIndent + "<raw_text>")
		  
		  Dim content As Text = Text.Join(stx.RawChars, "")
		  If ShowWhitespace Then content = TransformWhitespace(content)
		  
		  mOutput.Append(content)
		  mOutput.Append("</raw_text>")
		  mOutput.Append(EOL)
		  DecreaseIndent
		  
		  mOutput.Append(CurrentIndent + "</heading>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitTextBlock(tb As MarkdownKit.TextBlock)
		  // Part of the IWalker interface.
		  
		  mOutput.Append(CurrentIndent + "<text>")
		  
		  Dim content As Text = Text.Join(tb.Chars, "")
		  If ShowWhitespace Then content = TransformWhitespace(content)
		  
		  mOutput.Append(content)
		  mOutput.Append("</text>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitThematicBreak(tb As MarkdownKit.ThematicBreak)
		  // Part of the MarkdownKit.IWalker interface.
		  
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
	#tag EndViewBehavior
End Class
#tag EndClass
