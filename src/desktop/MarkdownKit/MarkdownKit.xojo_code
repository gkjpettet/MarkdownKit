#tag Module
Protected Module MarkdownKit
	#tag Method, Flags = &h0
		Function ToString(Extends type As MKBlockTypes) As String
		  // Returns a String representation of the passed block type.
		  
		  Select Case type
		  Case MKBlockTypes.AtxHeading
		    Return "ATX Heading"
		    
		  Case MKBlockTypes.BlockQuote
		    Return "Blockquote"
		    
		  Case MKBlockTypes.Document
		    Return "Document"
		    
		  Case MKBlockTypes.FencedCode
		    Return "Fenced Code"
		    
		  Case MKBlockTypes.Html
		    Return "HTML"
		    
		  Case MKBlockTypes.IndentedCode
		    Return "Indented Code"
		    
		  Case MKBlockTypes.List
		    Return "List"
		    
		  Case MKBlockTypes.ListItem
		    Return "List Item"
		    
		  Case MKBlockTypes.Paragraph
		    Return "Paragraph"
		    
		  Case MKBlockTypes.ReferenceDefinition
		    Return "Reference Definition"
		    
		  Case MKBlockTypes.SetextHeading
		    Return "Setext Heading"
		    
		  Case MKBlockTypes.ThematicBreak
		    Return "Thematic Break"
		    
		  Else
		    Return "Unknown block type"
		  End Select
		  
		End Function
	#tag EndMethod


	#tag Enum, Name = MKBlockTypes, Type = Integer, Flags = &h0
		AtxHeading
		  Block
		  BlockQuote
		  Document
		  FencedCode
		  Html
		  IndentedCode
		  List
		  ListItem
		  Paragraph
		  ReferenceDefinition
		  SetextHeading
		  TextBlock
		ThematicBreak
	#tag EndEnum


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
End Module
#tag EndModule
