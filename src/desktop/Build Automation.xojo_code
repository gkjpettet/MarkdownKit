#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyTestFilesMac
					AppliesTo = 0
					Architecture = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vLi4vdGVzdHMvb3V0cHV0Lw==
					FolderItem = Li4vLi4vLi4vdGVzdHMvaW5wdXQv
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
