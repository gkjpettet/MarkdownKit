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
			Name="MarkerOffset"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="BulletChar"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsTight"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ListDelimiter"
			Group="Behavior"
			Type="MarkdownKit.ListDelimiter"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ListType"
			Group="Behavior"
			Type="MarkdownKit.ListType"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Padding"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Start"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
