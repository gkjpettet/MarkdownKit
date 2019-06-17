#tag Class
Protected Class InlineCodespan
Inherits MarkdownKit.Inline
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IInlineVisitor)
		  visitor.VisitInlineCodespan(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  // Everything between StartPos and EndPos is the content of this code span.
		  
		  Dim seenNonSpace As Boolean = False
		  For i As Integer = Self.StartPos To Self.EndPos
		    Select Case Parent.RawChars(i)
		    Case &u000A
		      // Newlines are normalised to spaces.
		      chars.Append(&u0020)
		    Case &u0020
		      chars.Append(&u0020)
		    Else
		      seenNonSpace = True
		      chars.Append(Parent.RawChars(i))
		    End Select
		  Next i
		  
		  // If the resulting content both begins and ends with a space character, but does not 
		  // consist entirely of space characters, a single space character is removed from the 
		  // front and back.
		  If seenNonSpace And Chars.Ubound >= 1 And Chars(0) = &u0020 And Chars(Chars.Ubound) = &u0020 Then
		    Chars.Remove(0)
		    Call Chars.Pop
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(startPos As Integer, endPos As Integer, container As MarkdownKit.InlineContainerBlock, delimiterLength As Integer)
		  Super.Constructor(startPos, endPos, InlineType.CodeSpan, Xojo.Core.WeakRef.Create(container))
		  Self.DelimiterLength = delimiterLength
		  Self.Close
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		DelimiterLength As Integer = 0
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
			Name="Type"
			Group="Behavior"
			InitialValue="MarkdownKit.InlineType.Textual"
			Type="MarkdownKit.InlineType"
			EditorType="Enum"
			#tag EnumValues
				"0 - Textual"
				"1 - Emphasis"
				"2 - Strong"
				"3 - CodeSpan"
				"4 - HTML"
				"5 - Softbreak"
				"6 - Linebreak"
				"7 - Link"
				"8 - Image"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartPos"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="EndPos"
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsOpen"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
