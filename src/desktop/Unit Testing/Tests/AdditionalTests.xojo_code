#tag Class
Protected Class AdditionalTests
Inherits TestGroup
	#tag Event
		Sub Setup()
		  mParser = New MarkdownKit.MKParser
		  mRenderer = New MarkdownKit.MKHTMLRenderer
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(err As RuntimeException, methodName As String) As Boolean
		  #pragma unused err
		  
		  Const kMethodName As Text = "UnhandledException"
		  
		  If methodName.Length >= kMethodName.Length And methodName.Left(kMethodName.Length) = kMethodName Then
		    Assert.Pass("Exception was handled")
		    Return True
		  End If
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Example1Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example2Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example3Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example4Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example5Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example6Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example7Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example8Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example9Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example10Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example11Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example12Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example13Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example14Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example15Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example16Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example17Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example18Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example19Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example20Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example21Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example22Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example23Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example24Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example25Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example26Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example27Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example28Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example29Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example30Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506F70756C61746573205B6D61726B646F776E5D20776974682074686520636F6E74656E7473206F66207468652066696C6520604170705265736F75726365732F696E7075742F5B66696C654E616D655D2E2052657475726E732046616C736520696620616E206572726F72206F63637572732E
		Private Function GetTestInput(fileName As String, ByRef markdown As String) As Boolean
		  /// Populates [markdown] with the contents of the file `AppResources/input-additional/[fileName]. 
		  /// Returns False if an error occurs.
		  
		  #Pragma BreakOnExceptions False
		  
		  Try
		    Var f As FolderItem = SpecialFolder.Resource("input-additional").Child(fileName)
		    Var tin As TextInputStream = TextInputStream.Open(f)
		    markdown = tin.ReadAll
		    tin.Close
		    Return True
		  Catch e
		    Return False
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506F70756C61746573205B6D61726B646F776E5D20776974682074686520636F6E74656E7473206F66207468652066696C6520604170705265736F75726365732F6F75747075742F5B66696C654E616D655D2E2052657475726E732046616C736520696620616E206572726F72206F63637572732E
		Private Function GetTestOutput(fileName As String, ByRef markdown As String) As Boolean
		  /// Populates [markdown] with the contents of the file `AppResources/output-additional/[fileName]. 
		  /// Returns False if an error occurs.
		  
		  #Pragma BreakOnExceptions False
		  
		  Try
		    Var f As FolderItem = SpecialFolder.Resource("output-additional").Child(fileName)
		    Var tin As TextInputStream = TextInputStream.Open(f)
		    markdown = tin.ReadAll
		    tin.Close
		    Return True
		  Catch e
		    Return False
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52756E7320616E2048544D4C2074657374206E616D6564205B6D6574686F644E616D655D2E
		Sub Run(methodName As String)
		  /// Runs an HTML test named [methodName].
		  
		  Var testNumber As Integer = Integer.FromString(methodName.Replace("AdditionalTests.Example", "").Replace("Test", ""))
		  
		  // Get the names of the files containing the input Markdown and the expected HTML output.
		  Var inputFileName As String = testNumber.ToString + ".md"
		  Var expectedOutputName As String = testNumber.ToString + ".html"
		  
		  // Get the input Markdown file.
		  Var input As String
		  If Not GetTestInput(inputFileName, input) Then
		    Assert.Fail("Unable to load test Markdown file `" + inputFileName + "`")
		    Return
		  End If
		  
		  // Get the expected HTML output.
		  Var expected As String
		  If Not GetTestOutput(expectedOutputName, expected) Then
		    Assert.Fail("Unable to load test HTML file `" + expectedOutputName + "`")
		    Return
		  End If
		  
		  // Convert the input Markdown to HTML.
		  Var doc As MarkdownKit.MKDocument = mParser.ParseSource(input)
		  doc.TestNumber = testNumber
		  Var actual As String = mRenderer.VisitDocument(doc)
		  
		  // Transform whitespace in our result and the expected truth to make it easier to visualise.
		  TransformWhitespace(actual)
		  TransformWhitespace(expected)
		  
		  // Removing leading / trailing whitespace.
		  actual = actual.Trim
		  
		  // Check the result matches the truth.
		  Assert.AreEqualCustom(input, expected, actual)
		  
		  Exception e
		    Assert.FailCustom(input, expected, "Exception occurred!")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5265706C616365732073706163657320616E6420746162732077697468696E205B735D20776974682076697369626C6520636861726163746572732E
		Private Sub TransformWhitespace(ByRef s As String)
		  /// Replaces spaces and tabs within [s] with visible characters.
		  
		  s = s.ReplaceAll(&u0020, "•")
		  s = s.ReplaceAll(&u0009, "→")
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mParser As MarkdownKit.MKParser
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mRenderer As MarkdownKit.MKHTMLRenderer
	#tag EndProperty


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
			Name="TestCount"
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
