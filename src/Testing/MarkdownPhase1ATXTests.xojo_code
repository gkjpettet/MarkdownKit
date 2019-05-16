#tag Class
Protected Class MarkdownPhase1ATXTests
Inherits TestGroup
	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example32Test()
		  Const mdName = "32.md"
		  Const astName = "32-phase1.ast"
		  Dim abort As Boolean = False
		  
		  // Get the contents of the required files and abort if there's a problem.
		  Dim md As Text = GetMarkdown(mdName, abort)
		  Dim truth As Text = GetTruth(astName, abort)
		  If abort Then Return
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1Printer
		  printer.Pretty = True
		  printer.VisitDocument(doc)
		  Dim result As Text = printer.Output
		  
		  Assert.AreEqual(result, truth)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example33Test()
		  Const mdName = "33.md"
		  Const astName = "33-phase1.ast"
		  Dim abort As Boolean = False
		  
		  // Get the contents of the required files and abort if there's a problem.
		  Dim md As Text = GetMarkdown(mdName, abort)
		  Dim truth As Text = GetTruth(astName, abort)
		  If abort Then Return
		  
		  // Create a new Markdown document.
		  Dim doc As New MarkdownKit.Document(md)
		  doc.ConstructBlockStructure
		  
		  // Convert the phase 1 block structure to Text.
		  Dim printer As New Phase1Printer
		  printer.Pretty = True
		  printer.VisitDocument(doc)
		  Dim result As Text = printer.Output
		  
		  Assert.AreEqual(result, truth)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetMarkdown(markdownSourceFileName As Text, ByRef abort As Boolean) As Text
		  // Get the test Markdown source from the specified file name.
		  
		  Dim mdFile As Xojo.IO.FolderItem = Xojo.IO.SpecialFolder.GetResource(markdownSourceFileName)
		  
		  // Read the Markdown source.
		  Dim md As Text
		  Try
		    Dim tin As Xojo.IO.TextInputStream = Xojo.IO.TextInputStream.Open(mdFile, Xojo.Core.TextEncoding.UTF8)
		    md = tin.ReadAll
		    tin.Close
		    abort = False
		  Catch e
		    // This shouldn't happen.
		    MsgBox("Unable to read the contents of " + markdownSourceFileName)
		    Assert.AreEqual(0, 1) // Cause a fail.
		    abort = True
		  End Try
		  
		  Return md
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTruth(astSourceFileName As Text, ByRef abort As Boolean) As Text
		  // Get the expected AST Text from the specified file name.
		  
		  Dim astFile As Xojo.IO.FolderItem = Xojo.IO.SpecialFolder.GetResource(astSourceFileName)
		  
		  // Read the AST file.
		  Dim truth As Text
		  Try
		    Dim tin As Xojo.IO.TextInputStream = Xojo.IO.TextInputStream.Open(astFile, Xojo.Core.TextEncoding.UTF8)
		    truth = tin.ReadAll
		    tin.Close
		    abort = False
		  Catch e
		    // This shouldn't happen.
		    MsgBox("Unable to read the contents of " + astSourceFileName)
		    Assert.AreEqual(0, 1) // Cause a fail.
		    abort = True
		  End Try
		  
		  // Convert invisible characters to make them easier to see.
		  Dim chars() As Text = truth.Split
		  Dim i As Integer
		  Dim charsUbound As Integer = chars.Ubound
		  For i = 0 to charsUbound
		    Select Case chars(i)
		    Case " "
		      chars(i) = "•"
		    Case &u0009
		      chars(i) = "→"
		    End Select
		  Next i
		  
		  If chars.Ubound = -1 Then chars.Append("⮐")
		  
		  Return Text.Join(chars, "")
		  
		End Function
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
