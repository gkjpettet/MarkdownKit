#tag Class
Protected Class DelimiterStackNode
	#tag Method, Flags = &h0
		Function CurrentLength() As Integer
		  If TextNodePointer.Value = Nil Then Return 0
		  
		  Return Markdownkit.Block(TextNodePointer.Value).Chars.LastIndex + 1
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Active As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		CanClose As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		CanOpen As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Delimiter As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Ignore As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		OriginalLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		TextNodePointer As Xojo.Core.WeakRef
	#tag EndProperty


	#tag ViewBehavior
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
			Name="Delimiter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OriginalLength"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Active"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanClose"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanOpen"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ignore"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
