#tag Class
Protected Class Document
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.Walker)
		  visitor.VisitDocument(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AcceptsLines() As Boolean
		  // Document blocks do not accept lines.
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AdvanceOptionalSpace(line As MarkdownKit.LineInfo, ByRef charPos As Integer, ByRef charCol As Integer, ByRef char As Text) As Boolean
		  // This method advances the character pointer and updates the passed ByRef parameters by 
		  // one place if this character is either a space or a tab.
		  // Returns True if the character is a tab, False if it is anything else.
		  
		  If char <> &u0020 And char <> &u0009 Then Return False
		  
		  If charPos >= line.CharsUbound Then Return False
		  
		  AdvancePos(line, 1, charPos, charCol, char)
		  
		  If char = &u0009 Then
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AdvancePos(line As MarkdownKit.LineInfo, places As Integer, ByRef charPos As Integer, ByRef charCol As Integer, ByRef char As Text)
		  // Advances the position of the character pointer on the passed line by `places` number of places.
		  // Updates the passed ByRef parameters accordingly.
		  // If incrementing the character pointer by the specified number of places causes the pointer to 
		  // point beyond the remaining characters on the line then we set 
		  // `charPos` and `charCol` to -1 and `char` to "".
		  
		  // Sanity check.
		  If places <= 0 Then Return
		  
		  // Do the increment.
		  charPos = charPos + places
		  
		  // Bounds check.
		  If charPos > line.CharsUbound Then
		    charPos = -1
		    charCol = -1
		    char = ""
		    Return
		  End If
		  
		  // All good. Update the ByRef parameters.
		  Dim i As Integer
		  charCol = 0
		  For i = 0 To charPos
		    Select Case line.Chars(i)
		    Case &u0009 // Tab. This equates to 4 columns.
		      charCol = charCol + 4
		    Else // All other characters equate to one column.
		      charCol = charCol + 1
		    End Select
		  Next i
		  char = line.Chars(charPos)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanContain(childType As MarkdownKit.BlockType) As Boolean
		  // Document blocks can contain all blocks except for document blocks.
		  
		  If childType = MarkdownKit.BlockType.Document Then
		    Return False
		  Else
		    Return True
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructBlockStructure()
		  Dim i, limit As Integer
		  limit = Lines.Ubound
		  Dim currentBlock As MarkdownKit.Block = Self
		  For i = 0 To limit
		    ProcessLine(Lines(i), currentBlock)
		  Next i
		  
		  // Finalise all blocks.
		  While currentBlock <> Nil
		    currentBlock.Finalise
		    currentBlock = currentBlock.Parent
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(markdown As Text)
		  // Make sure that the MarkdownKit module has been initialised.
		  MarkdownKit.Initialise
		  
		  MyScanner = New MarkdownKit.Scanner
		  
		  // Standardise the line endings in the passed Markdown to line feeds.
		  markdown = ReplaceLineEndings(markdown, MarkdownKit.kLF)
		  
		  // Replace insecure characters (spec 0.29 2.3).
		  markdown = markdown.ReplaceAll(&u0000, &uFFFD)
		  
		  // Split the Markdown into lines of Text.
		  Dim tmp() As Text = markdown.Split(MarkdownKit.kLF)
		  
		  // Cache the upperbounds of the temporary Text array.
		  Dim tmpUbound As Integer = tmp.Ubound
		  
		  // Convert each line of text in the temporary array to a LineInfo object.
		  For i As Integer = 0 To tmpUbound
		    Lines.Append(New MarkdownKit.LineInfo(tmp(i), i))
		  Next i
		  
		  // Remove contiguous blank lines at the beginning of the array.
		  Dim count As Integer = 0
		  While count <= tmpUbound
		    If Lines(0).IsBlank Then
		      Lines.Remove(0)
		    Else
		      Exit
		    End If
		    count = count + 1
		  Wend
		  
		  // Remove contiguous blank lines from the end of the array.
		  For i As Integer = Lines.Ubound DownTo 0
		    If Lines(i).IsBlank Then
		      Lines.Remove(i)
		    Else
		      Exit
		    End If
		  Next i
		  
		  // Cache the upper bounds of the Lines array.
		  LinesUbound = Lines.Ubound
		  
		  // The root starts open.
		  IsOpen = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ConvertParagraphToSetextHeading(b As MarkdownKit.Block, line As MarkdownKit.LineInfo, level As Integer) As MarkdownKit.Block
		  // Remove the passed Paragraph block from its parent and replace it with a new 
		  // SetextHeading block with the same children.
		  // Returns the newly created SetextHeading.
		  
		  // Make sure we've been passed a Paragraph block.
		  If b.Type <> MarkdownKit.BlockType.Paragraph Then
		    Raise New MarkdownKit.MarkdownException("Expected a Paragraph block to be passed")
		  End If
		  
		  Dim p As MarkdownKit.Paragraph = MarkdownKit.Paragraph(b)
		  
		  // Get a reference to the Paragraph's parent.
		  Dim theParent As MarkdownKit.Block = p.Parent
		  
		  // Get the index of this Paragraph in its parent's Children array.
		  Dim index As Integer = theParent.Children.IndexOf(p)
		  If index = -1 Then
		    Raise New MarkdownKit.MarkdownException("Unable to convert paragraph block to setext heading")
		  End If
		  
		  // Create a new SetextHeading block to replace the paragraph.
		  Dim stx As New MarkdownKit.SetextHeading(line, p.FirstCharPos, p.FirstCharCol)
		  stx.Level = level
		  
		  // Copy the Paragraph's children to this SetextHeading.
		  For i As Integer = 0 To p.Children.Ubound
		    stx.Children.Append(p.Children(i))
		  Next i
		  
		  // Remove the Paragraph.
		  theParent.Children.Remove(index)
		  
		  // Insert the SetextHeading.
		  If index = 0 Then
		    theParent.Children.Append(stx)
		  Else
		    theParent.Children.Insert(index, stx)
		  End If
		  
		  stx.Parent = theParent
		  
		  Return stx
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CreateChildBlock(theParent As MarkdownKit.Block, line As MarkdownKit.LineInfo, childType As MarkdownKit.BlockType, charPos As Integer, charCol As Integer) As MarkdownKit.Block
		  // Creates a new block of the specified type and adds it as a child of `container`.
		  // Returns the newly created child.
		  
		  // If `theParent` isn't the kind of block that can accept this child, 
		  // back up until we hit a block that can.
		  While Not theparent.CanContain(childType) 
		    theParent.Finalise
		    theParent = theParent.Parent
		  Wend
		  
		  // Create the child block.
		  Dim child As MarkdownKit.Block
		  Select Case childType
		  Case MarkdownKit.BlockType.AtxHeading
		    child = New MarkdownKit.AtxHeading(line, charPos, charCol)
		  Case MarkdownKit.BlockType.BlockQuote
		    child = New MarkdownKit.BlockQuote(line, charPos, charCol)
		  Case MarkdownKit.BlockType.Paragraph
		    child = New MarkdownKit.Paragraph(line, charPos, charCol)
		  Case MarkdownKit.BlockType.FencedCode
		    child = New MarkdownKit.FencedCode(line, charPos, charCol)
		  Case MarkdownKit.BlockType.IndentedCode
		    child = New MarkdownKit.IndentedCode(line, charPos, charCol)
		  Case MarkdownKit.BlockType.SetextHeading
		    child = new MarkdownKit.SetextHeading(line, charPos, charCol)
		  Case MarkdownKit.BlockType.ThematicBreak
		    child = new MarkdownKit.ThematicBreak(line, charPos, charCol)
		  Case MarkdownKit.BlockType.List
		    child = New MarkdownKit.List(line, charPos, charCol)
		  Case MarkdownKit.BlockType.ListItem
		    child = New MarkdownKit.ListItem(line, charPos, charCol)
		  Else
		    Dim err As New Xojo.Core.UnsupportedOperationException
		    err.Reason = childType.ToText + " blocks are not yet supported"
		    Raise err
		  End Select
		  
		  child.Parent = theParent
		  
		  // Insert the child into the parent's tree.
		  theParent.Children.Append(child)
		  
		  // Return the new child block.
		  Return child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub FindFirstNonWhitespace(line As MarkdownKit.LineInfo, ByRef startPos As Integer, ByRef absoluteCol As Integer, ByRef relativeCol As Integer, ByRef char As Text)
		  // Starting at `startPos`, step through the contents of the passed line, character-by-character 
		  // until we find a non-whitespace character (NWS). 
		  // Set the passed ByRef `startPos` parameter to the zero-based index of this first NWS character.
		  // Set the passed ByRef `absoluteCol` to the one-based column of this first NWS character.
		  // Set the passed ByRef `char` to the first NWS character.
		  // If there are no NWS on this line (searching only from `startPos` onwards) then set 
		  // `startPos` and `charCol` to -1 and `char` to "".
		  // Set the passed ByRef `relativeCol` to the column that this first NEW character occurs 
		  // on, relative to the start position on the line.
		  
		  // Is the entire line blank?
		  If line.IsBlank Then
		    startPos = -1
		    absoluteCol = -1
		    relativeCol = -1
		    char = ""
		    Return
		  End If
		  
		  // Is the remainder of the line blank?
		  If startPos = -1 Then
		    startPos = -1
		    absoluteCol = -1
		    relativeCol = -1
		    char = ""
		    Return
		  End If
		  
		  // Check each character for the first NWS character
		  Dim foundNWS As Boolean = False
		  Dim i, column As Integer = 0
		  Dim tmpChar As Text
		  Dim originalStartPos As Integer = startPos
		  For i = startPos To line.CharsUbound
		    tmpChar = line.Chars(i)
		    Select Case tmpChar
		    Case &u0020 // Space.
		      column = column + 1
		    Case &u0009 // Tab.
		      column = column + 4
		    Else // Non-whitespace character.
		      column = column + 1
		      startPos = i
		      relativeCol = column
		      char = tmpChar
		      foundNWS = True
		      Exit
		    End Select
		  Next i
		  
		  If foundNWS Then
		    // Found a NWS character. Calculate the absolute column it's in.
		    // Remember, we've only thus far calculated the relative number columns from the current 
		    // position on the line to the first NWS character, we've neglected characters 
		    // preceding the current position.
		    If originalStartPos > 1 Then
		      Dim tmpInt As Integer = originalStartPos - 1
		      For i = 0 To tmpInt
		        Select Case line.Chars(i)
		        Case &u0009 // Tab.
		          column = column + 4
		        Else
		          column = column + 1
		        End Select
		      Next i
		    End If
		    absoluteCol = column
		  Else
		    // Reset the ByRef parameters.
		    startPos = -1
		    absoluteCol = -1
		    relativeCol = -1
		    char = ""
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ListsMatch(listData As MarkdownKit.ListData, itemData As MarkdownKit.ListData) As Boolean
		  If listData.Type = itemData.Type And listData.Bullet = itemData.Bullet Then
		    Return True
		  Else
		    Return False
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ProcessLine(line As MarkdownKit.LineInfo, ByRef currentBlock As MarkdownKit.Block)
		  Dim container As MarkdownKit.Block
		  
		  // Start at the root.
		  container = Self
		  
		  // Step 1:
		  // Iterate through the open blocks and descend through the last children 
		  // down to the last open block. For each open block, check to see if this 
		  // line meets the required condition to keep the block open.
		  // In this phase we match all or just some of the open blocks but 
		  // we cannot close unmatched Blocks yet because we may have a lazy continuation line.
		  Dim allMatched As Boolean  = True
		  Dim currentChar As Text = "" // The current character on this line to handle.
		  Dim currentCharPos As Integer = 0 // Zero-based index of the current character on this line.
		  
		  // The one-based column that currentChar is in. Note a tab = 4 columns.
		  // This is the absolute column (i.e. the number of columns from the start of the line to 
		  // the current character).
		  Dim absoluteCol As Integer = 1
		  
		  // This is the (one-based) relative column that the current character is in. Often this will 
		  // be the same as `absoluteCol` but if we are in a partially matched line then the "start" of 
		  // that line may well not be the beginning of the line and therefore, the column that the 
		  // current character is needs to be adjusted.
		  Dim relativeCol As Integer = 1
		  
		  Dim blank As Boolean = False // Whether there are no more characters on the line.
		  Dim indented As Boolean
		  Dim tmpInt1, tmpInt2 As Integer
		  Dim tmpText1, tmpText2 As Text
		  Dim tmpListData As ListData
		  While container.LastChild <> Nil And container.LastChild.IsOpen
		    
		    container = container.LastChild
		    
		    // Get the first non-whitespace (NWS) character, starting from the zero-based 
		    // index `currentCharPos`. Update `currentChar`, `currentCharPos` and `absoluteCol`.
		    FindFirstNonWhitespace(line, currentCharPos, absoluteCol, relativeCol, currentChar)
		    
		    // // Is the first NWS character indented?
		    indented = If(line.Indented Or relativeCol > 4, True, False)
		    
		    // Blank remaining line?
		    blank = If(currentChar = "", True, False)
		    
		    Select Case container.Type
		    Case MarkdownKit.BlockType.BlockQuote
		      If currentChar = ">" And Not indented And Not IsEscaped(line.Chars, currentCharPos) Then
		        // Continue this open blockquote.
		        // Advance one position along the line (past the ">" character we've just handled).
		        AdvancePos(line, 1, currentCharPos, absoluteCol, currentChar)
		        // An optional space is permitted after the ">". Handle this scenario.
		        Call AdvanceOptionalSpace(line, currentCharPos, absoluteCol, currentChar)
		      Else
		        allMatched = False
		      End If
		      
		    Case MarkdownKit.BlockType.List
		      #Pragma Warning "TODO: This may not be needed"
		      If blank Then container.ListData.Tight = False
		      
		    Case MarkdownKit.BlockType.ListItem
		      If currentCharPos >= container.ListData.ContentStartIndex Then
		        // Continue this open list item.
		        // Advance past the list marker.
		        AdvancePos(line, container.ListData.MarkerWidth, currentCharPos, absoluteCol, currentChar)
		      Else
		        allMatched = False
		      End If
		      
		    Case MarkdownKit.BlockType.IndentedCode
		      If Not indented And Not blank Then allMatched = False
		      
		    Case MarkdownKit.BlockType.AtxHeading, MarkdownKit.BlockType.SetextHeading
		      // A heading can never contain more than one line.
		      allMatched = False
		      
		    Case MarkdownKit.BlockType.FencedCode
		      If MarkdownKit.FencedCode(container).NeedsClosing Then allMatched = False
		      
		    Case MarkdownKit.BlockType.Paragraph
		      // Blank lines interrupt paragraphs.
		      If blank Then allMatched = False
		    End Select
		    
		    If Not allMatched Then
		      container = container.Parent // Back up to last matching block.
		      Exit
		    End If
		  Wend
		  
		  Dim lastMatchedContainer As MarkdownKit.Block = container
		  
		  Dim maybeLazy As Boolean = If(currentBlock.Type = MarkdownKit.BlockType.Paragraph, True, False)
		  
		  // Step 2:
		  // Now that we've consumed the continuation markers for existing blocks, 
		  // we look look for new block starts (e.g: ">" for a blockquote). If we 
		  // encounter a new block start, we close any blocks unmatched in step 1 
		  // before creating the new block as a child of the last matched block.
		  
		  // Remember, some container blocks can't open new blocks (e.g. code blocks)
		  While container.Type <> MarkdownKit.BlockType.FencedCode And _
		    container.Type <> MarkdownKit.BlockType.IndentedCode And _ 
		    container.Type <> MarkdownKit.BlockType.HtmlBlock
		    
		    // Get the first non-whitespace (NWS) character, starting from the zero-based 
		    // index `currentCharPos`. Update `currentChar`, `currentCharPos` and `absoluteCol`.
		    FindFirstNonWhitespace(line, currentCharPos, absoluteCol, relativeCol, currentChar)
		    
		    // // Is the first NWS character indented?
		    indented = If(line.Indented Or relativeCol > 4, True, False)
		    
		    // Blank remaining line?
		    blank = If(currentChar = "", True, False)
		    
		    If Not indented And currentChar = ">" And Not IsEscaped(line.Chars, currentCharPos) Then
		      // ======= NEW BLOCKQUOTE =======
		      // Advance one position along the line (past the ">" character we've just handled).
		      AdvancePos(line, 1, currentCharPos, absoluteCol, currentChar)
		      // An optional space is permitted after the ">". Handle this scenario.
		      Dim optionalTab As Boolean = AdvanceOptionalSpace(line, currentCharPos, absoluteCol, currentChar)
		      // Create the new blockquote block.
		      container = CreateChildBlock(container, line, MarkdownKit.BlockType.BlockQuote, _
		      currentCharPos, absoluteCol)
		      container.OpeningMarkerHasOptionalTab = optionalTab
		      
		    ElseIf Not indented And currentChar = "#" And _
		      Not IsEscaped(line.Chars, currentCharPos) And _
		      MyScanner.ValidAtxHeadingStart(line, currentCharPos, tmpInt1) Then
		      // ======= NEW ATX HEADING =======
		      // Create the new ATX heading block.
		      container = CreateChildBlock(container, line, MarkdownKit.BlockType.AtxHeading, _
		      currentCharPos, absoluteCol)
		      // Assign the heading's level.
		      MarkdownKit.AtxHeading(container).Level = tmpInt1
		      
		    ElseIf Not indented And (currentChar = "`" Or currentChar = "~") And _
		      MyScanner.ValidCodeFenceStart(line, currentCharPos, tmpText1, tmpText2, tmpInt1, tmpInt2) Then
		      // ======= NEW FENCED CODE BLOCK =======
		      // Create the new fenced code block.
		      container = CreateChildBlock(container, line, MarkdownKit.BlockType.FencedCode, _
		      currentCharPos, absoluteCol)
		      // Set the code block's info string, opening character and offset.
		      MarkdownKit.FencedCode(container).InfoString = tmpText1
		      MarkdownKit.FencedCode(container).OpeningChar = tmpText2
		      MarkdownKit.FencedCode(container).Offset = tmpInt1
		      MarkdownKit.FencedCode(container).OpeningLength = tmpInt2
		      // Advance past the opening sequence.
		      currentChar = ""
		      absoluteCol = -1
		      relativeCol = -1
		      currentCharPos = -1
		      
		    ElseIf Not indented And container.Type = MarkdownKit.BlockType.Paragraph And _
		      (currentChar = "=" Or currentChar = "-") And _
		      MyScanner.ValidSetextHeadingUnderline(line, tmpInt1) Then
		      // ======= NEW SETEXT HEADING =======
		      // We know now that the container is NOT a paragraph but is actually a SetextHeading.
		      container = ConvertParagraphToSetextHeading(container, line, tmpInt1)
		      // We don't want to add this line (which we know must be a setext underline line) 
		      // as a child of this new setext heading so we'll flag that the line is blank so that 
		      // it doesn't get added.
		      blank = True
		      
		    ElseIf Not indented And Not (container.Type = MarkdownKit.BlockType.Paragraph And allMatched = False) And _
		      MyScanner.ValidThematicBreakLine(line) Then
		      // ======= NEW THEMATIC BREAK =======
		      // It's only now that we know the line is not part of a setext heading.
		      container = CreateChildBlock(container, line, MarkdownKit.BlockType.ThematicBreak, _
		      currentCharPos, absoluteCol)
		      container.Finalise
		      container = container.Parent
		      
		      // Mark this line as blank so it is subsequently ignored.
		      blank = True
		      Exit
		      
		    ElseIf (Not indented Or container.Type = MarkdownKit.BlockType.List) And _
		      Not blank And MyScanner.ValidListMarker(line, currentCharPos, tmpListData) Then
		      // Check the container. If it's a list then see if this list item
		      // can continue the list. Otherwise, create a new list container.
		      If container.Type <> MarkdownKit.BlockType.List Or Not ListsMatch(container.ListData, tmpListData) Then
		        container = CreateChildBlock(container, line, MarkdownKit.BlockType.List, _
		        currentCharPos, absoluteCol)
		        container.ListData = tmpListData
		      End If
		      
		      // Add the list data.
		      container = CreateChildBlock(container, line, MarkdownKit.BlockType.ListItem, _
		      currentCharPos, absoluteCol)
		      container.ListData = tmpListData
		      
		      // Advance our position in the line past the list marker.
		      AdvancePos(line, tmpListData.MarkerWidth, currentCharPos, absoluteCol, currentChar)
		      
		    ElseIf indented And Not blank And Not maybeLazy Then
		      // ======= NEW INDENTED CODE BLOCK =======
		      // Create the new indented code block.
		      container = CreateChildBlock(container, line, MarkdownKit.BlockType.IndentedCode, _
		      currentCharPos, absoluteCol)
		    Else
		      Exit
		    End If
		    
		    If container.AcceptsLines Then
		      // Containers that accept lines can't contain other containers.
		      Exit
		    End If
		    
		    maybeLazy = False
		  Wend
		  
		  // What remains at the currentCharPos is a text line. Add this text to the 
		  // appropriate container.
		  // If the last line processed belonged to a paragraph block,
		  // and we didn't match all of the line prefixes for the open containers,
		  // and we didn't start any new containers,
		  // and the line isn't blank,
		  // then treat this as a "lazy continuation line" and add it to
		  // the open paragraph.
		  If currentBlock <> lastMatchedContainer And _
		    container = lastMatchedContainer And _
		    Not blank And currentBlock.Type = MarkdownKit.BlockType.Paragraph And _
		    currentBlock.Children.Ubound >= 0 Then
		    currentBlock.AddLine(line, currentCharPos, absoluteCol)
		  Else
		    // Not a lazy continuation.
		    
		    // Finalise any blocks that were not matched and set currentBlock to container.
		    While currentBlock <> lastMatchedContainer
		      currentBlock.Finalise
		      currentBlock = currentBlock.Parent
		      If currentBlock = Nil Then
		        Raise New MarkdownKit.MarkdownException(_
		        "Cannot finalise container block. Last matched container type = " + _
		        lastMatchedContainer.Type.ToText)
		      End If
		    Wend
		    
		    If container.Type = MarkdownKit.BlockType.FencedCode Then
		      If currentChar = MarkdownKit.FencedCode(container).OpeningChar And Not indented And _
		        Not IsEscaped(line.Chars, currentCharPos) And _
		        MyScanner.ValidCodeFenceEnd(line, currentCharPos, MarkdownKit.FencedCode(container)) Then
		        // Mark this fenced code block as requiring closing when the next line is processed.
		        MarkdownKit.FencedCode(container).NeedsClosing = True
		      Else
		        // Add the whole line (including prefixing whitespace) to this fenced code block.
		        container.AddLine(line, 0, 1)
		      End If
		      
		    ElseIf container.Type = MarkdownKit.BlockType.IndentedCode Then
		      // Add the whole line (including prefixing whitespace) to this fenced code block.
		      container.AddLine(line, 0, 1)
		      
		    Else
		      // Only fenced and indented code blocks can contain blank lines.
		      If Not blank Then
		        If container.Type = MarkdownKit.BlockType.AtxHeading Then
		          // ATX heading.
		          container.AddLine(line, currentCharPos, absoluteCol)
		          container.Finalise
		          container = container.Parent
		          
		        ElseIf container.AcceptsLines Then
		          container.AddLine(line, currentCharPos, absoluteCol)
		          
		        ElseIf container.Type <> MarkdownKit.BlockType.ThematicBreak And _
		          container.Type <> MarkdownKit.BlockType.SetextHeading Then
		          // Create a paragraph container for the line.
		          container = CreateChildBlock(container, line, MarkdownKit.BlockType.Paragraph, currentCharPos, _
		          absoluteCol)
		          container.AddLine(line, currentCharPos, absoluteCol)
		          
		        Else
		          Raise New MarkdownKit.MarkdownException(_
		          "Line " + line.Number.ToText + " with container type " + container.Type.ToText + " did not " + _
		          "match any condition")
		        End If
		      End If
		      
		    End If
		    
		    currentBlock = container
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReplaceLineEndings(t As Text, what As Text) As Text
		  // Normalize the line endings first.
		  t = t.ReplaceAll(MarkdownKit.kCRLF, MarkdownKit.kLF)
		  t = t.ReplaceAll(MarkdownKit.kCR, MarkdownKit.kLF)
		  
		  // Now replace them.
		  t = t.ReplaceAll(MarkdownKit.kLF, what)
		  
		  Return t
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Lines() As MarkdownKit.LineInfo
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LinesUbound As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private MyScanner As MarkdownKit.Scanner
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="OpeningMarkerHasOptionalTab"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
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
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsLastLineBlank"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstCharPos"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstCharCol"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
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
	#tag EndViewBehavior
End Class
#tag EndClass
