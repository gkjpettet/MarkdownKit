#tag Class
Protected Class ASTTokenArrayRenderer
Implements MarkdownKit.MKRenderer
	#tag Method, Flags = &h21, Description = 536F72747320616E206172726179206F66204C696E65546F6B656E73206279207468656972206162736F6C75746520706F736974696F6E2E
		Private Function SortTokensByAbsolutePosition(tok1 As LineToken, tok2 As LineToken) As Integer
		  /// Sorts an array of LineTokens by their absolute position.
		  
		  If tok1.StartAbsolute < tok2.StartAbsolute Then
		    Return -1
		  ElseIf tok1.StartAbsolute > tok2.StartAbsolute Then
		    Return 1
		  Else
		    Return 0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitATXHeading(atx As MarkdownKit.MKATXHeadingBlock) As Variant
		  // Part of the MKRenderer interface.
		  
		  // Opening sequence.
		  Tokens.Add(New LineToken(atx.OpeningSequenceAbsoluteStart, atx.OpeningSequenceLocalStart, _
		  atx.Level, atx.LineNumber, "atxDelimiter"))
		  
		  IsWithinATXHeading = True
		  
		  For Each child As MarkdownKit.MKBlock In atx.Children
		    Call child.Accept(Self)
		  Next child
		  
		  IsWithinATXHeading = False
		  
		  // Closing sequence.
		  If atx.HasClosingSequence Then
		    Tokens.Add(New LineToken(atx.ClosingSequenceAbsoluteStart, atx.ClosingSequenceLocalStart, _
		    atx.ClosingSequenceCount, atx.LineNumber, "atxDelimiter"))
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlock(b As MarkdownKit.MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  ///
		  /// Nothing to do.
		  
		  #Pragma Unused b
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlockQuote(bq As MarkdownKit.MKBlockQuote) As Variant
		  // Part of the MKRenderer interface.
		  
		  // Add the block quote opening delimiters.
		  For Each delimiter As MarkdownKit.MKCharacter In bq.OpeningDelimiters
		    Tokens.Add(New LineToken(delimiter.AbsolutePosition, delimiter.LocalPosition, 1, _
		    delimiter.Line.Number, "blockQuoteDelimiter"))
		  Next delimiter
		  
		  For Each child As MarkdownKit.MKBlock In bq.Children
		    Call child.Accept(Self)
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitCodeSpan(cs As MarkdownKit.MKCodeSpan) As Variant
		  // Part of the MKRenderer interface.
		  
		  // Opening delimiter.
		  Tokens.Add(New LineToken(cs.Start, cs.LocalStart, cs.BacktickStringLength, cs.LineNumber, "codespanDelimiter"))
		  
		  IsWithinCodeSpan = True
		  
		  For Each child As MarkdownKit.MKBlock In cs.Children
		    Call child.Accept(Self)
		  Next child
		  
		  IsWithinCodeSpan = False
		  
		  // Closing delimiter.
		  Tokens.Add(New LineToken(cs.ClosingBacktickStringStart, cs.ClosingBacktickStringLocalStart, _
		  cs.BacktickStringLength, cs.LineNumber, "codespanDelimiter"))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitDocument(doc As MarkdownKit.MKDocument) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Tokens.RemoveAll
		  InEmphasis = False
		  InStrongEmphasis = False
		  IsWithinCodeSpan = False
		  IsWithinATXHeading = False
		  IsWithinSetextHeading = False
		  
		  For Each child As MarkdownKit.MKBlock In doc.Children
		    Call child.Accept(Self)
		  Next child
		  
		  Tokens.Sort(AddressOf SortTokensByAbsolutePosition)
		  
		  Return Tokens
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitEmphasis(e As MarkdownKit.MKEmphasis) As Variant
		  // Part of the MKRenderer interface.
		  
		  Var wasInEmphasis As Boolean = InEmphasis
		  
		  InEmphasis = True
		  
		  // Opening delimiter.
		  Tokens.Add(New LineToken( _
		  e.OpeningDelimiterAbsoluteStart, e.OpeningDelimiterLocalStart, 1, e.OpeningDelimiterLineNumber, _
		  "emphasisDelimiter"))
		  
		  For Each child As MarkdownKit.MKBlock In e.Children
		    Call child.Accept(Self)
		  Next child
		  
		  // Closing delimiter.
		  Tokens.Add(New LineToken( _
		  e.ClosingDelimiterAbsoluteStart, e.ClosingDelimiterLocalStart, 1, e.ClosingDelimiterLineNumber, _
		  "emphasisDelimiter"))
		  
		  InEmphasis = wasInEmphasis
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitFencedCode(fc As MarkdownKit.MKFencedCodeBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  // Opening delimiter.
		  Tokens.Add(New LineToken(fc.Start, fc.OpeningFenceLocalStart, fc.FenceLength, fc.LineNumber, "fenceDelimiter"))
		  
		  // Info string?
		  If fc.HasInfoString Then
		    Tokens.Add(New LineToken(fc.InfoStringStart, fc.InfoStringLocalStart, _
		    fc.InfoStringLength, fc.LineNumber, "infoString"))
		  End If
		  
		  // Contents.
		  For Each child As MarkdownKit.MKBlock In fc.Children
		    Var codeLine As MarkdownKit.MKTextBlock = MarkdownKit.MKTextBlock(child)
		    Tokens.Add(New LineToken(codeLine.Start, codeLine.LocalStart, _
		    codeLine.Contents.CharacterCount, codeLine.Line.Number, "codeLine"))
		  Next child
		  
		  // Closing delimiter.
		  Tokens.Add(New LineToken(fc.ClosingFenceStart, fc.ClosingFenceLocalStart, _
		  fc.FenceLength, fc.ClosingFenceLineNumber, "fenceDelimiter"))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHTMLBlock(html As MarkdownKit.MKHTMLBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  For Each child As MarkdownKit.MKBlock In html.Children
		    Call child.Accept(Self)
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIndentedCode(ic As MarkdownKit.MKIndentedCodeBlock) As Variant
		  // Part of the MKRenderer interface.
		  
		  For Each child As MarkdownKit.MKBlock In ic.Children
		    Var codeLine As MarkdownKit.MKTextBlock = MarkdownKit.MKTextBlock(child)
		    Tokens.Add(New LineToken(codeLine.Start, codeLine.LocalStart, _
		    codeLine.Contents.CharacterCount, codeLine.Line.Number, "codeLine"))
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineHTML(html As MarkdownKit.MKInlineHTML) As Variant
		  /// Part of the MKRenderer interface.
		  
		  For Each child As MarkdownKit.MKBlock In html.Children
		    Var tb As MarkdownKit.MKTextBlock = MarkdownKit.MKTextBlock(child)
		    Tokens.Add(New LineToken(tb.Start, tb.LocalStart, tb.Contents.CharacterCount, tb.Line.Number, "inlineHTML"))
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineImage(image As MarkdownKit.MKInlineImage) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineLink(link As MarkdownKit.MKInlineLink) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineText(it As MarkdownKit.MKInlineText) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Var type As String
		  
		  If IsWithinATXHeading Then
		    type = "atx"
		    
		  ElseIf IsWithinCodeSpan Then
		    type = "codeSpan"
		    
		  ElseIf InEmphasis And InStrongEmphasis Then
		    type = "strongAndEmphasis"
		    
		  ElseIf InEmphasis Then
		    type = "emphasis"
		    
		  ElseIf InStrongEmphasis Then
		    type = "strong"
		    
		  ElseIf IsWithinSetextHeading Then
		    type = "setext"
		    
		  Else
		    type = "default"
		    
		  End If
		  
		  Tokens.Add(New LineToken(it.Start, it.LocalStart, it.Characters.Count, it.LineNumber, type))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitList(list As MarkdownKit.MKListBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  For Each child As MarkdownKit.MKBlock In list.Children
		    Call child.Accept(Self)
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitListItem(item As MarkdownKit.MKListItemBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  // List marker.
		  Tokens.Add(New LineToken(item.Start, item.ListData.LinePosition, item.ListData.MarkerWidth, _
		  item.LineNumber, "listMarker"))
		  
		  // Children.
		  For Each child As MarkdownKit.MKBlock In item.Children
		    Call child.Accept(Self)
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParagraph(p As MarkdownKit.MKParagraphBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  For Each child As MarkdownKit.MKBlock In p.Children
		    Call child.Accept(Self)
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSetextHeading(stx As MarkdownKit.MKSetextHeadingBlock) As Variant
		  // Part of the MKRenderer interface.
		  
		  IsWithinSetextHeading = True
		  
		  For Each child As MarkdownKit.MKBlock In stx.Children
		    Call child.Accept(Self)
		  Next child
		  
		  IsWithinSetextHeading = False
		  
		  Tokens.Add(New LineToken(stx.UnderlineStart, stx.UnderlineLocalStart, _
		  stx.UnderlineLength, stx.UnderlineLineNumber, "setextUnderline"))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSoftBreak(sb As MarkdownKit.MKSoftBreak) As Variant
		  /// Part of the MKRenderer interface.
		  ///
		  /// Nothing to do.
		  
		  #Pragma Unused sb
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitStrongEmphasis(se As MarkdownKit.MKStrongEmphasis) As Variant
		  // Part of the MKRenderer interface.
		  
		  Var wasInStrongEmphasis As Boolean = InStrongEmphasis
		  
		  InStrongEmphasis = True
		  
		  // Opening delimiter.
		  Tokens.Add(New LineToken( _
		  se.OpeningDelimiterAbsoluteStart, se.OpeningDelimiterLocalStart, 2, se.OpeningDelimiterLineNumber, _
		  "strongEmphasisDelimiter"))
		  
		  For Each child As MarkdownKit.MKBlock In se.Children
		    Call child.Accept(Self)
		  Next child
		  
		  // Closing delimiter.
		  Tokens.Add(New LineToken( _
		  se.ClosingDelimiterAbsoluteStart, se.ClosingDelimiterLocalStart, 2, se.ClosingDelimiterLineNumber, _
		  "strongEmphasisDelimiter"))
		  
		  InStrongEmphasis = wasInStrongEmphasis
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitTextBlock(tb As MarkdownKit.MKTextBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  If tb.IsBlank Then Return Nil
		  
		  Var type As String
		  If IsWithinCodeSpan Then
		    type = "codespan"
		  Else
		    type = "default"
		  End If
		  
		  Tokens.Add(New LineToken(tb.Start, tb.LocalStart, tb.Contents.CharacterCount, tb.Line.Number, type))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitThematicBreak(tb As MarkdownKit.MKThematicBreak) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Tokens.Add(New LineToken(tb.Start, tb.LocalStart, tb.Length, tb.LineNumber))
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 54727565206966207468652072656E64657265722069732063757272656E746C792077697468696E20656D7068617369732E
		Private InEmphasis As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54727565206966207468652072656E64657265722069732063757272656E746C792077697468696E207374726F6E6720656D7068617369732E
		Private InStrongEmphasis As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468652072656E64657265722069732063757272656E746C792077697468696E20616E204154582068656164696E672E
		IsWithinATXHeading As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		IsWithinCodeSpan As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468652072656E64657265722069732063757272656E746C792077697468696E2061207365746578742068656164696E672E
		IsWithinSetextHeading As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Tokens() As LineToken
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
			Name="IsWithinATXHeading"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsWithinCodeSpan"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsWithinSetextHeading"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
