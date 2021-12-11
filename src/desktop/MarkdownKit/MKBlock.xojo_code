#tag Class
Protected Class MKBlock
	#tag Method, Flags = &h0
		Function Accept(visitor As MKRenderer, lines() As TextLine = Nil) As Variant
		  /// Accepts an AST renderer and redirects to the correct method.
		  
		  Select Case Self.Type
		  Case MKBlockTypes.AtxHeading
		    Return visitor.VisitATXHeading(Self)
		    
		  Case MKBlockTypes.Block
		    #Pragma Warning "TODO: Implement block visitor"
		    
		  Case MKBlockTypes.BlockQuote
		    Return visitor.VisitBlockQuote(Self)
		    
		  Case MKBlockTypes.Document
		    Return visitor.VisitDocument(Self)
		    
		  Case MKBlockTypes.FencedCode
		    Return visitor.VisitFencedCode(MKFencedCodeBlock(Self))
		    
		  Case MKBlockTypes.Paragraph
		    Return visitor.VisitParagraph(Self)
		    
		  Case MKBlockTypes.TextBlock
		    Return visitor.VisitTextBlock(Self)
		    
		  Case MKBlockTypes.ThematicBreak
		    Return visitor.VisitThematicBreak(Self)
		    
		  Else
		    Raise New MKException("Unknown block type.")
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4164647320746578742066726F6D205B6C696E655D20626567696E6E696E67206174205B7374617274506F735D20746F2074686520656E64206F6620746865206C696E652E
		Sub AddLine(line As TextLine, startPos As Integer)
		  /// Adds text from [line] beginning at [startPos] to the end of the line.
		  
		  // Prohibit adding new lines to closed blocks.
		  If Not Self.IsOpen Then
		    Raise New MKException("Attempted to add line " + _
		    line.Number.ToString + " to closed container " + Self.Type.ToString + ".")
		  End If
		  
		  Select Case Type
		  Case MKBlockTypes.Html
		    #Pragma Warning "TODO: Add line to HTML block"
		    
		  Case MKBlockTypes.Paragraph
		    // ===============
		    // PARAGRAPH BLOCK
		    //================
		    // Get the characters from the current line offset to the end of the line.
		    Var s As String = line.Value.MiddleCharacters(startPos)
		    
		    // Don't add empty lines.
		    If s = "" Then Return
		    
		    Self.Lines.Add(New TextLine(line.Number, line.Start + startPos, s))
		    
		  Else
		    // =====================
		    // ALL OTHER BLOCK TYPES
		    // =====================
		    // Get the characters from the current line offset to the end of the line.
		    Var s As String = line.Value.MiddleCharacters(startPos)
		    
		    // Blank line?
		    If s = "" Then
		      Children.Add(New MKBlock(MKBlockTypes.TextBlock, Self, line.Start + startPos))
		      Return
		    End If
		    
		    // Add the text as a text block.
		    Var b As New MKBlock(MKBlockTypes.TextBlock, Self, line.Start + startPos)
		    b.Lines.Add(New TextLine(line.Number, line.Start + startPos, s))
		    Children.Add(b)
		  End Select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(type As MKBlockTypes, parent As MKBlock, blockStart As Integer = 0)
		  Self.Type = type
		  Self.Parent = parent
		  Self.Start = blockStart
		  
		  If type = MKBlockTypes.TextBlock Then
		    Self.IsOpen = False
		  Else
		    Self.IsOpen = True
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546869732067656E657269632062617365206D6574686F6420636C6F736573207468697320626C6F636B2E
		Sub Finalise(line As TextLine)
		  /// This generic base method closes this block.
		  ///
		  /// Subclasses can override this method if they have more complicated needs upon block closure.
		  /// [line] is the line that triggered the `Finalise` invocation.
		  
		  // Already closed?
		  If Not IsOpen Then Return
		  
		  // Mark that we're closed.
		  IsOpen = False
		  
		  Select Case Type
		  Case MKBlockTypes.AtxHeading
		    // ============
		    // ATX HEADING
		    // ============
		    Self.Start = line.Start
		    Self.Lines.Add(New TextLine(line.Number, line.Start, line.Value))
		    
		  Case MKBlockTypes.BlockQuote
		    // ============
		    // BLOCK QUOTES
		    // ============
		    // If all children of this block quote are blank paragraphs then remove them.
		    Var removeAllChildren As Boolean = True
		    For Each child As MKBlock In Self.Children
		      If child.Type <> MKBlockTypes.Paragraph Or child.Lines.Count <> 0 Then
		        removeAllChildren = False
		        Exit
		      End If
		    Next child
		    If removeAllChildren Then Self.Children.RemoveAll
		    
		  Case MKBlockTypes.FencedCode
		    If FirstChild <> Nil Then
		      // The first child (if present) is the info string.
		      If FirstChild.Lines.Count > 0 Then
		        MKFencedCodeBlock(Self).InfoString = FirstChild.Lines(0).Value
		      Else
		        MKFencedCodeBlock(Self).InfoString = ""
		      End If
		      Children.RemoveAt(0)
		    End If
		    
		    
		  Case MKBlockTypes.Html
		    #Pragma Warning "TODO: Finalise HTML blocks"
		    
		  Case MKBlockTypes.IndentedCode
		    #Pragma Warning "TODO: Finalise indented code"
		    
		  Case MKBlockTypes.List
		    #Pragma Warning "TODO: Finalise lists"
		    
		  Case MKBlockTypes.ListItem
		    #Pragma Warning "TODO: Finalise list items"
		    
		  Case MKBlockTypes.SetextHeading
		    #Pragma Warning "TODO: Finalise Setext headings"
		    
		  End Select
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 5468697320626C6F636B2773206368696C6472656E2E
		Children() As MKBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206669727374206368696C64206F66207468697320626C6F636B206F72204E696C20696620746865726520617265206E6F206368696C6472656E2E
		#tag Getter
			Get
			  If Children.LastIndex > -1 Then
			    Return Children(0)
			  Else
			    Return Nil
			  End If
			  
			End Get
		#tag EndGetter
		FirstChild As MKBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5472756520696620746865206C617374206C696E65206F66207468697320636F6E7461696E657220697320626C616E6B2E
		IsLastLineBlank As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320626C6F636B206973206F70656E2E
		IsOpen As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206C617374206368696C64206F66207468697320626C6F636B206F72204E696C206966207468697320626C6F636B20686173206E6F206368696C6472656E2E
		#tag Getter
			Get
			  If Children.Count = 0 Then
			    Return Nil
			  Else
			    Return Children(Children.LastIndex)
			  End If
			  
			End Get
		#tag EndGetter
		LastChild As MKBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 536F6D6520626C6F636B7320686176652061206C6576656C2028652E672E20686561646572206C6576656C20666F722041545820626C6F636B73292E
		Level As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520312D6261736564206C696E65206E756D62657220696E20746865204D61726B646F776E20646F776E2074686174207468697320626C6F636B206F6363757273206F6E2E
		LineNumber As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E79206C696E6573206F6620746578742077697468696E207468697320626C6F636B2061667465722070617273696E672074686520626C6F636B207374727563747572652E205468657920747261636B2074686520737461727420706F736974696F6E206F6620746865697220636F6E74656E74732E
		Lines() As TextLine
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 41207765616B207265666572656E636520746F207468697320626C6F636B277320706172656E742E2057696C6C206265204E696C2069662074686973206973206120646F63756D656E7420626C6F636B2E
		Private mParent As WeakRef
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 5468697320626C6F636B277320706172656E74206F72204E696C20696620697420756E6F776E6564206F72206973206120646F63756D656E7420626C6F636B2E
		#tag Getter
			Get
			  If mParent <> Nil Then
			    Return MKBlock(mParent.Value)
			  Else
			    Return Nil
			  End If
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value = Nil Then
			    mParent = Nil
			  Else
			    mParent = New WeakRef(value)
			  End If
			  
			End Set
		#tag EndSetter
		Parent As MKBlock
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 54686520302D626173656420706F736974696F6E20696E20746865206F726967696E616C204D61726B646F776E20736F757263652074686174207468697320626C6F636B20626567696E732061742E
		Start As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652074797065206F6620626C6F636B2E
		Type As MKBlockTypes = MKBlockTypes.Block
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
				"3 - Document"
				"4 - FencedCode"
				"5 - Html"
				"6 - IndentedCode"
				"7 - List"
				"8 - ListItem"
				"9 - Paragraph"
				"10 - ReferenceDefinition"
				"11 - SetextHeading"
				"12 - TextBlock"
				"13 - ThematicBreak"
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
			Name="Level"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
