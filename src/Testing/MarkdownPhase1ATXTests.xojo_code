#tag Class
Protected Class MarkdownPhase1ATXTests
Inherits TestGroup
	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example32Test()
		  Const mdName = "32.md"
		  Const astName = "32-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not GetTestMarkdown(mdName, md) Then Return // Error loading resource.
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not GetTestAST(astName, expected) Then Return // Error loading resource.
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  TransformWhitespace(actual)
		  TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(expected, actual)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example33Test()
		  Const mdName = "33.md"
		  Const astName = "33-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not GetTestMarkdown(mdName, md) Then Return // Error loading resource.
		  
		  // Get the expected AST output.
		  Dim truth As Text
		  If Not GetTestAST(astName, truth) Then Return // Error loading resource.
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim result As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  TransformWhitespace(result)
		  TransformWhitespace(truth)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(truth, result)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example34Test()
		  Const mdName = "34.md"
		  Const astName = "34-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not GetTestMarkdown(mdName, md) Then Return // Error loading resource.
		  
		  // Get the expected AST output.
		  Dim truth As Text
		  If Not GetTestAST(astName, truth) Then Return // Error loading resource.
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim result As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  TransformWhitespace(result)
		  TransformWhitespace(truth)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(truth, result)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example35Test()
		  Const mdName = "35.md"
		  Const astName = "35-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not GetTestMarkdown(mdName, md) Then Return // Error loading resource.
		  
		  // Get the expected AST output.
		  Dim truth As Text
		  If Not GetTestAST(astName, truth) Then Return // Error loading resource.
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim result As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  TransformWhitespace(result)
		  TransformWhitespace(truth)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(truth, result)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example36Test()
		  Const mdName = "36.md"
		  Const astName = "36-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not GetTestMarkdown(mdName, md) Then Return // Error loading resource.
		  
		  // Get the expected AST output.
		  Dim truth As Text
		  If Not GetTestAST(astName, truth) Then Return // Error loading resource.
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim result As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  TransformWhitespace(result)
		  TransformWhitespace(truth)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(truth, result)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example37Test()
		  Const mdName = "37.md"
		  Const astName = "37-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not GetTestMarkdown(mdName, md) Then Return // Error loading resource.
		  
		  // Get the expected AST output.
		  Dim truth As Text
		  If Not GetTestAST(astName, truth) Then Return // Error loading resource.
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim result As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  TransformWhitespace(result)
		  TransformWhitespace(truth)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(truth, result)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example38Test()
		  Const mdName = "38.md"
		  Const astName = "38-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not GetTestMarkdown(mdName, md) Then Return // Error loading resource.
		  
		  // Get the expected AST output.
		  Dim truth As Text
		  If Not GetTestAST(astName, truth) Then Return // Error loading resource.
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim result As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  TransformWhitespace(result)
		  TransformWhitespace(truth)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(truth, result)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example39Test()
		  Const mdName = "39.md"
		  Const astName = "39-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not GetTestMarkdown(mdName, md) Then Return // Error loading resource.
		  
		  // Get the expected AST output.
		  Dim truth As Text
		  If Not GetTestAST(astName, truth) Then Return // Error loading resource.
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1TestPrinter
		  printer.VisitDocument(doc)
		  Dim result As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  TransformWhitespace(result)
		  TransformWhitespace(truth)
		  
		  // Check the result matches the truth.
		  Assert.AreEqual(truth, result)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTestAST(fileName As Text, ByRef ast As Text) As Boolean
		  // Takes the name of an example AST output file copied to the 
		  // app's resources folder and returns the contents.
		  
		  Dim f As Xojo.IO.FolderItem = Xojo.IO.SpecialFolder.GetResource(fileName)
		  
		  Try
		    Dim tin As Xojo.IO.TextInputStream = Xojo.IO.TextInputStream.Open(f, Xojo.Core.TextEncoding.UTF8)
		    ast = tin.ReadAll
		    tin.Close
		    Return True
		  Catch e
		    MsgBox("Unable to find the AST example file `" + fileName + "`")
		    Assert.AreEqual(0, 1) // Force a fail.
		    Return False
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTestMarkdown(fileName As Text, ByRef md As Text) As Boolean
		  // Takes the name of a Markdown example test file copied to the 
		  // app's resources folder and returns the contents.
		  
		  Dim f As Xojo.IO.FolderItem = Xojo.IO.SpecialFolder.GetResource(fileName)
		  
		  Try
		    Dim tin As Xojo.IO.TextInputStream = Xojo.IO.TextInputStream.Open(f, Xojo.Core.TextEncoding.UTF8)
		    md = tin.ReadAll
		    tin.Close
		    Return True
		  Catch e
		    MsgBox("Unable to find the Markdown example file `" + fileName + "`")
		    Assert.AreEqual(0, 1) // Force a fail.
		    Return False
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TransformWhitespace(ByRef t As Text)
		  t = t.ReplaceAll(" ", "•")
		  t = t.ReplaceAll(&u0009, "→")
		  
		End Sub
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
