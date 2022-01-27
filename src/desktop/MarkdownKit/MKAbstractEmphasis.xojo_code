#tag Class
Protected Class MKAbstractEmphasis
Inherits MKBlock
	#tag Note, Name = About
		An abstract base class for MKEmphasis and MKStrongEmphasis blocks.
		
	#tag EndNote


	#tag Property, Flags = &h0, Description = 302D62617365642061626F736C75746520706F736974696F6E206F662074686520666972737420636861726163746572206F662074686520636C6F73696E672064656C696D6974657220696E20746865206F726967696E616C20736F757263652E
		ClosingDelimiterAbsoluteStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E65206E756D62657220746861742074686520636C6F73696E672064656C696D69746572206F6363757273206F6E2E
		ClosingDelimiterLineNumber As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D6261736564206C6F63616C20706F736974696F6E206F662074686520666972737420636861726163746572206F662074686520636C6F73696E672064656C696D697465722E
		ClosingDelimiterLocalStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652064656C696D697465722E
		Delimiter As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C656E677468206F66207468652064656C696D697465722E
		DelimiterLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D62617365642061626F736C75746520706F736974696F6E206F662074686520666972737420636861726163746572206F6620746865206F70656E696E672064656C696D6974657220696E20746865206F726967696E616C20736F757263652E
		OpeningDelimiterAbsoluteStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E65206E756D626572207468617420746865206F70656E696E672064656C696D69746572206F6363757273206F6E2E
		OpeningDelimiterLineNumber As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D6261736564206C6F63616C20706F736974696F6E206F662074686520666972737420636861726163746572206F6620746865206F70656E696E672064656C696D697465722E
		OpeningDelimiterLocalStart As Integer = 0
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
			Name="ClosingDelimiterLineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpeningDelimiterLineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpeningDelimiterLocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClosingDelimiterAbsoluteStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClosingDelimiterLocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Delimiter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DelimiterLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpeningDelimiterAbsoluteStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
