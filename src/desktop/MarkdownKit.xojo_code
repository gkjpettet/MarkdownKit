#tag Module
Protected Module MarkdownKit
	#tag Method, Flags = &h1, Description = 5265647563657320636F6E736563757469766520696E7465726E616C207768697465737061636520746F20612073696E676C652073706163652E
		Protected Function CollapseInternalWhitespace(s As String) As String
		  /// Reduces consecutive internal whitespace to a single space.
		  
		  // Exit early if there's no whitespace in [s].
		  If s.IndexOf(" ") = -1 And s.IndexOf(&u0009) = -1 And s.IndexOf(&u0A) = -1 Then Return s
		  
		  Var chars() As String = s.CharacterArray
		  Var tmp() As String
		  
		  // Find the first non-space character.
		  Var charsLastIndex As Integer = chars.LastIndex
		  Var start As Integer = -1
		  For i As Integer = 0 To charsLastIndex
		    Select Case chars(i)
		    Case " ", &u0009, &u0A
		      Continue
		    Else
		      start = i
		      Exit
		    End Select
		  Next i
		  If start = -1 Then Return s
		  
		  // Find the last non-space character.
		  Var finish As Integer = start
		  For i As Integer = charsLastIndex DownTo start
		    Select Case chars(i)
		    Case " ", &u0009, &u0A
		      Continue
		    Else
		      finish = i
		      Exit
		    End Select
		  Next i
		  If finish = start Then Return s
		  
		  // Collapse internal whitespace.
		  Var previousCharWasWhitespace As Boolean = False
		  For i As Integer = start To finish
		    Var char As String = chars(i)
		    Select Case char
		    Case " ", &u0009, &u0A
		      If Not previousCharWasWhitespace Then tmp.Add(" ")
		      previousCharWasWhitespace = True
		    Else
		      tmp.Add(char)
		      previousCharWasWhitespace = False
		    End Select
		  Next i
		  
		  Return String.FromArray(tmp, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73206120737472696E672066726F6D205B63686172735D20626567696E6E696E6720617420696E646578205B73746172745D20666F72205B6C656E6774685D20636861726163746572732E20417373756D6573205B63686172735D20697320616E206172726179206F6620696E646976696475616C20636861726163746572732E
		Protected Function FromMKCharacterArray(chars() As String, start As Integer, length As Integer = -1) As String
		  /// Returns a string from [chars] beginning at index [start] for [length] characters. 
		  /// Assumes [chars] is an array of individual characters.
		  ///
		  /// If `start + length` > the number of remaining characters then all characters from [start] to the
		  /// end of [chars] are returned.
		  /// If [length] = `-1` then all characters from [start] to the end of [chars] are returned.
		  
		  Var tmp() As String
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  Var finish As Integer
		  If start + length > charsLastIndex Or length = -1 Then
		    finish = charsLastIndex
		  Else
		    finish = start + length - 1
		  End If
		  
		  For i As Integer = start To finish
		    tmp.Add(chars(i))
		  Next i
		  
		  Return String.FromArray(tmp, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54727565206966205B636861725D2069732061206261636B736C6173682D657363617061626C65206368617261637465722E
		Private Function IsEscapable(char As String) As Boolean
		  /// True if [char] is a backslash-escapable character.
		  
		  Return EscapableCharacters.HasKey(char)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 547275652069662074686520636861726163746572206174205B706F736974696F6E5D2069732065736361706564202870726563656465642062792061206E6F6E2D65736361706564206261636B736C61736820636861726163746572292E496620706F73203E2063686172732E4C617374496E646578206F7220706F73203D2030205468656E2052657475726E2046616C7365
		Function IsEscaped(Extends chars() As MKCharacter, position As Integer) As Boolean
		  /// True if the character at [position] is escaped (preceded by a non-escaped backslash character).If pos > chars.LastIndex or pos = 0 Then Return False
		  
		  If position <= 0 Then Return False
		  
		  If chars(position - 1).Value = "\" And Not chars.IsEscaped(position - 1) Then
		    Return True
		  Else
		    Return False
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 547275652069662074686520636861726163746572206174205B706F735D2069732065736361706564202870726563656465642062792061206E6F6E2D65736361706564206261636B736C61736820636861726163746572292E
		Function IsMarkdownEscaped(chars() As MKCharacter, pos As Integer) As Boolean
		  /// True if the character at [pos] is escaped (preceded by a non-escaped backslash character).
		  
		  If pos > chars.LastIndex or pos = 0 Then Return False
		  
		  If chars(pos - 1).Value = "\" And Not IsMarkdownEscaped(chars, pos - 1) Then
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 547275652069662074686520636861726163746572206174205B706F735D2069732065736361706564202870726563656465642062792061206E6F6E2D65736361706564206261636B736C61736820636861726163746572292E
		Function IsMarkdownEscaped(chars() As String, pos As Integer) As Boolean
		  /// True if the character at [pos] is escaped (preceded by a non-escaped backslash character).
		  
		  If pos > chars.LastIndex or pos = 0 Then Return False
		  
		  If chars(pos - 1) = "\" And Not IsMarkdownEscaped(chars, pos - 1) Then
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54727565206966205B636861725D20697320636F6E73696465726564204D61726B646F776E20776869746573706163652E
		Function IsMarkdownWhitespace(Extends char As MKCharacter, lineEndingIsWhitespace As Boolean = False) As Boolean
		  /// True if [char] is considered Markdown whitespace.
		  ///
		  /// If the optional [lineEndingIsWhitespace] is True then we also consider a line ending to be whitespace.
		  
		  Select Case char.Value
		  Case &u0020, &u0009, &uA0
		    Return True
		  Else
		    If lineEndingIsWhitespace And char.IsLineEnding Then
		      Return True
		    Else
		      Return False
		    End If
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54727565206966205B636861725D20697320776869746573706163652E
		Function IsMarkdownWhitespace(Extends char As String) As Boolean
		  /// True if [char] is considered Markdown whitespace.
		  
		  Select Case char
		  Case &u0020, &u0009, ""
		    Return True
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54727565206966205B636861725D206973204D61726B646F776E2070756E6374756174696F6E2E
		Function IsPunctuation(Extends char As MKCharacter) As Boolean
		  /// True if [char] is Markdown punctuation.
		  
		  Select Case char.Value
		  Case "!", """", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", _
		    "/", ":", ";", "<", "=", ">", "?", "@", "[", "\", "]", "^", "_", "`", _
		    "{", "|", "}", "~"
		    Return True
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73205B735D20617320616E206172726179206F66204D4B43686172616374657220696E7374616E6365732E
		Function MKCharacters(Extends s As String, line As TextLine, localStartOffset As Integer = 0) As MKCharacter()
		  /// Returns [s] as an array of MKCharacter instances. 
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var chars() As MKCharacter
		  
		  Var i As Integer = 0
		  For Each char As String In s.Characters
		    chars.Add(New MKCharacter(char, line, i + localStartOffset))
		    i = i + 1
		  Next char
		  
		  Return chars
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub ReplaceEntities(chars() As String)
		  /// Replaces any HTML entities defined in [chars] with their corresponding unicode character.
		  ///
		  /// The document https://html.spec.whatwg.org/multipage/entities.json is used as an authoritative 
		  /// source for the valid entity references and their corresponding code points.
		  ///
		  /// Entity reference: 
		  /// "&", a valid HTML5 entity name, ";"
		  ///
		  /// Decimal numeric character reference:
		  /// &#[0-9]{1–7};
		  ///
		  /// Hexadecimal numeric character reference:
		  /// &#[Xx][a-fA-F0-9]{1-6};
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  // Quick check to see if we can bail early.
		  Var start As Integer = chars.IndexOf("&")
		  If start = -1 Or chars.IndexOf(";") = -1 Then Return
		  
		  Var c As String
		  Var tmp() As String
		  Var i As Integer = start
		  Var xLimit As Integer
		  Var codePoint As Integer
		  Var seenSemiColon As Boolean = False
		  While i < chars.LastIndex
		    tmp.RemoveAll
		    seenSemiColon = False
		    c = chars(i)
		    
		    // Expect an unescaped "&".
		    If c <> "&" Then Return
		    If IsMarkdownEscaped(chars, i) Then
		      i = i + 1
		      If i > chars.LastIndex Then Return
		      // Any other potential references?
		      start = chars.IndexOf("&", i)
		      If start = -1 Then
		        Return
		      Else
		        i = start
		      End If
		    End If
		    i = i + 1
		    If i > chars.LastIndex Then Return
		    
		    c = chars(i)
		    If c = "#" Then
		      // ===========================
		      // NUMERIC CHARACTER REFERENCE
		      // ===========================
		      i = i + 1
		      If i > chars.LastIndex Then Return
		      c = chars(i)
		      
		      If c = "X" Then
		        // ========================
		        // HEX CHARACTER REFERENCE?
		        // ========================
		        xLimit = Min(chars.LastIndex, i + 7)
		        If i + 1 > chars.LastIndex Then Return
		        For x As Integer = i + 1 To xLimit
		          c = chars(x)
		          If C.IsHexDigit Then
		            tmp.Add(c)
		          ElseIf c = ";" Then
		            seenSemiColon = True
		            Exit
		          Else
		            // Any other potential references?
		            start = chars.IndexOf("&", x)
		            If start = -1 Then
		              Return
		            Else
		              i = start
		              Continue While
		            End If
		          End If
		        Next x
		        
		        If seenSemiColon And tmp.LastIndex > -1 Then
		          // `tmp` contains the hex value of the codepoint.
		          // Remove the characters in `chars` that make up this reference.
		          For x As Integer = 1 To tmp.LastIndex + 5
		            chars.RemoveAt(start)
		          Next x
		          chars.AddAt(start, Text.FromUnicodeCodepoint(Integer.FromHex(String.FromArray(tmp, ""))))
		          // Any other potential references?
		          i = start + 1
		          If i > chars.LastIndex Then Return
		          start = chars.IndexOf("&", i)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        Else
		          // Any other potential references?
		          i = i + 1
		          If i > chars.LastIndex Then Return
		          start = chars.IndexOf("&", i)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        End If
		        
		        // Any other potential references?
		        start = chars.IndexOf("&")
		        If start = -1 Then
		          Return
		        Else
		          i = start
		          Continue While
		        End If
		        
		      ElseIf c.IsDigit Then
		        // ============================
		        // DECIMAL CHARACTER REFERENCE?
		        // ============================
		        xLimit = Min(chars.LastIndex, i + 6)
		        If i + 1 > chars.LastIndex Then Return
		        For x As Integer = i To xLimit
		          c = chars(x)
		          If c.IsDigit Then
		            tmp.Add(c)
		          ElseIf c = ";" Then
		            seenSemiColon = True
		            Exit
		          Else
		            // Any other potential references?
		            start = chars.IndexOf("&", x)
		            If start = -1 Then
		              Return
		            Else
		              i = start
		              Continue While
		            End If
		          End If
		        Next x
		        
		        If seenSemiColon And tmp.LastIndex > -1 Then
		          // `tmp` contains the decimal value of the codepoint.
		          // Remove the characters in `chars` that make up this reference.
		          For x As Integer = 1 To tmp.LastIndex + 4
		            chars.RemoveAt(start)
		          Next x
		          codePoint = Integer.FromString(String.FromArray(tmp, ""))
		          // For security reasons, the code point U+0000 is replaced by U+FFFD.
		          If codePoint = 0 Then codePoint = &hFFFD
		          chars.AddAt(start, Text.FromUnicodeCodepoint(codePoint))
		          // Any other potential references?
		          i = start + 1
		          If i > chars.LastIndex Then Return
		          start = chars.IndexOf("&", i)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        Else
		          // Any other potential references?
		          i = i + 1
		          If i > chars.LastIndex Then Return
		          start = chars.IndexOf("&", i)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        End If
		        
		      Else
		        start = chars.IndexOf("&", i)
		        If start = -1 Then
		          Return
		        Else
		          i = start
		          Continue While
		        End If
		      End If
		      
		    ElseIf c.IsASCIILetterOrDigit Then
		      // =================
		      // ENTITY REFERENCE?
		      // =================
		      // The longest entity reference is 31 characters.
		      xLimit = Min(chars.LastIndex, i + 30)
		      If i + 1 > chars.LastIndex Then Return
		      For x As Integer = i To xLimit
		        c = chars(x)
		        If C.IsASCIILetterOrDigit Then
		          tmp.Add(c)
		        ElseIf c = ";" Then
		          seenSemiColon = True
		          Exit
		        Else
		          // Any other potential references?
		          start = chars.IndexOf("&", x)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        End If
		      Next x
		      If Not seenSemiColon Then Return
		      // `tmp` contains the HTML entity reference name.
		      // Is this a valid entity name?
		      Var entityName As String = String.FromArray(tmp, "")
		      If CharacterReferences.HasKey(entityName) Then
		        // Remove the characters in `chars` that make up this reference.
		        For x As Integer = 1 To tmp.LastIndex + 3
		          chars.RemoveAt(start)
		        Next x
		        chars.AddAt(start, Text.FromUnicodeCodepoint(CharacterReferences.Value(entityName)))
		      End If
		      
		      // Any other potential references?
		      i = start + 1
		      If i > chars.LastIndex Then Return
		      start = chars.IndexOf("&", i)
		      If start = -1 Then
		        Return
		      Else
		        i = start
		        Continue While
		      End If
		      
		    Else
		      // Any other potential references?
		      start = chars.IndexOf("&", i)
		      If start = -1 Then
		        Return
		      Else
		        i = start
		      End If
		    End If
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 5265706C6163657320616E792048544D4C20656E74697469657320696E205B735D207769746820746865697220636F72726573706F6E64696E6720756E69636F6465206368617261637465722E
		Protected Function ReplaceEntities(s As String) As String
		  /// Replaces any HTML entities in [s] with their corresponding unicode character.
		  
		  If s.IndexOf("&") = -1 Or s.IndexOf(";") = -1 Then
		    Return s
		  Else
		    Var tmp() As String = s.Split("")
		    ReplaceEntities(tmp)
		    Return String.FromArray(tmp, "")
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E7320746865205B6D61726B646F776E5D20737472696E672061732061204D61726B646F776E20646F63756D656E74202861736274726163742073796E7461782074726565292E
		Protected Function ToDocument(markdown As String) As MarkdownKit.MKDocument
		  /// Returns the [markdown] string as a Markdown document (asbtract syntax tree).
		  
		  If mParser = Nil Then mParser = New MarkdownKit.MKParser
		  
		  Return mParser.ParseSource(markdown)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E7320746865205B6D61726B646F776E5D20737472696E672061732048544D4C2E
		Protected Function ToHTML(markdown As String) As String
		  /// Returns the [markdown] string as HTML.
		  
		  If mParser = Nil Then mParser = New MarkdownKit.MKParser
		  
		  Var doc As MarkdownKit.MKDocument = mParser.ParseSource(markdown)
		  
		  Var htmlRenderer As New MarkdownKit.MKHTMLRenderer
		  
		  Return htmlRenderer.VisitDocument(doc)
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

	#tag Method, Flags = &h0, Description = 436F6E7665727420616E206172726179206F66204D4B43686172616374657220696E7374616E63657320746F206120737472696E672E
		Function ToString(Extends chars() As MKCharacter) As String
		  /// Convert an array of MKCharacter instances to a string.
		  
		  Var tmp() As String
		  For Each c As MKCharacter In chars
		    If c.IsLineEnding Then
		      tmp.Add(&u0A)
		    Else
		      tmp.Add(c.Value)
		    End If
		  Next c
		  
		  Return String.FromArray(tmp, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E672066726F6D205B63686172735D20626567696E6E696E6720617420696E646578205B73746172745D20666F72205B6C656E6774685D20636861726163746572732E
		Function ToString(Extends chars() As MKCharacter, start As Integer, length As Integer) As String
		  /// Returns a string from [chars] beginning at index [start] for [length] characters. 
		  ///
		  /// If `start + length` > the number of remaining characters then all characters from [start] to the
		  /// end of [chars] are returned.
		  /// If [length] = `-1` then all characters from [start] to the end of [chars] are returned.
		  
		  Var tmp() As String
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  Var finish As Integer
		  If start + length > charsLastIndex Or length = -1 Then
		    finish = charsLastIndex
		  Else
		    finish = start + length - 1
		  End If
		  
		  For i As Integer = start To finish
		    If chars(i).IsLineEnding Then
		      tmp.Add(&u0A)
		    Else
		      tmp.Add(chars(i).Value)
		    End If
		  Next i
		  
		  Return String.FromArray(tmp, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E7665727473206261636B736C6173682065736361706564206368617261637465727320696E205B735D20746F207468656972206C69746572616C206368617261637465722076616C75652E204D757461746573205B735D2E
		Sub Unescape(ByRef s As String)
		  /// Converts backslash escaped characters in [s] to their literal character value. Mutates [s].
		  
		  If s.IndexOf("\") = -1 Then Return
		  
		  Var chars() As String = s.CharacterArray
		  Var pos As Integer = 0
		  Var c As String
		  Do Until pos > chars.LastIndex
		    c = chars(pos)
		    If c = "\" And pos < chars.LastIndex And IsEscapable(chars(pos + 1)) Then
		      // Remove the backslash from the array.
		      chars.RemoveAt(pos)
		    End If
		    pos = pos + 1
		  Loop
		  
		  s = String.FromArray(chars, "")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E7665727473206261636B736C6173682065736361706564206368617261637465727320746F207468656972206C69746572616C206368617261637465722076616C75652E204D757461746573205B63686172735D2E
		Protected Sub Unescape(chars() As String)
		  /// Converts backslash escaped characters to their literal character value. Mutates [chars].
		  
		  If chars.IndexOf("\") = -1 Then Return
		  
		  Var pos As Integer = 0
		  Var c As String
		  Do Until pos > chars.LastIndex
		    c = chars(pos)
		    If c = "\" And pos < chars.LastIndex And IsEscapable(chars(pos + 1)) Then
		      // Remove the backslash from the array.
		      chars.RemoveAt(pos)
		    End If
		    pos = pos + 1
		  Loop
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h1, Description = 4120636173652D73656E7369746976652064696374696F6E61727920636F6E7461696E696E67207468652048544D4C20656E74697479207265666572656E63657320616E6420746865697220636F72726573706F6E64696E6720756E69636F646520636F6465706F696E74732E204B6579203D20656E746974792C2056616C7565203D20636F6465706F696E742E
		#tag Getter
			Get
			  /// A dictionary containing the HTML entity references and their corresponding unicode codepoints.
			  /// Key = entity, Value = codepoint.
			  
			  Static d As New CaseSensitiveDictionary( True, _
			  "AElig" : 198, _
			  "AMP" : 38, _
			  "Aacute" : 193, _
			  "Abreve" : 258, _
			  "Acirc" : 194, _
			  "Acy" : 1040, _
			  "Afr" : 120068, _
			  "Agrave" : 192, _
			  "Alpha" : 913, _
			  "Amacr" : 256, _
			  "And" : 10835, _
			  "Aogon" : 260, _
			  "Aopf" : 120120, _
			  "ApplyFunction" : 8289, _
			  "Aring" : 197, _
			  "Ascr" : 119964, _
			  "Assign" : 8788, _
			  "Atilde" : 195, _
			  "Auml" : 196, _
			  "Backslash" : 8726, _
			  "Barv" : 10983, _
			  "Barwed" : 8966, _
			  "Bcy" : 1041, _
			  "Because" : 8757, _
			  "Bernoullis" : 8492, _
			  "Beta" : 914, _
			  "Bfr" : 120069, _
			  "Bopf" : 120121, _
			  "Breve" : 728, _
			  "Bscr" : 8492, _
			  "Bumpeq" : 8782, _
			  "CHcy" : 1063, _
			  "COPY" : 169, _
			  "Cacute" : 262, _
			  "Cap" : 8914, _
			  "CapitalDifferentialD" : 8517, _
			  "Cayleys" : 8493, _
			  "Ccaron" : 268, _
			  "Ccedil" : 199, _
			  "Ccirc" : 264, _
			  "Cconint" : 8752, _
			  "Cdot" : 266, _
			  "Cedilla" : 184, _
			  "CenterDot" : 183, _
			  "Cfr" : 8493, _
			  "Chi" : 935, _
			  "CircleDot" : 8857, _
			  "CircleMinus" : 8854, _
			  "CirclePlus" : 8853, _
			  "CircleTimes" : 8855, _
			  "ClockwiseContourIntegral" : 8754, _
			  "CloseCurlyDoubleQuote" : 8221, _
			  "CloseCurlyQuote" : 8217, _
			  "Colon" : 8759, _
			  "Colone" : 10868, _
			  "Congruent" : 8801, _
			  "Conint" : 8751, _
			  "ContourIntegral" : 8750, _
			  "Copf" : 8450, _
			  "Coproduct" : 8720, _
			  "CounterClockwiseContourIntegral" : 8755, _
			  "Cross" : 10799, _
			  "Cscr" : 119966, _
			  "Cup" : 8915, _
			  "CupCap" : 8781, _
			  "DD" : 8517, _
			  "DDotrahd" : 10513, _
			  "DJcy" : 1026, _
			  "DScy" : 1029, _
			  "DZcy" : 1039, _
			  "Dagger" : 8225, _
			  "Darr" : 8609, _
			  "Dashv" : 10980, _
			  "Dcaron" : 270, _
			  "Dcy" : 1044, _
			  "Del" : 8711, _
			  "Delta" : 916, _
			  "Dfr" : 120071, _
			  "DiacriticalAcute" : 180, _
			  "DiacriticalDot" : 729, _
			  "DiacriticalDoubleAcute" : 733, _
			  "DiacriticalGrave" : 96, _
			  "DiacriticalTilde" : 732, _
			  "Diamond" : 8900, _
			  "DifferentialD" : 8518, _
			  "Dopf" : 120123, _
			  "Dot" : 168, _
			  "DotDot" : 8412, _
			  "DotEqual" : 8784, _
			  "DoubleContourIntegral" : 8751, _
			  "DoubleDot" : 168, _
			  "DoubleDownArrow" : 8659, _
			  "DoubleLeftArrow" : 8656, _
			  "DoubleLeftRightArrow" : 8660, _
			  "DoubleLeftTee" : 10980, _
			  "DoubleLongLeftArrow" : 10232, _
			  "DoubleLongLeftRightArrow" : 10234, _
			  "DoubleLongRightArrow" : 10233, _
			  "DoubleRightArrow" : 8658, _
			  "DoubleRightTee" : 8872, _
			  "DoubleUpArrow" : 8657, _
			  "DoubleUpDownArrow" : 8661, _
			  "DoubleVerticalBar" : 8741, _
			  "DownArrow" : 8595, _
			  "DownArrowBar" : 10515, _
			  "DownArrowUpArrow" : 8693, _
			  "DownBreve" : 785, _
			  "DownLeftRightVector" : 10576, _
			  "DownLeftTeeVector" : 10590, _
			  "DownLeftVector" : 8637, _
			  "DownLeftVectorBar" : 10582, _
			  "DownRightTeeVector" : 10591, _
			  "DownRightVector" : 8641, _
			  "DownRightVectorBar" : 10583, _
			  "DownTee" : 8868, _
			  "DownTeeArrow" : 8615, _
			  "Downarrow" : 8659, _
			  "Dscr" : 119967, _
			  "Dstrok" : 272, _
			  "ENG" : 330, _
			  "ETH" : 208, _
			  "Eacute" : 201, _
			  "Ecaron" : 282, _
			  "Ecirc" : 202, _
			  "Ecy" : 1069, _
			  "Edot" : 278, _
			  "Efr" : 120072, _
			  "Egrave" : 200, _
			  "Element" : 8712, _
			  "Emacr" : 274, _
			  "EmptySmallSquare" : 9723, _
			  "EmptyVerySmallSquare" : 9643, _
			  "Eogon" : 280, _
			  "Eopf" : 120124, _
			  "Epsilon" : 917, _
			  "Equal" : 10869, _
			  "EqualTilde" : 8770, _
			  "Equilibrium" : 8652, _
			  "Escr" : 8496, _
			  "Esim" : 10867, _
			  "Eta" : 919, _
			  "Euml" : 203, _
			  "Exists" : 8707, _
			  "ExponentialE" : 8519, _
			  "Fcy" : 1060, _
			  "Ffr" : 120073, _
			  "FilledSmallSquare" : 9724, _
			  "FilledVerySmallSquare" : 9642, _
			  "Fopf" : 120125, _
			  "ForAll" : 8704, _
			  "Fouriertrf" : 8497, _
			  "Fscr" : 8497, _
			  "GJcy" : 1027, _
			  "GT" : 62, _
			  "Gamma" : 915, _
			  "Gammad" : 988, _
			  "Gbreve" : 286, _
			  "Gcedil" : 290, _
			  "Gcirc" : 284, _
			  "Gcy" : 1043, _
			  "Gdot" : 288, _
			  "Gfr" : 120074, _
			  "Gg" : 8921, _
			  "Gopf" : 120126, _
			  "GreaterEqual" : 8805, _
			  "GreaterEqualLess" : 8923, _
			  "GreaterFullEqual" : 8807, _
			  "GreaterGreater" : 10914, _
			  "GreaterLess" : 8823, _
			  "GreaterSlantEqual" : 10878, _
			  "GreaterTilde" : 8819, _
			  "Gscr" : 119970, _
			  "Gt" : 8811, _
			  "HARDcy" : 1066, _
			  "Hacek" : 711, _
			  "Hat" : 94, _
			  "Hcirc" : 292, _
			  "Hfr" : 8460, _
			  "HilbertSpace" : 8459, _
			  "Hopf" : 8461, _
			  "HorizontalLine" : 9472, _
			  "Hscr" : 8459, _
			  "Hstrok" : 294, _
			  "HumpDownHump" : 8782, _
			  "HumpEqual" : 8783, _
			  "IEcy" : 1045, _
			  "IJlig" : 306, _
			  "IOcy" : 1025, _
			  "Iacute" : 205, _
			  "Icirc" : 206, _
			  "Icy" : 1048, _
			  "Idot" : 304, _
			  "Ifr" : 8465, _
			  "Igrave" : 204, _
			  "Im" : 8465, _
			  "Imacr" : 298, _
			  "ImaginaryI" : 8520, _
			  "Implies" : 8658, _
			  "Int" : 8748, _
			  "Integral" : 8747, _
			  "Intersection" : 8898, _
			  "InvisibleComma" : 8291, _
			  "InvisibleTimes" : 8290, _
			  "Iogon" : 302, _
			  "Iopf" : 120128, _
			  "Iota" : 921, _
			  "Iscr" : 8464, _
			  "Itilde" : 296, _
			  "Iukcy" : 1030, _
			  "Iuml" : 207, _
			  "Jcirc" : 308, _
			  "Jcy" : 1049, _
			  "Jfr" : 120077, _
			  "Jopf" : 120129, _
			  "Jscr" : 119973, _
			  "Jsercy" : 1032, _
			  "Jukcy" : 1028, _
			  "KHcy" : 1061, _
			  "KJcy" : 1036, _
			  "Kappa" : 922, _
			  "Kcedil" : 310, _
			  "Kcy" : 1050, _
			  "Kfr" : 120078, _
			  "Kopf" : 120130, _
			  "Kscr" : 119974, _
			  "LJcy" : 1033, _
			  "LT" : 60, _
			  "Lacute" : 313, _
			  "Lambda" : 923, _
			  "Lang" : 10218, _
			  "Laplacetrf" : 8466, _
			  "Larr" : 8606, _
			  "Lcaron" : 317, _
			  "Lcedil" : 315, _
			  "Lcy" : 1051, _
			  "LeftAngleBracket" : 10216, _
			  "LeftArrow" : 8592, _
			  "LeftArrowBar" : 8676, _
			  "LeftArrowRightArrow" : 8646, _
			  "LeftCeiling" : 8968, _
			  "LeftDoubleBracket" : 10214, _
			  "LeftDownTeeVector" : 10593, _
			  "LeftDownVector" : 8643, _
			  "LeftDownVectorBar" : 10585, _
			  "LeftFloor" : 8970, _
			  "LeftRightArrow" : 8596, _
			  "LeftRightVector" : 10574, _
			  "LeftTee" : 8867, _
			  "LeftTeeArrow" : 8612, _
			  "LeftTeeVector" : 10586, _
			  "LeftTriangle" : 8882, _
			  "LeftTriangleBar" : 10703, _
			  "LeftTriangleEqual" : 8884, _
			  "LeftUpDownVector" : 10577, _
			  "LeftUpTeeVector" : 10592, _
			  "LeftUpVector" : 8639, _
			  "LeftUpVectorBar" : 10584, _
			  "LeftVector" : 8636, _
			  "LeftVectorBar" : 10578, _
			  "Leftarrow" : 8656, _
			  "Leftrightarrow" : 8660, _
			  "LessEqualGreater" : 8922, _
			  "LessFullEqual" : 8806, _
			  "LessGreater" : 8822, _
			  "LessLess" : 10913, _
			  "LessSlantEqual" : 10877, _
			  "LessTilde" : 8818, _
			  "Lfr" : 120079, _
			  "Ll" : 8920, _
			  "Lleftarrow" : 8666, _
			  "Lmidot" : 319, _
			  "LongLeftArrow" : 10229, _
			  "LongLeftRightArrow" : 10231, _
			  "LongRightArrow" : 10230, _
			  "Longleftarrow" : 10232, _
			  "Longleftrightarrow" : 10234, _
			  "Longrightarrow" : 10233, _
			  "Lopf" : 120131, _
			  "LowerLeftArrow" : 8601, _
			  "LowerRightArrow" : 8600, _
			  "Lscr" : 8466, _
			  "Lsh" : 8624, _
			  "Lstrok" : 321, _
			  "Lt" : 8810, _
			  "Map" : 10501, _
			  "Mcy" : 1052, _
			  "MediumSpace" : 8287, _
			  "Mellintrf" : 8499, _
			  "Mfr" : 120080, _
			  "MinusPlus" : 8723, _
			  "Mopf" : 120132, _
			  "Mscr" : 8499, _
			  "Mu" : 924, _
			  "NJcy" : 1034, _
			  "Nacute" : 323, _
			  "Ncaron" : 327, _
			  "Ncedil" : 325, _
			  "Ncy" : 1053, _
			  "NegativeMediumSpace" : 8203, _
			  "NegativeThickSpace" : 8203, _
			  "NegativeThinSpace" : 8203, _
			  "NegativeVeryThinSpace" : 8203, _
			  "NestedGreaterGreater" : 8811, _
			  "NestedLessLess" : 8810, _
			  "NewLine" : 10, _
			  "Nfr" : 120081, _
			  "NoBreak" : 8288, _
			  "NonBreakingSpace" : 160, _
			  "Nopf" : 8469, _
			  "Not" : 10988, _
			  "NotCongruent" : 8802, _
			  "NotCupCap" : 8813, _
			  "NotDoubleVerticalBar" : 8742, _
			  "NotElement" : 8713, _
			  "NotEqual" : 8800, _
			  "NotEqualTilde" : 8770, _
			  "NotExists" : 8708, _
			  "NotGreater" : 8815, _
			  "NotGreaterEqual" : 8817, _
			  "NotGreaterFullEqual" : 8807, _
			  "NotGreaterGreater" : 8811, _
			  "NotGreaterLess" : 8825, _
			  "NotGreaterSlantEqual" : 10878, _
			  "NotGreaterTilde" : 8821, _
			  "NotHumpDownHump" : 8782, _
			  "NotHumpEqual" : 8783, _
			  "NotLeftTriangle" : 8938, _
			  "NotLeftTriangleBar" : 10703, _
			  "NotLeftTriangleEqual" : 8940, _
			  "NotLess" : 8814, _
			  "NotLessEqual" : 8816, _
			  "NotLessGreater" : 8824, _
			  "NotLessLess" : 8810, _
			  "NotLessSlantEqual" : 10877, _
			  "NotLessTilde" : 8820, _
			  "NotNestedGreaterGreater" : 10914, _
			  "NotNestedLessLess" : 10913, _
			  "NotPrecedes" : 8832, _
			  "NotPrecedesEqual" : 10927, _
			  "NotPrecedesSlantEqual" : 8928, _
			  "NotReverseElement" : 8716, _
			  "NotRightTriangle" : 8939, _
			  "NotRightTriangleBar" : 10704, _
			  "NotRightTriangleEqual" : 8941, _
			  "NotSquareSubset" : 8847, _
			  "NotSquareSubsetEqual" : 8930, _
			  "NotSquareSuperset" : 8848, _
			  "NotSquareSupersetEqual" : 8931, _
			  "NotSubset" : 8834, _
			  "NotSubsetEqual" : 8840, _
			  "NotSucceeds" : 8833, _
			  "NotSucceedsEqual" : 10928, _
			  "NotSucceedsSlantEqual" : 8929, _
			  "NotSucceedsTilde" : 8831, _
			  "NotSuperset" : 8835, _
			  "NotSupersetEqual" : 8841, _
			  "NotTilde" : 8769, _
			  "NotTildeEqual" : 8772, _
			  "NotTildeFullEqual" : 8775, _
			  "NotTildeTilde" : 8777, _
			  "NotVerticalBar" : 8740, _
			  "Nscr" : 119977, _
			  "Ntilde" : 209, _
			  "Nu" : 925, _
			  "OElig" : 338, _
			  "Oacute" : 211, _
			  "Ocirc" : 212, _
			  "Ocy" : 1054, _
			  "Odblac" : 336, _
			  "Ofr" : 120082, _
			  "Ograve" : 210, _
			  "Omacr" : 332, _
			  "Omega" : 937, _
			  "Omicron" : 927, _
			  "Oopf" : 120134, _
			  "OpenCurlyDoubleQuote" : 8220, _
			  "OpenCurlyQuote" : 8216, _
			  "Or" : 10836, _
			  "Oscr" : 119978, _
			  "Oslash" : 216, _
			  "Otilde" : 213, _
			  "Otimes" : 10807, _
			  "Ouml" : 214, _
			  "OverBar" : 8254, _
			  "OverBrace" : 9182, _
			  "OverBracket" : 9140, _
			  "OverParenthesis" : 9180, _
			  "PartialD" : 8706, _
			  "Pcy" : 1055, _
			  "Pfr" : 120083, _
			  "Phi" : 934, _
			  "Pi" : 928, _
			  "PlusMinus" : 177, _
			  "Poincareplane" : 8460, _
			  "Popf" : 8473, _
			  "Pr" : 10939, _
			  "Precedes" : 8826, _
			  "PrecedesEqual" : 10927, _
			  "PrecedesSlantEqual" : 8828, _
			  "PrecedesTilde" : 8830, _
			  "Prime" : 8243, _
			  "Product" : 8719, _
			  "Proportion" : 8759, _
			  "Proportional" : 8733, _
			  "Pscr" : 119979, _
			  "Psi" : 936, _
			  "QUOT" : 34, _
			  "Qfr" : 120084, _
			  "Qopf" : 8474, _
			  "Qscr" : 119980, _
			  "RBarr" : 10512, _
			  "REG" : 174, _
			  "Racute" : 340, _
			  "Rang" : 10219, _
			  "Rarr" : 8608, _
			  "Rarrtl" : 10518, _
			  "Rcaron" : 344, _
			  "Rcedil" : 342, _
			  "Rcy" : 1056, _
			  "Re" : 8476, _
			  "ReverseElement" : 8715, _
			  "ReverseEquilibrium" : 8651, _
			  "ReverseUpEquilibrium" : 10607, _
			  "Rfr" : 8476, _
			  "Rho" : 929, _
			  "RightAngleBracket" : 10217, _
			  "RightArrow" : 8594, _
			  "RightArrowBar" : 8677, _
			  "RightArrowLeftArrow" : 8644, _
			  "RightCeiling" : 8969, _
			  "RightDoubleBracket" : 10215, _
			  "RightDownTeeVector" : 10589, _
			  "RightDownVector" : 8642, _
			  "RightDownVectorBar" : 10581, _
			  "RightFloor" : 8971, _
			  "RightTee" : 8866, _
			  "RightTeeArrow" : 8614, _
			  "RightTeeVector" : 10587, _
			  "RightTriangle" : 8883, _
			  "RightTriangleBar" : 10704, _
			  "RightTriangleEqual" : 8885, _
			  "RightUpDownVector" : 10575, _
			  "RightUpTeeVector" : 10588, _
			  "RightUpVector" : 8638, _
			  "RightUpVectorBar" : 10580, _
			  "RightVector" : 8640, _
			  "RightVectorBar" : 10579, _
			  "Rightarrow" : 8658, _
			  "Ropf" : 8477, _
			  "RoundImplies" : 10608, _
			  "Rrightarrow" : 8667, _
			  "Rscr" : 8475, _
			  "Rsh" : 8625, _
			  "RuleDelayed" : 10740, _
			  "SHCHcy" : 1065, _
			  "SHcy" : 1064, _
			  "SOFTcy" : 1068, _
			  "Sacute" : 346, _
			  "Sc" : 10940, _
			  "Scaron" : 352, _
			  "Scedil" : 350, _
			  "Scirc" : 348, _
			  "Scy" : 1057, _
			  "Sfr" : 120086, _
			  "ShortDownArrow" : 8595, _
			  "ShortLeftArrow" : 8592, _
			  "ShortRightArrow" : 8594, _
			  "ShortUpArrow" : 8593, _
			  "Sigma" : 931, _
			  "SmallCircle" : 8728, _
			  "Sopf" : 120138, _
			  "Sqrt" : 8730, _
			  "Square" : 9633, _
			  "SquareIntersection" : 8851, _
			  "SquareSubset" : 8847, _
			  "SquareSubsetEqual" : 8849, _
			  "SquareSuperset" : 8848, _
			  "SquareSupersetEqual" : 8850, _
			  "SquareUnion" : 8852, _
			  "Sscr" : 119982, _
			  "Star" : 8902, _
			  "Sub" : 8912, _
			    "Subset" : 8912, _
			    "SubsetEqual" : 8838, _
			    "Succeeds" : 8827, _
			    "SucceedsEqual" : 10928, _
			    "SucceedsSlantEqual" : 8829, _
			    "SucceedsTilde" : 8831, _
			    "SuchThat" : 8715, _
			    "Sum" : 8721, _
			    "Sup" : 8913, _
			    "Superset" : 8835, _
			    "SupersetEqual" : 8839, _
			    "Supset" : 8913, _
			    "THORN" : 222, _
			    "TRADE" : 8482, _
			    "TSHcy" : 1035, _
			    "TScy" : 1062, _
			    "Tab" : 9, _
			    "Tau" : 932, _
			    "Tcaron" : 356, _
			    "Tcedil" : 354, _
			    "Tcy" : 1058, _
			    "Tfr" : 120087, _
			    "Therefore" : 8756, _
			    "Theta" : 920, _
			    "ThickSpace" : 8287, _
			    "ThinSpace" : 8201, _
			    "Tilde" : 8764, _
			    "TildeEqual" : 8771, _
			    "TildeFullEqual" : 8773, _
			    "TildeTilde" : 8776, _
			    "Topf" : 120139, _
			    "TripleDot" : 8411, _
			    "Tscr" : 119983, _
			    "Tstrok" : 358, _
			    "Uacute" : 218, _
			    "Uarr" : 8607, _
			    "Uarrocir" : 10569, _
			    "Ubrcy" : 1038, _
			    "Ubreve" : 364, _
			    "Ucirc" : 219, _
			    "Ucy" : 1059, _
			    "Udblac" : 368, _
			    "Ufr" : 120088, _
			    "Ugrave" : 217, _
			    "Umacr" : 362, _
			    "UnderBar" : 95, _
			    "UnderBrace" : 9183, _
			    "UnderBracket" : 9141, _
			    "UnderParenthesis" : 9181, _
			    "Union" : 8899, _
			    "UnionPlus" : 8846, _
			    "Uogon" : 370, _
			    "Uopf" : 120140, _
			    "UpArrow" : 8593, _
			    "UpArrowBar" : 10514, _
			    "UpArrowDownArrow" : 8645, _
			    "UpDownArrow" : 8597, _
			    "UpEquilibrium" : 10606, _
			    "UpTee" : 8869, _
			    "UpTeeArrow" : 8613, _
			    "Uparrow" : 8657, _
			    "Updownarrow" : 8661, _
			    "UpperLeftArrow" : 8598, _
			    "UpperRightArrow" : 8599, _
			    "Upsi" : 978, _
			    "Upsilon" : 933, _
			    "Uring" : 366, _
			    "Uscr" : 119984, _
			    "Utilde" : 360, _
			    "Uuml" : 220, _
			    "VDash" : 8875, _
			    "Vbar" : 10987, _
			    "Vcy" : 1042, _
			    "Vdash" : 8873, _
			    "Vdashl" : 10982, _
			    "Vee" : 8897, _
			    "Verbar" : 8214, _
			    "Vert" : 8214, _
			    "VerticalBar" : 8739, _
			    "VerticalLine" : 124, _
			    "VerticalSeparator" : 10072, _
			    "VerticalTilde" : 8768, _
			    "VeryThinSpace" : 8202, _
			    "Vfr" : 120089, _
			    "Vopf" : 120141, _
			    "Vscr" : 119985, _
			    "Vvdash" : 8874, _
			    "Wcirc" : 372, _
			    "Wedge" : 8896, _
			    "Wfr" : 120090, _
			    "Wopf" : 120142, _
			    "Wscr" : 119986, _
			    "Xfr" : 120091, _
			    "Xi" : 926, _
			    "Xopf" : 120143, _
			    "Xscr" : 119987, _
			    "YAcy" : 1071, _
			    "YIcy" : 1031, _
			    "YUcy" : 1070, _
			    "Yacute" : 221, _
			    "Ycirc" : 374, _
			    "Ycy" : 1067, _
			    "Yfr" : 120092, _
			    "Yopf" : 120144, _
			    "Yscr" : 119988, _
			    "Yuml" : 376, _
			    "ZHcy" : 1046, _
			    "Zacute" : 377, _
			    "Zcaron" : 381, _
			    "Zcy" : 1047, _
			    "Zdot" : 379, _
			    "ZeroWidthSpace" : 8203, _
			    "Zeta" : 918, _
			    "Zfr" : 8488, _
			    "Zopf" : 8484, _
			    "Zscr" : 119989, _
			    "aacute" : 225, _
			    "abreve" : 259, _
			    "ac" : 8766, _
			    "acE" : 8766, _
			    "acd" : 8767, _
			    "acirc" : 226, _
			    "acute" : 180, _
			    "acy" : 1072, _
			    "aelig" : 230, _
			    "af" : 8289, _
			    "afr" : 120094, _
			    "agrave" : 224, _
			    "alefsym" : 8501, _
			    "aleph" : 8501, _
			    "alpha" : 945, _
			    "amacr" : 257, _
			    "amalg" : 10815, _
			    "amp" : 38, _
			    "and" : 8743, _
			    "andand" : 10837, _
			    "andd" : 10844, _
			    "andslope" : 10840, _
			    "andv" : 10842, _
			    "ang" : 8736, _
			    "ange" : 10660, _
			    "angle" : 8736, _
			    "angmsd" : 8737, _
			    "angmsdaa" : 10664, _
			    "angmsdab" : 10665, _
			    "angmsdac" : 10666, _
			    "angmsdad" : 10667, _
			    "angmsdae" : 10668, _
			    "angmsdaf" : 10669, _
			    "angmsdag" : 10670, _
			    "angmsdah" : 10671, _
			    "angrt" : 8735, _
			    "angrtvb" : 8894, _
			    "angrtvbd" : 10653, _
			    "angsph" : 8738, _
			    "angst" : 197, _
			    "angzarr" : 9084, _
			    "aogon" : 261, _
			    "aopf" : 120146, _
			    "ap" : 8776, _
			    "apE" : 10864, _
			    "apacir" : 10863, _
			    "ape" : 8778, _
			    "apid" : 8779, _
			    "apos" : 39, _
			    "approx" : 8776, _
			    "approxeq" : 8778, _
			    "aring" : 229, _
			    "ascr" : 119990, _
			    "ast" : 42, _
			    "asymp" : 8776, _
			    "asympeq" : 8781, _
			    "atilde" : 227, _
			    "auml" : 228, _
			    "awconint" : 8755, _
			    "awint" : 10769, _
			    "bNot" : 10989, _
			    "backcong" : 8780, _
			    "backepsilon" : 1014, _
			    "backprime" : 8245, _
			    "backsim" : 8765, _
			    "backsimeq" : 8909, _
			    "barvee" : 8893, _
			    "barwed" : 8965, _
			    "barwedge" : 8965, _
			    "bbrk" : 9141, _
			    "bbrktbrk" : 9142, _
			    "bcong" : 8780, _
			    "bcy" : 1073, _
			    "bdquo" : 8222, _
			    "becaus" : 8757, _
			    "because" : 8757, _
			    "bemptyv" : 10672, _
			    "bepsi" : 1014, _
			    "bernou" : 8492, _
			    "beta" : 946, _
			    "beth" : 8502, _
			    "between" : 8812, _
			    "bfr" : 120095, _
			    "bigcap" : 8898, _
			    "bigcirc" : 9711, _
			    "bigcup" : 8899, _
			    "bigodot" : 10752, _
			    "bigoplus" : 10753, _
			    "bigotimes" : 10754, _
			    "bigsqcup" : 10758, _
			    "bigstar" : 9733, _
			    "bigtriangledown" : 9661, _
			    "bigtriangleup" : 9651, _
			    "biguplus" : 10756, _
			    "bigvee" : 8897, _
			    "bigwedge" : 8896, _
			    "bkarow" : 10509, _
			    "blacklozenge" : 10731, _
			    "blacksquare" : 9642, _
			    "blacktriangle" : 9652, _
			    "blacktriangledown" : 9662, _
			    "blacktriangleleft" : 9666, _
			    "blacktriangleright" : 9656, _
			    "blank" : 9251, _
			    "blk12" : 9618, _
			    "blk14" : 9617, _
			    "blk34" : 9619, _
			    "block" : 9608, _
			    "bne" : 61, _
			    "bnequiv" : 8801, _
			    "bnot" : 8976, _
			    "bopf" : 120147, _
			    "bot" : 8869, _
			    "bottom" : 8869, _
			    "bowtie" : 8904, _
			    "boxDL" : 9559, _
			    "boxDR" : 9556, _
			    "boxDl" : 9558, _
			    "boxDr" : 9555, _
			    "boxH" : 9552, _
			    "boxHD" : 9574, _
			    "boxHU" : 9577, _
			    "boxHd" : 9572, _
			    "boxHu" : 9575, _
			    "boxUL" : 9565, _
			    "boxUR" : 9562, _
			    "boxUl" : 9564, _
			    "boxUr" : 9561, _
			    "boxV" : 9553, _
			    "boxVH" : 9580, _
			    "boxVL" : 9571, _
			    "boxVR" : 9568, _
			    "boxVh" : 9579, _
			    "boxVl" : 9570, _
			    "boxVr" : 9567, _
			    "boxbox" : 10697, _
			    "boxdL" : 9557, _
			    "boxdR" : 9554, _
			    "boxdl" : 9488, _
			    "boxdr" : 9484, _
			    "boxh" : 9472, _
			    "boxhD" : 9573, _
			    "boxhU" : 9576, _
			    "boxhd" : 9516, _
			    "boxhu" : 9524, _
			    "boxminus" : 8863, _
			    "boxplus" : 8862, _
			    "boxtimes" : 8864, _
			    "boxuL" : 9563, _
			    "boxuR" : 9560, _
			    "boxul" : 9496, _
			    "boxur" : 9492, _
			    "boxv" : 9474, _
			    "boxvH" : 9578, _
			    "boxvL" : 9569, _
			    "boxvR" : 9566, _
			    "boxvh" : 9532, _
			    "boxvl" : 9508, _
			    "boxvr" : 9500, _
			    "bprime" : 8245, _
			    "breve" : 728, _
			    "brvbar" : 166, _
			    "bscr" : 119991, _
			    "bsemi" : 8271, _
			    "bsim" : 8765, _
			    "bsime" : 8909, _
			    "bsol" : 92, _
			    "bsolb" : 10693, _
			    "bsolhsub" : 10184, _
			    "bull" : 8226, _
			    "bullet" : 8226, _
			    "bump" : 8782, _
			    "bumpE" : 10926, _
			    "bumpe" : 8783, _
			    "bumpeq" : 8783, _
			    "cacute" : 263, _
			    "cap" : 8745, _
			    "capand" : 10820, _
			    "capbrcup" : 10825, _
			    "capcap" : 10827, _
			    "capcup" : 10823, _
			    "capdot" : 10816, _
			    "caps" : 8745, _
			    "caret" : 8257, _
			    "caron" : 711, _
			    "ccaps" : 10829, _
			    "ccaron" : 269, _
			    "ccedil" : 231, _
			    "ccirc" : 265, _
			    "ccups" : 10828, _
			    "ccupssm" : 10832, _
			    "cdot" : 267, _
			    "cedil" : 184, _
			    "cemptyv" : 10674, _
			    "cent" : 162, _
			    "centerdot" : 183, _
			    "cfr" : 120096, _
			    "chcy" : 1095, _
			    "check" : 10003, _
			    "checkmark" : 10003, _
			    "chi" : 967, _
			    "cir" : 9675, _
			    "cirE" : 10691, _
			    "circ" : 710, _
			    "circeq" : 8791, _
			    "circlearrowleft" : 8634, _
			    "circlearrowright" : 8635, _
			    "circledR" : 174, _
			    "circledS" : 9416, _
			    "circledast" : 8859, _
			    "circledcirc" : 8858, _
			    "circleddash" : 8861, _
			    "cire" : 8791, _
			    "cirfnint" : 10768, _
			    "cirmid" : 10991, _
			    "cirscir" : 10690, _
			    "clubs" : 9827, _
			    "clubsuit" : 9827, _
			    "colon" : 58, _
			    "colone" : 8788, _
			    "coloneq" : 8788, _
			    "comma" : 44, _
			    "commat" : 64, _
			    "comp" : 8705, _
			    "compfn" : 8728, _
			    "complement" : 8705, _
			    "complexes" : 8450, _
			    "cong" : 8773, _
			    "congdot" : 10861, _
			    "conint" : 8750, _
			    "copf" : 120148, _
			    "coprod" : 8720, _
			    "copy" : 169, _
			    "copysr" : 8471, _
			    "crarr" : 8629, _
			    "cross" : 10007, _
			    "cscr" : 119992, _
			    "csub" : 10959, _
			    "csube" : 10961, _
			    "csup" : 10960, _
			    "csupe" : 10962, _
			    "ctdot" : 8943, _
			    "cudarrl" : 10552, _
			    "cudarrr" : 10549, _
			    "cuepr" : 8926, _
			    "cuesc" : 8927, _
			    "cularr" : 8630, _
			    "cularrp" : 10557, _
			    "cup" : 8746, _
			    "cupbrcap" : 10824, _
			    "cupcap" : 10822, _
			    "cupcup" : 10826, _
			    "cupdot" : 8845, _
			    "cupor" : 10821, _
			    "cups" : 8746, _
			    "curarr" : 8631, _
			    "curarrm" : 10556, _
			    "curlyeqprec" : 8926, _
			    "curlyeqsucc" : 8927, _
			    "curlyvee" : 8910, _
			    "curlywedge" : 8911, _
			    "curren" : 164, _
			    "curvearrowleft" : 8630, _
			    "curvearrowright" : 8631, _
			    "cuvee" : 8910, _
			    "cuwed" : 8911, _
			    "cwconint" : 8754, _
			    "cwint" : 8753, _
			    "cylcty" : 9005, _
			    "dArr" : 8659, _
			    "dHar" : 10597, _
			    "dagger" : 8224, _
			    "daleth" : 8504, _
			    "darr" : 8595, _
			    "dash" : 8208, _
			    "dashv" : 8867, _
			    "dbkarow" : 10511, _
			    "dblac" : 733, _
			    "dcaron" : 271, _
			    "dcy" : 1076, _
			    "dd" : 8518, _
			    "ddagger" : 8225, _
			    "ddarr" : 8650, _
			    "ddotseq" : 10871, _
			    "deg" : 176, _
			    "delta" : 948, _
			    "demptyv" : 10673, _
			    "dfisht" : 10623, _
			    "dfr" : 120097, _
			    "dharl" : 8643, _
			    "dharr" : 8642, _
			    "diam" : 8900, _
			    "diamond" : 8900, _
			    "diamondsuit" : 9830, _
			    "diams" : 9830, _
			    "die" : 168, _
			    "digamma" : 989, _
			    "disin" : 8946, _
			    "div" : 247, _
			    "divide" : 247, _
			    "divideontimes" : 8903, _
			    "divonx" : 8903, _
			    "djcy" : 1106, _
			    "dlcorn" : 8990, _
			    "dlcrop" : 8973, _
			    "dollar" : 36, _
			    "dopf" : 120149, _
			    "dot" : 729, _
			    "doteq" : 8784, _
			    "doteqdot" : 8785, _
			    "dotminus" : 8760, _
			    "dotplus" : 8724, _
			    "dotsquare" : 8865, _
			    "doublebarwedge" : 8966, _
			    "downarrow" : 8595, _
			    "downdownarrows" : 8650, _
			    "downharpoonleft" : 8643, _
			    "downharpoonright" : 8642, _
			    "drbkarow" : 10512, _
			    "drcorn" : 8991, _
			    "drcrop" : 8972, _
			    "dscr" : 119993, _
			    "dscy" : 1109, _
			    "dsol" : 10742, _
			    "dstrok" : 273, _
			    "dtdot" : 8945, _
			    "dtri" : 9663, _
			    "dtrif" : 9662, _
			    "duarr" : 8693, _
			    "duhar" : 10607, _
			    "dwangle" : 10662, _
			    "dzcy" : 1119, _
			    "dzigrarr" : 10239, _
			    "eDDot" : 10871, _
			    "eDot" : 8785, _
			    "eacute" : 233, _
			    "easter" : 10862, _
			    "ecaron" : 283, _
			    "ecir" : 8790, _
			    "ecirc" : 234, _
			    "ecolon" : 8789, _
			    "ecy" : 1101, _
			    "edot" : 279, _
			    "ee" : 8519, _
			    "efDot" : 8786, _
			    "efr" : 120098, _
			    "eg" : 10906, _
			    "egrave" : 232, _
			    "egs" : 10902, _
			    "egsdot" : 10904, _
			    "el" : 10905, _
			    "elinters" : 9191, _
			    "ell" : 8467, _
			    "els" : 10901, _
			    "elsdot" : 10903, _
			    "emacr" : 275, _
			    "empty" : 8709, _
			    "emptyset" : 8709, _
			    "emptyv" : 8709, _
			    "emsp13" : 8196, _
			    "emsp14" : 8197, _
			    "emsp" : 8195, _
			    "eng" : 331, _
			    "ensp" : 8194, _
			    "eogon" : 281, _
			    "eopf" : 120150, _
			    "epar" : 8917, _
			    "eparsl" : 10723, _
			    "eplus" : 10865, _
			    "epsi" : 949, _
			    "epsilon" : 949, _
			    "epsiv" : 1013, _
			    "eqcirc" : 8790, _
			    "eqcolon" : 8789, _
			    "eqsim" : 8770, _
			    "eqslantgtr" : 10902, _
			    "eqslantless" : 10901, _
			    "equals" : 61, _
			    "equest" : 8799, _
			    "equiv" : 8801, _
			    "equivDD" : 10872, _
			    "eqvparsl" : 10725, _
			    "erDot" : 8787, _
			    "erarr" : 10609, _
			    "escr" : 8495, _
			    "esdot" : 8784, _
			    "esim" : 8770, _
			    "eta" : 951, _
			    "eth" : 240, _
			    "euml" : 235, _
			    "euro" : 8364, _
			    "excl" : 33, _
			    "exist" : 8707, _
			    "expectation" : 8496, _
			    "exponentiale" : 8519, _
			    "fallingdotseq" : 8786, _
			    "fcy" : 1092, _
			    "female" : 9792, _
			    "ffilig" : 64259, _
			    "fflig" : 64256, _
			    "ffllig" : 64260, _
			    "ffr" : 120099, _
			    "filig" : 64257, _
			    "fjlig" : 102, _
			    "flat" : 9837, _
			    "fllig" : 64258, _
			    "fltns" : 9649, _
			    "fnof" : 402, _
			    "fopf" : 120151, _
			    "forall" : 8704, _
			    "fork" : 8916, _
			    "forkv" : 10969, _
			    "fpartint" : 10765, _
			    "frac12" : 189, _
			    "frac13" : 8531, _
			    "frac14" : 188, _
			    "frac15" : 8533, _
			    "frac16" : 8537, _
			    "frac18" : 8539, _
			    "frac23" : 8532, _
			    "frac25" : 8534, _
			    "frac34" : 190, _
			    "frac35" : 8535, _
			    "frac38" : 8540, _
			    "frac45" : 8536, _
			    "frac56" : 8538, _
			    "frac58" : 8541, _
			    "frac78" : 8542, _
			    "frasl" : 8260, _
			    "frown" : 8994, _
			    "fscr" : 119995, _
			    "gE" : 8807, _
			    "gEl" : 10892, _
			    "gacute" : 501, _
			    "gamma" : 947, _
			    "gammad" : 989, _
			    "gap" : 10886, _
			    "gbreve" : 287, _
			    "gcirc" : 285, _
			    "gcy" : 1075, _
			    "gdot" : 289, _
			    "ge" : 8805, _
			    "gel" : 8923, _
			    "geq" : 8805, _
			    "geqq" : 8807, _
			    "geqslant" : 10878, _
			    "ges" : 10878, _
			    "gescc" : 10921, _
			    "gesdot" : 10880, _
			    "gesdoto" : 10882, _
			    "gesdotol" : 10884, _
			    "gesl" : 8923, _
			    "gesles" : 10900, _
			    "gfr" : 120100, _
			    "gg" : 8811, _
			    "ggg" : 8921, _
			    "gimel" : 8503, _
			    "gjcy" : 1107, _
			    "gl" : 8823, _
			    "glE" : 10898, _
			    "gla" : 10917, _
			    "glj" : 10916, _
			    "gnE" : 8809, _
			    "gnap" : 10890, _
			    "gnapprox" : 10890, _
			    "gne" : 10888, _
			    "gneq" : 10888, _
			    "gneqq" : 8809, _
			    "gnsim" : 8935, _
			    "gopf" : 120152, _
			    "grave" : 96, _
			    "gscr" : 8458, _
			    "gsim" : 8819, _
			    "gsime" : 10894, _
			    "gsiml" : 10896, _
			    "gt" : 62, _
			    "gtcc" : 10919, _
			    "gtcir" : 10874, _
			    "gtdot" : 8919, _
			    "gtlPar" : 10645, _
			    "gtquest" : 10876, _
			    "gtrapprox" : 10886, _
			    "gtrarr" : 10616, _
			    "gtrdot" : 8919, _
			    "gtreqless" : 8923, _
			    "gtreqqless" : 10892, _
			    "gtrless" : 8823, _
			    "gtrsim" : 8819, _
			    "gvertneqq" : 8809, _
			    "gvnE" : 8809, _
			    "hArr" : 8660, _
			    "hairsp" : 8202, _
			    "half" : 189, _
			    "hamilt" : 8459, _
			    "hardcy" : 1098, _
			    "harr" : 8596, _
			    "harrcir" : 10568, _
			    "harrw" : 8621, _
			    "hbar" : 8463, _
			    "hcirc" : 293, _
			    "hearts" : 9829, _
			    "heartsuit" : 9829, _
			    "hellip" : 8230, _
			    "hercon" : 8889, _
			    "hfr" : 120101, _
			    "hksearow" : 10533, _
			    "hkswarow" : 10534, _
			    "hoarr" : 8703, _
			    "homtht" : 8763, _
			    "hookleftarrow" : 8617, _
			    "hookrightarrow" : 8618, _
			    "hopf" : 120153, _
			    "horbar" : 8213, _
			    "hscr" : 119997, _
			    "hslash" : 8463, _
			    "hstrok" : 295, _
			    "hybull" : 8259, _
			    "hyphen" : 8208, _
			    "iacute" : 237, _
			    "ic" : 8291, _
			    "icirc" : 238, _
			    "icy" : 1080, _
			    "iecy" : 1077, _
			    "iexcl" : 161, _
			    "iff" : 8660, _
			    "ifr" : 120102, _
			    "igrave" : 236, _
			    "ii" : 8520, _
			    "iiiint" : 10764, _
			    "iiint" : 8749, _
			    "iinfin" : 10716, _
			    "iiota" : 8489, _
			    "ijlig" : 307, _
			    "imacr" : 299, _
			    "image" : 8465, _
			    "imagline" : 8464, _
			    "imagpart" : 8465, _
			    "imath" : 305, _
			    "imof" : 8887, _
			    "imped" : 437, _
			    "in" : 8712, _
			    "incare" : 8453, _
			    "infin" : 8734, _
			    "infintie" : 10717, _
			    "inodot" : 305, _
			    "int" : 8747, _
			    "intcal" : 8890, _
			    "integers" : 8484, _
			    "intercal" : 8890, _
			    "intlarhk" : 10775, _
			    "intprod" : 10812, _
			    "iocy" : 1105, _
			    "iogon" : 303, _
			    "iopf" : 120154, _
			    "iota" : 953, _
			    "iprod" : 10812, _
			    "iquest" : 191, _
			    "iscr" : 119998, _
			    "isin" : 8712, _
			    "isinE" : 8953, _
			    "isindot" : 8949, _
			    "isins" : 8948, _
			    "isinsv" : 8947, _
			    "isinv" : 8712, _
			    "it" : 8290, _
			    "itilde" : 297, _
			    "iukcy" : 1110, _
			    "iuml" : 239, _
			    "jcirc" : 309, _
			    "jcy" : 1081, _
			    "jfr" : 120103, _
			    "jmath" : 567, _
			    "jopf" : 120155, _
			    "jscr" : 119999, _
			    "jsercy" : 1112, _
			    "jukcy" : 1108, _
			    "kappa" : 954, _
			    "kappav" : 1008, _
			    "kcedil" : 311, _
			    "kcy" : 1082, _
			    "kfr" : 120104, _
			    "kgreen" : 312, _
			    "khcy" : 1093, _
			    "kjcy" : 1116, _
			    "kopf" : 120156, _
			    "kscr" : 120000, _
			    "lAarr" : 8666, _
			    "lArr" : 8656, _
			    "lAtail" : 10523, _
			    "lBarr" : 10510, _
			    "lE" : 8806, _
			    "lEg" : 10891, _
			    "lHar" : 10594, _
			    "lacute" : 314, _
			    "laemptyv" : 10676, _
			    "lagran" : 8466, _
			    "lambda" : 955, _
			    "lang" : 10216, _
			    "langd" : 10641, _
			    "langle" : 10216, _
			    "lap" : 10885, _
			    "laquo" : 171, _
			    "larr" : 8592, _
			    "larrb" : 8676, _
			    "larrbfs" : 10527, _
			    "larrfs" : 10525, _
			    "larrhk" : 8617, _
			    "larrlp" : 8619, _
			    "larrpl" : 10553, _
			    "larrsim" : 10611, _
			    "larrtl" : 8610, _
			    "lat" : 10923, _
			    "latail" : 10521, _
			    "late" : 10925, _
			    "lates" : 10925, _
			    "lbarr" : 10508, _
			    "lbbrk" : 10098, _
			    "lbrace" : 123, _
			    "lbrack" : 91, _
			    "lbrke" : 10635, _
			    "lbrksld" : 10639, _
			    "lbrkslu" : 10637, _
			    "lcaron" : 318, _
			    "lcedil" : 316, _
			    "lceil" : 8968, _
			    "lcub" : 123, _
			    "lcy" : 1083, _
			    "ldca" : 10550, _
			    "ldquo" : 8220, _
			    "ldquor" : 8222, _
			    "ldrdhar" : 10599, _
			    "ldrushar" : 10571, _
			    "ldsh" : 8626, _
			    "le" : 8804, _
			    "leftarrow" : 8592, _
			    "leftarrowtail" : 8610, _
			    "leftharpoondown" : 8637, _
			    "leftharpoonup" : 8636, _
			    "leftleftarrows" : 8647, _
			    "leftrightarrow" : 8596, _
			    "leftrightarrows" : 8646, _
			    "leftrightharpoons" : 8651, _
			    "leftrightsquigarrow" : 8621, _
			    "leftthreetimes" : 8907, _
			    "leg" : 8922, _
			    "leq" : 8804, _
			    "leqq" : 8806, _
			    "leqslant" : 10877, _
			    "les" : 10877, _
			    "lescc" : 10920, _
			    "lesdot" : 10879, _
			    "lesdoto" : 10881, _
			    "lesdotor" : 10883, _
			    "lesg" : 8922, _
			    "lesges" : 10899, _
			    "lessapprox" : 10885, _
			    "lessdot" : 8918, _
			    "lesseqgtr" : 8922, _
			    "lesseqqgtr" : 10891, _
			    "lessgtr" : 8822, _
			    "lesssim" : 8818, _
			    "lfisht" : 10620, _
			    "lfloor" : 8970, _
			    "lfr" : 120105, _
			    "lg" : 8822, _
			    "lgE" : 10897, _
			    "lhard" : 8637, _
			    "lharu" : 8636, _
			    "lharul" : 10602, _
			    "lhblk" : 9604, _
			    "ljcy" : 1113, _
			    "ll" : 8810, _
			    "llarr" : 8647, _
			    "llcorner" : 8990, _
			    "llhard" : 10603, _
			    "lltri" : 9722, _
			    "lmidot" : 320, _
			    "lmoust" : 9136, _
			    "lmoustache" : 9136, _
			    "lnE" : 8808, _
			    "lnap" : 10889, _
			    "lnapprox" : 10889, _
			    "lne" : 10887, _
			    "lneq" : 10887, _
			    "lneqq" : 8808, _
			    "lnsim" : 8934, _
			    "loang" : 10220, _
			    "loarr" : 8701, _
			    "lobrk" : 10214, _
			    "longleftarrow" : 10229, _
			    "longleftrightarrow" : 10231, _
			    "longmapsto" : 10236, _
			    "longrightarrow" : 10230, _
			    "looparrowleft" : 8619, _
			    "looparrowright" : 8620, _
			    "lopar" : 10629, _
			    "lopf" : 120157, _
			    "loplus" : 10797, _
			    "lotimes" : 10804, _
			    "lowast" : 8727, _
			    "lowbar" : 95, _
			    "loz" : 9674, _
			    "lozenge" : 9674, _
			    "lozf" : 10731, _
			    "lpar" : 40, _
			    "lparlt" : 10643, _
			    "lrarr" : 8646, _
			    "lrcorner" : 8991, _
			    "lrhar" : 8651, _
			    "lrhard" : 10605, _
			    "lrm" : 8206, _
			    "lrtri" : 8895, _
			    "lsaquo" : 8249, _
			    "lscr" : 120001, _
			    "lsh" : 8624, _
			    "lsim" : 8818, _
			    "lsime" : 10893, _
			    "lsimg" : 10895, _
			    "lsqb" : 91, _
			    "lsquo" : 8216, _
			    "lsquor" : 8218, _
			    "lstrok" : 322, _
			    "lt" : 60, _
			    "ltcc" : 10918, _
			    "ltcir" : 10873, _
			    "ltdot" : 8918, _
			    "lthree" : 8907, _
			    "ltimes" : 8905, _
			    "ltlarr" : 10614, _
			    "ltquest" : 10875, _
			    "ltrPar" : 10646, _
			    "ltri" : 9667, _
			    "ltrie" : 8884, _
			    "ltrif" : 9666, _
			    "lurdshar" : 10570, _
			    "luruhar" : 10598, _
			    "lvertneqq" : 8808, _
			    "lvnE" : 8808, _
			    "mDDot" : 8762, _
			    "macr" : 175, _
			    "male" : 9794, _
			    "malt" : 10016, _
			    "maltese" : 10016, _
			    "map" : 8614, _
			    "mapsto" : 8614, _
			    "mapstodown" : 8615, _
			    "mapstoleft" : 8612, _
			    "mapstoup" : 8613, _
			    "marker" : 9646, _
			    "mcomma" : 10793, _
			    "mcy" : 1084, _
			    "mdash" : 8212, _
			    "measuredangle" : 8737, _
			    "mfr" : 120106, _
			    "mho" : 8487, _
			    "micro" : 181, _
			    "mid" : 8739, _
			    "midast" : 42, _
			    "midcir" : 10992, _
			    "middot" : 183, _
			    "minus" : 8722, _
			    "minusb" : 8863, _
			    "minusd" : 8760, _
			    "minusdu" : 10794, _
			    "mlcp" : 10971, _
			    "mldr" : 8230, _
			    "mnplus" : 8723, _
			    "models" : 8871, _
			    "mopf" : 120158, _
			    "mp" : 8723, _
			    "mscr" : 120002, _
			    "mstpos" : 8766, _
			    "mu" : 956, _
			    "multimap" : 8888, _
			    "mumap" : 8888, _
			    "nGg" : 8921, _
			    "nGt" : 8811, _
			    "nGtv" : 8811, _
			    "nLeftarrow" : 8653, _
			    "nLeftrightarrow" : 8654, _
			    "nLl" : 8920, _
			    "nLt" : 8810, _
			    "nLtv" : 8810, _
			    "nRightarrow" : 8655, _
			    "nVDash" : 8879, _
			    "nVdash" : 8878, _
			    "nabla" : 8711, _
			    "nacute" : 324, _
			    "nang" : 8736, _
			    "nap" : 8777, _
			    "napE" : 10864, _
			    "napid" : 8779, _
			    "napos" : 329, _
			    "napprox" : 8777, _
			    "natur" : 9838, _
			    "natural" : 9838, _
			    "naturals" : 8469, _
			    "nbsp" : 160, _
			    "nbump" : 8782, _
			    "nbumpe" : 8783, _
			    "ncap" : 10819, _
			    "ncaron" : 328, _
			    "ncedil" : 326, _
			    "ncong" : 8775, _
			    "ncongdot" : 10861, _
			    "ncup" : 10818, _
			    "ncy" : 1085, _
			    "ndash" : 8211, _
			    "ne" : 8800, _
			    "neArr" : 8663, _
			    "nearhk" : 10532, _
			    "nearr" : 8599, _
			    "nearrow" : 8599, _
			    "nedot" : 8784, _
			    "nequiv" : 8802, _
			    "nesear" : 10536, _
			    "nesim" : 8770, _
			    "nexist" : 8708, _
			    "nexists" : 8708, _
			    "nfr" : 120107, _
			    "ngE" : 8807, _
			    "nge" : 8817, _
			    "ngeq" : 8817, _
			    "ngeqq" : 8807, _
			    "ngeqslant" : 10878, _
			    "nges" : 10878, _
			    "ngsim" : 8821, _
			    "ngt" : 8815, _
			    "ngtr" : 8815, _
			    "nhArr" : 8654, _
			    "nharr" : 8622, _
			    "nhpar" : 10994, _
			    "ni" : 8715, _
			    "nis" : 8956, _
			    "nisd" : 8954, _
			    "niv" : 8715, _
			    "njcy" : 1114, _
			    "nlArr" : 8653, _
			    "nlE" : 8806, _
			    "nlarr" : 8602, _
			    "nldr" : 8229, _
			    "nle" : 8816, _
			    "nleftarrow" : 8602, _
			    "nleftrightarrow" : 8622, _
			    "nleq" : 8816, _
			    "nleqq" : 8806, _
			    "nleqslant" : 10877, _
			    "nles" : 10877, _
			    "nless" : 8814, _
			    "nlsim" : 8820, _
			    "nlt" : 8814, _
			    "nltri" : 8938, _
			    "nltrie" : 8940, _
			    "nmid" : 8740, _
			    "nopf" : 120159, _
			    "not" : 172, _
			    "notin" : 8713, _
			    "notinE" : 8953, _
			    "notindot" : 8949, _
			    "notinva" : 8713, _
			    "notinvb" : 8951, _
			    "notinvc" : 8950, _
			    "notni" : 8716, _
			    "notniva" : 8716, _
			    "notnivb" : 8958, _
			    "notnivc" : 8957, _
			    "npar" : 8742, _
			    "nparallel" : 8742, _
			    "nparsl" : 11005, _
			    "npart" : 8706, _
			    "npolint" : 10772, _
			    "npr" : 8832, _
			    "nprcue" : 8928, _
			    "npre" : 10927, _
			    "nprec" : 8832, _
			    "npreceq" : 10927, _
			    "nrArr" : 8655, _
			    "nrarr" : 8603, _
			    "nrarrc" : 10547, _
			    "nrarrw" : 8605, _
			    "nrightarrow" : 8603, _
			    "nrtri" : 8939, _
			    "nrtrie" : 8941, _
			    "nsc" : 8833, _
			    "nsccue" : 8929, _
			    "nsce" : 10928, _
			    "nscr" : 120003, _
			    "nshortmid" : 8740, _
			    "nshortparallel" : 8742, _
			    "nsim" : 8769, _
			    "nsime" : 8772, _
			    "nsimeq" : 8772, _
			    "nsmid" : 8740, _
			    "nspar" : 8742, _
			    "nsqsube" : 8930, _
			    "nsqsupe" : 8931, _
			    "nsub" : 8836, _
			    "nsubE" : 10949, _
			    "nsube" : 8840, _
			    "nsubset" : 8834, _
			    "nsubseteq" : 8840, _
			    "nsubseteqq" : 10949, _
			    "nsucc" : 8833, _
			    "nsucceq" : 10928, _
			    "nsup" : 8837, _
			    "nsupE" : 10950, _
			    "nsupe" : 8841, _
			    "nsupset" : 8835, _
			    "nsupseteq" : 8841, _
			    "nsupseteqq" : 10950, _
			    "ntgl" : 8825, _
			    "ntilde" : 241, _
			    "ntlg" : 8824, _
			    "ntriangleleft" : 8938, _
			    "ntrianglelefteq" : 8940, _
			    "ntriangleright" : 8939, _
			    "ntrianglerighteq" : 8941, _
			    "nu" : 957, _
			    "num" : 35, _
			    "numero" : 8470, _
			    "numsp" : 8199, _
			    "nvDash" : 8877, _
			    "nvHarr" : 10500, _
			    "nvap" : 8781, _
			    "nvdash" : 8876, _
			    "nvge" : 8805, _
			    "nvgt" : 62, _
			    "nvinfin" : 10718, _
			    "nvlArr" : 10498, _
			    "nvle" : 8804, _
			    "nvlt" : 60, _
			    "nvltrie" : 8884, _
			    "nvrArr" : 10499, _
			    "nvrtrie" : 8885, _
			    "nvsim" : 8764, _
			    "nwArr" : 8662, _
			    "nwarhk" : 10531, _
			    "nwarr" : 8598, _
			    "nwarrow" : 8598, _
			    "nwnear" : 10535, _
			    "oS" : 9416, _
			    "oacute" : 243, _
			    "oast" : 8859, _
			    "ocir" : 8858, _
			    "ocirc" : 244, _
			    "ocy" : 1086, _
			    "odash" : 8861, _
			    "odblac" : 337, _
			    "odiv" : 10808, _
			    "odot" : 8857, _
			    "odsold" : 10684, _
			    "oelig" : 339, _
			    "ofcir" : 10687, _
			    "ofr" : 120108, _
			    "ogon" : 731, _
			    "ograve" : 242, _
			    "ogt" : 10689, _
			    "ohbar" : 10677, _
			    "ohm" : 937, _
			    "oint" : 8750, _
			    "olarr" : 8634, _
			    "olcir" : 10686, _
			    "olcross" : 10683, _
			    "oline" : 8254, _
			    "olt" : 10688, _
			    "omacr" : 333, _
			    "omega" : 969, _
			    "omicron" : 959, _
			    "omid" : 10678, _
			    "ominus" : 8854, _
			    "oopf" : 120160, _
			    "opar" : 10679, _
			    "operp" : 10681, _
			    "oplus" : 8853, _
			    "or" : 8744, _
			    "orarr" : 8635, _
			    "ord" : 10845, _
			    "order" : 8500, _
			    "orderof" : 8500, _
			    "ordf" : 170, _
			    "ordm" : 186, _
			    "origof" : 8886, _
			    "oror" : 10838, _
			    "orslope" : 10839, _
			    "orv" : 10843, _
			    "oscr" : 8500, _
			    "oslash" : 248, _
			    "osol" : 8856, _
			    "otilde" : 245, _
			    "otimes" : 8855, _
			    "otimesas" : 10806, _
			    "ouml" : 246, _
			    "ovbar" : 9021, _
			    "par" : 8741, _
			    "para" : 182, _
			    "parallel" : 8741, _
			    "parsim" : 10995, _
			    "parsl" : 11005, _
			    "part" : 8706, _
			    "pcy" : 1087, _
			    "percnt" : 37, _
			    "period" : 46, _
			    "permil" : 8240, _
			    "perp" : 8869, _
			    "pertenk" : 8241, _
			    "pfr" : 120109, _
			    "phi" : 966, _
			    "phiv" : 981, _
			    "phmmat" : 8499, _
			    "phone" : 9742, _
			    "pi" : 960, _
			    "pitchfork" : 8916, _
			    "piv" : 982, _
			    "planck" : 8463, _
			    "planckh" : 8462, _
			    "plankv" : 8463, _
			    "plus" : 43, _
			    "plusacir" : 10787, _
			    "plusb" : 8862, _
			    "pluscir" : 10786, _
			    "plusdo" : 8724, _
			    "plusdu" : 10789, _
			    "pluse" : 10866, _
			    "plusmn" : 177, _
			    "plussim" : 10790, _
			    "plustwo" : 10791, _
			    "pm" : 177, _
			    "pointint" : 10773, _
			    "popf" : 120161, _
			    "pound" : 163, _
			    "pr" : 8826, _
			    "prE" : 10931, _
			    "prap" : 10935, _
			    "prcue" : 8828, _
			    "pre" : 10927, _
			    "prec" : 8826, _
			    "precapprox" : 10935, _
			    "preccurlyeq" : 8828, _
			    "preceq" : 10927, _
			    "precnapprox" : 10937, _
			    "precneqq" : 10933, _
			    "precnsim" : 8936, _
			    "precsim" : 8830, _
			    "prime" : 8242, _
			    "primes" : 8473, _
			    "prnE" : 10933, _
			    "prnap" : 10937, _
			    "prnsim" : 8936, _
			    "prod" : 8719, _
			    "profalar" : 9006, _
			    "profline" : 8978, _
			    "profsurf" : 8979, _
			    "prop" : 8733, _
			    "propto" : 8733, _
			    "prsim" : 8830, _
			    "prurel" : 8880, _
			    "pscr" : 120005, _
			    "psi" : 968, _
			    "puncsp" : 8200, _
			    "qfr" : 120110, _
			    "qint" : 10764, _
			    "qopf" : 120162, _
			    "qprime" : 8279, _
			    "qscr" : 120006, _
			    "quaternions" : 8461, _
			    "quatint" : 10774, _
			    "quest" : 63, _
			    "questeq" : 8799, _
			    "quot" : 34, _
			    "rAarr" : 8667, _
			    "rArr" : 8658, _
			    "rAtail" : 10524, _
			    "rBarr" : 10511, _
			    "rHar" : 10596, _
			    "race" : 8765, _
			    "racute" : 341, _
			    "radic" : 8730, _
			    "raemptyv" : 10675, _
			    "rang" : 10217, _
			    "rangd" : 10642, _
			    "range" : 10661, _
			    "rangle" : 10217, _
			    "raquo" : 187, _
			    "rarr" : 8594, _
			    "rarrap" : 10613, _
			    "rarrb" : 8677, _
			    "rarrbfs" : 10528, _
			    "rarrc" : 10547, _
			    "rarrfs" : 10526, _
			    "rarrhk" : 8618, _
			    "rarrlp" : 8620, _
			    "rarrpl" : 10565, _
			    "rarrsim" : 10612, _
			    "rarrtl" : 8611, _
			    "rarrw" : 8605, _
			    "ratail" : 10522, _
			    "ratio" : 8758, _
			    "rationals" : 8474, _
			    "rbarr" : 10509, _
			    "rbbrk" : 10099, _
			    "rbrace" : 125, _
			    "rbrack" : 93, _
			    "rbrke" : 10636, _
			    "rbrksld" : 10638, _
			    "rbrkslu" : 10640, _
			    "rcaron" : 345, _
			    "rcedil" : 343, _
			    "rceil" : 8969, _
			    "rcub" : 125, _
			    "rcy" : 1088, _
			    "rdca" : 10551, _
			    "rdldhar" : 10601, _
			    "rdquo" : 8221, _
			    "rdquor" : 8221, _
			    "rdsh" : 8627, _
			    "real" : 8476, _
			    "realine" : 8475, _
			    "realpart" : 8476, _
			    "reals" : 8477, _
			    "rect" : 9645, _
			    "reg" : 174, _
			    "rfisht" : 10621, _
			    "rfloor" : 8971, _
			    "rfr" : 120111, _
			    "rhard" : 8641, _
			    "rharu" : 8640, _
			    "rharul" : 10604, _
			    "rho" : 961, _
			    "rhov" : 1009, _
			    "rightarrow" : 8594, _
			    "rightarrowtail" : 8611, _
			    "rightharpoondown" : 8641, _
			    "rightharpoonup" : 8640, _
			    "rightleftarrows" : 8644, _
			    "rightleftharpoons" : 8652, _
			    "rightrightarrows" : 8649, _
			    "rightsquigarrow" : 8605, _
			    "rightthreetimes" : 8908, _
			    "ring" : 730, _
			    "risingdotseq" : 8787, _
			    "rlarr" : 8644, _
			    "rlhar" : 8652, _
			    "rlm" : 8207, _
			    "rmoust" : 9137, _
			    "rmoustache" : 9137, _
			    "rnmid" : 10990, _
			    "roang" : 10221, _
			    "roarr" : 8702, _
			    "robrk" : 10215, _
			    "ropar" : 10630, _
			    "ropf" : 120163, _
			    "roplus" : 10798, _
			    "rotimes" : 10805, _
			    "rpar" : 41, _
			    "rpargt" : 10644, _
			    "rppolint" : 10770, _
			    "rrarr" : 8649, _
			    "rsaquo" : 8250, _
			    "rscr" : 120007, _
			    "rsh" : 8625, _
			    "rsqb" : 93, _
			    "rsquo" : 8217, _
			    "rsquor" : 8217, _
			    "rthree" : 8908, _
			    "rtimes" : 8906, _
			    "rtri" : 9657, _
			    "rtrie" : 8885, _
			    "rtrif" : 9656, _
			    "rtriltri" : 10702, _
			    "ruluhar" : 10600, _
			    "rx" : 8478, _
			    "sacute" : 347, _
			    "sbquo" : 8218, _
			    "sc" : 8827, _
			    "scE" : 10932, _
			    "scap" : 10936, _
			    "scaron" : 353, _
			    "sccue" : 8829, _
			    "sce" : 10928, _
			    "scedil" : 351, _
			    "scirc" : 349, _
			    "scnE" : 10934, _
			    "scnap" : 10938, _
			    "scnsim" : 8937, _
			    "scpolint" : 10771, _
			    "scsim" : 8831, _
			    "scy" : 1089, _
			    "sdot" : 8901, _
			    "sdotb" : 8865, _
			    "sdote" : 10854, _
			    "seArr" : 8664, _
			    "searhk" : 10533, _
			    "searr" : 8600, _
			    "searrow" : 8600, _
			    "sect" : 167, _
			    "semi" : 59, _
			    "seswar" : 10537, _
			    "setminus" : 8726, _
			    "setmn" : 8726, _
			    "sext" : 10038, _
			    "sfr" : 120112, _
			    "sfrown" : 8994, _
			    "sharp" : 9839, _
			    "shchcy" : 1097, _
			    "shcy" : 1096, _
			    "shortmid" : 8739, _
			    "shortparallel" : 8741, _
			    "shy" : 173, _
			    "sigma" : 963, _
			    "sigmaf" : 962, _
			    "sigmav" : 962, _
			    "sim" : 8764, _
			    "simdot" : 10858, _
			    "sime" : 8771, _
			    "simeq" : 8771, _
			    "simg" : 10910, _
			    "simgE" : 10912, _
			    "siml" : 10909, _
			    "simlE" : 10911, _
			    "simne" : 8774, _
			    "simplus" : 10788, _
			    "simrarr" : 10610, _
			    "slarr" : 8592, _
			    "smallsetminus" : 8726, _
			    "smashp" : 10803, _
			    "smeparsl" : 10724, _
			    "smid" : 8739, _
			    "smile" : 8995, _
			    "smt" : 10922, _
			    "smte" : 10924, _
			    "smtes" : 10924, _
			    "softcy" : 1100, _
			    "sol" : 47, _
			    "solb" : 10692, _
			    "solbar" : 9023, _
			    "sopf" : 120164, _
			    "spades" : 9824, _
			    "spadesuit" : 9824, _
			    "spar" : 8741, _
			    "sqcap" : 8851, _
			    "sqcaps" : 8851, _
			    "sqcup" : 8852, _
			    "sqcups" : 8852, _
			    "sqsub" : 8847, _
			    "sqsube" : 8849, _
			    "sqsubset" : 8847, _
			    "sqsubseteq" : 8849, _
			    "sqsup" : 8848, _
			    "sqsupe" : 8850, _
			    "sqsupset" : 8848, _
			    "sqsupseteq" : 8850, _
			    "squ" : 9633, _
			    "square" : 9633, _
			    "squarf" : 9642, _
			    "squf" : 9642, _
			    "srarr" : 8594, _
			    "sscr" : 120008, _
			    "ssetmn" : 8726, _
			    "ssmile" : 8995, _
			    "sstarf" : 8902, _
			    "star" : 9734, _
			    "starf" : 9733, _
			    "straightepsilon" : 1013, _
			    "straightphi" : 981, _
			    "strns" : 175, _
			    "sub" : 8834, _
			      "subE" : 10949, _
			      "subdot" : 10941, _
			      "sube" : 8838, _
			      "subedot" : 10947, _
			      "submult" : 10945, _
			      "subnE" : 10955, _
			      "subne" : 8842, _
			      "subplus" : 10943, _
			      "subrarr" : 10617, _
			      "subset" : 8834, _
			      "subseteq" : 8838, _
			      "subseteqq" : 10949, _
			      "subsetneq" : 8842, _
			      "subsetneqq" : 10955, _
			      "subsim" : 10951, _
			      "subsub" : 10965, _
			      "subsup" : 10963, _
			      "succ" : 8827, _
			      "succapprox" : 10936, _
			      "succcurlyeq" : 8829, _
			      "succeq" : 10928, _
			      "succnapprox" : 10938, _
			      "succneqq" : 10934, _
			      "succnsim" : 8937, _
			      "succsim" : 8831, _
			      "sum" : 8721, _
			      "sung" : 9834, _
			      "sup1" : 185, _
			      "sup2" : 178, _
			      "sup3" : 179, _
			      "sup" : 8835, _
			      "supE" : 10950, _
			      "supdot" : 10942, _
			      "supdsub" : 10968, _
			      "supe" : 8839, _
			      "supedot" : 10948, _
			      "suphsol" : 10185, _
			      "suphsub" : 10967, _
			      "suplarr" : 10619, _
			      "supmult" : 10946, _
			      "supnE" : 10956, _
			      "supne" : 8843, _
			      "supplus" : 10944, _
			      "supset" : 8835, _
			      "supseteq" : 8839, _
			      "supseteqq" : 10950, _
			      "supsetneq" : 8843, _
			      "supsetneqq" : 10956, _
			      "supsim" : 10952, _
			      "supsub" : 10964, _
			      "supsup" : 10966, _
			      "swArr" : 8665, _
			      "swarhk" : 10534, _
			      "swarr" : 8601, _
			      "swarrow" : 8601, _
			      "swnwar" : 10538, _
			      "szlig" : 223, _
			      "target" : 8982, _
			      "tau" : 964, _
			      "tbrk" : 9140, _
			      "tcaron" : 357, _
			      "tcedil" : 355, _
			      "tcy" : 1090, _
			      "tdot" : 8411, _
			      "telrec" : 8981, _
			      "tfr" : 120113, _
			      "there4" : 8756, _
			      "therefore" : 8756, _
			      "theta" : 952, _
			      "thetasym" : 977, _
			      "thetav" : 977, _
			      "thickapprox" : 8776, _
			      "thicksim" : 8764, _
			      "thinsp" : 8201, _
			      "thkap" : 8776, _
			      "thksim" : 8764, _
			      "thorn" : 254, _
			      "tilde" : 732, _
			      "times" : 215, _
			      "timesb" : 8864, _
			      "timesbar" : 10801, _
			      "timesd" : 10800, _
			      "tint" : 8749, _
			      "toea" : 10536, _
			      "top" : 8868, _
			      "topbot" : 9014, _
			      "topcir" : 10993, _
			      "topf" : 120165, _
			      "topfork" : 10970, _
			      "tosa" : 10537, _
			      "tprime" : 8244, _
			      "trade" : 8482, _
			      "triangle" : 9653, _
			      "triangledown" : 9663, _
			      "triangleleft" : 9667, _
			      "trianglelefteq" : 8884, _
			      "triangleq" : 8796, _
			      "triangleright" : 9657, _
			      "trianglerighteq" : 8885, _
			      "tridot" : 9708, _
			      "trie" : 8796, _
			      "triminus" : 10810, _
			      "triplus" : 10809, _
			      "trisb" : 10701, _
			      "tritime" : 10811, _
			      "trpezium" : 9186, _
			      "tscr" : 120009, _
			      "tscy" : 1094, _
			      "tshcy" : 1115, _
			      "tstrok" : 359, _
			      "twixt" : 8812, _
			      "twoheadleftarrow" : 8606, _
			      "twoheadrightarrow" : 8608, _
			      "uArr" : 8657, _
			      "uHar" : 10595, _
			      "uacute" : 250, _
			      "uarr" : 8593, _
			      "ubrcy" : 1118, _
			      "ubreve" : 365, _
			      "ucirc" : 251, _
			      "ucy" : 1091, _
			      "udarr" : 8645, _
			      "udblac" : 369, _
			      "udhar" : 10606, _
			      "ufisht" : 10622, _
			      "ufr" : 120114, _
			      "ugrave" : 249, _
			      "uharl" : 8639, _
			      "uharr" : 8638, _
			      "uhblk" : 9600, _
			      "ulcorn" : 8988, _
			      "ulcorner" : 8988, _
			      "ulcrop" : 8975, _
			      "ultri" : 9720, _
			      "umacr" : 363, _
			      "uml" : 168, _
			      "uogon" : 371, _
			      "uopf" : 120166, _
			      "uparrow" : 8593, _
			      "updownarrow" : 8597, _
			      "upharpoonleft" : 8639, _
			      "upharpoonright" : 8638, _
			      "uplus" : 8846, _
			      "upsi" : 965, _
			      "upsih" : 978, _
			      "upsilon" : 965, _
			      "upuparrows" : 8648, _
			      "urcorn" : 8989, _
			      "urcorner" : 8989, _
			      "urcrop" : 8974, _
			      "uring" : 367, _
			      "urtri" : 9721, _
			      "uscr" : 120010, _
			      "utdot" : 8944, _
			      "utilde" : 361, _
			      "utri" : 9653, _
			      "utrif" : 9652, _
			      "uuarr" : 8648, _
			      "uuml" : 252, _
			      "uwangle" : 10663, _
			      "vArr" : 8661, _
			      "vBar" : 10984, _
			      "vBarv" : 10985, _
			      "vDash" : 8872, _
			      "vangrt" : 10652, _
			      "varepsilon" : 1013, _
			      "varkappa" : 1008, _
			      "varnothing" : 8709, _
			      "varphi" : 981, _
			      "varpi" : 982, _
			      "varpropto" : 8733, _
			      "varr" : 8597, _
			      "varrho" : 1009, _
			      "varsigma" : 962, _
			      "varsubsetneq" : 8842, _
			      "varsubsetneqq" : 10955, _
			      "varsupsetneq" : 8843, _
			      "varsupsetneqq" : 10956, _
			      "vartheta" : 977, _
			      "vartriangleleft" : 8882, _
			      "vartriangleright" : 8883, _
			      "vcy" : 1074, _
			      "vdash" : 8866, _
			      "vee" : 8744, _
			      "veebar" : 8891, _
			      "veeeq" : 8794, _
			      "vellip" : 8942, _
			      "verbar" : 124, _
			      "vert" : 124, _
			      "vfr" : 120115, _
			      "vltri" : 8882, _
			      "vnsub" : 8834, _
			      "vnsup" : 8835, _
			      "vopf" : 120167, _
			      "vprop" : 8733, _
			      "vrtri" : 8883, _
			      "vscr" : 120011, _
			      "vsubnE" : 10955, _
			      "vsubne" : 8842, _
			      "vsupnE" : 10956, _
			      "vsupne" : 8843, _
			      "vzigzag" : 10650, _
			      "wcirc" : 373, _
			      "wedbar" : 10847, _
			      "wedge" : 8743, _
			      "wedgeq" : 8793, _
			      "weierp" : 8472, _
			      "wfr" : 120116, _
			      "wopf" : 120168, _
			      "wp" : 8472, _
			      "wr" : 8768, _
			      "wreath" : 8768, _
			      "wscr" : 120012, _
			      "xcap" : 8898, _
			      "xcirc" : 9711, _
			      "xcup" : 8899, _
			      "xdtri" : 9661, _
			      "xfr" : 120117, _
			      "xhArr" : 10234, _
			      "xharr" : 10231, _
			      "xi" : 958, _
			      "xlArr" : 10232, _
			      "xlarr" : 10229, _
			      "xmap" : 10236, _
			      "xnis" : 8955, _
			      "xodot" : 10752, _
			      "xopf" : 120169, _
			      "xoplus" : 10753, _
			      "xotime" : 10754, _
			      "xrArr" : 10233, _
			      "xrarr" : 10230, _
			      "xscr" : 120013, _
			      "xsqcup" : 10758, _
			      "xuplus" : 10756, _
			      "xutri" : 9651, _
			      "xvee" : 8897, _
			      "xwedge" : 8896, _
			      "yacute" : 253, _
			      "yacy" : 1103, _
			      "ycirc" : 375, _
			      "ycy" : 1099, _
			      "yen" : 165, _
			      "yfr" : 120118, _
			      "yicy" : 1111, _
			      "yopf" : 120170, _
			      "yscr" : 120014, _
			      "yucy" : 1102, _
			      "yuml" : 255, _
			      "zacute" : 378, _
			      "zcaron" : 382, _
			      "zcy" : 1079, _
			      "zdot" : 380, _
			      "zeetrf" : 8488, _
			      "zeta" : 950, _
			      "zfr" : 120119, _
			      "zhcy" : 1078, _
			      "zigrarr" : 8669, _
			      "zopf" : 120171, _
			      "zscr" : 120015, _
			      "zwj" : 8205, _
			      "zwnj" : 8204)
			      
			      Return d
			      
			End Get
		#tag EndGetter
		Protected CharacterReferences As CaseSensitiveDictionary
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21, Description = 412064696374696F6E61727920636F6E7461696E696E67206368617261637465727320746861742063616E20626520657363617065642077697468206120707265636564696E67206261636B736C6173682E
		#tag Getter
			Get
			  /// A dictionary containing characters that can be escaped with a preceding backslash.
			  
			  Static d As New Dictionary( _
			  "!" : Nil, _
			  """" : Nil, _
			  "#" : Nil, _
			  "$" : Nil, _
			  "%" : Nil, _
			  "&" : Nil, _
			  "'" : Nil, _
			  "(" : Nil, _
			  ")" : Nil, _
			  "*" : Nil, _
			  "+" : Nil, _
			  "," : Nil, _
			  "-" : Nil, _
			  "." : Nil, _
			  "/" : Nil, _
			  "\" : Nil, _
			  ":" : Nil, _
			  ";" : Nil, _
			  "<" : Nil, _
			  "=" : Nil, _
			  ">" : Nil, _
			  "?" : Nil, _
			  "@" : Nil, _
			  "[" : Nil, _
			  "]" : Nil, _
			  "^" : Nil, _
			  "_" : Nil, _
			  "`" : Nil, _
			  "{" : Nil, _
			  "|" : Nil, _
			  "}" : Nil, _
			  "~" : Nil)
			  
			  Return d
			  
			End Get
		#tag EndGetter
		Private EscapableCharacters As Dictionary
	#tag EndComputedProperty

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

	#tag Property, Flags = &h21, Description = 416E20696E7465726E616C20706172736572207573656420666F7220636F6E76656E69656E6365206D6574686F647320737563682061732060546F48544D4C2829602E
		Private mParser As MarkdownKit.MKParser
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1, Description = 5468652063757272656E742076657273696F6E20696E2074686520666F726D61743A20224D414A4F522E4D494E4F522E5041544348222E
		#tag Getter
			Get
			  Return VERSION_MAJOR.ToString + "." + VERSION_MINOR.ToString + "." + VERSION_PATCH.ToString
			End Get
		#tag EndGetter
		Protected Version As String
	#tag EndComputedProperty


	#tag Constant, Name = MAX_REFERENCE_LABEL_LENGTH, Type = Double, Dynamic = False, Default = \"999", Scope = Protected, Description = 546865206D6178696D756D206E756D626572206F662063686172616374657273207065726D69747465642077697468696E207468652073717561726520627261636B657473206F662061206C696E6B206C6162656C2E
	#tag EndConstant

	#tag Constant, Name = VERSION_MAJOR, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = VERSION_MINOR, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = VERSION_PATCH, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = MKBlockTypes, Type = Integer, Flags = &h0
		AtxHeading
		  Block
		  BlockQuote
		  CodeSpan
		  Document
		  Emphasis
		  FencedCode
		  Html
		  IndentedCode
		  InlineHTML
		  InlineImage
		  InlineLink
		  InlineText
		  List
		  ListItem
		  Paragraph
		  ReferenceDefinition
		  SetextHeading
		  SoftBreak
		  StrongEmphasis
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

	#tag Enum, Name = MKLinkTypes, Type = Integer, Flags = &h0
		CollapsedReference
		  FullReference
		  ShortcutReference
		Standard
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
