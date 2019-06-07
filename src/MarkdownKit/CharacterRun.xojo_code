#tag Class
Protected Class CharacterRun
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(start As Integer, finish As Integer)
		  Self.Start = start
		  Self.Finish = finish
		  
		End Sub
	#tag EndMethod


	#tag Note, Name = About
		A CharacterRun represents a substring within an array of characters. IT contains the zero-based start and finish 
		positions wihtin the array that constitute the word.
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
		Start As Integer = -1
	#tag EndProperty


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
		#tag ViewProperty
			Name="Start"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
