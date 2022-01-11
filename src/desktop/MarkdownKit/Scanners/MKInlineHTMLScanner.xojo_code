#tag Class
Protected Class MKInlineHTMLScanner
	#tag Method, Flags = &h0, Description = 46696E64732074686520302D626173656420696E64657820696E205B63686172735D206F6620612076616C69642048544D4C20636C6F73696E6754616720626567696E6E696E67206174205B706F735D2E2052657475726E7320603060206966206E6F2076616C696420636C6F73696E6754616720697320666F756E642E
		Shared Function FindClosingTag(chars() As MKCharacter, pos As integer, ByRef tagName As String) As Integer
		  /// Finds the 0-based index in [chars] of a valid HTML closingTag beginning at [pos].
		  /// Returns `0` if no valid closingTag is found.
		  ///
		  /// Assumes that [pos] points to the character immediately following "</"
		  ///
		  /// closingTag: </, tagName, optional whitespace, >
		  /// tagName: ASCII letter, >= 0 ASCII letter|digit|-
		  /// Also sets the ByRef [tagName] parameter to the detected tagName (if present) or "" if no 
		  /// valid tagName is found.
		  ///
		  /// The return value is the 0-based index immediately after the closing `>`.
		  
		  tagName = ""
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  If pos + 1 > charsLastIndex Then Return 0
		  
		  // The tag name must start with an ASCII letter.
		  If Not chars(pos).Value.IsASCIILetter Then Return 0
		  
		  // Get the tag name and move `pos` to the position immediately following the tag name.
		  tagName = GetHtmlTagName(chars, pos)
		  If pos > charsLastIndex Then Return 0
		  If tagName = "" Then Return 0
		  
		  // Get the current character.
		  Var c As String = chars(pos).Value
		  
		  // Skip optional whitespace.
		  Call SkipWhitespace(chars, pos, c)
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
		Shared Function FindOpenTag(chars() As MKCharacter, pos As Integer, ByRef tagName As String) As Integer
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
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  If pos + 1 > charsLastIndex Then Return 0
		  
		  // The tag name must start with an ASCII letter.
		  If Not chars(pos).Value.IsASCIILetter Then Return 0
		  
		  // Get the tag name and move `pos` to the position immediately following the tag name.
		  tagName = GetHtmlTagName(chars, pos)
		  If pos > charsLastIndex Then Return 0
		  If tagName = "" Then Return 0
		  
		  // Loop until the end of the line is reached or the tag is closed.
		  Var hadWhitespace As Boolean = False
		  Var hadAttribute As Boolean = False
		  Var tmpChar As String
		  Var currentChar As String = chars(pos).Value
		  While pos <= charsLastIndex
		    // Skip whitespace.
		    hadWhitespace = SkipWhitespace(chars, pos, currentChar)
		    
		    // Has the end of the tag been reached?
		    If currentChar = ">" Then
		      Return pos + 1
		    Else
		      If currentChar = "/" Then
		        If pos + 1 <= charsLastIndex And chars(pos + 1).Value = ">" Then
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
		      currentChar = chars(pos).Value
		      Call SkipWhitespace(chars, pos, currentChar)
		      
		      If currentChar = "'" Or currentChar = """" Then
		        tmpChar = currentChar
		        pos = pos + 1
		        If pos > charsLastIndex Then Return 0
		        currentChar = chars(pos).Value
		        Call MatchAnythingExcept(chars, pos, currentChar, tmpChar)
		        If currentChar <> tmpChar Or pos >= charsLastIndex Then Return 0
		        
		        pos = pos + 1
		        If pos > charsLastIndex Then Return 0
		        currentChar = chars(pos).Value
		      Else
		        // Unquoted attribute values must have at least one valid character.
		        If Not MatchAnythingExceptInvalidAndWhitespace(chars, pos, currentChar, """", "'", "=", "<", ">", "`") Then
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
		    If Not MatchASCIILetterOrValidCharacter(chars, pos, currentChar, "_", ":") Then
		      Return 0
		    End If
		    
		    // Match any remaining characters in the attribute name.
		    Call MatchASCIILetterOrDigit(chars, pos, currentChar, "_", ":", ".", "-")
		    hadAttribute = True
		  Wend
		  
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5374617274696E67206174205B706F735D2C20726561647320612048544D4C20746167206E616D652066726F6D205B63686172735D20616E642072657475726E732069742E2041646A75737473205B706F735D20746F20706F696E7420746F207468652063686172616374657220696D6D6564696174656C792061667465722074686520746167206E616D652E204D61792072657475726E2022222E
		Shared Function GetHtmlTagName(chars() As MKCharacter, ByRef pos As Integer) As String
		  /// Starting at [pos], reads a HTML tag name from [chars] and returns it. Adjusts [pos] to point to the 
		  /// character immediately after the tag name. May return "".
		  ///
		  /// Note: [pos] is passed ByRef.
		  /// tagName: ASCII letter, >= 0 ASCII letter|digit|-
		  /// Returns "" If no valid tagName is found.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  If pos > charsLastIndex Or Not chars(pos).Value.IsASCIILetter Then Return ""
		  
		  Var tmp() As String
		  Var start As Integer = pos
		  For pos = start To charsLastIndex
		    Var c As String = chars(pos).Value
		    If c.IsASCIILetter Or c.IsDigit Or c= "-" Then
		      tmp.Add(c)
		    Else
		      Exit
		    End If
		  Next pos
		  
		  Return String.FromArray(tmp, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416476616E636573207061737420746865206368617261637465727320696E205B63686172735D207374617274696E67206174205B706F735D20756E74696C205B696E76616C6964436861725D2E2052657475726E73205472756520696620776520616476616E6365642E205B706F735D20616E64205B63757272656E74436861725D20617265206D7574617465642E
		Shared Function MatchAnythingExcept(chars() As MKCharacter, ByRef pos As Integer, ByRef currentChar As String, invalidChar As String) As Boolean
		  /// Advances past the characters in [chars] starting at [pos] until [invalidChar]. 
		  /// Returns True if we advanced. [pos] and [currentChar] are mutated.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  While currentChar <> invalidChar And pos < charsLastIndex
		    pos = pos + 1
		    currentChar = chars(pos).Value
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416476616E636573207061737420746865206368617261637465727320696E205B63686172735D207374617274696E67206174205B706F735D20756E74696C2077686974657370616365206F7220616E20696E76616C69642063686172616374657220697320666F756E642E2052657475726E73205472756520696620776520616476616E6365642E205B706F735D20616E64205B63757272656E74436861725D20617265206D7574617465642E
		Shared Function MatchAnythingExceptInvalidAndWhitespace(chars() As MKCharacter, ByRef pos As Integer, ByRef currentChar As String, ParamArray invalidChars() As String) As Boolean
		  /// Advances past the characters in [chars] starting at [pos] until whitespace or an invalid character is 
		  /// found. Returns True if we advanced. [pos] and [currentChar] are mutated.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Add in whitespace characters to the array of invalid characters.
		  invalidChars.Add(" ")
		  invalidChars.Add(&u000A)
		  
		  While pos < charsLastIndex And (currentChar.IsASCIILetterOrDigitOrHyphen Or currentChar = ":") And invalidChars.IndexOf(currentChar) = -1
		    pos = pos + 1
		    currentChar = chars(pos).Value
		    matched = True
		  Wend
		  
		  Return matched
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416476616E636573207468726F756768205B63686172735D207374617274696E67206174205B706F735D206173206C6F6E67206173207468652063686172616374657220697320616E204153434949206C65747465722C206469676974206F72205B76616C696443686172735D2E204D757461746573205B706F735D20616E64205B63757272656E74436861725D2E2054727565206966205B706F735D206368616E6765642E
		Shared Function MatchASCIILetterOrDigit(chars() As MKCharacter, ByRef pos As Integer, ByRef currentChar As String, ParamArray validChars() As String) As Boolean
		  /// Advances through [chars] starting at [pos] as long as the character is an ASCII letter, digit or 
		  /// [validChars]. Mutates [pos] and [currentChar]. True if [pos] changed.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  While pos < charsLastIndex And _
		    (currentChar.IsASCIILetterOrDigit Or validChars.IndexOf(currentChar) <> -1)
		    pos = pos + 1
		    currentChar = chars(pos).Value
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 416476616E636573207468726F756768205B63686172735D206173206C6F6E67206173206974206D61746368657320616E204153434949206C65747465722C206469676974206F722068797068656E2E2052657475726E7320746865206E756D626572206F66206D61746368656420636861726163746572732E2053746F7073206966207765206D61746368205B6D6178436F756E745D20636861726163746572732E
		Private Shared Function MatchASCIILetterOrDigitOrHyphen(chars() As MKCharacter, pos As Integer, maxCount As Integer) As Integer
		  /// Advances through [chars] as long as it matches an ASCII letter, digit or hyphen. Returns the number 
		  /// of matched characters. Stops if we match [maxCount] characters.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  If pos > charsLastIndex Then Return 0
		  Var c As String = chars(pos).Value
		  Var matched As Integer = 0
		  
		  While c.IsASCIILetterOrDigitOrHyphen And pos < charsLastIndex And matched <= maxCount
		    pos = pos + 1
		    c = chars(pos).Value
		    matched = matched + 1
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 416476616E636573207468726F756768205B63686172735D207374617274696E67206174205B706F735D206173206C6F6E67206173207468652063686172616374657220697320616E204153434949206C6574746572206F72205B76616C696443686172735D2E204D757461746573205B706F735D20616E64205B63757272656E74436861725D2E2054727565206966205B706F735D206368616E6765642E
		Shared Function MatchASCIILetterOrValidCharacter(chars() As MKCharacter, ByRef pos As Integer, ByRef currentChar As String, ParamArray validChars() As String) As Boolean
		  /// Advances through [chars] starting at [pos] as long as the character is an ASCII letter or 
		  /// [validChars]. Mutates [pos] and [currentChar]. True if [pos] changed.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  While pos < charsLastIndex And _
		    (currentChar.IsASCIILetter Or validChars.IndexOf(currentChar) <> -1)
		    pos = pos + 1
		    currentChar = chars(pos).Value
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363616E73205B63686172735D20666F7220612076616C6964206175746F6C696E6B2072657475726E696E672074686520696E646578206F66207468652063686172616374657220696D6D6564696174656C7920666F6C6C6F77696E6720612076616C6964206175746F6C696E6B206F7220603060206966206E6F6E6520697320666F756E642E2053657473205B7572695D20746F20746865206162736F6C757465205552492E
		Shared Function ScanAutoLink(chars() As MKCharacter, startPos As Integer, ByRef uri As String) As Integer
		  /// Scans [chars] for a valid autolink returning the index of the character immediately following a valid 
		  /// autolink or `0` if none is found. Sets [uri] to the absolute URI.
		  ///
		  /// Assumes `chars(startPos - 1) = "<"`
		  ///
		  /// Valid autolink:
		  ///      "<", absolute URI, ">"
		  /// Absolute URI = scheme, :, >=0 characters (not WS, <, >)
		  /// Scheme = [A-Za-z]{1}[A-Za-z0-9\+\.\-]{1, 31}
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Reset the URI.
		  uri = ""
		  
		  // The minimum valid autolink is 5 characters (e.g: `<aa:>`).
		  If startPos + 3 > charsLastIndex Then Return 0
		  
		  // Check for a valid scheme.
		  Var pos As Integer = ScanLinkScheme(chars, startPos)
		  If pos = 0 Or pos >= charsLastIndex Then Return 0
		  
		  // Check for a colon.
		  If chars(pos).Value <> ":" Then Return 0
		  pos = pos +1
		  
		  // Skip over any characters that aren't whitespace, "<" or ">"
		  If pos >= charsLastIndex Then Return 0
		  Var c As MKCharacter
		  Var limit As Integer
		  For pos = pos To charsLastIndex
		    c = chars(pos)
		    If c.Value = ">" Then
		      // Valid autolink. Construct the URI.
		      limit = pos - 1
		      Var tmp() As String
		      For i As Integer = startPos To limit
		        tmp.Add(chars(i).Value)
		      Next i
		      uri = String.FromArray(tmp, "")
		      Return pos + 1
		    End If
		    If c.IsMarkdownWhitespace Then Return 0
		    If c.Value = "<" Then Return 0
		  Next pos
		  
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363616E73205B63686172735D20666F7220612076616C69642048544D4C206465636C61726174696F6E2C20636F6D6D656E74206F722043444154412073656374696F6E2E2052657475726E732074686520696E646578206F6620746865206368617261637465722061667465722074686520636C6F73696E6720636861726163746572206F7220603060206966206E6F7420666F756E642E
		Shared Function ScanDeclarationCommentOrCData(chars() As MKCharacter, startPos As Integer) As Integer
		  /// Scans [chars] for a valid HTML declaration, comment or CDATA section. Returns the index of the 
		  /// character after the closing character or `0` if not found.
		  ///
		  /// Assumes [startPos] points at the index of the character immediately following `<!`.
		  ///
		  /// CDATA:
		  /// -----
		  ///   "<![CDATA[", >= 0 characters, then "]]>
		  ///
		  /// Declaration:
		  /// -----------
		  ///   "<!", >= 1 uppercase ASCII letters, whitespace, >= 1 characters not including ">", then ">"
		  ///
		  /// Comment:
		  /// -------
		  ///   "<!--" + text + "-->"
		  ///   Where text does not start with ">" or "->", does not end with "-", and does not contain "--"
		  ///
		  /// Starting assumptions:
		  ///   <![CDATA[X]]>
		  ///   0123456789012
		  ///     ^
		  ///
		  ///   <!X X>
		  ///   012345
		  ///     ^
		  ///
		  ///   <!--a-->
		  ///   01234567
		  ///     ^
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Shortest valid: <!A A>
		  If startPos + 3 > charsLastIndex Then Return 0
		  
		  Var c As String = chars(startPos).Value
		  
		  Var pos As Integer
		  If c = "-" Then
		    // Comment?
		    If chars(startPos + 1).Value <> "-" Then Return 0
		    If chars(startPos + 2).Value = ">" Then Return 0 // Text can't start with ">"
		    If chars(startPos + 2).Value = "-" And chars(startPos + 3).Value = ">" Then Return 0 // Or "->"
		    
		    For pos = startPos + 2 To charsLastIndex
		      If chars(pos).Value = "-" And pos + 2 <= charsLastIndex And chars(pos + 1).Value = "-" Then
		        If chars(pos + 2).Value = ">" Then
		          Return pos + 3
		        Else // The contents can't contain "--"
		          Return 0
		        End If
		      End If
		    Next pos
		    Return 0
		    
		  ElseIf c = "[" Then
		    // CDATA?
		    If startPos + 10 > charsLastIndex Then Return 0
		    If chars(startPos + 1).Value <> "C" And chars(startPos + 2).Value <> "D" And _
		    chars(startPos + 3).Value <> "A" And chars(startPos + 4).Value <> "T" And _
		    chars(startPos + 5).Value <> "A" And chars(startPos + 5).Value <>"[" Then Return 0
		    // Skip over the contents until we hit "]]>"
		    For pos = startPos + 6 To charsLastIndex
		      If chars(pos).Value = "]" And pos + 2 <= charsLastIndex And chars(pos + 1).Value = "]" And _
		      chars(pos + 2).Value = ">" Then Return pos + 3
		    Next pos
		    Return 0
		    
		  ElseIf c.IsUppercaseASCIICharacter Then
		    // Declaration?
		    // Consume the uppercase ASCII letters.
		    For pos = startPos + 1 To charsLastIndex
		      If Not chars(pos).Value.IsUppercaseASCIILetter Then Exit
		    Next pos
		    
		    // Must see whitespace at `pos`.
		    If Not chars(pos).IsMarkdownWhitespace Then Return 0
		    // Consume the contiguous whitespace.
		    For pos = pos + 1 to charsLastIndex
		      If Not chars(pos).IsMarkdownWhitespace Then Exit
		    Next pos
		    
		    If pos >= charsLastIndex Then Return 0
		    
		    // Must see at least one character that's not ">"
		    If chars(pos).Value = ">" Then Return 0
		    
		    // Consume characters until we get to ">"
		    For pos = pos + 1 To charsLastIndex
		      If chars(pos).Value = ">" Then Return pos + 1
		    Next pos
		    Return 0
		    
		  Else
		    Return 0
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363616E73205B63686172735D2066726F6D205B7374617274506F735D20666F7220612076616C696420656D61696C206175746F6C696E6B2C2072657475726E696E672074686520696E646578206F66207468652063686172616374657220616674657220612076616C6964206175746F6C696E6B206F7220603060206966206E6F6E6520697320666F756E642E2053657473205B7572695D20746F20746865206162736F6C757465205552492E
		Shared Function ScanEmailLink(chars() As MKCharacter, startPos As Integer, ByRef uri As String) As Integer
		  /// Scans [chars] from [startPos] for a valid email autolink, returning the index of the character
		  /// after a valid autolink or `0` if none is found. Sets [uri] to the absolute URI.
		  ///
		  /// Assumes `chars(startPos - 1) = "<"`
		  /// Sets the ByRef parameter `uri` to the absolute URI.
		  /// 
		  /// Valid email autolink:
		  ///  "<", email address, ">"
		  ///   Email address:
		  ///      [a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?
		  ///      (?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Reset the URI.
		  uri = ""
		  
		  Var pos As Integer = startPos
		  
		  // Match between 1 and unlimited times, as many times as possible, a character 
		  // in the set: a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-
		  Var c As String
		  Var done As Boolean = False
		  While pos < charsLastIndex
		    If Not EmailPartOneCharacters.HasKey(chars(pos).Value) Then
		      Exit
		    Else
		      done = True
		    End If
		    pos = pos + 1
		  Wend
		  If Not done Then Return 0
		  
		  // Need to see the `@` character.
		  If chars(pos).Value <> "@" Then Return 0
		  pos = pos + 1
		  
		  // [a-zA-Z0-9]
		  If pos > charsLastIndex Then Return 0
		  c = chars(pos).Value
		  If Not c.IsASCIILetterOrDigit Then Return 0
		  pos = pos + 1
		  
		  If pos > charsLastIndex Then Return 0
		  
		  // Is there a dot next?
		  c = chars(pos).Value
		  Var hadDot As Boolean = If(c = ".", True, False)
		  Var dotPosition As Integer = If(hadDot, pos, -1)
		  
		  Var count As Integer
		  If Not hadDot Then
		    // Match zero or one times: [a-zA-Z0-9-]{0,61}[a-zA-Z0-9]
		    count = MatchASCIILetterOrDigitOrHyphen(chars, pos, 62)
		    pos = pos + count
		    // Need a dot.
		    If pos > charsLastIndex Then Return 0
		    If chars(pos).Value <> "." Then Return 0
		    dotPosition = pos
		    pos = pos + 1
		  End If
		  
		  pos = dotPosition
		  
		  
		  Var valid As Boolean = False
		  Var limit As Integer
		  Var tmp() As String
		  Do
		    // Have we found a valid email?
		    If chars(pos).Value = ">" Then
		      If Valid Then
		        // Construct the URI.
		        limit = pos - 1
		        tmp.RemoveAll
		        For i As Integer = startPos To limit
		          tmp.Add(chars(i).Value)
		        Next i
		        uri = String.FromArray(tmp, "")
		        Return pos + 1
		      Else
		        Return 0
		      End If
		    End If
		    
		    // Match dot.
		    If chars(pos).Value <> "." Then Return 0
		    pos = pos + 1
		    
		    // Match once: [a-zA-Z0-9]
		    If pos > charsLastIndex Then Return 0
		    c = chars(pos).Value
		    If Not c.IsASCIILetterOrDigit Then Return 0
		    pos = pos + 1
		    If pos > charsLastIndex Then Return 0
		    
		    // Match zero or one times: [a-zA-Z0-9-]{0,61}[a-zA-Z0-9]
		    count = MatchASCIILetterOrDigitOrHyphen(chars, pos, 62)
		    pos = pos + count
		    If pos > charsLastIndex Then Return 0
		    valid = True
		  Loop
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5363616E73205B63686172735D20626567696E6E696E67206174205B706F735D20666F7220616E20696E6C696E65206C696E6B20736368656D652C2072657475726E696E672074686520696E646578206F66207468652063686172616374657220666F6C6C6F77696E672074686520736368656D65206F7220603060206966206E6F6E6520697320666F756E642E
		Private Shared Function ScanLinkScheme(chars() As MKCharacter, pos As Integer) As Integer
		  /// Scans [chars] beginning at [pos] for an inline link scheme, returning the index of the character 
		  /// following the scheme or `0` if none is found.
		  ///
		  /// Valid scheme = [A-Za-z]{1}[A-Za-z0-9\+\.\-]{1, 31}
		  
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  #Pragma DisableBoundsChecking
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // The minimum valid scheme is 2 characters (e.g: `aa`).
		  If pos + 1 > charsLastIndex Then Return 0
		  
		  If Not chars(pos).Value.IsASCIILetter Then Return 0
		  
		  Var c As String = chars(pos + 1).Value
		  If Not c.IsASCIILetterOrDigit And _
		    c <> "+" And c<> "." And c <> "-" Then
		    Return 0
		  End If
		  
		  pos = pos + 2
		  
		  // Up to 30 more ASCII letters, digits, +, . or -
		  Var count As Integer = 1
		  While pos <= charsLastIndex And count <= 30
		    c = chars(pos).Value
		    
		    If Not c.IsASCIILetterOrDigit And c <> "+" And c <> "." And c <> "-" Then
		      Return pos
		    End If
		    
		    pos = pos + 1
		    count = count + 1
		  Wend
		  
		  Return pos
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5363616E7320666F7220616E20696E6C696E652048544D4C202270726F63657373696E6720696E737472756374696F6E222E2052657475726E732074686520696E64657820696E205B63686172735D206F6620746865206368617261637465722061667465722074686520636C6F73696E6720603F3E60206F7220603060206966206E6F7420666F756E642E
		Shared Function ScanProcessingInstruction(chars() As MKCharacter, startPos As Integer) As Integer
		  /// Scans for an inline HTML "processing instruction". Returns the index in [chars] of the character after
		  /// the closing `?>` or `0` if not found.
		  ///
		  /// A processing instruction consists of the string `<?`, a string of characters not including the 
		  /// string `?>` and the string `?>`.
		  /// Assumes [startPos] points at the index in [chars] of the character immediately following an 
		  /// opening `<?`.
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  // Min valid format: <??>
		  If startPos + 2 > charsLastIndex Then Return 0
		  
		  For i As Integer = startPos To charsLastIndex
		    If chars(i).Value = "?" And i + 1 <= charsLastIndex And chars(i + 1).Value = ">" Then
		      Return i + 2
		    ElseIf chars(i).IsLineEnding Then
		      Return 0
		    End If
		  Next i
		  
		  Return 0
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 536B697073206F766572207768697465737061636520696E205B63686172735D20626567696E6E696E67206174205B706F735D207570646174696E67205B706F735D20616E64205B63757272656E74436861725D2E2052657475726E73205472756520696620616E7920776869746573706163652077617320736B69707065642E
		Shared Function SkipWhitespace(chars() As MKCharacter, ByRef pos As Integer, ByRef currentChar As String) As Boolean
		  /// Skips over whitespace in [chars] beginning at [pos] updating [pos] and [currentChar]. Returns True if
		  /// any whitespace was skipped.
		  
		  Var matched As Boolean = False
		  
		  Var charsLastIndex As Integer = chars.LastIndex
		  
		  While currentChar.IsMarkdownWhitespace And pos < charsLastIndex
		    pos = pos + 1
		    currentChar = chars(pos).Value
		    matched = True
		  Wend
		  
		  Return matched
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h21, Description = 53746F7265732074686520636861726163746572732074686174206172652076616C696420666F72207468652066697273742070617274206F6620616E20656D61696C206175746F6C696E6B3A20612D7A412D5A302D392E2123242526272A2B5C2F3D3F5E5F607B7C7D7E2D
		#tag Note
			Stores the characters that are valid for the first part of an email autolink:
			a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-
		#tag EndNote
		#tag Getter
			Get
			  Static d As New Dictionary( _
			  "a" : Nil, _
			  "b" : Nil, _
			  "c" : Nil, _
			  "d" : Nil, _
			  "e" : Nil, _
			  "f" : Nil, _
			  "g" : Nil, _
			  "h" : Nil, _
			  "i" : Nil, _
			  "j" : Nil, _
			  "k" : Nil, _
			  "l" : Nil, _
			  "m" : Nil, _
			  "n" : Nil, _
			  "o" : Nil, _
			  "p" : Nil, _
			  "q" : Nil, _
			  "r" : Nil, _
			  "s" : Nil, _
			  "t" : Nil, _
			  "u" : Nil, _
			  "v" : Nil, _
			  "w" : Nil, _
			  "x" : Nil, _
			  "y" : Nil, _
			  "z" : Nil, _
			  "0" : Nil, _
			  "1" : Nil, _
			  "2" : Nil, _
			  "3" : Nil, _
			  "4" : Nil, _
			  "5" : Nil, _
			  "6" : Nil, _
			  "7" : Nil, _
			  "8" : Nil, _
			  "9" : Nil, _
			  "." : Nil, _
			  "!" : Nil, _
			  "#" : Nil, _
			  "$" : Nil, _
			  "%" : Nil, _
			  "&" : Nil, _
			  "'" : Nil, _
			  "*" : Nil, _
			  "+" : Nil, _
			  "/" : Nil, _
			  "=" : Nil, _
			  "?" : Nil, _
			  "^" : Nil, _
			  "_" : Nil, _
			  "`" : Nil, _
			  "{" : Nil, _
			  "|" : Nil, _
			  "}" : Nil, _
			  "~" : Nil, _
			  "-" : Nil)
			  
			  Return d
			  
			  
			  
			End Get
		#tag EndGetter
		Private Shared EmailPartOneCharacters As Dictionary
	#tag EndComputedProperty


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
