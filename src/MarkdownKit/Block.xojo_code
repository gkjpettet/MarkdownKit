#tag Class
Protected Class Block
	#tag Method, Flags = &h0
		Sub AddLine(line As MarkdownKit.LineInfo)
		  // This method must be overridden by subclasses.
		  
		  Dim e As New Xojo.Core.UnsupportedOperationException
		  e.Reason = "The Block.AddLine method must be overridden by subclasses."
		  Raise e
		  
		  #Pragma Error "Implement in subclasses"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(lineNumber As Integer, startColumn As Integer)
		  Self.LineNumber = lineNumber
		  Self.StartColumn = startColumn
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As MarkdownKit.LineInfo)
		  // This generic base method simply closes this block.
		  // Subclasses can override this method if they have more complicated needs 
		  // upon block closure.
		  // `line` is the line that triggered the Finalise call.
		  
		  If IsOpen Then
		    Return
		  Else
		    IsOpen = False
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206669727374206368696C64206F66207468697320426C6F636B206F72204E696C2069662074686520426C6F636B20686173206E6F206368696C6472656E2E
		Function FirstChild() As MarkdownKit.Block
		  // Return the first child of htis Block. Nil otherwise.
		  
		  If Children.Ubound >- 1 Then
		    Return Children(Children.Ubound)
		  Else
		    Return Nil
		  End If
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206C617374206368696C64206F66207468697320426C6F636B206F72204E696C206966207468697320426C6F636B20686173206E6F206368696C6472656E2E
		Function LastChild() As MarkdownKit.Block
		  // Return the last child of htis Block. Nil otherwise.
		  
		  If Children.Ubound >- 1 Then
		    Return Children(Children.Ubound)
		  Else
		    Return Nil
		  End If
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 5468697320426C6F636B2773206368696C6420426C6F636B732028696620616E79292E
		Children() As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E20746865206C617374206C696E65206F66207468697320636F6E7461696E657220697320626C616E6B2E
		IsLastLineBlank As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		IsOpen As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E65206E756D6265722074686174207468697320626C6F636B20626567696E73206F6E2E
		LineNumber As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320426C6F636B277320706172656E742028692E653A20656E636C6F73696E672920426C6F636B2E2057696C6C206265204E696C206966207468697320426C6F636B2069732074686520726F6F7420446F63756D656E742E
		Parent As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		StartColumn As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Type As MarkdownKit.BlockType
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
			Name="IsOpen"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Type"
			Group="Behavior"
			Type="MarkdownKit.BlockType"
			EditorType="Enum"
			#tag EnumValues
				"0 - Document"
				"1 - BlockQuote"
				"2 - List"
				"3 - ListItem"
				"4 - FencedCode"
				"5 - IndentedCode"
				"6 - HtmlBlock"
				"7 - Paragraph"
				"8 - AtxHeading"
				"9 - SetextHeading"
				"10 - ThematicBreak"
				"11 - ReferenceDefinition"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsLastLineBlank"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartColumn"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineNumber"
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
