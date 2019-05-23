#tag Class
Protected Class ListData
	#tag Property, Flags = &h0
		Bullet As MarkdownKit.BulletType
	#tag EndProperty

	#tag Property, Flags = &h0
		ContentStartIndex As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Delimiter As MarkdownKit.ListDelimiterType
	#tag EndProperty

	#tag Property, Flags = &h0
		MarkerWidth As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Start As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Tight As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As MarkdownKit.ListType
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
			Name="Bullet"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
