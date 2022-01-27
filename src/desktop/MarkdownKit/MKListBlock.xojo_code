#tag Class
Protected Class MKListBlock
Inherits MKAbstractList
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStart As Integer = 0)
		  Super.Constructor(MKBlockTypes.List, parent, blockStart)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As TextLine = Nil)
		  Super.Finalise(line)
		  
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
		End Sub
	#tag EndMethod


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
	#tag EndViewBehavior
End Class
#tag EndClass
