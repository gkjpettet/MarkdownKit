#tag Class
Protected Class MKCharacter
	#tag Method, Flags = &h0
		Sub Constructor(value As String, position As Integer)
		  Self.Value = value
		  Self.Position = position
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732061207370656369616C206C696E6520656E64696E67206368617261637465722E
		Shared Function CreateLineEnding() As MKCharacter
		  /// Returns a special line ending character.
		  
		  Return New MKCharacter("", -1)
		End Function
	#tag EndMethod


	#tag Note, Name = About
		Stores an individual character and its absolute 0-based position in the original Markdown source.
		
	#tag EndNote


	#tag ComputedProperty, Flags = &h0, Description = 5472756520696620746869732069732061207370656369616C206C696E6520656E64696E67206368617261637465722028706F736974696F6E2077696C6C2062652073657420746F20602D3160292E
		#tag Getter
			Get
			  Return Position = -1
			End Get
		#tag EndGetter
		IsLineEnding As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686520302D626173656420706F736974696F6E206F6620746869732063686172616374657220696E20746865206F726967696E616C204D61726B646F776E20736F757263652E2053657420746F20602D316020696620746869732069732061207370656369616C206C696E6520656E64696E67206368617261637465722E
		Position As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206368617261637465722E
		Value As String
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
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
