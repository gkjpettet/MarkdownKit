#tag Class
Protected Class MKParagraphBlock
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStart As Integer)
		  Super.Constructor(MKBlockTypes.Paragraph, parent, blockStart)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As TextLine)
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  ParseLinkReferenceDefinitions
		  
		  // If this paragraph consists only of whitespace, empty out its character array.
		  Var seenNonWhitespace As Boolean = False
		  For Each char As MKCharacter In Characters
		    If Not char.IsMarkdownWhitespace(True) Then
		      seenNonWhitespace = True
		      Exit
		    End If
		  Next char
		  If Not seenNonWhitespace Then Characters.RemoveAll
		  
		  // Removing a single trailing line ending if present.
		  If Characters.Count > 0 And Characters(Characters.LastIndex).IsLineEnding Then Call Characters.Pop
		  
		  // Final spaces are stripped before inline parsing.
		  For i As Integer = Characters.LastIndex DownTo 0
		    Select Case Characters(i).Value
		    Case " "
		      Characters.RemoveAt(i)
		    Else
		      Exit
		    End Select
		  Next i
		  
		  // Remove this paragraph from its parent if it's empty.
		  If Characters.Count = 0 And Parent <> Nil Then
		    Var parentIndex As Integer = Parent.Children.IndexOf(Self)
		    If parentIndex <> -1 Then Parent.Children.RemoveAt(parentIndex)
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 416C6C206F66207468697320626C6F636B2773206368617261637465727320617320616E206172726179206F66204D4B43686172616374657220696E7374616E6365732E
		Private mAllCharacters() As MKCharacter
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
				"5 - Emphasis"
				"6 - FencedCode"
				"7 - Html"
				"8 - IndentedCode"
				"9 - InlineHTML"
				"10 - InlineImage"
				"11 - InlineLink"
				"12 - InlineText"
				"13 - List"
				"14 - ListItem"
				"15 - Paragraph"
				"16 - ReferenceDefinition"
				"17 - SetextHeading"
				"18 - SoftBreak"
				"19 - StrongEmphasis"
				"20 - TextBlock"
				"21 - ThematicBreak"
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
	#tag EndViewBehavior
End Class
#tag EndClass
