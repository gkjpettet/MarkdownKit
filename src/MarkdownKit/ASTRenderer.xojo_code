#tag Class
Protected Class ASTRenderer
Implements Global.MarkdownKit.IRenderer
	#tag Method, Flags = &h21, Description = 52657475726E7320746865207265717569726564206E756D626572206F662073706163657320746F20726570726573656E74207468652063757272656E7420696E64656E742E
		Private Function CurrentIndent() As String
		  /// Returns the required number of spaces to represent the current indent.
		  
		  If Not Pretty Then Return ""
		  
		  Var numSpaces As Integer = mCurrentIndent * SPACES_PER_INDENT
		  Var tmp() As String
		  For i As Integer = 1 To numSpaces
		    tmp.Add(" ")
		  Next i
		  
		  Return String.FromArray(tmp, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DecreaseIndent()
		  mCurrentIndent = mCurrentIndent - 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function EncodePredefinedEntities(t As String) As String
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
		Private Function TransformWhitespace(t As String) As String
		  t = t.ReplaceAll(" ", "•")
		  t = t.ReplaceAll(&u0009, "→")
		  t = t.ReplaceAll(&u000A, "⮐")
		  
		  Return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitAtxHeading(atx As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + _
		  "<heading level=" + """" + atx.Level.ToText + """" +  ">")
		  mOutput.Add(EOL)
		  
		  For Each child As MarkdownKit.Block In atx.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Add(CurrentIndent + "</heading>")
		  mOutput.Add(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlock(b As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<block>")
		  mOutput.Add(EOL)
		  
		  For Each child As MarkdownKit.Block In b.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Add(CurrentIndent + "</block>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlockQuote(bq As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<block_quote>")
		  mOutput.Add(EOL)
		  
		  For Each b As MarkdownKit.Block In bq.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Add(CurrentIndent + "</block_quote>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitCodespan(cs As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<code>")
		  mOutput.Add(String.FromArray(cs.Chars, ""))
		  mOutput.Add("</code>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitDocument(d As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<document>")
		  mOutput.Add(EOL)
		  
		  For Each b As MarkdownKit.Block In d.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Add(CurrentIndent + "</document>")
		  
		  // Display the reference link map.
		  If ListReferences And d.ReferenceMap.Count > 0 Then
		    // Since iterating through a dictionary does not guarantee order, 
		    // we will get the keys (definition names) as an array and sort 
		    // them alphabetically.
		    Dim keys() As String
		    For Each entry As DictionaryEntry In d.ReferenceMap
		      keys.Add(entry.Key)
		    Next entry
		    keys.Sort
		    
		    mOutput.Add(EOL)
		    mOutput.Add(EOL)
		    DecreaseIndent
		    For i As Integer = 0 To keys.LastIndex
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
		  
		  mOutput.Add(CurrentIndent + "<emph>")
		  mOutput.Add(EOL)
		  
		  For Each child As MarkdownKit.Block In e.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Add(CurrentIndent + "</emph>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitFencedCode(fc As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  Dim info As String = If(fc.InfoString <> "", " info=" + """" + fc.InfoString + """", "")
		  
		  mOutput.Add(CurrentIndent + "<fenced_code_block" + _
		  If(info <> "", info, "") + ">")
		  mOutput.Add(EOL)
		  
		  Dim content As String
		  For Each b As MarkdownKit.Block In fc.Children
		    IncreaseIndent
		    
		    mOutput.Add("<text>")
		    content = String.FromArray(b.Chars, "")
		    If ShowWhitespace Then content = TransformWhitespace(content)
		    mOutput.Add(content)
		    mOutput.Add("</text>")
		    mOutput.Add(EOL)
		    
		    DecreaseIndent
		  Next b
		  
		  mOutput.Add(CurrentIndent + "</fenced_code_block>")
		  mOutput.Add(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHardbreak(hb As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  #Pragma Unused hb
		  
		  mOutput.Add(CurrentIndent + "<linebreak />")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHTMLBlock(h As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<html_block>")
		  
		  Dim content As String = String.FromArray(h.Chars, "")
		  
		  // Since the reference AST ( https://spec.commonmark.org/dingus/ ) uses XML, we 
		  // encode the predefined entities in the content to to match.
		  content = EncodePredefinedEntities(content)
		  mOutput.Add(content)
		  
		  mOutput.Add("</html_block>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitIndentedCode(ic As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<indented_code_block>")
		  mOutput.Add(EOL)
		  
		  Dim content As String
		  For Each b As MarkdownKit.Block In ic.Children
		    IncreaseIndent
		    
		    mOutput.Add("<text>")
		    content = String.FromArray(b.Chars, "")
		    If ShowWhitespace Then content = TransformWhitespace(content)
		    mOutput.Add(content)
		    mOutput.Add("</text>")
		    mOutput.Add(EOL)
		    
		    DecreaseIndent
		  Next b
		  
		  mOutput.Add(CurrentIndent + "</indented_code_block>")
		  mOutput.Add(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineHTML(h As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<html_inline>")
		  
		  // Since the reference AST ( https://spec.commonmark.org/dingus/ ) uses XML, we 
		  // encode the predefined entities in the content to to match.
		  Dim content As String = String.FromArray(h.Chars, "")
		  content = EncodePredefinedEntities(content)
		  mOutput.Add(content)
		  
		  mOutput.Add("</html_inline>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineImage(image As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<image destination=")
		  mOutput.Add("""")
		  mOutput.Add(EncodePredefinedEntities(image.Destination) + """" + " title=")
		  mOutput.Add("""" + EncodePredefinedEntities(image.Title) + """" + ">")
		  mOutput.Add(EOL)
		  
		  For Each child As MarkdownKit.Block In image.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Add(CurrentIndent + "</image>")
		  mOutput.Add(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineLink(l As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<link destination=")
		  mOutput.Add("""")
		  mOutput.Add(EncodePredefinedEntities(l.Destination) + """" + " title=")
		  mOutput.Add("""" + EncodePredefinedEntities(l.Title) + """" + ">")
		  mOutput.Add(EOL)
		  
		  If l.IsAutoLink Then
		    // The contents of autolinks are not inlines and are stored in the `Label` property of the link.
		    mOutput.Add(CurrentIndent + "<text>" + EncodePredefinedEntities(l.Label) + "</text>")
		    mOutput.Add(EOL)
		  Else
		    For Each child As MarkdownKit.Block In l.Children
		      IncreaseIndent
		      child.Accept(Self)
		      DecreaseIndent
		    Next child
		  End If
		  
		  mOutput.Add(CurrentIndent + "</link>")
		  mOutput.Add(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitInlineText(t As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<text>")
		  mOutput.Add(String.FromArray(t.Chars, ""))
		  mOutput.Add("</text>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitLinkReferenceDefinition(ref As MarkdownKit.LinkReferenceDefinition)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<reference_definition>")
		  mOutput.Add(EOL)
		  IncreaseIndent
		  mOutput.Add(CurrentIndent + "<name>" + ref.Name + "</name>")
		  mOutput.Add(EOL)
		  mOutput.Add(CurrentIndent + "<destination>" + ref.Destination + "</destination>")
		  mOutput.Add(EOL)
		  If ref.Title <> "" Then
		    mOutput.Add(CurrentIndent + "<title>" + ref.Title + "</title>")
		    mOutput.Add(EOL)
		  End If
		  DecreaseIndent
		  mOutput.Add(CurrentIndent + "</reference_definition>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitList(theList As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  Const Q = """"
		  
		  // Construct the list header.
		  Dim header As String
		  If theList.ListData.ListType = MarkdownKit.ListType.Ordered Then
		    header = "type=" + Q + "ordered" + Q + " start=" + Q + _
		    thelist.ListData.Start.ToText + Q + " tight=" + Q + _
		    If(theList.ListData.IsTight, "true", "false") + Q + " delimiter=" + _
		    Q + If(theList.ListData.ListDelimiter = MarkdownKit.ListDelimiter.Period, "period", "paren") + Q
		  ElseIf theList.ListData.ListType = MarkdownKit.ListType.Bullet Then
		    header = "type=" + Q + "bullet" + Q + " tight=" + Q + _
		    If(theList.ListData.IsTight, "true", "false") + Q
		  End If
		  
		  mOutput.Add(CurrentIndent + "<list " + header + ">")
		  mOutput.Add(EOL)
		  
		  For Each b As MarkdownKit.Block In theList.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Add(CurrentIndent + "</list>")
		  mOutput.Add(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitListItem(li As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<item>")
		  mOutput.Add(EOL)
		  
		  For Each b As MarkdownKit.Block In li.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Add(CurrentIndent + "</item>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitParagraph(p As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<paragraph>")
		  mOutput.Add(EOL)
		  
		  For Each child As MarkdownKit.Block In p.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Add(CurrentIndent + "</paragraph>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSetextHeading(stx As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + _
		  "<heading level=" + """" + stx.Level.ToText + """" +  ">")
		  mOutput.Add(EOL)
		  
		  For Each child As MarkdownKit.Block In stx.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Add(CurrentIndent + "</heading>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSoftbreak(sb As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  #Pragma Unused sb
		  
		  mOutput.Add(CurrentIndent + "<softbreak />")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitStrong(s As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  mOutput.Add(CurrentIndent + "<strong>")
		  mOutput.Add(EOL)
		  
		  For Each child As MarkdownKit.Block In s.Children
		    IncreaseIndent
		    child.Accept(Self)
		    DecreaseIndent
		  Next child
		  
		  mOutput.Add(CurrentIndent + "</strong>")
		  mOutput.Add(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitThematicBreak(tb As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.IRenderer interface.
		  
		  #Pragma Unused tb
		  
		  mOutput.Add(CurrentIndent + "<thematic_break />")
		  mOutput.Add(EOL)
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
		Private EOL As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		ListReferences As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mCurrentIndent As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOutput() As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return String.FromArray(mOutput, "").Trim
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			  
			End Set
		#tag EndSetter
		Output As String
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Pretty As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		ShowWhitespace As Boolean = False
	#tag EndProperty


	#tag Constant, Name = SPACES_PER_INDENT, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant


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
		#tag ViewProperty
			Name="Pretty"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShowWhitespace"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ListReferences"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
