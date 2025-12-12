#tag Class
Protected Class TextLine
	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(lineNumber As Integer, start As Integer, contents As String)
		  Self.Number = lineNumber
		  Self.Start = start
		  Self.Value = contents
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520696E646976696475616C2063686172616374657273206F6E2074686973206C696E652E20446F6573206E6F7420696E636C756465206E65776C696E6520636861726163746572732E2053686F756C6420626520636F6E7369646572656420726561642D6F6E6C792E
		Characters() As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 54686520302D626173656420696E64657820696E2074686520696E697469616C2074657874206F662074686520656E64206F662074686973206C696E652E
		#tag Getter
			Get
			  Return Start + Length
			End Get
		#tag EndGetter
		Finish As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 547275652069662074686973206C696E6520697320636F6E7369646572656420626C616E6B2028656D707479206F7220636F6E7461696E73206F6E6C7920737061636573206F7220686F72697A6F6E74616C2074616273292E
		#tag Getter
			Get
			  #Pragma NilObjectChecking False
			  #Pragma StackOverflowChecking False
			  #Pragma DisableBoundsChecking

			  // Return cached value if available
			  If mIsBlankCached Then Return mIsBlank

			  If IsEmpty Then
			    mIsBlank = True
			    mIsBlankCached = True
			    Return True
			  End If

			  Var iLimit As Integer = Characters.LastIndex
			  Var c As String
			  For i As Integer = 0 To iLimit
			    c = Characters(i)
			    // Fix: Use And instead of Or - a line is only blank if ALL chars are whitespace
			    If c <> &u0020 And c <> &u0009 Then
			      mIsBlank = False
			      mIsBlankCached = True
			      Return False
			    End If
			  Next i

			  mIsBlank = True
			  mIsBlankCached = True
			  Return True

			End Get
		#tag EndGetter
		IsBlank As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5472756520696620746865206C696E652073686F756C6420626520636F6E7369646572656420646972747920616E64206E6565647320726564726177696E672E
		IsDirty As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 54727565206966207468697320697320616E20656D707479206C696E652E
		#tag Getter
			Get
			  Return Length = 0
			End Get
		#tag EndGetter
		IsEmpty As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F662063686172616374657273206F6E2074686973206C696E652E
		#tag Getter
			Get
			  Return Characters.Count
			End Get
		#tag EndGetter
		Length As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1, Description = 4261636B696E67206669656C64207768696368206973206120737472696E6720636F6E636174656E6174696F6E206F6620746865206043686172616374657273602061727261792E
		Protected mContents As String
	#tag EndProperty

	#tag Property, Flags = &h1, Description = 4361636865642076616C756520666F72204973426C616E6B20636F6D707574656420706F70657274792E
		Protected mIsBlank As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h1, Description = 5472756520696620746865204973426C616E6B2076616C756520686173206265656E20636163686564
		Protected mIsBlankCached As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520312D6261736564206C696E65206E756D6265722E
		Number As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520302D626173656420696E6465782077697468696E2074686520696E697469616C2074657874206F662074686520666972737420636861726163746572206F6E2074686973206C696E652E
		Start As Integer = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865206C696E65277320636F6E74656E7473206173206120737472696E672E
		#tag Getter
			Get
			  Return mContents
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Characters = value.CharacterArray
			  mContents = value
			End Set
		#tag EndSetter
		Value As String
	#tag EndComputedProperty


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
			Name="Number"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Start"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Finish"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Length"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsEmpty"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
