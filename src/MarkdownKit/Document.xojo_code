#tag Class
Protected Class Document
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IWalker)
		  visitor.VisitDocument(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function AcceptsLines(type As MarkdownKit.BlockType) As Boolean
		  // Returns True if the queried Block type accepts lines.
		  
		  Return type = BlockType.Paragraph Or _
		  type = BlockType.AtxHeading Or _
		  type = BlockType.IndentedCode Or _
		  type = BlockType.FencedCode
		  
		End Function
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
		Sub Constructor(source As Text)
		  Super.Constructor(1, 0, 1)
		  
		  // Document Blocks act as the root of the block tree. They don't have parents.
		  Self.Parent = Nil
		  
		  // Make sure that the MarkdownKit module has been initialised.
		  MarkdownKit.Initialise
		  
		  // Standardise the line endings in the passed Markdown to line feeds.
		  source = ReplaceLineEndings(source, &u000A)
		  
		  // Replace insecure characters (spec 0.29 2.3).
		  source = source.ReplaceAll(&u0000, &uFFFD)
		  
		  // Split the source into lines of Text.
		  Dim tmp() As Text = source.Split(&u000A)
		  
		  // Convert each line of text in the temporary array to a LineInfo object.
		  Dim tmpUbound As Integer = tmp.Ubound
		  Dim i As Integer
		  For i = 0 To tmpUbound
		    Lines.Append(New MarkdownKit.LineInfo(tmp(i), i + 1))
		  Next i
		  
		  // Remove contiguous blank lines at the beginning and end of the array.
		  // As blank lines at the beginning and end of the document 
		  // are ignored (commonmark spec 0.29 4.9).
		  // Leading...
		  While Lines.Ubound > -1
		    If Lines(0).IsBlank Then
		      Lines.Remove(0)
		    Else
		      Exit
		    End If
		  Wend
		  // Trailing...
		  For i = Lines.Ubound DownTo 0
		    If Lines(i).IsBlank Then
		      Lines.Remove(i)
		    Else
		      Exit
		    End If
		  Next i
		  
		  // Cache the upper bounds of the Lines array.
		  LinesUbound = Lines.Ubound
		  
		  // The document block starts open.
		  IsOpen = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416464732061206E657720626C6F636B206173206368696C64206F6620616E6F746865722E2052657475726E7320746865206368696C642E
		Shared Function CreateChildBlock(theParent As MarkdownKit.Block, line As MarkdownKit.LineInfo, childType As MarkdownKit.BlockType, startPos As Integer, startColumn As Integer) As MarkdownKit.Block
		  // Create a new Block of the specified type, add it as a child of theParent and 
		  // return the newly created child.
		  
		  // If `theParent` isn't the kind of block that can accept this child,
		  // then back up until we hit a block that can.
		  While Not CanContain(theParent.Type, childType)
		    theParent.Finalise(line)
		    theParent = theParent.Parent
		  Wend
		  
		  // Create the child block.
		  Dim child As MarkdownKit.Block
		  Select Case childType
		  Case BlockType.BlockQuote
		    child = New MarkdownKit.BlockQuote(line.Number, startPos, startColumn)
		  Case BlockType.Paragraph
		    child = New MarkdownKit.Paragraph(line.Number, startPos, startColumn)
		  Case BlockType.IndentedCode
		    child = New MarkdownKit.IndentedCode(line.Number, startPos, startColumn)
		  Case BlockType.FencedCode
		    child = New MarkdownKit.FencedCode(line.Number, startPos, startColumn)
		  Case BlockType.ATXHeading
		    child = New MarkdownKit.ATXHeading(line.Number, startPos, startColumn)
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

	#tag Method, Flags = &h0
		Sub ParseBlockStructure()
		  // Process each line to determine the overall block structure of this 
		  // Markdown document.
		  
		  Dim currentBlock As MarkdownKit.Block = Self
		  
		  For i As Integer = 0 To LinesUbound
		    
		    ProcessLine(Lines(i), currentBlock)
		    
		  Next i
		  
		  // Finalise all blocks in the tree.
		  While currentBlock <> Nil
		    currentBlock.Finalise(Lines(LinesUbound))
		    currentBlock = currentBlock.Parent
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ProcessLine(line As MarkdownKit.LineInfo, ByRef currentBlock As MarkdownKit.Block)
		  // Takes a line of source Markdown and incorporates it into the document tree.
		  // currentBlock: The Block that most recently has had lines added to it.
		  //               Will be modified by the method.
		  
		  // Always start processing at the document root.
		  Dim container As MarkdownKit.Block = Self
		  
		  //If line.Chars(Line.CharsUbound) = "!" Then Break
		  
		  // Match this line against each open block in the tree.
		  TryOpenBlocks(line, container)
		  
		  // Store which container was the last to match.
		  Dim lastMatchedContainer As MarkdownKit.Block = container
		  
		  // Paragraph Blocks can have lazy continuation lines.
		  Dim maybeLazy As Boolean = _
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
		  
		  line.FindNextNonWhitespace
		  Dim indent As Integer = line.NextNWSColumn - line.Column
		  Dim blank As Boolean = If(line.CurrentChar = "", True, False)
		  
		  If blank And container.LastChild <> Nil Then container.LastChild.IsLastLineBlank = True
		  
		  // Blockquote lines are never blank as they start with ">"
		  // and we don't count blanks in fenced code for the purposes of tight/loose
		  // lists or breaking out of lists. We also don't set IsLastLineBlank
		  // on an empty list item.
		  #Pragma Warning "NOTE: Have omitted the last condition re: container.SourcePosition"
		  container.IsLastLineBlank = blank And _
		  container.Type <> BlockType.BlockQuote And _
		  container.Type <> BlockType.SetextHeading And _
		  container.Type <> BlockType.FencedCode And _
		  Not (container.Type = BlockType.ListItem And _
		  container.FirstChild = Nil)
		  
		  // Flag that the last line of all the ancestors of this Block are NOT blank.
		  Dim tmpBlock As MarkdownKit.Block = container
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
		    currentBlock.Type = BlockType.Paragraph And _
		    currentBlock.Children.Ubound > -1 Then
		    currentBlock.AddLine(line, line.Offset)
		    
		  Else // This is NOT a lazy continuation line.
		    // Finalise any blocks that were not matched and set `curentBlock` to `container`.
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
		      If (indent <= 3 And line.CurrentChar = FencedCode(container).FenceChar) And _
		        0 <> Scanner.ScanCloseCodeFence(line.Chars, line.NextNWS, FencedCode(container).FenceLength) Then
		        // If it's a closing fence, set the fence length to -1. It will be closed when the next line is processed. 
		        FencedCode(container).FenceLength = -1
		      Else
		        container.AddLine(line, line.Offset)
		      End If
		      
		    ElseIf container.Type = MarkdownKit.BlockType.HtmlBlock Then
		      #Pragma Warning "TODO"
		      
		    ElseIf blank Then
		      // Do nothing?
		      
		    ElseIf container.Type = MarkdownKit.BlockType.AtxHeading Then
		      #Pragma Warning "BROKEN: Line not being added to the heading"
		      #Pragma Warning "May be an off-by-1 error in Scanner.ScanATXHeadingStart"
		      Dim p As Integer = line.CharsUbound
		      
		      // Trim trailing spaces.
		      While p >= 0 And (line.Chars(p) = " " Or line.Chars(p) = &u0009)
		        p = p - 1
		      Wend
		      
		      Dim px As Integer = p
		      
		      // If the line end in #s, remove them.
		      while p >= 0 And line.Chars(p) = "#"
		        p = p - 1
		      Wend
		      
		      // There must be a space before the last #.
		      If p < 0 Or (line.Chars(p) <> " " And line.Chars(p) <> &u0009) Then p = px
		      
		      // Trim trailing spaces that are before the closing #s.
		      While p >= line.NextNWS And (line.Chars(p) = " " Or line.Chars(p) = &u0009)
		        p = p - 1
		      Wend
		      
		      container.AddLine(line, line.NextNWS, p - line.NextNWS + 1)
		      container.Finalise(line)
		      container = container.Parent
		      
		    ElseIf AcceptsLines(container.Type) Then
		      container.AddLine(line, line.NextNWS)
		      
		    ElseIf container.Type <> BlockType.ThematicBreak And _ 
		      container.Type <> BlockType.SetextHeading Then
		      // Create a paragraph container for this line.
		      container = CreateChildBlock(container, line, BlockType.Paragraph, _
		      line.NextNWS, line.NextNWSColumn)
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
		Private Function ReplaceLineEndings(t As Text, what As Text) As Text
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
		  
		  Const kCodeIndent = 4
		  Dim indent, tmpInt1, tmpInt2 As Integer
		  Dim blank, indented As Boolean
		  
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
		      container = CreateChildBlock(container, line, BlockType.BlockQuote, line.NextNWS, _
		      line.NextNWSColumn)
		      
		    ElseIf Not indented And line.CurrentChar = "#" And _
		       0 <> Scanner.ScanAtxHeadingStart(line.Chars, line.NextNWS, _ 
		      tmpInt1, tmpInt2) Then
		      // ============= New ATX heading =============
		      line.AdvanceOffset(line.NextNWS + tmpInt2 - line.Offset, False)
		      
		      container = CreateChildBlock(container, line, BlockType.AtxHeading, line.NextNWS, _
		      line.NextNWSColumn)
		      ATXHeading(container).Level = tmpInt1
		      
		    ElseIf Not indented And _
		      (line.CurrentChar = "`" Or line.CurrentChar = "~") And _ 
		      0 <> Scanner.ScanOpenCodeFence(line.Chars, line.NextNWS, tmpInt1) Then
		      // ============= New fenced code block =============
		      container = CreateChildBlock(container, line, BlockType.FencedCode, line.NextNWS, _
		      line.NextNWSColumn)
		      FencedCode(container).FenceChar = line.CurrentChar
		      FencedCode(container).FenceLength = tmpInt1
		      FencedCode(container).FenceOffset = line.NextNWS - line.Offset
		      line.AdvanceOffset(line.NextNWS + tmpInt1 - line.Offset, False)
		      
		    ElseIf indented And Not maybeLazy And Not blank Then
		      // ============= New indented code block =============
		      line.AdvanceOffset(kCodeIndent, True)
		      container = CreateChildBlock(container, line, BlockType.IndentedCode, line.Offset, 0)
		      
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
		  
		  Const kCodeIndent = 4
		  Dim indent As Integer
		  Dim blank As Boolean
		  Dim allMatched As Boolean = True
		  
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
		        allMatched = False
		      End If
		      
		    Case BlockType.IndentedCode
		      If indent >= kCodeIndent Then
		        line.AdvanceOffset(kCodeIndent, True)
		      ElseIf blank Then
		        line.AdvanceOffset(line.NextNWS - line.Offset, False)
		      Else
		        allMatched = False
		      End If
		      
		    Case BlockType.AtxHeading, BlockType.SetextHeading
		      // A heading can never contain more than one line.
		      allMatched = False
		      If blank Then container.IsLastLineBlank = True
		      
		    Case BlockType.FencedCode
		      // -1 means we've seen closer 
		      If MarkdownKit.FencedCode(container).FenceLength = -1 Then
		        allMatched = False
		        If blank Then container.IsLastLineBlank = True
		      Else
		        // Skip optional spaces of fence offset.
		        Dim i As Integer = MarkdownKit.FencedCode(container).FenceOffset
		        While i > 0 And line.Offset <= line.CharsUbound And _
		          line.Chars(line.Offset) = " "
		          line.Offset = line.Offset + 1
		          line.Column = line.Column + 1
		          i = i - 1
		        Wend
		      End If
		      
		    Case MarkdownKit.BlockType.Paragraph
		      If blank Then
		        container.IsLastLineBlank = True
		        allMatched = False
		      End If
		    End Select
		    
		    If Not allMatched Then
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
		Private LinesUbound As Integer = -1
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsOpen"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
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
	#tag EndViewBehavior
End Class
#tag EndClass
