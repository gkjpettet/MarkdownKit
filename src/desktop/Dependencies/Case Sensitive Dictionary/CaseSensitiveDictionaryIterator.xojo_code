#tag Class
Protected Class CaseSensitiveDictionaryIterator
Implements Iterator
	#tag Method, Flags = &h0
		Sub Constructor(owner As Dictionary)
		  mOwner = owner
		  
		  mKeys = mOwner.Keys
		  mKeysLastIndex = mKeys.LastIndex
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MoveNext() As Boolean
		  /// Part of the Iterator interface.
		  
		  Return mCurrent <= mKeysLastIndex
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value() As Variant
		  /// Part of the Iterator interface.
		  
		  mCurrent = mCurrent + 1
		  
		  Var entry As New DictionaryEntry
		  entry.Key = mKeys(mCurrent - 1)
		  entry.Value = mOwner.Value(entry.Key)
		  
		  Return entry
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCurrent As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeys() As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mKeysLastIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mOwner As Dictionary
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
	#tag EndViewBehavior
End Class
#tag EndClass
