#tag Class
Protected Class MKTextBlock
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, absoluteStart As Integer, localStart As Integer, contents As String, phantomSpaces As Integer, line As TextLine)
		  Super.Constructor(MKBlockTypes.TextBlock, parent, absoluteStart)
		  Self.LocalStart = localStart
		  Self.Contents = contents
		  Self.PhantomSpaces = phantomSpaces
		  Self.Line = line
		  Self.LineNumber = line.Number
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520636F6E74656E7473206F662074686973207465787420626C6F636B2E
		Contents As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 547275652069662074686973207465787420626C6F636B20697320656D7074792E
		#tag Getter
			Get
			  Return Self.Contents = ""
			End Get
		#tag EndGetter
		IsBlank As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 546865206C696E652074686973207465787420626C6F636B20626567696E73206F6E2E
		Line As TextLine
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D6261736564206C6F63616C20706F736974696F6E206F6E20746865206C696E6520746861742074686973207465787420626C6F636B207374617274732E
		LocalStart As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F662073706163657320746F20626520696E73657274656420617420746865207374617274206F662074686973207465787420626C6F636B207468617420646F6E27742061637475616C6C7920657869737420696E2074686520736F75726365206275742061726520726571756972656420666F7220436F6D6D6F6E4D61726B20636F6D706C69616E63652E
		PhantomSpaces As Integer = 0
	#tag EndProperty


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
			Name="IsBlank"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Contents"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PhantomSpaces"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
