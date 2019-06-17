#tag Class
Protected Class InlineHTML
Inherits MarkdownKit.Inline
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IInlineVisitor)
		  visitor.VisitInlineHTML(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  // StartPos = "<" and EndPos = ">"
		  
		  For i As Integer = Self.StartPos To Self.EndPos
		    chars.Append(Parent.RawChars(i))
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(startPos As Integer, endPos As Integer, container As MarkdownKit.InlineContainerBlock)
		  Super.Constructor(startPos, endPos, InlineType.HTML, Xojo.Core.WeakRef.Create(container))
		  Self.Close
		  
		End Sub
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
				"6 - Link"
				"7 - Image"
				"8 - Hardbreak"
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
