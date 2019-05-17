#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyTests
					AppliesTo = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vdGVzdHMvcGhhc2UxLzMyLXBoYXNlMS5hc3Q=
					FolderItem = Li4vLi4vdGVzdHMvcGhhc2UxLzMyLm1k
					FolderItem = Li4vLi4vdGVzdHMvcGhhc2UxLzMzLXBoYXNlMS5hc3Q=
					FolderItem = Li4vLi4vdGVzdHMvcGhhc2UxLzMzLm1k
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
