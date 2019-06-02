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
		  // Calling the overridden superclass method.
		  Super.AddLine(line, startPos)
		  
		  // Do we need to prepend a hard or soft break before this line?
		  Dim rt As MarkdownKit.RawText
		  If Children.Ubound > 0 Then
		    rt = MarkdownKit.RawText(Children(Children.Ubound - 1))
		    Dim charsUbound As Integer = rt.Chars.Ubound
		    
		    If charsUbound > 1 And rt.Chars(charsUbound) = " " And _ 
		      rt.Chars(charsUbound - 1) = " " Then
		      // The preceding line ended with two spaces. Prepend a hard line break.
		      Children.Insert(Children.Ubound, New MarkdownKit.Hardbreak(line.Number - 1))
		    ElseIf rt.Chars(charsUbound) = "\" Then
		      // A backslash at the end of the preceding lines indicates a hard break.
		      Children.Insert(Children.Ubound, New MarkdownKit.Hardbreak(line.Number - 1))
		      // Remove the trailing backslash from the preceding line.
		      rt.Chars.Remove(rt.Chars.Ubound)
		    Else
		      // Prepend a soft line break.
		      Children.Insert(Children.Ubound, New MarkdownKit.Softbreak(line.Number - 1))
		    End If
		    
		    // Strip the trailing whitespace from the end of the preceding line.
		    StripTrailingWhitespace(rt.Chars)
		  End If
		  
		  // Strip leading and trailing whitespace from THIS line.
		  If Children.Ubound >= 0 Then
		    rt = MarkdownKit.RawText(Children(Children.Ubound))
		    StripLeadingWhitespace(rt.Chars)
		    StripTrailingWhitespace(rt.Chars)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As MarkdownKit.LineInfo)
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  // Strip leading and trailing whitespace.
		  Dim rt As MarkdownKit.RawText
		  If Children.Ubound >= 0 Then
		    // Leading...
		    rt = MarkdownKit.RawText(Children(0))
		    StripLeadingWhitespace(rt.Chars)
		    // Trailing.
		    rt = MarkdownKit.RawText(Children(Children.Ubound))
		    StripTrailingWhitespace(rt.Chars)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToText() As Text
		  // Returns concatenated Text representing this paragraph's children.
		  // Assumes that the paragraph has not undergone any inline parsing yet.
		  
		  #Pragma Error "Needs implementing"
		  Dim tmp() As Text
		  Dim child As MarkdownKit.Block
		  Dim childrenUbound As Integer = Children.Ubound
		  For i As Integer = 0 To childrenUbound
		    child = Children(i)
		    Select Case child
		    Case IsA MarkdownKit.RawText
		      
		    Case IsA MarkdownKit.Softbreak
		      
		    Case IsA MarkdownKit.Hardbreak
		      
		    Else
		      Raise New MarkdownKit.MarkdownException("Unexpected block type in " + _
		      "this paragraph's children")
		    End Select
		  Next i
		End Function
	#tag EndMethod


	#tag ViewBehavior
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
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
