#tag Class
Protected Class Utilities
	#tag Method, Flags = &h0
		Shared Function CharInHeaderLevelRange(c As String) As Boolean
		  // Returns True if `c` is 1, 2, 3, 4, 5 or 6.
		  
		  Select Case c
		  Case "1", "2", "3", "4", "5", "6"
		    Return True
		  Else
		    Return False
		  End Select
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function Escaped(chars() As String, pos As Integer) As Boolean
		  // Returns True if the character at zero-based position `pos` is escaped.
		  // (i.e: preceded by a (non-escaped) backslash character).
		  
		  If pos > chars.LastIndex or pos = 0 Then Return False
		  
		  If chars(pos - 1) = "\" And Not Escaped(chars, pos - 1) Then
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub Initialise()
		  If mInitialised Then Return
		  
		  InitialiseCharacterReferencesDictionary
		  
		  mInitialised = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub InitialiseCharacterReferencesDictionary()
		  // One-time intialisation of the dictionary which contains the recognised HTML entity 
		  // references and their corresponding Unicode codepoints.
		  
		  CharacterReferences = Xojo.Data.ParseJSON("{}") // Case-sensitive.
		  
		  CharacterReferences.Value("AElig") = 198
		  CharacterReferences.Value("AMP") = 38
		  CharacterReferences.Value("Aacute") = 193
		  CharacterReferences.Value("Abreve") = 258
		  CharacterReferences.Value("Acirc") = 194
		  CharacterReferences.Value("Acy") = 1040
		  CharacterReferences.Value("Afr") = 120068
		  CharacterReferences.Value("Agrave") = 192
		  CharacterReferences.Value("Alpha") = 913
		  CharacterReferences.Value("Amacr") = 256
		  CharacterReferences.Value("And") = 10835
		  CharacterReferences.Value("Aogon") = 260
		  CharacterReferences.Value("Aopf") = 120120
		  CharacterReferences.Value("ApplyFunction") = 8289
		  CharacterReferences.Value("Aring") = 197
		  CharacterReferences.Value("Ascr") = 119964
		  CharacterReferences.Value("Assign") = 8788
		  CharacterReferences.Value("Atilde") = 195
		  CharacterReferences.Value("Auml") = 196
		  CharacterReferences.Value("Backslash") = 8726
		  CharacterReferences.Value("Barv") = 10983
		  CharacterReferences.Value("Barwed") = 8966
		  CharacterReferences.Value("Bcy") = 1041
		  CharacterReferences.Value("Because") = 8757
		  CharacterReferences.Value("Bernoullis") = 8492
		  CharacterReferences.Value("Beta") = 914
		  CharacterReferences.Value("Bfr") = 120069
		  CharacterReferences.Value("Bopf") = 120121
		  CharacterReferences.Value("Breve") = 728
		  CharacterReferences.Value("Bscr") = 8492
		  CharacterReferences.Value("Bumpeq") = 8782
		  CharacterReferences.Value("CHcy") = 1063
		  CharacterReferences.Value("COPY") = 169
		  CharacterReferences.Value("Cacute") = 262
		  CharacterReferences.Value("Cap") = 8914
		  CharacterReferences.Value("CapitalDifferentialD") = 8517
		  CharacterReferences.Value("Cayleys") = 8493
		  CharacterReferences.Value("Ccaron") = 268
		  CharacterReferences.Value("Ccedil") = 199
		  CharacterReferences.Value("Ccirc") = 264
		  CharacterReferences.Value("Cconint") = 8752
		  CharacterReferences.Value("Cdot") = 266
		  CharacterReferences.Value("Cedilla") = 184
		  CharacterReferences.Value("CenterDot") = 183
		  CharacterReferences.Value("Cfr") = 8493
		  CharacterReferences.Value("Chi") = 935
		  CharacterReferences.Value("CircleDot") = 8857
		  CharacterReferences.Value("CircleMinus") = 8854
		  CharacterReferences.Value("CirclePlus") = 8853
		  CharacterReferences.Value("CircleTimes") = 8855
		  CharacterReferences.Value("ClockwiseContourIntegral") = 8754
		  CharacterReferences.Value("CloseCurlyDoubleQuote") = 8221
		  CharacterReferences.Value("CloseCurlyQuote") = 8217
		  CharacterReferences.Value("Colon") = 8759
		  CharacterReferences.Value("Colone") = 10868
		  CharacterReferences.Value("Congruent") = 8801
		  CharacterReferences.Value("Conint") = 8751
		  CharacterReferences.Value("ContourIntegral") = 8750
		  CharacterReferences.Value("Copf") = 8450
		  CharacterReferences.Value("Coproduct") = 8720
		  CharacterReferences.Value("CounterClockwiseContourIntegral") = 8755
		  CharacterReferences.Value("Cross") = 10799
		  CharacterReferences.Value("Cscr") = 119966
		  CharacterReferences.Value("Cup") = 8915
		  CharacterReferences.Value("CupCap") = 8781
		  CharacterReferences.Value("DD") = 8517
		  CharacterReferences.Value("DDotrahd") = 10513
		  CharacterReferences.Value("DJcy") = 1026
		  CharacterReferences.Value("DScy") = 1029
		  CharacterReferences.Value("DZcy") = 1039
		  CharacterReferences.Value("Dagger") = 8225
		  CharacterReferences.Value("Darr") = 8609
		  CharacterReferences.Value("Dashv") = 10980
		  CharacterReferences.Value("Dcaron") = 270
		  CharacterReferences.Value("Dcy") = 1044
		  CharacterReferences.Value("Del") = 8711
		  CharacterReferences.Value("Delta") = 916
		  CharacterReferences.Value("Dfr") = 120071
		  CharacterReferences.Value("DiacriticalAcute") = 180
		  CharacterReferences.Value("DiacriticalDot") = 729
		  CharacterReferences.Value("DiacriticalDoubleAcute") = 733
		  CharacterReferences.Value("DiacriticalGrave") = 96
		  CharacterReferences.Value("DiacriticalTilde") = 732
		  CharacterReferences.Value("Diamond") = 8900
		  CharacterReferences.Value("DifferentialD") = 8518
		  CharacterReferences.Value("Dopf") = 120123
		  CharacterReferences.Value("Dot") = 168
		  CharacterReferences.Value("DotDot") = 8412
		  CharacterReferences.Value("DotEqual") = 8784
		  CharacterReferences.Value("DoubleContourIntegral") = 8751
		  CharacterReferences.Value("DoubleDot") = 168
		  CharacterReferences.Value("DoubleDownArrow") = 8659
		  CharacterReferences.Value("DoubleLeftArrow") = 8656
		  CharacterReferences.Value("DoubleLeftRightArrow") = 8660
		  CharacterReferences.Value("DoubleLeftTee") = 10980
		  CharacterReferences.Value("DoubleLongLeftArrow") = 10232
		  CharacterReferences.Value("DoubleLongLeftRightArrow") = 10234
		  CharacterReferences.Value("DoubleLongRightArrow") = 10233
		  CharacterReferences.Value("DoubleRightArrow") = 8658
		  CharacterReferences.Value("DoubleRightTee") = 8872
		  CharacterReferences.Value("DoubleUpArrow") = 8657
		  CharacterReferences.Value("DoubleUpDownArrow") = 8661
		  CharacterReferences.Value("DoubleVerticalBar") = 8741
		  CharacterReferences.Value("DownArrow") = 8595
		  CharacterReferences.Value("DownArrowBar") = 10515
		  CharacterReferences.Value("DownArrowUpArrow") = 8693
		  CharacterReferences.Value("DownBreve") = 785
		  CharacterReferences.Value("DownLeftRightVector") = 10576
		  CharacterReferences.Value("DownLeftTeeVector") = 10590
		  CharacterReferences.Value("DownLeftVector") = 8637
		  CharacterReferences.Value("DownLeftVectorBar") = 10582
		  CharacterReferences.Value("DownRightTeeVector") = 10591
		  CharacterReferences.Value("DownRightVector") = 8641
		  CharacterReferences.Value("DownRightVectorBar") = 10583
		  CharacterReferences.Value("DownTee") = 8868
		  CharacterReferences.Value("DownTeeArrow") = 8615
		  CharacterReferences.Value("Downarrow") = 8659
		  CharacterReferences.Value("Dscr") = 119967
		  CharacterReferences.Value("Dstrok") = 272
		  CharacterReferences.Value("ENG") = 330
		  CharacterReferences.Value("ETH") = 208
		  CharacterReferences.Value("Eacute") = 201
		  CharacterReferences.Value("Ecaron") = 282
		  CharacterReferences.Value("Ecirc") = 202
		  CharacterReferences.Value("Ecy") = 1069
		  CharacterReferences.Value("Edot") = 278
		  CharacterReferences.Value("Efr") = 120072
		  CharacterReferences.Value("Egrave") = 200
		  CharacterReferences.Value("Element") = 8712
		  CharacterReferences.Value("Emacr") = 274
		  CharacterReferences.Value("EmptySmallSquare") = 9723
		  CharacterReferences.Value("EmptyVerySmallSquare") = 9643
		  CharacterReferences.Value("Eogon") = 280
		  CharacterReferences.Value("Eopf") = 120124
		  CharacterReferences.Value("Epsilon") = 917
		  CharacterReferences.Value("Equal") = 10869
		  CharacterReferences.Value("EqualTilde") = 8770
		  CharacterReferences.Value("Equilibrium") = 8652
		  CharacterReferences.Value("Escr") = 8496
		  CharacterReferences.Value("Esim") = 10867
		  CharacterReferences.Value("Eta") = 919
		  CharacterReferences.Value("Euml") = 203
		  CharacterReferences.Value("Exists") = 8707
		  CharacterReferences.Value("ExponentialE") = 8519
		  CharacterReferences.Value("Fcy") = 1060
		  CharacterReferences.Value("Ffr") = 120073
		  CharacterReferences.Value("FilledSmallSquare") = 9724
		  CharacterReferences.Value("FilledVerySmallSquare") = 9642
		  CharacterReferences.Value("Fopf") = 120125
		  CharacterReferences.Value("ForAll") = 8704
		  CharacterReferences.Value("Fouriertrf") = 8497
		  CharacterReferences.Value("Fscr") = 8497
		  CharacterReferences.Value("GJcy") = 1027
		  CharacterReferences.Value("GT") = 62
		  CharacterReferences.Value("Gamma") = 915
		  CharacterReferences.Value("Gammad") = 988
		  CharacterReferences.Value("Gbreve") = 286
		  CharacterReferences.Value("Gcedil") = 290
		  CharacterReferences.Value("Gcirc") = 284
		  CharacterReferences.Value("Gcy") = 1043
		  CharacterReferences.Value("Gdot") = 288
		  CharacterReferences.Value("Gfr") = 120074
		  CharacterReferences.Value("Gg") = 8921
		  CharacterReferences.Value("Gopf") = 120126
		  CharacterReferences.Value("GreaterEqual") = 8805
		  CharacterReferences.Value("GreaterEqualLess") = 8923
		  CharacterReferences.Value("GreaterFullEqual") = 8807
		  CharacterReferences.Value("GreaterGreater") = 10914
		  CharacterReferences.Value("GreaterLess") = 8823
		  CharacterReferences.Value("GreaterSlantEqual") = 10878
		  CharacterReferences.Value("GreaterTilde") = 8819
		  CharacterReferences.Value("Gscr") = 119970
		  CharacterReferences.Value("Gt") = 8811
		  CharacterReferences.Value("HARDcy") = 1066
		  CharacterReferences.Value("Hacek") = 711
		  CharacterReferences.Value("Hat") = 94
		  CharacterReferences.Value("Hcirc") = 292
		  CharacterReferences.Value("Hfr") = 8460
		  CharacterReferences.Value("HilbertSpace") = 8459
		  CharacterReferences.Value("Hopf") = 8461
		  CharacterReferences.Value("HorizontalLine") = 9472
		  CharacterReferences.Value("Hscr") = 8459
		  CharacterReferences.Value("Hstrok") = 294
		  CharacterReferences.Value("HumpDownHump") = 8782
		  CharacterReferences.Value("HumpEqual") = 8783
		  CharacterReferences.Value("IEcy") = 1045
		  CharacterReferences.Value("IJlig") = 306
		  CharacterReferences.Value("IOcy") = 1025
		  CharacterReferences.Value("Iacute") = 205
		  CharacterReferences.Value("Icirc") = 206
		  CharacterReferences.Value("Icy") = 1048
		  CharacterReferences.Value("Idot") = 304
		  CharacterReferences.Value("Ifr") = 8465
		  CharacterReferences.Value("Igrave") = 204
		  CharacterReferences.Value("Im") = 8465
		  CharacterReferences.Value("Imacr") = 298
		  CharacterReferences.Value("ImaginaryI") = 8520
		  CharacterReferences.Value("Implies") = 8658
		  CharacterReferences.Value("Int") = 8748
		  CharacterReferences.Value("Integral") = 8747
		  CharacterReferences.Value("Intersection") = 8898
		  CharacterReferences.Value("InvisibleComma") = 8291
		  CharacterReferences.Value("InvisibleTimes") = 8290
		  CharacterReferences.Value("Iogon") = 302
		  CharacterReferences.Value("Iopf") = 120128
		  CharacterReferences.Value("Iota") = 921
		  CharacterReferences.Value("Iscr") = 8464
		  CharacterReferences.Value("Itilde") = 296
		  CharacterReferences.Value("Iukcy") = 1030
		  CharacterReferences.Value("Iuml") = 207
		  CharacterReferences.Value("Jcirc") = 308
		  CharacterReferences.Value("Jcy") = 1049
		  CharacterReferences.Value("Jfr") = 120077
		  CharacterReferences.Value("Jopf") = 120129
		  CharacterReferences.Value("Jscr") = 119973
		  CharacterReferences.Value("Jsercy") = 1032
		  CharacterReferences.Value("Jukcy") = 1028
		  CharacterReferences.Value("KHcy") = 1061
		  CharacterReferences.Value("KJcy") = 1036
		  CharacterReferences.Value("Kappa") = 922
		  CharacterReferences.Value("Kcedil") = 310
		  CharacterReferences.Value("Kcy") = 1050
		  CharacterReferences.Value("Kfr") = 120078
		  CharacterReferences.Value("Kopf") = 120130
		  CharacterReferences.Value("Kscr") = 119974
		  CharacterReferences.Value("LJcy") = 1033
		  CharacterReferences.Value("LT") = 60
		  CharacterReferences.Value("Lacute") = 313
		  CharacterReferences.Value("Lambda") = 923
		  CharacterReferences.Value("Lang") = 10218
		  CharacterReferences.Value("Laplacetrf") = 8466
		  CharacterReferences.Value("Larr") = 8606
		  CharacterReferences.Value("Lcaron") = 317
		  CharacterReferences.Value("Lcedil") = 315
		  CharacterReferences.Value("Lcy") = 1051
		  CharacterReferences.Value("LeftAngleBracket") = 10216
		  CharacterReferences.Value("LeftArrow") = 8592
		  CharacterReferences.Value("LeftArrowBar") = 8676
		  CharacterReferences.Value("LeftArrowRightArrow") = 8646
		  CharacterReferences.Value("LeftCeiling") = 8968
		  CharacterReferences.Value("LeftDoubleBracket") = 10214
		  CharacterReferences.Value("LeftDownTeeVector") = 10593
		  CharacterReferences.Value("LeftDownVector") = 8643
		  CharacterReferences.Value("LeftDownVectorBar") = 10585
		  CharacterReferences.Value("LeftFloor") = 8970
		  CharacterReferences.Value("LeftRightArrow") = 8596
		  CharacterReferences.Value("LeftRightVector") = 10574
		  CharacterReferences.Value("LeftTee") = 8867
		  CharacterReferences.Value("LeftTeeArrow") = 8612
		  CharacterReferences.Value("LeftTeeVector") = 10586
		  CharacterReferences.Value("LeftTriangle") = 8882
		  CharacterReferences.Value("LeftTriangleBar") = 10703
		  CharacterReferences.Value("LeftTriangleEqual") = 8884
		  CharacterReferences.Value("LeftUpDownVector") = 10577
		  CharacterReferences.Value("LeftUpTeeVector") = 10592
		  CharacterReferences.Value("LeftUpVector") = 8639
		  CharacterReferences.Value("LeftUpVectorBar") = 10584
		  CharacterReferences.Value("LeftVector") = 8636
		  CharacterReferences.Value("LeftVectorBar") = 10578
		  CharacterReferences.Value("Leftarrow") = 8656
		  CharacterReferences.Value("Leftrightarrow") = 8660
		  CharacterReferences.Value("LessEqualGreater") = 8922
		  CharacterReferences.Value("LessFullEqual") = 8806
		  CharacterReferences.Value("LessGreater") = 8822
		  CharacterReferences.Value("LessLess") = 10913
		  CharacterReferences.Value("LessSlantEqual") = 10877
		  CharacterReferences.Value("LessTilde") = 8818
		  CharacterReferences.Value("Lfr") = 120079
		  CharacterReferences.Value("Ll") = 8920
		  CharacterReferences.Value("Lleftarrow") = 8666
		  CharacterReferences.Value("Lmidot") = 319
		  CharacterReferences.Value("LongLeftArrow") = 10229
		  CharacterReferences.Value("LongLeftRightArrow") = 10231
		  CharacterReferences.Value("LongRightArrow") = 10230
		  CharacterReferences.Value("Longleftarrow") = 10232
		  CharacterReferences.Value("Longleftrightarrow") = 10234
		  CharacterReferences.Value("Longrightarrow") = 10233
		  CharacterReferences.Value("Lopf") = 120131
		  CharacterReferences.Value("LowerLeftArrow") = 8601
		  CharacterReferences.Value("LowerRightArrow") = 8600
		  CharacterReferences.Value("Lscr") = 8466
		  CharacterReferences.Value("Lsh") = 8624
		  CharacterReferences.Value("Lstrok") = 321
		  CharacterReferences.Value("Lt") = 8810
		  CharacterReferences.Value("Map") = 10501
		  CharacterReferences.Value("Mcy") = 1052
		  CharacterReferences.Value("MediumSpace") = 8287
		  CharacterReferences.Value("Mellintrf") = 8499
		  CharacterReferences.Value("Mfr") = 120080
		  CharacterReferences.Value("MinusPlus") = 8723
		  CharacterReferences.Value("Mopf") = 120132
		  CharacterReferences.Value("Mscr") = 8499
		  CharacterReferences.Value("Mu") = 924
		  CharacterReferences.Value("NJcy") = 1034
		  CharacterReferences.Value("Nacute") = 323
		  CharacterReferences.Value("Ncaron") = 327
		  CharacterReferences.Value("Ncedil") = 325
		  CharacterReferences.Value("Ncy") = 1053
		  CharacterReferences.Value("NegativeMediumSpace") = 8203
		  CharacterReferences.Value("NegativeThickSpace") = 8203
		  CharacterReferences.Value("NegativeThinSpace") = 8203
		  CharacterReferences.Value("NegativeVeryThinSpace") = 8203
		  CharacterReferences.Value("NestedGreaterGreater") = 8811
		  CharacterReferences.Value("NestedLessLess") = 8810
		  CharacterReferences.Value("NewLine") = 10
		  CharacterReferences.Value("Nfr") = 120081
		  CharacterReferences.Value("NoBreak") = 8288
		  CharacterReferences.Value("NonBreakingSpace") = 160
		  CharacterReferences.Value("Nopf") = 8469
		  CharacterReferences.Value("Not") = 10988
		  CharacterReferences.Value("NotCongruent") = 8802
		  CharacterReferences.Value("NotCupCap") = 8813
		  CharacterReferences.Value("NotDoubleVerticalBar") = 8742
		  CharacterReferences.Value("NotElement") = 8713
		  CharacterReferences.Value("NotEqual") = 8800
		  CharacterReferences.Value("NotEqualTilde") = 8770
		  CharacterReferences.Value("NotExists") = 8708
		  CharacterReferences.Value("NotGreater") = 8815
		  CharacterReferences.Value("NotGreaterEqual") = 8817
		  CharacterReferences.Value("NotGreaterFullEqual") = 8807
		  CharacterReferences.Value("NotGreaterGreater") = 8811
		  CharacterReferences.Value("NotGreaterLess") = 8825
		  CharacterReferences.Value("NotGreaterSlantEqual") = 10878
		  CharacterReferences.Value("NotGreaterTilde") = 8821
		  CharacterReferences.Value("NotHumpDownHump") = 8782
		  CharacterReferences.Value("NotHumpEqual") = 8783
		  CharacterReferences.Value("NotLeftTriangle") = 8938
		  CharacterReferences.Value("NotLeftTriangleBar") = 10703
		  CharacterReferences.Value("NotLeftTriangleEqual") = 8940
		  CharacterReferences.Value("NotLess") = 8814
		  CharacterReferences.Value("NotLessEqual") = 8816
		  CharacterReferences.Value("NotLessGreater") = 8824
		  CharacterReferences.Value("NotLessLess") = 8810
		  CharacterReferences.Value("NotLessSlantEqual") = 10877
		  CharacterReferences.Value("NotLessTilde") = 8820
		  CharacterReferences.Value("NotNestedGreaterGreater") = 10914
		  CharacterReferences.Value("NotNestedLessLess") = 10913
		  CharacterReferences.Value("NotPrecedes") = 8832
		  CharacterReferences.Value("NotPrecedesEqual") = 10927
		  CharacterReferences.Value("NotPrecedesSlantEqual") = 8928
		  CharacterReferences.Value("NotReverseElement") = 8716
		  CharacterReferences.Value("NotRightTriangle") = 8939
		  CharacterReferences.Value("NotRightTriangleBar") = 10704
		  CharacterReferences.Value("NotRightTriangleEqual") = 8941
		  CharacterReferences.Value("NotSquareSubset") = 8847
		  CharacterReferences.Value("NotSquareSubsetEqual") = 8930
		  CharacterReferences.Value("NotSquareSuperset") = 8848
		  CharacterReferences.Value("NotSquareSupersetEqual") = 8931
		  CharacterReferences.Value("NotSubset") = 8834
		  CharacterReferences.Value("NotSubsetEqual") = 8840
		  CharacterReferences.Value("NotSucceeds") = 8833
		  CharacterReferences.Value("NotSucceedsEqual") = 10928
		  CharacterReferences.Value("NotSucceedsSlantEqual") = 8929
		  CharacterReferences.Value("NotSucceedsTilde") = 8831
		  CharacterReferences.Value("NotSuperset") = 8835
		  CharacterReferences.Value("NotSupersetEqual") = 8841
		  CharacterReferences.Value("NotTilde") = 8769
		  CharacterReferences.Value("NotTildeEqual") = 8772
		  CharacterReferences.Value("NotTildeFullEqual") = 8775
		  CharacterReferences.Value("NotTildeTilde") = 8777
		  CharacterReferences.Value("NotVerticalBar") = 8740
		  CharacterReferences.Value("Nscr") = 119977
		  CharacterReferences.Value("Ntilde") = 209
		  CharacterReferences.Value("Nu") = 925
		  CharacterReferences.Value("OElig") = 338
		  CharacterReferences.Value("Oacute") = 211
		  CharacterReferences.Value("Ocirc") = 212
		  CharacterReferences.Value("Ocy") = 1054
		  CharacterReferences.Value("Odblac") = 336
		  CharacterReferences.Value("Ofr") = 120082
		  CharacterReferences.Value("Ograve") = 210
		  CharacterReferences.Value("Omacr") = 332
		  CharacterReferences.Value("Omega") = 937
		  CharacterReferences.Value("Omicron") = 927
		  CharacterReferences.Value("Oopf") = 120134
		  CharacterReferences.Value("OpenCurlyDoubleQuote") = 8220
		  CharacterReferences.Value("OpenCurlyQuote") = 8216
		  CharacterReferences.Value("Or") = 10836
		  CharacterReferences.Value("Oscr") = 119978
		  CharacterReferences.Value("Oslash") = 216
		  CharacterReferences.Value("Otilde") = 213
		  CharacterReferences.Value("Otimes") = 10807
		  CharacterReferences.Value("Ouml") = 214
		  CharacterReferences.Value("OverBar") = 8254
		  CharacterReferences.Value("OverBrace") = 9182
		  CharacterReferences.Value("OverBracket") = 9140
		  CharacterReferences.Value("OverParenthesis") = 9180
		  CharacterReferences.Value("PartialD") = 8706
		  CharacterReferences.Value("Pcy") = 1055
		  CharacterReferences.Value("Pfr") = 120083
		  CharacterReferences.Value("Phi") = 934
		  CharacterReferences.Value("Pi") = 928
		  CharacterReferences.Value("PlusMinus") = 177
		  CharacterReferences.Value("Poincareplane") = 8460
		  CharacterReferences.Value("Popf") = 8473
		  CharacterReferences.Value("Pr") = 10939
		  CharacterReferences.Value("Precedes") = 8826
		  CharacterReferences.Value("PrecedesEqual") = 10927
		  CharacterReferences.Value("PrecedesSlantEqual") = 8828
		  CharacterReferences.Value("PrecedesTilde") = 8830
		  CharacterReferences.Value("Prime") = 8243
		  CharacterReferences.Value("Product") = 8719
		  CharacterReferences.Value("Proportion") = 8759
		  CharacterReferences.Value("Proportional") = 8733
		  CharacterReferences.Value("Pscr") = 119979
		  CharacterReferences.Value("Psi") = 936
		  CharacterReferences.Value("QUOT") = 34
		  CharacterReferences.Value("Qfr") = 120084
		  CharacterReferences.Value("Qopf") = 8474
		  CharacterReferences.Value("Qscr") = 119980
		  CharacterReferences.Value("RBarr") = 10512
		  CharacterReferences.Value("REG") = 174
		  CharacterReferences.Value("Racute") = 340
		  CharacterReferences.Value("Rang") = 10219
		  CharacterReferences.Value("Rarr") = 8608
		  CharacterReferences.Value("Rarrtl") = 10518
		  CharacterReferences.Value("Rcaron") = 344
		  CharacterReferences.Value("Rcedil") = 342
		  CharacterReferences.Value("Rcy") = 1056
		  CharacterReferences.Value("Re") = 8476
		  CharacterReferences.Value("ReverseElement") = 8715
		  CharacterReferences.Value("ReverseEquilibrium") = 8651
		  CharacterReferences.Value("ReverseUpEquilibrium") = 10607
		  CharacterReferences.Value("Rfr") = 8476
		  CharacterReferences.Value("Rho") = 929
		  CharacterReferences.Value("RightAngleBracket") = 10217
		  CharacterReferences.Value("RightArrow") = 8594
		  CharacterReferences.Value("RightArrowBar") = 8677
		  CharacterReferences.Value("RightArrowLeftArrow") = 8644
		  CharacterReferences.Value("RightCeiling") = 8969
		  CharacterReferences.Value("RightDoubleBracket") = 10215
		  CharacterReferences.Value("RightDownTeeVector") = 10589
		  CharacterReferences.Value("RightDownVector") = 8642
		  CharacterReferences.Value("RightDownVectorBar") = 10581
		  CharacterReferences.Value("RightFloor") = 8971
		  CharacterReferences.Value("RightTee") = 8866
		  CharacterReferences.Value("RightTeeArrow") = 8614
		  CharacterReferences.Value("RightTeeVector") = 10587
		  CharacterReferences.Value("RightTriangle") = 8883
		  CharacterReferences.Value("RightTriangleBar") = 10704
		  CharacterReferences.Value("RightTriangleEqual") = 8885
		  CharacterReferences.Value("RightUpDownVector") = 10575
		  CharacterReferences.Value("RightUpTeeVector") = 10588
		  CharacterReferences.Value("RightUpVector") = 8638
		  CharacterReferences.Value("RightUpVectorBar") = 10580
		  CharacterReferences.Value("RightVector") = 8640
		  CharacterReferences.Value("RightVectorBar") = 10579
		  CharacterReferences.Value("Rightarrow") = 8658
		  CharacterReferences.Value("Ropf") = 8477
		  CharacterReferences.Value("RoundImplies") = 10608
		  CharacterReferences.Value("Rrightarrow") = 8667
		  CharacterReferences.Value("Rscr") = 8475
		  CharacterReferences.Value("Rsh") = 8625
		  CharacterReferences.Value("RuleDelayed") = 10740
		  CharacterReferences.Value("SHCHcy") = 1065
		  CharacterReferences.Value("SHcy") = 1064
		  CharacterReferences.Value("SOFTcy") = 1068
		  CharacterReferences.Value("Sacute") = 346
		  CharacterReferences.Value("Sc") = 10940
		  CharacterReferences.Value("Scaron") = 352
		  CharacterReferences.Value("Scedil") = 350
		  CharacterReferences.Value("Scirc") = 348
		  CharacterReferences.Value("Scy") = 1057
		  CharacterReferences.Value("Sfr") = 120086
		  CharacterReferences.Value("ShortDownArrow") = 8595
		  CharacterReferences.Value("ShortLeftArrow") = 8592
		  CharacterReferences.Value("ShortRightArrow") = 8594
		  CharacterReferences.Value("ShortUpArrow") = 8593
		  CharacterReferences.Value("Sigma") = 931
		  CharacterReferences.Value("SmallCircle") = 8728
		  CharacterReferences.Value("Sopf") = 120138
		  CharacterReferences.Value("Sqrt") = 8730
		  CharacterReferences.Value("Square") = 9633
		  CharacterReferences.Value("SquareIntersection") = 8851
		  CharacterReferences.Value("SquareSubset") = 8847
		  CharacterReferences.Value("SquareSubsetEqual") = 8849
		  CharacterReferences.Value("SquareSuperset") = 8848
		  CharacterReferences.Value("SquareSupersetEqual") = 8850
		  CharacterReferences.Value("SquareUnion") = 8852
		  CharacterReferences.Value("Sscr") = 119982
		  CharacterReferences.Value("Star") = 8902
		  CharacterReferences.Value("Sub") = 8912
		  CharacterReferences.Value("Subset") = 8912
		  CharacterReferences.Value("SubsetEqual") = 8838
		  CharacterReferences.Value("Succeeds") = 8827
		  CharacterReferences.Value("SucceedsEqual") = 10928
		  CharacterReferences.Value("SucceedsSlantEqual") = 8829
		  CharacterReferences.Value("SucceedsTilde") = 8831
		  CharacterReferences.Value("SuchThat") = 8715
		  CharacterReferences.Value("Sum") = 8721
		  CharacterReferences.Value("Sup") = 8913
		  CharacterReferences.Value("Superset") = 8835
		  CharacterReferences.Value("SupersetEqual") = 8839
		  CharacterReferences.Value("Supset") = 8913
		  CharacterReferences.Value("THORN") = 222
		  CharacterReferences.Value("TRADE") = 8482
		  CharacterReferences.Value("TSHcy") = 1035
		  CharacterReferences.Value("TScy") = 1062
		  CharacterReferences.Value("Tab") = 9
		  CharacterReferences.Value("Tau") = 932
		  CharacterReferences.Value("Tcaron") = 356
		  CharacterReferences.Value("Tcedil") = 354
		  CharacterReferences.Value("Tcy") = 1058
		  CharacterReferences.Value("Tfr") = 120087
		  CharacterReferences.Value("Therefore") = 8756
		  CharacterReferences.Value("Theta") = 920
		  CharacterReferences.Value("ThickSpace") = 8287
		  CharacterReferences.Value("ThinSpace") = 8201
		  CharacterReferences.Value("Tilde") = 8764
		  CharacterReferences.Value("TildeEqual") = 8771
		  CharacterReferences.Value("TildeFullEqual") = 8773
		  CharacterReferences.Value("TildeTilde") = 8776
		  CharacterReferences.Value("Topf") = 120139
		  CharacterReferences.Value("TripleDot") = 8411
		  CharacterReferences.Value("Tscr") = 119983
		  CharacterReferences.Value("Tstrok") = 358
		  CharacterReferences.Value("Uacute") = 218
		  CharacterReferences.Value("Uarr") = 8607
		  CharacterReferences.Value("Uarrocir") = 10569
		  CharacterReferences.Value("Ubrcy") = 1038
		  CharacterReferences.Value("Ubreve") = 364
		  CharacterReferences.Value("Ucirc") = 219
		  CharacterReferences.Value("Ucy") = 1059
		  CharacterReferences.Value("Udblac") = 368
		  CharacterReferences.Value("Ufr") = 120088
		  CharacterReferences.Value("Ugrave") = 217
		  CharacterReferences.Value("Umacr") = 362
		  CharacterReferences.Value("UnderBar") = 95
		  CharacterReferences.Value("UnderBrace") = 9183
		  CharacterReferences.Value("UnderBracket") = 9141
		  CharacterReferences.Value("UnderParenthesis") = 9181
		  CharacterReferences.Value("Union") = 8899
		  CharacterReferences.Value("UnionPlus") = 8846
		  CharacterReferences.Value("Uogon") = 370
		  CharacterReferences.Value("Uopf") = 120140
		  CharacterReferences.Value("UpArrow") = 8593
		  CharacterReferences.Value("UpArrowBar") = 10514
		  CharacterReferences.Value("UpArrowDownArrow") = 8645
		  CharacterReferences.Value("UpDownArrow") = 8597
		  CharacterReferences.Value("UpEquilibrium") = 10606
		  CharacterReferences.Value("UpTee") = 8869
		  CharacterReferences.Value("UpTeeArrow") = 8613
		  CharacterReferences.Value("Uparrow") = 8657
		  CharacterReferences.Value("Updownarrow") = 8661
		  CharacterReferences.Value("UpperLeftArrow") = 8598
		  CharacterReferences.Value("UpperRightArrow") = 8599
		  CharacterReferences.Value("Upsi") = 978
		  CharacterReferences.Value("Upsilon") = 933
		  CharacterReferences.Value("Uring") = 366
		  CharacterReferences.Value("Uscr") = 119984
		  CharacterReferences.Value("Utilde") = 360
		  CharacterReferences.Value("Uuml") = 220
		  CharacterReferences.Value("VDash") = 8875
		  CharacterReferences.Value("Vbar") = 10987
		  CharacterReferences.Value("Vcy") = 1042
		  CharacterReferences.Value("Vdash") = 8873
		  CharacterReferences.Value("Vdashl") = 10982
		  CharacterReferences.Value("Vee") = 8897
		  CharacterReferences.Value("Verbar") = 8214
		  CharacterReferences.Value("Vert") = 8214
		  CharacterReferences.Value("VerticalBar") = 8739
		  CharacterReferences.Value("VerticalLine") = 124
		  CharacterReferences.Value("VerticalSeparator") = 10072
		  CharacterReferences.Value("VerticalTilde") = 8768
		  CharacterReferences.Value("VeryThinSpace") = 8202
		  CharacterReferences.Value("Vfr") = 120089
		  CharacterReferences.Value("Vopf") = 120141
		  CharacterReferences.Value("Vscr") = 119985
		  CharacterReferences.Value("Vvdash") = 8874
		  CharacterReferences.Value("Wcirc") = 372
		  CharacterReferences.Value("Wedge") = 8896
		  CharacterReferences.Value("Wfr") = 120090
		  CharacterReferences.Value("Wopf") = 120142
		  CharacterReferences.Value("Wscr") = 119986
		  CharacterReferences.Value("Xfr") = 120091
		  CharacterReferences.Value("Xi") = 926
		  CharacterReferences.Value("Xopf") = 120143
		  CharacterReferences.Value("Xscr") = 119987
		  CharacterReferences.Value("YAcy") = 1071
		  CharacterReferences.Value("YIcy") = 1031
		  CharacterReferences.Value("YUcy") = 1070
		  CharacterReferences.Value("Yacute") = 221
		  CharacterReferences.Value("Ycirc") = 374
		  CharacterReferences.Value("Ycy") = 1067
		  CharacterReferences.Value("Yfr") = 120092
		  CharacterReferences.Value("Yopf") = 120144
		  CharacterReferences.Value("Yscr") = 119988
		  CharacterReferences.Value("Yuml") = 376
		  CharacterReferences.Value("ZHcy") = 1046
		  CharacterReferences.Value("Zacute") = 377
		  CharacterReferences.Value("Zcaron") = 381
		  CharacterReferences.Value("Zcy") = 1047
		  CharacterReferences.Value("Zdot") = 379
		  CharacterReferences.Value("ZeroWidthSpace") = 8203
		  CharacterReferences.Value("Zeta") = 918
		  CharacterReferences.Value("Zfr") = 8488
		  CharacterReferences.Value("Zopf") = 8484
		  CharacterReferences.Value("Zscr") = 119989
		  CharacterReferences.Value("aacute") = 225
		  CharacterReferences.Value("abreve") = 259
		  CharacterReferences.Value("ac") = 8766
		  CharacterReferences.Value("acE") = 8766
		  CharacterReferences.Value("acd") = 8767
		  CharacterReferences.Value("acirc") = 226
		  CharacterReferences.Value("acute") = 180
		  CharacterReferences.Value("acy") = 1072
		  CharacterReferences.Value("aelig") = 230
		  CharacterReferences.Value("af") = 8289
		  CharacterReferences.Value("afr") = 120094
		  CharacterReferences.Value("agrave") = 224
		  CharacterReferences.Value("alefsym") = 8501
		  CharacterReferences.Value("aleph") = 8501
		  CharacterReferences.Value("alpha") = 945
		  CharacterReferences.Value("amacr") = 257
		  CharacterReferences.Value("amalg") = 10815
		  CharacterReferences.Value("amp") = 38
		  CharacterReferences.Value("and") = 8743
		  CharacterReferences.Value("andand") = 10837
		  CharacterReferences.Value("andd") = 10844
		  CharacterReferences.Value("andslope") = 10840
		  CharacterReferences.Value("andv") = 10842
		  CharacterReferences.Value("ang") = 8736
		  CharacterReferences.Value("ange") = 10660
		  CharacterReferences.Value("angle") = 8736
		  CharacterReferences.Value("angmsd") = 8737
		  CharacterReferences.Value("angmsdaa") = 10664
		  CharacterReferences.Value("angmsdab") = 10665
		  CharacterReferences.Value("angmsdac") = 10666
		  CharacterReferences.Value("angmsdad") = 10667
		  CharacterReferences.Value("angmsdae") = 10668
		  CharacterReferences.Value("angmsdaf") = 10669
		  CharacterReferences.Value("angmsdag") = 10670
		  CharacterReferences.Value("angmsdah") = 10671
		  CharacterReferences.Value("angrt") = 8735
		  CharacterReferences.Value("angrtvb") = 8894
		  CharacterReferences.Value("angrtvbd") = 10653
		  CharacterReferences.Value("angsph") = 8738
		  CharacterReferences.Value("angst") = 197
		  CharacterReferences.Value("angzarr") = 9084
		  CharacterReferences.Value("aogon") = 261
		  CharacterReferences.Value("aopf") = 120146
		  CharacterReferences.Value("ap") = 8776
		  CharacterReferences.Value("apE") = 10864
		  CharacterReferences.Value("apacir") = 10863
		  CharacterReferences.Value("ape") = 8778
		  CharacterReferences.Value("apid") = 8779
		  CharacterReferences.Value("apos") = 39
		  CharacterReferences.Value("approx") = 8776
		  CharacterReferences.Value("approxeq") = 8778
		  CharacterReferences.Value("aring") = 229
		  CharacterReferences.Value("ascr") = 119990
		  CharacterReferences.Value("ast") = 42
		  CharacterReferences.Value("asymp") = 8776
		  CharacterReferences.Value("asympeq") = 8781
		  CharacterReferences.Value("atilde") = 227
		  CharacterReferences.Value("auml") = 228
		  CharacterReferences.Value("awconint") = 8755
		  CharacterReferences.Value("awint") = 10769
		  CharacterReferences.Value("bNot") = 10989
		  CharacterReferences.Value("backcong") = 8780
		  CharacterReferences.Value("backepsilon") = 1014
		  CharacterReferences.Value("backprime") = 8245
		  CharacterReferences.Value("backsim") = 8765
		  CharacterReferences.Value("backsimeq") = 8909
		  CharacterReferences.Value("barvee") = 8893
		  CharacterReferences.Value("barwed") = 8965
		  CharacterReferences.Value("barwedge") = 8965
		  CharacterReferences.Value("bbrk") = 9141
		  CharacterReferences.Value("bbrktbrk") = 9142
		  CharacterReferences.Value("bcong") = 8780
		  CharacterReferences.Value("bcy") = 1073
		  CharacterReferences.Value("bdquo") = 8222
		  CharacterReferences.Value("becaus") = 8757
		  CharacterReferences.Value("because") = 8757
		  CharacterReferences.Value("bemptyv") = 10672
		  CharacterReferences.Value("bepsi") = 1014
		  CharacterReferences.Value("bernou") = 8492
		  CharacterReferences.Value("beta") = 946
		  CharacterReferences.Value("beth") = 8502
		  CharacterReferences.Value("between") = 8812
		  CharacterReferences.Value("bfr") = 120095
		  CharacterReferences.Value("bigcap") = 8898
		  CharacterReferences.Value("bigcirc") = 9711
		  CharacterReferences.Value("bigcup") = 8899
		  CharacterReferences.Value("bigodot") = 10752
		  CharacterReferences.Value("bigoplus") = 10753
		  CharacterReferences.Value("bigotimes") = 10754
		  CharacterReferences.Value("bigsqcup") = 10758
		  CharacterReferences.Value("bigstar") = 9733
		  CharacterReferences.Value("bigtriangledown") = 9661
		  CharacterReferences.Value("bigtriangleup") = 9651
		  CharacterReferences.Value("biguplus") = 10756
		  CharacterReferences.Value("bigvee") = 8897
		  CharacterReferences.Value("bigwedge") = 8896
		  CharacterReferences.Value("bkarow") = 10509
		  CharacterReferences.Value("blacklozenge") = 10731
		  CharacterReferences.Value("blacksquare") = 9642
		  CharacterReferences.Value("blacktriangle") = 9652
		  CharacterReferences.Value("blacktriangledown") = 9662
		  CharacterReferences.Value("blacktriangleleft") = 9666
		  CharacterReferences.Value("blacktriangleright") = 9656
		  CharacterReferences.Value("blank") = 9251
		  CharacterReferences.Value("blk12") = 9618
		  CharacterReferences.Value("blk14") = 9617
		  CharacterReferences.Value("blk34") = 9619
		  CharacterReferences.Value("block") = 9608
		  CharacterReferences.Value("bne") = 61
		  CharacterReferences.Value("bnequiv") = 8801
		  CharacterReferences.Value("bnot") = 8976
		  CharacterReferences.Value("bopf") = 120147
		  CharacterReferences.Value("bot") = 8869
		  CharacterReferences.Value("bottom") = 8869
		  CharacterReferences.Value("bowtie") = 8904
		  CharacterReferences.Value("boxDL") = 9559
		  CharacterReferences.Value("boxDR") = 9556
		  CharacterReferences.Value("boxDl") = 9558
		  CharacterReferences.Value("boxDr") = 9555
		  CharacterReferences.Value("boxH") = 9552
		  CharacterReferences.Value("boxHD") = 9574
		  CharacterReferences.Value("boxHU") = 9577
		  CharacterReferences.Value("boxHd") = 9572
		  CharacterReferences.Value("boxHu") = 9575
		  CharacterReferences.Value("boxUL") = 9565
		  CharacterReferences.Value("boxUR") = 9562
		  CharacterReferences.Value("boxUl") = 9564
		  CharacterReferences.Value("boxUr") = 9561
		  CharacterReferences.Value("boxV") = 9553
		  CharacterReferences.Value("boxVH") = 9580
		  CharacterReferences.Value("boxVL") = 9571
		  CharacterReferences.Value("boxVR") = 9568
		  CharacterReferences.Value("boxVh") = 9579
		  CharacterReferences.Value("boxVl") = 9570
		  CharacterReferences.Value("boxVr") = 9567
		  CharacterReferences.Value("boxbox") = 10697
		  CharacterReferences.Value("boxdL") = 9557
		  CharacterReferences.Value("boxdR") = 9554
		  CharacterReferences.Value("boxdl") = 9488
		  CharacterReferences.Value("boxdr") = 9484
		  CharacterReferences.Value("boxh") = 9472
		  CharacterReferences.Value("boxhD") = 9573
		  CharacterReferences.Value("boxhU") = 9576
		  CharacterReferences.Value("boxhd") = 9516
		  CharacterReferences.Value("boxhu") = 9524
		  CharacterReferences.Value("boxminus") = 8863
		  CharacterReferences.Value("boxplus") = 8862
		  CharacterReferences.Value("boxtimes") = 8864
		  CharacterReferences.Value("boxuL") = 9563
		  CharacterReferences.Value("boxuR") = 9560
		  CharacterReferences.Value("boxul") = 9496
		  CharacterReferences.Value("boxur") = 9492
		  CharacterReferences.Value("boxv") = 9474
		  CharacterReferences.Value("boxvH") = 9578
		  CharacterReferences.Value("boxvL") = 9569
		  CharacterReferences.Value("boxvR") = 9566
		  CharacterReferences.Value("boxvh") = 9532
		  CharacterReferences.Value("boxvl") = 9508
		  CharacterReferences.Value("boxvr") = 9500
		  CharacterReferences.Value("bprime") = 8245
		  CharacterReferences.Value("breve") = 728
		  CharacterReferences.Value("brvbar") = 166
		  CharacterReferences.Value("bscr") = 119991
		  CharacterReferences.Value("bsemi") = 8271
		  CharacterReferences.Value("bsim") = 8765
		  CharacterReferences.Value("bsime") = 8909
		  CharacterReferences.Value("bsol") = 92
		  CharacterReferences.Value("bsolb") = 10693
		  CharacterReferences.Value("bsolhsub") = 10184
		  CharacterReferences.Value("bull") = 8226
		  CharacterReferences.Value("bullet") = 8226
		  CharacterReferences.Value("bump") = 8782
		  CharacterReferences.Value("bumpE") = 10926
		  CharacterReferences.Value("bumpe") = 8783
		  CharacterReferences.Value("bumpeq") = 8783
		  CharacterReferences.Value("cacute") = 263
		  CharacterReferences.Value("cap") = 8745
		  CharacterReferences.Value("capand") = 10820
		  CharacterReferences.Value("capbrcup") = 10825
		  CharacterReferences.Value("capcap") = 10827
		  CharacterReferences.Value("capcup") = 10823
		  CharacterReferences.Value("capdot") = 10816
		  CharacterReferences.Value("caps") = 8745
		  CharacterReferences.Value("caret") = 8257
		  CharacterReferences.Value("caron") = 711
		  CharacterReferences.Value("ccaps") = 10829
		  CharacterReferences.Value("ccaron") = 269
		  CharacterReferences.Value("ccedil") = 231
		  CharacterReferences.Value("ccirc") = 265
		  CharacterReferences.Value("ccups") = 10828
		  CharacterReferences.Value("ccupssm") = 10832
		  CharacterReferences.Value("cdot") = 267
		  CharacterReferences.Value("cedil") = 184
		  CharacterReferences.Value("cemptyv") = 10674
		  CharacterReferences.Value("cent") = 162
		  CharacterReferences.Value("centerdot") = 183
		  CharacterReferences.Value("cfr") = 120096
		  CharacterReferences.Value("chcy") = 1095
		  CharacterReferences.Value("check") = 10003
		  CharacterReferences.Value("checkmark") = 10003
		  CharacterReferences.Value("chi") = 967
		  CharacterReferences.Value("cir") = 9675
		  CharacterReferences.Value("cirE") = 10691
		  CharacterReferences.Value("circ") = 710
		  CharacterReferences.Value("circeq") = 8791
		  CharacterReferences.Value("circlearrowleft") = 8634
		  CharacterReferences.Value("circlearrowright") = 8635
		  CharacterReferences.Value("circledR") = 174
		  CharacterReferences.Value("circledS") = 9416
		  CharacterReferences.Value("circledast") = 8859
		  CharacterReferences.Value("circledcirc") = 8858
		  CharacterReferences.Value("circleddash") = 8861
		  CharacterReferences.Value("cire") = 8791
		  CharacterReferences.Value("cirfnint") = 10768
		  CharacterReferences.Value("cirmid") = 10991
		  CharacterReferences.Value("cirscir") = 10690
		  CharacterReferences.Value("clubs") = 9827
		  CharacterReferences.Value("clubsuit") = 9827
		  CharacterReferences.Value("colon") = 58
		  CharacterReferences.Value("colone") = 8788
		  CharacterReferences.Value("coloneq") = 8788
		  CharacterReferences.Value("comma") = 44
		  CharacterReferences.Value("commat") = 64
		  CharacterReferences.Value("comp") = 8705
		  CharacterReferences.Value("compfn") = 8728
		  CharacterReferences.Value("complement") = 8705
		  CharacterReferences.Value("complexes") = 8450
		  CharacterReferences.Value("cong") = 8773
		  CharacterReferences.Value("congdot") = 10861
		  CharacterReferences.Value("conint") = 8750
		  CharacterReferences.Value("copf") = 120148
		  CharacterReferences.Value("coprod") = 8720
		  CharacterReferences.Value("copy") = 169
		  CharacterReferences.Value("copysr") = 8471
		  CharacterReferences.Value("crarr") = 8629
		  CharacterReferences.Value("cross") = 10007
		  CharacterReferences.Value("cscr") = 119992
		  CharacterReferences.Value("csub") = 10959
		  CharacterReferences.Value("csube") = 10961
		  CharacterReferences.Value("csup") = 10960
		  CharacterReferences.Value("csupe") = 10962
		  CharacterReferences.Value("ctdot") = 8943
		  CharacterReferences.Value("cudarrl") = 10552
		  CharacterReferences.Value("cudarrr") = 10549
		  CharacterReferences.Value("cuepr") = 8926
		  CharacterReferences.Value("cuesc") = 8927
		  CharacterReferences.Value("cularr") = 8630
		  CharacterReferences.Value("cularrp") = 10557
		  CharacterReferences.Value("cup") = 8746
		  CharacterReferences.Value("cupbrcap") = 10824
		  CharacterReferences.Value("cupcap") = 10822
		  CharacterReferences.Value("cupcup") = 10826
		  CharacterReferences.Value("cupdot") = 8845
		  CharacterReferences.Value("cupor") = 10821
		  CharacterReferences.Value("cups") = 8746
		  CharacterReferences.Value("curarr") = 8631
		  CharacterReferences.Value("curarrm") = 10556
		  CharacterReferences.Value("curlyeqprec") = 8926
		  CharacterReferences.Value("curlyeqsucc") = 8927
		  CharacterReferences.Value("curlyvee") = 8910
		  CharacterReferences.Value("curlywedge") = 8911
		  CharacterReferences.Value("curren") = 164
		  CharacterReferences.Value("curvearrowleft") = 8630
		  CharacterReferences.Value("curvearrowright") = 8631
		  CharacterReferences.Value("cuvee") = 8910
		  CharacterReferences.Value("cuwed") = 8911
		  CharacterReferences.Value("cwconint") = 8754
		  CharacterReferences.Value("cwint") = 8753
		  CharacterReferences.Value("cylcty") = 9005
		  CharacterReferences.Value("dArr") = 8659
		  CharacterReferences.Value("dHar") = 10597
		  CharacterReferences.Value("dagger") = 8224
		  CharacterReferences.Value("daleth") = 8504
		  CharacterReferences.Value("darr") = 8595
		  CharacterReferences.Value("dash") = 8208
		  CharacterReferences.Value("dashv") = 8867
		  CharacterReferences.Value("dbkarow") = 10511
		  CharacterReferences.Value("dblac") = 733
		  CharacterReferences.Value("dcaron") = 271
		  CharacterReferences.Value("dcy") = 1076
		  CharacterReferences.Value("dd") = 8518
		  CharacterReferences.Value("ddagger") = 8225
		  CharacterReferences.Value("ddarr") = 8650
		  CharacterReferences.Value("ddotseq") = 10871
		  CharacterReferences.Value("deg") = 176
		  CharacterReferences.Value("delta") = 948
		  CharacterReferences.Value("demptyv") = 10673
		  CharacterReferences.Value("dfisht") = 10623
		  CharacterReferences.Value("dfr") = 120097
		  CharacterReferences.Value("dharl") = 8643
		  CharacterReferences.Value("dharr") = 8642
		  CharacterReferences.Value("diam") = 8900
		  CharacterReferences.Value("diamond") = 8900
		  CharacterReferences.Value("diamondsuit") = 9830
		  CharacterReferences.Value("diams") = 9830
		  CharacterReferences.Value("die") = 168
		  CharacterReferences.Value("digamma") = 989
		  CharacterReferences.Value("disin") = 8946
		  CharacterReferences.Value("div") = 247
		  CharacterReferences.Value("divide") = 247
		  CharacterReferences.Value("divideontimes") = 8903
		  CharacterReferences.Value("divonx") = 8903
		  CharacterReferences.Value("djcy") = 1106
		  CharacterReferences.Value("dlcorn") = 8990
		  CharacterReferences.Value("dlcrop") = 8973
		  CharacterReferences.Value("dollar") = 36
		  CharacterReferences.Value("dopf") = 120149
		  CharacterReferences.Value("dot") = 729
		  CharacterReferences.Value("doteq") = 8784
		  CharacterReferences.Value("doteqdot") = 8785
		  CharacterReferences.Value("dotminus") = 8760
		  CharacterReferences.Value("dotplus") = 8724
		  CharacterReferences.Value("dotsquare") = 8865
		  CharacterReferences.Value("doublebarwedge") = 8966
		  CharacterReferences.Value("downarrow") = 8595
		  CharacterReferences.Value("downdownarrows") = 8650
		  CharacterReferences.Value("downharpoonleft") = 8643
		  CharacterReferences.Value("downharpoonright") = 8642
		  CharacterReferences.Value("drbkarow") = 10512
		  CharacterReferences.Value("drcorn") = 8991
		  CharacterReferences.Value("drcrop") = 8972
		  CharacterReferences.Value("dscr") = 119993
		  CharacterReferences.Value("dscy") = 1109
		  CharacterReferences.Value("dsol") = 10742
		  CharacterReferences.Value("dstrok") = 273
		  CharacterReferences.Value("dtdot") = 8945
		  CharacterReferences.Value("dtri") = 9663
		  CharacterReferences.Value("dtrif") = 9662
		  CharacterReferences.Value("duarr") = 8693
		  CharacterReferences.Value("duhar") = 10607
		  CharacterReferences.Value("dwangle") = 10662
		  CharacterReferences.Value("dzcy") = 1119
		  CharacterReferences.Value("dzigrarr") = 10239
		  CharacterReferences.Value("eDDot") = 10871
		  CharacterReferences.Value("eDot") = 8785
		  CharacterReferences.Value("eacute") = 233
		  CharacterReferences.Value("easter") = 10862
		  CharacterReferences.Value("ecaron") = 283
		  CharacterReferences.Value("ecir") = 8790
		  CharacterReferences.Value("ecirc") = 234
		  CharacterReferences.Value("ecolon") = 8789
		  CharacterReferences.Value("ecy") = 1101
		  CharacterReferences.Value("edot") = 279
		  CharacterReferences.Value("ee") = 8519
		  CharacterReferences.Value("efDot") = 8786
		  CharacterReferences.Value("efr") = 120098
		  CharacterReferences.Value("eg") = 10906
		  CharacterReferences.Value("egrave") = 232
		  CharacterReferences.Value("egs") = 10902
		  CharacterReferences.Value("egsdot") = 10904
		  CharacterReferences.Value("el") = 10905
		  CharacterReferences.Value("elinters") = 9191
		  CharacterReferences.Value("ell") = 8467
		  CharacterReferences.Value("els") = 10901
		  CharacterReferences.Value("elsdot") = 10903
		  CharacterReferences.Value("emacr") = 275
		  CharacterReferences.Value("empty") = 8709
		  CharacterReferences.Value("emptyset") = 8709
		  CharacterReferences.Value("emptyv") = 8709
		  CharacterReferences.Value("emsp13") = 8196
		  CharacterReferences.Value("emsp14") = 8197
		  CharacterReferences.Value("emsp") = 8195
		  CharacterReferences.Value("eng") = 331
		  CharacterReferences.Value("ensp") = 8194
		  CharacterReferences.Value("eogon") = 281
		  CharacterReferences.Value("eopf") = 120150
		  CharacterReferences.Value("epar") = 8917
		  CharacterReferences.Value("eparsl") = 10723
		  CharacterReferences.Value("eplus") = 10865
		  CharacterReferences.Value("epsi") = 949
		  CharacterReferences.Value("epsilon") = 949
		  CharacterReferences.Value("epsiv") = 1013
		  CharacterReferences.Value("eqcirc") = 8790
		  CharacterReferences.Value("eqcolon") = 8789
		  CharacterReferences.Value("eqsim") = 8770
		  CharacterReferences.Value("eqslantgtr") = 10902
		  CharacterReferences.Value("eqslantless") = 10901
		  CharacterReferences.Value("equals") = 61
		  CharacterReferences.Value("equest") = 8799
		  CharacterReferences.Value("equiv") = 8801
		  CharacterReferences.Value("equivDD") = 10872
		  CharacterReferences.Value("eqvparsl") = 10725
		  CharacterReferences.Value("erDot") = 8787
		  CharacterReferences.Value("erarr") = 10609
		  CharacterReferences.Value("escr") = 8495
		  CharacterReferences.Value("esdot") = 8784
		  CharacterReferences.Value("esim") = 8770
		  CharacterReferences.Value("eta") = 951
		  CharacterReferences.Value("eth") = 240
		  CharacterReferences.Value("euml") = 235
		  CharacterReferences.Value("euro") = 8364
		  CharacterReferences.Value("excl") = 33
		  CharacterReferences.Value("exist") = 8707
		  CharacterReferences.Value("expectation") = 8496
		  CharacterReferences.Value("exponentiale") = 8519
		  CharacterReferences.Value("fallingdotseq") = 8786
		  CharacterReferences.Value("fcy") = 1092
		  CharacterReferences.Value("female") = 9792
		  CharacterReferences.Value("ffilig") = 64259
		  CharacterReferences.Value("fflig") = 64256
		  CharacterReferences.Value("ffllig") = 64260
		  CharacterReferences.Value("ffr") = 120099
		  CharacterReferences.Value("filig") = 64257
		  CharacterReferences.Value("fjlig") = 102
		  CharacterReferences.Value("flat") = 9837
		  CharacterReferences.Value("fllig") = 64258
		  CharacterReferences.Value("fltns") = 9649
		  CharacterReferences.Value("fnof") = 402
		  CharacterReferences.Value("fopf") = 120151
		  CharacterReferences.Value("forall") = 8704
		  CharacterReferences.Value("fork") = 8916
		  CharacterReferences.Value("forkv") = 10969
		  CharacterReferences.Value("fpartint") = 10765
		  CharacterReferences.Value("frac12") = 189
		  CharacterReferences.Value("frac13") = 8531
		  CharacterReferences.Value("frac14") = 188
		  CharacterReferences.Value("frac15") = 8533
		  CharacterReferences.Value("frac16") = 8537
		  CharacterReferences.Value("frac18") = 8539
		  CharacterReferences.Value("frac23") = 8532
		  CharacterReferences.Value("frac25") = 8534
		  CharacterReferences.Value("frac34") = 190
		  CharacterReferences.Value("frac35") = 8535
		  CharacterReferences.Value("frac38") = 8540
		  CharacterReferences.Value("frac45") = 8536
		  CharacterReferences.Value("frac56") = 8538
		  CharacterReferences.Value("frac58") = 8541
		  CharacterReferences.Value("frac78") = 8542
		  CharacterReferences.Value("frasl") = 8260
		  CharacterReferences.Value("frown") = 8994
		  CharacterReferences.Value("fscr") = 119995
		  CharacterReferences.Value("gE") = 8807
		  CharacterReferences.Value("gEl") = 10892
		  CharacterReferences.Value("gacute") = 501
		  CharacterReferences.Value("gamma") = 947
		  CharacterReferences.Value("gammad") = 989
		  CharacterReferences.Value("gap") = 10886
		  CharacterReferences.Value("gbreve") = 287
		  CharacterReferences.Value("gcirc") = 285
		  CharacterReferences.Value("gcy") = 1075
		  CharacterReferences.Value("gdot") = 289
		  CharacterReferences.Value("ge") = 8805
		  CharacterReferences.Value("gel") = 8923
		  CharacterReferences.Value("geq") = 8805
		  CharacterReferences.Value("geqq") = 8807
		  CharacterReferences.Value("geqslant") = 10878
		  CharacterReferences.Value("ges") = 10878
		  CharacterReferences.Value("gescc") = 10921
		  CharacterReferences.Value("gesdot") = 10880
		  CharacterReferences.Value("gesdoto") = 10882
		  CharacterReferences.Value("gesdotol") = 10884
		  CharacterReferences.Value("gesl") = 8923
		  CharacterReferences.Value("gesles") = 10900
		  CharacterReferences.Value("gfr") = 120100
		  CharacterReferences.Value("gg") = 8811
		  CharacterReferences.Value("ggg") = 8921
		  CharacterReferences.Value("gimel") = 8503
		  CharacterReferences.Value("gjcy") = 1107
		  CharacterReferences.Value("gl") = 8823
		  CharacterReferences.Value("glE") = 10898
		  CharacterReferences.Value("gla") = 10917
		  CharacterReferences.Value("glj") = 10916
		  CharacterReferences.Value("gnE") = 8809
		  CharacterReferences.Value("gnap") = 10890
		  CharacterReferences.Value("gnapprox") = 10890
		  CharacterReferences.Value("gne") = 10888
		  CharacterReferences.Value("gneq") = 10888
		  CharacterReferences.Value("gneqq") = 8809
		  CharacterReferences.Value("gnsim") = 8935
		  CharacterReferences.Value("gopf") = 120152
		  CharacterReferences.Value("grave") = 96
		  CharacterReferences.Value("gscr") = 8458
		  CharacterReferences.Value("gsim") = 8819
		  CharacterReferences.Value("gsime") = 10894
		  CharacterReferences.Value("gsiml") = 10896
		  CharacterReferences.Value("gt") = 62
		  CharacterReferences.Value("gtcc") = 10919
		  CharacterReferences.Value("gtcir") = 10874
		  CharacterReferences.Value("gtdot") = 8919
		  CharacterReferences.Value("gtlPar") = 10645
		  CharacterReferences.Value("gtquest") = 10876
		  CharacterReferences.Value("gtrapprox") = 10886
		  CharacterReferences.Value("gtrarr") = 10616
		  CharacterReferences.Value("gtrdot") = 8919
		  CharacterReferences.Value("gtreqless") = 8923
		  CharacterReferences.Value("gtreqqless") = 10892
		  CharacterReferences.Value("gtrless") = 8823
		  CharacterReferences.Value("gtrsim") = 8819
		  CharacterReferences.Value("gvertneqq") = 8809
		  CharacterReferences.Value("gvnE") = 8809
		  CharacterReferences.Value("hArr") = 8660
		  CharacterReferences.Value("hairsp") = 8202
		  CharacterReferences.Value("half") = 189
		  CharacterReferences.Value("hamilt") = 8459
		  CharacterReferences.Value("hardcy") = 1098
		  CharacterReferences.Value("harr") = 8596
		  CharacterReferences.Value("harrcir") = 10568
		  CharacterReferences.Value("harrw") = 8621
		  CharacterReferences.Value("hbar") = 8463
		  CharacterReferences.Value("hcirc") = 293
		  CharacterReferences.Value("hearts") = 9829
		  CharacterReferences.Value("heartsuit") = 9829
		  CharacterReferences.Value("hellip") = 8230
		  CharacterReferences.Value("hercon") = 8889
		  CharacterReferences.Value("hfr") = 120101
		  CharacterReferences.Value("hksearow") = 10533
		  CharacterReferences.Value("hkswarow") = 10534
		  CharacterReferences.Value("hoarr") = 8703
		  CharacterReferences.Value("homtht") = 8763
		  CharacterReferences.Value("hookleftarrow") = 8617
		  CharacterReferences.Value("hookrightarrow") = 8618
		  CharacterReferences.Value("hopf") = 120153
		  CharacterReferences.Value("horbar") = 8213
		  CharacterReferences.Value("hscr") = 119997
		  CharacterReferences.Value("hslash") = 8463
		  CharacterReferences.Value("hstrok") = 295
		  CharacterReferences.Value("hybull") = 8259
		  CharacterReferences.Value("hyphen") = 8208
		  CharacterReferences.Value("iacute") = 237
		  CharacterReferences.Value("ic") = 8291
		  CharacterReferences.Value("icirc") = 238
		  CharacterReferences.Value("icy") = 1080
		  CharacterReferences.Value("iecy") = 1077
		  CharacterReferences.Value("iexcl") = 161
		  CharacterReferences.Value("iff") = 8660
		  CharacterReferences.Value("ifr") = 120102
		  CharacterReferences.Value("igrave") = 236
		  CharacterReferences.Value("ii") = 8520
		  CharacterReferences.Value("iiiint") = 10764
		  CharacterReferences.Value("iiint") = 8749
		  CharacterReferences.Value("iinfin") = 10716
		  CharacterReferences.Value("iiota") = 8489
		  CharacterReferences.Value("ijlig") = 307
		  CharacterReferences.Value("imacr") = 299
		  CharacterReferences.Value("image") = 8465
		  CharacterReferences.Value("imagline") = 8464
		  CharacterReferences.Value("imagpart") = 8465
		  CharacterReferences.Value("imath") = 305
		  CharacterReferences.Value("imof") = 8887
		  CharacterReferences.Value("imped") = 437
		  CharacterReferences.Value("in") = 8712
		  CharacterReferences.Value("incare") = 8453
		  CharacterReferences.Value("infin") = 8734
		  CharacterReferences.Value("infintie") = 10717
		  CharacterReferences.Value("inodot") = 305
		  CharacterReferences.Value("int") = 8747
		  CharacterReferences.Value("intcal") = 8890
		  CharacterReferences.Value("integers") = 8484
		  CharacterReferences.Value("intercal") = 8890
		  CharacterReferences.Value("intlarhk") = 10775
		  CharacterReferences.Value("intprod") = 10812
		  CharacterReferences.Value("iocy") = 1105
		  CharacterReferences.Value("iogon") = 303
		  CharacterReferences.Value("iopf") = 120154
		  CharacterReferences.Value("iota") = 953
		  CharacterReferences.Value("iprod") = 10812
		  CharacterReferences.Value("iquest") = 191
		  CharacterReferences.Value("iscr") = 119998
		  CharacterReferences.Value("isin") = 8712
		  CharacterReferences.Value("isinE") = 8953
		  CharacterReferences.Value("isindot") = 8949
		  CharacterReferences.Value("isins") = 8948
		  CharacterReferences.Value("isinsv") = 8947
		  CharacterReferences.Value("isinv") = 8712
		  CharacterReferences.Value("it") = 8290
		  CharacterReferences.Value("itilde") = 297
		  CharacterReferences.Value("iukcy") = 1110
		  CharacterReferences.Value("iuml") = 239
		  CharacterReferences.Value("jcirc") = 309
		  CharacterReferences.Value("jcy") = 1081
		  CharacterReferences.Value("jfr") = 120103
		  CharacterReferences.Value("jmath") = 567
		  CharacterReferences.Value("jopf") = 120155
		  CharacterReferences.Value("jscr") = 119999
		  CharacterReferences.Value("jsercy") = 1112
		  CharacterReferences.Value("jukcy") = 1108
		  CharacterReferences.Value("kappa") = 954
		  CharacterReferences.Value("kappav") = 1008
		  CharacterReferences.Value("kcedil") = 311
		  CharacterReferences.Value("kcy") = 1082
		  CharacterReferences.Value("kfr") = 120104
		  CharacterReferences.Value("kgreen") = 312
		  CharacterReferences.Value("khcy") = 1093
		  CharacterReferences.Value("kjcy") = 1116
		  CharacterReferences.Value("kopf") = 120156
		  CharacterReferences.Value("kscr") = 120000
		  CharacterReferences.Value("lAarr") = 8666
		  CharacterReferences.Value("lArr") = 8656
		  CharacterReferences.Value("lAtail") = 10523
		  CharacterReferences.Value("lBarr") = 10510
		  CharacterReferences.Value("lE") = 8806
		  CharacterReferences.Value("lEg") = 10891
		  CharacterReferences.Value("lHar") = 10594
		  CharacterReferences.Value("lacute") = 314
		  CharacterReferences.Value("laemptyv") = 10676
		  CharacterReferences.Value("lagran") = 8466
		  CharacterReferences.Value("lambda") = 955
		  CharacterReferences.Value("lang") = 10216
		  CharacterReferences.Value("langd") = 10641
		  CharacterReferences.Value("langle") = 10216
		  CharacterReferences.Value("lap") = 10885
		  CharacterReferences.Value("laquo") = 171
		  CharacterReferences.Value("larr") = 8592
		  CharacterReferences.Value("larrb") = 8676
		  CharacterReferences.Value("larrbfs") = 10527
		  CharacterReferences.Value("larrfs") = 10525
		  CharacterReferences.Value("larrhk") = 8617
		  CharacterReferences.Value("larrlp") = 8619
		  CharacterReferences.Value("larrpl") = 10553
		  CharacterReferences.Value("larrsim") = 10611
		  CharacterReferences.Value("larrtl") = 8610
		  CharacterReferences.Value("lat") = 10923
		  CharacterReferences.Value("latail") = 10521
		  CharacterReferences.Value("late") = 10925
		  CharacterReferences.Value("lates") = 10925
		  CharacterReferences.Value("lbarr") = 10508
		  CharacterReferences.Value("lbbrk") = 10098
		  CharacterReferences.Value("lbrace") = 123
		  CharacterReferences.Value("lbrack") = 91
		  CharacterReferences.Value("lbrke") = 10635
		  CharacterReferences.Value("lbrksld") = 10639
		  CharacterReferences.Value("lbrkslu") = 10637
		  CharacterReferences.Value("lcaron") = 318
		  CharacterReferences.Value("lcedil") = 316
		  CharacterReferences.Value("lceil") = 8968
		  CharacterReferences.Value("lcub") = 123
		  CharacterReferences.Value("lcy") = 1083
		  CharacterReferences.Value("ldca") = 10550
		  CharacterReferences.Value("ldquo") = 8220
		  CharacterReferences.Value("ldquor") = 8222
		  CharacterReferences.Value("ldrdhar") = 10599
		  CharacterReferences.Value("ldrushar") = 10571
		  CharacterReferences.Value("ldsh") = 8626
		  CharacterReferences.Value("le") = 8804
		  CharacterReferences.Value("leftarrow") = 8592
		  CharacterReferences.Value("leftarrowtail") = 8610
		  CharacterReferences.Value("leftharpoondown") = 8637
		  CharacterReferences.Value("leftharpoonup") = 8636
		  CharacterReferences.Value("leftleftarrows") = 8647
		  CharacterReferences.Value("leftrightarrow") = 8596
		  CharacterReferences.Value("leftrightarrows") = 8646
		  CharacterReferences.Value("leftrightharpoons") = 8651
		  CharacterReferences.Value("leftrightsquigarrow") = 8621
		  CharacterReferences.Value("leftthreetimes") = 8907
		  CharacterReferences.Value("leg") = 8922
		  CharacterReferences.Value("leq") = 8804
		  CharacterReferences.Value("leqq") = 8806
		  CharacterReferences.Value("leqslant") = 10877
		  CharacterReferences.Value("les") = 10877
		  CharacterReferences.Value("lescc") = 10920
		  CharacterReferences.Value("lesdot") = 10879
		  CharacterReferences.Value("lesdoto") = 10881
		  CharacterReferences.Value("lesdotor") = 10883
		  CharacterReferences.Value("lesg") = 8922
		  CharacterReferences.Value("lesges") = 10899
		  CharacterReferences.Value("lessapprox") = 10885
		  CharacterReferences.Value("lessdot") = 8918
		  CharacterReferences.Value("lesseqgtr") = 8922
		  CharacterReferences.Value("lesseqqgtr") = 10891
		  CharacterReferences.Value("lessgtr") = 8822
		  CharacterReferences.Value("lesssim") = 8818
		  CharacterReferences.Value("lfisht") = 10620
		  CharacterReferences.Value("lfloor") = 8970
		  CharacterReferences.Value("lfr") = 120105
		  CharacterReferences.Value("lg") = 8822
		  CharacterReferences.Value("lgE") = 10897
		  CharacterReferences.Value("lhard") = 8637
		  CharacterReferences.Value("lharu") = 8636
		  CharacterReferences.Value("lharul") = 10602
		  CharacterReferences.Value("lhblk") = 9604
		  CharacterReferences.Value("ljcy") = 1113
		  CharacterReferences.Value("ll") = 8810
		  CharacterReferences.Value("llarr") = 8647
		  CharacterReferences.Value("llcorner") = 8990
		  CharacterReferences.Value("llhard") = 10603
		  CharacterReferences.Value("lltri") = 9722
		  CharacterReferences.Value("lmidot") = 320
		  CharacterReferences.Value("lmoust") = 9136
		  CharacterReferences.Value("lmoustache") = 9136
		  CharacterReferences.Value("lnE") = 8808
		  CharacterReferences.Value("lnap") = 10889
		  CharacterReferences.Value("lnapprox") = 10889
		  CharacterReferences.Value("lne") = 10887
		  CharacterReferences.Value("lneq") = 10887
		  CharacterReferences.Value("lneqq") = 8808
		  CharacterReferences.Value("lnsim") = 8934
		  CharacterReferences.Value("loang") = 10220
		  CharacterReferences.Value("loarr") = 8701
		  CharacterReferences.Value("lobrk") = 10214
		  CharacterReferences.Value("longleftarrow") = 10229
		  CharacterReferences.Value("longleftrightarrow") = 10231
		  CharacterReferences.Value("longmapsto") = 10236
		  CharacterReferences.Value("longrightarrow") = 10230
		  CharacterReferences.Value("looparrowleft") = 8619
		  CharacterReferences.Value("looparrowright") = 8620
		  CharacterReferences.Value("lopar") = 10629
		  CharacterReferences.Value("lopf") = 120157
		  CharacterReferences.Value("loplus") = 10797
		  CharacterReferences.Value("lotimes") = 10804
		  CharacterReferences.Value("lowast") = 8727
		  CharacterReferences.Value("lowbar") = 95
		  CharacterReferences.Value("loz") = 9674
		  CharacterReferences.Value("lozenge") = 9674
		  CharacterReferences.Value("lozf") = 10731
		  CharacterReferences.Value("lpar") = 40
		  CharacterReferences.Value("lparlt") = 10643
		  CharacterReferences.Value("lrarr") = 8646
		  CharacterReferences.Value("lrcorner") = 8991
		  CharacterReferences.Value("lrhar") = 8651
		  CharacterReferences.Value("lrhard") = 10605
		  CharacterReferences.Value("lrm") = 8206
		  CharacterReferences.Value("lrtri") = 8895
		  CharacterReferences.Value("lsaquo") = 8249
		  CharacterReferences.Value("lscr") = 120001
		  CharacterReferences.Value("lsh") = 8624
		  CharacterReferences.Value("lsim") = 8818
		  CharacterReferences.Value("lsime") = 10893
		  CharacterReferences.Value("lsimg") = 10895
		  CharacterReferences.Value("lsqb") = 91
		  CharacterReferences.Value("lsquo") = 8216
		  CharacterReferences.Value("lsquor") = 8218
		  CharacterReferences.Value("lstrok") = 322
		  CharacterReferences.Value("lt") = 60
		  CharacterReferences.Value("ltcc") = 10918
		  CharacterReferences.Value("ltcir") = 10873
		  CharacterReferences.Value("ltdot") = 8918
		  CharacterReferences.Value("lthree") = 8907
		  CharacterReferences.Value("ltimes") = 8905
		  CharacterReferences.Value("ltlarr") = 10614
		  CharacterReferences.Value("ltquest") = 10875
		  CharacterReferences.Value("ltrPar") = 10646
		  CharacterReferences.Value("ltri") = 9667
		  CharacterReferences.Value("ltrie") = 8884
		  CharacterReferences.Value("ltrif") = 9666
		  CharacterReferences.Value("lurdshar") = 10570
		  CharacterReferences.Value("luruhar") = 10598
		  CharacterReferences.Value("lvertneqq") = 8808
		  CharacterReferences.Value("lvnE") = 8808
		  CharacterReferences.Value("mDDot") = 8762
		  CharacterReferences.Value("macr") = 175
		  CharacterReferences.Value("male") = 9794
		  CharacterReferences.Value("malt") = 10016
		  CharacterReferences.Value("maltese") = 10016
		  CharacterReferences.Value("map") = 8614
		  CharacterReferences.Value("mapsto") = 8614
		  CharacterReferences.Value("mapstodown") = 8615
		  CharacterReferences.Value("mapstoleft") = 8612
		  CharacterReferences.Value("mapstoup") = 8613
		  CharacterReferences.Value("marker") = 9646
		  CharacterReferences.Value("mcomma") = 10793
		  CharacterReferences.Value("mcy") = 1084
		  CharacterReferences.Value("mdash") = 8212
		  CharacterReferences.Value("measuredangle") = 8737
		  CharacterReferences.Value("mfr") = 120106
		  CharacterReferences.Value("mho") = 8487
		  CharacterReferences.Value("micro") = 181
		  CharacterReferences.Value("mid") = 8739
		  CharacterReferences.Value("midast") = 42
		  CharacterReferences.Value("midcir") = 10992
		  CharacterReferences.Value("middot") = 183
		  CharacterReferences.Value("minus") = 8722
		  CharacterReferences.Value("minusb") = 8863
		  CharacterReferences.Value("minusd") = 8760
		  CharacterReferences.Value("minusdu") = 10794
		  CharacterReferences.Value("mlcp") = 10971
		  CharacterReferences.Value("mldr") = 8230
		  CharacterReferences.Value("mnplus") = 8723
		  CharacterReferences.Value("models") = 8871
		  CharacterReferences.Value("mopf") = 120158
		  CharacterReferences.Value("mp") = 8723
		  CharacterReferences.Value("mscr") = 120002
		  CharacterReferences.Value("mstpos") = 8766
		  CharacterReferences.Value("mu") = 956
		  CharacterReferences.Value("multimap") = 8888
		  CharacterReferences.Value("mumap") = 8888
		  CharacterReferences.Value("nGg") = 8921
		  CharacterReferences.Value("nGt") = 8811
		  CharacterReferences.Value("nGtv") = 8811
		  CharacterReferences.Value("nLeftarrow") = 8653
		  CharacterReferences.Value("nLeftrightarrow") = 8654
		  CharacterReferences.Value("nLl") = 8920
		  CharacterReferences.Value("nLt") = 8810
		  CharacterReferences.Value("nLtv") = 8810
		  CharacterReferences.Value("nRightarrow") = 8655
		  CharacterReferences.Value("nVDash") = 8879
		  CharacterReferences.Value("nVdash") = 8878
		  CharacterReferences.Value("nabla") = 8711
		  CharacterReferences.Value("nacute") = 324
		  CharacterReferences.Value("nang") = 8736
		  CharacterReferences.Value("nap") = 8777
		  CharacterReferences.Value("napE") = 10864
		  CharacterReferences.Value("napid") = 8779
		  CharacterReferences.Value("napos") = 329
		  CharacterReferences.Value("napprox") = 8777
		  CharacterReferences.Value("natur") = 9838
		  CharacterReferences.Value("natural") = 9838
		  CharacterReferences.Value("naturals") = 8469
		  CharacterReferences.Value("nbsp") = 160
		  CharacterReferences.Value("nbump") = 8782
		  CharacterReferences.Value("nbumpe") = 8783
		  CharacterReferences.Value("ncap") = 10819
		  CharacterReferences.Value("ncaron") = 328
		  CharacterReferences.Value("ncedil") = 326
		  CharacterReferences.Value("ncong") = 8775
		  CharacterReferences.Value("ncongdot") = 10861
		  CharacterReferences.Value("ncup") = 10818
		  CharacterReferences.Value("ncy") = 1085
		  CharacterReferences.Value("ndash") = 8211
		  CharacterReferences.Value("ne") = 8800
		  CharacterReferences.Value("neArr") = 8663
		  CharacterReferences.Value("nearhk") = 10532
		  CharacterReferences.Value("nearr") = 8599
		  CharacterReferences.Value("nearrow") = 8599
		  CharacterReferences.Value("nedot") = 8784
		  CharacterReferences.Value("nequiv") = 8802
		  CharacterReferences.Value("nesear") = 10536
		  CharacterReferences.Value("nesim") = 8770
		  CharacterReferences.Value("nexist") = 8708
		  CharacterReferences.Value("nexists") = 8708
		  CharacterReferences.Value("nfr") = 120107
		  CharacterReferences.Value("ngE") = 8807
		  CharacterReferences.Value("nge") = 8817
		  CharacterReferences.Value("ngeq") = 8817
		  CharacterReferences.Value("ngeqq") = 8807
		  CharacterReferences.Value("ngeqslant") = 10878
		  CharacterReferences.Value("nges") = 10878
		  CharacterReferences.Value("ngsim") = 8821
		  CharacterReferences.Value("ngt") = 8815
		  CharacterReferences.Value("ngtr") = 8815
		  CharacterReferences.Value("nhArr") = 8654
		  CharacterReferences.Value("nharr") = 8622
		  CharacterReferences.Value("nhpar") = 10994
		  CharacterReferences.Value("ni") = 8715
		  CharacterReferences.Value("nis") = 8956
		  CharacterReferences.Value("nisd") = 8954
		  CharacterReferences.Value("niv") = 8715
		  CharacterReferences.Value("njcy") = 1114
		  CharacterReferences.Value("nlArr") = 8653
		  CharacterReferences.Value("nlE") = 8806
		  CharacterReferences.Value("nlarr") = 8602
		  CharacterReferences.Value("nldr") = 8229
		  CharacterReferences.Value("nle") = 8816
		  CharacterReferences.Value("nleftarrow") = 8602
		  CharacterReferences.Value("nleftrightarrow") = 8622
		  CharacterReferences.Value("nleq") = 8816
		  CharacterReferences.Value("nleqq") = 8806
		  CharacterReferences.Value("nleqslant") = 10877
		  CharacterReferences.Value("nles") = 10877
		  CharacterReferences.Value("nless") = 8814
		  CharacterReferences.Value("nlsim") = 8820
		  CharacterReferences.Value("nlt") = 8814
		  CharacterReferences.Value("nltri") = 8938
		  CharacterReferences.Value("nltrie") = 8940
		  CharacterReferences.Value("nmid") = 8740
		  CharacterReferences.Value("nopf") = 120159
		  CharacterReferences.Value("not") = 172
		  CharacterReferences.Value("notin") = 8713
		  CharacterReferences.Value("notinE") = 8953
		  CharacterReferences.Value("notindot") = 8949
		  CharacterReferences.Value("notinva") = 8713
		  CharacterReferences.Value("notinvb") = 8951
		  CharacterReferences.Value("notinvc") = 8950
		  CharacterReferences.Value("notni") = 8716
		  CharacterReferences.Value("notniva") = 8716
		  CharacterReferences.Value("notnivb") = 8958
		  CharacterReferences.Value("notnivc") = 8957
		  CharacterReferences.Value("npar") = 8742
		  CharacterReferences.Value("nparallel") = 8742
		  CharacterReferences.Value("nparsl") = 11005
		  CharacterReferences.Value("npart") = 8706
		  CharacterReferences.Value("npolint") = 10772
		  CharacterReferences.Value("npr") = 8832
		  CharacterReferences.Value("nprcue") = 8928
		  CharacterReferences.Value("npre") = 10927
		  CharacterReferences.Value("nprec") = 8832
		  CharacterReferences.Value("npreceq") = 10927
		  CharacterReferences.Value("nrArr") = 8655
		  CharacterReferences.Value("nrarr") = 8603
		  CharacterReferences.Value("nrarrc") = 10547
		  CharacterReferences.Value("nrarrw") = 8605
		  CharacterReferences.Value("nrightarrow") = 8603
		  CharacterReferences.Value("nrtri") = 8939
		  CharacterReferences.Value("nrtrie") = 8941
		  CharacterReferences.Value("nsc") = 8833
		  CharacterReferences.Value("nsccue") = 8929
		  CharacterReferences.Value("nsce") = 10928
		  CharacterReferences.Value("nscr") = 120003
		  CharacterReferences.Value("nshortmid") = 8740
		  CharacterReferences.Value("nshortparallel") = 8742
		  CharacterReferences.Value("nsim") = 8769
		  CharacterReferences.Value("nsime") = 8772
		  CharacterReferences.Value("nsimeq") = 8772
		  CharacterReferences.Value("nsmid") = 8740
		  CharacterReferences.Value("nspar") = 8742
		  CharacterReferences.Value("nsqsube") = 8930
		  CharacterReferences.Value("nsqsupe") = 8931
		  CharacterReferences.Value("nsub") = 8836
		  CharacterReferences.Value("nsubE") = 10949
		  CharacterReferences.Value("nsube") = 8840
		  CharacterReferences.Value("nsubset") = 8834
		  CharacterReferences.Value("nsubseteq") = 8840
		  CharacterReferences.Value("nsubseteqq") = 10949
		  CharacterReferences.Value("nsucc") = 8833
		  CharacterReferences.Value("nsucceq") = 10928
		  CharacterReferences.Value("nsup") = 8837
		  CharacterReferences.Value("nsupE") = 10950
		  CharacterReferences.Value("nsupe") = 8841
		  CharacterReferences.Value("nsupset") = 8835
		  CharacterReferences.Value("nsupseteq") = 8841
		  CharacterReferences.Value("nsupseteqq") = 10950
		  CharacterReferences.Value("ntgl") = 8825
		  CharacterReferences.Value("ntilde") = 241
		  CharacterReferences.Value("ntlg") = 8824
		  CharacterReferences.Value("ntriangleleft") = 8938
		  CharacterReferences.Value("ntrianglelefteq") = 8940
		  CharacterReferences.Value("ntriangleright") = 8939
		  CharacterReferences.Value("ntrianglerighteq") = 8941
		  CharacterReferences.Value("nu") = 957
		  CharacterReferences.Value("num") = 35
		  CharacterReferences.Value("numero") = 8470
		  CharacterReferences.Value("numsp") = 8199
		  CharacterReferences.Value("nvDash") = 8877
		  CharacterReferences.Value("nvHarr") = 10500
		  CharacterReferences.Value("nvap") = 8781
		  CharacterReferences.Value("nvdash") = 8876
		  CharacterReferences.Value("nvge") = 8805
		  CharacterReferences.Value("nvgt") = 62
		  CharacterReferences.Value("nvinfin") = 10718
		  CharacterReferences.Value("nvlArr") = 10498
		  CharacterReferences.Value("nvle") = 8804
		  CharacterReferences.Value("nvlt") = 60
		  CharacterReferences.Value("nvltrie") = 8884
		  CharacterReferences.Value("nvrArr") = 10499
		  CharacterReferences.Value("nvrtrie") = 8885
		  CharacterReferences.Value("nvsim") = 8764
		  CharacterReferences.Value("nwArr") = 8662
		  CharacterReferences.Value("nwarhk") = 10531
		  CharacterReferences.Value("nwarr") = 8598
		  CharacterReferences.Value("nwarrow") = 8598
		  CharacterReferences.Value("nwnear") = 10535
		  CharacterReferences.Value("oS") = 9416
		  CharacterReferences.Value("oacute") = 243
		  CharacterReferences.Value("oast") = 8859
		  CharacterReferences.Value("ocir") = 8858
		  CharacterReferences.Value("ocirc") = 244
		  CharacterReferences.Value("ocy") = 1086
		  CharacterReferences.Value("odash") = 8861
		  CharacterReferences.Value("odblac") = 337
		  CharacterReferences.Value("odiv") = 10808
		  CharacterReferences.Value("odot") = 8857
		  CharacterReferences.Value("odsold") = 10684
		  CharacterReferences.Value("oelig") = 339
		  CharacterReferences.Value("ofcir") = 10687
		  CharacterReferences.Value("ofr") = 120108
		  CharacterReferences.Value("ogon") = 731
		  CharacterReferences.Value("ograve") = 242
		  CharacterReferences.Value("ogt") = 10689
		  CharacterReferences.Value("ohbar") = 10677
		  CharacterReferences.Value("ohm") = 937
		  CharacterReferences.Value("oint") = 8750
		  CharacterReferences.Value("olarr") = 8634
		  CharacterReferences.Value("olcir") = 10686
		  CharacterReferences.Value("olcross") = 10683
		  CharacterReferences.Value("oline") = 8254
		  CharacterReferences.Value("olt") = 10688
		  CharacterReferences.Value("omacr") = 333
		  CharacterReferences.Value("omega") = 969
		  CharacterReferences.Value("omicron") = 959
		  CharacterReferences.Value("omid") = 10678
		  CharacterReferences.Value("ominus") = 8854
		  CharacterReferences.Value("oopf") = 120160
		  CharacterReferences.Value("opar") = 10679
		  CharacterReferences.Value("operp") = 10681
		  CharacterReferences.Value("oplus") = 8853
		  CharacterReferences.Value("or") = 8744
		  CharacterReferences.Value("orarr") = 8635
		  CharacterReferences.Value("ord") = 10845
		  CharacterReferences.Value("order") = 8500
		  CharacterReferences.Value("orderof") = 8500
		  CharacterReferences.Value("ordf") = 170
		  CharacterReferences.Value("ordm") = 186
		  CharacterReferences.Value("origof") = 8886
		  CharacterReferences.Value("oror") = 10838
		  CharacterReferences.Value("orslope") = 10839
		  CharacterReferences.Value("orv") = 10843
		  CharacterReferences.Value("oscr") = 8500
		  CharacterReferences.Value("oslash") = 248
		  CharacterReferences.Value("osol") = 8856
		  CharacterReferences.Value("otilde") = 245
		  CharacterReferences.Value("otimes") = 8855
		  CharacterReferences.Value("otimesas") = 10806
		  CharacterReferences.Value("ouml") = 246
		  CharacterReferences.Value("ovbar") = 9021
		  CharacterReferences.Value("par") = 8741
		  CharacterReferences.Value("para") = 182
		  CharacterReferences.Value("parallel") = 8741
		  CharacterReferences.Value("parsim") = 10995
		  CharacterReferences.Value("parsl") = 11005
		  CharacterReferences.Value("part") = 8706
		  CharacterReferences.Value("pcy") = 1087
		  CharacterReferences.Value("percnt") = 37
		  CharacterReferences.Value("period") = 46
		  CharacterReferences.Value("permil") = 8240
		  CharacterReferences.Value("perp") = 8869
		  CharacterReferences.Value("pertenk") = 8241
		  CharacterReferences.Value("pfr") = 120109
		  CharacterReferences.Value("phi") = 966
		  CharacterReferences.Value("phiv") = 981
		  CharacterReferences.Value("phmmat") = 8499
		  CharacterReferences.Value("phone") = 9742
		  CharacterReferences.Value("pi") = 960
		  CharacterReferences.Value("pitchfork") = 8916
		  CharacterReferences.Value("piv") = 982
		  CharacterReferences.Value("planck") = 8463
		  CharacterReferences.Value("planckh") = 8462
		  CharacterReferences.Value("plankv") = 8463
		  CharacterReferences.Value("plus") = 43
		  CharacterReferences.Value("plusacir") = 10787
		  CharacterReferences.Value("plusb") = 8862
		  CharacterReferences.Value("pluscir") = 10786
		  CharacterReferences.Value("plusdo") = 8724
		  CharacterReferences.Value("plusdu") = 10789
		  CharacterReferences.Value("pluse") = 10866
		  CharacterReferences.Value("plusmn") = 177
		  CharacterReferences.Value("plussim") = 10790
		  CharacterReferences.Value("plustwo") = 10791
		  CharacterReferences.Value("pm") = 177
		  CharacterReferences.Value("pointint") = 10773
		  CharacterReferences.Value("popf") = 120161
		  CharacterReferences.Value("pound") = 163
		  CharacterReferences.Value("pr") = 8826
		  CharacterReferences.Value("prE") = 10931
		  CharacterReferences.Value("prap") = 10935
		  CharacterReferences.Value("prcue") = 8828
		  CharacterReferences.Value("pre") = 10927
		  CharacterReferences.Value("prec") = 8826
		  CharacterReferences.Value("precapprox") = 10935
		  CharacterReferences.Value("preccurlyeq") = 8828
		  CharacterReferences.Value("preceq") = 10927
		  CharacterReferences.Value("precnapprox") = 10937
		  CharacterReferences.Value("precneqq") = 10933
		  CharacterReferences.Value("precnsim") = 8936
		  CharacterReferences.Value("precsim") = 8830
		  CharacterReferences.Value("prime") = 8242
		  CharacterReferences.Value("primes") = 8473
		  CharacterReferences.Value("prnE") = 10933
		  CharacterReferences.Value("prnap") = 10937
		  CharacterReferences.Value("prnsim") = 8936
		  CharacterReferences.Value("prod") = 8719
		  CharacterReferences.Value("profalar") = 9006
		  CharacterReferences.Value("profline") = 8978
		  CharacterReferences.Value("profsurf") = 8979
		  CharacterReferences.Value("prop") = 8733
		  CharacterReferences.Value("propto") = 8733
		  CharacterReferences.Value("prsim") = 8830
		  CharacterReferences.Value("prurel") = 8880
		  CharacterReferences.Value("pscr") = 120005
		  CharacterReferences.Value("psi") = 968
		  CharacterReferences.Value("puncsp") = 8200
		  CharacterReferences.Value("qfr") = 120110
		  CharacterReferences.Value("qint") = 10764
		  CharacterReferences.Value("qopf") = 120162
		  CharacterReferences.Value("qprime") = 8279
		  CharacterReferences.Value("qscr") = 120006
		  CharacterReferences.Value("quaternions") = 8461
		  CharacterReferences.Value("quatint") = 10774
		  CharacterReferences.Value("quest") = 63
		  CharacterReferences.Value("questeq") = 8799
		  CharacterReferences.Value("quot") = 34
		  CharacterReferences.Value("rAarr") = 8667
		  CharacterReferences.Value("rArr") = 8658
		  CharacterReferences.Value("rAtail") = 10524
		  CharacterReferences.Value("rBarr") = 10511
		  CharacterReferences.Value("rHar") = 10596
		  CharacterReferences.Value("race") = 8765
		  CharacterReferences.Value("racute") = 341
		  CharacterReferences.Value("radic") = 8730
		  CharacterReferences.Value("raemptyv") = 10675
		  CharacterReferences.Value("rang") = 10217
		  CharacterReferences.Value("rangd") = 10642
		  CharacterReferences.Value("range") = 10661
		  CharacterReferences.Value("rangle") = 10217
		  CharacterReferences.Value("raquo") = 187
		  CharacterReferences.Value("rarr") = 8594
		  CharacterReferences.Value("rarrap") = 10613
		  CharacterReferences.Value("rarrb") = 8677
		  CharacterReferences.Value("rarrbfs") = 10528
		  CharacterReferences.Value("rarrc") = 10547
		  CharacterReferences.Value("rarrfs") = 10526
		  CharacterReferences.Value("rarrhk") = 8618
		  CharacterReferences.Value("rarrlp") = 8620
		  CharacterReferences.Value("rarrpl") = 10565
		  CharacterReferences.Value("rarrsim") = 10612
		  CharacterReferences.Value("rarrtl") = 8611
		  CharacterReferences.Value("rarrw") = 8605
		  CharacterReferences.Value("ratail") = 10522
		  CharacterReferences.Value("ratio") = 8758
		  CharacterReferences.Value("rationals") = 8474
		  CharacterReferences.Value("rbarr") = 10509
		  CharacterReferences.Value("rbbrk") = 10099
		  CharacterReferences.Value("rbrace") = 125
		  CharacterReferences.Value("rbrack") = 93
		  CharacterReferences.Value("rbrke") = 10636
		  CharacterReferences.Value("rbrksld") = 10638
		  CharacterReferences.Value("rbrkslu") = 10640
		  CharacterReferences.Value("rcaron") = 345
		  CharacterReferences.Value("rcedil") = 343
		  CharacterReferences.Value("rceil") = 8969
		  CharacterReferences.Value("rcub") = 125
		  CharacterReferences.Value("rcy") = 1088
		  CharacterReferences.Value("rdca") = 10551
		  CharacterReferences.Value("rdldhar") = 10601
		  CharacterReferences.Value("rdquo") = 8221
		  CharacterReferences.Value("rdquor") = 8221
		  CharacterReferences.Value("rdsh") = 8627
		  CharacterReferences.Value("real") = 8476
		  CharacterReferences.Value("realine") = 8475
		  CharacterReferences.Value("realpart") = 8476
		  CharacterReferences.Value("reals") = 8477
		  CharacterReferences.Value("rect") = 9645
		  CharacterReferences.Value("reg") = 174
		  CharacterReferences.Value("rfisht") = 10621
		  CharacterReferences.Value("rfloor") = 8971
		  CharacterReferences.Value("rfr") = 120111
		  CharacterReferences.Value("rhard") = 8641
		  CharacterReferences.Value("rharu") = 8640
		  CharacterReferences.Value("rharul") = 10604
		  CharacterReferences.Value("rho") = 961
		  CharacterReferences.Value("rhov") = 1009
		  CharacterReferences.Value("rightarrow") = 8594
		  CharacterReferences.Value("rightarrowtail") = 8611
		  CharacterReferences.Value("rightharpoondown") = 8641
		  CharacterReferences.Value("rightharpoonup") = 8640
		  CharacterReferences.Value("rightleftarrows") = 8644
		  CharacterReferences.Value("rightleftharpoons") = 8652
		  CharacterReferences.Value("rightrightarrows") = 8649
		  CharacterReferences.Value("rightsquigarrow") = 8605
		  CharacterReferences.Value("rightthreetimes") = 8908
		  CharacterReferences.Value("ring") = 730
		  CharacterReferences.Value("risingdotseq") = 8787
		  CharacterReferences.Value("rlarr") = 8644
		  CharacterReferences.Value("rlhar") = 8652
		  CharacterReferences.Value("rlm") = 8207
		  CharacterReferences.Value("rmoust") = 9137
		  CharacterReferences.Value("rmoustache") = 9137
		  CharacterReferences.Value("rnmid") = 10990
		  CharacterReferences.Value("roang") = 10221
		  CharacterReferences.Value("roarr") = 8702
		  CharacterReferences.Value("robrk") = 10215
		  CharacterReferences.Value("ropar") = 10630
		  CharacterReferences.Value("ropf") = 120163
		  CharacterReferences.Value("roplus") = 10798
		  CharacterReferences.Value("rotimes") = 10805
		  CharacterReferences.Value("rpar") = 41
		  CharacterReferences.Value("rpargt") = 10644
		  CharacterReferences.Value("rppolint") = 10770
		  CharacterReferences.Value("rrarr") = 8649
		  CharacterReferences.Value("rsaquo") = 8250
		  CharacterReferences.Value("rscr") = 120007
		  CharacterReferences.Value("rsh") = 8625
		  CharacterReferences.Value("rsqb") = 93
		  CharacterReferences.Value("rsquo") = 8217
		  CharacterReferences.Value("rsquor") = 8217
		  CharacterReferences.Value("rthree") = 8908
		  CharacterReferences.Value("rtimes") = 8906
		  CharacterReferences.Value("rtri") = 9657
		  CharacterReferences.Value("rtrie") = 8885
		  CharacterReferences.Value("rtrif") = 9656
		  CharacterReferences.Value("rtriltri") = 10702
		  CharacterReferences.Value("ruluhar") = 10600
		  CharacterReferences.Value("rx") = 8478
		  CharacterReferences.Value("sacute") = 347
		  CharacterReferences.Value("sbquo") = 8218
		  CharacterReferences.Value("sc") = 8827
		  CharacterReferences.Value("scE") = 10932
		  CharacterReferences.Value("scap") = 10936
		  CharacterReferences.Value("scaron") = 353
		  CharacterReferences.Value("sccue") = 8829
		  CharacterReferences.Value("sce") = 10928
		  CharacterReferences.Value("scedil") = 351
		  CharacterReferences.Value("scirc") = 349
		  CharacterReferences.Value("scnE") = 10934
		  CharacterReferences.Value("scnap") = 10938
		  CharacterReferences.Value("scnsim") = 8937
		  CharacterReferences.Value("scpolint") = 10771
		  CharacterReferences.Value("scsim") = 8831
		  CharacterReferences.Value("scy") = 1089
		  CharacterReferences.Value("sdot") = 8901
		  CharacterReferences.Value("sdotb") = 8865
		  CharacterReferences.Value("sdote") = 10854
		  CharacterReferences.Value("seArr") = 8664
		  CharacterReferences.Value("searhk") = 10533
		  CharacterReferences.Value("searr") = 8600
		  CharacterReferences.Value("searrow") = 8600
		  CharacterReferences.Value("sect") = 167
		  CharacterReferences.Value("semi") = 59
		  CharacterReferences.Value("seswar") = 10537
		  CharacterReferences.Value("setminus") = 8726
		  CharacterReferences.Value("setmn") = 8726
		  CharacterReferences.Value("sext") = 10038
		  CharacterReferences.Value("sfr") = 120112
		  CharacterReferences.Value("sfrown") = 8994
		  CharacterReferences.Value("sharp") = 9839
		  CharacterReferences.Value("shchcy") = 1097
		  CharacterReferences.Value("shcy") = 1096
		  CharacterReferences.Value("shortmid") = 8739
		  CharacterReferences.Value("shortparallel") = 8741
		  CharacterReferences.Value("shy") = 173
		  CharacterReferences.Value("sigma") = 963
		  CharacterReferences.Value("sigmaf") = 962
		  CharacterReferences.Value("sigmav") = 962
		  CharacterReferences.Value("sim") = 8764
		  CharacterReferences.Value("simdot") = 10858
		  CharacterReferences.Value("sime") = 8771
		  CharacterReferences.Value("simeq") = 8771
		  CharacterReferences.Value("simg") = 10910
		  CharacterReferences.Value("simgE") = 10912
		  CharacterReferences.Value("siml") = 10909
		  CharacterReferences.Value("simlE") = 10911
		  CharacterReferences.Value("simne") = 8774
		  CharacterReferences.Value("simplus") = 10788
		  CharacterReferences.Value("simrarr") = 10610
		  CharacterReferences.Value("slarr") = 8592
		  CharacterReferences.Value("smallsetminus") = 8726
		  CharacterReferences.Value("smashp") = 10803
		  CharacterReferences.Value("smeparsl") = 10724
		  CharacterReferences.Value("smid") = 8739
		  CharacterReferences.Value("smile") = 8995
		  CharacterReferences.Value("smt") = 10922
		  CharacterReferences.Value("smte") = 10924
		  CharacterReferences.Value("smtes") = 10924
		  CharacterReferences.Value("softcy") = 1100
		  CharacterReferences.Value("sol") = 47
		  CharacterReferences.Value("solb") = 10692
		  CharacterReferences.Value("solbar") = 9023
		  CharacterReferences.Value("sopf") = 120164
		  CharacterReferences.Value("spades") = 9824
		  CharacterReferences.Value("spadesuit") = 9824
		  CharacterReferences.Value("spar") = 8741
		  CharacterReferences.Value("sqcap") = 8851
		  CharacterReferences.Value("sqcaps") = 8851
		  CharacterReferences.Value("sqcup") = 8852
		  CharacterReferences.Value("sqcups") = 8852
		  CharacterReferences.Value("sqsub") = 8847
		  CharacterReferences.Value("sqsube") = 8849
		  CharacterReferences.Value("sqsubset") = 8847
		  CharacterReferences.Value("sqsubseteq") = 8849
		  CharacterReferences.Value("sqsup") = 8848
		  CharacterReferences.Value("sqsupe") = 8850
		  CharacterReferences.Value("sqsupset") = 8848
		  CharacterReferences.Value("sqsupseteq") = 8850
		  CharacterReferences.Value("squ") = 9633
		  CharacterReferences.Value("square") = 9633
		  CharacterReferences.Value("squarf") = 9642
		  CharacterReferences.Value("squf") = 9642
		  CharacterReferences.Value("srarr") = 8594
		  CharacterReferences.Value("sscr") = 120008
		  CharacterReferences.Value("ssetmn") = 8726
		  CharacterReferences.Value("ssmile") = 8995
		  CharacterReferences.Value("sstarf") = 8902
		  CharacterReferences.Value("star") = 9734
		  CharacterReferences.Value("starf") = 9733
		  CharacterReferences.Value("straightepsilon") = 1013
		  CharacterReferences.Value("straightphi") = 981
		  CharacterReferences.Value("strns") = 175
		  CharacterReferences.Value("sub") = 8834
		  CharacterReferences.Value("subE") = 10949
		  CharacterReferences.Value("subdot") = 10941
		  CharacterReferences.Value("sube") = 8838
		  CharacterReferences.Value("subedot") = 10947
		  CharacterReferences.Value("submult") = 10945
		  CharacterReferences.Value("subnE") = 10955
		  CharacterReferences.Value("subne") = 8842
		  CharacterReferences.Value("subplus") = 10943
		  CharacterReferences.Value("subrarr") = 10617
		  CharacterReferences.Value("subset") = 8834
		  CharacterReferences.Value("subseteq") = 8838
		  CharacterReferences.Value("subseteqq") = 10949
		  CharacterReferences.Value("subsetneq") = 8842
		  CharacterReferences.Value("subsetneqq") = 10955
		  CharacterReferences.Value("subsim") = 10951
		  CharacterReferences.Value("subsub") = 10965
		  CharacterReferences.Value("subsup") = 10963
		  CharacterReferences.Value("succ") = 8827
		  CharacterReferences.Value("succapprox") = 10936
		  CharacterReferences.Value("succcurlyeq") = 8829
		  CharacterReferences.Value("succeq") = 10928
		  CharacterReferences.Value("succnapprox") = 10938
		  CharacterReferences.Value("succneqq") = 10934
		  CharacterReferences.Value("succnsim") = 8937
		  CharacterReferences.Value("succsim") = 8831
		  CharacterReferences.Value("sum") = 8721
		  CharacterReferences.Value("sung") = 9834
		  CharacterReferences.Value("sup1") = 185
		  CharacterReferences.Value("sup2") = 178
		  CharacterReferences.Value("sup3") = 179
		  CharacterReferences.Value("sup") = 8835
		  CharacterReferences.Value("supE") = 10950
		  CharacterReferences.Value("supdot") = 10942
		  CharacterReferences.Value("supdsub") = 10968
		  CharacterReferences.Value("supe") = 8839
		  CharacterReferences.Value("supedot") = 10948
		  CharacterReferences.Value("suphsol") = 10185
		  CharacterReferences.Value("suphsub") = 10967
		  CharacterReferences.Value("suplarr") = 10619
		  CharacterReferences.Value("supmult") = 10946
		  CharacterReferences.Value("supnE") = 10956
		  CharacterReferences.Value("supne") = 8843
		  CharacterReferences.Value("supplus") = 10944
		  CharacterReferences.Value("supset") = 8835
		  CharacterReferences.Value("supseteq") = 8839
		  CharacterReferences.Value("supseteqq") = 10950
		  CharacterReferences.Value("supsetneq") = 8843
		  CharacterReferences.Value("supsetneqq") = 10956
		  CharacterReferences.Value("supsim") = 10952
		  CharacterReferences.Value("supsub") = 10964
		  CharacterReferences.Value("supsup") = 10966
		  CharacterReferences.Value("swArr") = 8665
		  CharacterReferences.Value("swarhk") = 10534
		  CharacterReferences.Value("swarr") = 8601
		  CharacterReferences.Value("swarrow") = 8601
		  CharacterReferences.Value("swnwar") = 10538
		  CharacterReferences.Value("szlig") = 223
		  CharacterReferences.Value("target") = 8982
		  CharacterReferences.Value("tau") = 964
		  CharacterReferences.Value("tbrk") = 9140
		  CharacterReferences.Value("tcaron") = 357
		  CharacterReferences.Value("tcedil") = 355
		  CharacterReferences.Value("tcy") = 1090
		  CharacterReferences.Value("tdot") = 8411
		  CharacterReferences.Value("telrec") = 8981
		  CharacterReferences.Value("tfr") = 120113
		  CharacterReferences.Value("there4") = 8756
		  CharacterReferences.Value("therefore") = 8756
		  CharacterReferences.Value("theta") = 952
		  CharacterReferences.Value("thetasym") = 977
		  CharacterReferences.Value("thetav") = 977
		  CharacterReferences.Value("thickapprox") = 8776
		  CharacterReferences.Value("thicksim") = 8764
		  CharacterReferences.Value("thinsp") = 8201
		  CharacterReferences.Value("thkap") = 8776
		  CharacterReferences.Value("thksim") = 8764
		  CharacterReferences.Value("thorn") = 254
		  CharacterReferences.Value("tilde") = 732
		  CharacterReferences.Value("times") = 215
		  CharacterReferences.Value("timesb") = 8864
		  CharacterReferences.Value("timesbar") = 10801
		  CharacterReferences.Value("timesd") = 10800
		  CharacterReferences.Value("tint") = 8749
		  CharacterReferences.Value("toea") = 10536
		  CharacterReferences.Value("top") = 8868
		  CharacterReferences.Value("topbot") = 9014
		  CharacterReferences.Value("topcir") = 10993
		  CharacterReferences.Value("topf") = 120165
		  CharacterReferences.Value("topfork") = 10970
		  CharacterReferences.Value("tosa") = 10537
		  CharacterReferences.Value("tprime") = 8244
		  CharacterReferences.Value("trade") = 8482
		  CharacterReferences.Value("triangle") = 9653
		  CharacterReferences.Value("triangledown") = 9663
		  CharacterReferences.Value("triangleleft") = 9667
		  CharacterReferences.Value("trianglelefteq") = 8884
		  CharacterReferences.Value("triangleq") = 8796
		  CharacterReferences.Value("triangleright") = 9657
		  CharacterReferences.Value("trianglerighteq") = 8885
		  CharacterReferences.Value("tridot") = 9708
		  CharacterReferences.Value("trie") = 8796
		  CharacterReferences.Value("triminus") = 10810
		  CharacterReferences.Value("triplus") = 10809
		  CharacterReferences.Value("trisb") = 10701
		  CharacterReferences.Value("tritime") = 10811
		  CharacterReferences.Value("trpezium") = 9186
		  CharacterReferences.Value("tscr") = 120009
		  CharacterReferences.Value("tscy") = 1094
		  CharacterReferences.Value("tshcy") = 1115
		  CharacterReferences.Value("tstrok") = 359
		  CharacterReferences.Value("twixt") = 8812
		  CharacterReferences.Value("twoheadleftarrow") = 8606
		  CharacterReferences.Value("twoheadrightarrow") = 8608
		  CharacterReferences.Value("uArr") = 8657
		  CharacterReferences.Value("uHar") = 10595
		  CharacterReferences.Value("uacute") = 250
		  CharacterReferences.Value("uarr") = 8593
		  CharacterReferences.Value("ubrcy") = 1118
		  CharacterReferences.Value("ubreve") = 365
		  CharacterReferences.Value("ucirc") = 251
		  CharacterReferences.Value("ucy") = 1091
		  CharacterReferences.Value("udarr") = 8645
		  CharacterReferences.Value("udblac") = 369
		  CharacterReferences.Value("udhar") = 10606
		  CharacterReferences.Value("ufisht") = 10622
		  CharacterReferences.Value("ufr") = 120114
		  CharacterReferences.Value("ugrave") = 249
		  CharacterReferences.Value("uharl") = 8639
		  CharacterReferences.Value("uharr") = 8638
		  CharacterReferences.Value("uhblk") = 9600
		  CharacterReferences.Value("ulcorn") = 8988
		  CharacterReferences.Value("ulcorner") = 8988
		  CharacterReferences.Value("ulcrop") = 8975
		  CharacterReferences.Value("ultri") = 9720
		  CharacterReferences.Value("umacr") = 363
		  CharacterReferences.Value("uml") = 168
		  CharacterReferences.Value("uogon") = 371
		  CharacterReferences.Value("uopf") = 120166
		  CharacterReferences.Value("uparrow") = 8593
		  CharacterReferences.Value("updownarrow") = 8597
		  CharacterReferences.Value("upharpoonleft") = 8639
		  CharacterReferences.Value("upharpoonright") = 8638
		  CharacterReferences.Value("uplus") = 8846
		  CharacterReferences.Value("upsi") = 965
		  CharacterReferences.Value("upsih") = 978
		  CharacterReferences.Value("upsilon") = 965
		  CharacterReferences.Value("upuparrows") = 8648
		  CharacterReferences.Value("urcorn") = 8989
		  CharacterReferences.Value("urcorner") = 8989
		  CharacterReferences.Value("urcrop") = 8974
		  CharacterReferences.Value("uring") = 367
		  CharacterReferences.Value("urtri") = 9721
		  CharacterReferences.Value("uscr") = 120010
		  CharacterReferences.Value("utdot") = 8944
		  CharacterReferences.Value("utilde") = 361
		  CharacterReferences.Value("utri") = 9653
		  CharacterReferences.Value("utrif") = 9652
		  CharacterReferences.Value("uuarr") = 8648
		  CharacterReferences.Value("uuml") = 252
		  CharacterReferences.Value("uwangle") = 10663
		  CharacterReferences.Value("vArr") = 8661
		  CharacterReferences.Value("vBar") = 10984
		  CharacterReferences.Value("vBarv") = 10985
		  CharacterReferences.Value("vDash") = 8872
		  CharacterReferences.Value("vangrt") = 10652
		  CharacterReferences.Value("varepsilon") = 1013
		  CharacterReferences.Value("varkappa") = 1008
		  CharacterReferences.Value("varnothing") = 8709
		  CharacterReferences.Value("varphi") = 981
		  CharacterReferences.Value("varpi") = 982
		  CharacterReferences.Value("varpropto") = 8733
		  CharacterReferences.Value("varr") = 8597
		  CharacterReferences.Value("varrho") = 1009
		  CharacterReferences.Value("varsigma") = 962
		  CharacterReferences.Value("varsubsetneq") = 8842
		  CharacterReferences.Value("varsubsetneqq") = 10955
		  CharacterReferences.Value("varsupsetneq") = 8843
		  CharacterReferences.Value("varsupsetneqq") = 10956
		  CharacterReferences.Value("vartheta") = 977
		  CharacterReferences.Value("vartriangleleft") = 8882
		  CharacterReferences.Value("vartriangleright") = 8883
		  CharacterReferences.Value("vcy") = 1074
		  CharacterReferences.Value("vdash") = 8866
		  CharacterReferences.Value("vee") = 8744
		  CharacterReferences.Value("veebar") = 8891
		  CharacterReferences.Value("veeeq") = 8794
		  CharacterReferences.Value("vellip") = 8942
		  CharacterReferences.Value("verbar") = 124
		  CharacterReferences.Value("vert") = 124
		  CharacterReferences.Value("vfr") = 120115
		  CharacterReferences.Value("vltri") = 8882
		  CharacterReferences.Value("vnsub") = 8834
		  CharacterReferences.Value("vnsup") = 8835
		  CharacterReferences.Value("vopf") = 120167
		  CharacterReferences.Value("vprop") = 8733
		  CharacterReferences.Value("vrtri") = 8883
		  CharacterReferences.Value("vscr") = 120011
		  CharacterReferences.Value("vsubnE") = 10955
		  CharacterReferences.Value("vsubne") = 8842
		  CharacterReferences.Value("vsupnE") = 10956
		  CharacterReferences.Value("vsupne") = 8843
		  CharacterReferences.Value("vzigzag") = 10650
		  CharacterReferences.Value("wcirc") = 373
		  CharacterReferences.Value("wedbar") = 10847
		  CharacterReferences.Value("wedge") = 8743
		  CharacterReferences.Value("wedgeq") = 8793
		  CharacterReferences.Value("weierp") = 8472
		  CharacterReferences.Value("wfr") = 120116
		  CharacterReferences.Value("wopf") = 120168
		  CharacterReferences.Value("wp") = 8472
		  CharacterReferences.Value("wr") = 8768
		  CharacterReferences.Value("wreath") = 8768
		  CharacterReferences.Value("wscr") = 120012
		  CharacterReferences.Value("xcap") = 8898
		  CharacterReferences.Value("xcirc") = 9711
		  CharacterReferences.Value("xcup") = 8899
		  CharacterReferences.Value("xdtri") = 9661
		  CharacterReferences.Value("xfr") = 120117
		  CharacterReferences.Value("xhArr") = 10234
		  CharacterReferences.Value("xharr") = 10231
		  CharacterReferences.Value("xi") = 958
		  CharacterReferences.Value("xlArr") = 10232
		  CharacterReferences.Value("xlarr") = 10229
		  CharacterReferences.Value("xmap") = 10236
		  CharacterReferences.Value("xnis") = 8955
		  CharacterReferences.Value("xodot") = 10752
		  CharacterReferences.Value("xopf") = 120169
		  CharacterReferences.Value("xoplus") = 10753
		  CharacterReferences.Value("xotime") = 10754
		  CharacterReferences.Value("xrArr") = 10233
		  CharacterReferences.Value("xrarr") = 10230
		  CharacterReferences.Value("xscr") = 120013
		  CharacterReferences.Value("xsqcup") = 10758
		  CharacterReferences.Value("xuplus") = 10756
		  CharacterReferences.Value("xutri") = 9651
		  CharacterReferences.Value("xvee") = 8897
		  CharacterReferences.Value("xwedge") = 8896
		  CharacterReferences.Value("yacute") = 253
		  CharacterReferences.Value("yacy") = 1103
		  CharacterReferences.Value("ycirc") = 375
		  CharacterReferences.Value("ycy") = 1099
		  CharacterReferences.Value("yen") = 165
		  CharacterReferences.Value("yfr") = 120118
		  CharacterReferences.Value("yicy") = 1111
		  CharacterReferences.Value("yopf") = 120170
		  CharacterReferences.Value("yscr") = 120014
		  CharacterReferences.Value("yucy") = 1102
		  CharacterReferences.Value("yuml") = 255
		  CharacterReferences.Value("zacute") = 378
		  CharacterReferences.Value("zcaron") = 382
		  CharacterReferences.Value("zcy") = 1079
		  CharacterReferences.Value("zdot") = 380
		  CharacterReferences.Value("zeetrf") = 8488
		  CharacterReferences.Value("zeta") = 950
		  CharacterReferences.Value("zfr") = 120119
		  CharacterReferences.Value("zhcy") = 1078
		  CharacterReferences.Value("zigrarr") = 8669
		  CharacterReferences.Value("zopf") = 120171
		  CharacterReferences.Value("zscr") = 120015
		  CharacterReferences.Value("zwj") = 8205
		  CharacterReferences.Value("zwnj") = 8204
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsASCIIAlphaChar(c As String) As Boolean
		  // Returns True if the passed character `c` is A-Z or a-z.
		  
		  Select Case Asc(c)
		  Case 65 To 90, 97 To 122
		    Return True
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsDigit(c As String) As Boolean
		  // Returns True if the passed character `c` a digit 0-9.
		  
		  Select Case Asc(c)
		  Case 48 To 57
		    Return True
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsHexDigit(c As String) As Boolean
		  // Returns True if the passed character `c` is A-F, a-f or 0-9.
		  
		  Select Case Asc(c)
		  Case 65 To 70, 97 To 102, 48 To 57
		    Return True
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsPunctuation(char As String) As Boolean
		  Select Case char
		  Case "!", """", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", _
		    "/", ":", ";", "<", "=", ">", "?", "@", "[", "\", "]", "^", "_", "`", _
		    "{", "|", "}", "~"
		    Return True
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsUppercaseASCIIChar(c As String) As Boolean
		  // Returns True if the passed character `c` is an uppercase ASCII character.
		  
		  Select Case Asc(c)
		  Case 65 To 90
		    Return True
		  Else
		    Return False
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsWhitespace(char As String, nonBreakingSpaceIsWhitespace As Boolean = False) As Boolean
		  // Returns True if the passed character is whitespace.
		  // If the optional `nonBreakingSpaceIsWhitespace` is True then we also 
		  // consider a non-breaking space (&u0A0) to be whitespace.
		  
		  Select Case char
		  Case &u0020, &u0009, &u000A, ""
		    Return True
		  Else
		    If nonBreakingSpaceIsWhitespace And char = &u00A0 Then
		      Return True
		    Else
		      Return False
		    End If
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub ReplaceEntities(chars() As String)
		  // Scans the characters in the passed array of characters for valid entity and numeric character 
		  // references.
		  // If one is found, the characters representing the reference are replaced with the 
		  // corresponding unicode character.
		  // The document https://html.spec.whatwg.org/multipage/entities.json is used as an authoritative 
		  // source for the valid entity references and their corresponding code points.
		  
		  // Entity reference: 
		  // "&", a valid HTML5 entity name, ";"
		  
		  // Decimal numeric character reference:
		  // &#[0-9]{1–7};
		  
		  // Hexadecimal numeric character reference:
		  // &#[Xx][a-fA-F0-9]{1-6};
		  
		  #If Not TargetWeb
		    #Pragma DisableBackgroundTasks
		  #Endif
		  #Pragma DisableBoundsChecking
		  #Pragma StackOverflowChecking False
		  
		  // Quick check to see if we can bail early.
		  Dim start As Integer = chars.IndexOf("&")
		  If start = -1 Or chars.IndexOf(";") = -1 Then Return
		  
		  Dim c As String
		  Dim tmp() As String
		  Dim i As Integer = start
		  Dim xLimit As Integer
		  Dim codePoint As Integer
		  Dim seenSemiColon As Boolean = False
		  While i < chars.LastIndex
		    Redim tmp(-1)
		    seenSemiColon = False
		    c = chars(i)
		    
		    // Expect an unescaped "&".
		    If chars(i) <> "&" Then Return
		    If Utilities.Escaped(chars, i) Then
		      i = i + 1
		      If i > chars.LastIndex Then Return
		      // Any other potential references?
		      start = chars.IndexOf("&", i)
		      If start = -1 Then
		        Return
		      Else
		        i = start
		      End If
		    End If
		    
		    i = i + 1
		    If i > chars.LastIndex Then Return
		    c = chars(i)
		    
		    If c = "#" Then
		      i = i + 1
		      If i > chars.LastIndex Then Return
		      c = chars(i)
		      
		      If c = "X" Then
		        // ========== HEX REFERENCE? ==========
		        xLimit = Xojo.Math.Min(chars.LastIndex, i + 7)
		        If i + 1 > chars.LastIndex Then Return
		        For x As Integer = i + 1 To xLimit
		          c = chars(x)
		          If Utilities.IsHexDigit(c) Then
		            tmp.Add(c)
		          ElseIf c = ";" Then
		            seenSemiColon = True
		            Exit
		          Else
		            // Any other potential references?
		            start = chars.IndexOf("&", x)
		            If start = -1 Then
		              Return
		            Else
		              i = start
		              Continue While
		            End If
		          End If
		        Next x
		        If seenSemiColon And tmp.LastIndex > -1 Then
		          // `tmp` contains the hex value of the codepoint.
		          // Remove the characters in `chars` that make up this reference.
		          For x As Integer = 1 To tmp.LastIndex + 5
		            chars.RemoveAt(start)
		          Next x
		          chars.AddAt(start, Text.FromUnicodeCodepoint(Integer.FromHex(String.FromArray(tmp, "").ToText)))
		          // Any other potential references?
		          i = start + 1
		          If i > chars.LastIndex Then Return
		          start = chars.IndexOf("&", i)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        Else
		          // Any other potential references?
		          i = i + 1
		          If i > chars.LastIndex Then Return
		          start = chars.IndexOf("&", i)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        End If
		        
		        // Any other potential references?
		        start = chars.IndexOf("&")
		        If start = -1 Then
		          Return
		        Else
		          i = start
		          Continue While
		        End If
		      ElseIf Utilities.IsDigit(c) Then
		        // ========== DECIMAL REFERENCE? ==========
		        xLimit = Xojo.Math.Min(chars.LastIndex, i + 6)
		        If i + 1 > chars.LastIndex Then Return
		        For x As Integer = i To xLimit
		          c = chars(x)
		          If Utilities.IsDigit(c) Then
		            tmp.Add(c)
		          ElseIf c = ";" Then
		            seenSemiColon = True
		            Exit
		          Else
		            // Any other potential references?
		            start = chars.IndexOf("&", x)
		            If start = -1 Then
		              Return
		            Else
		              i = start
		              Continue While
		            End If
		          End If
		        Next x
		        
		        If seenSemiColon And tmp.LastIndex > -1 Then
		          // `tmp` contains the decimal value of the codepoint.
		          // Remove the characters in `chars` that make up this reference.
		          For x As Integer = 1 To tmp.LastIndex + 4
		            chars.RemoveAt(start)
		          Next x
		          codePoint = Val(String.FromArray(tmp, ""))
		          // For security reasons, the code point U+0000 is replaced by U+FFFD.
		          If codePoint = 0 Then codePoint = &hFFFD
		          chars.AddAt(start, Text.FromUnicodeCodepoint(codePoint))
		          // Any other potential references?
		          i = start + 1
		          If i > chars.LastIndex Then Return
		          start = chars.IndexOf("&", i)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        Else
		          // Any other potential references?
		          i = i + 1
		          If i > chars.LastIndex Then Return
		          start = chars.IndexOf("&", i)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        End If
		        
		      Else
		        start = chars.IndexOf("&", i)
		        If start = -1 Then
		          Return
		        Else
		          i = start
		          Continue While
		        End If
		      End If
		      
		    ElseIf Utilities.IsASCIIAlphaChar(c) Or Utilities.IsDigit(c) Then
		      // ========== ENTITY REFERENCE? ==========
		      // The longest entity reference is 31 characters.
		      xLimit = Xojo.Math.Min(chars.LastIndex, i + 30)
		      If i + 1 > chars.LastIndex Then Return
		      For x As Integer = i To xLimit
		        c = chars(x)
		        If Utilities.IsASCIIAlphaChar(c) Or Utilities.IsDigit(c) Then
		          tmp.Add(c)
		        ElseIf c = ";" Then
		          seenSemiColon = True
		          Exit
		        Else
		          // Any other potential references?
		          start = chars.IndexOf("&", x)
		          If start = -1 Then
		            Return
		          Else
		            i = start
		            Continue While
		          End If
		        End If
		      Next x
		      If Not seenSemiColon Then Return
		      // `tmp` contains the HTML entity reference name.
		      // Is this a valid entity name?
		      Dim entityName As Text = String.FromArray(tmp, "").ToText // Must be text for correct case-sensitive lookup.
		      If CharacterReferences.HasKey(entityName) Then
		        // Remove the characters in `chars` that make up this reference.
		        For x As Integer = 1 To tmp.LastIndex + 3
		          chars.RemoveAt(start)
		        Next x
		        chars.AddAt(start, Text.FromUnicodeCodepoint(CharacterReferences.Value(entityName)))
		      End If
		      
		      // Any other potential references?
		      i = start + 1
		      If i > chars.LastIndex Then Return
		      start = chars.IndexOf("&", i)
		      If start = -1 Then
		        Return
		      Else
		        i = start
		        Continue While
		      End If
		      
		    Else
		      // Any other potential references?
		      start = chars.IndexOf("&", i)
		      If start = -1 Then
		        Return
		      Else
		        i = start
		      End If
		    End If
		    
		  Wend
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function ReplaceEntities(t As String) As String
		  If t.IndexOf("&") = -1 Or t.IndexOf(";") = -1 Then
		    Return t
		  Else
		    Dim tmp() As String = t.Split("")
		    Utilities.ReplaceEntities(tmp)
		    Return String.FromArray(tmp, "")
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub Unescape(ByRef t As String)
		  // Converts backslash escaped characters in the passed Text object to their 
		  // literal character value.
		  // Mutates the original value.
		  
		  If t.IndexOf("\") = -1 Then Return
		  
		  Dim chars() As String = t.Split("")
		  Dim pos As Integer = 0
		  Dim c As String
		  Do Until pos > chars.LastIndex
		    c = chars(pos)
		    If c = "\" And pos < chars.LastIndex And _
		      MarkdownKit.IsEscapable(chars(pos + 1)) Then
		      // Remove the backslash from the array.
		      chars.RemoveAt(pos)
		    End If
		    pos = pos + 1
		  Loop
		  
		  t = String.FromArray(chars, "")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub Unescape(chars() As String)
		  // Converts backslash escaped characters to their literal character value.
		  // Mutates alters the passed array.
		  
		  If chars.IndexOf("\") = -1 Then Return
		  
		  Dim pos As Integer = 0
		  Dim c As String
		  Do Until pos > chars.LastIndex
		    c = chars(pos)
		    If c = "\" And pos < chars.LastIndex And _
		      MarkdownKit.IsEscapable(chars(pos + 1)) Then
		      // Remove the backslash from the array.
		      chars.RemoveAt(pos)
		    End If
		    pos = pos + 1
		  Loop
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Shared CharacterReferences As Xojo.Core.Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared mInitialised As Boolean = False
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
