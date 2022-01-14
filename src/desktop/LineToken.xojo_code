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

	#tag Method, Flags = &h0, Description = 54727565206966207468697320746F6B656E2068617320646174612077697468207468652073706563696669656420286361736520696E73656E73697469766529205B6B65795D2E
		Function HasDataKey(key As String) As Boolean
		  /// True if this token has data with the specified (case insensitive) [key].
		  
		  If mData = Nil Then Return False
		  Return mData.HasKey(key)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520646174612076616C7565206173736F6369617465642077697468205B6B65795D206F72205B64656661756C745D206966207468657265206973206E6F206D61746368696E67206B65792E
		Function LookupData(key As String, default As Variant) As Variant
		  /// Returns the data value associated with [key] or [default] if there is no matching key.
		  
		  If mData = Nil Then Return Default
		  Return mData.Lookup(key, Default)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53657473207468652064617461205B6B65795D20746F205B76616C75655D2E2057696C6C206F766572777269746520746865206578697374696E672076616C7565206F66205B6B65795D20696620616C7265616479207365742E
		Sub SetData(key As String, value As Variant)
		  /// Sets the data [key] to [value]. Will overwrite the existing value of [key] if already set.
		  
		  If mData = Nil Then mData = New Dictionary
		  mData.Value(key) = value
		  
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

	#tag Property, Flags = &h1, Description = 4261636B696E672064696374696F6E61727920666F7220616E79206172626974726172792064617461207468697320746F6B656E206D617920636F6E7461696E2E
		Protected mData As Dictionary
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
		#tag ViewProperty
			Name="LineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue="default"
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
