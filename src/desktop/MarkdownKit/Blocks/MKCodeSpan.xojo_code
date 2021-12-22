#tag Class
Protected Class MKCodeSpan
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, absoluteStartPos As Integer, localStartPos As Integer, backtickStringLength As Integer, absoluteClosingBacktickStringStart As Integer, localClosingBacktickStringStart As Integer)
		  Super.Constructor(MKBlockTypes.CodeSpan, parent, absoluteStartPos)
		  
		  Self.LocalStart = localStartPos
		  Self.EndPosition = closingBacktickStringStart - 1
		  Self.BacktickStringLength = backtickStringLength
		  Self.ClosingBacktickStringStart = absoluteClosingBacktickStringStart
		  Self.LocalClosingBacktickStringStart = localClosingBacktickStringStart
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As TextLine = Nil)
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  Var seenNonSpace As Boolean = False
		  Var iStart As Integer = LocalStart + BacktickStringLength
		  Var iLimit As Integer = LocalClosingBacktickStringStart - 1
		  Var textBlockStart As Integer = LocalStart
		  Var contentsBuffer() As String
		  For i As Integer = iStart To iLimit
		    Var c As MKCharacter = Parent.Characters(i)
		    
		    If c.IsLineEnding Then
		      Var s As String = String.FromArray(contentsBuffer, "")
		      Children.Add(New MKTextBlock(Self, Parent.Characters(textBlockStart).Position, s))
		      contentsBuffer.RemoveAll
		      textBlockStart = i
		      
		    ElseIf c.Value = &u0020 Then
		      contentsBuffer.Add(c.Value)
		      
		    Else
		      seenNonSpace = True
		      contentsBuffer.Add(c.Value)
		    End If
		  Next i
		  
		  If contentsBuffer.Count > 0 Then
		    Var s As String = String.FromArray(contentsBuffer, "")
		    Children.Add(New MKTextBlock(Self, Parent.Characters(textBlockStart).Position, s))
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206C656E677468206F662074686520666C616E6B696E67206261636B7469636B2064656C696D69746572732061726F756E64207468697320636F6465207370616E2E
		BacktickStringLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D626173656420696E64657820696E20746865206F726967696E616C20736F75726365206F662074686520666972737420636861726163746572206F662074686520636C6F73696E67206261636B7469636B20737472696E672E
		ClosingBacktickStringStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D626173656420696E64657820696E207468697320636F6465207370616E277320706172656E7420706172616772617068277320604368617261637465727360206172726179206F662074686520666972737420636861726163746572206F662074686520636C6F73696E67206261636B7469636B20737472696E672E
		LocalClosingBacktickStringStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D626173656420696E64657820696E2060506172656E742E4368617261637465727360207468617420746865206F70656E696E67206261636B7469636B20636861726163746572206F66207468697320636F6465207370616E20626567696E732E
		LocalStart As Integer = 0
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="EndPosition"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
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
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue="MKBlockTypes.Block"
			Type="MKBlockTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - AtxHeading"
				"1 - Block"
				"2 - BlockQuote"
				"3 - CodeSpan"
				"4 - Document"
				"5 - FencedCode"
				"6 - Html"
				"7 - IndentedCode"
				"8 - InlineText"
				"9 - List"
				"10 - ListItem"
				"11 - Paragraph"
				"12 - ReferenceDefinition"
				"13 - SetextHeading"
				"14 - TextBlock"
				"15 - ThematicBreak"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsOpen"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
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
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsLastLineBlank"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsChildOfTightList"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsChildOfListItem"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BacktickStringLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClosingBacktickStringStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
