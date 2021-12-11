#tag Module
Protected Module MarkdownKit
	#tag Method, Flags = &h0, Description = 54727565206966205B636861725D20697320776869746573706163652E
		Function IsMarkdownWhitespace(Extends char As String, nonBreakingSpaceIsWhitespace As Boolean = False) As Boolean
		  /// True if [char] is considered Markdown whitespace.
		  ///
		  /// If the optional [nonBreakingSpaceIsWhitespace] is True then we also 
		  /// consider a non-breaking space (&u0A0) to be whitespace.
		  
		  Select Case char
		  Case &u0020, &u0009, &u000A, ""
		    Return True
		  Else
		    If nonBreakingSpaceIsWhitespace And char = &u00A0 Then
		      Return True
		    Else
		      Return False
		    End If
		  End Select
		  
		End Function
	#tag EndMethod

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


	#tag ComputedProperty, Flags = &h1, Description = 412064696374696F6E617279206F662048544D4C20746167206E616D65732E
		#tag Getter
			Get
			  /// A dictionary of HTML tag names.
			  
			  Static d As New Dictionary( _
			  "ADDRESS" : Nil, _
			  "ARTICLE": Nil, _
			  "ASIDE": Nil, _
			  "BASE": Nil, _
			  "BASEFONT": Nil, _
			  "BLOCKQUOTE": Nil, _
			  "BODY": Nil, _
			  "CAPTION": Nil, _
			  "CENTER": Nil, _
			  "COL": Nil, _
			  "COLGROUP": Nil, _
			  "DD": Nil, _
			  "DETAILS": Nil, _
			  "DIALOG": Nil, _
			  "DIR": Nil, _
			  "DIV": Nil, _
			  "DL": Nil, _
			  "DT": Nil, _
			  "FIELDSET": Nil, _
			  "FIGCAPTION": Nil, _
			  "FIGURE": Nil, _
			  "FOOTER": Nil, _
			  "FORM": Nil, _
			  "FRAME": Nil, _
			  "FRAMESET": Nil, _
			  "H1": Nil, _
			  "H2": Nil, _
			  "H3": Nil, _
			  "H4": Nil, _
			  "H5": Nil, _
			  "H6": Nil, _
			  "HEAD": Nil, _
			  "HEADER": Nil, _
			  "HR": Nil, _
			  "HTML": Nil, _
			  "IFRAME": Nil, _
			  "LEGEND": Nil, _
			  "LI": Nil, _
			  "LINK": Nil, _
			  "MAIN": Nil, _
			  "MENU": Nil, _
			  "MENUITEM": Nil, _
			  "NAV": Nil, _
			  "NOFRAMES": Nil, _
			  "OL": Nil, _
			  "OPTGROUP": Nil, _
			  "OPTION": Nil, _
			  "P": Nil, _
			  "PARAM": Nil, _
			  "SECTION": Nil, _
			  "SOURCE": Nil, _
			  "SUMMARY": Nil, _
			  "TABLE": Nil, _
			  "TBODY": Nil, _
			  "TD": Nil, _
			  "TFOOT": Nil, _
			  "TH": Nil, _
			  "THEAD": Nil, _
			  "TITLE": Nil, _
			  "TR": Nil, _
			  "TRACK": Nil, _
			  "UL": Nil)
			  
			  Return d
			  
			End Get
		#tag EndGetter
		Protected HTMLTagNames As Dictionary
	#tag EndComputedProperty


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

	#tag Enum, Name = MKHTMLBlockTypes, Type = Integer, Flags = &h0
		None=0
		  InterruptingBlockWithEmptyLines=1
		  Comment = 2
		  ProcessingInstruction=3
		  Document = 4
		  CData = 5
		  InterruptingBlock=6
		NonInterruptingBlock=7
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
