#tag Class
Protected Class MKHTMLBlockScanner
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  /// Private to prevent instantiation.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 46696E64732074686520302D626173656420696E64657820696E205B6C696E655D206F6620612076616C69642048544D4C20636C6F73696E6754616720626567696E6E696E67206174205B706F735D2E2052657475726E7320603060206966206E6F2076616C696420636C6F73696E6754616720697320666F756E642E
		Shared Function FindClosingTag(line As TextLine, pos As integer, ByRef tagName As String) As Integer
		  /// Finds the 0-based index in [line] of a valid HTML closingTag beginning at [pos].
		  /// Returns `0` if no valid closingTag is found.
		  ///
		  /// Assumes that [pos] points to the character immediately following "</"
		  ///
		  /// closingTag: </, tagName, optional whitespace, >
		  /// tagName: ASCII letter, >= 0 ASCII letter|digit|-
		  /// Also sets the ByRef [tagName] parameter to the detected tagName (if present) or "" if no 
		  /// valid tagName is found.
		  
		  tagName = ""
		  Var charsLastIndex As Integer = line.Characters.LastIndex
		  
		  If pos + 1 > charsLastIndex Then Return 0
		  
		  // The tag name must start with an ASCII letter.
		  If Not line.Characters(pos).IsASCIILetter Then Return 0
		  
		  // Get the tag name and move `pos` to the position immediately following the tag name.
		  tagName = MKHTMLBlockScanner.GetHtmlTagName(line.Characters, pos)
		  If pos > charsLastIndex Then Return 0
		  If tagName = "" Then Return 0
		  
		  // Get the current character.
		  Var c As String = line.Characters(pos)
		  
		  // Skip optional whitespace.
		  Call MKHTMLBlockScanner.SkipWhitespace(line.Characters, pos, c)
		  If pos > charsLastIndex Then Return 0
		  
		  // Check for the tag closing delimiter.
		  If c = ">" Then
		    Return pos + 1
		  Else
		    Return 0
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function FindOpenTag(line As TextLine, pos As Integer, ByRef tagName As String, type7Only As Boolean = True) As Integer
		  /// Returns the 0-based index in [line] of the end of a valid HTML opening tag, beginning at [pos] 
		  /// or `0` if not found. [tagName] is set to the tag found or "".
		  ///
		  /// Assumes that [pos] points to the character immediately following "<"
		  /// Sets the ByRef parameter [tagName] to the detected tag name (if present) or "" if none is found.
		  ///
		  /// openTag: "<", a tagname, >= 0 attributes, optional whitespace, optional "/", and a ">".
		  /// tagName: ASCII letter, >= 0 ASCII letter|digit|-
		  /// attribute: whitespace, attributeName, optional attributeValueSpec
		  /// attributeName: ASCII letter|-|:, >=0 ASCII letter|digit|_|.|:|-
		  /// attributeValueSpec: optional whitespace, =, optional whitespace, attributeValue
		  /// attributeValue: unQuotedAttValue | singleQuotedAttValue | doubleQuotedAttValue
		  /// unQuotedAttValue: > 0 characters NOT including whitespace, ", ', =, <, >, or `.
		  /// singleQuotedAttValue: ', >= 0 characters NOT including ', then a final '
		  /// doubleQuotedAttValue: ", >= 0 characters NOT including ", then a final "
		  
		  tagName = ""
		  
		  Var chars() As String = line.Characters
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  If pos + 1 > charsLastIndex Then Return 0
		  
		  // The tag name must start with an ASCII letter.
		  If Not chars(pos).IsASCIILetter Then Return 0
		  
		  // Get the tag name and move `pos` to the position immediately following the tag name.
		  tagName = MKHTMLBlockScanner.GetHtmlTagName(chars, pos)
		  If pos > charsLastIndex Then Return 0
		  If tagName = "" Then Return 0
		  
		  If type7Only Then
		    // For a valid type 7 HTML block start, "script", "pre" and "style" are not valid tag names.
		    If tagName = "script" Or tagName = "pre" Or tagName = "style" Then Return 0
		  End If
		  
		  // Loop until the end of the line is reached or the tag is closed.
		  Var hadWhitespace As Boolean = False
		  Var hadAttribute As Boolean = False
		  Var tmpChar As String
		  Var currentChar As String = chars(pos)
		  While pos <= charsLastIndex
		    // Skip whitespace.
		    hadWhitespace = MKHTMLBlockScanner.SkipWhitespace(chars, pos, currentChar)
		    
		    // Has the end of the tag been reached?
		    If currentChar = ">" Then
		      Return pos + 1
		    Else
		      If currentChar = "/" Then
		        If pos + 1 <= charsLastIndex And chars(pos + 1) = ">" Then
		          Return pos + 2
		        Else
		          Return 0
		        End If
		      End If
		    End If
		    
		    // Have we arrived at an attribute value?
		    If currentChar = "=" Then
		      If Not hadAttribute Or pos >= charsLastIndex Then Return 0
		      
		      // Move past the "=" symbol and any whitespace.
		      pos = pos + 1
		      currentChar = chars(pos)
		      Call MKHTMLBlockScanner.SkipWhitespace(chars, pos, currentChar)
		      
		      If currentChar = "'" Or currentChar = """" Then
		        tmpChar = currentChar
		        pos = pos + 1
		        If pos > charsLastIndex Then Return 0
		        currentChar = chars(pos)
		        Call MKHTMLBlockScanner.MatchAnythingExcept(line, pos, currentChar, tmpChar)
		        If currentChar <> tmpChar Or pos >= charsLastIndex Then Return 0
		        
		        pos = pos + 1
		        If pos > charsLastIndex Then Return 0
		        currentChar = chars(pos)
		      Else
		        // Unquoted attribute values must have at least one character.
		        If Not MKHTMLBlockScanner.MatchAnythingExceptInvalidAndWhitespace(line, pos, currentChar, """", "'", "=", "<", ">", "`") Then
		          Return 0
		        End If
		      End If
		      
		      hadAttribute = False
		      Continue
		    End If
		    
		    // The attribute must be preceded by whitespace.
		    If Not hadWhitespace Then Return 0
		    
		    // If the end has not been found then there is just one possible alternative - an attribute.
		    // Ensure that the attribute name starts with a correct character
		    If Not MKHTMLBlockScanner.MatchASCIILetterOrValidCharacter(line, pos, currentChar, "_", ":") Then
		      Return 0
		    End If
		    
		    // Match any remaining characters in the attribute name.
		    Call MKHTMLBlockScanner.MatchASCIILetterOrDigit(line, pos, currentChar, "_", ":", ".", "-")
		    hadAttribute = True
		  Wend
		  
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5374617274696E67206174205B706F735D2C20726561647320612048544D4C20746167206E616D652066726F6D205B63686172735D20616E642072657475726E732069742E2041646A75737473205B706F735D20746F20706F696E7420746F207468652063686172616374657220696D6D6564696174656C792061667465722074686520746167206E616D652E204D61792072657475726E2022222E
		Shared Function GetHtmlTagName(chars() As String, ByRef pos As Integer) As String
		  /// Starting at [pos], reads a HTML tag name from [chars] and returns it. Adjusts [pos] to point to the 
		  /// character immediately after the tag name. May return "".
		  ///
		  /// Note: [pos] is passed ByRef.
		  /// tagName: ASCII letter, >= 0 ASCII letter|digit|-
		  /// Returns "" If no valid tagName is found.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  If pos > charsLastIndex Or Not chars(pos).IsASCIILetter Then Return ""
		  
		  Var tmp() As String
		  Var start As Integer = pos
		  For pos = start To charsLastIndex
		    Var c As String = chars(pos)
		    If c.IsASCIILetter Or c.IsDigit Or c= "-" Then
		      tmp.Add(c)
		    Else
		      Exit
		    End If
		  Next pos
		  
		  Return String.FromArray(tmp, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320547275652069662C207374617274696E67206174205B706F735D2C2077652066696E6420612076616C69642048544D4C2074797065203120626C6F636B20656E64206F6E205B6C696E655D2E
		Shared Function IsHtmlBlockType1End(line As TextLine, pos As Integer) As Boolean
		  /// Returns True if, starting at [pos], we find a valid HTML type 1 block end on [line].
		  ///
		  /// End condition:   line contains an end tag </script>, </pre>, or </style> 
		  ///                  (case-insensitive; it need not match the start tag).
		  
		  #Pragma BreakOnExceptions False
		  
		  If line.Value.IndexOf(pos, "</pre>") <> -1 Then Return True
		  If line.Value.IndexOf(pos, "</style>") <> -1 Then Return True
		  If line.Value.IndexOf(pos, "</script>") <> -1 Then Return True
		  
		  Return False
		  
		  Exception e
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320547275652069662C207374617274696E67206174205B706F735D2C205B6C696E655D20636F6E7461696E7320612076616C69642048544D4C2074797065203220626C6F636B20656E642E
		Shared Function IsHtmlBlockType2End(line As TextLine, pos As Integer) As Boolean
		  /// Returns True if, starting at [pos], [line] contains a valid HTML type 2 block end.
		  ///
		  /// End condition: line contains the string "-->"
		  
		  #Pragma BreakOnExceptions False
		  
		  Return If(line.Value.IndexOf(pos, "-->") <> -1, True, False)
		  
		  Exception e
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 547275652069662C207374617274696E67206174205B706F735D2C205B6C696E655D20636F6E7461696E7320612076616C69642048544D4C2074797065203320626C6F636B20656E642E
		Shared Function IsHtmlBlockType3End(line As TextLine, pos As Integer) As Boolean
		  /// True if, starting at [pos], [line] contains a valid HTML type 3 block end.
		  ///
		  /// End condition: line contains the string "?>"
		  
		  #Pragma BreakOnExceptions False
		  
		  Return If(line.Value.IndexOf(pos, "?>") <> -1, True, False)
		  
		  Exception e
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 547275652069662C207374617274696E67206174205B706F735D2C205B6C696E655D20636F6E7461696E7320612076616C69642048544D4C2074797065203420626C6F636B20656E642E
		Shared Function IsHtmlBlockType4End(line As TextLine, pos As Integer) As Boolean
		  /// True if, starting at [pos], [line] contains a valid HTML type 4 block end.
		  ///
		  /// End condition: line contains the character ">".
		  
		  #Pragma BreakOnExceptions False
		  
		  Return If(line.Value.IndexOf(pos, ">") <> -1, True, False)
		  
		  Exception e
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 547275652069662C207374617274696E67206174205B706F735D2C205B6C696E655D20636F6E7461696E7320612076616C69642048544D4C2074797065203520626C6F636B20656E642E
		Shared Function IsHtmlBlockType5End(line As TextLine, pos As Integer) As Boolean
		  /// True if, starting at [pos], [line] contains a valid HTML type 5 block end.
		  ///
		  /// End condition: line contains the string "]]>".
		  
		  #Pragma BreakOnExceptions False
		  
		  Return If(line.Value.IndexOf(pos, "]]>") <> -1, True, False)
		  
		  Exception e
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416476616E636573207061737420746865206368617261637465727320696E205B6C696E655D207374617274696E67206174205B706F735D20756E74696C205B696E76616C6964436861725D2E2052657475726E73205472756520696620776520616476616E6365642E205B706F735D20616E64205B63757272656E74436861725D20617265206D7574617465642E
		Shared Function MatchAnythingExcept(line As TextLine, ByRef pos As Integer, ByRef currentChar As String, invalidChar As String) As Boolean
		  /// Advances past the characters in [line] starting at [pos] until [invalidChar]. 
		  /// Returns True if we advanced. [pos] and [currentChar] are mutated.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = line.Characters.LastIndex
		  
		  While currentChar <> invalidChar And pos < charsLastIndex
		    pos = pos + 1
		    currentChar = line.Characters(pos)
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416476616E636573207061737420746865206368617261637465727320696E205B6C696E655D207374617274696E67206174205B706F735D20756E74696C2077686974657370616365206F7220616E20696E76616C69642063686172616374657220697320666F756E642E2052657475726E73205472756520696620776520616476616E6365642E205B706F735D20616E64205B63757272656E74436861725D20617265206D7574617465642E
		Shared Function MatchAnythingExceptInvalidAndWhitespace(line As TextLine, ByRef pos As Integer, ByRef currentChar As String, ParamArray invalidChars() As String) As Boolean
		  /// Advances past the characters in [line] starting at [pos] until whitespace or an invalid character is found.
		  /// Returns True if we advanced. [pos] and [currentChar] are mutated.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = line.Characters.LastIndex
		  
		  // Add in whitespace characters to the array of invalid characters.
		  invalidChars.Add(" ")
		  invalidChars.Add(&u000A)
		  
		  While invalidChars.IndexOf(currentChar) = -1 And pos < charsLastIndex
		    pos = pos + 1
		    currentChar = line.Characters(pos)
		    matched = True
		  Wend
		  
		  Return matched
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416476616E63657320616C6F6E67205B6C696E655D207374617274696E67206174205B706F735D206173206C6F6E67206173207468652063686172616374657220697320616E204153434949206C65747465722C206469676974206F72205B76616C696443686172735D2E204D757461746573205B706F735D20616E64205B63757272656E74436861725D2E2054727565206966205B706F735D206368616E6765642E
		Shared Function MatchASCIILetterOrDigit(line As TextLine, ByRef pos As Integer, ByRef currentChar As String, ParamArray validChars() As String) As Boolean
		  /// Advances along [line] starting at [pos] as long as the character is an ASCII letter, digit or 
		  /// [validChars]. Mutates [pos] and [currentChar]. True if [pos] changed.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = line.Characters.LastIndex
		  
		  While pos < charsLastIndex And _
		    (currentChar.IsASCIILetter Or currentChar.IsDigit Or validChars.IndexOf(currentChar) <> -1)
		    pos = pos + 1
		    currentChar = line.Characters(pos)
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416476616E63657320616C6F6E67205B6C696E655D207374617274696E67206174205B706F735D206173206C6F6E67206173207468652063686172616374657220697320616E204153434949206C6574746572206F72205B76616C696443686172735D2E204D757461746573205B706F735D20616E64205B63757272656E74436861725D2E2054727565206966205B706F735D206368616E6765642E
		Shared Function MatchASCIILetterOrValidCharacter(line As TextLine, ByRef pos As Integer, ByRef currentChar As String, ParamArray validChars() As String) As Boolean
		  /// Advances along [line] starting at [pos] as long as the character is an ASCII letter or 
		  /// [validChars]. Mutates [pos] and [currentChar]. True if [pos] changed.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = line.Characters.LastIndex
		  
		  While pos < charsLastIndex And _
		    (currentChar.IsASCIILetter Or validChars.IndexOf(currentChar) <> -1)
		    pos = pos + 1
		    currentChar = line.Characters(pos)
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536B697073206F766572207768697465737061636520696E205B63686172735D20626567696E6E696E67206174205B706F735D207570646174696E67205B706F735D20616E64205B63757272656E74436861725D2E2052657475726E73205472756520696620616E7920776869746573706163652077617320736B69707065642E
		Shared Function SkipWhitespace(chars() As String, ByRef pos As Integer, ByRef currentChar As String) As Boolean
		  /// Skips over whitespace in [chars] beginning at [pos] updating [pos] and [currentChar]. Returns True if
		  /// any whitespace was skipped.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  While currentChar.IsMarkdownWhitespace And pos < charsLastIndex
		    pos = pos + 1
		    currentChar = chars(pos)
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod


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
End Class
#tag EndClass
