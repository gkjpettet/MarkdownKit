#tag Class
Protected Class MKListData
	#tag Method, Flags = &h0, Description = 436F6D70617265732074686973206C6973742077697468205B6F746865725D2E2052657475726E732060306020696620746865792061726520636F6E7369646572656420657175616C2C206F74686572776973652072657475726E7320602D31602E
		Function Operator_Compare(other As MKListData) As Integer
		  /// Compares this list with [other]. Returns `0` if they are considered equal, otherwise returns `-1`.
		  
		  If Self.ListType = other.ListType And Self.ListDelimiter = other.ListDelimiter And _
		    Self.BulletCharacter = other.BulletCharacter Then
		    Return 0
		  Else
		    Return -1
		  End If
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520636861726163746572207573656420666F7220756E6F726465726564206C697374732E205573656420696620604C697374446174612E4C69737454797065602069732073657420746F20604D4B4C69737454797065732E42756C6C6574602E
		BulletCharacter As String
	#tag EndProperty

	#tag Property, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)), Description = 5472756520696620746865206C697374206973207469676874202873756368206C697374732077696C6C206E6F742072656E646572206164646974696F6E616C206578706C696369742070617261677261706820656C656D656E7473292E
		IsTight As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C656E677468206F6620746865206C697374206D61726B65722E
		Length As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D626173656420706F736974696F6E206F6E20746865206C696E6520746861742074686973206C697374206D61726B657220626567696E732061742E
		LinePosition As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520636861726163746572207468617420666F6C6C6F777320746865206E756D62657220696620604C697374446174612E4C69737454797065602069732073657420746F20604C697374547970652E4F726465726564602E
		ListDelimiter As MKListDelimiters = MKListDelimiters.Period
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207479706520286F726465726564206F7220756E6F72646572656429206F662074686973206C6973742E
		ListType As MKListTypes = MKListTypes.Bullet
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662073706163657320746865206C697374206D61726B657220697320696E64656E7465642E
		MarkerOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207769647468206F6620746865206C697374206D61726B65722E204D617920696E636C75646520616E206F7074696F6E616C20747261696C696E672073706163652E
		MarkerWidth As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D62657220666F7220746865206669727374206C697374206974656D20696620604C697374446174612E4C69737454797065602069732073657420746F20604C697374547970652E4F726465726564602E
		StartNumber As Integer
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
			Name="MarkerOffset"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BulletCharacter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsTight"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="MarkerWidth"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartNumber"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
