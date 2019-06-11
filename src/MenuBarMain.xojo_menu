#tag Menu
Begin Menu MenuBarMain
   Begin MenuItem FileMenu
      SpecialMenu = 0
      Text = "&File"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem FileRunTests
         SpecialMenu = 0
         Text = "&Run Tests"
         Index = -2147483648
         ShortcutKey = "R"
         Shortcut = "Cmd+R"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
      Begin QuitMenuItem FileQuit
         SpecialMenu = 0
         Text = "#App.kFileQuit"
         Index = -2147483648
         ShortcutKey = "#App.kFileQuitShortcut"
         Shortcut = "#App.kFileQuitShortcut"
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem EditMenu
      SpecialMenu = 0
      Text = "&Edit"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem EditUndo
         SpecialMenu = 0
         Text = "&Undo"
         Index = -2147483648
         ShortcutKey = "Z"
         Shortcut = "Cmd+Z"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem UntitledMenu1
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditCut
         SpecialMenu = 0
         Text = "Cu&t"
         Index = -2147483648
         ShortcutKey = "X"
         Shortcut = "Cmd+X"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditCopy
         SpecialMenu = 0
         Text = "&Copy"
         Index = -2147483648
         ShortcutKey = "C"
         Shortcut = "Cmd+C"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditPaste
         SpecialMenu = 0
         Text = "&Paste"
         Index = -2147483648
         ShortcutKey = "V"
         Shortcut = "Cmd+V"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditClear
         SpecialMenu = 0
         Text = "#App.kEditClear"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem UntitledMenu0
         SpecialMenu = 0
         Text = "-"
         Index = -2147483648
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditSelectAllGroups
         SpecialMenu = 0
         Text = "Select &All Groups"
         Index = -2147483648
         ShortcutKey = "A"
         Shortcut = "Cmd+A"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem EditUnselectAllGroups
         SpecialMenu = 0
         Text = "Unselect All Groups"
         Index = -2147483648
         ShortcutKey = "-"
         Shortcut = "Cmd+-"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
   End
   Begin MenuItem ParserMenu
      SpecialMenu = 0
      Text = "Parser"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem ParserParse
         SpecialMenu = 0
         Text = "Parse"
         Index = -2147483648
         ShortcutKey = "Y"
         Shortcut = "Cmd+Y"
         MenuModifier = True
         AutoEnable = False
         Visible = True
      End
   End
   Begin MenuItem WindowMenu
      SpecialMenu = 0
      Text = "Window"
      Index = -2147483648
      AutoEnable = True
      Visible = True
      Begin MenuItem WindowEditor
         SpecialMenu = 0
         Text = "Editor"
         Index = -2147483648
         ShortcutKey = "1"
         Shortcut = "Cmd+1"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
      Begin MenuItem WindowTests
         SpecialMenu = 0
         Text = "Tests"
         Index = -2147483648
         ShortcutKey = "2"
         Shortcut = "Cmd+2"
         MenuModifier = True
         AutoEnable = True
         Visible = True
      End
   End
End
#tag EndMenu
