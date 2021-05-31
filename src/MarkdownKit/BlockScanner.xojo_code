#tag Class
Protected Class BlockScanner
	#tag Method, Flags = &h0
		Shared Sub FinaliseLinkReferenceDefinition(ByRef chars() As String, doc As MarkdownKit.Document, labelCR As MarkdownKit.CharacterRun, destinationCR As MarkdownKit.CharacterRun, titleCR As MarkdownKit.CharacterRun = Nil)
		  // Called by the ScanLinkReferenceDefinition method. 
		  // Handles the addition of this reference definition to the document's reference 
		  // map (if appropriate) and removing the definition from the raw characters 
		  // of this paragraph block.
		  
		  // ##### LABEL #####
		  Dim labelChars() As String = labelCR.ToArray(chars)
		  InlineScanner.CleanLinkLabel(labelChars)
		  Dim label As String = String.FromArray(labelChars, "")
		  
		  // ##### DESTINATION #####
		  Dim urlChars() As String = destinationCR.ToArray(chars)
		  InlineScanner.CleanURL(urlChars)
		  // Dim url As String = String.FromArray(urlChars, "")
		  Dim url As String = Utilities.ReplaceEntities(String.FromArray(urlChars, ""))
		  
		  // ##### TITLE #####
		  Dim title As String = ""
		  If titleCR <> Nil Then
		    Dim titleChars() As String = titleCR.ToArray(chars)
		    InlineScanner.CleanLinkTitle(titleChars)
		    title = Utilities.ReplaceEntities(String.FromArray(titleChars, ""))
		  End If
		  
		  // Only add this reference to the document if it's the first time we've encountered 
		  // a reference with this normalised name.
		  If Not doc.ReferenceMap.HasKey(label.Lowercase) Then
		    // This is the first reference with this label that we've encountered. Add it.
		    doc.AddLinkReferenceDefinition(label, url, title)
		  End If
		  
		  // Remove the entire reference definition from the original character array.
		  Dim refLength As Integer = If(titleCR <> Nil And titleCR.Finish <> -1, titleCR.Finish + 1, destinationCR.Finish + 1)
		  chars.RemoveLeft(refLength)
		  StripLeadingWhitespace(chars)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub Initialise()
		  If mInitialised Then Return
		  
		  InitialiseBlockScannerHTMLTagNames
		  
		  mInitialised = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitialiseBlockScannerHTMLTagNames()
		  // Initialise the lookup dictionary for HTML tag names.
		  
		  mHTMLTagNames = New Xojo.Core.Dictionary
		  
		  mHTMLTagNames.Value("ADDRESS") = 0
		  mHTMLTagNames.Value("ARTICLE") = 0
		  mHTMLTagNames.Value("ASIDE") = 0
		  mHTMLTagNames.Value("BASE") = 0
		  mHTMLTagNames.Value("BASEFONT") = 0
		  mHTMLTagNames.Value("BLOCKQUOTE") = 0
		  mHTMLTagNames.Value("BODY") = 0
		  mHTMLTagNames.Value("CAPTION") = 0
		  mHTMLTagNames.Value("CENTER") = 0
		  mHTMLTagNames.Value("COL") = 0
		  mHTMLTagNames.Value("COLGROUP") = 0
		  mHTMLTagNames.Value("DD") = 0
		  mHTMLTagNames.Value("DETAILS") = 0
		  mHTMLTagNames.Value("DIALOG") = 0
		  mHTMLTagNames.Value("DIR") = 0
		  mHTMLTagNames.Value("DIV") = 0
		  mHTMLTagNames.Value("DL") = 0
		  mHTMLTagNames.Value("DT") = 0
		  mHTMLTagNames.Value("FIELDSET") = 0
		  mHTMLTagNames.Value("FIGCAPTION") = 0
		  mHTMLTagNames.Value("FIGURE") = 0
		  mHTMLTagNames.Value("FOOTER") = 0
		  mHTMLTagNames.Value("FORM") = 0
		  mHTMLTagNames.Value("FRAME") = 0
		  mHTMLTagNames.Value("FRAMESET") = 0
		  mHTMLTagNames.Value("H1") = 0
		  mHTMLTagNames.Value("H2") = 0
		  mHTMLTagNames.Value("H3") = 0
		  mHTMLTagNames.Value("H4") = 0
		  mHTMLTagNames.Value("H5") = 0
		  mHTMLTagNames.Value("H6") = 0
		  mHTMLTagNames.Value("HEAD") = 0
		  mHTMLTagNames.Value("HEADER") = 0
		  mHTMLTagNames.Value("HR") = 0
		  mHTMLTagNames.Value("HTML") = 0
		  mHTMLTagNames.Value("IFRAME") = 0
		  mHTMLTagNames.Value("LEGEND") = 0
		  mHTMLTagNames.Value("LI") = 0
		  mHTMLTagNames.Value("LINK") = 0
		  mHTMLTagNames.Value("MAIN") = 0
		  mHTMLTagNames.Value("MENU") = 0
		  mHTMLTagNames.Value("MENUITEM") = 0
		  mHTMLTagNames.Value("NAV") = 0
		  mHTMLTagNames.Value("NOFRAMES") = 0
		  mHTMLTagNames.Value("OL") = 0
		  mHTMLTagNames.Value("OPTGROUP") = 0
		  mHTMLTagNames.Value("OPTION") = 0
		  mHTMLTagNames.Value("P") = 0
		  mHTMLTagNames.Value("PARAM") = 0
		  mHTMLTagNames.Value("SECTION") = 0
		  mHTMLTagNames.Value("SOURCE") = 0
		  mHTMLTagNames.Value("SUMMARY") = 0
		  mHTMLTagNames.Value("TABLE") = 0
		  mHTMLTagNames.Value("TBODY") = 0
		  mHTMLTagNames.Value("TD") = 0
		  mHTMLTagNames.Value("TFOOT") = 0
		  mHTMLTagNames.Value("TH") = 0
		  mHTMLTagNames.Value("THEAD") = 0
		  mHTMLTagNames.Value("TITLE") = 0
		  mHTMLTagNames.Value("TR") = 0
		  mHTMLTagNames.Value("TRACK") = 0
		  mHTMLTagNames.Value("UL") = 0
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ParseListMarker(indented As Boolean, chars() As String, pos As Integer, interruptsParagraph As Boolean, ByRef data As MarkdownKit.ListData, ByRef length As Integer) As Integer
		  // Attempts to parse a ListItem marker (bullet or enumerated).
		  // On success, it returns the length of the marker, and populates
		  // data with the details.  On failure it returns 0.
		  // Also populates the ByRef `length` parameter to the computed length.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim c As String
		  Dim startPos As Integer
		  data = Nil
		  length = 0
		  
		  Dim charsUbound As Integer = chars.LastIndex
		  
		  If pos > charsUbound Then Return 0
		  
		  // List items may not be indented more than 3 spaces.
		  if indented Then Return 0
		  
		  startPos = pos
		  c = chars(pos)
		  
		  If c = "+" Or c = "•" Or ((c = "*" Or c = "-") And _
		    0 = BlockScanner.ScanThematicBreak(chars, pos)) Then
		    pos = pos + 1
		    
		    If pos <= charsUbound And Not Utilities.IsWhitespace(chars(pos)) Then Return 0
		    
		    If interruptsParagraph And _
		    BlockScanner.ScanSpaceChars(chars, pos + 1) = (charsUbound + 1) - pos Then Return 0
		    
		    data = New MarkdownKit.ListData
		    data.BulletChar = c
		    data.Start = 1
		    
		  ElseIf c = "0" Or c = "1" Or c = "2" Or c = "3" Or c = "4" Or c = "5" Or _
		    c = "6" Or c = "7" Or c = "8" Or c = "9" Then
		    Dim numDigits As Integer = 0
		    Dim startText As String
		    Dim limit As Integer = Min(chars.LastIndex, startPos + 8)
		    For i As Integer = startPos To limit
		      c = chars(i)
		      Select Case c
		      Case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
		        // Max 9 digits to avoid integer overflows in some browsers.
		        If numDigits = 9 Then Return 0
		        numDigits = numDigits + 1
		        startText = startText + c
		      Else
		        Exit
		      End Select
		    Next i
		    Dim start As Integer = Val(startText)
		    pos = pos + numDigits
		    // pos now points to the character after the last digit.
		    If pos > charsUbound Then Return 0
		    
		    // Need to find a period or parenthesis.
		    c = chars(pos)
		    If c <> "." And c <> ")" Then Return 0
		    pos = pos + 1
		    
		    // The next character must be whitespace (unless this is the EOL).
		    If pos <= charsUbound And Not Utilities.IsWhitespace(chars(pos)) Then Return 0
		    
		    If interruptsParagraph And _
		      (start <> 1 Or _
		      BlockScanner.ScanSpaceChars(chars, pos + 1) = (charsUbound + 1) - pos) Then
		      Return 0
		    End If
		    
		    data = New MarkdownKit.ListData
		    data.ListType = MarkdownKit.ListType.Ordered
		    data.BulletChar = ""
		    data.Start = start
		    data.ListDelimiter = If(c = ".", _
		    MarkdownKit.ListDelimiter.Period, MarkdownKit.ListDelimiter.Parenthesis)
		  Else
		    Return 0
		    
		  End If
		  
		  length = pos - startPos
		  Return pos - startPos
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanATXHeadingStart(chars() As String, pos As Integer, ByRef headingLevel As Integer, ByRef length As Integer) As Integer
		  // Checks to see if there is a valid ATX heading start.
		  // We are passed the characters of the line as an array and the position we 
		  // should consider to be the first character. 
		  // The method assumes that leading spaces have been skipped over during 
		  // calculation of `pos` so the first character should be a #.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim charsUbound As Integer = chars.LastIndex
		  
		  // Reset the ByRef variables.
		  length = 0
		  headingLevel = 0
		  
		  // Sanity check.
		  If pos > charsUbound Then Return 0
		  If chars(pos) <> "#" Then Return 0
		  
		  // An ATX heading consists of a string of characters, starting with an 
		  // opening sequence of 1–6 unescaped # characters.
		  Dim i As Integer
		  For i = pos To charsUbound
		    If chars(i) = "#" Then
		      headingLevel = headingLevel + 1
		      If headingLevel > 6 Then Return 0
		    Else
		      Exit
		    End If
		  Next i
		  If headingLevel = 0 Then Return 0
		  
		  // The opening sequence of #s must be followed by a space, a tab or the EOL.
		  If (pos + headingLevel) > charsUbound Then
		    length = headingLevel
		    Return length
		  ElseIf chars(pos + headingLevel) = " " Or chars(pos + headingLevel) = &u0009 Then
		    // This is a valid opening sequence. Keep consuming whitespace to determine 
		    // the full length of the opening sequence.
		    length = headingLevel
		    For i = pos + headingLevel To charsUbound
		      Select Case chars(i)
		      Case " ", &u0009
		        length = length + 1
		      Else
		        Exit
		      End Select
		    Next i
		    Return length
		  Else
		    Return 0
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanCloseCodeFence(chars() As String, pos As Integer, length As Integer) As Integer
		  // Scan for a closing fence of at least length `length`.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim charsUbound As Integer = chars.LastIndex
		  
		  If pos + (length - 1) > charsUbound Then Return 0
		  
		  Dim c1 As String = chars(pos)
		  If c1 <> "`" And c1 <> "~" Then Return 0
		  
		  Dim cnt As Integer = 1
		  Dim spaces As Boolean = False
		  
		  Dim i As Integer
		  Dim c As String
		  For i = pos + 1 To charsUbound
		    c = chars(i)
		    
		    If c = c1 And Not spaces Then
		      cnt = cnt + 1
		    ElseIf c = " " Then
		      spaces = True
		    Else
		      Return 0
		    End If
		  Next i
		  
		  Return If(cnt < length, 0, cnt)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanHtmlBlockEnd(type As Integer, line As MarkdownKit.LineInfo, pos As Integer) As Boolean
		  // Scans for the correct ending condition for the specified HTML block type.
		  // Returns True if we find one, False otherwise.
		  // There are 7 kinds of HTML blocks (CommonMark spec 0.29 4.6).
		  
		  Select Case type
		  Case Block.kHTMLBlockTypeInterruptingBlockWithEmptyLines
		    Return HTMLScanner.ScanHTMLBlockType1End(line, pos)
		  Case Block.kHTMLBlockTypeComment
		    Return HTMLScanner.ScanHtmlBlockType2End(line, pos)
		  Case Block.kHTMLBlockTypeProcessingInstruction
		    Return HTMLScanner.ScanHtmlBlockType3End(line, pos)
		  Case Block.kHTMLBlockTypeDocumentType
		    Return HTMLScanner.ScanHtmlBlockType4End(line, pos)
		  Case Block.kHTMLBlockTypeCData
		    Return HTMLScanner.ScanHtmlBlockType5End(line, pos)
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanHtmlBlockStart(line As MarkdownKit.LineInfo, pos As Integer, ByRef type As Integer) As Integer
		  // Scan for the start of an HTML block.
		  // Returns the type of HTML block as one of the Block.kHTMLBlockType constants.
		  // Also sets the ByRef `type` parameter to the same value as the returned value.
		  // There are 7 kinds of HTML block. See the note "HTML Block Types" in this class 
		  // for more detail.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim chars() As String = line.Chars
		  Dim charsUbound As Integer = chars.LastIndex
		  
		  // The shortest opening condition is two characters.
		  If pos + 1 > charsUbound Then
		    type = Block.kHTMLBlockTypeNone
		    Return Block.kHTMLBlockTypeNone
		  End If
		  
		  If chars(pos) <> "<" Then
		    type = Block.kHTMLBlockTypeNone
		    Return Block.kHTMLBlockTypeNone
		  End If
		  
		  pos = pos + 1
		  Dim c As String = chars(pos)
		  
		  // Type 2, 4 or 5?
		  // 2: <!--
		  // 4: <!A-Z{1}
		  // 5: <![CDATA[
		  If c = "!" Then
		    pos = pos + 1
		    If pos > charsUbound Then
		      type = Block.kHTMLBlockTypeNone
		      Return Block.kHTMLBlockTypeNone
		    End If
		    
		    c = chars(pos)
		    If Utilities.IsUppercaseASCIIChar(c) Then
		      type = Block.kHTMLBlockTypeDocumentType
		      Return Block.kHTMLBlockTypeDocumentType
		    End If
		    
		    // `pos` is currently pointing at the character after "!".
		    If pos + 1 > charsUbound Then Return Block.kHTMLBlockTypeNone
		    If chars(pos) = "-" And chars(pos + 1) = "-" Then
		      type = Block.kHTMLBlockTypeComment
		      Return Block.kHTMLBlockTypeComment
		    End If
		    
		    // `pos` still points at the character after "!".
		    If pos + 6 > charsUbound Then
		      type = Block.kHTMLBlockTypeNone
		      Return Block.kHTMLBlockTypeNone
		    End If
		    
		    If chars.ToString(pos, 7).ToText.Compare("[CDATA[", Text.CompareCaseSensitive) = 0 Then
		      type = Block.kHTMLBlockTypeCData
		      Return Block.kHTMLBlockTypeCData
		    End If
		    
		    type = Block.kHTMLBlockTypeNone
		    Return Block.kHTMLBlockTypeNone
		  End If
		  
		  // Type 3?
		  If c = "?" Then
		    type = Block.kHTMLBlockTypeProcessingInstruction
		    Return Block.kHTMLBlockTypeProcessingInstruction
		  End If
		  
		  // Type 1 or 6?
		  // 1: <(script|pre|style)([•→\n]|>)
		  // 6: <|</(HTMLTagName)([•→\n]|>|/>)
		  Dim slashAtStart As Boolean = If(c = "/", True, False)
		  If slashAtStart Then
		    pos = pos + 1
		    If pos > charsUbound Then
		      type = Block.kHTMLBlockTypeNone
		      Return Block.kHTMLBlockTypeNone
		    End If
		    c = chars(pos)
		  End If
		  
		  // `pos` currently points to the first character of a potential tag name.
		  Dim tagNameArray() As String
		  While pos <= charsUbound And tagNameArray.LastIndex < 10
		    c = chars(pos)
		    If Utilities.IsASCIIAlphaChar(c) Or Utilities.CharInHeaderLevelRange(c) Then
		      tagNameArray.Add(c)
		    Else
		      Exit
		    End If
		    pos = pos + 1
		  Wend
		  
		  Dim tagName As String = String.FromArray(tagNameArray, "")
		  If Not mHTMLTagNames.HasKey(tagName) And tagName <> "pre" And tagName <> "script" And tagName <> "style" Then
		    type = Block.kHTMLBlockTypeNone
		    Return Block.kHTMLBlockTypeNone
		  End If
		  
		  Dim maybeType1 As Boolean
		  maybeType1 = If(Not slashAtStart And (tagName = "script" Or tagName = "pre" Or tagName = "style"), True, False)
		  Dim maybeType6 As Boolean
		  maybeType6 = If(Not maybeType1 And tagName <> "script" And tagName <> "pre" And tagName <> "style", True, False)
		  
		  // `pos` points to the character immediately following the tag name.
		  c = If (pos < charsUbound, chars(pos), "")
		  If maybeType1 Then
		    If Utilities.IsWhitespace(c) Or c = ">" Then
		      type = Block.kHTMLBlockTypeInterruptingBlockWithEmptyLines
		      Return Block.kHTMLBlockTypeInterruptingBlockWithEmptyLines
		    Else
		      type = Block.kHTMLBlockTypeNone
		      Return Block.kHTMLBlockTypeNone
		    End If
		  ElseIf maybeType6 Then // Type 6?
		    If Utilities.IsWhitespace(c) Or c = ">" Or (c = "/" And pos + 1 <= charsUbound And chars(pos + 1) = ">") Then
		      type = Block.kHTMLBlockTypeInterruptingBlock
		      Return Block.kHTMLBlockTypeInterruptingBlock
		    Else
		      type = Block.kHTMLBlockTypeNone
		      Return Block.kHTMLBlockTypeNone
		    End If
		  End If
		  
		  type = Block.kHTMLBlockTypeNone
		  Return Block.kHTMLBlockTypeNone
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanHtmlBlockType7Start(line As MarkdownKit.LineInfo, pos As Integer, ByRef type As Integer) As Integer
		  // Returns Block.kHTMLBlockTypeNonInterruptingBlock (type 7) If this line (begining at 
		  // `pos`) is a valid type 7 HTML block start. Otherwise returns Block.kHTMLBlockTypeNone.
		  // Also sets the ByRef `type` parameter to the same value as the returned value.
		  // Type 7: {openTag NOT script|style|pre}[•→]+|⮐$   or
		  //         {closingTag}[•→]+|⮐$
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // Reset the ByRef type parameter.
		  type = Block.kHTMLBlockTypeNone
		  
		  // At least 3 characters are required for a valid type 7 block start.
		  Dim chars() As String = line.Chars
		  Dim charsUbound As Integer = chars.LastIndex
		  If pos + 2 > charsUbound Then Return Block.kHTMLBlockTypeNone
		  
		  If chars(pos) <> "<" Then Return Block.kHTMLBlockTypeNone
		  
		  Dim tagName As String
		  If chars(pos + 1) = "/" Then
		    pos = HTMLScanner.ScanClosingTag(chars, pos + 2, tagName)
		  Else
		    pos = HTMLScanner.ScanOpenTag(chars, pos + 1, tagName)
		    If tagName = "script" Or tagName = "style" Or tagName = "pre" Then
		      Return Block.kHTMLBlockTypeNone
		    End If
		  End If
		  If pos = 0 Then Return Block.kHTMLBlockTypeNone
		  
		  While pos <= charsUbound
		    If Not Utilities.IsWhitespace(chars(pos)) Then Return Block.kHTMLBlockTypeNone
		    pos = pos + 1
		  Wend
		  
		  type = Block.kHTMLBlockTypeNonInterruptingBlock
		  Return Block.kHTMLBlockTypeNonInterruptingBlock
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub ScanLinkReferenceDefinition(ByRef chars() As String, doc As MarkdownKit.Document)
		  // Takes an array of characters representing the raw text of a paragraph.
		  // Assumes that there are at least 4 characters and chars(0) = "[".
		  // If we find a valid link reference definition then we remove it from the 
		  // character array (which is passed by reference) and we add it to the passed 
		  // Document's reference map dictionary.
		  // If we don't find a valid reference then we leave chars alone.
		  // Assumes doc <> Nil.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim charsUbound As Integer = chars.LastIndex
		  Dim pos As Integer = 0
		  
		  // Parse the label.
		  Dim labelCR As MarkdownKit.CharacterRun = InlineScanner.ScanLinkLabelDefinition(chars, pos)
		  If labelCR.Length = -1 Then Return // Invalid.
		  
		  pos = labelCR.Start + labelCR.Length
		  If pos > charsUbound Then Return
		  
		  // Colon?
		  If chars(pos) <> ":" Then
		    Return
		  Else
		    pos = pos + 1
		    If pos > charsUbound Then Return
		  End If
		  
		  // Advance optional whitespace following the colon (including up to one newline).
		  Dim i As Integer
		  Dim seenNewline As Boolean = False
		  For i = pos To charsUbound
		    Select Case chars(i)
		    Case &u000A
		      If seenNewline Then Return // Invalid.
		      seenNewline = True
		    Case " ", &u0009
		      Continue
		    Else
		      Exit
		    End Select
		  Next i
		  pos = i
		  
		  // Parse the link destination.
		  Dim destinationCR As MarkdownKit.CharacterRun = InlineScanner.ScanLinkDestination(chars, pos, True)
		  If destinationCR.Length = -1 Then Return // Invalid.
		  pos = pos + destinationCR.Length
		  
		  // Advance optional whitespace following the destination (including up to one newline).
		  Dim skippedWhitespace As Boolean = False
		  If pos <= charsUbound Then
		    seenNewline = False
		    For i = pos To charsUbound
		      Select Case chars(i)
		      Case &u000A
		        If seenNewline Then Return // Invalid.
		        seenNewline = True
		        skippedWhitespace = True
		      Case " ", &u0009
		        skippedWhitespace = True
		        Continue
		      Else
		        Exit
		      End Select
		    Next i
		    pos = i
		  End If
		  
		  If pos >= charsUbound Then
		    // No title.
		    FinaliseLinkReferenceDefinition(chars, doc, labelCR, destinationCR)
		    Return
		  End If
		  
		  // Parse the (optional) title.
		  Dim titleCR As MarkdownKit.CharacterRun = InlineScanner.ScanLinkTitle(chars, pos)
		  If titleCR.Invalid Then
		    Return
		  ElseIf titleCR.Length = -1 Then
		    // No title.
		    FinaliseLinkReferenceDefinition(chars, doc, labelCR, destinationCR)
		    Return
		  Else
		    // Titles must be separated from the destination by whitespace
		    If Not skippedWhitespace Then Return
		  End If
		  
		  // Ensure that there are no further non-whitespace characters on this line 
		  // (i.e: up to the next newline or end of array).
		  pos = pos + titleCR.Length
		  seenNewline = False
		  Dim c As String
		  If pos < charsUbound Then
		    For i = pos To charsUbound
		      c = chars(i)
		      If c = &u000A And Not seenNewline Then
		        seenNewline = True
		      ElseIf Not Utilities.IsWhitespace(c) Then
		        If Not seenNewline Then
		          // The only way this can still be a valid reference def is if this 
		          // title begins on a newline (in which case we treat it as a 
		          // definition without a title)
		          If chars(titleCR.Start - 1) = &u000A Then // No title.
		            FinaliseLinkReferenceDefinition(chars, doc, labelCR, destinationCR)
		          End If
		          Return
		        Else
		          titleCR.Finish = i - 1
		          Exit
		        End If
		      End If
		      titleCR.Finish = i
		    Next i
		  End If
		  
		  // Finalise the reference.
		  FinaliseLinkReferenceDefinition(chars, doc, labelCR, destinationCR, titleCR)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanOpenCodeFence(chars() As String, pos As Integer, ByRef length As Integer) As Integer
		  // Scans the passed array of characters for an opening code fence.
		  // Returns the length of the fence if found (0 if not found).
		  // Additionally mutates the ByRef `length` variable to the length of the 
		  // found (or not found) code fence length.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim charsUbound As Integer = chars.LastIndex
		  
		  length = 0
		  
		  If pos + 2 > charsUbound Then Return 0
		  
		  Dim fchar As String = chars(pos)
		  If fchar <> "`" And fchar <> "~" Then Return 0
		  
		  length = 1
		  Dim fenceDone As Boolean = False
		  
		  Dim i As Integer
		  Dim c As String
		  For i = pos + 1 to charsUbound
		    c = chars(i)
		    
		    If c = fchar Then
		      If fenceDone Then
		        // Backticks are permitted in tilde-declared fences.
		        If fchar = "~" Then Continue 
		        Return 0
		      End If
		      length = length + 1
		      Continue
		    End If
		    
		    fenceDone = True
		    If length < 3 Then Return 0
		    
		    If c = "" Then Return length
		  Next i
		  
		  If length < 3 Then Return 0
		  
		  Return length
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanSetextHeadingLine(chars() As String, pos As Integer, ByRef level As Integer) As Integer
		  // Attempts to match a setext heading line. 
		  // Returns the heading level (1 or 2) or 0 if this is not a setext heading line.
		  // We also set the ByRef `level` variable to the heading level or 0.
		  ' ^[=]+[ ]*$
		  ' ^[-]+[ ]*$
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  // Reset the ByRef parameter.
		  level = 0
		  
		  Dim charsUbound As Integer = chars.LastIndex
		  If pos > charsUbound Then Return 0
		  
		  Dim c As String = chars(pos)
		  Dim stxChar As String
		  If c <> "=" And c <> "-" Then
		    Return 0
		  Else
		    stxChar = c
		  End If
		  If pos + 1 > charsUbound Then
		    level = If(c = "=", 1, 2)
		    Return level
		  End If
		  
		  Dim i As Integer
		  Dim done As Boolean = False
		  For i = pos + 1 To charsUbound
		    c = chars(i)
		    
		    If c = stxChar And Not Done Then Continue
		    
		    // Not a  "=" or "-" character.
		    done = True
		    
		    If c = " " Or c = &u0009 Then Continue
		    
		    level = 0
		    Return 0
		  Next i
		  
		  level = If(c = "=", 1, 2)
		  Return level
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanSpaceChars(chars() As String, pos As Integer) As Integer
		  // Match space and tab characters.
		  
		  #If Not TargetWeb
		    #Pragma DisableBackgroundTasks
		  #Endif
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  
		  Dim charsUbound As Integer = chars.LastIndex
		  
		  If pos > charsUbound Then Return 0
		  
		  Dim i As Integer
		  For i = pos To charsUbound
		    If Not Utilities.IsWhitespace(chars(pos)) Then Return i - pos
		  Next i
		  
		  Return (charsUbound + 1)- pos
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ScanThematicBreak(chars() As String, pos As Integer) As Integer
		  // Scan for a thematic break line.
		  // Valid thematic break lines consist of >= 3 dashes, underscores or asterixes 
		  // which may be optionally separated by any amount of spaces or tabs whitespace.
		  // The characters must match.
		  ' ^([-][ ]*){3,}[\s]*$"
		  ' ^([_][ ]*){3,}[\s]*$"
		  ' ^([\*][ ]*){3,}[\s]*$"
		  // Returns the length of the matching thematic break.
		  
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Dim charsUbound As Integer = chars.LastIndex
		  
		  Dim count As Integer = 0
		  Dim i As Integer
		  Dim c, tbChar As String
		  
		  For i = pos To charsUbound
		    c = chars(i)
		    If c = " " Or c = &u0009 Then
		      Continue
		    ElseIf count = 0 Then
		      Select Case c
		      Case "-", "_", "*"
		        tbChar = c
		        count = count + 1
		      Else
		        Return 0
		      End Select
		    ElseIf c = tbChar Then
		      count = count + 1
		    Else
		      Return 0
		    End If
		  Next i
		  
		  If count < 3 Then
		    Return 0
		  Else
		    Return charsUbound + 1 - pos
		  End If
		  
		End Function
	#tag EndMethod


	#tag Note, Name = HTML Block Types
		Type 1: Block.kHTMLBlockTypeInterruptingBlockWithEmptyLines)
		Start condition: line begins with the string <script, <pre, or <style (case-insensitive), followed by whitespace, the string >, or the end of the line.
		End condition: line contains an end tag </script>, </pre>, or </style> (case-insensitive; it need not match the start tag).
		
		Type 2: (Block.kHTMLBlockTypeComment)
		Start condition: line begins with the string <!--.
		End condition: line contains the string -->.
		
		Type 3: (Block.kHTMLBlockTypeProcessingInstruction)
		Start condition: line begins with the string <?.
		End condition: line contains the string ?>.
		
		Type 4: (Block.kHTMLBlockTypeDocumentType)
		Start condition: line begins with the string <! followed by an uppercase ASCII letter.
		End condition: line contains the character >.
		
		Type 5: (Block.kHTMLBlockTypeCData)
		Start condition: line begins with the string <![CDATA[.
		End condition: line contains the string ]]>.
		
		Type 6: (Block.kHTMLBlockTypeInterruptingBlock)
		Start condition: line begins the string < or </ followed by one of the strings (case-insensitive) address, article, aside, base, basefont, blockquote, body, caption, center, col, colgroup, dd, details, dialog, dir, div, dl, dt, fieldset, figcaption, figure, footer, form, frame, frameset, h1, h2, h3, h4, h5, h6, head, header, hr, html, iframe, legend, li, link, main, menu, menuitem, nav, noframes, ol, optgroup, option, p, param, section, source, summary, table, tbody, td, tfoot, th, thead, title, tr, track, ul, followed by whitespace, the end of the line, the string >, or the string />.
		End condition: line is followed by a blank line.
		
		Type 7: (Block.kHTMLBlockTypeNonInterruptingBlock)
		Start condition: line begins with a complete open tag (with any tag name other than script, style, or pre) or a complete closing tag, followed only by whitespace or the end of the line.
		End condition: line is followed by a blank line.
		
	#tag EndNote


	#tag Property, Flags = &h21
		Private Shared mHTMLTagNames As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mInitialised As Boolean = False
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
	#tag EndViewBehavior
End Class
#tag EndClass
