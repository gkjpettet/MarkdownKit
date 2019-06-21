#tag Class
Protected Class InlineText
Inherits MarkdownKit.Inline
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IInlineVisitor)
		  visitor.VisitInlineText(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  #Pragma Warning "TODO: Encode entities, etc"
		  
		  For x As Integer = Self.StartPos To Self.EndPos
		    Self.Chars.Append(Self.Parent.RawChars(x))
		  Next x
		  
		  Self.IsOpen = False
		  
		  // Unescape backslash-escaped characters.
		  Utilities.Unescape(Self.Chars)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(startPos As Integer, endPos As Integer, container As MarkdownKit.InlineContainerBlock)
		  Super.Constructor(startPos, endPos, InlineType.Textual, Xojo.Core.WeakRef.Create(container))
		  
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
