#tag Class
Protected Class MKTableBlock
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStart As Integer = 0)
		  Super.Constructor(MKBlockTypes.Table, parent, blockStart)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520616C69676E6D656E7420666F72206561636820636F6C756D6E20286C6566742C2063656E7465722C207269676874206F72206E6F6E65292E
		ColumnAlignments() As MarkdownKit.MKTableColumnAlignments
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F6620636F6C756D6E7320696E2074686973207461626C652E
		ColumnCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E65206E756D626572206F66207468652064656C696D6974657220726F772E205573656420746F20736B6970206164646974696F6E616C2070726F63657373696E67206F66207468652064656C696D69746572206C696E652E
		DelimiterLineNumber As Integer = -1
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
			Name="ColumnCount"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="DelimiterLineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
