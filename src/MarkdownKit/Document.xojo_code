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
		Private Sub AdvanceOptionalSpace(line As MarkdownKit.LineInfo, ByRef charPos As Integer, ByRef charCol As Integer, ByRef char As Text)
		  // This method advances the character pointer and updates the passed ByRef parameters by 
		  // one place if (and only if) this character is a space.
		  
		  If char <> &u0020 Then Return
		  
		  If charPos >= line.CharsUbound Then Return
		  
		  AdvancePos(line, 1, charPos, charCol, char)
		  
		End Sub
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
		Private Sub FindFirstNonWhitespace(line As MarkdownKit.LineInfo, ByRef startPos As Integer, ByRef charCol As Integer, ByRef char As Text)
		  // Starting at `startPos`, step through the contents of the passed line, character-by-character 
		  // until we find a non-whitespace character (NWS). 
		  // Set the passed ByRef `startPos` parameter to the zero-based index of this first NWS character.
		  // Set the passed ByRef `charCol` to the one-based column of this first NWS character.
		  // Set the passed ByRef `char` to the first NWS character.
		  // If there are no NWS on this line (searching only from `startPos` onwards) then set 
		  // `startPos` and `charCol` to -1 and `char` to "".
		  
		  // Is the entire line blank?
		  If line.IsBlank Then
		    startPos = -1
		    charCol = -1
		    char = ""
		    Return
		  End If
		  
		  // Is the remainder of the line blank?
		  If startPos = -1 Then
		    startPos = -1
		    charCol = -1
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
		      char = tmpChar
		      foundNWS = True
		      Exit
		    End Select
		  Next i
		  
		  If foundNWS Then
		    // Found a NWS character. Calculate the column it's in.
		    // Remember, we've only thus far counted the number of columns from the current 
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
		    charCol = column
		  Else
		    // Reset the ByRef parameters.
		    startPos = -1
		    charCol = -1
		    char = ""
		  End If
		  
		  
		End Sub
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
		  Dim currentCharCol As Integer = 1 // The one-based column that currentChar is in. Note a tab = 4 columns.
		  Dim blank As Boolean = False // Whether there are no more characters on the line.
		  Dim indented As Boolean
		  Dim tmpInt As Integer
		  While container.LastChild <> Nil And container.LastChild.IsOpen
		    
		    container = container.LastChild
		    
		    // Get the first non-whitespace (NWS) character, starting from the zero-based 
		    // index `currentCharPos`. Update `currentChar`, `currentCharPos` and `CurrentCharCol`.
		    FindFirstNonWhitespace(line, currentCharPos, currentCharCol, currentChar)
		    
		    // Is the first NWS character indented?
		    indented = If(currentCharCol > 4, True, False)
		    
		    // Blank remaining line?
		    blank = If(currentChar = "", True, False)
		    
		    Select Case container.Type
		    Case MarkdownKit.BlockType.BlockQuote
		      If currentChar = ">" And Not indented And Not IsEscaped(line.Chars, currentCharPos) Then
		        // Continue this open blockquote.
		        // Advance one position along the line (past the ">" character we've just handled).
		        AdvancePos(line, 1, currentCharPos, currentCharCol, currentChar)
		        // An optional space is permitted after the ">". Handle this scenario.
		        AdvanceOptionalSpace(line, currentCharPos, currentCharCol, currentChar)
		      Else
		        allMatched = False
		      End If
		      
		    Case MarkdownKit.BlockType.AtxHeading, MarkdownKit.BlockType.SetextHeading
		      // A heading can never contain more than one line.
		      allMatched = False
		      
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
		    // index `currentCharPos`. Update `currentChar`, `currentCharPos` and `CurrentCharCol`.
		    FindFirstNonWhitespace(line, currentCharPos, currentCharCol, currentChar)
		    
		    // Is the first NWS character indented?
		    indented = If(currentCharCol > 4, True, False)
		    
		    // Blank remaining line?
		    blank = If(currentChar = "", True, False)
		    
		    If Not indented And currentChar = ">" And Not IsEscaped(line.Chars, currentCharPos) Then
		      // New blockquote.
		      // Advance one position along the line (past the ">" character we've just handled).
		      AdvancePos(line, 1, currentCharPos, currentCharCol, currentChar)
		      // An optional space is permitted after the ">". Handle this scenario.
		      AdvanceOptionalSpace(line, currentCharPos, currentCharCol, currentChar)
		      // Create the new blockquote block.
		      container = CreateChildBlock(container, line, MarkdownKit.BlockType.BlockQuote, _
		      currentCharPos, currentCharCol)
		    ElseIf Not indented And currentChar = "#" And _
		      Not IsEscaped(line.Chars, currentCharPos) And _
		      MyScanner.ValidAtxHeadingStart(line, currentCharPos, tmpInt) Then
		      // New ATX heading.
		      // Create the new ATX heading block.
		      container = CreateChildBlock(container, line, MarkdownKit.BlockType.AtxHeading, _
		      currentCharPos, currentCharCol)
		      // Assign the heading's level.
		      MarkdownKit.AtxHeading(container).Level = tmpInt
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
		  FindFirstNonWhitespace(line, currentCharPos, CurrentCharCol, currentChar)
		  indented = If(currentCharCol > 4, True, False)
		  blank = If(currentChar = "", True, False)
		  
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
		    currentBlock.AddLine(line, currentCharPos, currentCharCol)
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
		    
		    If Not blank Then
		      If container.AcceptsLines Then
		        container.AddLine(line, currentCharPos, currentCharCol)
		      ElseIf container.Type = MarkdownKit.BlockType.AtxHeading Then
		        // ATX heading.
		        currentBlock.AddLine(line, currentCharPos, currentCharCol)
		        container.Finalise
		        container = container.Parent
		      ElseIf container.Type <> MarkdownKit.BlockType.ThematicBreak And _
		        container.Type <> MarkdownKit.BlockType.SetextHeading Then
		        // Create a paragraph container for the line.
		        container = CreateChildBlock(container, line, MarkdownKit.BlockType.Paragraph, currentCharPos, currentCharCol)
		        container.AddLine(line, currentCharPos, currentCharCol)
		      Else
		        Raise New MarkdownKit.MarkdownException(_
		        "Line " + line.Number.ToText + " with container type " + container.Type.ToText + " did not " + _
		        "match any condition")
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
