#tag Class
Protected Class HTMLTestGroup
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub Run(methodName As String)
		  Var testNumber As Integer = Val(methodName.Replace("HTMLTests.Example", "").Replace("Test", ""))
		  
		  // Get the names of the files containing the test Markdown and expected HTML output.
		  Var mdName As String = testNumber.ToText + ".md"
		  Var htmlName As String = testNumber.ToText + ".html"
		  
		  // Get the example Markdown file.
		  Var md As String
		  If Not HTMLTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected HTML output.
		  Var expected As String
		  If Not HTMLTestController.GetTestHTML(htmlName, expected) Then
		    Assert.Fail("Unable to load test HTML file `" + htmlName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Var doc As New MarkdownKit.Document(md)
		  doc.ParseBlockStructure
		  doc.ParseInlines
		  
		  // Convert the AST to HTML.
		  Var renderer As New MarkdownKit.HTMLRenderer
		  renderer.VisitDocument(doc)
		  Var actual As String = renderer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  HTMLTestController.TransformWhitespace(actual)
		  HTMLTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  ' Assert.AreEqual(expected, actual)
		  Assert.AreEqualCustom(expected, actual)
		  
		  Exception e
		    Assert.FailCustom(expected, "Exception occurred!")
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
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
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
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
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
