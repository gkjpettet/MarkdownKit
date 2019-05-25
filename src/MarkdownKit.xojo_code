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


	#tag Property, Flags = &h21, Description = 412064696374696F6E617279206F6620746865206368617261637465727320746861742061726520657363617061626C65206279206120707265636564696E67206261636B736C617368
		Private mEscapableCharacters As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInitialised As Boolean = False
	#tag EndProperty


	#tag Enum, Name = BlockType, Flags = &h1
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
