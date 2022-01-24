#tag Class
Protected Class MKATXHeadingBlock
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStart As Integer = 0)
		  Super.Constructor(MKBlockTypes.AtxHeading, parent, blockStart)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436C6F736573207468697320626C6F636B20616E64206D616B657320616E792066696E616C206368616E6765732074686174206D61792062652072657175697265642E
		Sub Finalise(line As TextLine)
		  /// Closes this block and makes any final changes that may be required.
		  
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  // Get the characters of the title from this line, minus the opening and (optional) closing sequences.
		  Var s As String
		  If HasClosingSequence Then
		    s = line.Value.MiddleCharacters(Self.Start - line.Start + OpeningSequenceLength, _
		    ClosingSequenceAbsoluteStart - line.Start - OpeningSequenceLength)
		  Else
		    s = line.Value.MiddleCharacters(Self.Start - line.Start + OpeningSequenceLength)
		  End If
		  
		  // Compute the characters that make up this heading's title. This is required for later inline parsing.
		  Var tmp() as MKCharacter = s.MKCharacters(line, Self.Start - line.Start + OpeningSequenceLength)
		  For Each character As MKCharacter In tmp
		    Characters.Add(character)
		  Next character
		  Characters.Add(MKCharacter.CreateLineEnding(line))
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520302D626173656420696E64657820696E20746865206F726967696E616C20736F75726365206F662074686520666972737420636861726163746572206F6620746865206F7074696F6E616C20636C6F73696E672073657175656E6365206F66206023602063686172616374657273206F7220602D3160206966207468657265206973206E6F20636C6F73696E672073657175656E63652E
		ClosingSequenceAbsoluteStart As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F6620602360206368617261637465727320696E20746865206F7074696F6E616C20636C6F73696E672073657175656E63652E204D6179206265206030602E
		ClosingSequenceCount As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C6F63616C20302D626173656420696E646578206F6E20746865206C696E65206F662074686520666972737420636861726163746572206F6620746865206F7074696F6E616C20636C6F73696E672073657175656E6365206F66206023602063686172616374657273206F7220602D3160206966207468657265206973206E6F20636C6F73696E672073657175656E63652E
		ClosingSequenceLocalStart As Integer = -1
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 547275652069662074686973204154582068656164657220686164206F7074696F6E616C20636C6F73696E672060236020636861726163746572732E
		#tag Getter
			Get
			  Return ClosingSequenceCount > 0
			End Get
		#tag EndGetter
		HasClosingSequence As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0, Description = 5468697320415458206865616465722773206C6576656C2E
		Level As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D6261736564206162736F6C75746520706F736974696F6E20696E20746865206F726967696E616C20736F7572636520746861742074686520415458206F70656E696E672073657175656E6365207374617274732061742E
		OpeningSequenceAbsoluteStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F66206368617261637465727320636F6D70726973696E6720746865206F70656E696E672073657175656E63652028696E636C75646573207768697465737061636520616674657220746865206023602063686172616374657273292E
		OpeningSequenceLength As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 302D6261736564206C6F63616C20706F736974696F6E206F6E20746865206C696E6520746861742074686520415458206F70656E696E672073657175656E6365207374617274732061742E
		OpeningSequenceLocalStart As Integer = 0
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
			Name="ClosingSequenceAbsoluteStart"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClosingSequenceCount"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ClosingSequenceLocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasClosingSequence"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Level"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpeningSequenceAbsoluteStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpeningSequenceLength"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="OpeningSequenceLocalStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
