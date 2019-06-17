#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyPhase1ASTs
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vdGVzdHMvcGhhc2UlMjAxJTIwQVNUcy8=
				End
				Begin CopyFilesBuildStep CopyPhase2ASTs
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vdGVzdHMvcGhhc2UlMjAyJTIwQVNUcy8=
				End
				Begin CopyFilesBuildStep CopyTestMarkdownSource
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vdGVzdHMvc291cmNlJTIwbWFya2Rvd24v
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
