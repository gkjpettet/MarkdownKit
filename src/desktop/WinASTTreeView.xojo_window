#tag DesktopWindow
Begin DesktopWindow WinASTTreeView
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   616
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   459241471
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "Markdown -> AST TreeView"
   Type            =   0
   Visible         =   True
   Width           =   1060
   Begin BetterTextArea Source
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      Height          =   544
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   2
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   0
      ValidationMask  =   ""
      Visible         =   True
      Width           =   570
   End
   Begin DesktopButton ButtonParse
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Parse"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   960
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   576
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopTreeView ASTTreeView
      AutoDeactivate  =   True
      BackColor       =   &cFFFFFF00
      ColumnCount     =   1
      DarkBackColor   =   &c2D2D2D00
      DarkNodeTextColor=   &cFFFFFF00
      DragReceiveBehavior=   1
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      HasBackColor    =   False
      HasBorder       =   True
      HasHeader       =   False
      HasInactiveSelectionColor=   False
      HasNodeColor    =   False
      HasNodeTextColor=   False
      HasSelectionColor=   False
      Height          =   544
      InactiveSelectionColor=   &cD3D3D300
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   602
      LinuxDrawTreeLines=   False
      LinuxExpanderStyle=   0
      LinuxHighlightFullRow=   True
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MacDrawTreeLines=   False
      MacExpanderStyle=   0
      MacHighlightFullRow=   True
      MultiSelection  =   False
      NodeEvenColor   =   &cFFFFFF00
      NodeHeight      =   18
      NodeOddColor    =   &cFFFFFF00
      NodeTextColor   =   &c00000000
      QuartzShading   =   False
      Scope           =   0
      SelectionColor  =   &c478A1A00
      SelectionSeparator=   0
      SystemNodeColors=   True
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      UseFocusRing    =   True
      Visible         =   True
      Width           =   438
      WinDrawTreeLines=   True
      WinHighlightFullRow=   False
   End
   Begin DesktopLabel Info
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   576
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   570
   End
   Begin Timer InfoTimer
      Enabled         =   True
      Index           =   -2147483648
      LockedInPosition=   False
      Period          =   250
      RunMode         =   2
      Scope           =   0
      TabPanelIndex   =   0
   End
   Begin DesktopLabel Time
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   719
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   576
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   229
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Constant, Name = SAMPLE_MARKDOWN, Type = String, Dynamic = False, Default = \"### Hello World\nThis is some text.\n\nAnother paragraph.", Scope = Public
	#tag EndConstant


#tag EndWindowCode

#tag Events ButtonParse
	#tag Event
		Sub Pressed()
		  Var parser As New MKParser
		  
		  Var watch As New StopWatch(True)
		  Var doc As MKDocument = parser.ParseSource(Source.Text)
		  watch.stop
		  Var parseTime As Integer = watch.ElapsedMilliseconds
		  
		  Var printer As New ASTTreeViewRenderer
		  ASTTreeView.RemoveAllNodes
		  watch.Start
		  Var node As TreeViewNode = printer.VisitDocument(doc)
		  ASTTreeView.AppendNode(node)
		  watch.Stop
		  Var renderTime As Integer = watch.ElapsedMilliseconds
		  
		  // Expand the document node.
		  ASTTreeView.SelectedIndex = 0
		  ASTTreeView.SelectedNode.SetExpanded(True, True)
		  
		  Time.Text = "Parsed in " + parseTime.ToString + " ms, rendered in " + renderTime.ToString + " ms" 
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events InfoTimer
	#tag Event
		Sub Action()
		  Info.Text = "Pos: " + Source.SelectionStart.ToString
		End Sub
	#tag EndEvent
#tag EndEvents
