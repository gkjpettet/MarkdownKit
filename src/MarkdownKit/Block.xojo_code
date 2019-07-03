#tag Class
Protected Class Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IRenderer)
		  Select Case Type
		  Case MarkdownKit.BlockType.AtxHeading
		    visitor.VisitAtxHeading(Self)
		  Case MarkdownKit.BlockType.Block
		    visitor.VisitBlock(Self)
		  Case MarkdownKit.BlockType.BlockQuote
		    visitor.VisitBlockQuote(Self)
		  Case MarkdownKit.BlockType.Document
		    visitor.VisitDocument(Self)
		  Case MarkdownKit.BlockType.FencedCode
		    visitor.VisitFencedCode(Self)
		  Case MarkdownKit.BlockType.Hardbreak
		    visitor.VisitHardbreak(Self)
		  Case MarkdownKit.BlockType.HtmlBlock
		    visitor.VisitHtmlBlock(Self)
		  Case MarkdownKit.BlockType.IndentedCode
		    visitor.VisitIndentedCode(Self)
		  Case MarkdownKit.BlockType.Codespan
		    visitor.VisitCodespan(Self)
		  Case MarkdownKit.BlockType.Emphasis
		    visitor.VisitEmphasis(Self)
		  Case MarkdownKit.BlockType.InlineHTML
		    visitor.VisitInlineHTML(Self)
		  Case MarkdownKit.BlockType.InlineImage
		    visitor.VisitInlineImage(Self)
		  Case MarkdownKit.BlockType.InlineLink
		    visitor.VisitInlineLink(Self)
		  Case MarkdownKit.BlockType.Softbreak
		    visitor.VisitSoftbreak(Self)
		  Case MarkdownKit.BlockType.Strong
		    visitor.VisitStrong(Self)
		  Case MarkdownKit.BlockType.InlineText
		    visitor.VisitInlineText(Self)
		  Case MarkdownKit.BlockType.List
		    visitor.VisitList(Self)
		  Case MarkdownKit.BlockType.ListItem
		    visitor.VisitListItem(Self)
		  Case MarkdownKit.BlockType.Paragraph
		    visitor.VisitParagraph(Self)
		  Case MarkdownKit.BlockType.SetextHeading
		    visitor.VisitSetextHeading(Self)
		  Case MarkdownKit.BlockType.ThematicBreak
		    visitor.VisitThematicBreak(Self)
		  Else
		    Raise New MarkdownKit.MarkdownException("Unknown block type")
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddLine(line As MarkdownKit.LineInfo, startPos As Integer, length As Integer = -1)
		  // Add the passed line to this Block.
		  
		  // Prohibit adding new lines to closed blocks.
		  If Not Self.IsOpen Then
		    Raise New MarkdownKit.MarkdownException("Attempted to add line " + _
		    line.Number.ToText + " to closed container " + Self.Type.ToText)
		  End If
		  
		  // Get the length of the text.
		  Dim len As Integer = If(length = -1, line.CharsUbound - line.Offset + 1, length)
		  
		  Select Case Type
		  Case MarkdownKit.BlockType.HtmlBlock
		    // ===== HTML block =====
		    // Get the characters from the current line offset to the end of the line.
		    Dim tmp() As Text
		    Dim limit As Integer = Xojo.Math.Min(line.Chars.Ubound, startPos + len - 1)
		    For i As Integer = startPos To limit
		      tmp.Append(line.Chars(i))
		    Next i
		    
		    // Add a newline to the end of this line.
		    tmp.Append(&u000A)
		    
		    // Append the characters of this line to this block's RawChars array.
		    Chars.AppendArray(tmp)
		    
		  Case MarkdownKit.BlockType.Paragraph
		    // ===== Paragraph block =====
		    // Unexpected blank line?
		    If len <= 0 Then Raise New MarkdownKit.MarkdownException("Unexpected blank line")
		    
		    // Get the characters from the current line offset to the end of the line.
		    Dim limit As Integer = Xojo.Math.Min(line.Chars.Ubound, startPos + len - 1)
		    Dim tmp() As Text
		    For i As Integer = startPos To limit
		      tmp.Append(line.Chars(i))
		    Next i
		    
		    // Strip leading and trailing whitespace from this line.
		    StripLeadingWhitespace(tmp)
		    
		    // Add a newline to the end of this line.
		    tmp.Append(&u000A)
		    
		    // Append the characters of this line to this paragraph's RawChars array.
		    Chars.AppendArray(tmp)
		    
		  Else
		    // ===== All other block types ====
		    Dim tmp() As Text
		    If len <= 0 Then
		      // Blank line.
		      Dim b As New MarkdownKit.Block(BlockType.TextBlock, Xojo.Core.WeakRef.Create(Self))
		      b.Chars = tmp
		      Children.Append(b)
		      Return
		    End If
		    
		    // Get the characters from the current line offset to the end of the line.
		    // Remember to account for missing spaces.
		    For i As Integer = 1 To line.RemainingSpaces
		      tmp.Append(" ")
		    Next i
		    Dim limit As Integer = Xojo.Math.Min(line.Chars.Ubound, startPos + len - 1)
		    For i As Integer = startPos To limit
		      tmp.Append(line.Chars(i))
		    Next i
		    
		    // Add the text as a text block.
		    Dim b As New MarkdownKit.Block(BlockType.TextBlock, Xojo.Core.WeakRef.Create(Self))
		    b.Chars = tmp
		    Children.Append(b)
		  End Select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  Select Case Type
		    // === Code span ===
		  Case MarkdownKit.BlockType.Codespan
		    Dim seenNonSpace As Boolean = False
		    For i As Integer = Self.StartPos To Self.EndPos
		      Select Case Parent.Chars(i)
		      Case &u000A
		        // Newlines are normalised to spaces.
		        chars.Append(&u0020)
		      Case &u0020
		        chars.Append(&u0020)
		      Else
		        seenNonSpace = True
		        chars.Append(Parent.Chars(i))
		      End Select
		    Next i
		    
		    // If the resulting content both begins and ends with a space character, but does not 
		    // consist entirely of space characters, a single space character is removed from the 
		    // front and back.
		    If seenNonSpace And Chars.Ubound >= 1 And Chars(0) = &u0020 And Chars(Chars.Ubound) = &u0020 Then
		      Chars.Remove(0)
		      Call Chars.Pop
		    End If
		    
		  Case MarkdownKit.BlockType.InlineLink
		    Self.IsOpen = False
		    
		  Case MarkdownKit.BlockType.InlineHTML
		    For i As Integer = Self.StartPos To Self.EndPos
		      chars.Append(Parent.Chars(i))
		    Next i
		    
		  Case MarkdownKit.BlockType.InlineText
		    For x As Integer = Self.StartPos To Self.EndPos
		      Self.Chars.Append(Self.Parent.Chars(x))
		    Next x
		    
		    Self.IsOpen = False
		    
		    // Replace entity and numeric character references
		    Utilities.ReplaceEntities(Self.Chars)
		    
		    // Unescape backslash-escaped characters.
		    Utilities.Unescape(Self.Chars)
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(type As MarkdownKit.BlockType, parent As Xojo.Core.WeakRef)
		  Self.Type = type
		  Self.ListData = New MarkdownKit.ListData
		  Self.mParent = parent
		  Self.Root = If(Self.Parent = Nil, Nil, Self.Parent.Root)
		  
		  Select Case Type
		  Case MarkdownKit.BlockType.InlineHTML
		    
		  Case MarkdownKit.BlockType.TextBlock
		    Self.IsOpen = False
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function EndsWithBlankLine(b As MarkdownKit.Block) As Boolean
		  // Check to see if the passed block ends with a blank line, 
		  // descending if needed into lists and sublists.
		  
		  Do
		    If b.IsLastLineBlank Then Return True
		    
		    If b.Type <> BlockType.List And b.Type <> BlockType.ListItem Then Return False
		    
		    b = b.LastChild
		    
		    If b = Nil Then Return False
		  Loop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As MarkdownKit.LineInfo)
		  // This generic base method simply closes this block.
		  // Subclasses can override this method if they have more complicated needs 
		  // upon block closure.
		  // `line` is the line that triggered the Finalise call.
		  
		  #If Not TargetWeb
		    #Pragma DisableBackgroundTasks
		  #Endif
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  
		  If Not IsOpen Then
		    Return
		  Else
		    IsOpen = False
		  End If
		  
		  Select Case Type
		  Case MarkdownKit.BlockType.AtxHeading
		    // ===== ATX heading =====
		    Dim p As Integer = line.CharsUbound
		    
		    // Trim trailing spaces.
		    While p >= 0 And (line.Chars(p) = " " Or line.Chars(p) = &u0009)
		      p = p - 1
		    Wend
		    
		    Dim px As Integer = p
		    
		    // If the line ends in #s, remove them.
		    while p >= 0 And line.Chars(p) = "#"
		      p = p - 1
		    Wend
		    
		    // There must be a space before the last #.
		    If p < 0 Or (line.Chars(p) <> " " And line.Chars(p) <> &u0009) Then p = px
		    
		    // Trim trailing spaces that are before the closing #s.
		    While p >= line.NextNWS And (line.Chars(p) = " " Or line.Chars(p) = &u0009)
		      p = p - 1
		    Wend
		    
		    // Add contents of the line.
		    If p - line.NextNWS > -1 Then
		      Dim len As Integer = If(p - line.NextNWS + 1 = -1, line.CharsUbound - line.Offset + 1, p - line.NextNWS + 1)
		      If len <= 0 Then Return // Empty heading.
		      
		      // Get the characters from the current line offset to the end of the line.
		      // Remember to account for missing spaces.
		      Dim i As Integer
		      For i = 1 To line.RemainingSpaces
		        Chars.Append(" ")
		      Next i
		      Dim limit As Integer = Xojo.Math.Min(line.Chars.Ubound, line.NextNWS + len - 1)
		      For i = line.NextNWS To limit
		        Chars.Append(line.Chars(i))
		      Next i
		    End If
		    
		  Case MarkdownKit.BlockType.FencedCode
		    // ===== Fenced code =====
		    If FirstChild <> Nil Then
		      // The first child (if present) is the info string. It may be empty.
		      Dim tb As MarkdownKit.Block = FirstChild
		      If Not tb.Chars.IsBlank Then
		        InfoString = Text.Join(tb.Chars, "").Trim
		        InfoString = Utilities.ReplaceEntities(InfoString)
		        Utilities.Unescape(InfoString)
		      End If
		      Children.Remove(0)
		    End If
		    
		  Case MarkdownKit.BlockType.HtmlBlock
		    // ===== HTML block =====
		    If Chars.Ubound < 0 Then Return
		    If Chars(Chars.Ubound) = &u000A Then Call Chars.Pop
		    
		  Case MarkdownKit.BlockType.IndentedCode
		    // ===== Indented code =====
		    // Blank lines preceding or following an indented code block are not included in it.
		    Dim limit As Integer = Children.Ubound
		    Dim b As MarkdownKit.Block
		    // Leading blank lines...
		    For i As Integer = 0 to limit
		      b = Children(i)
		      If b.Chars.IsBlank Then
		        Children.Remove(0)
		      Else
		        Exit
		      End If
		    Next i
		    // Trailing blank lines...
		    If Children.Ubound > -1 Then
		      For i As Integer = Children.Ubound DownTo 0
		        b = Children(i)
		        If b.Chars.IsBlank Then
		          Children.Remove(i)
		        Else
		          Exit
		        End If
		      Next i
		    End If
		    
		  Case MarkdownKit.BlockType.List
		    // ===== List =====
		    // Determine tight/loose status of the list.
		    Self.ListData.IsTight = True // Tight by default.
		    
		    Dim item As MarkdownKit.Block = Self.FirstChild
		    Dim subItem As MarkdownKit.Block
		    
		    While item <> Nil
		      
		      // Check for a non-final non-empty ListItem ending with blank line.
		      If item.IsLastLineBlank And item.NextSibling <> Nil Then
		        Self.ListData.IsTight = False
		        Exit
		      End If
		      
		      // Recurse into the children of the ListItem, to see if there are spaces between them.
		      subitem = item.FirstChild
		      
		      While subItem <> Nil
		        If EndsWithBlankLine(subItem) And (item.NextSibling <> Nil Or subitem.NextSibling <> Nil) Then
		          Self.ListData.IsTight = False
		          Exit
		        End If
		        subItem = subitem.NextSibling
		      Wend
		      
		      If Not Self.ListData.IsTight Then Exit
		      
		      item = item.NextSibling
		    Wend
		    
		    Dim i As Integer
		    Dim childrenUbound As Integer = Self.Children.Ubound
		    For i = 0 To childrenUbound
		      Self.Children(i).IsChildOfTightList = Self.ListData.IsTight
		    Next i
		    
		  Case MarkdownKit.BlockType.ListItem
		    // ===== List items =====
		    Dim i As Integer
		    Dim childrenUbound As Integer = Self.Children.Ubound
		    For i = 0 To childrenUbound
		      Self.Children(i).IsChildOfListItem = True
		    Next i
		    
		  Case MarkdownKit.BlockType.Paragraph
		    // ===== Paragraph blocks =====
		    If Chars.Ubound < 0 Then Return
		    
		    StripTrailingWhitespace(Chars)
		    
		    Dim origCount As Integer
		    While Chars.Ubound >= 3 And Chars(0) = "["
		      // Cache the size of the chars array now as it will change if a reference is found.
		      origCount = Chars.Ubound
		      BlockScanner.ScanLinkReferenceDefinition(Chars, MarkdownKit.Document(Self.Root))
		      If origCount = Chars.Ubound Then Exit // No more reference links found.
		    Wend
		    
		    // Do we need to remove this paragraph entirely? This occurs when its only content 
		    // was a reference link.
		    If Chars.Ubound = -1 Then Self.Parent.RemoveChild(Self)
		    
		  Case MarkdownKit.BlockType.SetextHeading
		    // ===== Setext heading =====
		    If Chars.Ubound < 0 Then Return
		    
		    StripTrailingWhitespace(Chars)
		    
		    Dim origCount As Integer
		    While Chars.Ubound >= 3 And Chars(0) = "["
		      // Cache the size of the chars array now as it will change if a reference is found.
		      origCount = Chars.Ubound
		      BlockScanner.ScanLinkReferenceDefinition(Chars, MarkdownKit.Document(Self.Root))
		      If origCount = Chars.Ubound Then Exit // No more reference links found.
		    Wend
		    
		  End Select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206669727374206368696C64206F66207468697320426C6F636B206F72204E696C2069662074686520426C6F636B20686173206E6F206368696C6472656E2E
		Function FirstChild() As MarkdownKit.Block
		  // Return the first child of this Block. Nil otherwise.
		  
		  If Children.Ubound > -1 Then
		    Return Children(0)
		  Else
		    Return Nil
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206C617374206368696C64206F66207468697320426C6F636B206F72204E696C206966207468697320426C6F636B20686173206E6F206368696C6472656E2E
		Function LastChild() As MarkdownKit.Block
		  // Return the last child of htis Block. Nil otherwise.
		  
		  If Children.Ubound >- 1 Then
		    Return Children(Children.Ubound)
		  Else
		    Return Nil
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NextSibling() As MarkdownKit.Block
		  If Self.Parent = Nil Then Return Nil
		  
		  Dim myIndex As Integer = Self.Parent.Children.IndexOf(Self)
		  If myIndex = -1 Then Return Nil
		  If myIndex = Self.Parent.Children.Ubound Then
		    Return Nil
		  Else
		    Return Self.Parent.Children(myIndex + 1)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveChild(child As MarkdownKit.Block)
		  // Removes the passed child block from this block.
		  // Only looks at the top level children of this block.
		  
		  Dim childIndex As Integer = Children.IndexOf(child)
		  If childIndex <> -1 Then Children.Remove(childIndex)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Chars() As Text
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320426C6F636B2773206368696C6420426C6F636B732028696620616E79292E
		Children() As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		Delimiter As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		DelimiterLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Destination As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		EndPos As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		FenceChar As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		FenceLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FenceOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		HTMLBlockType As Integer = kHTMLBlockTypeNone
	#tag EndProperty

	#tag Property, Flags = &h0
		InfoString As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		IsAutoLink As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		IsChildOfListItem As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		IsChildOfTightList As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E20746865206C617374206C696E65206F66207468697320636F6E7461696E657220697320626C616E6B2E
		IsLastLineBlank As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		IsOpen As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Label As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Level As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		ListData As MarkdownKit.ListData
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468697320426C6F636B277320706172656E742028692E653A20656E636C6F73696E672920426C6F636B2E2057696C6C206265204E696C206966207468697320426C6F636B2069732074686520726F6F7420446F63756D656E742E
		Private mParent As Xojo.Core.WeakRef
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As Text
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mParent = Nil Then
			    Return Nil
			  Else
			    Return MarkdownKit.Block(mParent.Value)
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mParent = If(value = Nil, Nil, Xojo.Core.WeakRef.Create(value))
			End Set
		#tag EndSetter
		Parent As MarkdownKit.Block
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5468652070726576696F7573207369626C696E67206F66207468697320626C6F636B20656C656D656E742E204E696C20696620746869732069732074686520666972737420656C656D656E742E
		Previous As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 4B6579203D205265666572656E6365206C696E6B206E616D652C2056616C7565203D204D61726B646F776E4B69742E5265666572656E63654C696E6B446566696E6974696F6E
		ReferenceMap As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		Root As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		StartPos As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		Title As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As MarkdownKit.BlockType
	#tag EndProperty


	#tag Constant, Name = kHTMLBlockTypeCData, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeComment, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeDocumentType, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeInterruptingBlock, Type = Double, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeInterruptingBlockWithEmptyLines, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeNonInterruptingBlock, Type = Double, Dynamic = False, Default = \"7", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeProcessingInstruction, Type = Double, Dynamic = False, Default = \"3", Scope = Public
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
			Name="IsOpen"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsLastLineBlank"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTMLBlockType"
			Group="Behavior"
			InitialValue="kHTMLBlockTypeNone"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartPos"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EndPos"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Group="Behavior"
			Type="MarkdownKit.BlockType"
			EditorType="Enum"
			#tag EnumValues
				"0 - Document"
				"1 - BlockQuote"
				"2 - List"
				"3 - ListItem"
				"4 - FencedCode"
				"5 - IndentedCode"
				"6 - HtmlBlock"
				"7 - Paragraph"
				"8 - AtxHeading"
				"9 - SetextHeading"
				"10 - ThematicBreak"
				"11 - ReferenceDefinition"
				"12 - Block"
				"13 - TextBlock"
				"14 - Softbreak"
				"15 - Hardbreak"
				"16 - InlineText"
				"17 - Emphasis"
				"18 - Strong"
				"19 - Codespan"
				"20 - InlineHTML"
				"21 - InlineLink"
				"22 - InlineImage"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Level"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceChar"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceLength"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceOffset"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InfoString"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Destination"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Label"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Delimiter"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DelimiterLength"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsAutoLink"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsChildOfListItem"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsChildOfTightList"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
