#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyTestMarkdownSource
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vdGVzdHMvc291cmNlJTIwbWFya2Rvd24v
				End
				Begin CopyFilesBuildStep CopyASTs
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vdGVzdHMvQVNUcy8=
				End
				Begin CopyFilesBuildStep CopyHTML
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vdGVzdHMvSFRNTC8=
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
