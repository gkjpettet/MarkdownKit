#tag Class
Protected Class LineInfo
	#tag Method, Flags = &h0
		Sub AdvanceOffset(count As Integer, columns As Boolean)
		  // Advance the offset by the specified number of places.
		  // If `columns` is set to True then we need to take into consideration 
		  // tab stops.
		  
		  If columns Then
		    If RemainingSpaces > count Then
		      RemainingSpaces = RemainingSpaces - count
		      count = 0
		    Else
		      count = count - RemainingSpaces
		      RemainingSpaces = 0
		    End If
		  Else
		    RemainingSpaces = 0
		  End If
		  
		  Dim charsToTabStop As Integer
		  Do
		    // If count = 0 Then Exit
		    If count <= 0 Then Exit
		    
		    If Offset > CharsLastIndex Then
		      CurrentChar = ""
		      Exit
		    End If
		    
		    CurrentChar = Chars(Offset)
		    Select Case CurrentChar
		    Case ""
		      Exit
		    Case &u0009
		      charsToTabStop = 4 - (column Mod kTabSize)
		      Column = Column + charsToTabStop
		      Offset = Offset + 1
		      count = count - If(columns, charsToTabStop, 1)
		      If count < 0 Then RemainingSpaces = 0 - count
		    Else
		      Offset = Offset + 1
		      Column = Column + 1
		      count = count - 1
		    End Select
		  Loop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AdvanceOptionalSpace() As Boolean
		  // Advance a single space or tab if the next character is a space.
		  // Returns True if there is an optional space or False if the next character 
		  // is a non-whitespace character.
		  
		  If RemainingSpaces > 0 Then
		    RemainingSpaces = RemainingSpaces - 1
		    Return True
		  End If
		  
		  If Offset > CharsLastIndex Then Return False
		  
		  Select Case Chars(Offset)
		  Case " "
		    Offset = Offset + 1
		    Column = Column + 1
		    CurrentChar = If(Offset <= CharsLastIndex, Chars(Offset), "")
		    Return True
		  Case &u0009
		    Offset = Offset + 1
		    Dim charsToTabStop As Integer = 4 - (Column Mod kTabSize)
		    Column = Column + charsToTabStop
		    RemainingSpaces = charsToTabStop - 1
		    CurrentChar = If(Offset <= CharsLastIndex, Chars(Offset), "")
		    Return True
		  End Select
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(lineText As String, lineNumber As Integer, startOffset As Integer = -1)
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Value = lineText
		  Chars = lineText.Split("")
		  CharsLastIndex = Chars.LastIndex
		  Number = lineNumber
		  Self.StartOffset = startOffset
		  
		  IsEmpty = If(Value = "", True, False)
		  
		  If IsEmpty Then
		    IsBlank = True
		    Return
		  End If
		  
		  // A line containing no characters, or a line containing only spaces or
		  // tabs, is considered blank (spec 0.29 2.1).
		  Dim i As Integer
		  IsBlank = True
		  For i = 0 To CharsLastIndex
		    Select Case Chars(i)
		    Case &u0020, &u0009
		      // Keep searching.
		    Else
		      IsBlank = False
		    End Select
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 46696E647320746865206E657874206E6F6E2D776869746573706163652063686172616374657220696E2074686973206C696E6520626567696E6E696E67206174207468652063757272656E74206F66667365742E2055706461746573206043757272656E7443686172602C2060436F6C756D6E602C206046697273744E57536020616E64206046697273744E5753436F6C756D6E602070726F706572746965732E
		Sub FindNextNonWhitespace()
		  // Starting at Offset, find the next non-whitespace (NWS) character on this 
		  // line, updating NextNWS, NextNWSColumn and CurrentChar.
		  // If we don't find a NWS then we set:
		  //        - CurrentChar to ""
		  //        - Column, NextNWSColumn and NextNWSColumn to -1
		  
		  
		  // Is the entire line blank?
		  If IsBlank Then CurrentChar = ""
		  
		  Dim charsToNextTabStop As Integer = kTabSize - (Column Mod kTabSize)
		  NextNWS = Offset
		  NextNWSColumn = Column
		  
		  Do
		    If NextNWS > CharsLastIndex Then
		      CurrentChar = ""
		    Else
		      CurrentChar = Chars(NextNWS)
		    End If
		    Select Case CurrentChar
		    Case " "
		      NextNWS = NextNWS + 1
		      NextNWSColumn = NextNWSColumn + 1
		      charsToNextTabStop = charsToNextTabStop - 1
		      If charsToNextTabStop = 0 Then charsToNextTabStop = kTabSize
		    Case &u0009
		      NextNWS = NextNWS + 1
		      NextNWSColumn = NextNWSColumn + charsToNextTabStop
		      charsToNextTabStop = kTabSize
		    Else
		      Exit
		    End Select
		  Loop
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		AllMatched As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E206172726179206F662074686520696E646976696475616C2063686172616374657273206F662074686973206C696E652E
		Chars() As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520757070657220626F756E6473206F662074686973206C696E6527732043686172732061727261792E20
		CharsLastIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207669727475616C20706F736974696F6E20696E20746865206C696E6520746861742074616B65732054414220657870616E73696F6E20696E746F206163636F756E742E
		Column As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468652063757272656E742063686172616374657220696E20746865206C696E652E
		CurrentChar As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 41206C696E6520697320636F6E7369646572656420626C616E6B20696620697420697320656D707479206F72206F6E6C7920636F6E7461696E7320776869746573706163652E
		IsBlank As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662074686973206C696E6520636F6E7461696E73206E6F207465787420617420616C6C2C20697420697320636F6E7369646572656420656D7074792E
		IsEmpty As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207A65726F2D626173656420696E646578206F6620746865206E657874206E6F6E2D776869746573706163652063686172616374657220696E20746865206C696E652C20617373756D696E67207468617420746865206C696E6520626567696E7320617420606F6666736574602E
		NextNWS As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207669727475616C20706F736974696F6E206F6620746865206E657874206E6F6E2D776869746573706163652063686172616374657220746861742074616B65732054414220657870616E73696F6E20696E746F206163636F756E742E
		NextNWSColumn As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C696E65206E756D626572206F662074686973206C696E6520696E20746865206F726967696E616C204D61726B646F776E20736F757263652E204C696E65206E756D6265727320617265206F6E652D62617365642E
		Number As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865207A65726F2D626173656420706F736974696F6E206F66207468652063757272656E742063686172616374657220696E20746865206C696E652E
		Offset As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E2061646A7573746D656E742076616C756520746F20746865207669727475616C2060436F6C756D6E60207468617420706F696E747320746F20746865206E756D626572206F66207370616365732066726F6D207468652054414220746861742068617665206E6F74206265656E20696E636C7564656420696E20616E7920696E64656E742E
		RemainingSpaces As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D6261736564206F666673657420696E20746865206F726967696E616C20736F7572636520636F646520737472696E67206F662074686520666972737420636861726163746572206F662074686973206C696E652E
		StartOffset As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F726967696E616C20746578742076616C7565206F662074686973206C696E652E
		Value As String
	#tag EndProperty


	#tag Constant, Name = kTabSize, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant


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
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllMatched"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CharsLastIndex"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Column"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CurrentChar"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NextNWS"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NextNWSColumn"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Number"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Offset"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RemainingSpaces"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsBlank"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsEmpty"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StartOffset"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
