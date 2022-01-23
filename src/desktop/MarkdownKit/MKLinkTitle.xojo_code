#tag Class
Protected Class MKLinkTitle
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(openingDelimiter As MKCharacter)
		  Self.OpeningDelimiter = openingDelimiter
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		title
		n required for rendering into source code tokens.
	#tag EndNote


	#tag Property, Flags = &h0, Description = 5468652063686172616374657273206D616B696E67207570207468652076616C7565206F662074686973206C696E6B207469746C6520286E6F7420696E636C7564696E6720616E7920666C616E6B696E672064656C696D6974657273292E204D617920696E636C756465206E65776C696E65732E
		Characters() As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520636C6F73696E672064656C696D6974657220666F7220746865207469746C652E
		ClosingDelimiter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C656E677468206F66207468652064657374696E6174696F6E2E
		Length As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F70656E696E672064656C696D6974657220666F722074686973206C696E6B2773207469746C652E
		OpeningDelimiter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520756E65736361706564206C696E6B2064657374696E6174696F6E2E
		Value As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E206172726179206F66207370656369616C207469746C65207465787420626C6F636B732077686572652065616368206974656D2069732061206C696E6520286F7220706F7274696F6E206F662061206C696E6529206F6620746865206C696E6B277320746578742E204D617920626520656D7074792E
		ValueBlocks() As MarkdownKit.MKLinkTitleBlock
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
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
