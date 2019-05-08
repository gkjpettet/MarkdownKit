#tag Module
Protected Module MarkdownKit
	#tag Method, Flags = &h1
		Protected Function ToHTML(markdown As Text) As Text
		  // Takes Markdown text as input and returns it as HTML.
		  
		  // Create a new document root block.
		  // This will automatically sanitise the passed Markdown for us.
		  Document = New MarkdownKit.DocumentBlock(markdown)
		  
		  #Pragma Warning "TODO"
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Document As MarkdownKit.DocumentBlock
	#tag EndProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u000D
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			End Set
		#tag EndSetter
		Protected kCR As Text
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u000D + &u000A
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			End Set
		#tag EndSetter
		Protected kCRLF As Text
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  Return &u000A
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  // Read only.
			End Set
		#tag EndSetter
		Protected kLF As Text
	#tag EndComputedProperty


	#tag Constant, Name = kCommonMarkSpecVersion, Type = Text, Dynamic = False, Default = \"0.29", Scope = Protected, Description = 54686520436F6D6D6F6E4D61726B2073706563696669636174696F6E2076657273696F6E2074686174204D61726B646F776E4B697420636F6E666F726D7320746F
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
