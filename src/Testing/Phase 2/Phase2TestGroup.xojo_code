#tag Class
Protected Class Phase2TestGroup
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub Run(testNumber As Integer)
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = testNumber.ToText + ".md"
		  Dim astNAme As Text = testNumber.ToText + "-phase2.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not Phase2TestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not Phase2TestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ParseBlockStructure
		  doc.ParseInlines
		  
		  // Convert the phase 2 block structure to Text.
		  Dim printer As New Phase2Printer
		  printer.Pretty = False
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  Phase2TestController.TransformWhitespace(actual)
		  Phase2TestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		  Exception e
		    Assert.FailCustom(expected, "Exception occurred!")
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
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
