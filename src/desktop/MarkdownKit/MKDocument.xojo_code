#tag Class
Protected Class MKDocument
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor()
		  Super.Constructor(MKBlockTypes.Document, Nil)
		  Self.References = New Dictionary
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h21, Description = 54686520646F63756D656E742074686174206F776E73207468697320626C6F636B2E
		#tag Getter
			Get
			  // Shadowed to prevent access. A document can't be within another document.
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Shadowed to prevent access. A document can't be within another document.
			End Set
		#tag EndSetter
		Private Document As MKDocument
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5468697320646F63756D656E742773206C696E6B207265666572656E636520646566696E6974696F6E732E204B6579203D206C696E6B206C6162656C2C2056616C7565203D204D4B5265666572656E63654C696E6B446566696E6974696F6E2E
		References As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 466F7220646562756767696E67206F6E6C792E
		TestNumber As Integer = 0
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
			Name="TestNumber"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
