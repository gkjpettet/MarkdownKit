#tag Module
Protected Module MarkdownKit
	#tag Method, Flags = &h21
		Private Sub AppendArray(Extends array1() As String, array2() As String)
		  // Appends the contents of array2 to array1.
		  // Has no effect on array2 but mutates array2.
		  
		  Dim array2LastIndex As Integer = array2.LastIndex
		  If array2LastIndex < 0 Then Return
		  
		  Dim i As Integer
		  For i = 0 To array2LastIndex
		    array1.Add(array2(i))
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Initialise()
		  If mInitialised Then Return
		  
		  InitialiseEscapableCharactersDictionary
		  
		  BlockScanner.Initialise
		  InlineScanner.Initialise
		  Utilities.Initialise
		  
		  mInitialised = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitialiseEscapableCharactersDictionary()
		  // This Dictionary provides fast lookup for characters that can be 
		  // escaped with a preceding backslash.
		  
		  mEscapableCharacters = New Dictionary
		  
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
		  mEscapableCharacters.Value("\") = 0
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

	#tag Method, Flags = &h21
		Private Function IsBlank(Extends chars() As String) As Boolean
		  // Returns True if this array of characters is empty or contains only whitespace.
		  If chars.LastIndex = - 1 Then Return True
		  
		  Dim charsLastIndex As Integer = chars.LastIndex
		  Dim i As Integer
		  For i = 0 To charsLastIndex
		    Select Case Chars(i)
		    Case " ", &u0009
		      // Continue...
		    Else
		      Return False
		    End Select
		  Next i
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsEscapable(char As String) As Boolean
		  // Is the passed character a backslash-escapable character?
		  Return mEscapableCharacters.HasKey(char)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Peek(chars() As String, pos As Integer, char As String) As Boolean
		  // Returns True if the character at position `pos` is `char`.
		  
		  If pos < 0 Or pos > chars.LastIndex Then Return False
		  Return If(chars(pos) = char, True, False)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub RemoveLeft(Extends source() As String, length As Integer)
		  // Removes `length` elements from the start of the passed array.
		  
		  If length <= 0 Or (length - 1) > source.LastIndex Then
		    Raise New MarkdownKit.MarkdownException( _
		    "Invalid parameters provided to the MarkdownKit.RemoveLeft method")
		  End If
		  
		  Dim remaining As Integer = length
		  Do Until remaining = 0
		    source.RemoveAt(0)
		    remaining = remaining - 1
		  Loop
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StripLeadingWhitespace(chars() As String)
		  // Takes a ByRef array of characters and removes contiguous whitespace 
		  // characters from the beginning of it.
		  // Whitespace characters are &u0020, &u0009.
		  
		  Dim i As Integer
		  Dim c As String
		  For i = chars.LastIndex DownTo 0
		    c = chars(0)
		    Select Case c
		    Case &u0020, &u0009, &u000A
		      chars.RemoveAt(0)
		    Else
		      Exit
		    End Select
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StripTrailingWhitespace(chars() As String)
		  // Takes an array of characters and removes contiguous whitespace 
		  // characters from the end of it.
		  // Whitespace characters are &u0020, &u0009.
		  // Mutates the passed array.
		  
		  Dim i As Integer
		  Dim c As String
		  For i = chars.LastIndex DownTo 0
		    c = chars(chars.LastIndex)
		    Select Case c
		    Case &u0020, &u0009, &u000A
		      chars.RemoveAt(chars.LastIndex)
		    Else
		      Exit
		    End Select
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ToHTML(markdown As String) As String
		  // Takes Markdown source as a String and returns it as raw HTML.
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(markdown)
		  
		  // Create the AST.
		  doc.ParseBlockStructure
		  doc.ParseInlines
		  
		  // Create a HTML renderer to walk the AST.
		  Dim renderer As New MarkdownKit.HTMLRenderer
		  renderer.VisitDocument(doc)
		  
		  Return renderer.Output
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToString(Extends chars() As String, start As Integer, length As Integer) As String
		  // Grabs `length` characters from the passed character array beginning at `start` 
		  // and returns them as a concatenated String.
		  // If any of the passed parameters are out of range then we return "".
		  
		  Dim charsLastIndex As Integer = chars.LastIndex
		  
		  If start < 0 Or start > charsLastIndex Or length <= 0 Or _
		  (start + length - 1 > charsLastIndex) Then Return ""
		  
		  Dim limit As Integer = start + length - 1
		  Dim tmp() As String
		  For i As Integer = start To limit
		    tmp.Add(chars(i))
		  Next i
		  
		  Return String.FromArray(tmp, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToText(Extends type As MarkdownKit.BlockType) As String
		  // Returns a String representation of the passed MarkdownKit.BlockType.
		  
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
		  Case MarkdownKit.BlockType.HtmlBlock
		    Return "HTML"
		  Else
		    Return "Unknown block type"
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Version() As String
		  Dim major As Integer = kVersionMajor
		  Dim minor As Integer = kVersionMinor
		  Dim bug As Integer = kVersionBug
		  
		  Return major.ToText + "." + minor.ToText + "." + bug.ToText
		End Function
	#tag EndMethod


	#tag Note, Name = About
		MarkdownKit
		===========
		
		MarkdownKit is a 100% native Xojo module for converting Markdown to an 
		abstract syntax tree (AST) and thereafter to HTML. It is 100% compliant with 
		the CommonMark 0.29 specification (https://spec.commonmark.org/0.29/). It works 
		on all platforms supported by Xojo (Mac, Windows, Linux x86/ARM and iOS).
		
		## Usage.
		The easiest way to convert Markdown to HTML is to use the 
		`MarkdownKit.ToHTML()` method. This takes the Markdown source code as a String and 
		returns the HTML as a String:
		
		```xojo
		Dim html As String = MarkdownKit.ToHTML("**Hello** World!") // <p><strong>Hello</strong> World!</p>
		```
		
		If you would like access to the abstract syntax tree (AST) created by the parser 
		you can do so by creating a new `MarkdownKit.Document`:
		
		```xojo
		// Create a new Markdown document with some source code.
		Dim doc As New MarkdownKit.Document("Some **bold** `Markdown` code.")
		
		// Parse the source code into an AST.
		doc.ParseBlockStructure
		doc.ParseInlines
		
		// `doc` is now essentially an AST. You can print it out using one of the 
		// included renderers:
		Dim astRenderer As New MarkdownKit.ASTRenderer
		astRenderer.VisitDocument(doc)
		Dim ast As String = astRenderer.Output
		
		Dim htmlRenderer As New MarkdownKit.HTMLRenderer
		htmlRenderer.VisitDocument(doc)
		Dim html As String = htmlRenderer.Output
		```
		
		One of the powerful and customisable aspects of MarkdownKit is that because you 
		have access to the AST, you could write your own renderer. Perhaps one that outputs 
		LaText or some other format. You just need to create a new class that implements 
		the `MarkdownKit.IRenderer` interface.
		
	#tag EndNote


	#tag Property, Flags = &h21, Description = 412064696374696F6E617279206F6620746865206368617261637465727320746861742061726520657363617061626C65206279206120707265636564696E67206261636B736C617368
		Private mEscapableCharacters As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mInitialised As Boolean = False
	#tag EndProperty


	#tag Constant, Name = kVersionBug, Type = Double, Dynamic = False, Default = \"4", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kVersionMajor, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = kVersionMinor, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant


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
		  Block
		  TextBlock
		  Softbreak
		  Hardbreak
		  InlineText
		  Emphasis
		  Strong
		  Codespan
		  InlineHTML
		  InlineLink
		InlineImage
	#tag EndEnum

	#tag Enum, Name = InlineType, Flags = &h1
		Textual
		  Emphasis
		  Strong
		  CodeSpan
		  HTML
		  Softbreak
		  Link
		  Image
		Hardbreak
	#tag EndEnum

	#tag Enum, Name = ListDelimiter, Type = Integer, Flags = &h1, Description = 446566696E6573207468652064656C696D69746572207573656420696E2074686520736F7572636520666F72206F726465726564206C697374732E
		Period=0
		Parenthesis
	#tag EndEnum

	#tag Enum, Name = ListType, Type = Integer, Flags = &h1, Description = 446566696E6573207468652074797065206F662061206C69737420626C6F636B20656C656D656E742E
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
