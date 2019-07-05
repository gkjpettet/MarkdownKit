#tag Class
Protected Class DelimiterStackNode
	#tag Method, Flags = &h0
		Function CurrentLength() As Integer
		  If TextNodePointer.Value = Nil Then Return 0
		  
		  Return Markdownkit.Block(TextNodePointer.Value).Chars.Ubound + 1
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
			Name="Delimiter"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="OriginalLength"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Active"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanClose"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanOpen"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ignore"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
