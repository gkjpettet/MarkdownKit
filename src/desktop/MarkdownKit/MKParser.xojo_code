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
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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

	#tag Method, Flags = &h21, Description = 52656D6F7665732074686520706173736564205B7061726167726170685D2066726F6D2069747320706172656E7420616E64207265706C6163657320697420776974682061206E65772053657465787448656164696E6720626C6F636B2077697468207468652073616D65206368696C6472656E2E2052657475726E73207468652053657465787448656164696E6720626C6F636B2E
		Private Function ConvertParagraphBlockToSetextHeading(ByRef paragraph As MarkdownKit.MKBlock, line As TextLine) As MKSetextHeadingBlock
		  /// Removes the passed [paragraph] from its parent and replaces it with a new SetextHeading block
		  /// with the same children. Returns the SetextHeading block.
		  
		  // Get a reference to the passed paragraph's parent.
		  Var paraParent As MKBlock = paragraph.Parent
		  
		  // Get the index of the passed paragraph in its parent's Children array.
		  Var index As Integer = paraParent.Children.IndexOf(paragraph)
		  If index = -1 Then
		    Raise New MKException("Unable to convert paragraph block to setext heading.")
		  End If
		  
		  // Create a new SetextHeading block to replace the paragraph.
		  Var stx As New MKSetextHeadingBlock(paragraph.Parent)
		  
		  // Copy the paragraph's characters
		  stx.Characters = paragraph.Characters
		  
		  stx.Start = paragraph.Start
		  
		  // Edge case:
		  // It's possible for the contents of this setext heading to be a reference link definition only.
		  // In this scenario, we need to get the definition and add it to the document's reference map (if 
		  // appropriate), add the setext heading line as content to this paragraph and raise 
		  // an EdgeCase exception.
		  stx.Finalise(line)
		  If stx.Characters.Count = 0 Then
		    paragraph.Start = line.Start
		    paragraph.AddLine(line, 0, 0)
		    #Pragma BreakOnExceptions False
		    Raise New MKEdgeCase
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
		  paragraph = Nil
		  
		  // Return the new SetextHeading.
		  Return stx
		  
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
		  Select Case type
		  Case MKBlockTypes.AtxHeading
		    child = New MKATXHeadingBlock(parent, blockStartOffset)
		    
		  Case MKBlockTypes.BlockQuote
		    child = New MKBlockQuote(parent, blockStartOffset)
		    
		  Case MKBlockTypes.List
		    child = New MKListBlock(parent, blockStartOffset)
		    
		  Case MKBlockTypes.ListItem
		    child = New MKListItemBlock(parent, blockStartOffset)
		    
		  Case MKBlockTypes.FencedCode
		    child = New MKFencedCodeBlock(parent, blockStartOffset)
		    
		  Case MKBlockTypes.Html
		    child = New MKHTMLBlock(parent, blockStartOffset)
		    
		  Case MKBlockTypes.IndentedCode
		    child = New MKIndentedCodeBlock(parent, blockStartOffset)
		    
		  Case MKBlockTypes.Paragraph
		    child = New MKParagraphBlock(parent, blockStartOffset)
		    
		  Case MKBlockTypes.SetextHeading
		    child = New MKSetextHeadingBlock(parent, blockStartOffset)
		    
		  Case MKBlockTypes.ThematicBreak
		    child = New MKThematicBreak(parent, blockStartOffset)
		    
		  Else
		    child = New MKBlock(type, parent, blockStartOffset)
		  End Select
		  
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
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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
		  /// Sets `data.Value("level")` to the header level (1 to 6).
		  /// Sets `data.Value("length")` to number of characters from the start of the opening sequence to the 
		  ///      first character of the heading content.
		  /// Sets `data.Value("closingSequenceCount")` to the number of trailing `#` characters (may be zero).
		  /// Sets `data.Value("closingSequenceStart")` to the index of the first `#` character in the closing
		  ///      sequence IF there is one, otherwise data.Value("closingSequenceCount")` is absent.
		  
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
		  
		  If data = Nil Then Return False
		  
		  // Analyse the optional closing sequence.
		  Var closingSequenceCount As Integer = 0
		  Var closingSequenceStart As Integer = -1
		  For i = mNextNWS + length To charsLastIndex
		    If chars(i) = "#" Then
		      // The closing sequence must be preceded by a space.
		      If i - 1 > 0 And chars(i - 1) = " " Then
		        closingSequenceStart = i
		        Exit
		      End If
		    End If
		  Next i
		  If closingSequenceStart > -1 Then
		    closingSequenceCount = 1
		    Var failIfSeeHashSign As Boolean = False
		    For i = closingSequenceStart + 1 To charsLastIndex
		      Select Case chars(i)
		      Case "#"
		        If failIfSeeHashSign Then
		          closingSequenceCount = 0
		          closingSequenceStart = -1
		          Exit
		        Else
		          closingSequenceCount = closingSequenceCount + 1
		        End If
		      Case &u0020, &u0009
		        failIfSeeHashSign = True
		      Else
		        closingSequenceCount = 0
		        closingSequenceStart = -1
		        Exit
		      End Select
		    Next i
		  End If
		  
		  data.Value("closingSequenceCount") = closingSequenceCount
		  data.Value("closingSequenceStart") = closingSequenceStart
		  
		  Return data <> Nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsClosingCodeFence(length As Integer) As Boolean
		  /// Returns True if mCurrentLine, beginning at `mNextNWS` is a closing fence of at least [length] characters.
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var chars() As String = mCurrentLine.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Are the enough remaining characters on the line to be a valid closing fence.
		  If mNextNWS + (length - 1) > charsLastIndex Then Return False
		  
		  Var fenceChar As String = chars(mNextNWS)
		  If fenceChar <> "`" And fenceChar <> "~" Then Return False
		  
		  Var count As Integer = 1
		  
		  Var lastFenceCharIndex As Integer = -1
		  For i As Integer = mNextNWS + 1 To charsLastIndex
		    If chars(i) = fenceChar Then
		      count = count + 1
		      lastFenceCharIndex = i
		    Else
		      If count < length Then
		        Return False
		      Else
		        Exit
		      End If
		    End If
		  Next i
		  
		  If count < length Then Return False
		  
		  // Ensure there are no other non-whitespace characters after the last seen fence character.
		  For i As Integer = lastFenceCharIndex + 1 To charsLastIndex
		    If chars(i) <> "" Then Return False
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
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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
		  
		  // If the fence character is a backtick, ensure that there are no more backticks on this line 
		  // after `lastFenceCharIndex`.
		  If fenceChar = "`" Then
		    For i As Integer = lastFenceCharIndex + 1 To charsLastIndex
		      If chars(i) = fenceChar Then Return False
		    Next i
		  End If
		  
		  If fenceLength < 3 Then Return False
		  
		  data = New Dictionary("fenceLength" : fenceLength, "fenceChar" : fenceChar)
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320547275652069662077652066696E642074686520636F727265637420656E64696E6720636F6E646974696F6E20666F7220746865207370656369666965642048544D4C20626C6F636B20747970652E
		Private Function IsCorrectHtmlBlockEnd(type As MKHTMLBlockTypes, line As TextLine, pos As Integer) As Boolean
		  /// Returns True if we find the correct ending condition for the specified HTML block type.
		  ///
		  /// There are 7 kinds of HTML blocks (CommonMark spec 0.29 4.6).
		  
		  Select Case type
		  Case MKHTMLBlockTypes.InterruptingBlockWithEmptyLines
		    Return MKHTMLBlockScanner.IsHTMLBlockType1End(line, pos)
		    
		  Case MKHTMLBlockTypes.Comment
		    Return MKHTMLBlockScanner.IsHtmlBlockType2End(line, pos)
		    
		  Case MKHTMLBlockTypes.ProcessingInstruction
		    Return MKHTMLBlockScanner.IsHtmlBlockType3End(line, pos)
		    
		  Case MKHTMLBlockTypes.Document
		    Return MKHTMLBlockScanner.IsHtmlBlockType4End(line, pos)
		    
		  Case MKHTMLBlockTypes.CData
		    Return MKHTMLBlockScanner.IsHtmlBlockType5End(line, pos)
		    
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320547275652069662074686520746865726520697320612048544D4C20626C6F636B207374617274696E67206174205B706F735D206F6E205B6D43757272656E744C696E655D2E20507574732074686520227479706522206F662048544D4C20626C6F636B20696E205B646174615D2E
		Private Function IsHtmlBlockStart(pos As Integer, ByRef data As Dictionary) As Boolean
		  /// Returns True if the there is a HTML block starting at [pos] on [mCurrentLine]. 
		  /// Puts the "type" of HTML block in [data].
		  ///
		  /// There are 7 kinds of HTML block. See the note "HTML Block Types" in this class for more detail.
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var chars() As String = mCurrentLine.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  data = New Dictionary("type" : MKHTMLBlockTypes.None)
		  
		  // The shortest opening condition is two characters.
		  If pos + 1 > charsLastIndex Then Return False
		  
		  If chars(pos) <> "<" Then Return False
		  
		  pos = pos + 1
		  Var c As String = chars(pos)
		  
		  // Type 2, 4 or 5?
		  // 2: <!--
		  // 4: <!A-Z{1}
		  // 5: <![CDATA[
		  If c = "!" Then
		    pos = pos + 1
		    If pos > charsLastIndex Then Return False
		    
		    c = chars(pos)
		    If c.IsUppercaseASCIICharacter Then
		      data.Value("type") = MKHTMLBlockTypes.Document
		      Return True
		    End If
		    
		    // `pos` is currently pointing at the character after "!".
		    If pos + 1 > charsLastIndex Then Return False
		    
		    If chars(pos) = "-" And chars(pos + 1) = "-" Then
		      data.Value("type") = MKHTMLBlockTypes.Comment
		      Return True
		    End If
		    
		    // `pos` still points at the character after "!".
		    If pos + 6 > charsLastIndex Then Return False
		    
		    If mCurrentLine.Value.MiddleCharacters(pos, 7).IsExactly("[CDATA[") Then
		      data.Value("type") = MKHTMLBlockTypes.CData
		      Return True
		    End If
		    
		    Return False
		  End If
		  
		  // Type 3?
		  If c = "?" Then
		    data.Value("type") = MKHTMLBlockTypes.ProcessingInstruction
		    Return True
		  End If
		  
		  // Type 1 or 6?
		  // 1: <(script|pre|style)([•→\n]|>)
		  // 6: <|</(HTMLTagName)([•→\n]|>|/>)
		  Var slashAtStart As Boolean = If(c = "/", True, False)
		  If slashAtStart Then
		    pos = pos + 1
		    If pos > charsLastIndex Then Return False
		    c = chars(pos)
		  End If
		  
		  // `pos` currently points to the first character of a potential tag name.
		  Var tagNameArray() As String
		  While pos <= charsLastIndex And tagNameArray.LastIndex < 10
		    c = chars(pos)
		    If c.IsASCIILetter Or (c.ToInteger >=1 And c.ToInteger <= 6) Then
		      tagNameArray.Add(c)
		    Else
		      Exit
		    End If
		    pos = pos + 1
		  Wend
		  
		  Var tagName As String = String.FromArray(tagNameArray, "")
		  If Not MarkdownKit.HTMLTagNames.HasKey(tagName) And tagName <> "pre" And tagName <> "script" And tagName <> "style" Then
		    Return False
		  End If
		  
		  Var maybeType1 As Boolean
		  maybeType1 = If(Not slashAtStart And (tagName = "script" Or tagName = "pre" Or tagName = "style"), True, False)
		  Var maybeType6 As Boolean
		  maybeType6 = If(Not maybeType1 And tagName <> "script" And tagName <> "pre" And tagName <> "style", True, False)
		  
		  // `pos` points to the character immediately following the tag name.
		  c = If (pos < charsLastIndex, chars(pos), "")
		  If maybeType1 Then
		    If c.IsMarkdownWhitespace Or c = ">" Then
		      data.Value("type") = MKHTMLBlockTypes.InterruptingBlockWithEmptyLines
		      Return True
		    Else
		      Return False
		    End If
		  ElseIf maybeType6 Then // Type 6?
		    If c.IsMarkdownWhitespace Or c = ">" Or (c = "/" And pos + 1 <= charsLastIndex And chars(pos + 1) = ">") Then
		      data.Value("type") = MKHTMLBlockTypes.InterruptingBlock
		      Return True
		    Else
		      Return False
		    End If
		  End If
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565206966205B6D43757272656E744C696E655D2066726F6D205B706F735D2069732061207479706520372048544D4C20626C6F636B2073746172742E2053657473205B646174612E56616C756528227479706522295D20746F206E6F6E65206F722074797065203720656E756D65726174696F6E2E
		Private Function IsHtmlBlockType7Start(pos As Integer, ByRef data As Dictionary) As Boolean
		  /// Returns True if [mCurrentLine] from [pos] is a type 7 HTML block start. Sets [data.Value("type")] to 
		  /// none or type 7 enumeration.
		  ///
		  /// Type 7: {openTag NOT script|style|pre}[•→]+|⮐$   or
		  ///         {closingTag}[•→]+|⮐$
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  data = New Dictionary("type" : MKHTMLBlockTypes.None)
		  
		  Var chars() As String = mCurrentLine.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // At least 3 characters are required for a valid type 7 block start.
		  If pos + 2 > charsLastIndex Then Return False
		  
		  If chars(pos) <> "<" Then Return False
		  
		  Var tagName As String // Will be mutated.
		  If chars(pos + 1) = "/" Then
		    pos = MKHTMLBlockScanner.FindClosingTag(mCurrentLine, pos + 2, tagName)
		  Else
		    pos = MKHTMLBlockScanner.FindOpenTag(mCurrentLine, pos + 1, tagName)
		    If tagName = "script" Or tagName = "style" Or tagName = "pre" Then Return False
		  End If
		  If pos = 0 Then Return False
		  
		  While pos <= charsLastIndex
		    If Not chars(pos).IsMarkdownWhitespace Then Return False
		    pos = pos + 1
		  Wend
		  
		  data.Value("type") = MKHTMLBlockTypes.NonInterruptingBlock
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565206966205B6D43757272656E744C696E655D2C20626567696E6E696E67206174205B6D4E6578744E57535D2069732061207365746578742068656164696E67206C696E652E2053657473205B646174612E56616C756528226C6576656C22295D
		Private Function IsSetextHeadingLine(ByRef data As Dictionary) As Boolean
		  /// Returns True if [mCurrentLine], beginning at [mNextNWS] is a setext heading line.
		  /// Sets [data.Value("level")]
		  ///
		  /// Sets [data.Value("level")] to the heading level (1 or 2) or 0 if this is not a setext heading line.
		  ///   ^[=]+[ ]*$
		  ///   ^[-]+[ ]*$
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  data = New Dictionary("level" : 0)
		  
		  Var chars() As String = mCurrentLine.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Sanity check.
		  If mNextNWS > charsLastIndex Then Return False
		  
		  // Determine the setext heading character.
		  Var stxChar As String = chars(mNextNWS)
		  If stxChar <> "=" And stxChar <> "-" Then Return False
		  
		  If mNextNWS + 1 > charsLastIndex Then
		    data.Value("level") = If(stxChar = "=", 1, 2)
		    Return True
		  End If
		  
		  // Trailing whitespace after the heading line is allowed, internal whitespace is not.
		  Var seenWhitespace As Boolean = False
		  Var c As String
		  For i As Integer = mNextNWS + 1 To charsLastIndex
		    c = chars(i)
		    If c = stxChar Then
		      If seenWhitespace Then
		        data.Value("level") = 0
		        Return False
		      Else
		        Continue
		      End If
		    ElseIf c = " " Or c = &u0009 Then
		      seenWhitespace = True
		      Continue
		    Else
		      // Not a "=", "-" character or whitespace.
		      data.Value("level") = 0
		      Return False
		    End If
		  Next i
		  
		  data.Value("level") = If(c = "=", 1, 2)
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565206966205B6C696E655D207374617274696E67206174205B706F735D2069732061207468656D6174696320627265616B2E
		Private Function IsThematicBreak(chars() As String, pos As Integer) As Boolean
		  /// Returns True if [line] starting at [pos] is a thematic break.
		  ///
		  /// Valid thematic break lines consist of >= 3 dashes, underscores or asterixes 
		  /// which may be optionally separated by any amount of spaces or tabs whitespace.
		  /// The characters must match:
		  ///   ^([-][ ]*){3,}[\s]*$"
		  ///   ^([_][ ]*){3,}[\s]*$"
		  ///   ^([\*][ ]*){3,}[\s]*$"
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  Var count As Integer = 0
		  Var i As Integer
		  Var c, tbChar As String
		  
		  For i = pos To charsLastIndex
		    c = chars(i)
		    
		    If c = " " Or c = &u0009 Then Continue
		    
		    If count = 0 Then
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
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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

	#tag Method, Flags = &h21, Description = 4D6174636865732077686974657370616365206F6E205B6C696E655D20626567696E6E696E67206174205B706F735D20616E642072657475726E7320686F77206D616E7920636861726163746572732077657265206D6174636865642E
		Private Function MatchWhitespaceCharacters(line As TextLine, pos As Integer) As Integer
		  /// Matches whitespace on [line] beginning at [pos] and returns how many characters were matched.
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var charsLastIndex As Integer = line.Characters.LastIndex
		  
		  // Sanity check.
		  If pos > charsLastIndex Then Return 0
		  
		  For i As Integer = pos To charsLastIndex
		    If Not line.Characters(i).IsMarkdownWhitespace Then Return i - pos
		  Next i
		  
		  Return (charsLastIndex + 1)- pos
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506172736573205B6D4C696E65735D20696E746F206120626C6F636B207374727563747572652E
		Private Sub ParseBlockStructure()
		  /// Parses [mLines] into a block structure.
		  ///
		  /// This is part 1 of the parsing process. It gives us the overall structure of the Markdown document.
		  /// Assumes the parser has been reset before this method is invoked.
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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

	#tag Method, Flags = &h21, Description = 57616C6B732074686520646F63756D656E742070617273696E6720696E6C696E6520636F6E74656E742E
		Private Sub ParseInlines()
		  /// Walks the document parsing inline content.
		  ///
		  /// Assumes that `ParseBlockStructure` was called immediately prior to this method.
		  
		  Var stack() As MKBlock
		  Var block As MKBlock = mDoc
		  Var delimiterStack() As MKDelimiterStackNode
		  
		  While block <> Nil
		    Select Case block.Type
		    Case MKBlockTypes.AtxHeading, MKBlockTypes.Paragraph, MKBlockTypes.SetextHeading
		      MKInlineScanner.ParseInlines(block, delimiterStack)
		    End Select
		    
		    If block.FirstChild <> Nil Then
		      If block.NextSibling <> Nil Then stack.Add(block.NextSibling)
		      block = block.FirstChild
		      
		    ElseIf block.NextSibling <> Nil Then
		      block = block.NextSibling
		      
		    ElseIf stack.LastIndex > -1 Then
		      block = stack.Pop
		      
		    Else
		      block = Nil
		    End If
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506172736573205B6C696E65735D20696E746F2061204D61726B646F776E20646F63756D656E742E
		Function ParseLines(lines() As TextLine) As MKDocument
		  /// Parses [lines] into a Markdown document.
		  
		  Reset(lines)
		  
		  ParseBlockStructure
		  
		  ParseInlines
		  
		  Return mDoc
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320547275652069662061626C6520746F2070617273652061204C6973744974656D206D61726B65722C20706F70756C6174696E67205B646174615D2077697468207468652064657461696C732E
		Private Function ParseListMarker(indented As Boolean, line As TextLine, pos As Integer, interruptsParagraph As Boolean, ByRef data As MarkdownKit.MKListData) As Boolean
		  /// Returns True if able to parse a ListItem marker, populating [data] with the details.
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var chars() As String = line.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  Var c As String
		  Var startPos As Integer = pos
		  data = Nil
		  Var length As Integer = 0
		  
		  // Sanity check.
		  If pos > charsLastIndex Then Return False
		  
		  // List items may not be indented more than 3 spaces.
		  if indented Then Return False
		  
		  // Check the character.
		  c = chars(pos)
		  If c = "+" Or c = "•" Or ((c = "*" Or c = "-") And Not IsThematicBreak(chars, pos)) Then
		    pos = pos + 1
		    
		    If pos <= charsLastIndex And Not chars(pos).IsMarkdownWhitespace Then Return False
		    
		    If interruptsParagraph And MatchWhitespaceCharacters(line, pos + 1) = (charsLastIndex + 1) - pos Then 
		      Return False
		    End If
		    
		    data = New MKListData
		    data.BulletCharacter = c
		    data.StartNumber = 1
		    data.ListMarkerLocalPosition = pos - 1
		    data.ListMarkerAbsolutionPosition = line.Start + data.ListMarkerLocalPosition
		    
		  ElseIf c.IsDigit Then
		    Var markerStartPos As Integer = pos
		    Var numDigits As Integer = 0
		    Var startText As String // To store the start value for ordered lists.
		    Var limit As Integer = Min(charsLastIndex, startPos + 8)
		    For i As Integer = startPos To limit
		      If chars(i).IsDigit Then
		        If numDigits = 9 Then Return False // Avoids integer overflows in some browsers.
		        numDigits = numDigits + 1
		        startText = startText + chars(i)
		      Else
		        Exit
		      End If
		    Next i
		    
		    Var start As Integer = startText.ToInteger
		    pos = pos + numDigits
		    // pos now points to the character after the last digit.
		    If pos > charsLastIndex Then Return False
		    
		    // Need to find a period or parenthesis.
		    c = chars(pos)
		    If c <> "." And c <> ")" Then Return False
		    pos = pos + 1
		    
		    // The next character must be whitespace (unless this is the EOL).
		    If pos <= charsLastIndex And Not chars(pos).IsMarkdownWhitespace Then Return False
		    
		    If interruptsParagraph And _
		      (start <> 1 Or _
		      MatchWhitespaceCharacters(line, pos + 1) = (charsLastIndex + 1) - pos) Then
		      Return False
		    End If
		    
		    data = New MKListData
		    data.ListType = MKListTypes.Ordered
		    data.BulletCharacter = ""
		    data.ListMarkerAbsolutionPosition = line.Start + markerStartPos
		    data.StartNumber = start
		    data.ListMarkerLocalPosition = markerStartPos
		    data.ListDelimiter = If(c = ".", MKListDelimiters.Period, MKListDelimiters.Parenthesis)
		  Else
		    Return False
		  End If
		  
		  length = pos - startPos
		  If length = 0 Then
		    data = Nil
		    Return False
		  Else
		    data.Length = length
		    Return True
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506172736573205B6C696E65735D20696E746F2061204D61726B646F776E20646F63756D656E742E
		Function ParseSource(markdown As String) As MKDocument
		  /// Parses [markdown] into a Markdown document.
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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
		    mCurrentBlock.AddLine(mCurrentLine, mCurrentOffset, mRemainingSpaces)
		    
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
		      mContainer.AddLine(mCurrentLine, mCurrentOffset, mRemainingSpaces)
		      
		    ElseIf mContainer.Type = MKBlockTypes.FencedCode Then
		      If mCurrentIndent <= 3 And mCurrentChar = MKFencedCodeBlock(mContainer).FenceChar And _
		        IsClosingCodeFence(MKFencedCodeBlock(mContainer).FenceLength) Then
		        // It's a closing fence. It will be closed when the next line is processed. 
		        MKFencedCodeBlock(mContainer).ShouldClose = True
		        MKFencedCodeBlock(mContainer).ClosingFenceStart = mCurrentLine.Start + mNextNWS
		        MKFencedCodeBlock(mContainer).ClosingFenceLocalStart = mNextNWS
		        MKFencedCodeBlock(mContainer).ClosingFenceLineNumber = mCurrentLine.Number
		      Else
		        mContainer.AddLine(mCurrentLine, mCurrentOffset, mRemainingSpaces)
		      End If
		      
		    ElseIf mContainer.Type = MKBlockTypes.Html Then
		      mContainer.AddLine(mCurrentLine, mCurrentOffset, mRemainingSpaces)
		      If IsCorrectHtmlBlockEnd(MKHTMLBlock(mContainer).HtmlBlockType, mCurrentLine, mNextNWS) Then
		        mContainer.Finalise(mCurrentLine)
		        mContainer = mContainer.Parent
		      End If
		      
		    ElseIf mContainer.Type = MKBlockTypes.AtxHeading Then
		      mContainer.Finalise(mCurrentLine)
		      mContainer = mContainer.Parent
		      
		    ElseIf AcceptsLines(mContainer) Then
		      mContainer.AddLine(mCurrentLine, mNextNWS, mRemainingSpaces)
		      
		    ElseIf mContainer.Type <> MKBlockTypes.ThematicBreak And _ 
		      mContainer.Type <> MKBlockTypes.SetextHeading And Not blank Then
		      // Create a paragraph container for this line.
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.Paragraph, 0)
		      mContainer.AddLine(mCurrentLine, mNextNWS, mRemainingSpaces)
		      
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
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var data As New Dictionary
		  Var listData As MKListData
		  
		  While mContainer.Type <> MKBlockTypes.FencedCode And mContainer.Type <> MKBlockTypes.IndentedCode And _
		    mContainer.Type <> MKBlockTypes.Html
		    
		    FindNextNonWhitespace
		    
		    Var indented As Boolean = mCurrentIndent >= CODE_INDENT
		    Var blank As Boolean = If(mCurrentChar = "", True, False)
		    
		    If Not indented And mCurrentChar = ">" Then
		      // ======================
		      // BLOCK QUOTE
		      // ======================
		      Var blockQuoteChar As New MKCharacter(">", mCurrentLine, mNextNWS)
		      AdvanceOffset(mNextNWS + 1 - mCurrentOffset, False)
		      Var blockStartOffset As Integer = -1
		      blockStartOffset = blockStartOffset - If(AdvanceOptionalSpace, 1, 0)
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.BlockQuote, blockStartOffset)
		      MKBlockQuote(mContainer).AbsoluteOpenerStart = mCurrentLine.Start + mNextNWS
		      MKBlockQuote(mContainer).LocalOpenerStart = mNextNWS
		      MKBlockQuote(mContainer).OpeningDelimiters.Add(blockQuoteChar)
		      
		    ElseIf Not indented And mCurrentChar = "#" And IsATXHeader(data) Then
		      // ======================
		      // ATX HEADER
		      // ======================
		      AdvanceOffset(mNextNWS + data.Value("length") - mCurrentOffset, False)
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.AtxHeading, -data.Value("length"))
		      MKATXHeadingBlock(mContainer).OpeningSequenceLocalStart = mNextNWS
		      MKATXHeadingBlock(mContainer).OpeningSequenceAbsoluteStart = mCurrentLine.Start + mNextNWS
		      MKATXHeadingBlock(mContainer).Level = data.Value("level")
		      MKATXHeadingBlock(mContainer).OpeningSequenceLength = data.Value("length")
		      MKATXHeadingBlock(mContainer).ClosingSequenceCount = data.Value("closingSequenceCount")
		      If data.Value("closingSequenceStart") > -1 Then
		        MKATXHeadingBlock(mContainer).ClosingSequenceAbsoluteStart = _
		        data.Value("closingSequenceStart") + mCurrentLine.Start
		        MKATXHeadingBlock(mContainer).ClosingSequenceLocalStart = data.Value("closingSequenceStart")
		      Else
		        MKATXHeadingBlock(mContainer).ClosingSequenceAbsoluteStart = -1
		        MKATXHeadingBlock(mContainer).ClosingSequenceLocalStart = -1
		      End If
		      
		    ElseIf Not indented And _
		      (mCurrentChar = "`" Or mCurrentChar = "~") And IsCodeFenceOpening(mCurrentChar, data) Then
		      // ======================
		      // FENCED CODE BLOCK
		      // ======================
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.FencedCode, 0)
		      MKFencedCodeBlock(mContainer).OpeningFenceLocalStart = mNextNWS
		      MKFencedCodeBlock(mContainer).FenceChar = data.Value("fenceChar")
		      MKFencedCodeBlock(mContainer).FenceLength = data.Value("fenceLength")
		      MKFencedCodeBlock(mContainer).FenceOffset = mNextNWS - mCurrentOffset
		      AdvanceOffset(mNextNWS + data.Value("fenceLength") - mCurrentOffset, False)
		      
		    ElseIf Not indented And mCurrentChar = "<" And _
		      (IsHtmlBlockStart(mNextNWS, data) _
		      Or (mContainer.Type <> MKBlockTypes.Paragraph And IsHtmlBlockType7Start(mNextNWS, data))) Then
		      // ======================
		      // HTML BLOCK
		      // ======================
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.HTML, 0)
		      MKHTMLBlock(mContainer).HtmlBlockType = data.Value("type")
		      // NB: We don't adjust `mCurrentOffset` because the tag is part of the text.
		      
		    ElseIf Not indented And mContainer.Type = MKBlockTypes.Paragraph And _
		      (mCurrentChar = "=" Or mCurrentChar = "-") And IsSetextHeadingLine(data) Then
		      // ======================
		      // SETEXT HEADING
		      // ======================
		      Try
		        mContainer = ConvertParagraphBlockToSetextHeading(mContainer, mCurrentLine)
		        MKSetextHeadingBlock(mContainer).Level = data.Value("level")
		        // Store the start and length of the setext underlining on this block.
		        MKSetextHeadingBlock(mContainer).UnderlineStart = mCurrentLine.Start + mCurrentOffset
		        MKSetextHeadingBlock(mContainer).UnderlineLength = mCurrentLine.Length - mCurrentOffset
		        MKSetextHeadingBlock(mContainer).UnderlineLocalStart = mNextNWS
		        MKSetextHeadingBlock(mContainer).UnderlineLineNumber = mCurrentLine.Number
		        
		      Catch e As MKEdgeCase
		        // Happens when the entire contents of the setext heading is a reference link definition. 
		        // In this scenario, `mContainer` remains a paragraph with the setext heading line having been 
		        // added to the paragraph's contents.
		      End Try
		      AdvanceOffset(mCurrentLine.Characters.LastIndex + 1 - mCurrentOffset, False)
		      
		    ElseIf Not indented And Not (mContainer.Type = MKBlockTypes.Paragraph And Not mAllMatched) And _
		      IsThematicBreak(mCurrentLine.Characters, mNextNWS) Then
		      // ======================
		      // THEMATIC BREAK
		      // ======================
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.ThematicBreak, 0)
		      MKThematicBreak(mContainer).LocalStart = mNextNWS
		      mContainer.Finalise(mCurrentLine)
		      AdvanceOffset(mCurrentLine.Characters.LastIndex + 1 - mCurrentOffset, False)
		      MKThematicBreak(mContainer).Length = mCurrentOffset - MKThematicBreak(mContainer).LocalStart
		      mContainer = mContainer.Parent
		      
		    ElseIf (Not indented Or mContainer.Type = MKBlockTypes.List) And _
		      ParseListMarker(indented, mCurrentLine, mNextNWS, _
		      mContainer.Type = MKBlockTypes.Paragraph, listData) Then
		      // ======================
		      // LIST / LIST ITEM
		      // ======================
		      // Compute padding.
		      AdvanceOffset(mNextNWS + listData.Length - mCurrentOffset, False)
		      
		      Var prevOffset As Integer = mCurrentOffset
		      Var prevColumn As Integer = mCurrentColumn
		      Var prevRemainingSpaces As Integer = mRemainingSpaces
		      
		      While mCurrentColumn - prevColumn <= CODE_INDENT
		        If Not AdvanceOptionalSpace Then Exit
		      Wend
		      
		      If mCurrentColumn = prevColumn Then
		        // No spaces at all.
		        listData.MarkerWidth = listData.Length + 1
		      ElseIf mCurrentColumn - prevColumn > CODE_INDENT Or mCurrentChar = "" Then
		        listData.MarkerWidth = listData.Length + 1
		        // Too many (or no) spaces, ignoring everything but the first one.
		        mCurrentOffset = prevOffset
		        mCurrentColumn = prevColumn
		        mRemainingSpaces = prevRemainingSpaces
		        Call AdvanceOptionalSpace
		      Else
		        listData.MarkerWidth = listData.Length + mCurrentColumn - prevColumn
		      End If
		      
		      // Check the container. If it's a list, see if this list item can continue the list. 
		      // Otherwise, create a list container.
		      listData.MarkerOffset = mCurrentIndent
		      If mContainer.Type <> MKBlockTypes.List Or MKListBlock(mContainer).ListData <> listData Then
		        mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.List, 0)
		        MKListBlock(mContainer).ListData = listData
		      End If
		      
		      // Add the list item.
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.ListItem, -listData.MarkerWidth)
		      MKAbstractList(mContainer).ListData = listData
		      
		    ElseIf indented And Not mMaybeLazy And Not blank Then
		      // ======================
		      // INDENTED CODE BLOCK
		      // ======================
		      AdvanceOffset(CODE_INDENT, True)
		      mContainer = CreateChildBlock(mContainer, mCurrentLine, MKBlockTypes.IndentedCode, 0)
		      
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
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
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
		        MKBlockQuote(mContainer).OpeningDelimiters.Add(New MKCharacter(">", mCurrentLine, mNextNWS))
		        AdvanceOffset(mCurrentIndent + 1, True)
		        Call AdvanceOptionalSpace
		      Else
		        mAllMatched = False
		      End If
		      
		    Case MKBlockTypes.ListItem
		      // ======================
		      // LIST ITEM
		      // ======================
		      If mCurrentIndent >= MKListItemBlock(mContainer).ListData.MarkerOffset + _
		        MKListItemBlock(mContainer).ListData.MarkerWidth Then
		        AdvanceOffset(MKListItemBlock(mContainer).ListData.MarkerOffset + _
		        MKListItemBlock(mContainer).ListData.MarkerWidth, True)
		      ElseIf blank And mContainer.FirstChild <> Nil Then
		        // If container.FirstChild is Nil, then the opening line of the list item was blank after 
		        // the list marker. In this case we're done with the list item.
		        AdvanceOffset(mNextNWS - mCurrentOffset, False)
		      Else
		        mAllMatched = False
		      End If
		      
		    Case MKBlockTypes.IndentedCode
		      // ======================
		      // INDENTED CODE
		      // ======================
		      If mCurrentIndent >= CODE_INDENT Then
		        AdvanceOffset(CODE_INDENT, True)
		      ElseIf blank Then
		        AdvanceOffset(mNextNWS - mCurrentOffset, False)
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
		      
		    Case MKBlockTypes.Html
		      // ======================
		      // HTML BLOCK
		      // ======================
		      If blank And MKHTMLBlock(mContainer).IsType6Or7 Then
		        // All other block types can accept blanks.
		        mContainer.IsLastLineBlank = True
		        mAllMatched = False
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


	#tag Note, Name = HTML Block Types
		Type 1: MKHTMLBlockTypes.InterruptingBlockWithEmptyLines
		Start condition: line begins with the string <script, <pre, or <style (case-insensitive), followed by whitespace, the string >, or the end of the line.
		End condition: line contains an end tag </script>, </pre>, or </style> (case-insensitive; it need not match the start tag).
		
		Type 2: MKHTMLBlockTypesComment
		Start condition: line begins with the string <!--.
		End condition: line contains the string -->.
		
		Type 3: MKHTMLBlockTypes.ProcessingInstruction
		Start condition: line begins with the string <?.
		End condition: line contains the string ?>.
		
		Type 4: MKHTMLBlocks.TypeDocumentType
		Start condition: line begins with the string <! followed by an uppercase ASCII letter.
		End condition: line contains the character >.
		
		Type 5: MKHTMLBlockTypes.CData
		Start condition: line begins with the string <![CDATA[.
		End condition: line contains the string ]]>.
		
		Type 6: MKHTMLBlockTypes.InterruptingBlock
		Start condition: line begins the string < or </ followed by one of the strings (case-insensitive) address, article, aside, base, basefont, blockquote, body, caption, center, col, colgroup, dd, details, dialog, dir, div, dl, dt, fieldset, figcaption, figure, footer, form, frame, frameset, h1, h2, h3, h4, h5, h6, head, header, hr, html, iframe, legend, li, link, main, menu, menuitem, nav, noframes, ol, optgroup, option, p, param, section, source, summary, table, tbody, td, tfoot, th, thead, title, tr, track, ul, followed by whitespace, the end of the line, the string >, or the string />.
		End condition: line is followed by a blank line.
		
		Type 7: MKHTMLBlockTypes.NonInterruptingBlock
		Start condition: line begins with a complete open tag (with any tag name other than script, style, or pre) or a complete closing tag, followed only by whitespace or the end of the line.
		End condition: line is followed by a blank line.
		
	#tag EndNote


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
