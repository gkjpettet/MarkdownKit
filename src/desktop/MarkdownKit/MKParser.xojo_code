#tag Class
Protected Class MKParser
	#tag Method, Flags = &h21
		Private Function AcceptsLines(b As MKBlock) As Boolean
		  // Returns True if [b] accepts lines.
		  
		  Select Case b.Type
		  Case MKBlockTypes.AtxHeading, MKBlockTypes.FencedCode, MKBlockTypes.IndentedCode, MKBlockTypes.Paragraph
		    Return True
		  Else
		    Return False
		  End Select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 416476616E636573207468652063757272656E74206F6666736574206279205B636F756E745D20706C616365732E
		Private Sub AdvanceOffset(count As Integer, columns As Boolean)
		  /// Advances the current offset by [count] places.
		  ///
		  /// If [columns] is True then we need to take into consideration tab stops.
		  /// The offset relates to the location on the current line that is considered the start of the line
		  /// once indentation and block openers are taken into consideration.
		  
		  If columns Then
		    If mRemainingSpaces > count Then
		      mRemainingSpaces = mRemainingSpaces - count
		      count = 0
		    Else
		      count = count - mRemainingSpaces
		      mRemainingSpaces = 0
		    End If
		  Else
		    mRemainingSpaces = 0
		  End If
		  
		  Var charsToTabStop As Integer
		  Do
		    If count <= 0 Then Exit
		    
		    If mCurrentOffset > mCurrentLine.Characters.LastIndex Then
		      mCurrentChar = ""
		      Exit
		    End If
		    
		    mCurrentChar = mCurrentLine.Characters(mCurrentOffset)
		    
		    If mCurrentChar = &u0009 Then
		      charsToTabStop = 4 - (mCurrentColumn Mod TAB_SIZE)
		      mCurrentColumn = mCurrentColumn + charsToTabStop
		      mCurrentOffset = mCurrentOffset + 1
		      count = count - If(columns, charsToTabStop, 1)
		      If count < 0 Then mRemainingSpaces = 0 - count
		    Else
		      mCurrentOffset = mCurrentOffset + 1
		      mCurrentColumn = mCurrentColumn + 1
		      count = count - 1
		    End If
		  Loop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 416476616E63657320612073696E676C65207370616365206F722074616220696620746865206E6578742063686172616374657220697320612073706163652072657475726E696E6720547275652069662074686572652077617320612073706163652E
		Private Function AdvanceOptionalSpace() As Boolean
		  /// Advances a single space or tab if the next character is a space returning True if there was a space.
		  
		  If mRemainingSpaces > 0 Then
		    mRemainingSpaces = mRemainingSpaces - 1
		    Return True
		  End If
		  
		  If mCurrentOffset > mCharsLastIndex Then Return False
		  
		  Select Case mCurrentLine.Characters(mCurrentOffset)
		  Case &u0020
		    mCurrentOffset = mCurrentOffset + 1
		    mCurrentColumn = mCurrentColumn + 1
		    If mCurrentOffset <= mCharsLastIndex Then
		      mCurrentChar = mCurrentLine.Characters(mCurrentOffset)
		    Else
		      mCurrentChar = ""
		    End If
		    Return True
		    
		  Case &u0009
		    mCurrentOffset = mCurrentOffset + 1
		    Var charsToTabStop As Integer = 4 - (mCurrentColumn Mod TAB_SIZE)
		    mCurrentColumn = mCurrentColumn + charsToTabStop
		    mRemainingSpaces = charsToTabStop - 1
		    If mCurrentOffset <= mCharsLastIndex Then
		      mCurrentChar = mCurrentLine.Characters(mCurrentOffset)
		    Else
		      mCurrentChar = ""
		    End If
		    Return True
		    
		  End Select
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function CanContain(parentType As MKBlockTypes, childType As MKBlockTypes) As Boolean
		  // Returns True if a [parentType] can contain [childType].
		  
		  Return parentType = MKBlockTypes.Document Or _
		  parentType = MKBlockTypes.BlockQuote Or _
		  parentType = MKBlockTypes.ListItem Or _
		  (parentType = MKBlockTypes.List And childType = MKBlockTypes.ListItem)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 437265617465732061206E657720626C6F636B206F66205B747970655D2C20616464732069742061732061206368696C64206F66205B706172656E745D2C20747261636B7320746865206162736F6C75746520736F7572636520636F646520737461727420706F736974696F6E20616E642072657475726E7320746865206E657720626C6F636B2E
		Private Function CreateChildBlock(parent As MKBlock, line As TextLine, type As MKBlockTypes, blockStartOffset As Integer) As MKBlock
		  /// Creates a new block of [type], adds it as a child of [parent].
		  ///
		  /// [blockStartOffset] will be applied to [mCurrentOffset] when determining the absolute start 
		  /// position of this block.
		  
		  // If `parent` can't accept this child, then back up until we hit a block that can.
		  While Not CanContain(parent.Type, type)
		    parent.Finalise(line)
		    parent = parent.Parent
		  Wend
		  
		  // Create the child block.
		  Var child As MKBlock
		  If type = MKBlockTypes.FencedCode Then
		    child = New MKFencedCodeBlock(parent)
		  Else
		    child = New MKBlock(type, parent)
		  End If
		  
		  // Track source code positions for this child block.
		  child.LineNumber = line.Number
		  child.Start = line.Start + mCurrentOffset + blockStartOffset
		  
		  // Insert the child into the parent's tree.
		  parent.Children.Add(child)
		  
		  Return child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 46696E647320746865206E657874206E6F6E2D7768697465737061636520284E57532920636861726163746572206F6E2074686973206C696E65
		Private Sub FindNextNonWhitespace()
		  /// Finds the next non-whitespace (NWS) character on this line
		  
		  // Is the entire line blank?
		  If mCurrentLine.IsBlank Then mCurrentChar = ""
		  
		  Var charsToNextTabStop As Integer = TAB_SIZE - (mCurrentColumn Mod TAB_SIZE)
		  mNextNWS = mCurrentOffset
		  mNextNWSColumn = mCurrentColumn
		  
		  Do
		    If mNextNWS > mCurrentLine.Characters.LastIndex Then
		      mCurrentChar = ""
		      Exit
		    Else
		      mCurrentChar = mCurrentLine.Characters(mNextNWS)
		    End If
		    
		    Select Case mCurrentChar
		    Case &u0020
		      mNextNWS = mNextNWS + 1
		      mNextNWSColumn = mNextNWSColumn + 1
		      charsToNextTabStop = charsToNextTabStop - 1
		      If charsToNextTabStop = 0 Then charsToNextTabStop = TAB_SIZE
		    Case &u0009
		      mNextNWS = mNextNWS + 1
		      mNextNWSColumn = mNextNWSColumn + charsToNextTabStop
		      charsToNextTabStop = TAB_SIZE
		    Else
		      Exit
		    End Select
		  Loop
		  
		  mCurrentIndent = mNextNWSColumn - mCurrentColumn + mRemainingSpaces
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 46696E64732074686520696E64657820696E206D4C696E6573206F6620746865206669727374206E6F6E2D626C616E6B206C696E65206F722072657475726E73202D3120696620746865726520617265206F6E6C7920626C616E6B206C696E65732E
		Private Function FirstNonBlankIndex() As Integer
		  /// Finds the index in mLines of the first non-blank line or returns -1 if there are only blank lines.
		  
		  Var iLimit As Integer = mLines.LastIndex
		  For i As Integer = 0 To iLimit
		    If Not mLines(i).IsBlank Then
		      Return i
		    End If
		  Next i
		  
		  Return -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565206966205B6D43757272656E744C696E655D2C20626567696E6E696E67206174205B6D4E6578744E57535D2C20697320612076616C6964204154582068656164696E672E2049662054727565207468656E205B646174615D2069732061206E65772076616C69642064696374696F6E6172792C206F7468657277697365205B646174615D2069732073657420746F204E696C2E
		Private Function IsATXHeader(ByRef data As Dictionary) As Boolean
		  /// Returns True if [mCurrentLine], beginning at [mNextNWS], is a valid ATX heading.
		  /// If True then [data] is a new valid dictionary, otherwise [data] is set to Nil.
		  ///
		  /// Assumes that [mNextNWS] points to a "#" in [mCurrentLine].
		  
		  data = Nil
		  Var length As Integer = 0
		  Var headingLevel As Integer = 0
		  Var charsLastIndex As Integer = mCurrentLine.Characters.LastIndex
		  Var chars() As String = mCurrentLine.Characters // For brevity.
		  
		  // An ATX heading consists of a string of characters, starting with an 
		  // opening sequence of 1–6 unescaped # characters.
		  Var i As Integer
		  For i = mNextNWS To charsLastIndex
		    If chars(i) = "#" Then
		      headingLevel = headingLevel + 1
		      If headingLevel > 6 Then Return False
		    Else
		      Exit
		    End If
		  Next i
		  If headingLevel = 0 Then Return False
		  
		  // The opening sequence of #s must be followed by a space, a tab or the EOL.
		  If (mNextNWS + headingLevel) > charsLastIndex Then
		    length = headingLevel
		    data = New Dictionary("level" : headingLevel, "length" : length)
		  ElseIf chars(mNextNWS + headingLevel) = " " Or chars(mNextNWS + headingLevel) = &u0009 Then
		    // This is a valid opening sequence. Keep consuming whitespace to determine 
		    // the full length of the opening sequence.
		    length = headingLevel
		    For i = mNextNWS + headingLevel To charsLastIndex
		      Select Case chars(i)
		      Case " ", &u0009
		        length = length + 1
		      Else
		        Exit
		      End Select
		    Next i
		    If length > 0 Then data = New Dictionary("level" : headingLevel, "length" : length)
		  End If
		  
		  Return data <> Nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsClosingCodeFence(length As Integer) As Boolean
		  /// Returns True if mCurrentLine, beginning at `mNextNWS` is a closing fence of at least [length] characters.
		  
		  Var chars() As String = mCurrentLine.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Are the enough remaining characters on the line to be a valid closing fence.
		  If mNextNWS + (length - 1) > charsLastIndex Then Return False
		  
		  Var fenceChar As String = chars(mNextNWS)
		  If fenceChar <> "`" And fenceChar <> "~" Then Return False
		  
		  Var count As Integer = 1
		  
		  For i As Integer = mNextNWS + 1 To charsLastIndex
		    If count = length Then Return True
		    
		    Var char As String = chars(i)
		    
		    If char = fenceChar Then
		      count = count + 1
		    Else
		      Return False
		    End If
		  Next i
		  
		  Return If(count < length, False, True)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565206966205B6D43757272656E744C696E655D2C20626567696E6E696E67206174205B6D4E6578744E57535D2C20697320612066656E63656420636F6465206F70656E696E672E20506F70756C61746573205B646174615D207769746820746865202266656E63654C656E6774682220616E642022696E666F537472696E67222E
		Private Function IsCodeFenceOpening(fenceChar As String, ByRef data As Dictionary) As Boolean
		  /// Returns True if [mCurrentLine], beginning at [mNextNWS], is a fenced code opening. Populates [data]
		  /// with the "fenceLength".
		  ///
		  /// Assumes that `mCurrentChar = fenceChar` and `mCurrentLine.Characters(mNextNWS) = fenceChar` as this 
		  /// method is only called from `TryNewBlocks`.
		  /// Also assumes that [fenceChar] is either "`" or "~".
		  /// We don't capture the (optional) info string here as it gets added later as a TextBlock 
		  /// child of this block.
		  
		  data = Nil
		  Var charsLastIndex As Integer = mCurrentLine.Characters.LastIndex
		  Var chars() As String = mCurrentLine.Characters
		  
		  // The minimum length of a fence is 3 characters.
		  If mNextNWS + 2 > charsLastIndex Then Return False
		  
		  // We've found one fence character so the length is currently `1`.
		  Var fenceLength As Integer = 1
		  
		  Var lastFenceCharIndex As Integer = mNextNWS
		  For i As Integer = mNextNWS + 1 to charsLastIndex
		    Var char As String = chars(i)
		    
		    If char = fenceChar Then
		      fenceLength = fenceLength + 1
		      lastFenceCharIndex = i
		    Else
		      If fenceLength < 3 Then
		        Return False
		      Else
		        Exit
		      End If
		    End If
		  Next i
		  
		  If fenceLength < 3 Then Return False
		  
		  data = New Dictionary("fenceLength" : fenceLength, "fenceChar" : fenceChar)
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565206966205B6D43757272656E744C696E655D2C20626567696E6E696E67206174205B6D4E6578744E57535D2C2069732061207468656D6174696320627265616B2E
		Private Function IsThematicBreak() As Boolean
		  /// Returns True if [mCurrentLine], beginning at [mNextNWS], is a thematic break.
		  ///
		  /// Valid thematic break lines consist of >= 3 dashes, underscores or asterixes 
		  /// which may be optionally separated by any amount of spaces or tabs whitespace.
		  /// The characters must match.
		  ///   ^([-][ ]*){3,}[\s]*$"
		  ///   ^([_][ ]*){3,}[\s]*$"
		  ///   ^([\*][ ]*){3,}[\s]*$"
		  /// Assumes that [mNextNWS] points to a non-whitespace character in [mCurrentLine].
		  
		  Var charsLastIndex As Integer = mCurrentLine.Characters.LastIndex
		  
		  Var count As Integer = 0
		  Var i As Integer
		  Var c, tbChar As String
		  Var chars() As String = mCurrentLine.Characters
		  
		  For i = mNextNWS To charsLastIndex
		    c = chars(i)
		    If c = " " Or c = &u0009 Then
		      Continue
		    ElseIf count = 0 Then
		      Select Case c
		      Case "-", "_", "*"
		        tbChar = c
		        count = count + 1
		      Else
		        Return False
		      End Select
		    ElseIf c = tbChar Then
		      count = count + 1
		    Else
		      Return False
		    End If
		  Next i
		  
		  Return count >= 3
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 46696E64732074686520696E64657820696E205B6D4C696E65735D206F6620746865206C617374206E6F6E2D626C616E6B206C696E65206F722072657475726E73202D3120696620746865726520617265206F6E6C7920626C616E6B206C696E65732E
		Private Function LastNonBlankIndex(firstNonBlank As Integer) As Integer
		  /// Finds the index in [mLines] of the last non-blank line or returns -1 if there are only blank lines.
		  ///
		  /// [firstNonBlank] should be the index of a valid non-blank line in [mLines] (i.e. [FirstNonBlankIndex] has 
		  /// been called prior to this method).
		  
		  Var lastIndex As Integer = mLines.LastIndex
		  
		  // Edge case: There is only one non-blank line in the array.
		  If firstNonBlank = lastIndex Then Return firstNonBlank
		  
		  // Sanity check.
		  If firstNonBlank > lastIndex Then
		    Raise New OutOfBoundsException("`firstNonBlank` cannot be greater than `mLines.LastIndex`.")
		  End If
		  
		  For i As Integer = lastIndex DownTo firstNonBlank
		    If Not mLines(i).IsBlank Then
		      Return i
		    End If
		  Next i
		  
		  Return -1
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573205B6D4C696E65735D20696E746F206120626C6F636B207374727563747572652E
		Private Sub ParseBlockStructure()
		  /// Parses [mLines] into a block structure.
		  ///
		  /// This is part 1 of the parsing process. It gives us the overall structure of the Markdown document.
		  /// Assumes the parser has been reset before this method is invoked.
		  
		  // We need to process each line but blank lines at the beginning and end of the 
		  // document are ignored (0.30 4.9).
		  Var start As Integer = FirstNonBlankIndex
		  If start = -1 Then Return
		  Var finish As Integer = LastNonBlankIndex(start)
		  
		  // We always begin at the document root.
		  mCurrentBlock = mDoc
		  
		  For i As Integer = start To finish
		    ProcessLine(mLines(i))
		  Next i
		  
		  // Finalise all blocks in the tree.
		  While mCurrentBlock <> Nil
		    If mLines.LastIndex > -1 Then mCurrentBlock.Finalise(mLines(mLines.LastIndex))
		    mCurrentBlock = mCurrentBlock.Parent
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506172736573205B6C696E65735D20696E746F2061204D61726B646F776E20646F63756D656E742E
		Function ParseLines(lines() As TextLine) As MKDocument
		  /// Parses [lines] into a Markdown document.
		  
		  Reset(lines)
		  
		  ParseBlockStructure
		  
		  Return mDoc
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506172736573205B6C696E65735D20696E746F2061204D61726B646F776E20646F63756D656E742E
		Function ParseSource(markdown As String) As MKDocument
		  /// Parses [markdown] into a Markdown document.
		  
		  Var tmp() As String = markdown.ReplaceLineEndings(&u0A).Split(&u0A)
		  
		  Var lines() As TextLine
		  
		  Var iLimit As Integer = tmp.LastIndex
		  Var start As Integer = 0
		  For i As Integer = 0 To iLimit
		    Var line As New TextLine(i + 1, start, tmp(i))
		    lines.Add(line)
		    start = line.Finish + 1
		  Next i
		  
		  Return ParseLines(lines)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessLine(line As TextLine)
		  // Processes a line of Markdown and incorporates it into the document tree.
		  
		  // Reset properties related to the current line offset, whitespace locations, current line, etc to this line.
		  ResetLine(line)
		  
		  // Always start processing at the document root.
		  mContainer = mDoc
		  
		  // Match this line against each open block in the tree.
		  TryOpenBlocks
		  
		  // Store which container was the last to match.
		  mLastMatchedContainer = mContainer
		  
		  // Paragraph blocks can have lazy continuation lines.
		  mMaybeLazy = If(mCurrentBlock.Type = MKBlockTypes.Paragraph, True, False)
		  
		  // Should we create a new block?
		  TryNewBlocks
		  
		  // What remains at the offset is a text line. Add it to the appropriate container.
		  ProcessRemainderOfLine
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ProcessRemainderOfLine()
		  /// Processes what's left of the current line.
		  ///
		  /// We've tried matching against the open blocks and we've opened any required new blocks. 
		  /// What now remains at the offset is a text line. Add it to the appropriate container.
		  
		  FindNextNonWhitespace
		  
		  Var blank As Boolean = If(mCurrentChar = "", True, False)
		  
		  If blank And mContainer.LastChild <> Nil Then mContainer.LastChild.IsLastLineBlank = True
		  
		  // Blockquote lines are never blank as they start with ">"
		  // and we don't count blanks in fenced code for the purposes of tight/loose
		  // lists or breaking out of lists. We also don't set IsLastLineBlank on an empty list item.
		  mContainer.IsLastLineBlank = blank And _
		  mContainer.Type <> MKBlockTypes.BlockQuote And mContainer.Type <> MKBlockTypes.SetextHeading And _
		  mContainer.Type <> MKBlockTypes.FencedCode And _
		  Not (mContainer.Type = MKBlockTypes.ListItem And mContainer.FirstChild = Nil)
		  
		  // Flag that the last line of all the ancestors of this block are not blank.
		  Var tmpBlock As MKBlock = mContainer
		  While tmpBlock.Parent <> Nil
		    tmpBlock.Parent.IsLastLineBlank = False
		    tmpBlock = tmpBlock.Parent
		  Wend
		  
		  // If the last line processed belonged to a paragraph block,
		  // and we didn't match all of the line prefixes for the open containers,
		  // and we didn't start any new containers,
		  // and the line isn't blank,
		  // then treat this as a "lazy continuation line" and add it to the open paragraph.
		  If mCurrentBlock <> mLastMatchedContainer And _
		    mContainer = mLastMatchedContainer And _
		    Not blank And _
		    mCurrentBlock.Type = MKBlockTypes.Paragraph Then
		    mCurrentBlock.AddLine(mCurrentLine, mCurrentOffset)
		    
		  Else
		    // This is NOT a lazy continuation line.
		    // Finalise any blocks that were not matched.
		    While mCurrentBlock <> mLastMatchedContainer
		      mCurrentBlock.Finalise(mCurrentLine)
		      mCurrentBlock = mCurrentBlock.Parent
		      
		      If mCurrentBlock = Nil Then
		        Raise New MKException("Cannot finalise container block. Last matched container type = " + _ 
		        mLastMatchedContainer.Type.ToString + ".")
		      End If
		    Wend
		    
		    If mContainer.Type = MKBlockTypes.IndentedCode Then
		      mContainer.AddLine(mCurrentLine, mCurrentOffset)
		      
		    ElseIf mContainer.Type = MKBlockTypes.FencedCode Then
		      If mCurrentIndent <= 3 And mCurrentChar = MKFencedCodeBlock(mContainer).FenceChar And _
		        IsClosingCodeFence(MKFencedCodeBlock(mContainer).FenceLength) Then
		        // It's a closing fence. It will be closed when the next line is processed. 
		        MKFencedCodeBlock(mContainer).ShouldClose = True
		      Else
		        mContainer.AddLine(mCurrentLine, mCurrentOffset)
		      End If
		      
		    ElseIf mContainer.Type = MKBlockTypes.Html Then
		      #Pragma Warning "TODO: Finish processing line for HTML containers"
		      
		    ElseIf mContainer.Type = MKBlockTypes.AtxHeading Then
		      mContainer.Finalise(mCurrentLine)
		      mContainer = mContainer.Parent
		      
		    ElseIf AcceptsLines(mContainer) Then
		      mContainer.AddLine(mCurrentLine, mNextNWS)
		      
		    ElseIf mContainer.Type <> MKBlockTypes.ThematicBreak And _ 
		      mContainer.Type <> MKBlockTypes.SetextHeading And Not blank Then
		      #Pragma Warning "CHECK: Add `Not blank` above from MarkdownKit v1"
		      // Create a paragraph container for this line.
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.Paragraph, 0)
		      mContainer.AddLine(mCurrentLine, mNextNWS)
		      
		    End If
		    
		    mCurrentBlock = mContainer
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Reset(lines() As TextLine)
		  /// Resets all properties, ready to parse again.
		  
		  mLines = lines
		  mDoc = New MKDocument
		  mContainer = mDoc
		  mLastMatchedContainer = Nil
		  mCurrentBlock = Nil
		  ResetLine(Nil)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53657473205B6C696E655D20746F206265207468652063757272656E74206C696E6520666F722070726F63657373696E672E
		Private Sub ResetLine(line As TextLine)
		  /// Sets [line] to be the current line for processing, clears the line's tokens and marks it as dirty.
		  
		  mCurrentLine = line
		  mCurrentChar = ""
		  mCurrentColumn = 0
		  mCurrentIndent = 0
		  mCurrentOffset = 0
		  mNextNWS = 0
		  mNextNWSColumn = 0
		  mRemainingSpaces = 0
		  mAllMatched = True
		  mMaybeLazy = False
		  
		  If line <> Nil Then
		    mCharsLastIndex = line.Characters.LastIndex
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 547269657320746F2073746172742061206E657720636F6E7461696E657220626C6F636B2E
		Private Sub TryNewBlocks()
		  /// Tries to start a new container block.
		  
		  Var data As New Dictionary
		  
		  While mContainer.Type <> MKBlockTypes.FencedCode And mContainer.Type <> MKBlockTypes.IndentedCode And _
		    mContainer.Type <> MKBlockTypes.Html
		    
		    FindNextNonWhitespace
		    
		    Var indented As Boolean = mCurrentIndent >= CODE_INDENT
		    Var blank As Boolean = If(mCurrentChar = "", True, False)
		    
		    If Not indented And mCurrentChar = ">" Then
		      // ======================
		      // BLOCK QUOTE
		      // ======================
		      AdvanceOffset(mNextNWS + 1 - mCurrentOffset, False)
		      Var blockStartOffset As Integer = -1
		      blockStartOffset = blockStartOffset - If(AdvanceOptionalSpace, 1, 0)
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.BlockQuote, blockStartOffset)
		      
		    ElseIf Not indented And mCurrentChar = "#" And IsATXHeader(data) Then
		      // ======================
		      // ATX HEADER
		      // ======================
		      AdvanceOffset(mNextNWS + data.Value("length") - mCurrentOffset, False)
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.AtxHeading, 0)
		      mContainer.Level = data.Value("level")
		      
		    ElseIf Not indented And _
		      (mCurrentChar = "`" Or mCurrentChar = "~") And IsCodeFenceOpening(mCurrentChar, data) Then
		      // ============= New fenced code block =============
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.FencedCode, 0)
		      MKFencedCodeBlock(mContainer).FenceChar = data.Value("fenceChar")
		      MKFencedCodeBlock(mContainer).FenceLength = data.Value("fenceLength")
		      MKFencedCodeBlock(mContainer).FenceOffset = mNextNWS - mCurrentOffset
		      AdvanceOffset(mNextNWS + data.Value("fenceLength") - mCurrentOffset, False)
		      
		    ElseIf Not indented And Not (mContainer.Type = MKBlockTypes.Paragraph And Not mAllMatched) And _
		      IsThematicBreak Then
		      // ======================
		      // THEMATIC BREAK
		      // ======================
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.ThematicBreak, 0)
		      mContainer.Finalise(mCurrentLine)
		      mContainer = mContainer.Parent
		      AdvanceOffset(mCurrentLine.Characters.LastIndex + 1 - mCurrentOffset, False)
		      
		    Else
		      Exit
		    End If
		    
		    // If this is a line container then it can't contain other containers.
		    If AcceptsLines(mContainer) Then Exit
		    
		    mMaybeLazy = False
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4974657261746573207468726F756768206F70656E20626C6F636B7320616E642064657363656E64207468726F756768207468656972206C617374206368696C6472656E20646F776E20746F20746865206C617374206F70656E20626C6F636B2E
		Private Sub TryOpenBlocks()
		  /// Iterates through open blocks and descend through their last children down to the last open block. 
		  ///
		  /// For each open block, check to see if [mCurrentLine] meets the required condition to keep the block open.
		  ///
		  /// [mContainer] will be set to the Block which last had a match to the line.
		  
		  mAllMatched = True
		  
		  While mContainer.LastChild <> Nil And mContainer.LastChild.IsOpen
		    
		    mContainer = mContainer.LastChild
		    
		    FindNextNonWhitespace
		    
		    Var blank As Boolean = If(mCurrentChar = "", True, False)
		    
		    Select Case mContainer.Type
		    Case MKBlockTypes.BlockQuote
		      // ======================
		      // BLOCK QUOTE
		      // ======================
		      If mCurrentIndent <= 3 And mCurrentChar= ">" Then
		        AdvanceOffset(mCurrentIndent + 1, True)
		        Call AdvanceOptionalSpace
		      Else
		        mAllMatched = False
		      End If
		      
		    Case MKBlockTypes.AtxHeading, MKBlockTypes.SetextHeading
		      // ======================
		      // ATX / SETEXT HEADINGS
		      // ======================
		      // A heading can never contain more than one line.
		      mAllMatched = False
		      If blank Then mContainer.IsLastLineBlank = True
		      
		    Case MKBlockTypes.FencedCode
		      // ======================
		      // FENCED CODE
		      // ======================
		      If MKFencedCodeBlock(mContainer).ShouldClose Then
		        mAllMatched = False
		        If blank Then mContainer.IsLastLineBlank = True
		      Else
		        // Skip optional spaces of fence offset.
		        Var i As Integer = MKFencedCodeBlock(mContainer).FenceOffset
		        While i > 0 And mCurrentOffset <= mCurrentLine.Characters.LastIndex And _
		          mCurrentLine.Characters(mCurrentOffset) = " "
		          mCurrentOffset = mCurrentOffset + 1
		          mCurrentColumn = mCurrentColumn + 1
		          i = i - 1
		        Wend
		      End If
		      
		    Case MKBlockTypes.Paragraph
		      // ======================
		      // PARAGRAPH
		      // ======================
		      If blank Then
		        mContainer.IsLastLineBlank = True
		        mAllMatched = False
		      End If
		    End Select
		    
		    If Not mAllMatched Then
		      // Back up to the last matching block.
		      mContainer = mContainer.Parent
		      Exit
		    End If
		    
		  Wend
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mAllMatched As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41206361636865206F66205B6D43757272656E744C696E652E436861726163746572732E4C617374496E6465785D2E
		Private mCharsLastIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520626C6F636B207765206172652063757272656E746C7920636F6E7369646572696E672E
		Private mContainer As MKBlock
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520626C6F636B2063757272656E746C79206265696E67206576616C75617465642E
		Private mCurrentBlock As MKBlock
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652063757272656E742063686172616374657220776520617265206576616C756174696E672E
		Private mCurrentChar As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520302D6261736564207669727475616C20706F736974696F6E20696E20746865206C696E6520746861742074616B65732074616220657870616E73696F6E20696E746F206163636F756E742E
		Private mCurrentColumn As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652063757272656E7420696E64656E74206E756D626572206578707265737365642061732073706163657320286163636F756E747320666F72207461622073746F7073292E
		Private mCurrentIndent As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206C696E65207765206172652063757272656E746C792070726F63657373696E672E
		Private mCurrentLine As TextLine
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520302D626173656420706F736974696F6E206F66207468652063686172616374657220636F6E7369646572656420617320746865207374617274206F66207468652063757272656E74206C696E65206265696E67206576616C7561746564206F6E636520696E64656E746174696F6E20616E6420626C6F636B2073746172746572732068617665206265656E20636F6E73756D65642E
		Private mCurrentOffset As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520646F63756D656E7420746865207061727365722069732063757272656E746C7920636F6E737472756374696E672E
		Private mDoc As MKDocument
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206C617374206D61746368696E6720636F6E7461696E65722E
		Private mLastMatchedContainer As MKBlock
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41207265666572656E636520746F20746865206172726179206F662074657874206C696E6573206265696E67207061727365642E2053686F756C6420626520636F6E7369646572656420726561642D6F6E6C792E
		Private mLines() As TextLine
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54727565206966207468652063757272656E74206C696E65206D696768742062652061206C617A7920636F6E74696E756174696F6E206C696E652E
		Private mMaybeLazy As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865207A65726F2D626173656420696E646578206F6620746865206E657874206E6F6E2D776869746573706163652063686172616374657220696E20746865206C696E652C20617373756D696E67207468617420746865206C696E6520626567696E7320617420606D43757272656E744F6666736574602E
		Private mNextNWS As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520302D6261736564207669727475616C20706F736974696F6E206F6620746865206E657874206E6F6E2D7768697465737061636520636861726163746572206F6E205B6D43757272656E744C696E655D20746861742074616B65732074616220657870616E73696F6E20696E746F206163636F756E742E
		Private mNextNWSColumn As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRemainingSpaces As Integer = 0
	#tag EndProperty


	#tag Constant, Name = CODE_INDENT, Type = Double, Dynamic = False, Default = \"4", Scope = Private, Description = 546865206E756D626572206F662073706163657320726571756972656420666F72206120636F646520696E64656E746174696F6E2E
	#tag EndConstant

	#tag Constant, Name = TAB_SIZE, Type = Double, Dynamic = False, Default = \"4", Scope = Private, Description = 546865206E756D626572206F662073706163657320612074616220697320636F6E73696465726564206571756976616C656E7420746F2E
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
	#tag EndViewBehavior
End Class
#tag EndClass
