#tag Class
Protected Class MKBlock
	#tag Method, Flags = &h0
		Function Accept(visitor As MKRenderer) As Variant
		  /// Accepts an AST renderer and redirects to the correct method.
		  
		  Select Case Self.Type
		  Case MKBlockTypes.AtxHeading
		    Return visitor.VisitATXHeading(MKATXHeadingBlock(Self))
		    
		  Case MKBlockTypes.Block
		    Return visitor.VisitBlock(Self)
		    
		  Case MKBlockTypes.BlockQuote
		    Return visitor.VisitBlockQuote(MKBlockQuote(Self))
		    
		  Case MKBlockTypes.CodeSpan
		    Return visitor.VisitCodeSpan(MKCodeSpan(Self))
		    
		  Case MKBlockTypes.Document
		    Return visitor.VisitDocument(MKDocument(Self))
		    
		  Case MKBlockTypes.Emphasis
		    Return visitor.VisitEmphasis(MKEmphasis(Self))
		    
		  Case MKBlockTypes.FencedCode
		    Return visitor.VisitFencedCode(MKFencedCodeBlock(Self))
		    
		  Case MKBlockTypes.Html
		    Return visitor.VisitHTMLBlock(MKHTMLBlock(Self))
		    
		  Case MKBlockTypes.IndentedCode
		    Return visitor.VisitIndentedCode(MKIndentedCodeBlock(Self))
		    
		  Case MKBlockTypes.InlineHTML
		    Return visitor.VisitInlineHTML(MKInlineHTML(Self))
		    
		  Case MKBlockTypes.InlineImage
		    Return visitor.VisitInlineImage(MKInlineImage(Self))
		    
		  Case MKBlockTypes.InlineLink
		    Return visitor.VisitInlineLink(MKInlineLink(Self))
		    
		  Case MKBlockTypes.InlineText
		    Return visitor.VisitInlineText(MKInlineText(Self))
		    
		  Case MKBlockTypes.List
		    Return visitor.VisitList(MKListBlock(Self))
		    
		  Case MKBlockTypes.ListItem
		    Return visitor.VisitListItem(MKListItemBlock(Self))
		    
		  Case MKBlockTypes.Paragraph
		    Return visitor.VisitParagraph(MKParagraphBlock(Self))
		    
		  Case MKBlockTypes.SetextHeading
		    Return visitor.VisitSetextHeading(MKSetextHeadingBlock(Self))
		    
		  Case MKBlockTypes.SoftBreak
		    Return visitor.VisitSoftBreak(MKSoftBreak(Self))
		    
		  Case MKBlockTypes.StrongEmphasis
		    Return visitor.VisitStrongEmphasis(MKStrongEmphasis(Self))
		    
		  Case MKBlockTypes.TextBlock
		    Return visitor.VisitTextBlock(MKTextBlock(Self))
		    
		  Case MKBlockTypes.ThematicBreak
		    Return visitor.VisitThematicBreak(MKThematicBreak(Self))
		    
		  Else
		    Raise New MKException("Unknown block type.")
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320746578742066726F6D205B6C696E655D20626567696E6E696E67206174205B7374617274506F735D20746F2074686520656E64206F6620746865206C696E652E
		Sub AddLine(line As TextLine, startPos As Integer, phantomSpaces As Integer)
		  /// Adds text from [line] beginning at [startPos] to the end of the line.
		  
		  // Prohibit adding new lines to closed blocks.
		  If Not Self.IsOpen Then
		    Raise New MKException("Attempted to add line " + _
		    line.Number.ToString + " to closed container " + Self.Type.ToString + ".")
		  End If
		  
		  // Get the characters from the current line offset to the end of the line.
		  Var s As String = line.Value.MiddleCharacters(startPos)
		  
		  // We add the individual characters to inline containers and text blocks to other block types.
		  If IsInlineContainer Then
		    // Don't add empty lines to paragraphs.
		    If s = "" Then Return
		    
		    // Append the characters in the line, skipping leading whitespace.
		    Var tmp() As MKCharacter = s.MKCharacters(line, startPos)
		    Var seenNWS As Boolean = False
		    For Each character As MKCharacter In tmp
		      If Not character.IsMarkdownWhitespace Then
		        seenNWS = True
		        Characters.Add(character)
		      Else
		        If seenNWS Then Characters.Add(character)
		      End If
		    Next character
		    
		    // Add a line ending.
		    Characters.Add(MKCharacter.CreateLineEnding(line))
		  Else
		    // Add the text as a text block.
		    Var b As New MKTextBlock(Self, line.Start + startPos, startPos, s, phantomSpaces, line)
		    Children.Add(b)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5374617274696E67206174205B706F735D2C20616476616E636573207468726F756768205B436861726163746572735D20746F20746865207374617274206F6620746865206E657874206C696E652E204966207468697320697320746865206C617374206C696E65207468656E205B706F735D2069732073657420746F2060436861726163746572732E4C617374496E646578202B2031602E
		Private Sub AdvanceToNextLineStart(ByRef pos As Integer)
		  /// Starting at [pos], advances through [Characters] to the start of the next line. If this is the last line 
		  /// then [pos] is set to `Characters.LastIndex + 1`.
		  
		  Var charsLastIndex As Integer = Characters.LastIndex
		  For i As Integer = pos To charsLastIndex
		    If Characters(i).IsLineEnding Then
		      pos = i + 1
		      Return
		    Else
		      pos = i
		    End If
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(type As MKBlockTypes, parent As MKBlock, blockStart As Integer = 0)
		  Self.Type = type
		  Self.Parent = parent
		  
		  If type = MKBlockTypes.Document Then
		    mDocument = New WeakRef(Self)
		  Else
		    If parent <> Nil And parent.Document <> Nil Then mDocument = New WeakRef(parent.Document)
		  End If
		  
		  Self.Start = blockStart
		  
		  If type = MKBlockTypes.TextBlock Then
		    Self.IsOpen = False
		  Else
		    Self.IsOpen = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732054727565206966207468697320626C6F636B20656E64732077697468206120626C616E6B206C696E652C2064657363656E64696E67206966206E656564656420696E746F206C6973747320616E64207375626C697374732E
		Function EndsWithBlankLine() As Boolean
		  /// Returns True if this block ends with a blank line, descending if needed into lists and sublists.
		  
		  Var b As MKBlock = Self
		  
		  Do
		    If b.IsLastLineBlank Then Return True
		    
		    If b.Type <> MKBlockTypes.List And b.Type <> MKBlockTypes.ListItem Then Return False
		    
		    b = b.LastChild
		    
		    If b = Nil Then Return False
		  Loop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6F736573207468697320626C6F636B20616E64206D616B657320616E792066696E616C206368616E6765732074686174206D61792062652072657175697265642E
		Sub Finalise(line As TextLine = Nil)
		  /// Closes this block and makes any final changes that may be required. 
		  ///
		  /// Subclasses can override this method if they have more complicated needs upon block closure.
		  /// [line] is the line that triggered the `Finalise` invocation.
		  
		  #Pragma Unused line
		  
		  // Already closed?
		  If Not IsOpen Then Return
		  
		  // Mark that we're closed.
		  IsOpen = False
		  
		  Select Case Type
		  Case MKBlockTypes.BlockQuote
		    // ============
		    // BLOCK QUOTES
		    // ============
		    // If all children of this block quote are blank paragraphs then remove them.
		    Var removeAllChildren As Boolean = True
		    For Each child As MKBlock In Self.Children
		      If child.Type <> MKBlockTypes.Paragraph Or child.Characters.Count <> 0 Then
		        removeAllChildren = False
		        Exit
		      End If
		    Next child
		    If removeAllChildren Then Self.Children.RemoveAll
		    
		  Case MKBlockTypes.ListItem
		    // ============
		    // LIST ITEM
		    // ============
		    For i As Integer = 0 To Self.Children.LastIndex
		      Self.Children(i).IsChildOfListItem = True
		    Next i
		  End Select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54727565206966207468697320626C6F636B2063616E20636F6E7461696E20696E6C696E6520626C6F636B732E
		Function IsInlineContainer() As Boolean
		  /// True if this block can contain inline blocks.
		  
		  Return Type = MKBlockTypes.Paragraph Or Type = MKBlockTypes.AtxHeading Or Type = MKBlockTypes.SetextHeading
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D617463686573207768697465737061636520696E205B63686172735D20626567696E6E696E67206174205B706F735D20616E642072657475726E7320686F77206D616E7920636861726163746572732077657265206D6174636865642E
		Private Function MatchWhitespaceCharactersInArray(chars() As MKCharacter, pos As Integer) As Integer
		  /// Matches whitespace in [chars] beginning at [pos] and returns how many characters were matched.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Sanity check.
		  If pos > charsLastIndex Then Return 0
		  
		  For i As Integer = pos To charsLastIndex
		    If Not chars(i).IsMarkdownWhitespace Then Return i - pos
		  Next i
		  
		  Return (charsLastIndex + 1)- pos
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468697320626C6F636B2773206E657874207369626C696E67206F72204E696C2069662074686572652069736E2774206F6E652E
		Function NextSibling() As MKBlock
		  /// Returns this block's next sibling or Nil if there isn't one.
		  
		  If Self.Parent = Nil Then Return Nil
		  
		  Var myIndex As Integer = Self.Parent.Children.IndexOf(Self)
		  If myIndex = -1 Then Return Nil
		  If myIndex = Self.Parent.Children.LastIndex Then
		    Return Nil
		  Else
		    Return Self.Parent.Children(myIndex + 1)
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 50617273657320616E79206C696E6B207265666572656E636520646566696E6974696F6E7320696E2074686973207061726167726170682C2065786369736573207468656D2C2061646473207468656D20746F2074686520646F63756D656E7420616E642072652D617373656D626C65732074686973207061726167726170682773207465787420626C6F636B732E
		Protected Sub ParseLinkReferenceDefinitions()
		  /// Parses any link reference definitions in this block, excises them, adds them to the document 
		  /// and adjust's this block's characters.
		  ///
		  /// Assumes that this method is called during block parsing.
		  /// Assumes this is only ever called by paragraph and STX blocks.
		  /// At this point in the paragraph's life cycle, it consists of contiguous characters. That is:
		  ///   Characters(n + 1).Position = Characters(n).Position + 1`.
		  ///
		  /// A link reference definition consists of a "link label", preceded by up to 3 spaces of indentation, 
		  /// followed by a colon (`:`), optional spaces or tabs (including up to one line ending), 
		  /// a "link destination", optional spaces or tabs (including up to one line ending)
		  /// and an optional "link title" which, if present, must be separated from the "link destination" by 
		  /// spaces or tabs. No further character may occur.
		  ///
		  /// A "link label" begins with a left bracket (`[`) and ends with the first right bracket (`]`) that is not 
		  /// backslash-escaped. 
		  /// Between these brackets there must be at least one character that is not a space, tab, or line ending. 
		  /// Unescaped square bracket characters are not allowed inside the opening and closing square brackets of 
		  /// link labels. A link label can have at most 999 characters inside the square brackets.
		  ///
		  /// A "link destination" consists of either:
		  /// 1. >= 0 characters between an opening `<` and a closing `>` that contains no line endings or 
		  ///    unescaped `<` or `>` characters, or
		  /// 2. > 0 characters that does not start with `<`, does not include ASCII control characters or space 
		  /// character, and includes parentheses only if:
		  ///    (a) they are backslash-escaped
		  ///    (b) they are part of a balanced pair of unescaped parentheses. At least 3 levels must be supported.
		  ///
		  /// A "link title" consists of either:
		  /// 1. >= 0 characters between `"` characters, including a `"` character only if it is backslash-escaped.
		  /// 2. >= 0 characters between `'` characters, including a `'` character only if it is backslash-escaped
		  /// 3. >= 0 characters between matching parentheses, including a `(` or `)` only if it's backslash-escaped.
		  
		  Var data As Dictionary
		  Var linkLabel, linkTitle As String
		  Var labelStart, titleStart, labelLength, titleLength, linkLocalStart As Integer
		  Var destinationData As MarkdownKit.MKLinkDestination
		  Var destinationCharactersStart As Integer
		  
		  If Characters.Count = 0 Then Return
		  
		  Var i As Integer = 0
		  While i <= Characters.LastIndex
		    linkLocalStart = i
		    linkLabel = ""
		    labelStart = linkLocalStart
		    labelLength = 0
		    destinationData = New MKLinkDestination
		    destinationCharactersStart = 0
		    linkTitle = ""
		    titleStart = 0
		    titleLength = 0
		    data = Nil
		    
		    // Up to 3 spaces of indentation are permitted.
		    i = i + MatchWhitespaceCharactersInArray(Characters, i)
		    If i > labelStart + 3 Then Return
		    
		    // Can we match a link label?
		    If Not MKLinkScanner.ParseLinkLabel(Characters, i, data) Then
		      Return
		    Else
		      linkLabel = data.Value("linkLabel")
		      labelStart = data.Value("linkLabelStart") + linkLocalStart
		      labelLength = data.Value("linkLabelLength")
		    End If
		    
		    // The next character must be a colon.
		    If i > Characters.LastIndex Then Return
		    i = i + 1
		    If Characters(i).Value <> ":" Then
		      Return
		    Else
		      i = i + 1
		    End If
		    If i > Characters.LastIndex Then Return
		    
		    // Skip whitespace after the colon.
		    i = i + MatchWhitespaceCharactersInArray(Characters, i)
		    
		    // Match up to one line ending.
		    If i < Characters.LastIndex And Characters(i).IsLineEnding Then i = i + 1
		    
		    // Can we match a link destination?
		    destinationCharactersStart = i
		    If Not MKLinkScanner.ParseLinkDestination(Characters, i, data) Then
		      Return
		    Else
		      destinationData.StartCharacter = Characters(destinationCharactersStart)
		      destinationData.Value = data.Value("linkDestination")
		      destinationData.Length = data.Value("linkDestinationLength")
		    End If
		    
		    // Consume tabs and spaces.
		    Var indexBeforeWhitespaceCheck As Integer = i
		    i = i + MatchWhitespaceCharactersInArray(Characters, i)
		    
		    // Match up to one line ending.
		    Var destinationEndsLine As Boolean = False
		    If i < Characters.LastIndex And Characters(i).IsLineEnding Then
		      destinationEndsLine = True
		      i = i + 1
		    ElseIf i = Characters.LastIndex Then
		      destinationEndsLine = True
		    End If
		    Var whitespaceAfterDestination As Boolean = i > indexBeforeWhitespaceCheck
		    
		    // Can we match a link title?
		    If whitespaceAfterDestination Then
		      If MKLinkScanner.ParseLinkTitle(Characters, i, data) Then
		        If Not data.Value("linkTitleValid") And Not destinationEndsLine Then
		          // The title is invalid but the reference is OK up until this point. We therefore have a 
		          // valid reference link and the title is just text following it.
		          Return
		          
		        ElseIf data.Value("linkTitleValid") Then
		          linkTitle = data.Value("linkTitle")
		          titleStart = data.Value("linkTitleStart") + linkLocalStart
		          titleLength = data.Value("linkTitleLength")
		        End If
		      End If
		      
		    Else
		      If Not destinationEndsLine Then Return
		    End If
		    Var hasTitle As Boolean = titleLength > 0
		    
		    // We've found a definition. Add it to the document only if it's unique.
		    If Not Self.Document.References.HasKey(linkLabel.Lowercase) Then
		      Self.Document.References.Value(linkLabel.Lowercase) = _
		      New MKLinkReferenceDefinition(start, linkLabel.Lowercase, labelStart, labelLength, _
		      destinationData, linkTitle, titleStart, titleLength, i)
		    End If
		    
		    If titleLength > 0 Then
		      // Skip past any whitespace to the end of the line.
		      i = i + MatchWhitespaceCharactersInArray(Characters, i)
		    End If
		    
		    // Remove these characters from the paragraph.
		    For x As Integer = If(hasTitle, i, i - 1) DownTo linkLocalStart
		      ' For x As Integer = i DownTo linkLocalStart
		      Characters.RemoveAt(x)
		    Next x
		    
		    i = linkLocalStart
		    
		    If Characters(i).IsLineEnding Then
		      Characters.RemoveAt(i)
		      If i > Characters.LastIndex Then Return
		    End If
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468697320626C6F636B27732070726576696F7573207369626C696E67206F72204E696C2069662074686572652069736E2774206F6E652E
		Function PreviousSibling() As MKBlock
		  /// Returns this block's next sibling or Nil if there isn't one.
		  
		  If Self.Parent = Nil Then Return Nil
		  
		  Var myIndex As Integer = Self.Parent.Children.IndexOf(Self)
		  If myIndex = -1 Then Return Nil
		  If myIndex = Self.Parent.Children.FirstIndex Then
		    Return Nil
		  Else
		    Return Self.Parent.Children(myIndex - 1)
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4966205B6368696C645D206973206120746F702D6C6576656C206368696C64206F66207468697320626C6F636B2069742069732072656D6F7665642E
		Sub RemoveChild(child As MKBlock)
		  /// If [child] is a top-level child of this block it is removed.
		  
		  For i As Integer = Children.LastIndex DownTo 0
		    If Children(i) = child Then
		      Children.RemoveAt(i)
		      Return
		    End If
		  Next i
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 5468652063686172616374657273206F66207468697320626C6F636B2E204F6E6C792076616C696420666F7220696E6C696E6520636F6E7461696E65727320286F7468657220626C6F636B20747970657320757365204D4B54657874426C6F636B73292E
		Characters() As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320626C6F636B2773206368696C6472656E2E
		Children() As MarkdownKit.MKBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520646F63756D656E742074686174206F776E73207468697320626C6F636B2E
		#tag Getter
			Get
			  If mDocument = Nil Then
			    Return Nil
			  Else
			    Return MKDocument(mDocument.Value)
			  End If
			  
			End Get
		#tag EndGetter
		Document As MarkdownKit.MKDocument
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 302D626173656420706F736974696F6E20696E20746865206F726967696E616C20736F75726365206F662074686520656E64206F66207468697320626C6F636B2E204F6E6C792076616C696420666F7220696E6C696E6520626C6F636B7320616E6420696E6C696E6520636F6E7461696E657220626C6F636B732E
		EndPosition As Integer = -1
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206669727374206368696C64206F66207468697320626C6F636B206F72204E696C20696620746865726520617265206E6F206368696C6472656E2E
		#tag Getter
			Get
			  If Children.LastIndex > -1 Then
			    Return Children(0)
			  Else
			    Return Nil
			  End If
			  
			End Get
		#tag EndGetter
		FirstChild As MarkdownKit.MKBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320626C6F636B2069732061206368696C64206F662061206C697374206974656D2E
		IsChildOfListItem As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320626C6F636B2069732061206368696C64206F662061207469676874206C6973742E
		IsChildOfTightList As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 54727565206966207468697320626C6F636B20697320746865206669727374206368696C64206F662069747320706172656E742E
		#tag Getter
			Get
			  If Parent = Nil Then Return True
			  Return Parent.FirstChild = Self
			End Get
		#tag EndGetter
		IsFirstChild As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 54727565206966207468697320626C6F636B20697320746865206C617374206368696C64206F662069747320706172656E742E
		#tag Getter
			Get
			  If Parent = Nil Then Return True
			  Return Parent.LastChild = Self
			End Get
		#tag EndGetter
		IsLastChild As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5472756520696620746865206C617374206C696E65206F66207468697320636F6E7461696E657220697320626C616E6B2E
		IsLastLineBlank As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320626C6F636B206973206F70656E2E
		IsOpen As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206C617374206368696C64206F66207468697320626C6F636B206F72204E696C206966207468697320626C6F636B20686173206E6F206368696C6472656E2E
		#tag Getter
			Get
			  If Children.Count = 0 Then
			    Return Nil
			  Else
			    Return Children(Children.LastIndex)
			  End If
			  
			End Get
		#tag EndGetter
		LastChild As MarkdownKit.MKBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686520312D6261736564206C696E65206E756D62657220696E20746865204D61726B646F776E20646F776E2074686174207468697320626C6F636B206F6363757273206F6E2E
		LineNumber As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41207765616B207265666572656E636520746F2074686520646F63756D656E742074686174206F776E73207468697320626C6F636B2E
		Private mDocument As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41207765616B207265666572656E636520746F207468697320626C6F636B277320706172656E742E2057696C6C206265204E696C2069662074686973206973206120646F63756D656E7420626C6F636B2E
		Private mParent As WeakRef
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 5468697320626C6F636B277320706172656E74206F72204E696C20696620697420756E6F776E6564206F72206973206120646F63756D656E7420626C6F636B2E
		#tag Getter
			Get
			  If mParent <> Nil Then
			    Return MKBlock(mParent.Value)
			  Else
			    Return Nil
			  End If
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = Nil Then
			    mParent = Nil
			  Else
			    mParent = New WeakRef(value)
			  End If
			  
			End Set
		#tag EndSetter
		Parent As MarkdownKit.MKBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686520302D626173656420706F736974696F6E20696E20746865206F726967696E616C204D61726B646F776E20736F757263652074686174207468697320626C6F636B20626567696E732061742E
		Start As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652074797065206F6620626C6F636B2E
		Type As MarkdownKit.MKBlockTypes = MKBlockTypes.Block
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
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue="MKBlockTypes.Block"
			Type="MKBlockTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - AtxHeading"
				"1 - Block"
				"2 - BlockQuote"
				"3 - CodeSpan"
				"4 - Document"
				"5 - Emphasis"
				"6 - FencedCode"
				"7 - Html"
				"8 - IndentedCode"
				"9 - InlineHTML"
				"10 - InlineImage"
				"11 - InlineLink"
				"12 - InlineText"
				"13 - List"
				"14 - ListItem"
				"15 - Paragraph"
				"16 - ReferenceDefinition"
				"17 - SetextHeading"
				"18 - SoftBreak"
				"19 - StrongEmphasis"
				"20 - TextBlock"
				"21 - ThematicBreak"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsOpen"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsLastLineBlank"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsChildOfTightList"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsChildOfListItem"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EndPosition"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsFirstChild"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsLastChild"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
