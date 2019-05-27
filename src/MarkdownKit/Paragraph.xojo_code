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
		  If Children.Ubound > 0 Then
		    Dim rt As MarkdownKit.RawText = MarkdownKit.RawText(Children(Children.Ubound - 1))
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
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
