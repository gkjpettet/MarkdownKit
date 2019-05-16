#tag Class
Protected Class FencedCode
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Accept(visitor As MarkdownKit.Walker)
		  visitor.VisitFencedCode(Self)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AcceptsLines() As Boolean
		  // Fenced code blocks can contain lines.
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CanContain(childType As MarkdownKit.BlockType) As Boolean
		  #Pragma Unused childType
		  
		  // Fenced code blocks are NOT container blocks.
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(theLine As MarkdownKit.LineInfo, charPos As Integer, charCol As Integer)
		  // Calling the overridden superclass constructor.
		  Super.Constructor(theLine, charPos, charCol)
		  Self.Type = MarkdownKit.BlockType.FencedCode
		  Self.NeedsClosing = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise()
		  #Pragma Warning "TODO: Finish"
		  
		  // Nothing to do if this block is already closed.
		  If Not Self.IsOpen Then Return
		  
		  // Mark the block as closed.
		  Self.IsOpen = False
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		InfoString As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		NeedsClosing As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F66207370616365732074686174207468697320636F64652066656E6365206973206F666673657420286D6178203D203329
		Offset As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520636861726163746572207573656420746F206F70656E207468697320636F64652066656E63652E2045697468657220226022206F7220227E22
		OpeningChar As Text
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
		#tag ViewProperty
			Name="InfoString"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
