#tag Class
Protected Class MarkdownKitTestController
Inherits TestController
	#tag Event
		Sub InitializeTestGroups()
		  // Instantiate TestGroup subclasses here so that they can be run.
		  
		  Dim group As TestGroup
		  
		  // group = New MarkdownPhase1BlockquoteTests(Self, "Blockquotes")
		  // group = New MarkdownPhase1ATXTests(Self, "ATX Headings")
		  // group = New MarkdownPhase1IndentedCodeTests(Self, "Indented Code Blocks")
		  group = New MarkdownPhase1FencedCodeTests(Self, "Fenced Code Blocks")
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Shared Function GetTestAST(fileName As Text, ByRef ast As Text) As Boolean
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
		    
		    Return False
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetTestMarkdown(fileName As Text, ByRef md As Text) As Boolean
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
		    Return False
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetTestNumberFromMethodName(methodName As Text) As Text
		  // Given the name of a test, extract and return the test number.
		  
		  #Pragma BreakOnExceptions False
		  
		  Dim startPos As Integer = methodName.IndexOf("Example") + 7
		  Dim chars() As Text = methodName.Split
		  If startPos = 6 Or startPos = chars.Ubound Then
		    Dim e As New Xojo.Core.InvalidArgumentException
		    e.Reason = "Invalid method name format. Expected: `ExampleXXTest`"
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
		    e.Reason = "Invalid method name format. Expected: `ExampleXXTest`"
		    Raise e
		  End If
		  
		  Return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub RunPhase1Test(methodName As Text, tg As TestGroup)
		  // Get the names of the files containing the test Markdown and expected AST output.
		  Dim mdName As Text = MarkdownKitTestController.GetTestNumberFromMethodName(methodName) + ".md"
		  Dim astNAme As Text = MarkdownKitTestController.GetTestNumberFromMethodName(methodName) + "-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim md As Text
		  If Not MarkdownKitTestController.GetTestMarkdown(mdName, md) Then
		    tg.Assert.Fail("Unable to load test Markdown file `" + mdName + "`")
		    Return
		  End If
		  
		  // Get the expected AST output.
		  Dim expected As Text
		  If Not MarkdownKitTestController.GetTestAST(astName, expected) Then
		    tg.Assert.Fail("Unable to load test AST file `" + astName + "`")
		    Return
		  End If
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ParseBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New MarkdownKit.Phase1Printer
		  printer.Pretty = False
		  printer.VisitDocument(doc)
		  Dim actual As Text = printer.Output
		  
		  // Transform whitespace in our result and the expected truth to make it 
		  // easier to visualise.
		  MarkdownKitTestController.TransformWhitespace(actual)
		  MarkdownKitTestController.TransformWhitespace(expected)
		  
		  // Check the result matches the truth.
		  tg.Assert.AreEqual(expected, actual)
		  
		  Exception e
		    tg.Assert.FailCustom(expected, "Exception occurred!")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub TransformWhitespace(ByRef t As Text)
		  t = t.ReplaceAll(" ", "•")
		  t = t.ReplaceAll(&u0009, "→")
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
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
