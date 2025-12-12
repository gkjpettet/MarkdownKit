#tag Class
Protected Class MKTableCellBlock
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStart As Integer = 0)
		  Super.Constructor(MKBlockTypes.TableCell, parent, blockStart)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54727565206966207468697320626C6F636B2063616E20636F6E7461696E20696E6C696E6520626C6F636B732E
		Function IsInlineContainer() As Boolean
		  /// True if this block can contain inline blocks.
		  /// Table cells can contain inline content like emphasis, links, etc.
		  
		  Return True
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520616C69676E6D656E7420666F72207468697320636F6C756D6E2E
		Alignment As MarkdownKit.MKTableColumnAlignments = MKTableColumnAlignments.None
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520636F6C756D6E20696E64657820286265676E6E696E672061742030292074686174207468697320616C69676E73207769746820696E2074686520706172656E74207461626C652E
		ColumnIndex As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5472756520696620746869732069732061206865616465722063656C6C20287468292C2046616C736520666F72206461746120286464292E
		IsHeader As Boolean = False
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
			Name="ColumnIndex"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsHeader"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Alignment"
			Visible=false
			Group="Behavior"
			InitialValue="MKTableColumnAlignments.None"
			Type="MarkdownKit.MKTableColumnAlignments"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
