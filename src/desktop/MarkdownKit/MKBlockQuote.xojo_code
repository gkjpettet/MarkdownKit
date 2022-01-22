#tag Class
Protected Class MKBlockQuote
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStart As Integer)
		  Super.Constructor(MKBlockTypes.BlockQuote, parent, blockStart)
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 302D6261736564206F666673657420696E20746865206F726967696E616C20736F7572636520746861742074686520603E602063686172616374657220617070656172732E
		AbsoluteOpenerStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D6261736564206C6F63616C206F6666736574206F6E20746865206C696E6520746861742074686520603E602063686172616374657220617070656172732E
		LocalOpenerStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416C6C206F70656E696E672064656C696D69746572732028603E602920666F72207468697320626C6F636B2071756F746520696E20617070656172616E6365206F726465722E
		OpeningDelimiters() As MKCharacter
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
			Name="AbsoluteOpenerStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LocalOpenerStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
