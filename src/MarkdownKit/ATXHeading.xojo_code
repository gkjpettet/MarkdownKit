#tag Class
Protected Class ATXHeading
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.IWalker)
		  visitor.VisitATXHeading(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As MarkdownKit.LineInfo)
		  Dim p As Integer = line.CharsUbound
		  
		  // Trim trailing spaces.
		  While p >= 0 And (line.Chars(p) = " " Or line.Chars(p) = &u0009)
		    p = p - 1
		  Wend
		  
		  Dim px As Integer = p
		  
		  // If the line ends in #s, remove them.
		  while p >= 0 And line.Chars(p) = "#"
		    p = p - 1
		  Wend
		  
		  // There must be a space before the last #.
		  If p < 0 Or (line.Chars(p) <> " " And line.Chars(p) <> &u0009) Then p = px
		  
		  // Trim trailing spaces that are before the closing #s.
		  While p >= line.NextNWS And (line.Chars(p) = " " Or line.Chars(p) = &u0009)
		    p = p - 1
		  Wend
		  
		  // Add this line only if there is content.
		  If p - line.NextNWS > -1 Then AddLine(line, line.NextNWS, p - line.NextNWS + 1)
		  
		  // Close this block.
		  Self.IsOpen = False
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Level As Integer = 0
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
				"12 - Block"
				"13 - RawText"
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
	#tag EndViewBehavior
End Class
#tag EndClass
