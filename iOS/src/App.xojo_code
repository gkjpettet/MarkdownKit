#tag Class
Protected Class App
Inherits IOSApplication
	#tag CompatibilityFlags = TargetIOS
	#tag Event
		Function Open(launchOptionsHandle as Ptr) As Boolean
		  Dim md As Text = "This **is** cool `code`!"
		  Dim html As Text = MarkdownKit.ToHTML(md)
		  Break
		End Function
	#tag EndEvent


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
