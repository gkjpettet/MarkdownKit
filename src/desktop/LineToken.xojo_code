#tag Class
Protected Class LineToken
	#tag Method, Flags = &h0
		Sub Constructor(startAbsolute As Integer, startLocal As Integer, length As Integer, lineNumber As Integer, type As String = "default")
		  Self.StartAbsolute = startAbsolute
		  Self.StartLocal = startLocal
		  Self.Length = length
		  Self.LineNumber = lineNumber
		  Self.Type = type
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 302D626173656420706F736974696F6E206F662074686520656E64206F66207468697320746F6B656E206C6F63616C20746F2074686973206C696E652E
		#tag Getter
			Get
			  Return StartLocal + Length - 1
			  
			End Get
		#tag EndGetter
		EndLocal As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206C656E677468206F66207468697320746F6B656E20696E20636861726163746572732E
		Length As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520312D6261736564206E756D626572206F6620746865206C696E65207468697320746F6B656E2062656C6F6E677320746F2E
		LineNumber As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206162736F6C75746520302D626173656420737461727420706F736974696F6E206F66207468697320746F6B656E20696E20746865206F726967696E616C20736F7572636520746578742E
		StartAbsolute As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D6261736564206C6F63616C20706F736974696F6E206F66207468697320746F6B656E2077686572652060306020697320746865207374617274206F662074686973206C696E652E
		StartLocal As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320746F6B656E277320747970652E205573656420746F2064657465726D696E6520686F7720746F207374796C652069742E
		Type As String = "default"
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
			Name="EndLocal"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartAbsolute"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartLocal"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
