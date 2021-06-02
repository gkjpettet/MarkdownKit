#tag Class
Protected Class ListData
	#tag Property, Flags = &h0, Description = 54686520636861726163746572207573656420666F7220756E6F726465726564206C697374732E205573656420696620604C697374446174612E4C69737454797065602069732073657420746F20604C697374547970652E42756C6C6574602E
		BulletChar As String
	#tag EndProperty

	#tag Property, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)), Description = 412076616C756520696E6469636174696E67207768657468657220746865206C697374206973207469676874202873756368206C697374732077696C6C206E6F742072656E646572206164646974696F6E616C206578706C696369742070617261677261706820656C656D656E7473292E
		IsTight As Boolean
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520636861726163746572207468617420666F6C6C6F777320746865206E756D62657220696620604C697374446174612E4C69737454797065602069732073657420746F20604C697374547970652E4F726465726564602E
		ListDelimiter As MarkdownKit.ListDelimiter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207479706520286F726465726564206F7220756E6F72646572656429206F662074686973206C6973742E
		ListType As MarkdownKit.ListType
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662073706163657320746865206C697374206D61726B6572732061726520696E64656E7465642E
		MarkerOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520706F736974696F6E206F6620746865206C697374206974656D20636F6E74656E747320696E2074686520736F757263652074657874206C696E652E
		Padding As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D62657220666F7220746865206669727374206C697374206974656D20696620604C697374446174612E4C69737454797065602069732073657420746F20604C697374547970652E4F726465726564602E
		Start As Integer
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
			Name="BulletChar"
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
			Name="ListDelimiter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="MarkdownKit.ListDelimiter"
			EditorType="Enum"
			#tag EnumValues
				"0 - Period"
				"1 - Parenthesis"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="ListType"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="MarkdownKit.ListType"
			EditorType="Enum"
			#tag EnumValues
				"0 - Bullet"
				"1 - Ordered"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="Padding"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
