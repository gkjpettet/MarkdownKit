#tag Module
Protected Module MarkdownKit
	#tag Method, Flags = &h1
		Protected Sub Initialise()
		  If mInitialised Then Return
		  
		  InitialiseEscapableCharactersDictionary
		  
		  mInitialised = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitialiseEscapableCharactersDictionary()
		  // This Dictionary provides fast lookup for characters that can be 
		  // escaped with a preceding backslash.
		  
		  mEscapableCharacters = New Xojo.Core.Dictionary
		  
		  mEscapableCharacters.Value("!") = 0
		  mEscapableCharacters.Value("""") = 0
		  mEscapableCharacters.Value("#") = 0
		  mEscapableCharacters.Value("$") = 0
		  mEscapableCharacters.Value("%") = 0
		  mEscapableCharacters.Value("&") = 0
		  mEscapableCharacters.Value("'") = 0
		  mEscapableCharacters.Value("(") = 0
		  mEscapableCharacters.Value(")") = 0
		  mEscapableCharacters.Value("*") = 0
		  mEscapableCharacters.Value("+") = 0
		  mEscapableCharacters.Value(",") = 0
		  mEscapableCharacters.Value("-") = 0
		  mEscapableCharacters.Value(".") = 0
		  mEscapableCharacters.Value("/") = 0
		  mEscapableCharacters.Value(":") = 0
		  mEscapableCharacters.Value(";") = 0
		  mEscapableCharacters.Value("<") = 0
		  mEscapableCharacters.Value("=") = 0
		  mEscapableCharacters.Value(">") = 0
		  mEscapableCharacters.Value("?") = 0
		  mEscapableCharacters.Value("@") = 0
		  mEscapableCharacters.Value("[") = 0
		  mEscapableCharacters.Value("]") = 0
		  mEscapableCharacters.Value("^") = 0
		  mEscapableCharacters.Value("_") = 0
		  mEscapableCharacters.Value("`") = 0
		  mEscapableCharacters.Value("{") = 0
		  mEscapableCharacters.Value("|") = 0
		  mEscapableCharacters.Value("}") = 0
		  mEscapableCharacters.Value("~") = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsEscaped(chars() As Text, charPos As Integer) As Boolean
		  // Takes an array of characters and the zero-based index (`charPos`) of a particular 
		  // character within that array. If the referenced character in the array is escaped 
		  // then we return True, otherwise we return False.
		  // A character is escaped if it is immediately preceded by the backslash (\) character 
		  // and the character in question is escapable.
		  // The following characters are escapable (CommonMark 0.29 6.1):
		  // !"#$%&'()*+,-./:;<=>?@[]^_`{|}~
		  
		  If charPos <= 0 Then Return False // First character.
		  
		  If chars(charPos - 1) = "\" Then
		    If mEscapableCharacters.HasKey(chars(charPos - 1)) Then
		      Return True
		    Else
		      // Not an escapable character, even though it's preceded by a backslash.
		      Return False
		    End If
		  Else
		    // No preceding backslash.
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub StripLeadingWhitespace(chars() As Text)
		  // Takes a ByRef array of characters and removes contiguous whitespace 
		  // characters from the beginning of it.
		  // Whitespace characters are &u0020, &u0009.
		  
		  Dim i As Integer
		  For i = chars.Ubound DownTo 0
		    If chars(0) = &u0020 Or chars(0) = &u0009 Then
		      chars.Remove(0)
		    Else
		      Exit
		    End If
		  Next i
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub StripTrailingWhitespace(chars() As Text)
		  // Takes a ByRef array of characters and removes contiguous whitespace 
		  // characters from the end of it.
		  // Whitespace characters are &u0020, &u0009.
		  
		  Dim i As Integer
		  For i = chars.Ubound DownTo 0
		    If chars(chars.Ubound) = &u0020 Or chars(chars.Ubound) = &u0009 Then
		      chars.Remove(chars.Ubound)
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

	#tag Property, Flags = &h21, Description = 412064696374696F6E617279206F6620746865206368617261637465727320746861742061726520657363617061626C65206279206120707265636564696E67206261636B736C617368
		Private mEscapableCharacters As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInitialised As Boolean = False
	#tag EndProperty


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

	#tag Enum, Name = BulletType, Type = Integer, Flags = &h1
		Dash
		  Plus
		Star
	#tag EndEnum

	#tag Enum, Name = ListDelimiterType, Type = Integer, Flags = &h1
		Paren
		Period
	#tag EndEnum

	#tag Enum, Name = ListType, Type = Integer, Flags = &h1
		Ordered
		Unordered
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
