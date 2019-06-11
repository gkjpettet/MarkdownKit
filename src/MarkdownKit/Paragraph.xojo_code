#tag Class
Protected Class Paragraph
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IWalker)
		  visitor.VisitParagraph(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddLine(line As MarkdownKit.LineInfo, startPos As Integer, length As Integer = -1)
		  If Not Self.IsOpen Then
		    Raise New MarkdownKit.MarkdownException("Attempted to add line " + _
		    line.Number.ToText + " to closed container " + Self.Type.ToText)
		  End If
		  
		  Dim len As Integer = If(length = -1, line.CharsUbound - line.Offset + 1, length)
		  
		  // Unexpected blank line?
		  If len <= 0 Then Raise New MarkdownKit.MarkdownException("Bug: I didn't think this would happen!")
		  
		  // Get the characters from the current line offset to the end of the line.
		  Dim tmp() As Text
		  Dim i As Integer
		  Dim limit As Integer = Xojo.Math.Min(line.Chars.Ubound, startPos + len - 1)
		  For i = startPos To limit
		    tmp.Append(line.Chars(i))
		  Next i
		  
		  // Strip leading and trailing whitespace from this line.
		  StripLeadingWhitespace(tmp)
		  
		  // Add a newline to the end of this line as it's needed 
		  // during subsequent inline parsing.
		  tmp.Append(&u000A)
		  
		  // Append the characters of this line to this paragraph's RawChars array.
		  RawChars.AppendArray(tmp)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As MarkdownKit.LineInfo)
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  If RawChars.Ubound < 0 Then Return
		  
		  StripTrailingWhitespace(RawChars)
		  
		  Dim origCount As Integer
		  While RawChars.Ubound >= 3 And RawChars(0) = "["
		    // Cache the size of the chars array now as it will change if a reference is found.
		    origCount = RawChars.Ubound
		    BlockScanner.ScanLinkReferenceDefinition(RawChars, MarkdownKit.Document(Self.Root))
		    If origCount = RawChars.Ubound Then Exit // No more reference links found.
		  Wend
		  
		  // Do we need to remove this paragraph entirely? This occurs when its only content 
		  // was a reference link.
		  If RawChars.Ubound = -1 Then Self.Parent.RemoveChild(Self)
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="HTMLBlockType"
			Group="Behavior"
			InitialValue="kHTMLBlockTypeNone"
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
		#tag ViewProperty
			Name="IsLastLineBlank"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartColumn"
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineNumber"
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartPosition"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
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
				"12 - Block"
				"13 - RawText"
				"14 - Softbreak"
				"15 - Hardbreak"
				"16 - HTML"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
