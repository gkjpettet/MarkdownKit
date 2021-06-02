#tag Class
Protected Class Assert
	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub AreDifferent(expected As String, actual As String, message As String = "")
		  If expected.Encoding <> actual.Encoding Or _
		    expected.Compare(actual, ComparisonOptions.CaseInsensitive) <> 0 Then
		    Pass()
		  Else
		    Fail("String '" + actual + "' is the same", message )
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub AreEqual(expected As String, actual As String, message As String = "")
		  // This is a case-insensitive comparison
		  
		  If expected = actual Then
		    Pass()
		  Else
		    Fail(FailEqualMessage(expected, actual), message )
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub AreEqualCustom(expected As String, actual As String, message As String = "")
		  // This is a case-insensitive comparison
		  
		  If expected = actual Then
		    PassCustom(expected, actual)
		  Else
		    Fail(FailEqualMessage(expected, actual), message )
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub AreNotEqual(expected As String, actual As String, message As String = "")
		  //NCM-written
		  If expected <> actual Then
		    Pass()
		  Else
		    Fail("The Strings '" + actual + " are equal but shouldn't be", message)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Destructor()
		  Group = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub DoesNotMatch(regExPattern As String, actual As String, message As String = "")
		  If regExPattern = "" Then
		    Var err As New RegExException
		    err.Reason = "No pattern was specified"
		    Raise err
		  End If
		  
		  Var rx As New RegEx
		  rx.SearchPattern = regExPattern
		  
		  If rx.Search(actual) Is Nil Then
		    Pass()
		  Else
		    Fail("[" + actual + "]  matches the pattern /" + regExPattern + "/", message)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fail(failMessage As String, message As String = "")
		  Failed = True
		  Group.CurrentTestResult.Result = TestResult.Failed
		  
		  Message(message + ": " + failMessage)
		  
		  If Group.StopTestOnFail Then
		    #Pragma BreakOnExceptions False
		    Raise New XojoUnitTestFailedException
		    #Pragma BreakOnExceptions Default
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FailCustom(expected As String, actual As String)
		  Failed = True
		  Group.CurrentTestResult.Result = TestResult.Failed
		  
		  Group.CurrentTestResult.Expected = expected
		  Group.CurrentTestResult.Actual = actual
		  
		  If Group.StopTestOnFail Then
		    #Pragma BreakOnExceptions False
		    Raise New XojoUnitTestFailedException
		    #Pragma BreakOnExceptions Default
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FailEqualMessage(expected As String, actual As String) As String
		  Var message As String
		  
		  message = "Expected:" + EndOfLine + _
		  expected + EndOfLine + EndOfLine + _
		  "Actual:" + EndOfLine + actual
		  
		  Return message
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsFalse(condition As Boolean, message As Text = "")
		  If condition Then
		    Fail("[false] expected, but was [true].", message)
		  Else
		    Pass()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsNil(anObject As Object, message As Text = "")
		  If anObject = Nil Then
		    Pass()
		  Else
		    Fail("Object was expected to be [nil], but was not.", message)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsNotNil(anObject As Object, message As Text = "")
		  If anObject <> Nil Then
		    Pass()
		  Else
		    Fail("Expected value not to be [nil], but was [nil].", message)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsTrue(condition As Boolean, message As Text = "")
		  If condition Then
		    Pass()
		  Else
		    Fail("[true] expected, but was [false].", message)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub Matches(regExPattern As String, actual As String, message As String = "")
		  If regExPattern = "" Then
		    Var err As New RegExException
		    err.Reason = "No pattern was specified"
		    Raise err
		  End If
		  
		  Var rx As New RegEx
		  rx.SearchPattern = regExPattern
		  
		  If rx.Search(actual) Is Nil Then
		    Fail("[" + actual + "]  does not match the pattern /" + regExPattern + "/", message)
		  Else
		    Pass()
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Message(msg As String)
		  msg = msg.Trim
		  If msg = "" Then
		    Return
		  End If
		  
		  If Group.CurrentTestResult.Message.IsEmpty Then
		    Group.CurrentTestResult.Message = msg
		  Else
		    Group.CurrentTestResult.Message = Group.CurrentTestResult.Message + &u0A + msg
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Pass(message As String = "")
		  Failed = False
		  If Group.CurrentTestResult.Result <> TestResult.Failed Then
		    Group.CurrentTestResult.Result = TestResult.Passed
		    Message(message)
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PassCustom(expected As String, actual As String)
		  Failed = False
		  If Group.CurrentTestResult.Result <> TestResult.Failed Then
		    Group.CurrentTestResult.Result = TestResult.Passed
		    Group.CurrentTestResult.Actual = actual
		    Group.CurrentTestResult.Expected = expected
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Failed As Boolean
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mGroupWeakRef Is Nil Then
			    Return Nil
			  Else
			    Return TestGroup(mGroupWeakRef.Value)
			  End If
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  If value Is Nil Then
			    mGroupWeakRef = Nil
			  Else
			    mGroupWeakRef = New WeakRef(value)
			  End If
			End Set
		#tag EndSetter
		Group As TestGroup
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mGroupWeakRef As WeakRef
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Failed"
			Visible=false
			Group="Behavior"
			InitialValue=""
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
