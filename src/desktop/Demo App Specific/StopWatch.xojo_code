#tag Class
Protected Class StopWatch
	#tag Method, Flags = &h0
		Sub Constructor(startImmediately As Boolean = False)
		  If startImmediately Then Start
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4120726561642D6F6E6C792044617465496E74657276616C20726570726573656E74696E672074686520746F74616C20656C61707365642074696D65206D65617375726564206279207468652063757272656E7420696E7374616E63652E
		Function Elapsed() As DateInterval
		  /// A read-only DateInterval representing the total elapsed time measured by
		  /// the current instance.
		  
		  If mStart = Nil Then Return New DateInterval
		  
		  If mIsRunning Then
		    Return DateTime.Now - mStart
		  Else
		    Return mEnd - mStart
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ElapsedAsString() As String
		  /// Returns a string representation of the elapsed interval.
		  
		  Var di As DateInterval = Elapsed
		  
		  If di = Nil Then Return "Nil"
		  
		  Var s As String
		  
		  If di.Years > 0 Then
		    s = di.Years.ToString + " year" + If(di.Years = 1, "", "s") + ", "
		  End If
		  
		  If di.Months > 0 Then
		    s = s + di.Months.ToString + " month" + If(di.Months = 1, "", "s") + ", "
		  End If
		  
		  If di.Days > 0 Then
		    s = s + di.Days.ToString + " day" + If(di.Days = 1, "", "s") + ", "
		  End If
		  
		  If di.Minutes > 0 Then
		    s = s + di.Minutes.ToString + " minute" + If(di.Minutes = 1, "", "s") + ", "
		  End If
		  
		  If di.Seconds > 0 Then
		    s = s + di.Seconds.ToString + " second" + If(di.Seconds = 1, "", "s") + ", "
		  End If
		  
		  If di.Nanoseconds > 0 Then
		    Var ms As Integer = di.Nanoseconds / 1000000
		    s = s + ms.ToString + " ms"
		  End If
		  
		  Return s
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54686520746F74616C20656C61707365642074696D65206D65617375726564206279207468652063757272656E7420696E7374616E63652C20696E206D696C6C697365636F6E64732E
		Function ElapsedMilliseconds() As Integer
		  /// The total elapsed time measured by the current instance, in milliseconds.
		  /// 
		  /// If the stopwatch has been running for > 28 days then an 
		  /// UnsupportedOperationException is raised.
		  
		  Var di As DateInterval = Elapsed
		  
		  // Validate.
		  If di.Months > 0 Or di.Years > 0 Then
		    Raise New _
		    UnsupportedOperationException("The stopwatch has been running too long.")
		  End If
		  
		  Return (di.Days * MS_IN_DAY) + (di.Hours * MS_IN_HOUR) + _
		  (di.Minutes * MS_IN_MIN) + (di.Seconds * MS_IN_SEC) + _
		  (di.Nanoseconds / NS_IN_MS)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54686520746F74616C20656C61707365642074696D65206D65617375726564206279207468652063757272656E7420696E7374616E63652C20696E207469636B732E
		Function ElapsedTicks() As Integer
		  /// The total elapsed time measured by the current instance, in ticks.
		  /// 
		  /// If the stopwatch has been running for > 28 days then an 
		  /// UnsupportedOperationException is raised.
		  
		  Var di As DateInterval = Elapsed
		  
		  // Validate.
		  If di.Months > 0 Or di.Years > 0 Then
		    Raise New _
		    UnsupportedOperationException("The stopwatch has been running too long.")
		  End If
		  
		  Return (di.Days * TICKS_IN_DAY) + (di.Hours * TICKS_IN_HOUR) + _
		  (di.Minutes * TICKS_IN_MIN) + (di.Seconds * TICKS_IN_SEC) + _
		  (di.Nanoseconds / NS_IN_TICK)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657365747320616C6C20696E7465726E616C2070726F706572746965732E
		Sub Reset()
		  /// Resets all internal properties.
		  
		  mIsRunning = False
		  mStart = DateTime.Now
		  mEnd = DateTime.Now
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 426567696E732074696D696E672E
		Sub Start()
		  /// Begins timing.
		  
		  Reset
		  mIsRunning = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 53746F70732074696D696E672E
		Sub Stop()
		  /// Stops timing.
		  
		  mIsRunning = False
		  mEnd = DateTime.Now
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 54727565206966207468652073746F7077617463682069732063757272656E746C792072756E6E696E672E
		#tag Getter
			Get
			  Return mIsRunning
			  
			End Get
		#tag EndGetter
		IsRunning As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mEnd As DateTime
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsRunning As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mStart As DateTime
	#tag EndProperty


	#tag Constant, Name = MS_IN_DAY, Type = Double, Dynamic = False, Default = \"86400000", Scope = Private, Description = 546865206E756D626572206F66206D696C6C697365636F6E647320696E2061206461792E
	#tag EndConstant

	#tag Constant, Name = MS_IN_HOUR, Type = Double, Dynamic = False, Default = \"3.6e+6", Scope = Private, Description = 546865206E756D626572206F66206D696C6C697365636F6E647320696E20616E20686F75722E
	#tag EndConstant

	#tag Constant, Name = MS_IN_MIN, Type = Double, Dynamic = False, Default = \"60000", Scope = Private, Description = 546865206E756D626572206F66206D696C6C697365636F6E647320696E2061206D696E7574652E
	#tag EndConstant

	#tag Constant, Name = MS_IN_SEC, Type = Double, Dynamic = False, Default = \"1000", Scope = Private, Description = 546865206E756D626572206F66206D696C6C697365636F6E647320696E2061207365636F6E642E
	#tag EndConstant

	#tag Constant, Name = MS_IN_WEEK, Type = Double, Dynamic = False, Default = \"604800000", Scope = Private, Description = 546865206E756D626572206F66206D696C6C697365636F6E647320696E2061207765656B2E
	#tag EndConstant

	#tag Constant, Name = NS_IN_MS, Type = Double, Dynamic = False, Default = \"1000000", Scope = Private, Description = 546865206E756D626572206F66206E616E6F7365636F6E647320696E2061206D696C6C697365636F6E642E
	#tag EndConstant

	#tag Constant, Name = NS_IN_TICK, Type = Double, Dynamic = False, Default = \"16666666.67", Scope = Private, Description = 546865206E756D626572206F66206E616E6F7365636F6E647320696E2061207469636B2E
	#tag EndConstant

	#tag Constant, Name = TICKS_IN_DAY, Type = Double, Dynamic = False, Default = \"5184000", Scope = Private, Description = 546865206E756D626572206F66207469636B7320696E2061206461792E
	#tag EndConstant

	#tag Constant, Name = TICKS_IN_HOUR, Type = Double, Dynamic = False, Default = \"216000", Scope = Private, Description = 546865206E756D626572206F66207469636B7320696E20616E20686F75722E
	#tag EndConstant

	#tag Constant, Name = TICKS_IN_MIN, Type = Double, Dynamic = False, Default = \"3600", Scope = Private, Description = 546865206E756D626572206F66207469636B7320696E2061206D696E7574652E
	#tag EndConstant

	#tag Constant, Name = TICKS_IN_SEC, Type = Double, Dynamic = False, Default = \"60", Scope = Private, Description = 546865206E756D626572206F66207469636B7320696E2061207365636F6E642E
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
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
	#tag EndViewBehavior
End Class
#tag EndClass
