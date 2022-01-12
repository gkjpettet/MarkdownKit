#tag Class
Protected Class ASTTokenArrayRenderer
Implements MKRenderer
	#tag Method, Flags = &h0
		Function VisitATXHeading(atx As MKATXHeadingBlock) As Variant
		  // Part of the MKRenderer interface.
		  
		  // Opening sequence.
		  Tokens.Add(New LineToken(atx.OpeningSequenceAbsoluteStart, atx.OpeningSequenceLocalStart, _
		  atx.Level, atx.LineNumber, "atxDelimiter"))
		  
		  IsWithinATXHeading = True
		  
		  For Each child As MKBlock In atx.Children
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
		Function VisitBlock(b As MKBlock) As Variant
		  /// Part of the MKRenderer interface.
		  ///
		  /// Nothing to do.
		  
		  #Pragma Unused b
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitBlockQuote(bq As MKBlockQuote) As Variant
		  // Part of the MKRenderer interface.
		  
		  Tokens.Add(New LineToken(bq.AbsoluteOpenerStart, bq.LocalOpenerStart, 1, bq.LineNumber, "blockQuote"))
		  
		  For Each child As MKBlock In bq.Children
		    Call child.Accept(Self)
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitCodeSpan(cs As MKCodeSpan) As Variant
		  // Part of the MKRenderer interface.
		  
		  // Opening delimiter.
		  Tokens.Add(New LineToken(cs.Start, cs.LocalStart, cs.BacktickStringLength, cs.LineNumber, "codespanDelimiter"))
		  
		  IsWithinCodeSpan = True
		  
		  For Each child As MKBlock In cs.Children
		    Call child.Accept(Self)
		  Next child
		  
		  IsWithinCodeSpan = False
		  
		  // Closing delimiter.
		  Tokens.Add(New LineToken(cs.ClosingBacktickStringStart, cs.ClosingBacktickStringLocalStart, _
		  cs.BacktickStringLength, cs.LineNumber, "codespanDelimiter"))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitDocument(doc As MKDocument) As Variant
		  /// Part of the MKRenderer interface.
		  
		  Tokens.RemoveAll
		  InEmphasis = False
		  InStrongEmphasis = False
		  IsWithinCodeSpan = False
		  IsWithinATXHeading = False
		  
		  For Each child As MKBlock In doc.Children
		    Call child.Accept(Self)
		  Next child
		  
		  Return Tokens
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitEmphasis(e As MKEmphasis) As Variant
		  // Part of the MKRenderer interface.
		  
		  Var wasInEmphasis As Boolean = InEmphasis
		  
		  InEmphasis = True
		  
		  // Opening delimiter.
		  Tokens.Add(New LineToken( _
		  e.OpeningDelimiterAbsoluteStart, e.OpeningDelimiterLocalStart, 1, e.OpeningDelimiterLineNumber, _
		  "emphasisDelimiter"))
		  
		  For Each child As MKBlock In e.Children
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
		Function VisitFencedCode(fc As MKFencedCodeBlock) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitHTMLBlock(html As MKHTMLBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  For Each child As MKBlock In html.Children
		    Call child.Accept(Self)
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitIndentedCode(ic As MKIndentedCodeBlock) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineHTML(html As MKInlineHTML) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineImage(image As MKInlineImage) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineLink(link As MKInlineLink) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitInlineText(it As MKInlineText) As Variant
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
		    
		  Else
		    type = "default"
		    
		  End If
		  
		  Tokens.Add(New LineToken(it.Start, it.LocalStart, it.Characters.Count, it.LineNumber, type))
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitList(list As MKBlock) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitListItem(item As MKBlock) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitParagraph(p As MKParagraphBlock) As Variant
		  /// Part of the MKRenderer interface.
		  
		  For Each child As MKBlock In p.Children
		    Call child.Accept(Self)
		  Next child
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSetextHeading(stx As MKSetextHeadingBlock) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitSoftBreak(sb As MKSoftBreak) As Variant
		  /// Part of the MKRenderer interface.
		  ///
		  /// Nothing to do.
		  
		  #Pragma Unused sb
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function VisitStrongEmphasis(se As MKStrongEmphasis) As Variant
		  // Part of the MKRenderer interface.
		  
		  Var wasInStrongEmphasis As Boolean = InStrongEmphasis
		  
		  InStrongEmphasis = True
		  
		  // Opening delimiter.
		  Tokens.Add(New LineToken( _
		  se.OpeningDelimiterAbsoluteStart, se.OpeningDelimiterLocalStart, 2, se.OpeningDelimiterLineNumber, _
		  "strongEmphasisDelimiter"))
		  
		  For Each child As MKBlock In se.Children
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
		Function VisitTextBlock(tb As MKTextBlock) As Variant
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
		Function VisitThematicBreak(tb As MKBlock) As Variant
		  // Part of the MKRenderer interface.
		  #Pragma Warning  "Needs implementing"
		  
		  
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
	#tag EndViewBehavior
End Class
#tag EndClass
