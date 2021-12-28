#tag Class
Protected Class MKSoftBreak
Inherits MKBlock
	#tag Method, Flags = &h0
		Sub Constructor(parent As MKBlock, blockStart As Integer)
		  Super.Constructor(MKBlockTypes.SoftBreak, parent, blockStart)
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
