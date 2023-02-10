#tag Class
Protected Class MKInlineScanner
	#tag Method, Flags = &h21, Description = 54727565206966205B636F6E7461696E65725D2063616E20636F6E7461696E20736F667420627265616B732E
		Private Shared Function CanContainSoftBreaks(container As MKBlock) As Boolean
		  /// True if [container] can contain soft breaks.
		  
		  Select Case container.Type
		  Case MKBlockTypes.AtxHeading
		    Return False
		    
		  Else
		    Return True
		    
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6D707574657320746865206162736F6C75746520737461727420706F736974696F6E206F6620696E6C696E6520656C656D656E747320696E2074686973205B636F6E7461696E65725D2E
		Private Shared Function ComputeInlineStart(container As MKBlock) As Integer
		  /// Computes the absolute start position of inline elements in this [container].
		  ///
		  /// The start of inline elements is not always the same as the start position of the container.
		  /// For example:
		  ///   012
		  ///   Foo
		  ///   ^
		  /// Versus
		  ///   01234
		  ///   # Foo
		  ///     ^
		  
		  Select Case container.Type
		  Case MKBlockTypes.AtxHeading
		    Return container.Start + MKATXHeadingBlock(container).Level + 1 // +1 for the space after the `#`s.
		    
		  Else
		    Return container.Start
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5072697661746520746F2070726576656E7420696E7374616E74696174696F6E2E
		Private Sub Constructor()
		  /// Private to prevent instantiation.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E76656E69656E6365206D6574686F6420666F72206372656174696E672061206E6577204D4B496E6C696E654C696E6B44617461206F626A6563742E
		Private Shared Function CreateInlineLinkData(linkTextChars() As MKCharacter, destinationData As MarkdownKit.MKLinkDestination, titleData As MarkdownKit.MKLinkTitle, containerEndPos As Integer, isInlineImage As Boolean, openerChar As MKCharacter, closerChar As MKCharacter) As MKInlineLinkData
		  /// Convenience method for creating a new MKInlineLinkData object.
		  ///
		  /// [containerEndPos] is the position in the inline link's container's `Characters` array of the closing ")".
		  /// The contents of [linkTextChars] are used as the link's text and need to be parsed as inlines.
		  ///
		  /// [openerChar] is the opening `[` character (for links) or `!` character (for images).
		  /// [closerChar] is the closing `]` character.
		  
		  Var data As New MarkdownKit.MKInlineLinkData(isInlineImage, MKLinkTypes.Standard)
		  
		  Var labelData As New MarkdownKit.MKLinkLabel
		  labelData.Length = linkTextChars.Count
		  labelData.Value = linkTextChars.ToString
		  
		  labelData.Characters = linkTextChars
		  
		  data.EndPosition = containerEndPos
		  data.Label = labelData
		  data.Destination = destinationData
		  data.Title = titleData
		  data.Characters = linkTextChars
		  
		  data.OpenerCharacter = openerChar
		  data.CloserCharacter = closerChar
		  
		  Return data
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4765747320746865206461746120666F7220612076616C696461746564207265666572656E6365206C696E6B206E616D6564205B6C696E6B4C6162656C5D2066726F6D2074686520646F63756D656E742773207265666572656E6365206D61702073746F72696E6720746865206C696E6B277320656E6420706F736974696F6E20616E642063686172616374657220646174612E
		Private Shared Function CreateReferenceLinkData(ByRef container As MKBlock, linkLabel As String, chars() As MKCharacter, containerEndPos As Integer, isInlineImage As Boolean, openerChar As MKCharacter, closerChar As MKCharacter, linkType As MKLinkTypes, optionalDestination As MarkdownKit.MKLinkDestination = Nil) As MKInlineLinkData
		  /// Gets the data for a validated reference link named [linkLabel] from the document's reference map
		  /// storing the link's end position and character data.
		  ///
		  /// [containerEndPos] is the position in [container.Characters] of the closing "]".
		  /// If this is an inline link, the contents of [chars] are used as the link's text.
		  /// If this is an inline image, the contents of [chars] are used as the images's `alt` attrubute
		  /// [chars] will be parsed as inlines.
		  ///
		  /// [openerChar] is the opening `[` character (for links) or `!` character (for images).
		  /// [closerChar] is the closing `]` character.
		  
		  Var data As New MarkdownKit.MKInlineLinkData(isInlineImage, linkType)
		  data.EndPosition = containerEndPos
		  
		  Var linkTextData As New MarkdownKit.MKLinkLabel
		  linkTextData.Length = chars.Count
		  linkTextData.Value = chars.ToString
		  
		  linkTextData.Characters = chars
		  
		  // Get the reference destination and title from the document's reference map.
		  Var ref As MarkdownKit.MKLinkReferenceDefinition = _
		  MKLinkReferenceDefinition(container.Document.References.Value(linkLabel.Lowercase))
		  
		  If linkType = MKLinkTypes.FullReference And optionalDestination <> Nil Then
		    data.Destination = optionalDestination
		  Else
		    data.Destination = ref.LinkDestination
		  End If
		  data.Label = linkTextData
		  data.Title = ref.LinkTitle
		  data.Characters = chars
		  data.LinkType = linkType
		  
		  data.OpenerCharacter = openerChar
		  data.CloserCharacter = closerChar
		  
		  Return data
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 46696E616C69736573207468652063757272656E7420696E6C696E652070617273696E67206275666665722E
		Private Shared Sub FinaliseBuffer(ByRef buffer As MKInlineText, container As MKBlock)
		  /// Finalises the current inline parsing buffer.
		  ///
		  /// As we parse inlines, we perodically keep an open inline text buffer to add characters to
		  /// until we hit a different type of inline element (e.g. a backtick for a code span).
		  /// This method is called when we need to close / finalise that open buffer.
		  
		  buffer.Finalise
		  
		  // Add the buffer to the container block.
		  container.Children.Add(buffer)
		  
		  buffer = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 46696E616C69736573205B636F6E7461696E65725D2061667465722070617273696E6720616C6C206F662069747320696E6C696E65206368696C6472656E2E
		Private Shared Sub FinaliseInlineContainer(container As MKBlock)
		  /// Finalises [container] after parsing all of its inline children.
		  
		  Select Case container.Type
		  Case MKBlockTypes.Paragraph, MKBlockTypes.SetextHeading
		    If container.Children.Count > 0 And _
		      container.Children(container.Children.LastIndex).Type = MKBlockTypes.SoftBreak Then
		      // If the last inline of this container is a soft break, remove it.
		      Call container.Children.Pop
		    End If
		    
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732065697468657220616E20696E6C696E65206C696E6B206F72204E696C20696620612076616C69642066756C6C207265666572656E6365206C696E6B2063616E6E6F7420626520636F6E73747275637465642E
		Private Shared Function FullReferenceLinkData(ByRef container As MKBlock, chars() As MKCharacter, linkTextChars() As MKCharacter, charsStartPos As Integer, isInlineImage As Boolean, openerChar As MKCharacter, closerChar As MKCharacter) As MKInlineLinkData
		  /// Returns either an inline link or Nil if a valid full reference link cannot be constructed.
		  ///
		  /// [linkTextChars] are the raw characters representing this link's "link text". 
		  /// They are to be parsed as inlines.
		  /// [charsStartPos] is the index of the "[" immediately after the closing linkText "]".
		  /// [openerChar] is the opening `[` character (for links) or `!` character (for images).
		  /// [closerChar] is the closing `]` character.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // We know that `charsStartPos` points to a "[".
		  If charsStartPos + 1 > charsLastIndex Then Return Nil
		  
		  // Scan for a valid link label.
		  Var c, linkLabelChars() As String
		  Var indexOfClosingBracket As Integer = -1
		  For i As Integer = charsStartPos + 1 To charsLastIndex
		    c = chars(i).Value
		    If c = "]" And Not chars.IsEscaped(i) Then
		      indexOfClosingBracket = i
		      Exit
		    Else
		      linkLabelChars.Add(c)
		    End If
		  Next i
		  If indexOfClosingBracket = -1 Then Return Nil
		  
		  // A valid label must contain at least one non-whitespace character.
		  Var seenNonWhitespace As Boolean = False
		  Var linkLabelcharsLastIndex As Integer = linkLabelChars.LastIndex
		  For i As Integer = 0 To linkLabelcharsLastIndex
		    If Not linkLabelChars(i).IsMarkdownWhitespace Then
		      seenNonWhitespace = True
		      Exit
		    End If
		  Next i
		  If Not seenNonWhitespace Then Return Nil
		  
		  // Does the document's reference map contain a reference with the same label?
		  Var linkLabel As String = String.FromArray(linkLabelChars, "")
		  If Not container.Document.References.HasKey(linkLabel.Lowercase) Then Return Nil
		  
		  // Construct this reference link.
		  Var data As MarkdownKit.MKInlineLinkData = _
		  CreateReferenceLinkData(container, linkLabel, linkTextChars, indexOfClosingBracket, isInlineImage, _
		  openerChar, closerChar, MKLinkTypes.FullReference)
		  
		  data.FullReferenceDestinationOpener = chars(charsStartPos)
		  data.FullReferenceDestinationCloser = chars(indexOfClosingBracket)
		  data.FullReferenceLabelLength = indexOfClosingBracket - charsStartPos
		  
		  Return data
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 49662074686520636861726163746572206174205B7374617274506F735D20696E205B63686172735D20626567696E7320612076616C696420696E6C696E6520636F6465207370616E207468656E206F6E65206973206372656174656420616E642072657475726E65642C206F7468657277697365204E696C2069732072657475726E65642E
		Private Shared Function HandleBackticks(parent As MKBlock, chars() As MKCharacter, startPos As Integer) As MKCodeSpan
		  /// If the character at [startPos] in [chars] begins a valid inline code span then one is created and 
		  /// returned, otherwise Nil is returned.
		  /// 
		  /// Assumes [startPos] in [chars] is a backtick.
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  // If the character immediately before the starting backtick is another backtick then this
		  // can't be a valid code span.
		  If startPos > 0 And chars(startPos - 1).Value = "`" Then Return Nil
		  
		  Var openingBacktickChar As MKCharacter = chars(startPos)
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Compute the length of the backtickString and the index of the first character after the 
		  // opening backtickString.
		  Var contentStartPos As Integer = startPos + 1
		  While contentStartPos <= charsLastIndex
		    If chars(contentStartPos).Value <> "`" Then Exit
		    contentStartPos = contentStartPos + 1
		  Wend
		  If contentStartPos = charsLastIndex Then Return Nil
		  Var backtickStringLen As Integer = contentStartPos - startPos
		  
		  // Find the start position of the closing backtick string (if there is one).
		  Var firstBackTickSeenIndex As Integer = -1
		  Var contentEndPos, parentClosingBacktickStringStart As Integer
		  Var contiguousBackticks As Integer = 0
		  Var foundClosingBacktickString As Boolean = False
		  Var closingBackstringFirstCharacter As MKCharacter
		  For i As Integer = contentStartPos To charsLastIndex
		    If chars(i).Value = "`" Then
		      If firstBackTickSeenIndex = -1 Then firstBackTickSeenIndex = i
		      contiguousBackticks = contiguousBackticks + 1
		      If contiguousBackticks = backtickStringLen Then
		        // Done so long as the next character isn't a backtick.
		        If i = charsLastIndex Or (i < charsLastIndex And chars(i + 1).Value <> "`") Then
		          contentEndPos = chars(firstBackTickSeenIndex).AbsolutePosition - backtickStringLen
		          parentClosingBacktickStringStart = firstBackTickSeenIndex
		          foundClosingBacktickString = True
		          closingBackstringFirstCharacter = chars(i)
		          Exit
		        End If
		      End If
		    Else
		      contiguousBackticks = 0
		      firstBackTickSeenIndex = -1
		    End If
		  Next i
		  If Not foundClosingBacktickString Then Return Nil
		  
		  // We've found a code span.
		  Var cs As New MKCodeSpan(parent, parent.Start + startPos, startPos, _
		  chars(startPos).Line.Number, backtickStringLen, parentClosingBacktickStringStart, _
		  openingBacktickChar, chars(parentClosingBacktickStringStart))
		  cs.Finalise
		  
		  Return cs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 49662074686520636861726163746572206174205B7374617274506F735D20696E205B63686172735D20626567696E7320612076616C696420696E6C696E652048544D4C207370616E207468656E206F6E65206973206372656174656420616E642072657475726E65642C206F7468657277697365204E696C2069732072657475726E65642E
		Private Shared Function HandleLeftAngleBracket(parent As MKBlock, chars() As MarkdownKit.MKCharacter, startPos As Integer) As MKInlineHTML
		  /// If the character at [startPos] in [chars] begins a valid inline HTML span then one is created and 
		  /// returned, otherwise Nil is returned.
		  ///
		  /// Assumes `chars(startPos) = "<"`.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Bare minimum valid inline HTML tag 3 characters long (e.g: `<a>`).
		  If startPos + 2 > charsLastIndex Then Return Nil
		  
		  Var html As MKInlineHTML
		  Var pos As Integer = 0
		  Var c As String = chars(startPos + 1).Value
		  Var tagName As String
		  
		  If c = "/" Then
		    // Does this mark a closing tag?
		    pos = MKInlineHTMLScanner.FindClosingTag(chars, startPos + 2, tagName)
		    
		  ElseIf c = "?" Then
		    // Processing instruction?
		    pos = MKInlineHTMLScanner.ScanProcessingInstruction(chars, startPos + 2)
		    
		  ElseIf c = "!" Then
		    // Comment, declaration or CDATA section?
		    pos = MKInlineHTMLScanner.ScanDeclarationCommentOrCData(chars, startPos + 2)
		    
		  Else
		    // Autolink?
		    Var uri As String
		    pos = MKInlineHTMLScanner.ScanAutoLink(chars, startPos + 1, uri)
		    If pos > 0 Then
		      html = New MKInlineHTML(parent, parent.Start + startPos, startPos, chars(startPos).LocalPosition,_
		      chars(pos - 1), pos - 1)
		      html.IsAutoLink = True
		      html.Title = ""
		      html.Destination = uri
		      html.Label = uri
		      html.Finalise
		      Return html
		      
		    Else
		      // Email link?
		      pos = MKInlineHTMLScanner.ScanEmailLink(chars, startPos + 1, uri)
		      If pos > 0 Then
		        html = New MKInlineHTML(parent, parent.Start + startPos, startPos, chars(startPos).LocalPosition,_
		        chars(pos - 1), pos - 1)
		        html.IsAutoLink = True
		        html.Title = ""
		        html.Destination = "mailto:" + uri
		        html.Label = uri
		        html.Finalise
		        Return html
		      Else
		        // Opening tag?
		        pos = MKInlineHTMLScanner.FindOpenTag(chars, startPos + 1, tagName)
		      End If
		    End If
		  End If
		  
		  If pos = 0 Then
		    Return Nil
		  Else
		    html = New MKInlineHTML(parent, parent.Start + startPos, startPos, chars(startPos).LocalPosition, _
		    chars(pos - 1), pos - 1)
		    html.Finalise
		    Return html
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function InlineLinkData(openerChar As MKCharacter, closingBracketChar As MKCharacter, chars() As MarkdownKit.MKCharacter, linkTextChars() As MKCharacter, parenthStartPos As Integer, isInlineImage As Boolean) As MKInlineLinkData
		  /// Returns either an inline link or Nil if a valid inline link cannot be constructed.
		  ///
		  /// [linkTextChars] are the raw characters representing this link's text. They are to be parsed as inlines.
		  /// [parenthStartPos] points to the index of the "(" immediately after the closing linkText "]".
		  /// [openerChar] is the opening `[` character (for links) or `!` character (for images).
		  /// [closingBracketChar] is the closing `]` character.
		  ///
		  /// Inline link: linkText, "(", optional whitespace, optional link destination, 
		  ///              optional linkTitle, optional whitespace, ")"
		  ///
		  /// The contents of [linkText] are parsed as inlines and used as the link's text.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // We know that `parenthStartPos` points at the opening "(" so move past it.
		  Var pos As Integer = parenthStartPos + 1
		  
		  If pos > charsLastIndex Then Return Nil
		  
		  // Advance past any optional whitespace.
		  While pos <= charsLastIndex And chars(pos).IsMarkdownWhitespace
		    pos = pos + 1
		  Wend
		  
		  // Optional link destination?
		  Var destinationData As New MarkdownKit.MKLinkDestination(chars(parenthStartPos), "", 0, Nil)
		  Var destinationStartPos As Integer = pos
		  Var destination As String = ScanInlineLinkDestination(chars, pos)
		  MarkdownKit.Unescape(destination)
		  If destination.Length > 0 Then
		    destinationData.Value = destination
		    destinationData.Length = pos - destinationStartPos
		    destinationData.EndCharacter = chars(pos)
		  End If
		  
		  Var titleData As MarkdownKit.MKLinkTitle
		  
		  If pos > charsLastIndex Then Return Nil
		  
		  Var seenWhiteSpace As Boolean = False
		  // Advance past any optional whitespace.
		  While pos <= charsLastIndex And chars(pos).IsMarkdownWhitespace(True)
		    seenWhiteSpace = True
		    pos = pos + 1
		  Wend
		  
		  // Optional link title?
		  titleData = New MKLinkTitle(chars(pos))
		  Var titleValueStartPos As Integer = pos + 1
		  Var title As String = ScanInlineLinkTitle(chars, pos)
		  MarkdownKit.Unescape(title)
		  If title.Length > 0 Then
		    titleData.Value = title
		    Var vb As MarkdownKit.MKLinkTitleBlock
		    Var isOpenValueBlock As Boolean = False
		    Var c As MarkdownKit.MKCharacter
		    For i As Integer = titleValueStartPos To pos - 2 // -2 as `pos` points to the closing `)`
		      c = chars(i)
		      If c.IsLineEnding Then
		        If vb <> Nil Then titleData.ValueBlocks.Add(vb)
		        isOpenValueBlock = False
		        Continue
		      End If
		      If Not isOpenValueBlock Then
		        vb = New MKLinkTitleBlock(c.AbsolutePosition, c.LocalPosition, 1, c.Line.Number)
		        isOpenValueBlock = True
		      Else
		        vb.Length = vb.Length + 1
		      End If
		    Next i
		    If isOpenValueBlock Then
		      titleData.ValueBlocks.Add(vb)
		    End If
		    titleData.Length = pos - titleValueStartPos - 2 // -2 as `pos` points to the closing `)`
		    titleData.ClosingDelimiter = chars(pos - 1)
		  Else
		    titleData.OpeningDelimiter = Nil
		  End If
		  
		  // Advance past any optional whitespace.
		  While pos <= charsLastIndex And chars(pos).IsMarkdownWhitespace(True)
		    pos = pos + 1
		  Wend
		  
		  // Need to see the closing ")".
		  If pos > charsLastIndex Then Return Nil
		  If chars(pos).Value <> ")" Then Return Nil
		  
		  destinationData.EndCharacter = chars(pos)
		  
		  // We've found a valid inline link.
		  Return CreateInlineLinkData(linkTextChars, destinationData, titleData, pos, isInlineImage, openerChar, closingBracketChar)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 486176696E6720686974206120225D222C2072657475726E7320547275652069662061206C696E6B206F7220696D6167652070726563656465732069742E20496620547275652C20746865206C696E6B206F7220696D61676520697320616464656420746F205B636F6E7461696E65725D20616E64205B706F735D206973206D7574617465642E
		Private Shared Function LookForLinkOrImage(ByRef container As MarkdownKit.MKBlock, ByRef delimiterStack() As MKDelimiterStackNode, ByRef pos As Integer) As Boolean
		  /// Having hit a "]", returns True if a link or image precedes it. If True, the link or image is added to
		  /// [container] and [pos] is mutated.
		  
		  // Starting at the top of the delimiter stack, we look backwards through 
		  // for an opening "[" or "![" delimiter.
		  For i As Integer = delimiterStack.LastIndex DownTo 0
		    Var dsn As MarkdownKit.MKDelimiterStackNode = delimiterStack(i)
		    
		    // Can this delimiter open a link or image?
		    If Not dsn.CanOpenLinkOrImage Then Continue
		    
		    // If this delimiter is inactive, remove it from the stack and exit.
		    If Not dsn.Active Then
		      delimiterStack.RemoveAt(i)
		      Return False
		    End If
		    
		    Select Case dsn.Delimiter
		    Case "["
		      // Parse ahead for an inline link, reference link, compact reference link, or shortcut reference link.
		      Var linkData As MKInlineLinkData = ScanForInlineLink(container, dsn.TextNode.ParentStart, pos)
		      
		      If linkData = Nil Then
		        // Didn't find a valid link. Remove the opening delimiter from the stack.
		        delimiterStack.RemoveAt(i)
		        Return False
		      Else
		        // Create a new inline link with `container` as its parent.
		        Var link As New MarkdownKit.MKInlineLink(container, dsn.TextNode.Start, linkData)
		        link.LineNumber = container.Characters(pos).Line.Number
		        
		        // The children of this inline link are the child blocks of the container 
		        // AFTER the text node pointed to by the opening delimiter.
		        Var openerIndex As Integer = container.Children.IndexOf(dsn.TextNode)
		        If openerIndex = -1 Then
		          Raise New MKException("Couldn't find the opener text node in the container's children.")
		        End if
		        Var limit As Integer = container.Children.LastIndex
		        For x As Integer = openerIndex + 1 To limit
		          link.Children.Add(container.Children(x))
		          link.Children(link.Children.LastIndex).Parent = link
		        Next x
		        For x As Integer = openerIndex + 1 To limit
		          Call container.Children.Pop
		        Next x
		        
		        // Add this link as the last child of this container.
		        container.Children.Add(link)
		        
		        // Process emphasis on the link's children.
		        ProcessEmphasis(link, delimiterStack, i)
		        
		        // Remove the opening delimiter text node.
		        container.Children.RemoveAt(openerIndex)
		        
		        // Set all "[" delimiters before the opening delimiter to inactive.
		        // This prevents links within links.
		        For x As Integer = 0 to i - 1
		          If delimiterStack(x).Delimiter = "[" Then delimiterStack(x).Active = False
		        Next x
		        
		        // Remove this delimiter node as we're done with it.
		        delimiterStack.RemoveAt(i)
		        
		        // Update the position.
		        pos = linkData.EndPosition + 1
		        
		        Return True
		      End If
		      
		    Case "!["
		      // Parse ahead for an inline image, reference image, compact reference image, or shortcut reference image.
		      Var imageData As MKInlineLinkData = ScanForInlineImage(container, dsn.TextNode.ParentStart, pos)
		      
		      If imageData = Nil Then
		        // Didn't find a valid image. Remove the opening delimiter from the stack.
		        delimiterStack.RemoveAt(i)
		        Return False
		      Else
		        // Create a new inline image with `container` as its parent.
		        Var image As New MarkdownKit.MKInlineImage(container, dsn.TextNode.Start, imageData)
		        image.LineNumber = container.Characters(pos).Line.Number
		        
		        // The children of this inline image are the child blocks of the container 
		        // AFTER the text node pointed to by the opening delimiter.
		        Var openerIndex As Integer = container.Children.IndexOf(dsn.TextNode)
		        If openerIndex = -1 Then
		          Raise New MKException("Couldn't find the opener text node in the container's children.")
		        End if
		        Var limit As Integer = container.Children.LastIndex
		        For x As Integer = openerIndex + 1 To limit
		          image.Children.Add(container.Children(x))
		          image.Children(image.Children.LastIndex).Parent = image
		        Next x
		        For x As Integer = openerIndex + 1 To limit
		          Call container.Children.Pop
		        Next x
		        
		        // Add this image as the last child of this container.
		        container.Children.Add(image)
		        
		        // Process emphasis on the image's children.
		        ProcessEmphasis(image, delimiterStack, i)
		        
		        // Remove the opening delimiter text node.
		        container.Children.RemoveAt(openerIndex)
		        
		        // Remove this delimiter node as we're done with it.
		        delimiterStack.RemoveAt(i)
		        
		        // Update the position.
		        pos = imageData.EndPosition + 1
		        
		        Return True
		      End If
		    End Select
		  Next i
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5374657073207468726F7567682074686520636F6E74656E7473206F662074686520696E6C696E6520636F6E7461696E6572205B626C6F636B5D2C2068616E646C696E6720616E7920696E6C696E6520656C656D656E747320697420656E636F756E746572732E
		Shared Sub ParseInlines(block As MKBlock, ByRef delimiterStack() As MKDelimiterStackNode)
		  /// Steps through the contents of the inline container [block], handling any inline elements it encounters.
		  ///
		  /// Assumes [block] is an inline container block (i.e: a paragraph, ATX heading or setext heading).
		  
		  Var pos As Integer = 0
		  Var chars() As MKCharacter = block.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  Var buffer As MKInlineText
		  
		  Var inlineStart As Integer = ComputeInlineStart(block)
		  
		  While pos <= charsLastIndex
		    Var c As MarkdownKit.MKCharacter = chars(pos)
		    
		    If c.Value = "`" And Not chars.IsEscaped(pos) Then
		      // ============
		      // CODE SPAN
		      // ============
		      Var cs As MarkdownKit.MKCodeSpan = HandleBackticks(block, chars, pos)
		      If cs <> Nil Then
		        // Found a code span.
		        If buffer <> Nil Then FinaliseBuffer(buffer, block)
		        // Add the code span.
		        block.Children.Add(cs)
		        // Advance the position.
		        pos = cs.ParentClosingBacktickStringStart + cs.BacktickStringLength
		      Else
		        If buffer <> Nil Then
		          buffer.EndPosition = pos + block.Start
		        Else
		          buffer = New MKInlineText(block)
		          buffer.LineNumber = c.Line.Number
		          buffer.Start = c.AbsolutePosition
		          buffer.ParentStart = pos
		          buffer.LocalStart = c.LocalPosition
		          buffer.EndPosition = pos + block.Start
		        End If
		        pos = pos + 1
		      End If
		      
		    ElseIf c.Value = "<" And Not chars.IsEscaped(pos) Then
		      // ============
		      // INLINE HTML
		      // ============
		      Var html As MarkdownKit.MKInlineHTML = HandleLeftAngleBracket(block, chars, pos)
		      If html <> Nil Then
		        // Found inline HTML.
		        If buffer <> Nil Then FinaliseBuffer(buffer, block)
		        // Add the inline HTML.
		        block.Children.Add(html)
		        // Advance the position.
		        pos = html.LocalRightAnglePos + 1
		      Else
		        If buffer <> Nil Then
		          buffer.EndPosition = pos + block.Start
		        Else
		          buffer = New MKInlineText(block)
		          buffer.LineNumber = c.Line.Number
		          buffer.Start = c.AbsolutePosition
		          buffer.ParentStart = pos
		          buffer.LocalStart = c.LocalPosition
		          buffer.EndPosition = pos + block.Start
		        End If
		        pos = pos + 1
		      End If
		      
		    ElseIf c.Value = "[" And Not chars.IsEscaped(pos) Then
		      // =====================
		      // START OF INLINE LINK?
		      // =====================
		      If buffer <> Nil Then FinaliseBuffer(buffer, block)
		      
		      // Create a new text block for this "[" character.
		      buffer = New MKInlineText(block)
		      buffer.LineNumber = c.Line.Number
		      buffer.Start = c.AbsolutePosition
		      buffer.ParentStart = pos
		      buffer.LocalStart = c.LocalPosition
		      buffer.EndPosition = pos + block.Start // One character long.
		      
		      // Add a delimiter node to the stack pointing to this text block.
		      delimiterStack.Add(New MKDelimiterStackNode(buffer, "["))
		      
		      // Close this text buffer and advance past it.
		      FinaliseBuffer(buffer, block)
		      pos = pos + 1
		      
		    ElseIf c.Value = "!" And Not chars.IsEscaped(pos) And Peek(chars, pos + 1, "[") Then
		      // ======================
		      // START OF INLINE IMAGE?
		      // ======================
		      If buffer <> Nil Then FinaliseBuffer(buffer, block)
		      
		      // Create a new text block for this "![" character sequence.
		      buffer = New MKInlineText(block)
		      buffer.LineNumber = c.Line.Number
		      buffer.Start = c.AbsolutePosition
		      buffer.ParentStart = pos
		      buffer.LocalStart = c.LocalPosition
		      buffer.EndPosition = pos + block.Start + 1 // Two characters long.
		      
		      // Add a delimiter node to the stack pointing to this text block.
		      delimiterStack.Add(New MKDelimiterStackNode(buffer, "!["))
		      
		      // Close this text buffer and advance past it.
		      FinaliseBuffer(buffer, block)
		      pos = pos + 2
		      
		    ElseIf c.Value = "]" And Not chars.IsEscaped(pos) Then
		      // ============================
		      // END OF INLINE LINK OR IMAGE?
		      // ============================
		      If buffer <> Nil Then FinaliseBuffer(buffer, block)
		      
		      If Not LookForLinkOrImage(block, delimiterStack, pos) Then
		        // This is just a literal "]" character, not part of a link or image.
		        If buffer <> Nil Then
		          buffer.EndPosition = pos + block.Start
		        Else
		          // A link or image block will have been inserted as a child of `block` by `LookForLinkOrImage`
		          // so we need to start a new text block.
		          buffer = New MKInlineText(block)
		          buffer.LineNumber = c.Line.Number
		          buffer.Start = c.AbsolutePosition
		          buffer.ParentStart = pos
		          buffer.LocalStart = c.LocalPosition
		          buffer.EndPosition = pos + block.Start
		        End If
		        pos = pos + 1
		      End If
		      
		    ElseIf (c.Value = "*" Or c.Value = "_") And Not chars.IsEscaped(pos) Then
		      // =========
		      // EMPHASIS?
		      // =========
		      If buffer <> Nil Then FinaliseBuffer(buffer, block)
		      Var dsn As MKDelimiterStackNode = ScanDelimiterRun(chars, pos, c.Value)
		      buffer = New MKInlineText(block)
		      buffer.LineNumber = c.Line.Number
		      buffer.Start = c.AbsolutePosition
		      buffer.ParentStart = pos
		      buffer.LocalStart = c.LocalPosition
		      buffer.EndPosition = block.Start + pos + dsn.OriginalLength - 1
		      dsn.TextNode = buffer
		      FinaliseBuffer(buffer, block)
		      pos = pos + dsn.OriginalLength
		      delimiterStack.Add(dsn)
		      
		      // ============
		      // LINE ENDING
		      // ============
		    ElseIf c.IsLineEnding Then
		      If buffer <> Nil Then FinaliseBuffer(buffer, block)
		      If CanContainSoftBreaks(block) Then
		        Var lePos As Integer = If(pos = 0, inlineStart, chars(pos - 1).AbsolutePosition + 1)
		        block.Children.Add(New MKSoftBreak(block, lePos))
		      End If
		      pos = pos + 1
		      Continue
		      
		    Else
		      // This character is not the start of any inline content. If there is an 
		      // open inline text block then append this character to it, otherwise create a 
		      // new open inline text block and append this character to it.
		      If buffer <> Nil Then
		        buffer.EndPosition = pos + block.Start
		      Else
		        buffer = New MKInlineText(block)
		        buffer.LineNumber = c.Line.Number
		        buffer.Start = c.AbsolutePosition
		        buffer.ParentStart = pos
		        buffer.LocalStart = c.LocalPosition
		        buffer.EndPosition = pos + block.Start
		      End If
		      pos = pos + 1
		    End If
		  Wend
		  
		  If buffer <> Nil Then
		    FinaliseBuffer(buffer, block)
		  End If
		  
		  ProcessEmphasis(block, delimiterStack, -1)
		  
		  FinaliseInlineContainer(block)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73205472756520696620746865206368617261637465722061742060636861727328706F732960206973205B636861725D2E
		Private Shared Function Peek(chars() As MKCharacter, pos As Integer, char As String) As Boolean
		  /// Returns True if the character at `chars(pos)` is [char].
		  
		  If pos < 0 Or pos > chars.LastIndex Then Return False
		  Return If(chars(pos).Value = char, True, False)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50726F6365737320616E7920656D70686173697320696E205B636F6E7461696E65725D7320696E6C696E6520626C6F636B732E
		Private Shared Sub ProcessEmphasis(container As MKBlock, ByRef delimiterStack() As MKDelimiterStackNode, stackBottom As Integer)
		  /// Process any emphasis in [container]s inline blocks.
		  ///
		  /// [stackBottom] sets a lower bound to how far we descend in the delimiter stack. If it's `-1`, 
		  /// then we can go all the way to the bottom. Otherwise, we stop before visiting [stackBottom].
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  If delimiterStack.Count = 0 Then Return
		  
		  // Let `currentPosition` point to the element in the delimiter stack just above `stackBottom`
		  // (or the first element if stackBottom = -1).
		  Var currentPosition As Integer = If(stackBottom = -1, 0, stackBottom + 1)
		  
		  // Move `currentPosition` forward in the delimiter stack until we find the first potential 
		  // closer with delimiter `*` or `_`. (This will be the potential closer closest to the 
		  // beginning of the input - the first one in parse order).
		  Var closerNode, openerNode As MKDelimiterStackNode
		  
		  Var incrementCurrentPosition As Boolean = False
		  Var openerTextNode, closerTextNode As MKInlineText
		  Var emphasis As MKAbstractEmphasis
		  Var openerTextNodeIndex, closerTextNodeIndex, numToTranspose, limit As Integer
		  
		  While currentPosition <= delimiterStack.LastIndex
		    closerNode = delimiterStack(currentPosition)
		    If Not closerNode.Ignore And (closerNode.Delimiter = "*" Or closerNode.Delimiter = "_") And closerNode.CanClose Then
		      // Look back in the stack (staying above `stackBottom` and the `openersBottom` for this 
		      // delimiter type) for the first matching potential opener (“matching” means same delimiter).
		      
		      // HACK: Prevent an infinite loop.
		      If currentPosition < stackBottom + 2 Then
		        currentPosition = currentPosition + 1
		        Continue
		      End If
		      
		      For i As Integer = currentPosition - 1 DownTo stackBottom + 1
		        openerNode = delimiterStack(i)
		        If Not openerNode.Ignore And openerNode.CanOpen And openerNode.Delimiter = closerNode.Delimiter Then
		          // Can this opener and closer delimiter pair combination open emphasis?
		          If (openerNode.CanClose And openerNode.CanOpen) Or _
		            (closerNode.CanClose And closerNode.CanOpen) Then
		            If (openerNode.OriginalLength + closerNode.OriginalLength) Mod 3 = 0 Then
		              If openerNode.OriginalLength Mod 3 <> 0 Or closerNode.OriginalLength Mod 3 <> 0 Then
		                // If the closer at `currentPosition` is not a potential opener, remove it from the 
		                // delimiter stack (since we know it can’t be a closer either).
		                If Not closerNode.CanOpen Then closerNode.Ignore = True
		                currentPosition = currentPosition + 1
		                Continue
		              End If
		            End If
		          End If
		          
		          // Strong or regular emphasis? If both closer and opener spans have length >= 2, 
		          // we have strong, otherwise regular.
		          If closerNode.CurrentLength >= 2 And openerNode.CurrentLength >= 2 Then
		            // Strong.
		            emphasis = New MKStrongEmphasis(container, openerNode.TextNode.Start)
		          Else
		            // Regular. 
		            emphasis = New MKEmphasis(container, openerNode.TextNode.Start)
		          End If
		          emphasis.Delimiter = openerNode.Delimiter
		          emphasis.DelimiterLength = openerNode.CurrentLength
		          
		          // Insert the newly created emphasis node, after the text node corresponding to the opener.
		          // Get the index of the opener text node in the container's chidren.
		          openerTextNode = openerNode.TextNode
		          openerTextNodeIndex = openerTextNode.Parent.Children.IndexOf(openerTextNode)
		          If openerTextNodeIndex = -1 Then
		            Raise New MKException("Cannot locate opening emphasis delimiter run text node.")
		          End If
		          openerTextNode.Parent.Children.AddAt(openerTextNodeIndex + 1, emphasis)
		          
		          // Get the index of the closer text node in the container's `Children` array.
		          closerTextNode = closerNode.TextNode
		          closerTextNodeIndex = closerTextNode.Parent.Children.IndexOf(closerTextNode)
		          If closerTextNodeIndex = -1 Then
		            Raise New MKException("Cannot locate closing emphasis delimiter run text node.")
		          End If
		          
		          // Need to move all blocks that occur between `openerTextNodeIndex` and `closerTextNodeIndex` 
		          // into this emphasis node's `Children` array and remove them from the 
		          // container's `Children` array.
		          For x As Integer = openerTextNodeIndex + 2 To closerTextNodeIndex - 1
		            emphasis.Children.Add(container.Children(x))
		            emphasis.Children(emphasis.Children.LastIndex).Parent = emphasis
		          Next x
		          
		          // Remove the transposed inlines from the container.
		          numToTranspose = closerTextNodeIndex - openerTextNodeIndex - 2
		          While numToTranspose > 0
		            openerTextNode.Parent.Children.RemoveAt(openerTextNodeIndex + 2)
		            numToTranspose = numToTranspose - 1
		          Wend
		          
		          // Remove any delimiters between the opener and closer from the delimiter stack.
		          // We do this by setting their `ignore` flag to True.
		          limit = delimiterStack.IndexOf(closerNode) - 1
		          For j As Integer = i + 1 To limit
		            delimiterStack(j).Ignore = True
		          Next j
		          // Remove 1 (for regular emph) or 2 (for strong emphasis) delimiters from the opening 
		          // and closing text nodes. 
		          If emphasis.Type = MKBlockTypes.StrongEmphasis Then
		            // Track the position of the opening delimiter.
		            Call openerNode.TextNode.Characters.Pop
		            
		            Var openingDelimiterChar As MKCharacter = openerNode.TextNode.Characters.Pop
		            emphasis.OpeningDelimiterLineNumber = openingDelimiterChar.Line.Number
		            emphasis.OpeningDelimiterAbsoluteStart = openingDelimiterChar.AbsolutePosition
		            emphasis.OpeningDelimiterLocalStart = openingDelimiterChar.LocalPosition
		            
		            // Track the position of the start of the closing delimiter.
		            Var closingDelimiterChar As MKCharacter = closerNode.TextNode.Characters(0)
		            
		            Call closerNode.TextNode.Characters.Pop
		            Call closerNode.TextNode.Characters.Pop
		            
		            // Compute the locations of the closing delimiter.
		            emphasis.ClosingDelimiterLineNumber = closingDelimiterChar.Line.Number
		            emphasis.ClosingDelimiterAbsoluteStart = closingDelimiterChar.AbsolutePosition + closerNode.PoppedCharacters
		            emphasis.ClosingDelimiterLocalStart = closingDelimiterChar.LocalPosition + closerNode.PoppedCharacters
		            
		            // Track how many characters have been popped so far from this node during processing.
		            closerNode.PoppedCharacters = closerNode.PoppedCharacters + 2
		          Else
		            // Track the position of the opening delimiter.
		            Var openingDelimiterChar As MKCharacter = openerNode.TextNode.Characters.Pop
		            emphasis.OpeningDelimiterLineNumber = openingDelimiterChar.Line.Number
		            emphasis.OpeningDelimiterAbsoluteStart = openingDelimiterChar.AbsolutePosition
		            emphasis.OpeningDelimiterLocalStart = openingDelimiterChar.LocalPosition
		            
		            // Track the position of the start of the closing delimiter.
		            Var closingDelimiterChar As MKCharacter = closerNode.TextNode.Characters(0)
		            
		            Call closerNode.TextNode.Characters.Pop
		            
		            // Compute the locations of the closing delimiter.
		            emphasis.ClosingDelimiterLineNumber = closingDelimiterChar.Line.Number
		            emphasis.ClosingDelimiterAbsoluteStart = closingDelimiterChar.AbsolutePosition + closerNode.PoppedCharacters
		            emphasis.ClosingDelimiterLocalStart = closingDelimiterChar.LocalPosition + closerNode.PoppedCharacters
		            
		            // Track how many characters have been popped so far from this node during processing.
		            closerNode.PoppedCharacters = closerNode.PoppedCharacters + 1
		          End If
		          
		          // If the text node becomes empty as a result, remove it and 
		          // remove the corresponding element of the delimiter stack.
		          openerTextNode = openerNode.TextNode
		          If openerTextNode.Characters.Count = 0 Then
		            openerTextNodeIndex = openerTextNode.Parent.Children.IndexOf(openerTextNode)
		            If openerTextNodeIndex = -1 Then
		              Raise New MKException("Cannot locate opening emphasis delimiter run text node.")
		            End If
		            openerTextNode.Parent.Children.RemoveAt(openerTextNodeIndex)
		            openerNode.Ignore = True
		          End If
		          
		          closerTextNode = closerNode.TextNode
		          If closerTextNode.Characters.Count = 0 Then
		            closerTextNodeIndex = closerTextNode.Parent.Children.IndexOf(closerTextNode)
		            If closerTextNodeIndex = -1 Then
		              Raise New MKException("Cannot locate closing emphasis delimiter run text node.")
		            End If
		            closerTextNode.Parent.Children.RemoveAt(closerTextNodeIndex)
		            closerNode.Ignore = True
		          End If
		          
		          Exit
		          
		        Else
		          // If the closer at `currentPosition` is not a potential opener, remove it from the 
		          // delimiter stack (since we know it can’t be a closer either).
		          If Not closerNode.CanOpen Then closerNode.Ignore = True
		          incrementCurrentPosition = True
		        End If
		      Next i
		    Else
		      currentPosition = currentPosition + 1
		    End If
		    
		    If incrementCurrentPosition Then
		      currentPosition = currentPosition + 1
		      incrementCurrentPosition = False
		    End If
		  Wend
		  
		  // Remove all delimiters above `stackBottom` from the delimiter stack.
		  For i As Integer = stackBottom + 1 To delimiterStack.LastIndex
		    delimiterStack(i).Ignore = True
		  Next i
		  For i As Integer = delimiterStack.LastIndex DownTo 0
		    If delimiterStack(i).Ignore Then delimiterStack.RemoveAt(i)
		  Next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5363616E73205B63686172735D2066726F6D205B706F735D20666F7220612072756E206F6620656D7068617369732E2052657475726E7320612064656C696D6974657220737461636B206E6F6465207769746820696E666F726D6174696F6E2061626F7574207468652072756E2E
		Private Shared Function ScanDelimiterRun(chars() As MKCharacter, pos As Integer, delimiter As String) As MKDelimiterStackNode
		  /// Scans [chars] from [pos] for a run of emphasis. Returns a delimiter stack node with 
		  /// information about the run.
		  ///
		  /// Assumes `chars(pos)` points to the begining of the emphasis run.
		  /// [delimiter] is either "*" or "_".
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var startPos As integer = pos
		  Var charsLastIndex As Integer = chars.LastIndex
		  Var dsn As New MKDelimiterStackNode(Nil, delimiter)
		  
		  For pos = pos + 1 To charsLastIndex
		    If chars(pos).Value = delimiter Then
		      dsn.OriginalLength = dsn.OriginalLength + 1
		    Else
		      Exit
		    End If
		  Next pos
		  
		  // `pos` currently points at the character following the end of the run.
		  Var beforeIsWhitespace As Boolean
		  If startPos = 0 Then
		    beforeIsWhitespace = True
		  Else
		    beforeIsWhitespace = If(chars(startPos - 1 ).IsMarkdownWhitespace(True), True, False)
		  End If
		  
		  Var afterIsWhitespace As Boolean
		  If pos >= charsLastIndex Then
		    afterIsWhitespace = True
		  Else
		    afterIsWhitespace = If(chars(pos).IsMarkdownWhitespace(True), True, False)
		  End If
		  
		  Var beforeIsPunctuation As Boolean = If(startPos = 0 Or Not chars(startPos - 1).IsPunctuation, False, True)
		  Var afterIsPunctuation As Boolean = If(pos >= charsLastIndex Or Not chars(pos).IsPunctuation, False, True)
		  
		  // Left flanking?
		  Var leftFlanking As Boolean = Not afterIsWhitespace And _
		  (Not afterIsPunctuation Or (afterIsPunctuation And (beforeIsWhitespace Or beforeIsPunctuation)))
		  
		  // Right flanking?
		  Var rightFlanking As Boolean = Not beforeIsWhitespace And _
		  (Not beforeIsPunctuation Or (beforeIsPunctuation And (afterIsWhitespace Or afterIsPunctuation)))
		  
		  // Opener?
		  If delimiter = "*" Then
		    dsn.CanOpen = leftFlanking
		  Else // _
		    dsn.CanOpen = leftFlanking And (Not rightFlanking Or (rightFlanking And beforeIsPunctuation))
		  End If
		  
		  // Closer?
		  If delimiter = "*" Then
		    dsn.CanClose = rightFlanking
		  Else // _
		    dsn.CanClose = rightFlanking And (Not leftFlanking Or (leftFlanking And afterIsPunctuation))
		  End If
		  
		  Return dsn
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5363616E73205B636F6E7461696E65722E436861726163746572735D2066726F6D2074686520626567696E6E696E67206F662074686520617272617920666F7220616E20696E6C696E6520696D6167652E2052657475726E732074686520696D616765206461746120696620666F756E64206F72204E696C206966206E6F742E
		Private Shared Function ScanForInlineImage(ByRef container As MKBlock, startPos As Integer, closerCharPos As Integer) As MKInlineLinkData
		  /// Scans [container.Characters] from the beginning of the array for an inline image. 
		  /// Returns the image data if found or Nil if not.
		  ///
		  /// Assumes `container.Characters(startPos) = "!"` and `container.Characters(startPos + 1) = "["`.
		  /// Assumes `container.Characters(closerCharPos)` is the index of a "]" character.
		  
		  Var chars() As MKCharacter = container.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  Var pos As Integer = startPos
		  
		  // Skip past the opening "![".
		  pos = pos + 2
		  If pos > charsLastIndex Then Return Nil
		  
		  // Valid images start with either an "image description" or a "link label".
		  // Link labels can't contain unescaped brackets and must contain at least one non-whitespace character.
		  Var tmpCharacters() As MKCharacter
		  Var indexOfLastClosingSquareBracket As Integer = -1
		  Var openSquareBracketCount As Integer = 1
		  Var closeSquareBracketCount As Integer = 0
		  Var hasUnescapedBracket As Boolean = False
		  
		  // Compute the absolute and local positions of the first `!` and `]` characters (the image opener and 
		  // closer characters). These are needed for rendering tokens.
		  Var openerChar As MKCharacter = container.Characters(startPos)
		  Var closerChar As MKCharacter = container.Characters(closerCharPos)
		  
		  // Check for unbalanced brackets and get all characters making up the link text.
		  For i As Integer = 0 To closerCharPos
		    Var c As MKCharacter = chars(i)
		    If c.Value = "]" And Not chars.IsEscaped(i) Then
		      hasUnescapedBracket = True
		      indexOfLastClosingSquareBracket = i
		      closeSquareBracketCount = closeSquareBracketCount + 1
		      
		    ElseIf c.Value = "[" And Not chars.IsEscaped(i) Then
		      hasUnescapedBracket = True
		      openSquareBracketCount = openSquareBracketCount + 1
		      
		    ElseIf i > startPos + 1 Then // Only add characters occurring after the start position.
		      tmpCharacters.Add(c)
		    End If
		  Next i
		  
		  // If we didn't see a closing bracket or we have unbalanced brackets then there's no valid image.
		  If indexOfLastClosingSquareBracket = -1 Then Return Nil
		  If Not hasUnescapedBracket And openSquareBracketCount <> closeSquareBracketCount Then Return Nil
		  
		  // Remove characters from `tmpCharacters` from the closing "]" onwards.
		  Var charsToRemove As Integer = closerCharPos - indexOfLastClosingSquareBracket
		  For i As Integer = 1 To charsToRemove
		    Call tmpCharacters.Pop
		  Next i
		  
		  // Valid link label?
		  Var linkLabel As String
		  Var validLinkLabel As Boolean = False
		  If tmpCharacters.Count > 0 Then
		    linkLabel = tmpCharacters.ToString
		    If container.Document.References.HasKey(linkLabel.Lowercase) Then
		      validLinkLabel = True
		    End If
		  End If
		  
		  // Move past the closing part1 square bracket.
		  pos = indexOfLastClosingSquareBracket + 1
		  
		  // Shortcut reference image?
		  If validLinkLabel And Not Peek(chars, pos, "(") Then
		    If pos >= charsLastIndex Or pos + 1 > charsLastIndex Then
		      // Found a shortcut reference image.
		      Return CreateReferenceLinkData(container, linkLabel, tmpCharacters, pos - 1, True, _
		      openerChar, closerChar, MKLinkTypes.ShortcutReference)
		    ElseIf chars(pos).Value <> "[" And chars(pos + 1).Value <> "]" Then
		      // Found a shortcut reference link.
		      Return CreateReferenceLinkData(container, linkLabel, tmpCharacters, pos - 1, True, _
		      openerChar, closerChar, MKLinkTypes.ShortcutReference)
		    End If
		  End If
		  
		  // Collapsed reference image?
		  If validLinkLabel Then
		    If pos + 1 <= charsLastIndex And chars(pos).Value = "[" And chars(pos + 1).Value = "]" Then
		      // Found a collapsed reference image.
		      Return CreateReferenceLinkData(container, linkLabel, tmpCharacters, pos + 1, True, _
		      openerChar, closerChar, MKLinkTypes.CollapsedReference)
		    End If
		  End If
		  
		  // At this point, we know that tmpCharacters must represent an image description 
		  // rather than a defined link label. Look ahead beyond the `]`...
		  If pos > charsLastIndex Then Return Nil
		  If chars(pos).Value = "(" Then
		    // Could be an inline image.
		    Var result As MKInlineLinkData = InlineLinkData(openerChar, closerChar, chars, tmpCharacters, pos, True)
		    If result = Nil And validLinkLabel Then
		      // Edge case: Could still be a shortcut reference image immediately followed by a "(".
		      Return CreateReferenceLinkData(container, linkLabel, tmpCharacters, pos - 1, True, _
		      openerChar, closerChar, MKLinkTypes.ShortcutReference)
		    Else
		      Return result
		    End If
		    
		  ElseIf chars(pos).Value = "[" Then
		    // Could be a full reference image.
		    Return FullReferenceLinkData(container, chars, tmpCharacters, pos, True, openerChar, closerChar)
		  Else
		    Return Nil
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5363616E73205B636F6E7461696E65722E436861726163746572735D2066726F6D2074686520626567696E6E696E67206F662074686520617272617920666F7220616E20696E6C696E65206C696E6B2E2052657475726E7320746865206C696E6B206461746120696620666F756E64206F72204E696C206966206E6F742E
		Private Shared Function ScanForInlineLink(ByRef container As MKBlock, startPos As Integer, closerCharPos As Integer) As MKInlineLinkData
		  /// Scans [container.Characters] from the beginning of the array for an inline link. 
		  /// Returns the link data if found or Nil if not.
		  ///
		  /// Assumes `container.Characters(startPos) = "["`.
		  /// Assumes `container.Characters(closerCharPos)` is the index of a "]" character.
		  
		  Var pos As Integer = startPos
		  Var chars() As MKCharacter = container.Characters
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Skip past the opening "[".
		  pos = pos + 1
		  If pos > charsLastIndex Then Return Nil
		  
		  // Valid links start with "link text" (which may be a link label) flanked by [].
		  // Link text can't contain unescaped brackets and must contain at least one non-whitespace character.
		  Var linkTextChars() As MKCharacter
		  Var indexOfLastClosingSquareBracket As Integer = -1
		  Var openSquareBracketCount As Integer = 1
		  Var closeSquareBracketCount As Integer = 0
		  Var hasUnescapedBracket As Boolean = False
		  
		  // Compute the absolute and local positions of the first `[` and `]` characters (the link opener and 
		  // closer characters). These are needed for rendering tokens.
		  Var openerChar As MKCharacter = container.Characters(startPos)
		  Var closerChar As MKCharacter = container.Characters(closerCharPos)
		  
		  // Check for unbalanced brackets and get all characters making up the link text.
		  For i As Integer = 0 To closerCharPos
		    Var c As MKCharacter = chars(i)
		    
		    If c.Value = "]" And Not chars.IsEscaped(i) Then
		      hasUnescapedBracket = True
		      indexOfLastClosingSquareBracket = i
		      closeSquareBracketCount = closeSquareBracketCount + 1
		      
		    ElseIf c.Value = "[" And Not chars.IsEscaped(i) Then
		      hasUnescapedBracket = True
		      openSquareBracketCount = openSquareBracketCount + 1
		      
		    ElseIf i > startPos Then // Only add characters occurring after the start position.
		      linkTextChars.Add(c)
		    End If
		  Next i
		  
		  // If we didn't see a closing bracket or we have unbalanced brackets then there's no valid link.
		  If indexOfLastClosingSquareBracket = -1 Then Return Nil
		  If Not hasUnescapedBracket And openSquareBracketCount <> closeSquareBracketCount Then Return Nil
		  
		  // Remove characters from `tmpCharacters` from the closing "]" onwards.
		  Var charsToRemove As Integer = closerCharPos - indexOfLastClosingSquareBracket
		  For i As Integer = 1 To charsToRemove
		    Call linkTextChars.Pop
		  Next i
		  
		  // Valid link label?
		  Var linkLabel As String
		  Var validLinkLabel As Boolean = False
		  If linkTextChars.Count > 0 Then
		    // Consecutive internal whitespace is treated as one space for purposes of determining matching
		    linkLabel = linkTextChars.ToString
		    If container.Document.References.HasKey(linkLabel.Lowercase) Then
		      validLinkLabel = True
		    End If
		  End If
		  
		  // Move past the closing square bracket.
		  pos = indexOfLastClosingSquareBracket + 1
		  
		  // Shortcut reference link?
		  If validLinkLabel And Not Peek(chars, pos, "(") Then
		    If pos >= charsLastIndex Or pos + 1 > charsLastIndex Then
		      // Found a shortcut reference link.
		      Return CreateReferenceLinkData(container, linkLabel, linkTextChars, pos - 1, False, _
		      openerChar, closerChar, MKLinkTypes.ShortcutReference)
		    ElseIf chars(pos).Value <> "[" And chars(pos + 1).Value <> "]" Then
		      // Found a shortcut reference link.
		      Return CreateReferenceLinkData(container, linkLabel, linkTextChars, pos - 1, False, _
		      openerChar, closerChar, MKLinkTypes.ShortcutReference)
		    End If
		  End If
		  
		  // Collapsed reference link?
		  If validLinkLabel Then
		    If pos + 1 <= charsLastIndex And chars(pos).Value = "[" And chars(pos + 1).Value = "]" Then
		      // Found a collapsed reference link.
		      Return CreateReferenceLinkData(container, linkLabel, linkTextChars, pos + 1, False, _
		      openerChar, closerChar, MKLinkTypes.CollapsedReference)
		    End If
		  End If
		  
		  // At this point, we know that tmpCharacters must represent link text rather than a defined link label.
		  // Look ahead beyond the `]`...
		  If pos > charsLastIndex Then Return Nil
		  If chars(pos).Value = "(" Then
		    // Could be an inline link.
		    Var result As MKInlineLinkData = InlineLinkData(openerChar, closerChar, chars, linkTextChars, pos, False)
		    If result = Nil And validLinkLabel Then
		      // Edge case: Could still be a shortcut reference link immediately followed by a "(".
		      Return CreateReferenceLinkData(container, linkLabel, linkTextChars, pos - 1, False, _
		      openerChar, closerChar, MKLinkTypes.ShortcutReference)
		    Else
		      Return result
		    End If
		    
		  ElseIf chars(pos).Value = "[" Then
		    // Could be a full reference link.
		    Return FullReferenceLinkData(container, chars, linkTextChars, pos, False, openerChar, closerChar)
		  Else
		    Return Nil
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ScanInlineLinkDestination(chars() As MKCharacter, ByRef pos As Integer) As String
		  /// Starting at [pos], scans the [chars] for a valid link URL. Returns the URL or "" if there is none.
		  /// Mutates [pos].
		  ///
		  /// If the URL is flanked by "<>" (scenario 1) they are removed from the URL before returning.
		  
		  // Two kinds of link destinations:
		  // 1. A sequence of zero or more characters between an opening < and a closing > 
		  //    that contains no line breaks or unescaped < or > characters.
		  // 2. A non-empty sequence of characters that does not start with <, does not 
		  //    include ASCII space or control characters, and includes parentheses only 
		  //    if (a) they are backslash-escaped or (b) they are part of a balanced pair 
		  //    of unescaped parentheses.
		  
		  // Since we are looking for an inline link destination, we may encounter either a 
		  // closing ")" (representing the end of the inline link definition without providing 
		  // a title) or whitespace followed by the " character (indicating a trailing title).
		  
		  Var i As Integer
		  Var c As MKCharacter
		  
		  Var startPos As Integer = pos
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Sanity check.
		  If pos > charsLastIndex Then Return ""
		  
		  // Scenario 1:
		  If chars(pos).Value = "<" Then
		    i = pos + 1
		    While i <= charsLastIndex
		      c = chars(i)
		      If c.Value = ">" And Not chars.IsEscaped(i) Then
		        pos = i + 1
		        Return chars.ToString(startPos + 1, i - startPos - 1)
		      End If
		      If c.Value = "<" And Not chars.IsEscaped(i) Then Return ""
		      If c.IsLineEnding Then Return ""
		      i = i + 1
		    Wend
		    Return ""
		  End If
		  
		  // Scenario 2:
		  Var unmatchedOpenParens As Integer = 1 // Account for the opening parens we've already seen.
		  For i = startPos To charsLastIndex
		    
		    c = chars(i)
		    If c.Value = "(" Then
		      If chars.IsEscaped(i) Then Continue
		      unmatchedOpenParens = unmatchedOpenParens + 1
		      
		    ElseIf c.Value = ")" Then
		      If chars.IsEscaped(i) Then Continue
		      unmatchedOpenParens = unmatchedOpenParens - 1
		      If i = charsLastIndex Or chars(i + 1).IsLineEnding Then
		        If unmatchedOpenParens = 0 Then
		          pos = i
		          Var destination As String = chars.ToString(startPos, i - startPos)
		          Return MarkdownKit.ReplaceEntities(destination)
		        Else
		          Return ""
		        End If
		      End If
		      If unmatchedOpenParens = 0 Then
		        pos = i
		        Var destination As String = chars.ToString(startPos, i - startPos)
		        Return MarkdownKit.ReplaceEntities(destination)
		      End If
		      
		    ElseIf c.Value = &u0000 Or c.Value = &u0009 Then
		      Return ""
		      
		    ElseIf c.IsLineEnding Then
		      pos = i
		      Return chars.ToString(startPos, i - startPos)
		      
		    ElseIf c.Value = " " Then
		      If unmatchedOpenParens = 1 Then
		        pos = i
		        Var destination As String = chars.ToString(startPos, i - startPos)
		        Return MarkdownKit.ReplaceEntities(destination)
		      Else
		        Return ""
		      End If
		    End If
		  Next i
		  
		  If unmatchedOpenParens = 0 Then
		    pos = i
		    Var destination As String = chars.ToString(startPos, pos - startPos)
		    Return MarkdownKit.ReplaceEntities(destination)
		  Else
		    Return ""
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5363616E73205B63686172735D2C207374617274696E67206174205B706F735D2C20666F7220612076616C6964206C696E6B207469746C652E2052657475726E7320746865207469746C65206F722022206966207468657265206973206E6F6E652E204D757461746573205B706F735D20746F2074686520706F736974696F6E2061667465722074686520636C6F73696E67207469746C652064656C696D697465722E
		Private Shared Function ScanInlineLinkTitle(chars() As MKCharacter, ByRef pos As Integer) As String
		  /// Scans [chars], starting at [pos], for a valid link title. Returns the title or " if there is none. 
		  /// Mutates [pos] to the position after the closing title delimiter.
		  ///
		  /// There are 3 valid types of link title:
		  /// 1. >= 0 characters between straight " characters including a " character only if it is backslash-escaped.
		  /// 2. >= 0 characters between ' characters, including a ' character only if it is backslash-escaped.
		  /// 3. >= 0 characters between matching parentheses ((...)), including a ( or ) character only if 
		  ///    it's backslash-escaped.
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  Var startPos As Integer = pos
		  
		  // Sanity check.
		  If startPos > charsLastIndex Or (startPos + 1) > charsLastIndex Then Return ""
		  
		  Var delimiter As String
		  Var c As String = chars(pos).Value
		  Select Case c
		  Case """", "'"
		    delimiter = c
		  Case "("
		    delimiter = ")"
		  Else
		    Return ""
		  End Select
		  
		  For i As Integer = pos + 1 To charsLastIndex
		    c = chars(i).Value
		    If c = delimiter And Not chars.IsEscaped(i) Then
		      pos = i + 1
		      Var title As String = chars.ToString(startPos + 1, i - startPos - 1)
		      Return MarkdownKit.ReplaceEntities(title)
		    End If
		  Next i
		  
		  Return ""
		  
		End Function
	#tag EndMethod


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
