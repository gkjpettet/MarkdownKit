#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList iOS
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyAssets
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vLi4vdGVzdHMvSFRNTC8=
					FolderItem = Li4vLi4vLi4vdGVzdHMvc291cmNlJTIwbWFya2Rvd24v
				End
				Begin SignProjectStep Sign
				End
			End
#tag EndBuildAutomation
