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
					FolderItem = Li4vLi4vLi4vYWRkaXRpb25hbCUyMHRlc3RzL2lucHV0LWFkZGl0aW9uYWwv
					FolderItem = Li4vLi4vLi4vYWRkaXRpb25hbCUyMHRlc3RzL291dHB1dC1hZGRpdGlvbmFsLw==
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
