#tag Class
Protected Class LineInfo
	#tag Method, Flags = &h0
		Sub Constructor(lineContent As Text, lineIndex As Integer)
		  Self.Chars = lineContent.Split
		  Self.Index = lineIndex
		  Self.Number = lineIndex + 1
		  Self.CharsUbound = Self.Chars.Ubound
		  IsBlank = If(CharsUbound < 0 Or Chars(0) = MarkdownKit.kLF, True, False)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Chars() As Text
	#tag EndProperty

	#tag Property, Flags = &h0
		CharsUbound As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		Index As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		IsBlank As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		#tag Note
			Zero-based.
		#tag EndNote
		Number As Integer = 1
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
	#tag EndViewBehavior
End Class
#tag EndClass
