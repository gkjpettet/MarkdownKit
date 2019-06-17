#tag Class
Protected Class LinkReferenceDefinition
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IBlockVisitor)
		  visitor.VisitLinkReferenceDefinition(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(name As Text, destination As Text, title As Text)
		  Self.Name = name
		  Self.Destination = destination
		  Self.Title = title
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Destination As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Title As Text
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
			Name="Name"
			Group="Behavior"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Destination"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
