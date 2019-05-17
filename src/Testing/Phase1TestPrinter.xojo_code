#tag Class
Protected Class Phase1TestPrinter
Implements Global.MarkdownKit.Walker
	#tag Method, Flags = &h0
		Sub VisitAtxHeading(atx As MarkdownKit.AtxHeading)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append("<heading level=" + """" + atx.Level.ToText + """" +  ">")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In atx.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Append("</heading>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlock(block As MarkdownKit.Block)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append("<block>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In block.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Append("</block>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitBlockQuote(bq As MarkdownKit.BlockQuote)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append("<block_quote>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In bq.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Append("</block_quote>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitDocument(d As MarkdownKit.Document)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append("<document>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In d.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Append("</document>")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitFencedCode(f As MarkdownKit.FencedCode)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  Dim info As Text = If(f.InfoString <> "", " info=" + """" + f.InfoString + """", "")
		  
		  mOutput.Append("<fenced_code_block" + If(info <> "", info, "") + ">")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In f.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Append("</fenced_code_block>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitHardBreak(hb As MarkdownKit.HardBreak)
		  #Pragma Unused hb
		  
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append("<linebreak />")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitIndentedCode(i As MarkdownKit.IndentedCode)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append("<indented_code_block>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In i.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Append("</indented_code_block>")
		  mOutput.Append(EOL)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitParagraph(p As MarkdownKit.Paragraph)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append("<paragraph>")
		  mOutput.Append(EOL)
		  
		  For Each b As MarkdownKit.Block In p.Children
		    b.Accept(Self)
		  Next b
		  
		  mOutput.Append("</paragraph>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitRawText(rt As MarkdownKit.RawText)
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append("<text>")
		  mOutput.Append(Text.Join(rt.Chars, ""))
		  mOutput.Append("</text>")
		  mOutput.Append(EOL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub VisitSoftBreak(sb As MarkdownKit.SoftBreak)
		  #Pragma Unused sb
		  
		  // Part of the Global.MarkdownKit.Walker interface.
		  
		  mOutput.Append("<softbreak />")
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
			Name="Output"
			Group="Behavior"
			Type="Text"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
