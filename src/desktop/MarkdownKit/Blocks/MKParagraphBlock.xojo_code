#tag Class
Protected Class MKParagraphBlock
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStart As Integer)
		  Super.Constructor(MKBlockTypes.Paragraph, parent, blockStart)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As TextLine)
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  ParseLinkReferenceDefinitions
		  
		  // Remove this paragraph from its parent if it's empty.
		  If Characters.Count = 0 And Parent <> Nil Then
		    Var parentIndex As Integer = Parent.Children.IndexOf(Self)
		    If parentIndex <> -1 Then Parent.Children.RemoveAt(parentIndex)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D617463686573207768697465737061636520696E205B63686172735D20626567696E6E696E67206174205B706F735D20616E642072657475726E7320686F77206D616E7920636861726163746572732077657265206D6174636865642E
		Private Function MatchWhitespaceCharactersInArray(chars() As String, pos As Integer) As Integer
		  /// Matches whitespace in [chars] beginning at [pos] and returns how many characters were matched.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Sanity check.
		  If pos > charsLastIndex Then Return 0
		  
		  For i As Integer = pos To charsLastIndex
		    If Not chars(i).IsMarkdownWhitespace Then Return i - pos
		  Next i
		  
		  Return (charsLastIndex + 1)- pos
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E79206C696E6B207265666572656E636520646566696E6974696F6E7320696E2074686973207061726167726170682C2065786369736573207468656D2C2061646473207468656D20746F2074686520646F63756D656E7420616E642072652D617373656D626C65732074686973207061726167726170682773207465787420626C6F636B732E
		Private Sub ParseLinkReferenceDefinitions()
		  /// Parses any link reference definitions in this paragraph, excises them, adds them to the document 
		  /// and re-assembles this paragraph's text blocks.
		  ///
		  /// We deviate from the CommonMark spec here. The spec allows line breaks in link labels which we do not.
		  /// Additionally, the link destination must be on the same line as the link label. This simplifies
		  /// parsing considerably and I really think it's madness to allow so many line breaks in a definition.
		  /// Essentially, we assume link reference definitions are no more than one line.
		  ///
		  /// Assumes that this method is called during block parsing.
		  /// At this point in the paragraph's life cycle, it consists of one or more MKTextBlocks. These will always
		  /// be contiguous. That is:
		  ///   Children(n + 1).Start = Children(n).Start + Children(n).Start.CharacterCount + 1`.
		  /// MKTextBlocks at this stage represent lines (complete or partial). Therefore if `Children.Count = 2`, 
		  /// the text in the MKTextBlock `Children(1)` occurred on the line immediately after `Children(0)`.
		  ///
		  /// A link reference definition consists of a "link label", preceded by up to 3 spaces of indentation, 
		  /// followed by a colon (`:`), optional spaces or tabs (no line ending - CommonMark deviation), 
		  /// a "link destination", optional spaces or tabs (no line ending - CommonMark deviation)
		  /// and an optional "link title" which, if present, must be separated from the "link destination" by 
		  /// spaces or tabs. No further character may occur.
		  ///
		  /// A "link label" begins with a left bracket (`[`) and ends with the first right bracket (`]`) that is not 
		  /// backslash-escaped. 
		  /// Between these brackets there must be at least one character that is not a space, tab, or line ending. 
		  /// Unescaped square bracket characters are not allowed inside the opening and closing square brackets of 
		  /// link labels. A link label can have at most 999 characters inside the square brackets.
		  ///
		  /// A "link destination" consists of either:
		  /// 1. >= 0 characters between an opening `<` and a closing `>` that contains no line endings or 
		  ///    unescaped `<` or `>` characters, or
		  /// 2. > 0 characters that does not start with `<`, does not include ASCII control characters or space 
		  /// character, and includes parentheses only if:
		  ///    (a) they are backslash-escaped
		  ///    (b) they are part of a balanced pair of unescaped parentheses. At least 3 levels must be supported.
		  ///
		  /// A "link title" consists of either:
		  /// 1. >= 0 characters between `"` characters, including a `"` character only if it is backslash-escaped.
		  /// 2. >= 0 characters between `'` characters, including a `'` character only if it is backslash-escaped
		  /// 3. >= 0 characters between matching parentheses, including a `(` or `)` only if it's backslash-escaped.
		  
		  Var data As Dictionary
		  Var linkLabel, linkDestination, linkTitle As String
		  Var i, charsLastIndex, labelStart, destinationStart, titleStart As Integer
		  Var labelLength, destinationLength, titleLength, startOffset As Integer
		  
		  For childIndex As Integer = Children.LastIndex DownTo 0
		    
		    Var chars() As String = MKTextBlock(Children(childIndex)).Contents.CharacterArray
		    charsLastIndex = chars.LastIndex
		    startOffset = Children(childIndex).Start
		    linkLabel = ""
		    labelStart = 0
		    labelLength = 0
		    linkDestination = ""
		    destinationStart = 0
		    destinationLength = 0
		    linkTitle = ""
		    titleStart = 0
		    titleLength = 0
		    data = Nil
		    
		    // Up to 3 spaces of indentation are permitted.
		    i = MatchWhitespaceCharactersInArray(chars, i)
		    If i > 3 Then Continue
		    
		    // Can we match a link label?
		    If Not MKLinkScanner.ParseLinkLabel(chars, i, data) Then Continue
		    linkLabel = data.Value("linkLabel")
		    labelStart = data.Value("linkLabelStart") + startOffset
		    labelLength = i - labelStart + startOffset + 1 // Account for the flanking `[]`.
		    
		    // The next character must be a colon.
		    If i > charsLastIndex Then Continue
		    
		    i = i + 1
		    If chars(i) <> ":" Then
		      Continue
		    Else
		      i = i + 1
		    End If
		    
		    If i > i Then Continue
		    
		    // Skip whitespace after the colon.
		    i = i + MatchWhitespaceCharactersInArray(chars, i)
		    
		    // Can we match a link destination?
		    If Not MKLinkScanner.ParseLinkDestination(chars, i, data) Then Continue
		    linkDestination = data.Value("linkDestination")
		    destinationStart = data.Value("linkDestinationStart") + startOffset
		    destinationLength = i - destinationStart + startOffset
		    
		    // Consume optional tabs and spaces.
		    i = i + MatchWhitespaceCharactersInArray(chars, i)
		    
		    // Can we match a link title?
		    If MKLinkScanner.ParseLinkTitle(chars, i, data) Then
		      linkTitle = data.Value("linkTitle")
		      titleStart = data.Value("linkTitleStart") + startOffset
		      titleLength = i - titleStart + startOffset + 1 // Account for the flanking delimiters.
		    End If
		    
		    // We've found a definition. Add it to the document.
		    Self.Document.References.Value(linkLabel) = _
		    New MKLinkReferenceDefinition(start, linkLabel, labelStart, labelLength, _
		    linkDestination, destinationStart, destinationLength, _
		    linkTitle, titleStart, titleLength, i)
		    
		    // Remove this text block from the paragraph.
		    Children.RemoveAt(childIndex)
		  Next childIndex
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 416C6C206F66207468697320626C6F636B2773206368617261637465727320617320616E206172726179206F66204D4B43686172616374657220696E7374616E6365732E
		Private mAllCharacters() As MKCharacter
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsChildOfTightList"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
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
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue="MKBlockTypes.Block"
			Type="MKBlockTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - AtxHeading"
				"1 - Block"
				"2 - BlockQuote"
				"3 - Document"
				"4 - FencedCode"
				"5 - Html"
				"6 - IndentedCode"
				"7 - List"
				"8 - ListItem"
				"9 - Paragraph"
				"10 - ReferenceDefinition"
				"11 - SetextHeading"
				"12 - TextBlock"
				"13 - ThematicBreak"
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
			Name="LineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
			Name="Level"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
