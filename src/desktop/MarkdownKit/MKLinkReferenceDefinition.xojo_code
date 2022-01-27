#tag Class
Protected Class MKLinkReferenceDefinition
	#tag Method, Flags = &h0
		Sub Constructor(start As Integer, linkLabelOpener As MarkdownKit.MKCharacter, linkLabelCloser As MarkdownKit.MKCharacter, label As String, linkLabelStartChar As MarkdownKit.MKCharacter, labelStart As Integer, labelLength As Integer, colon As MarkdownKit.MKCharacter, destination As MarkdownKit.MKLinkDestination, title As MarkdownKit.MKLinkTitle, endPos As Integer)
		  Self.Start = start
		  Self.LinkLabel = label
		  Self.LinkLabelStart = labelStart
		  Self.LinkLabelLength = labelLength
		  Self.LinkLabelOpener = linkLabelOpener
		  Self.LinkLabelCloser = linkLabelCloser
		  Self.LinkLabelStartChar = linkLabelStartChar
		  
		  Self.Colon = colon
		  
		  destination.Value = MarkdownKit.ReplaceEntities(destination.Value)
		  Var tmpDestination As String = destination.Value
		  MarkdownKit.Unescape(tmpDestination)
		  destination.Value = tmpDestination
		  Self.LinkDestination = destination
		  
		  title.Value = MarkdownKit.ReplaceEntities(title.Value)
		  Var tmpTitle As String = title.Value
		  MarkdownKit.Unescape(tmpTitle)
		  title.Value = tmpTitle
		  Self.LinkTitle = title
		  
		  Self.EndPosition = endPos
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520636F6C6F6E206368617261637465722E
		Colon As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D626173656420696E64657820696E2074686520736F7572636520746861742074686973206C696E6B207265666572656E636520646566696E6974696F6E20656E64732E
		EndPosition As Integer = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 547275652069662074686973207265666572656E6365206C696E6B2068617320612064657374696E6174696F6E2E
		#tag Getter
			Get
			  Return LinkDestination <> Nil And LinkDestination.Length > 0
			End Get
		#tag EndGetter
		HasDestination As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 547275652069662074686572652069732061206C696E6B207265666572656E636520646566696E6974696F6E207469746C652E2049662046616C7365207468656E20604C696E6B5469746C6553746172746020616E6420604C696E6B5469746C654C656E677468602061726520696E76616C69642E
		#tag Getter
			Get
			  Return LinkTitle.Value <> ""
			End Get
		#tag EndGetter
		HasTitle As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6B2064657374696E6174696F6E2E
		LinkDestination As MarkdownKit.MKLinkDestination
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6B206C6162656C2E
		LinkLabel As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520636C6F73696E67206C696E6B206C6162656C2064656C696D697465722028605D60292E
		LinkLabelCloser As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C656E677468206F6620746865206C696E6B206C6162656C2028696E636C7564696E672074686520666C616E6B696E6720605B5D60292E
		LinkLabelLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F70656E696E67206C696E6B206C6162656C2064656C696D697465722028605B60292E
		LinkLabelOpener As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D626173656420696E64657820696E2074686520736F75726365206F6620746865207374617274206F6620746865206C696E6B206C6162656C2E
		LinkLabelStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520666972737420636861726163746572206F6620746865206C696E6B206C6162656C2E
		LinkLabelStartChar As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E6B207469746C652E204D617920626520656D7074792E
		LinkTitle As MarkdownKit.MKLinkTitle
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D6261736520696E64657820696E2074686520736F7572636520746861742074686973206C696E6B207265666572656E636520646566696E6974696F6E207374617274732E
		Start As Integer = 0
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
			Name="EndPosition"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasTitle"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LinkLabel"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LinkLabelLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LinkLabelStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasDestination"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
