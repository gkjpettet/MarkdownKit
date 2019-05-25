#tag Class
Protected Class Document
Inherits MarkdownKit.Block
	#tag Method, Flags = &h0
		Sub Constructor(source As Text)
		  Self.Type = MarkdownKit.BlockType.Document
		  
		  // Document Blocks act as the root of the block tree. They don't have parents.
		  Self.Parent = Nil
		  
		  // Make sure that the MarkdownKit module has been initialised.
		  MarkdownKit.Initialise
		  
		  // Standardise the line endings in the passed Markdown to line feeds.
		  source = ReplaceLineEndings(source, &u000A)
		  
		  // Replace insecure characters (spec 0.29 2.3).
		  source = source.ReplaceAll(&u0000, &uFFFD)
		  
		  // Split the source into lines of Text.
		  Dim tmp() As Text = source.Split(&u000A)
		  
		  // Convert each line of text in the temporary array to a LineInfo object.
		  Dim tmpUbound As Integer = tmp.Ubound
		  Dim i As Integer
		  For i = 0 To tmpUbound
		    Lines.Append(New MarkdownKit.LineInfo(tmp(i), i + 1))
		  Next i
		  
		  // Remove contiguous blank lines at the beginning and end of the array.
		  // As blank lines at the beginning and end of the document 
		  // are ignored (commonmark spec 0.29 4.9).
		  // Leading...
		  While Lines.Ubound > -1
		    If Lines(0).IsBlank Then
		      Lines.Remove(0)
		    Else
		      Exit
		    End If
		  Wend
		  // Trailing...
		  For i = Lines.Ubound DownTo 0
		    If Lines(i).IsBlank Then
		      Lines.Remove(i)
		    Else
		      Exit
		    End If
		  Next i
		  
		  // Cache the upper bounds of the Lines array.
		  LinesUbound = Lines.Ubound
		  
		  // The document block starts open.
		  IsOpen = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ParseBlockStructure()
		  // Process each line to determine the overall block structure of this 
		  // Markdown document.
		  
		  Dim currentBlock As MarkdownKit.Block = Self
		  
		  For i As Integer = 0 To LinesUbound
		    
		    ProcessLine(Lines(i), currentBlock)
		    
		  Next i
		  
		  // Finalise all blocks in the tree.
		  While currentBlock <> Nil
		    currentBlock.Finalise
		    currentBlock = currentBlock.Parent
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ProcessLine(line As MarkdownKit.LineInfo, ByRef currentBlock As MarkdownKit.Block)
		  // Takes a line of source Markdown and incorporates it into the document tree.
		  // currentBlock: The Block that most recently has had lines added to it.
		  //               Will be modified by the method.
		  
		  // Always start processing at the document root.
		  Dim container As MarkdownKit.Block = Self
		  
		  TryOpenBlocks(line, container)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ReplaceLineEndings(t As Text, what As Text) As Text
		  // Normalize the line endings first.
		  t = t.ReplaceAll(&u000D + &u000A, &u000A)
		  t = t.ReplaceAll(&u000D, &u000A)
		  
		  // Now replace them.
		  t = t.ReplaceAll(&u000A, what)
		  
		  Return t
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TryOpenBlocks(line As MarkdownKit.LineInfo, ByRef container As MarkdownKit.Block)
		  // This is step 1 in determining the document bloxk structure.
		  // Iterate through open blocks and descend through the last children 
		  // down to the last open block. For each open Block, check to see if 
		  // this line meets the required condition to keep the block open.
		  // `container`: This will be set to the Block which last had a match to the line.
		  
		  Dim indent As Integer
		  Dim blank As Boolean
		  Dim allMatched As Boolean = True
		  
		  While container.LastChild <> Nil And container.LastChild.IsOpen
		    
		    container = container.LastChild
		    
		    line.FindFirstNonWhitespace
		    
		    indent = line.FirstNWSColumn - line.Column + line.RemainingSpaces
		    
		    blank = If(line.CurrentChar = "", True, False)
		    
		    Select Case container.Type
		    Case MarkdownKit.BlockType.BlockQuote
		      If indent <= 3 And line.CurrentChar= ">" Then
		        line.AdvanceOffset(indent + 1, True)
		        Call line.AdvanceOptionalSpace
		      Else
		        allMatched = False
		      End If
		      
		    End Select
		  Wend
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Lines() As MarkdownKit.LineInfo
	#tag EndProperty

	#tag Property, Flags = &h21
		Private LinesUbound As Integer = -1
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="IsOpen"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
		#tag EndViewProperty
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
End Class
#tag EndClass
