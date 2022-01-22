#tag Class
Protected Class MKDelimiterStackNode
	#tag Method, Flags = &h0
		Sub Constructor(textNode As MKInlineText, delimiter As String)
		  Self.TextNode = textNode
		  Self.Delimiter = delimiter
		  Self.OriginalLength = delimiter.Length
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CurrentLength() As Integer
		  If TextNode = Nil Then Return 0
		  
		  Return TextNode.Characters.Count
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Active As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		CanClose As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		CanOpen As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 5472756520696620746869732064656C696D697465722063616E206F70656E20616E20696E6C696E65206C696E6B206F7220696D6167652E
		#tag Getter
			Get
			  Return Delimiter = "[" Or Delimiter = "!["
			End Get
		#tag EndGetter
		CanOpenLinkOrImage As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Delimiter As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Ignore As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41207765736B207265666572656E636520746F20746869732064656C696D69746572206E6F6465277320696E6C696E652074657874206E6F64652E
		Private mTextNodeRef As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F726967696E616C206C656E677468206F66207468652064656C696D697465722E
		OriginalLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F66206368617261637465727320706F7070656420647572696E672070726F63657373696E672E205573656420746F206F66667365742074686520636C6F73696E672064656C696D69746572206C6F63616C2073746172742E
		PoppedCharacters As Integer = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 41207765616B207265666572656E636520746F20746869732064656C696D69746572277320696E6C696E652074657874206E6F64652E
		#tag Getter
			Get
			  If mTextNodeRef = Nil Then
			    Return Nil
			  Else
			    Return MKInlineText(mTextNodeRef.Value)
			  End If
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = Nil Then
			    mTextNodeRef = Nil
			  Else
			    mTextNodeRef = New WeakRef(value)
			  End If
			  
			End Set
		#tag EndSetter
		TextNode As MKInlineText
	#tag EndComputedProperty


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
			Name="Delimiter"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Active"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanClose"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanOpen"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CanOpenLinkOrImage"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Ignore"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OriginalLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PoppedCharacters"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
