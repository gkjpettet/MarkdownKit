#tag Class
Protected Class InlineEmphasis
Inherits MarkdownKit.Inline
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IInlineVisitor)
		  visitor.VisitInlineEmphasis(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  #Pragma Warning "TODO"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(container As MarkdownKit.InlineContainerBlock, delimiter As Text, delimiterLength As Integer)
		  Super.Constructor(-1, -1, InlineType.Emphasis, Xojo.Core.WeakRef.Create(container))
		  Self.Delimiter = delimiter
		  Self.DelimiterLength = delimiterLength
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Children() As MarkdownKit.Inline
	#tag EndProperty

	#tag Property, Flags = &h0
		Delimiter As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		DelimiterLength As Integer = 0
	#tag EndProperty


	#tag ViewBehavior
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
			Name="IsOpen"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Delimiter"
			Group="Behavior"
			Type="Text"
			EditorType="Enum"
			#tag EnumValues
				"0 - Star"
				"1 - Underscore"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="DelimiterLength"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
