#tag Class
Protected Class BetterDictionary
Inherits Dictionary
	#tag Method, Flags = &h1, Description = 52657475726E73205B735D206173206120605465787460206F626A6563742E
		Protected Function AsText(s As String) As Text
		  /// Returns [s] as a `Text` object.
		  
		  Return s.ToText
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732061207368616C6C6F7720636C6F6E65206F6620746869732064696374696F6E617279
		Function Clone() As BetterDictionary
		  /// Returns a shallow clone of this dictionary
		  ///
		  /// Results in a new BetterDictionary that can be manipulated independently.
		  /// A shallow clone means that if a value or key refers to a class instance, 
		  /// its contents are not also cloned.
		  
		  Var bd As New BetterDictionary(mCaseSensitive)
		  
		  For Each entry As DictionaryEntry In Self
		    bd.Value(entry.Key) = entry.Value
		  Next entry
		  
		  Return bd
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  /// This is private to force users of the class to specify case sensitivity.
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(caseSensitive As Boolean, ParamArray entries() As Pair)
		  mCaseSensitive = caseSensitive
		  
		  For Each entry As Pair In entries
		    Self.Value(entry.Left) = entry.Right
		  Next entry
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 54686973206973207072697661746520746F20666F726365207573657273206F662074686520636C61737320746F207370656369667920636173652073656E73697469766974792E
		Private Sub Constructor(ParamArray entries() As Pair)
		  /// This is private to force users of the class to specify case sensitivity.
		  
		  #Pragma Unused entries
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 4465636F6465732074686520706173736564206B65792E
		Protected Function DecodeKey(key As Variant) As Variant
		  /// Decodes [key].
		  
		  If CaseSensitive Then
		    If key.Type = Variant.TypeString Then
		      Return DecodeHex(key)
		    Else
		      Return key
		    End If
		  Else
		    Return key
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 456E636F646573205B6B65795D2069662072657175697265642E
		Protected Function EncodeKey(key As Variant) As Variant
		  /// Encodes [key] if required.
		  ///
		  /// If we're case-sensitive, we encode all "textual" (`String` or `Text`) 
		  /// keys as hex strings. Other key types are left as-is.
		  /// If we're not case-sensitive then we store all textual keys as `Text`.
		  /// We do this so that we can compare the keys that may be `Text` with 
		  /// IDE string literals.
		  
		  If CaseSensitive Then
		    If key.Type = Variant.TypeText Or key.Type = Variant.TypeString Then
		      // Textual keys become hex encoded strings.
		      Return EncodeHex(key)
		    Else
		      // Leave this key alone.
		      Return key
		    End If
		  End If
		  
		  // Not case-sensitive.
		  If key.Type = Variant.TypeString Then
		    Return AsText(key)
		  Else
		    Return key
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5472756520696620746869732064696374696F6E6172792773206B65797320616E642076616C75657320617265206571756976616C656E7420746F205B6F746865725D2E
		Function EquivalentTo(other As BetterDictionary) As Boolean
		  /// True if this dictionary's keys and values are equivalent to [other].
		  
		  If other = Nil Then Return False
		  If Self.KeyCount <> other.KeyCount Then Return False
		  If Self.CaseSensitive <> other.CaseSensitive Then Return False
		  
		  // Compare the keys.
		  For Each entry As DictionaryEntry In Self
		    If Not other.HasKey(entry.Key) Then Return False
		    If entry.Value <> other.Value(entry.Key) Then Return False
		  Next entry
		  
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 54727565206966205B6B65795D20697320696E207468652064696374696F6E6172792E
		Function HasKey(key As Variant) As Boolean
		  /// True if [key] is in the dictionary.
		  
		  If CaseSensitive Then
		    // Keys _may_ be encoded when case sensitive.
		    Return Super.HasKey(EncodeKey(key))
		  Else
		    If key.Type = Variant.TypeString Then
		      // When case insensitive, `String` keys are stored as `Text`.
		      Return Super.HasKey(AsText(key))
		    Else
		      Return Super.HasKey(key)
		    End If
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Iterator() As Iterator
		  Return New BetterDictionaryIterator(Self)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73207468652076616C7565206F66205B6B65795D20666F7220746865205B696E6465785D74682073657175656E7469616C206974656D20696E20746869732044696374696F6E6172792E
		Function Key(index As Integer) As Variant
		  /// Returns the value of [key] for the [index]th sequential item in this 
		  /// Dictionary.
		  ///
		  /// The first item is numbered zero.
		  /// If there is no [index]th item in the dictionary, an `OutOfBoundsException`
		  /// is raised.
		  
		  If CaseSensitive Then
		    // We need to decode the key first.
		    Var encodedKey As Variant = Super.Key(index)
		    Return DecodeKey(encodedKey)
		  Else
		    Return Super.Key(index)
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320616C6C20746865206B65797320696E20746869732064696374696F6E61727920617320616E206172726179206F662056617269616E74732E
		Function Keys() As Variant()
		  /// Returns all the keys in this dictionary as an array of Variants.
		  
		  Var result() As Variant
		  
		  If CaseSensitive Then
		    // Keys need to be decoded as textual keys are hex encoded.
		    Var encodedKeys() as Variant = Super.Keys()
		    For Each encodedKey As Variant In encodedKeys
		      result.Add(DecodeKey(encodedKey))
		    Next encodedKey
		  Else
		    result = Super.Keys
		  End If
		  
		  Return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 4C6F6F6B7320757020746865207061737365642076616C7565206F66205B6B65795D2E
		Function Lookup(key As Variant, defaultValue As Variant) As Variant
		  /// Looks up the passed value of [key].
		  
		  If CaseSensitive Then
		    // When case sensitive, keys _may_ be encoded.
		    Return Super.Lookup(EncodeKey(key), defaultValue)
		  Else
		    // When case insensitive, `String` keys are stored as `Text`.
		    If key.Type = Variant.TypeString Then
		      Return Super.Lookup(AsText(key), defaultValue)
		    Else
		      Return Super.Lookup(key, defaultValue)
		    End If
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526574726965766573207468652076616C7565206173736F6369617465642077697468205B6B65795D20636F6E76657274656420746F206054657874602E
		Function TextValue(key As Variant) As Text
		  /// Retrieves the value associated with [key] converted to `Text`.
		  ///
		  /// Will fail if the value associated with [key] cannot be 
		  /// converted to `Text`.
		  
		  Var modifiedKey As Variant
		  
		  If CaseSensitive Then
		    // We may need to encode this key.
		    modifiedKey = EncodeKey(key)
		  Else
		    If key.Type = Variant.TypeString Then
		      // We store `String` keys as `Text`.
		      modifiedKey = AsText(key)
		    Else
		      modifiedKey = key
		    End If
		  End If
		  
		  Var v As Variant = Super.Value(modifiedKey)
		  If v.Type = Variant.TypeText Then
		    Return v
		  Else
		    Return v.StringValue.ToText
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526574726965766573207468652076616C7565206173736F6369617465642077697468205B6B65795D2E
		Function Value(key As Variant) As Variant
		  /// Retrieves the value associated with [key].
		  
		  If CaseSensitive Then
		    // We _may_ need to encode the key.
		    Return Super.Value(EncodeKey(key))
		  Else
		    // We store `String` keys as `Text`.
		    If key.Type = Variant.TypeString Then
		      Return Super.Value(AsText(key))
		    Else
		      Return Super.Value(key)
		    End If
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 41737369676E7320612076616C756520746F20746865205B6B65795D206974656D20696E207468652064696374696F6E6172792E
		Sub Value(key As Variant, Assigns v As Variant)
		  /// Assigns a value to the [key] item in the dictionary.
		  
		  If CaseSensitive Then
		    // We _may_ need to encode the key.
		    Super.Value(EncodeKey(key)) = v
		  Else
		    // We don't store `String` keys, only `Text`.
		    If key.Type = Variant.TypeString Then
		      Super.Value(AsText(key)) = v
		    Else
		      Super.Value(key) = v
		    End If
		  End If
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mCaseSensitive
			  
			End Get
		#tag EndGetter
		CaseSensitive As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mCaseSensitive As Boolean = False
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="BinCount"
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
		#tag ViewProperty
			Name="KeyCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="CaseSensitive"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
