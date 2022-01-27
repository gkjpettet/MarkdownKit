#tag Class
Protected Class MKInlineHTML
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, absoluteStartPos As Integer, parentLocalStart As Integer, localStartPos As Integer, absoluteRightAngleChar As MKCharacter, parentLocalRightAnglePos As Integer)
		  Super.Constructor(MKBlockTypes.InlineHTML, parent, absoluteStartPos)
		  
		  Self.ParentLocalStart = parentLocalStart
		  Self.LocalStart = localStartPos
		  Self.EndPosition = absoluteRightAngleChar.AbsolutePosition
		  Self.EndCharacter = absoluteRightAngleChar
		  Self.LocalRightAnglePos = parentLocalRightAnglePos
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As TextLine = Nil)
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  Var textBlockStart As Integer
		  Var contentsBuffer() As String
		  Var c As MKCharacter
		  For i As Integer = ParentLocalStart To LocalRightAnglePos
		    If contentsBuffer.Count = 0 Then textBlockStart = i
		    c = Parent.Characters(i)
		    If c.IsLineEnding Then
		      Var s As String = String.FromArray(contentsBuffer, "")
		      Children.Add(New MKTextBlock(Self, Parent.Characters(textBlockStart).AbsolutePosition, _
		      Parent.Characters(textBlockStart).LocalPosition, _
		      s, 0, c.Line))
		      contentsBuffer.RemoveAll
		    Else
		      contentsBuffer.Add(c.Value)
		    End If
		  Next i
		  
		  If contentsBuffer.Count > 0 Then
		    Var s As String = String.FromArray(contentsBuffer, "")
		    Children.Add(New MKTextBlock(Self, Parent.Characters(textBlockStart).AbsolutePosition, _
		    Parent.Characters(textBlockStart).LocalPosition, _
		    s, 0, c.Line))
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 4966207468697320696E6C696E652048544D4C206861732061206C696E6B2C2074686973206973207468652064657374696E6174696F6E2E
		Destination As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520656E64696E6720603E60206368617261637465722E
		EndCharacter As MarkdownKit.MKCharacter
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320696E6C696E652048544D4C20697320616E206175746F6C696E6B2E
		IsAutoLink As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320696E6C696E652048544D4C2773206F7074696F6E616C206C696E6B206C6162656C2E
		Label As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D626173656420706F736974696F6E20696E2060506172656E742E4368617261637465727360206F662074686520636C6F73696E6720726967687420616E676C6520627261636B65742E
		LocalRightAnglePos As Integer
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D626173656420696E646578206F6E20746865206C696E65206F6620746865206F70656E696E67206C65667420616E676C6520627261636B6574206F66207468697320696E6C696E652048544D4C2E
		LocalStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D626173656420696E64657820696E2060506172656E742E4368617261637465727360206F6620746865206F70656E696E67206C65667420616E676C6520627261636B6574206F66207468697320696E6C696E652048544D4C2E
		ParentLocalStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320696E6C696E652048544D4C2773207469746C652028696620616E79292E
		Title As String
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
			Name="LocalRightAnglePos"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Destination"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsAutoLink"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Label"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ParentLocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
