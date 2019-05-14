#tag Class
Protected Class DebugWalker
Implements Global.MarkdownKit.Walker
	#tag Method, Flags = &h21
		Private Function CurrentIndent() As Text
		  // Given the current indentation level (specified by mCurrentIndent), this 
		  // method returns mCurrentIndent * 4 number of spaces as Text.
		  
		  If Not Pretty Then Return ""
		  
		  Dim numSpaces As Integer = mCurrentIndent * kSpacesPerIndent
		  Dim tmp() As Text
		  For i As Integer = 0 To numSpaces
		    tmp.Append(" ")
		  Next i
		  Return Text.Join(tmp, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DecreaseIndent()
		  mCurrentIndent = mCurrentIndent - 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub IncreaseIndent()
		  mCurrentIndent = mCurrentIndent + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlock(block As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append(CurrentIndent + "<Block>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In block.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</Block>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlockQuote(bq As MarkdownKit.BlockQuote)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append(CurrentIndent + "<BlockQuote>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In bq.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</BlockQuote>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitDocument(d As MarkdownKit.Document)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append(CurrentIndent + "<Document>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In d.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</Document>")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitParagraph(p As MarkdownKit.Paragraph)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append(CurrentIndent + "<Paragraph>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In p.Children
		    IncreaseIndent
		    b.Accept(Self)
		    DecreaseIndent
		  Next b
		  
		  mOutput.Append(CurrentIndent + "</Paragraph>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitRawText(rt As MarkdownKit.RawText)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append(CurrentIndent + "<RawText>")
		  mOutput.Append(rt.Value)
		  mOutput.Append("</RawText>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSoftBreak(sb As MarkdownKit.SoftBreak)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append(CurrentIndent + "<SoftBreak />")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h21
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
		Private EOL As Text
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCurrentIndent As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOutput() As Text
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Text.Join(mOutput, "")
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			  
			End Set
		#tag EndSetter
		Output As Text
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Pretty As Boolean = True
	#tag EndProperty


	#tag Constant, Name = kSpacesPerIndent, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant


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
