#tag Class
Protected Class ASTTestController
Inherits TestController
	#tag Event
		Sub InitializeTestGroups()
		  // Instantiate TestGroup subclasses here so that they can be run.
		  
		  Var group As TestGroup
		  
		  // Current test.
		  group = New ASTCharacterReferenceTests(Self, "Character Reference Tests")
		  
		  // Block structure.
		  group = New ASTHTMLBlockTests(Self, "HTML Blocks")
		  group = New ASTParagraphTests(Self, "Paragraph Tests")
		  group = New ASTReferenceLinkTests(Self, "Reference Links")
		  group = New ASTListTests(Self, "Lists")
		  group = New ASTSetextTests(Self, "Setext Headings")
		  group = New ASTThematicBreakTests(Self, "Thematic Breaks")
		  group = New ASTBlockquoteTests(Self, "Blockquotes")
		  group = New ASTATXTests(Self, "ATX Headings")
		  group = New ASTIndentedCodeTests(Self, "Indented Code Blocks")
		  group = New ASTFencedCodeTests(Self, "Fenced Code Blocks")
		  group = New ASTBlankLineTests(Self, "Blank Lines")
		  
		  // Inlines.
		  group = New ASTBackslashEscapeTests(Self, "Backslash Escape Tests")
		  group = New ASTImageTests(Self, "Image Tests")
		  group = New ASTLinkTests(Self, "Link Tests")
		  group = New ASTEmphasisTests(Self, "Emphasis")
		  group = New ASTAutolinkTests(Self, "Auto Links")
		  group = New ASTTextualContentTests(Self, "Textual Content")
		  group = New ASTSoftLinebreakTests(Self, "Soft Line Breaks")
		  group = New ASTHardLinebreakTests(Self, "Hard Line Breaks")
		  group = New ASTInlineHTMLTests(Self, "Inline HTML")
		  group = New ASTCodespanTests(Self, "Code Spans")
		  group = New ASTInlineTests(Self, "Inline Tests")
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Shared Function GetTestAST(fileName As String, ByRef ast As String) As Boolean
		  // Takes the name of an example AST output file copied to the 
		  // app's resources folder and returns the contents.
		  
		  Var f As FolderItem = SpecialFolder.Resource("ASTs").Child(fileName)
		  
		  Var tin As TextInputStream = TextInputStream.Open(f)
		  ast = tin.ReadAll
		  tin.Close
		  Return True
		  
		  Exception e
		    MessageDialog.Show("Unable to find the AST example file `" + fileName + "`")
		    Return False
		    
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetTestMarkdown(fileName As String, ByRef md As String) As Boolean
		  // Takes the name of a Markdown example test file copied to the 
		  // app's resources folder and returns the contents.
		  
		  Var f As FolderItem = SpecialFolder.Resource("source markdown").Child(fileName)
		  Var tin As TextInputStream = TextInputStream.Open(f)
		  md = tin.ReadAll
		  tin.Close
		  Return True
		  
		  Exception e
		    MessageDialog.Show("Unable to find the Markdown example file `" + fileName + "`")
		    Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function GetTestNumberFromMethodName(methodName As String) As String
		  // Given the name of a test, extract and return the test number.
		  
		  #Pragma BreakOnExceptions False
		  
		  Var startPos As Integer = methodName.IndexOf("Example") + 7
		  Var chars() As String = methodName.Split("")
		  If startPos = 6 Or startPos = chars.LastIndex Then
		    Var e As New Xojo.Core.InvalidArgumentException
		    e.Reason = "Invalid method name format. Expected: `ExampleXXTest`"
		    Raise e
		  End If
		  
		  Var result As String
		  Var tmp As Integer
		  For i As Integer = startPos To chars.LastIndex
		    Try
		      tmp = chars(i).Val
		      result = result + chars(i)
		    Catch
		      Exit
		    End Try
		  Next i
		  
		  If result.Length = 0 Then
		    Var e As New Xojo.Core.InvalidArgumentException
		    e.Reason = "Invalid method name format. Expected: `ExampleXXTest`"
		    Raise e
		  End If
		  
		  Return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub TransformWhitespace(ByRef s As String)
		  s = s.ReplaceAll(&u0020, "•")
		  s = s.ReplaceAll(&u0009, "→")
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="AllTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="GroupCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunGroupCount"
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
			Name="SkippedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
