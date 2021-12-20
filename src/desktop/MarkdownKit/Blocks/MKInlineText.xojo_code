#tag Class
Protected Class MKInlineText
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock)
		  Super.Constructor(MKBlockTypes.InlineText, parent, 0)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Finalise(line As TextLine = Nil)
		  // Calling the overridden superclass method.
		  Super.Finalise(line)
		  
		  Var iLimit As Integer = EndPosition - Parent.Start
		  For i As Integer = LocalStart To iLimit
		    Var c As MKCharacter = Parent.Characters(i)
		    If c.IsLineEnding Then
		      Raise New MKException("Unexpected line ending in inline text.")
		    Else
		      Characters.Add(c)
		    End If
		  Next i
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 546865206C6F63616C20302D626173656420696E64657820696E2060506172656E742E43686172616374657273602074686174207468697320696E6C696E652074657874207370616E20626567696E732061742E
		LocalStart As Integer = 0
	#tag EndProperty


End Class
#tag EndClass
