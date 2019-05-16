#tag Class
Protected Class MarkdownPhase1ATXTests
Inherits TestGroup
	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub Example32Test()
		  Const mdName = "32.md"
		  Const astName = "32-phase1.ast"
		  
		  // Get the example Markdown file.
		  Dim mdFile As Xojo.IO.FolderItem = Xojo.IO.SpecialFolder.GetResource(mdName)
		  
		  // Read the Markdown source.
		  Dim md As Text
		  Try
		    Dim tin As Xojo.IO.TextInputStream = Xojo.IO.TextInputStream.Open(mdFile, Xojo.Core.TextEncoding.UTF8)
		    md = tin.ReadAll
		    tin.Close
		  Catch e
		    // This shouldn't happen.
		    MsgBox("Unable to read the contents of " + mdName)
		    Assert.AreEqual(0, 1) // Cause a fail.
		  End Try
		  
		  // Get the example Markdown file.
		  Dim astFile As Xojo.IO.FolderItem = Xojo.IO.SpecialFolder.GetResource(astName)
		  
		  // Read the expected output.
		  Dim truth As Text
		  Try
		    Dim tin As Xojo.IO.TextInputStream = Xojo.IO.TextInputStream.Open(astFile, Xojo.Core.TextEncoding.UTF8)
		    truth = tin.ReadAll
		    tin.Close
		  Catch e
		    // This shouldn't happen.
		    MsgBox("Unable to read the contents of " + astName)
		    Assert.AreEqual(0, 1) // Cause a fail.
		  End Try
		  
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
