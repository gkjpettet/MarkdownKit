#tag Class
Protected Class MarkdownPhase1IndentedCodeFenceTests
Inherits TestGroup
	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example77Test()
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = GetTestNumberFromMethodName(CurrentMethodName) + ".md"
		  Dim astNAme As Text = GetTestNumberFromMethodName(CurrentMethodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example80Test()
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = GetTestNumberFromMethodName(CurrentMethodName) + ".md"
		  Dim astNAme As Text = GetTestNumberFromMethodName(CurrentMethodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example81Test()
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = GetTestNumberFromMethodName(CurrentMethodName) + ".md"
		  Dim astNAme As Text = GetTestNumberFromMethodName(CurrentMethodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example82Test()
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = GetTestNumberFromMethodName(CurrentMethodName) + ".md"
		  Dim astNAme As Text = GetTestNumberFromMethodName(CurrentMethodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example83Test()
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = GetTestNumberFromMethodName(CurrentMethodName) + ".md"
		  Dim astNAme As Text = GetTestNumberFromMethodName(CurrentMethodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example84Test()
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = GetTestNumberFromMethodName(CurrentMethodName) + ".md"
		  Dim astNAme As Text = GetTestNumberFromMethodName(CurrentMethodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example86Test()
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = GetTestNumberFromMethodName(CurrentMethodName) + ".md"
		  Dim astNAme As Text = GetTestNumberFromMethodName(CurrentMethodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example87Test()
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = GetTestNumberFromMethodName(CurrentMethodName) + ".md"
		  Dim astNAme As Text = GetTestNumberFromMethodName(CurrentMethodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example88Test()
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = GetTestNumberFromMethodName(CurrentMethodName) + ".md"
		  Dim astNAme As Text = GetTestNumberFromMethodName(CurrentMethodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTestNumberFromMethodName(methodName As Text) As Text
		  // Given the name of a test, extract and return the test number.
		  // The method name should be in the format:
		  // MarkdownPhase1ATXTests.ExampleXXTest
		  
		  #Pragma BreakOnExceptions False
		  
		  Dim startPos As Integer = methodName.IndexOf("Example") + 7
		  Dim chars() As Text = methodName.Split
		  If startPos = 6 Or startPos = chars.Ubound Then
		    Dim e As New Xojo.Core.InvalidArgumentException
		    e.Reason = "Invalid method name format. Expected: `MarkdownPhase1ATXTests.ExampleXXTest`"
		    Raise e
		  End If
		  
		  Dim result As Text
		  Dim tmp As Integer
		  For i As Integer = startPos To chars.Ubound
		    Try
		      tmp = Integer.FromText(chars(i))
		      result = result + chars(i)
		    Catch
		      Exit
		    End Try
		  Next i
		  
		  If result.Length = 0 Then
		    Dim e As New Xojo.Core.InvalidArgumentException
		    e.Reason = "Invalid method name format. Expected: `MarkdownPhase1ATXTests.ExampleXXTest`"
		    Raise e
		  End If
		  
		  Return result
		  
		End Function
	#tag EndMethod


	#tag Note, Name = About
		These tests validate the first phase (document block construction) of the parsing process.
		Inline parsing does not occur until phase 2 which is why the expected AST is 
		different than that output by commonmark.js.
		
	#tag EndNote


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
			Name="IsRunning"
			Group="Behavior"
			Type="Boolean"
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
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
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
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
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
