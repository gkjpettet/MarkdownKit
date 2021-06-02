#tag Class
Protected Class CharacterRun
	#tag Method, Flags = &h0
		Sub Constructor()
		  Self.Start = -1
		  Self.Length = -1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(start As Integer, length As Integer, finish As Integer)
		  Self.Start = start
		  Self.Length = length
		  Self.Finish = finish
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToArray(source() As String) As String()
		  // Copies from the passed array of characters the characters that make up 
		  // this CharacterRun.
		  
		  Var sourceUbound As Integer = source.LastIndex
		  
		  // Sanity checks.
		  If Self.Start < 0 Or (Self.Start + Self.Length - 1) > sourceUbound Then
		    Raise New MarkdownKit.MarkdownException(_
		    "This CharacterRun is incompatible with the passed source array")
		  End If
		  
		  Var result() As String
		  If Self.Length = 0 Then Return result
		  
		  Var i, limit As Integer
		  limit = Self.Start + Self.Length - 1
		  For i = Self.Start To limit
		    result.Add(source(i))
		  Next i
		  
		  Return result
		  
		End Function
	#tag EndMethod


	#tag Note, Name = About
		A CharacterRun represents a substring within an array of characters. It contains the zero-based Start position
		in the array and the number of characters in the run (Length).
		
		E.g: 
		0 H
		1 I
		2 
		3 W
		4 O
		5 R
		6 L
		7 D
		
		CharacterRun(0, 1) = "HI"
		
		
	#tag EndNote


	#tag Property, Flags = &h0
		Finish As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		Invalid As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		Length As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		Start As Integer = -1
	#tag EndProperty


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
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finish"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Invalid"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
