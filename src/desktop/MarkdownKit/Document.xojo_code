#tag Class
Protected Class Document
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Shared Function AcceptsLines(type As MarkdownKit.BlockType) As Boolean
		  // Returns True if the queried Block type accepts lines.
		  
		  Return type = BlockType.Paragraph Or _
		  type = BlockType.AtxHeading Or _
		  type = BlockType.IndentedCode Or _
		  type = BlockType.FencedCode
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddLinkReferenceDefinition(name As String, destination As String, title As String)
		  // Adds a new link reference definition to this document's reference map.
		  
		  // Only add this definition if it's name is unique (case-insensitive) as 
		  // the first encountered definition supersedes subsequently similarly named 
		  // definitions.
		  If ReferenceMap.HasKey(name.Lowercase) Then
		    Return
		  Else
		    ReferenceMap.Value(name.Lowercase) = New MarkdownKit.LinkReferenceDefinition(name, destination, title)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function CanContain(parentType As MarkdownKit.BlockType, childType As MarkdownKit.BlockType) As Boolean
		  // Returns True if a Block of type `parentType` can contain a child Block of 
		  // type `childType`.
		  
		  Return parentType = BlockType.Document Or _
		  parentType = BlockType.BlockQuote Or _
		  parentType = BlockType.ListItem Or _
		  (parentType = BlockType.List And childType = BlockType.ListItem)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(source As String, trackCharacterOffsets As Boolean = False)
		  ///
		  ' - Parameter trackCharacterOffsets: If True then this document will track the offset of the 
		  '                                    first character of every line and the character offset 
		  '                                    that each block begins at. These properties are not 
		  '                                    required to accurately generate HTML (but may be required 
		  '                                    for other AST manipulations such as syntax highlighting).
		  ///
		  
		  Super.Constructor(MarkdownKit.BlockType.Document, Nil)
		  
		  Self.TrackCharacterOffsets = trackCharacterOffsets
		  
		  // Document Blocks act as the root of the block tree. 
		  Self.Root = Self
		  
		  // They don't have parents.
		  Self.Parent = Nil
		  
		  Self.ReferenceMap = New Dictionary
		  
		  // Standardise the line endings in the passed Markdown to line feeds.
		  source = ReplaceLineEndings(source, &u000A)
		  
		  // Split the source into lines of Text.
		  Var tmp() As String = source.Split(&u000A)
		  
		  Var lineStarts() As Integer = Array(0)
		  If trackCharacterOffsets Then
		    // Track the 0-based index of the first character for every line.
		    Var chars() As String = source.Split("")
		    For i As Integer = 0 To chars.LastIndex
		      If chars(i) = &u000A Then lineStarts.Add(i + 1)
		    Next i
		  End If
		  
		  // Convert each line of text in the temporary array to a LineInfo object.
		  Var tmpLastIndex As Integer = tmp.LastIndex
		  Var i As Integer
		  If trackCharacterOffsets Then
		    // We can pass in the actual offset that each line begins at.
		    For i = 0 To tmpLastIndex
		      Lines.Add(New MarkdownKit.LineInfo(tmp(i), i + 1, lineStarts(i)))
		    Next i
		  Else
		    For i = 0 To tmpLastIndex
		      Lines.Add(New MarkdownKit.LineInfo(tmp(i), i + 1))
		    Next i
		  End If
		  
		  // Remove contiguous blank lines at the beginning and end of the array.
		  // As blank lines at the beginning and end of the document 
		  // are ignored (commonmark spec 0.29 4.9).
		  // Leading...
		  While Lines.LastIndex > -1
		    If Lines(0).IsBlank Then
		      Lines.RemoveAt(0)
		    Else
		      Exit
		    End If
		  Wend
		  // Trailing...
		  For i = Lines.LastIndex DownTo 0
		    If Lines(i).IsBlank Then
		      Lines.RemoveAt(i)
		    Else
		      Exit
		    End If
		  Next i
		  
		  // Cache the upper bounds of the Lines array.
		  LinesLastIndex = Lines.LastIndex
		  
		  // The document block starts open.
		  IsOpen = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ConvertParagraphBlockToSetextHeading(ByRef p As MarkdownKit.Block, line As MarkdownKit.LineInfo) As MarkdownKit.Block
		  // Remove the passed Paragraph block (`p`) from its parent and replace it with a new 
		  // SetextHeading block with the same children.
		  // Returns the newly created SetextHeading.
		  
		  // Get a reference to the passed paragraph's parent.
		  Var paraParent As MarkdownKit.Block = p.Parent
		  
		  // Get the index of the passed paragraph in its parent's Children array.
		  Var index As Integer = paraParent.Children.IndexOf(p)
		  If index = -1 Then
		    Raise New MarkdownKit.MarkdownException("Unable to convert paragraph block to setext heading")
		  End If
		  
		  // Create a new SetextHeading block to replace the paragraph.
		  Var stx As New MarkdownKit.Block(BlockType.SetextHeading, New WeakRef(p.Parent))
		  
		  // Set the root.
		  stx.Root = p.Root
		  
		  // Copy the paragraph's raw character array to this SetextHeading.
		  stx.Chars = p.Chars
		  
		  // Edge case:
		  // It's possible for the contents of this setext heading to be a reference link definition only.
		  // In this scenario, we need to get the definition and add it to the document's reference map (if 
		  // appropriate), add the setext heading line as content to this paragraph and raise 
		  // an EdgeCase exception.
		  stx.Finalise(line)
		  If stx.Chars.LastIndex = -1 Then
		    p.AddLine(line, 0)
		    #Pragma BreakOnExceptions False
		    Raise New MarkdownKit.EdgeCase
		    #Pragma BreakOnExceptions True
		  End If
		  
		  // Remove the paragraph from its parent.
		  paraParent.Children.RemoveAt(index)
		  
		  // Insert our new SetextHeading.
		  If index = 0 Then
		    paraParent.Children.Add(stx)
		  Else
		    paraParent.Children.AddAt(index, stx)
		  End If
		  
		  // Assign the parent.
		  stx.Parent = paraParent
		  
		  // Nil out the old paragraph.
		  p = Nil
		  
		  // Return the new SetextHeading.
		  Return stx
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061206E657720626C6F636B206173206368696C64206F6620616E6F746865722E2052657475726E7320746865206368696C642E
		Shared Function CreateChildBlock(theParent As MarkdownKit.Block, line As MarkdownKit.LineInfo, childType As MarkdownKit.BlockType) As MarkdownKit.Block
		  // Create a new Block of the specified type, add it as a child of theParent and 
		  // return the newly created child.
		  
		  // If `theParent` isn't the kind of block that can accept this child,
		  // then back up until we hit a block that can.
		  While Not CanContain(theParent.Type, childType)
		    theParent.Finalise(line)
		    theParent = theParent.Parent
		  Wend
		  
		  // Create the child block.
		  Var child As New MarkdownKit.Block(childType, New WeakRef(theParent))
		  child.Root = theParent.Root
		  
		  // Store the line number that this block begins on.
		  child.LineNumber = line.Number
		  
		  // Store the 0-based offset of the start of this line.
		  child.OffsetOfLineStart = line.StartOffset
		  
		  // Insert the child into the parent's tree.
		  theParent.Children.Add(child)
		  
		  // Return the new child block.
		  Return child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ListsMatch(listData As MarkdownKit.ListData, itemData As MarkdownKit.ListData) As Boolean
		  Return listData.ListType = itemData.ListType And _
		  listData.ListDelimiter = itemData.ListDelimiter And _
		  listData.BulletChar = itemData.BulletChar
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseBlockStructure()
		  // Process each line to determine the overall block structure of this 
		  // Markdown document.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Var currentBlock As MarkdownKit.Block = Self
		  
		  For i As Integer = 0 To LinesLastIndex
		    
		    ProcessLine(Lines(i), currentBlock)
		    
		  Next i
		  
		  // Finalise all blocks in the tree.
		  While currentBlock <> Nil
		    If LinesLastIndex > -1 Then currentBlock.Finalise(Lines(LinesLastIndex))
		    currentBlock = currentBlock.Parent
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseInlines()
		  // Walks this document and its children parsing raw text content into inline content 
		  // where appropriate.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Var stack() As MarkdownKit.Block
		  Var delimiterStack() As MarkdownKit.DelimiterStackNode
		  
		  Var b As MarkdownKit.Block = Self
		  
		  While b <> Nil
		    Select Case b.Type
		    Case BlockType.AtxHeading, BlockType.Paragraph, BlockType.SetextHeading
		      delimiterStack.ResizeTo(-1) // Each block gets a new delimiter stack.
		      If b.Chars.LastIndex > -1 Then InlineScanner.ParseInlines(b, delimiterStack)
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
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ProcessLine(line As MarkdownKit.LineInfo, ByRef currentBlock As MarkdownKit.Block)
		  // Takes a line of source Markdown and incorporates it into the document tree.
		  // currentBlock: The Block that most recently has had lines added to it.
		  //               Will be modified by the method.
		  
		  // Always start processing at the document root.
		  Var container As MarkdownKit.Block = Self
		  
		  // Match this line against each open block in the tree.
		  TryOpenBlocks(line, container)
		  
		  // Store which container was the last to match.
		  Var lastMatchedContainer As MarkdownKit.Block = container
		  
		  // Paragraph Blocks can have lazy continuation lines.
		  Var maybeLazy As Boolean = _
		  If(currentBlock.Type = BlockType.Paragraph, True, False)
		  
		  // Should we create a new block?
		  TryNewBlocks(line, container, maybeLazy)
		  
		  // What remains at the offset is a text line. Add it to the appropriate container.
		  ProcessRemainderOfLine(line, currentBlock, container, lastMatchedContainer)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessRemainderOfLine(line As MarkdownKit.LineInfo, ByRef currentBlock As MarkdownKit.Block, ByRef container As MarkdownKit.Block, ByRef lastMatchedContainer As MarkdownKit.Block)
		  // We've tried matching against the open blocks and we've opened any required 
		  // new blocks. What now remains at the offset is a text line. Add it to the 
		  // appropriate container.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  line.FindNextNonWhitespace
		  Var indent As Integer = line.NextNWSColumn - line.Column
		  Var blank As Boolean = If(line.CurrentChar = "", True, False)
		  
		  If blank And container.LastChild <> Nil Then container.LastChild.IsLastLineBlank = True
		  
		  // Blockquote lines are never blank as they start with ">"
		  // and we don't count blanks in fenced code for the purposes of tight/loose
		  // lists or breaking out of lists. We also don't set IsLastLineBlank
		  // on an empty list item.
		  container.IsLastLineBlank = blank And _
		  container.Type <> BlockType.BlockQuote And _
		  container.Type <> BlockType.SetextHeading And _
		  container.Type <> BlockType.FencedCode And _
		  Not (container.Type = BlockType.ListItem And _
		  container.FirstChild = Nil)
		  
		  // Flag that the last line of all the ancestors of this Block are NOT blank.
		  Var tmpBlock As MarkdownKit.Block = container
		  While tmpBlock.Parent <> Nil
		    tmpBlock.Parent.IsLastLineBlank = False
		    tmpBlock = tmpBlock.Parent
		  Wend
		  
		  // If the last line processed belonged to a paragraph block,
		  // and we didn't match all of the line prefixes for the open containers,
		  // and we didn't start any new containers,
		  // and the line isn't blank,
		  // then treat this as a "lazy continuation line" and add it to
		  // the open paragraph.
		  If currentBlock <> lastMatchedContainer And _
		    container = lastMatchedContainer And _
		    Not blank And _
		    currentBlock.Type = BlockType.Paragraph Then
		    currentBlock.AddLine(line, line.Offset)
		    
		  Else // This is NOT a lazy continuation line.
		    // Finalise any blocks that were not matched and set `currentBlock` to `container`.
		    While currentBlock <> lastMatchedContainer
		      currentBlock.Finalise(line)
		      currentBlock = currentBlock.Parent
		      
		      If currentBlock = Nil Then
		        Raise New MarkdownException( _
		        "Cannot finalise container block. Last matched container type = " + _ 
		        lastMatchedContainer.Type.ToText)
		      End If
		    Wend
		    
		    If container.Type = MarkdownKit.BlockType.IndentedCode Then
		      container.AddLine(line, line.Offset)
		      
		    ElseIf container.Type = MarkdownKit.BlockType.FencedCode Then
		      If (indent <= 3 And line.CurrentChar = container.FenceChar) And _
		        0 <> BlockScanner.ScanCloseCodeFence(line.Chars, line.NextNWS, container.FenceLength) Then
		        // If it's a closing fence, set the fence length to -1. It will be closed when the next line is processed. 
		        container.FenceLength = -1
		      Else
		        container.AddLine(line, line.Offset)
		      End If
		      
		    ElseIf container.Type = MarkdownKit.BlockType.HtmlBlock Then
		      container.AddLine(line, line.Offset)
		      If BlockScanner.ScanHTMLBlockEnd(container.HtmlBlockType, line, line.NextNWS) Then
		        container.Finalise(line)
		        container = container.Parent
		      End If
		      
		    ElseIf blank Then
		      // Do nothing?
		      
		    ElseIf container.Type = MarkdownKit.BlockType.AtxHeading Then
		      container.Finalise(line)
		      container = container.Parent
		      
		    ElseIf AcceptsLines(container.Type) Then
		      container.AddLine(line, line.NextNWS)
		      
		    ElseIf container.Type <> BlockType.ThematicBreak And _ 
		      container.Type <> BlockType.SetextHeading Then
		      // Create a paragraph container for this line.
		      container = CreateChildBlock(container, line, BlockType.Paragraph)
		      container.AddLine(line, line.NextNWS)
		      
		    Else
		      Raise New MarkdownKit.MarkdownException( _
		      "Line " + line.Number.ToText + " with container type `" + _
		      container.Type.ToText + "` did not match any condition")
		    End If
		    
		    currentBlock = container
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReplaceLineEndings(t As String, what As String) As String
		  // Normalize the line endings first.
		  t = t.ReplaceAll(&u000D + &u000A, &u000A)
		  t = t.ReplaceAll(&u000D, &u000A)
		  
		  // Now replace them.
		  t = t.ReplaceAll(&u000A, what)
		  
		  Return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TryNewBlocks(line As MarkdownKit.LineInfo, ByRef container As MarkdownKit.Block, ByRef maybeLazy As Boolean)
		  // Unless the last matched container is code or HTML block, 
		  // try to start a new container block.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Const kCodeIndent = 4
		  Var indent, tmpInt1, tmpInt2 As Integer
		  Var blank, indented As Boolean
		  Var tmpData As MarkdownKit.ListData
		  
		  While container.Type <> BlockType.FencedCode And _
		    container.Type <> BlockType.IndentedCode And _
		    container.Type <> BlockType.HtmlBlock
		    
		    line.FindNextNonWhitespace
		    indent = line.NextNWSColumn - line.Column + line.RemainingSpaces
		    indented = indent >= kCodeIndent
		    blank = If(line.CurrentChar = "", True, False)
		    
		    If Not indented And line.CurrentChar = ">" Then
		      // ============= New blockquote =============
		      line.AdvanceOffset(line.NextNWS + 1 - line.Offset, False)
		      Call line.AdvanceOptionalSpace
		      container = CreateChildBlock(container, line, BlockType.BlockQuote)
		      
		    ElseIf Not indented And line.CurrentChar = "#" And _
		      0 <> BlockScanner.ScanAtxHeadingStart(line.Chars, line.NextNWS, _ 
		      tmpInt1, tmpInt2) Then
		      // ============= New ATX heading =============
		      line.AdvanceOffset(line.NextNWS + tmpInt2 - line.Offset, False)
		      
		      container = CreateChildBlock(container, line, BlockType.AtxHeading)
		      container.Level = tmpInt1
		      
		    ElseIf Not indented And _
		      (line.CurrentChar = "`" Or line.CurrentChar = "~") And _ 
		      0 <> BlockScanner.ScanOpenCodeFence(line.Chars, line.NextNWS, tmpInt1) Then
		      // ============= New fenced code block =============
		      container = CreateChildBlock(container, line, BlockType.FencedCode)
		      container.FenceChar = line.CurrentChar
		      container.FenceLength = tmpInt1
		      container.FenceOffset = line.NextNWS - line.Offset
		      line.AdvanceOffset(line.NextNWS + tmpInt1 - line.Offset, False)
		      
		    ElseIf Not indented And line.CurrentChar = "<" And _
		      (Block.kHTMLBlockTypeNone <> BlockScanner.ScanHtmlBlockStart(line, line.NextNWS, tmpInt1) _
		      Or (container.Type <> BlockType.Paragraph And _
		      Block.kHTMLBlockTypeNone <> BlockScanner.ScanHtmlBlockType7Start(line, line.NextNWS, tmpInt1))) Then
		      // ============= New HTML block =============
		      container = CreateChildBlock(container, line, BlockType.HTMLBlock)
		      container.HtmlBlockType = tmpInt1
		      // NB: We don't adjust offset because the tag is part of the text.
		      
		    ElseIf Not indented And container.Type = BlockType.Paragraph And _
		      (line.CurrentChar = "=" Or line.CurrentChar = "-") And _
		      0 <> BlockScanner.ScanSetextHeadingLine(line.Chars, line.NextNWS, tmpInt1) Then
		      // ============= New setext heading =============
		      Try
		        container = ConvertParagraphBlockToSetextHeading(container, line)
		        container.Level = tmpInt1
		      Catch e As MarkdownKit.EdgeCase
		        // This happens when the entire contents of the setext heading is a 
		        // reference link definition. In this scenario, `container` remains a 
		        // paragraph with the setext heading line having been added to the 
		        // paragraph's contents.
		      End Try
		      line.AdvanceOffset(line.Chars.LastIndex + 1 - line.Offset, False)
		      
		    ElseIf Not indented And _
		      Not (container.Type = BlockType.Paragraph And Not line.AllMatched) And _
		      0 <> BlockScanner.ScanThematicBreak(line.Chars, line.NextNWS) Then
		      // ============= New thematic break =============
		      // It's only now that we know that the line is not part of a setext heading.
		      container = CreateChildBlock(container, line, BlockType.ThematicBreak)
		      container.Finalise(line)
		      container = container.Parent
		      line.AdvanceOffset(line.Chars.LastIndex + 1 - line.Offset, False)
		      
		    ElseIf (Not indented Or container.Type = BlockType.List) And _
		      0 <> BlockScanner.ParseListMarker(indented, line.Chars, line.NextNWS, _
		      container.Type = BlockType.Paragraph, tmpData, tmpInt1) Then
		      // ============= New lists / list items =============
		      // Compute padding.
		      line.AdvanceOffset(line.NextNWS + tmpInt1 - line.Offset, False)
		      
		      Var prevOffset As Integer = line.Offset
		      Var prevColumn As Integer = line.Column
		      Var prevRemainingSpaces As Integer = line.RemainingSpaces
		      
		      While line.Column - prevColumn <= kCodeIndent
		        If Not line.AdvanceOptionalSpace Then Exit
		      Wend
		      
		      If line.Column = prevColumn Then
		        // No spaces at all.
		        tmpData.Padding = tmpInt1 + 1
		      ElseIf line.Column - prevColumn > kCodeIndent Or line.CurrentChar = "" Then
		        tmpData.Padding = tmpInt1 + 1
		        // Too many (or no) spaces, ignoring everything but the first one.
		        line.Offset = prevOffset
		        line.Column = prevColumn
		        line.RemainingSpaces = prevRemainingSpaces
		        Call line.AdvanceOptionalSpace
		      Else
		        tmpData.Padding = tmpInt1 + line.Column - prevColumn
		      End If
		      
		      // Check the container. If it's a list, see if this list item
		      // can continue the list. Otherwise, create a list container.
		      tmpData.MarkerOffset = indent
		      
		      If container.Type <> BlockType.List Or Not ListsMatch(container.ListData, tmpData) Then
		        container = CreateChildBlock(container, line, BlockType.List)
		        container.ListData = tmpData
		      End If
		      
		      // Add the list item.
		      container = CreateChildBlock(container, line, BlockType.ListItem)
		      container.ListData = tmpData
		      
		    ElseIf indented And Not maybeLazy And Not blank Then
		      // ============= New indented code block =============
		      line.AdvanceOffset(kCodeIndent, True)
		      container = CreateChildBlock(container, line, BlockType.IndentedCode)
		      
		    Else
		      Exit
		    End If
		    
		    // If this is a line container then it can't contain other containers...
		    If AcceptsLines(container.Type) Then Exit
		    
		    maybeLazy = False
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TryOpenBlocks(line As MarkdownKit.LineInfo, ByRef container As MarkdownKit.Block)
		  // This is step 1 in determining the document block structure.
		  // Iterate through open blocks and descend through the last children 
		  // down to the last open block. For each open Block, check to see if 
		  // this line meets the required condition to keep the block open.
		  // `container`: This will be set to the Block which last had a match to the line.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Const kCodeIndent = 4
		  Var indent As Integer
		  Var blank As Boolean
		  
		  line.AllMatched = True
		  
		  While container.LastChild <> Nil And container.LastChild.IsOpen
		    
		    container = container.LastChild
		    
		    line.FindNextNonWhitespace
		    
		    indent = line.NextNWSColumn - line.Column + line.RemainingSpaces
		    
		    blank = If(line.CurrentChar = "", True, False)
		    
		    Select Case container.Type
		    Case BlockType.BlockQuote
		      If indent <= 3 And line.CurrentChar= ">" Then
		        line.AdvanceOffset(indent + 1, True)
		        Call line.AdvanceOptionalSpace
		      Else
		        line.AllMatched = False
		      End If
		      
		    Case BlockType.ListItem
		      If indent >= container.ListData.MarkerOffset + container.ListData.Padding Then
		        line.AdvanceOffset(container.ListData.MarkerOffset + container.ListData.Padding, True)
		      ElseIf blank And container.FirstChild <> Nil Then
		        // If container.FirstChild is Nil, then the opening line
		        // of the list item was blank after the list marker. In this
		        // case, we are done with the list item.
		        line.AdvanceOffset(line.NextNWS - line.Offset, False)
		      Else
		        line.AllMatched = False
		      End If
		      
		    Case BlockType.IndentedCode
		      If indent >= kCodeIndent Then
		        line.AdvanceOffset(kCodeIndent, True)
		      ElseIf blank Then
		        line.AdvanceOffset(line.NextNWS - line.Offset, False)
		      Else
		        line.AllMatched = False
		      End If
		      
		    Case BlockType.AtxHeading, BlockType.SetextHeading
		      // A heading can never contain more than one line.
		      line.AllMatched = False
		      If blank Then container.IsLastLineBlank = True
		      
		    Case BlockType.FencedCode
		      // -1 means we've seen closer 
		      If container.FenceLength = -1 Then
		        line.AllMatched = False
		        If blank Then container.IsLastLineBlank = True
		      Else
		        // Skip optional spaces of fence offset.
		        Var i As Integer = container.FenceOffset
		        While i > 0 And line.Offset <= line.CharsLastIndex And _
		          line.Chars(line.Offset) = " "
		          line.Offset = line.Offset + 1
		          line.Column = line.Column + 1
		          i = i - 1
		        Wend
		      End If
		      
		    Case MarkdownKit.BlockType.HtmlBlock
		      // All other block types can accept blanks.
		      If blank And container.HtmlBlockType >= kHtmlBlockTypeInterruptingBlock Then
		        container.IsLastLineBlank = True
		        line.AllMatched = False
		      End If
		      
		    Case MarkdownKit.BlockType.Paragraph
		      If blank Then
		        container.IsLastLineBlank = True
		        line.AllMatched = False
		      End If
		    End Select
		    
		    If Not line.AllMatched Then
		      // Back up to the last matching block.
		      container = container.Parent
		      Exit
		    End If
		  Wend
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Lines() As MarkdownKit.LineInfo
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LinesLastIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E20776520747261636B2074686520302D6261736564206F666673657420696E2074686520736F75726365206F6620746865207374617274206F662065616368206C696E6520616E642070617261677261706820626C6F636B2E
		TrackCharacterOffsets As Boolean = False
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="LineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OffsetOfLineStart"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
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
			Name="IsChildOfTightList"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceChar"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceLength"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceOffset"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InfoString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Destination"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Label"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Delimiter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DelimiterLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsAutoLink"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartPos"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="EndPos"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Level"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTMLBlockType"
			Visible=false
			Group="Behavior"
			InitialValue="kHTMLBlockTypeNone"
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
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			Name="IsOpen"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
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
			Name="TrackCharacterOffsets"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
