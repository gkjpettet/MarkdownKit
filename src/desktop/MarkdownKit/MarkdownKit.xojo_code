#tag Module
Protected Module MarkdownKit
	#tag Method, Flags = &h0, Description = 547275652069662074686520636861726163746572206174205B706F735D206973206573636170656420287072656365646564206279206120286E6F6E2D6573636170656429206261636B736C61736820636861726163746572292E
		Function IsMarkdownEscaped(chars() As String, pos As Integer) As Boolean
		  /// True if the character at [pos] is escaped (preceded by a (non-escaped) backslash character).
		  
		  If pos > chars.LastIndex or pos = 0 Then Return False
		  
		  If chars(pos - 1) = "\" And Not IsMarkdownEscaped(chars, pos - 1) Then
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

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


	#tag Constant, Name = MAX_REFERENCE_LABEL_LENGTH, Type = Double, Dynamic = False, Default = \"999", Scope = Protected, Description = 546865206D6178696D756D206E756D626572206F662063686172616374657273207065726D69747465642077697468696E207468652073717561726520627261636B657473206F662061206C696E6B206C6162656C2E
	#tag EndConstant


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

	#tag Enum, Name = MKListDelimiters, Type = Integer, Flags = &h0, Description = 446566696E6573207468652064656C696D69746572207573656420696E2074686520736F7572636520666F72206F726465726564206C697374732E
		Period=0
		Parenthesis
	#tag EndEnum

	#tag Enum, Name = MKListTypes, Type = Integer, Flags = &h0, Description = 446566696E6573207468652074797065206F662061206C69737420626C6F636B20656C656D656E742E
		Bullet=0
		Ordered=1
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
