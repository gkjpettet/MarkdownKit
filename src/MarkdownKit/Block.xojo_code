#tag Class
Protected Class Block
	#tag Method, Flags = &h0
		Sub Finalise()
		  // This generic base method simply closes this block.
		  // Subclasses can override this method if they have more complicated needs 
		  // upon block closure.
		  
		  If IsOpen Then
		    Return
		  Else
		    IsOpen = False
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206C617374206368696C64206F66207468697320426C6F636B
		Function LastChild() As MarkdownKit.Block
		  // Return the last child of htis Block. Nil otherwise.
		  
		  If Children.Ubound >- 1 Then Return Children(Children.Ubound)
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 5468697320426C6F636B2773206368696C6420426C6F636B732028696620616E79292E
		Children() As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		IsOpen As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320426C6F636B277320706172656E742028692E653A20656E636C6F73696E672920426C6F636B2E2057696C6C206265204E696C206966207468697320426C6F636B2069732074686520726F6F7420446F63756D656E742E
		Parent As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As MarkdownKit.BlockType
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
			Name="IsOpen"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
