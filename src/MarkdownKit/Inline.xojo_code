#tag Class
Protected Class Inline
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IInlineVisitor)
		  visitor.VisitInline(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  Dim e As New Xojo.Core.UnsupportedOperationException
		  e.Reason = "The Inline.Close method should be overridden by subclasses"
		  Raise e
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(startPos As Integer, endPos As Integer, type As MarkdownKit.InlineType, parent As Xojo.Core.WeakRef)
		  Self.StartPos = startPos
		  Self.EndPos = endPos
		  Self.Type = type
		  Self.mParent = parent
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Chars() As Text
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207A65726F2D626173656420696E64657820696E2074686520636F6E7461696E65722773205261774368617273206172726179207768657265207468697320696E6C696E6520656E6473
		EndPos As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		IsOpen As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		mParent As Xojo.Core.WeakRef
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mParent.Value = Nil Then
			    Return Nil
			  Else
			    Return MarkdownKit.InlineContainerBlock(mParent.Value)
			  End If
			  
			End Get
		#tag EndGetter
		Parent As MarkdownKit.InlineContainerBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865207A65726F2D626173656420696E64657820696E2074686520636F6E7461696E65722773205261774368617273206172726179207768657265207468697320696E6C696E6520626567696E73
		StartPos As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As MarkdownKit.InlineType = MarkdownKit.InlineType.Textual
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
	#tag EndViewBehavior
End Class
#tag EndClass
