#tag Module
Protected Module MarkdownKit
	#tag Method, Flags = &h1
		Protected Sub StripTrailingWhitespace(chars() As Text)
		  // Takes a ByRef array of characters and removes contiguous whitespace 
		  // characters from the end of it.
		  // Whitespace characters are &u0020, &u0009.
		  
		  Dim i, tmp As Integer
		  For i = chars.Ubound DownTo 0
		    tmp = chars.Ubound
		    If chars(tmp) = &u0020 Or chars(tmp) = &u0009 Then
		      chars.Remove(tmp)
		    Else
		      Exit
		    End If
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToText(Extends type As MarkdownKit.BlockType) As Text
		  Select Case type
		  Case MarkdownKit.BlockType.AtxHeading
		    Return "ATX Heading"
		  Case MarkdownKit.BlockType.BlockQuote
		    Return "Blockquote"
		  Case MarkdownKit.BlockType.Document
		    Return "Document"
		  Case MarkdownKit.BlockType.FencedCode
		    Return "Fenced Code"
		  Case MarkdownKit.BlockType.HtmlBlock
		    Return "HTML Block"
		  Case MarkdownKit.BlockType.IndentedCode
		    Return "Indented Code"
		  Case MarkdownKit.BlockType.List
		    Return "List"
		  Case MarkdownKit.BlockType.ListItem
		    Return "List Item"
		  Case MarkdownKit.BlockType.Paragraph
		    Return "Paragraph"
		  Case MarkdownKit.BlockType.ReferenceDefinition
		    Return "Reference Definition"
		  Case MarkdownKit.BlockType.SetextHeading
		    Return "Setext Heading"
		  Case MarkdownKit.BlockType.ThematicBreak
		    Return "Thematic Break"
		  Else
		    Return "Unknown block type"
		  End Select
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u000D
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			End Set
		#tag EndSetter
		Protected kCR As Text
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u000D + &u000A
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			End Set
		#tag EndSetter
		Protected kCRLF As Text
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u000A
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			End Set
		#tag EndSetter
		Protected kLF As Text
	#tag EndComputedProperty


	#tag Constant, Name = kCommonMarkSpecVersion, Type = Text, Dynamic = False, Default = \"0.29", Scope = Protected, Description = 54686520436F6D6D6F6E4D61726B2073706563696669636174696F6E2076657273696F6E2074686174204D61726B646F776E4B697420636F6E666F726D7320746F
	#tag EndConstant


	#tag Enum, Name = BlockType, Type = Integer, Flags = &h1
		Document
		  BlockQuote
		  List
		  ListItem
		  FencedCode
		  IndentedCode
		  HtmlBlock
		  Paragraph
		  AtxHeading
		  SetextHeading
		  ThematicBreak
		ReferenceDefinition
	#tag EndEnum


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
	#tag EndViewBehavior
End Module
#tag EndModule
