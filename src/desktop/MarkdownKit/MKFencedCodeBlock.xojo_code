#tag Class
Protected Class MKFencedCodeBlock
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStartOffset As Integer = 0)
		  Super.Constructor(MKBlockTypes.FencedCode, parent, blockStartOffset)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6F736573207468697320626C6F636B20616E64206D616B657320616E792066696E616C206368616E6765732074686174206D61792062652072657175697265642E
		Sub Finalise(line As TextLine)
		  /// Closes this block and makes any final changes that may be required.
		  
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  If FirstChild <> Nil Then
		    // The first child (if present) is always the info string as a text block.
		    Self.InfoStringStart = MKTextBlock(FirstChild).Start
		    Self.InfoStringLocalStart = MKTextBlock(FirstChild).LocalStart
		    Self.InfoStringLength = MKTextBlock(FirstChild).Contents.CharacterCount
		    Self.InfoString = MKTextBlock(FirstChild).Contents
		    Children.RemoveAt(0)
		  End If
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206E756D626572206F6620746865206C696E6520746861742074686520636C6F73696E672066656E6365206973206F6E2E20602D31602069662074686572652069736E2774206F6E652E
		ClosingFenceLineNumber As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D6261736564206C6F63616C20706F736974696F6E206F6E20746865206C696E6520746861742074686520636C6F73696E672066656E636520636861726163746572207374617274732061742E
		ClosingFenceLocalStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D626173656420706F736974696F6E20696E2074686520736F75726365206F6620746865207374617274206F6620746869732066656E63656420636F646520626C6F636B277320636C6F73696E672066656E63652E
		ClosingFenceStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652066656E6365206368617261637465722E
		FenceChar As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662066656E63652063686172616374657273206D616B696E6720757020746865206F70656E696E672066656E63652E
		FenceLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FenceOffset As Integer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 5472756520696620746869732066656E63656420636F646520626C6F636B2068617320616E20696E666F20737472696E672E
		#tag Getter
			Get
			  Return InfoStringLength > 0
			End Get
		#tag EndGetter
		HasInfoString As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686520286F7074696F6E616C2920696E666F20737472696E672E
		InfoString As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C656E677468206F662074686520696E666F20737472696E672E
		InfoStringLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D6261736564206C6F63616C20737461727420706F736974696F6E206F6E20746865206C696E65206F6620746865207374617274206F662074686520696E666F20737472696E6720286F7220602D31602069662074686572652069736E2774206F6E65292E
		InfoStringLocalStart As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D6261736564206162736F6C75746520737461727420706F736974696F6E20696E20746865206F726967696E616C20736F75726365206F6620746865207374617274206F662074686520696E666F20737472696E6720286F7220602D31602069662074686572652069736E2774206F6E65292E
		InfoStringStart As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D6261736564206C6F63616C20706F736974696F6E206F6E20746865206C696E65207468617420746865206F70656E696E672066656E636520636861726163746572207374617274732061742E
		OpeningFenceLocalStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 53657420746F205472756520696E206050726F6365737352656D61696E6465724F664C696E656020696620746869732066656E63656420636F646520626C6F636B206E6565647320636C6F73696E672E
		ShouldClose As Boolean = False
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
			Name="FenceChar"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClosingFenceStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceLength"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceOffset"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InfoString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ShouldClose"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpeningFenceLocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClosingFenceLocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InfoStringStart"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InfoStringLocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="InfoStringLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClosingFenceLineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasInfoString"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
