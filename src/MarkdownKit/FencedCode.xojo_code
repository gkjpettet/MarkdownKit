#tag Class
Protected Class FencedCode
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IBlockVisitor)
		  visitor.VisitFencedCode(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As MarkdownKit.LineInfo)
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  If FirstChild <> Nil Then
		    // The first child (if present) is the info string. It may be empty.
		    Dim rt As MarkdownKit.TextBlock = MarkdownKit.TextBlock(FirstChild)
		    If Not rt.IsBlank Then
		      InfoString = Text.Join(rt.Chars, "").Trim
		    End If
		    Children.Remove(0)
		  End If
		  
		  Exception e
		    // This is a bug.
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		FenceChar As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		FenceLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		FenceOffset As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		InfoString As Text
	#tag EndProperty


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
			Name="FenceChar"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceLength"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FenceOffset"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="InfoString"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
