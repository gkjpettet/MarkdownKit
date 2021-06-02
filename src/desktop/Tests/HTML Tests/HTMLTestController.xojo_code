#tag Class
Protected Class HTMLTestController
Inherits TestController
	#tag Event
		Sub InitializeTestGroups()
		  // Instantiate TestGroup subclasses here so that they can be run.
		  
		  Var group As TestGroup
		  
		  group = New HTMLTests(Self, "HTML Tests")
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Shared Function GetTestHTML(fileName As String, ByRef html As String) As Boolean
		  // Takes the name of an example HTML output file copied to the 
		  // app's resources folder and returns the contents.
		  
		  Var f As FolderItem = SpecialFolder.Resource("HTML").Child(fileName)
		  
		  Var tin As TextInputStream = TextInputStream.Open(f)
		  html = tin.ReadAll
		  tin.Close
		  Return True
		  
		  Exception e
		    MessageDialog.Show("Unable to find the HTML example file `" + fileName + "`")
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
		    Var e As New InvalidArgumentException
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
