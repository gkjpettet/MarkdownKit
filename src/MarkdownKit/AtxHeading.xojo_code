#tag Class
Protected Class AtxHeading
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.Walker)
		  visitor.VisitAtxHeading(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AcceptsLines() As Boolean
		  // AtxHeading blocks can accept lines.
		  
		  Return True
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theLine As MarkdownKit.LineInfo, charPos As Integer, charCol As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor(theLine, charPos, charCol)
		  Self.Type = MarkdownKit.BlockType.AtxHeading
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise()
		  // Nothing to do if this block is already closed.
		  If Not Self.IsOpen Then
		    Return
		  Else
		    Self.IsOpen = False
		  End If
		  
		  // Sanity check.
		  If Children.Ubound <> 0 Then
		    Raise New MarkdownKit.MarkdownException(_ 
		    "A single block of raw text was expected in the AST node for the ATX heading " + _
		    "on line " + Self.Line.Number.ToText + ". Instead got " + Integer(Children.Ubound + 1).ToText)
		  End If
		  
		  // Get a reference to the text representing this heading.
		  Dim rt As MarkdownKit.RawText = MarkdownKit.RawText(Children(0))
		  
		  // At this point, Self.Children contains a single RawText block representing 
		  // the raw text of the header (including prefixing # characters and optional 
		  // trailing # characters). We need to remove these superfluous characters.
		  // First remove the prefixing # characters.
		  Dim i As Integer
		  For i = 1 To Self.Level
		    rt.Chars.Remove(0)
		  Next i
		  
		  // Remove any trailing whitespace.
		  StripTrailingWhitespace(rt.Chars)
		  
		  // Empty heading?
		  If rt.Chars.Ubound = -1 Then
		    Call Children.Pop
		    Return
		  End If
		  
		  // Is there an optional closing sequence to this heading?
		  Dim isClosingSequence As Boolean = False
		  Dim closingSequenceStartIndex As Integer
		  Dim charsUbound As Integer = rt.Chars.Ubound
		  For i = charsUbound DownTo 0
		    If rt.Chars(i) = "#" Then
		      isClosingSequence = True
		      closingSequenceStartIndex = i
		    Else
		      Exit
		    End If
		  Next i
		  If isClosingSequence Then
		    // There's a closing sequence which begins at index `closingSequenceStartIndex`.
		    // For this to be valid, the character immediately before the closing sequence 
		    // must be a space.
		    If closingSequenceStartIndex > 0 And rt.Chars(closingSequenceStartIndex - 1) = " " Then
		      // We have found a valid closing sequence. Remove it.
		      For i = rt.Chars.Ubound DownTo 0
		        If rt.Chars(rt.Chars.Ubound) = "#" Then
		          rt.Chars.Remove(rt.Chars.Ubound)
		        Else
		          Exit
		        End If
		      Next i
		    End If
		  End If
		  
		  // Empty heading?
		  If rt.Chars.Ubound = -1 Then
		    Call Children.Pop
		    Return
		  End If
		  
		  // Remove prefixing and trailing whitespace from the raw text.
		  StripLeadingWhitespace(rt.Chars)
		  StripTrailingWhitespace(rt.Chars)
		  
		  // Empty heading?
		  If rt.Chars.Ubound = -1 Then Call Children.Pop
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Level As Integer = 0
	#tag EndProperty


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
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsLastLineBlank"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstCharPos"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstCharCol"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Level"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
