#tag Class
Protected Class MKBlock
	#tag Method, Flags = &h0
		Function Accept(visitor As MKRenderer) As Variant
		  /// Accepts an AST renderer and redirects to the correct method.
		  
		  Select Case Self.Type
		  Case MKBlockTypes.AtxHeading
		    Return visitor.VisitATXHeading(Self)
		    
		  Case MKBlockTypes.Block
		    Return visitor.VisitBlock(Self)
		    
		  Case MKBlockTypes.BlockQuote
		    Return visitor.VisitBlockQuote(Self)
		    
		  Case MKBlockTypes.Document
		    Return visitor.VisitDocument(Self)
		    
		  Case MKBlockTypes.FencedCode
		    Return visitor.VisitFencedCode(MKFencedCodeBlock(Self))
		    
		  Case MKBlockTypes.Html
		    Return visitor.VisitHTMLBlock(MKHTMLBlock(Self))
		    
		  Case MKBlockTypes.List
		    Return visitor.VisitList(Self)
		    
		  Case MKBlockTypes.ListItem
		    Return visitor.VisitListItem(Self)
		    
		  Case MKBlockTypes.IndentedCode
		    Return visitor.VisitIndentedCode(Self)
		    
		  Case MKBlockTypes.Paragraph
		    Return visitor.VisitParagraph(Self)
		    
		  Case MKBlockTypes.SetextHeading
		    Return visitor.VisitSetextHeading(Self)
		    
		  Case MKBlockTypes.TextBlock
		    Return visitor.VisitTextBlock(MKTextBlock(Self))
		    
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
		  
		  // Get the characters from the current line offset to the end of the line.
		  Var s As String = line.Value.MiddleCharacters(startPos)
		  
		  // Don't add empty lines to paragraphs.
		  If Type = MKBlockTypes.Paragraph And s = "" Then
		    Return
		  ElseIf s = "" Then
		    Children.Add(New MKTextBlock(Self, line.Start + startPos, ""))
		    Return
		  End If
		  
		  // Add the text as a text block.
		  Var b As New MKTextBlock(Self, line.Start + startPos, s)
		  Children.Add(b)
		  
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

	#tag Method, Flags = &h0, Description = 52657475726E732054727565206966207468697320626C6F636B20656E64732077697468206120626C616E6B206C696E652C2064657363656E64696E67206966206E656564656420696E746F206C6973747320616E64207375626C697374732E
		Function EndsWithBlankLine() As Boolean
		  /// Returns True if this block ends with a blank line, descending if needed into lists and sublists.
		  
		  Var b As MKBlock = Self
		  
		  Do
		    If b.IsLastLineBlank Then Return True
		    
		    If b.Type <> MKBlockTypes.List And b.Type <> MKBlockTypes.ListItem Then Return False
		    
		    b = b.LastChild
		    
		    If b = Nil Then Return False
		  Loop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6F736573207468697320626C6F636B20616E64206D616B657320616E792066696E616C206368616E6765732074686174206D61792062652072657175697265642E
		Sub Finalise(line As TextLine)
		  /// Closes this block and makes any final changes that may be required.
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
		    Self.Children.Add(New MKTextBlock(Self, line.Start, line.Value))
		    
		  Case MKBlockTypes.BlockQuote
		    // ============
		    // BLOCK QUOTES
		    // ============
		    // If all children of this block quote are blank paragraphs then remove them.
		    Var removeAllChildren As Boolean = True
		    For Each child As MKBlock In Self.Children
		      If child.Type <> MKBlockTypes.Paragraph Or child.Children.Count <> 0 Then
		        removeAllChildren = False
		        Exit
		      End If
		    Next child
		    If removeAllChildren Then Self.Children.RemoveAll
		    
		  Case MKBlockTypes.FencedCode
		    // ============
		    // FENCED CODE
		    // ============
		    If FirstChild <> Nil Then
		      // The first child (if present) is always the info string as a text block.
		      MKFencedCodeBlock(Self).InfoString = MKTextBlock(FirstChild).Contents
		      Children.RemoveAt(0)
		    End If
		    
		  Case MKBlockTypes.List
		    // ============
		    // LISTS
		    // ============
		    // Determine tight/loose status of the list.
		    Self.ListData.IsTight = True // Tight by default.
		    
		    Var item As MKBlock = Self.FirstChild
		    Var subItem As MKBlock
		    
		    While item <> Nil
		      // Check for a non-final non-empty ListItem ending with blank line.
		      If item.IsLastLineBlank And item.NextSibling <> Nil Then
		        Self.ListData.IsTight = False
		        Exit
		      End If
		      
		      // Recurse into the children of the ListItem, to see if there are spaces between them.
		      subitem = item.FirstChild
		      While subItem <> Nil
		        If subItem.EndsWithBlankLine And (item.NextSibling <> Nil Or subitem.NextSibling <> Nil) Then
		          Self.ListData.IsTight = False
		          Exit
		        End If
		        subItem = subitem.NextSibling
		      Wend
		      
		      If Not Self.ListData.IsTight Then Exit
		      
		      item = item.NextSibling
		    Wend
		    
		    For i As Integer = 0 To Self.Children.LastIndex
		      Self.Children(i).IsChildOfTightList = Self.ListData.IsTight
		    Next i
		    
		  Case MKBlockTypes.ListItem
		    // ============
		    // LIST ITEM
		    // ============
		    For i As Integer = 0 To Self.Children.LastIndex
		      Self.Children(i).IsChildOfListItem = True
		    Next i
		    
		  Case MKBlockTypes.SetextHeading
		    #Pragma Warning "TODO: Finalise Setext headings (link reference definitions?"
		    
		  End Select
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468697320626C6F636B2773206E657874207369626C696E67206F72204E696C2069662074686572652069736E2774206F6E652E
		Function NextSibling() As MKBlock
		  /// Returns this block's next sibling or Nil if there isn't one.
		  
		  If Self.Parent = Nil Then Return Nil
		  
		  Var myIndex As Integer = Self.Parent.Children.IndexOf(Self)
		  If myIndex = -1 Then Return Nil
		  If myIndex = Self.Parent.Children.LastIndex Then
		    Return Nil
		  Else
		    Return Self.Parent.Children(myIndex + 1)
		  End If
		  
		End Function
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

	#tag Property, Flags = &h0, Description = 54727565206966207468697320626C6F636B2069732061206368696C64206F662061206C697374206974656D2E
		IsChildOfListItem As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54727565206966207468697320626C6F636B2069732061206368696C64206F662061207469676874206C6973742E
		IsChildOfTightList As Boolean = False
	#tag EndProperty

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

	#tag Property, Flags = &h0, Description = 4966207468697320626C6F636B2069732061206C6973742C20746869732069732069747320646174612E
		ListData As MKListData
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

	#tag Property, Flags = &h0, Description = 4966207468697320626C6F636B20697320612053657465787420686561646572207468656E207468697320697320746865206C656E6774682028696E206368617261637465727329206F66207468652053657465787420756E6465726C696E652E
		SetextUnderlineLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D626173656420706F736974696F6E20696E20746865206F726967696E616C20736F7572636520636F6465206F662074686520666972737420636861726163746572206F6620612053657465787420756E6465726C696E6520286966207468697320626C6F636B20697320612053657465787420686561646572292E
		SetextUnderlineStart As Integer = 0
	#tag EndProperty

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
			Name="SetextUnderlineStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SetextUnderlineLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
