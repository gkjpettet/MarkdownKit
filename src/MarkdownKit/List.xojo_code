#tag Class
Protected Class List
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IBlockVisitor)
		  visitor.VisitList(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As MarkdownKit.LineInfo)
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  // Determine tight/loose status of the list.
		  Self.ListData.IsTight = True // Tight by default.
		  
		  Dim item As MarkdownKit.Block = Self.FirstChild
		  Dim subItem As MarkdownKit.Block
		  
		  While item <> Nil
		    
		    // Check for a non-final non-empty ListItem ending with blank line.
		    If item.IsLastLineBlank And item.NextSibling <> Nil Then
		      Self.ListData.IsTight = False
		      Exit
		    End If
		    
		    // Recurse into the children of the ListItem, to see if there are spaces between them.
		    subitem = item.FirstChild
		    
		    While subItem <> Nil
		      If EndsWithBlankLine(subItem) And (item.NextSibling <> Nil Or subitem.NextSibling <> Nil) Then
		        Self.ListData.IsTight = False
		        Exit
		      End If
		      subItem = subitem.NextSibling
		    Wend
		    
		    If Not Self.ListData.IsTight Then Exit
		    
		    item = item.NextSibling
		  Wend
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="HTMLBlockType"
			Group="Behavior"
			InitialValue="kHTMLBlockTypeNone"
			Type="Integer"
		#tag EndViewProperty
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
	#tag EndViewBehavior
End Class
#tag EndClass
