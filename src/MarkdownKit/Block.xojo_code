#tag Class
Protected Class Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IBlockVisitor)
		  visitor.VisitBlock(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddLine(line As MarkdownKit.LineInfo, startPos As Integer, length As Integer = -1)
		  // Add the passed line to this Block.
		  // May be overridden by subclasses if more complicated tasks are required.
		  
		  If Not Self.IsOpen Then
		    Raise New MarkdownKit.MarkdownException("Attempted to add line " + _
		    line.Number.ToText + " to closed container " + Self.Type.ToText)
		  End If
		  
		  Dim len As Integer = If(length = -1, line.CharsUbound - line.Offset + 1, length)
		  
		  Dim tmp() As Text
		  
		  If len <= 0 Then
		    // Blank line.
		    Children.Append(New MarkdownKit.TextBlock(tmp, line))
		    Return
		  End If
		  
		  // Get the characters from the current line offset to the end of the line.
		  // Remember to account for missing spaces.
		  Dim i As Integer
		  For i = 1 To line.RemainingSpaces
		    tmp.Append(" ")
		  Next i
		  Dim limit As Integer = Xojo.Math.Min(line.Chars.Ubound, startPos + len - 1)
		  For i = startPos To limit
		    tmp.Append(line.Chars(i))
		  Next i
		  
		  // Add the raw text as the last child of this block.
		  Children.Append(New MarkdownKit.TextBlock(tmp, line))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(lineNumber As Integer, startPos As Integer, startColumn As Integer)
		  Self.LineNumber = lineNumber
		  Self.StartPosition = startPos
		  Self.StartColumn = startColumn
		  SetType
		  Self.ListData = New MarkdownKit.ListData
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function EndsWithBlankLine(b As MarkdownKit.Block) As Boolean
		  // Check to see if the passed block ends with a blank line, 
		  // descending if needed into lists and sublists.
		  
		  Do
		    If b.IsLastLineBlank Then Return True
		    
		    If b.Type <> BlockType.List And b.Type <> BlockType.ListItem Then Return False
		    
		    b = b.LastChild
		    
		    If b = Nil Then Return False
		  Loop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As MarkdownKit.LineInfo)
		  // This generic base method simply closes this block.
		  // Subclasses can override this method if they have more complicated needs 
		  // upon block closure.
		  // `line` is the line that triggered the Finalise call.
		  
		  #Pragma Unused line
		  
		  If Not IsOpen Then
		    Return
		  Else
		    IsOpen = False
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865206669727374206368696C64206F66207468697320426C6F636B206F72204E696C2069662074686520426C6F636B20686173206E6F206368696C6472656E2E
		Function FirstChild() As MarkdownKit.Block
		  // Return the first child of this Block. Nil otherwise.
		  
		  If Children.Ubound > -1 Then
		    Return Children(0)
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

	#tag Method, Flags = &h0
		Sub RemoveChild(child As MarkdownKit.Block)
		  // Removes the passed child block from this block.
		  // Only looks at the top level children of this block.
		  
		  Dim childIndex As Integer = Children.IndexOf(child)
		  If childIndex <> -1 Then Children.Remove(childIndex)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetType()
		  // Set this Block's type enumeration.
		  
		  If Self IsA MarkdownKit.BlockQuote Then
		    mType = MarkdownKit.BlockType.BlockQuote
		  ElseIf Self IsA MarkdownKit.Document Then
		    mType = MarkdownKit.BlockType.Document
		  ElseIf Self IsA MarkdownKit.Paragraph Then
		    mType = MarkdownKit.BlockType.Paragraph
		  ElseIf Self IsA MarkdownKit.TextBlock Then
		    mType = MarkdownKit.BlockType.TextBlock
		  ElseIf Self IsA MarkdownKit.IndentedCode Then
		    mType = MarkdownKit.BlockType.IndentedCode
		  ElseIf Self IsA MarkdownKit.FencedCode Then
		    mType = MarkdownKit.BlockType.FencedCode
		  ElseIf Self Isa MarkdownKit.ATXHeading Then
		    mType = MarkdownKit.BlockType.AtxHeading
		  ElseIf Self IsA MarkdownKit.SetextHeading Then
		    mType = MarkdownKit.BlockType.SetextHeading
		  ElseIf Self IsA MarkdownKit.ThematicBreak Then
		    mType = MarkdownKit.BlockType.ThematicBreak
		  ElseIf Self IsA MarkdownKit.ListItem Then
		    mType = MarkdownKit.BlockType.ListItem
		  ElseIf Self IsA MarkdownKit.List Then
		    mType = MarkdownKit.BlockType.List
		  ElseIf Self IsA MarkdownKit.HTML Then
		    mType = MarkdownKit.BlockType.HtmlBlock
		  Else
		    Raise New MarkdownKit.MarkdownException("Unknown Block type")
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 5468697320426C6F636B2773206368696C6420426C6F636B732028696620616E79292E
		Children() As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		HTMLBlockType As Integer = kHTMLBlockTypeNone
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

	#tag Property, Flags = &h0
		ListData As MarkdownKit.ListData
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mType As MarkdownKit.BlockType = MarkdownKit.BlockType.Block
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E657874207369626C696E67206F66207468697320626C6F636B20656C656D656E742E204E696C206966207468697320697320746865206C61737420656C656D656E742E
		NextSibling As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320426C6F636B277320706172656E742028692E653A20656E636C6F73696E672920426C6F636B2E2057696C6C206265204E696C206966207468697320426C6F636B2069732074686520726F6F7420446F63756D656E742E
		Parent As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652070726576696F7573207369626C696E67206F66207468697320626C6F636B20656C656D656E742E204E696C20696620746869732069732074686520666972737420656C656D656E742E
		Previous As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		RawChars() As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		Root As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		StartColumn As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0
		StartPosition As Integer = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mType
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			End Set
		#tag EndSetter
		Type As MarkdownKit.BlockType
	#tag EndComputedProperty


	#tag Constant, Name = kHTMLBlockTypeCData, Type = Double, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeComment, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeDocumentType, Type = Double, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeInterruptingBlock, Type = Double, Dynamic = False, Default = \"6", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeInterruptingBlockWithEmptyLines, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeNone, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeNonInterruptingBlock, Type = Double, Dynamic = False, Default = \"7", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kHTMLBlockTypeProcessingInstruction, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant


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
			Name="IsLastLineBlank"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartColumn"
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineNumber"
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartPosition"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
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
				"12 - Block"
				"13 - TextBlock"
				"14 - Softbreak"
				"15 - Hardbreak"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="HTMLBlockType"
			Group="Behavior"
			InitialValue="kHTMLBlockTypeNone"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
