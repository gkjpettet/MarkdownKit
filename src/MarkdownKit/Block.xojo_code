#tag Class
Protected Class Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.Walker)
		  visitor.VisitBlock(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AcceptsLines() As Boolean
		  Raise New MarkdownKit.MarkdownException("Subclasses must override this method")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AddLine(theLine As MarkdownKit.LineInfo, startPos As Integer, startCol As Integer)
		  // Get the remaining characters from `startPos` on this line until the end.
		  
		  If Not Self.IsOpen Then
		    Raise New MarkdownKit.MarkdownException("Attempted to add line " + theLine.Number.ToText + _
		    " to closed container " + Self.Type.ToText)
		  End If
		  
		  Dim tmp() As Text
		  
		  Dim i As Integer
		  For i = startPos To theLine.CharsUbound
		    tmp.Append(theLine.Chars(i))
		  Next i
		  
		  // Determine if there is a prepending hard or a soft break?
		  If Children.Ubound >=0 Then
		    Dim rt As MarkdownKit.RawText = MarkdownKit.RawText(Children(Children.Ubound))
		    If rt.Chars.Ubound > 2 And rt.Chars(rt.Chars.Ubound) = " " And _
		      rt.Chars(rt.Chars.Ubound - 1) = " " Then
		      // The preceding raw text line ended with two spaces. This should be interpreted as a hard line break.
		      Children.Append(New MarkdownKit.HardBreak(theLine))
		    Else
		      // Soft line break
		      Children.Append(New MarkdownKit.SoftBreak(theLine))
		    End If
		    // Strip the trailing whitespace from the end of the preceding line.
		    StripTrailingWhitespace(rt.Chars)
		  End If
		  
		  // Add the raw text as the last child of this block.
		  Children.Append(New MarkdownKit.RawText(tmp, theLine, startPos, startCol))
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanContain(childType As MarkdownKit.BlockType) As Boolean
		  Raise New MarkdownKit.MarkdownException("Subclasses should override this method")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theLine As MarkdownKit.LineInfo, charPos As Integer, charCol As Integer)
		  Self.Line = theLine
		  Self.FirstCharPos = charPos
		  Self.FirstCharCol = charcol
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise()
		  // Close this block correctly.
		  
		  // Nothing to do if this block is already closed.
		  If Not Self.IsOpen Then Return
		  
		  Select Case Self.Type
		  Case MarkdownKit.BlockType.Paragraph
		    // Final spaces are stripped before inline parsing, so a 
		    // paragraph that ends with two or more spaces will not end with
		    // a hard line break.
		    If Children.Ubound >= 0 And Children(Children.Ubound) IsA MarkdownKit.RawText Then
		      // Stip trailing whitespace from this last child.
		      Dim rt As MarkdownKit.RawText = MarkdownKit.RawText(Children(Children.Ubound))
		      StripTrailingWhitespace(rt.Chars)
		    End If
		  End Select
		  
		  // Mark the block as closed.
		  Self.IsOpen = False
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextContent() As Text
		  #Pragma Warning "TODO"
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Children() As MarkdownKit.Block
	#tag EndProperty

	#tag Property, Flags = &h0
		FirstCharCol As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FirstCharPos As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		IsLastLineBlank As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 496E646963617465732077686574686572207468697320626C6F636B20656C656D656E7420686173206265656E20636F6D706C657465642028616E642074687573206E6577206C696E65732063616E6E6F7420626520616464656420746F20697429206F72206974206973207374696C6C206F70656E2E2042792064656661756C7420616C6C20656C656D656E7473206172652063726561746564206173206F70656E20616E642061726520636C6F736564207768656E20746865207061727365722064657465637473206974
		IsOpen As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  // Return the last child for this container block or Nil if there are no children.
			  If Children.Ubound = -1 Then
			    Return Nil
			  Else
			    Return Children(Children.Ubound)
			  End If
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			  Dim err As New Xojo.Core.UnsupportedOperationException
			  err.Reason = "ContainerBlock.LastChild is read only"
			  Raise err
			  
			End Set
		#tag EndSetter
		LastChild As MarkdownKit.Block
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Line As MarkdownKit.LineInfo
	#tag EndProperty

	#tag Property, Flags = &h0
		Parent As MarkdownKit.Block
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
			Name="FirstCharPos"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FirstCharCol"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
