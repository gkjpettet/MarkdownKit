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
		  
		  // Performing any operation on `CharacterReferences` will create it.
		  Call CharacterReferences.KeyCount
		  
		  mInitialised = True
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320612064696374696F6E61727920636F6E7461696E696E6720746865207265636F676E697365642048544D4C20656E74697479207265666572656E63657320616E6420746865697220636F72726573706F6E64696E6720556E69636F646520636F6465706F696E74732E
		Private Shared Function InitialiseCharacterReferences() As Dictionary
		  // Returns a dictionary containing the recognised HTML entity 
		  /// references and their corresponding Unicode codepoints.
		  
		  Var d As Dictionary = ParseJSON("{}") // Case-sensitive.
		  
		  d.Value("AElig") = 198
		  d.Value("AMP") = 38
		  d.Value("Aacute") = 193
		  d.Value("Abreve") = 258
		  d.Value("Acirc") = 194
		  d.Value("Acy") = 1040
		  d.Value("Afr") = 120068
		  d.Value("Agrave") = 192
		  d.Value("Alpha") = 913
		  d.Value("Amacr") = 256
		  d.Value("And") = 10835
		  d.Value("Aogon") = 260
		  d.Value("Aopf") = 120120
		  d.Value("ApplyFunction") = 8289
		  d.Value("Aring") = 197
		  d.Value("Ascr") = 119964
		  d.Value("Assign") = 8788
		  d.Value("Atilde") = 195
		  d.Value("Auml") = 196
		  d.Value("Backslash") = 8726
		  d.Value("Barv") = 10983
		  d.Value("Barwed") = 8966
		  d.Value("Bcy") = 1041
		  d.Value("Because") = 8757
		  d.Value("Bernoullis") = 8492
		  d.Value("Beta") = 914
		  d.Value("Bfr") = 120069
		  d.Value("Bopf") = 120121
		  d.Value("Breve") = 728
		  d.Value("Bscr") = 8492
		  d.Value("Bumpeq") = 8782
		  d.Value("CHcy") = 1063
		  d.Value("COPY") = 169
		  d.Value("Cacute") = 262
		  d.Value("Cap") = 8914
		  d.Value("CapitalDifferentialD") = 8517
		  d.Value("Cayleys") = 8493
		  d.Value("Ccaron") = 268
		  d.Value("Ccedil") = 199
		  d.Value("Ccirc") = 264
		  d.Value("Cconint") = 8752
		  d.Value("Cdot") = 266
		  d.Value("Cedilla") = 184
		  d.Value("CenterDot") = 183
		  d.Value("Cfr") = 8493
		  d.Value("Chi") = 935
		  d.Value("CircleDot") = 8857
		  d.Value("CircleMinus") = 8854
		  d.Value("CirclePlus") = 8853
		  d.Value("CircleTimes") = 8855
		  d.Value("ClockwiseContourIntegral") = 8754
		  d.Value("CloseCurlyDoubleQuote") = 8221
		  d.Value("CloseCurlyQuote") = 8217
		  d.Value("Colon") = 8759
		  d.Value("Colone") = 10868
		  d.Value("Congruent") = 8801
		  d.Value("Conint") = 8751
		  d.Value("ContourIntegral") = 8750
		  d.Value("Copf") = 8450
		  d.Value("Coproduct") = 8720
		  d.Value("CounterClockwiseContourIntegral") = 8755
		  d.Value("Cross") = 10799
		  d.Value("Cscr") = 119966
		  d.Value("Cup") = 8915
		  d.Value("CupCap") = 8781
		  d.Value("DD") = 8517
		  d.Value("DDotrahd") = 10513
		  d.Value("DJcy") = 1026
		  d.Value("DScy") = 1029
		  d.Value("DZcy") = 1039
		  d.Value("Dagger") = 8225
		  d.Value("Darr") = 8609
		  d.Value("Dashv") = 10980
		  d.Value("Dcaron") = 270
		  d.Value("Dcy") = 1044
		  d.Value("Del") = 8711
		  d.Value("Delta") = 916
		  d.Value("Dfr") = 120071
		  d.Value("DiacriticalAcute") = 180
		  d.Value("DiacriticalDot") = 729
		  d.Value("DiacriticalDoubleAcute") = 733
		  d.Value("DiacriticalGrave") = 96
		  d.Value("DiacriticalTilde") = 732
		  d.Value("Diamond") = 8900
		  d.Value("DifferentialD") = 8518
		  d.Value("Dopf") = 120123
		  d.Value("Dot") = 168
		  d.Value("DotDot") = 8412
		  d.Value("DotEqual") = 8784
		  d.Value("DoubleContourIntegral") = 8751
		  d.Value("DoubleDot") = 168
		  d.Value("DoubleDownArrow") = 8659
		  d.Value("DoubleLeftArrow") = 8656
		  d.Value("DoubleLeftRightArrow") = 8660
		  d.Value("DoubleLeftTee") = 10980
		  d.Value("DoubleLongLeftArrow") = 10232
		  d.Value("DoubleLongLeftRightArrow") = 10234
		  d.Value("DoubleLongRightArrow") = 10233
		  d.Value("DoubleRightArrow") = 8658
		  d.Value("DoubleRightTee") = 8872
		  d.Value("DoubleUpArrow") = 8657
		  d.Value("DoubleUpDownArrow") = 8661
		  d.Value("DoubleVerticalBar") = 8741
		  d.Value("DownArrow") = 8595
		  d.Value("DownArrowBar") = 10515
		  d.Value("DownArrowUpArrow") = 8693
		  d.Value("DownBreve") = 785
		  d.Value("DownLeftRightVector") = 10576
		  d.Value("DownLeftTeeVector") = 10590
		  d.Value("DownLeftVector") = 8637
		  d.Value("DownLeftVectorBar") = 10582
		  d.Value("DownRightTeeVector") = 10591
		  d.Value("DownRightVector") = 8641
		  d.Value("DownRightVectorBar") = 10583
		  d.Value("DownTee") = 8868
		  d.Value("DownTeeArrow") = 8615
		  d.Value("Downarrow") = 8659
		  d.Value("Dscr") = 119967
		  d.Value("Dstrok") = 272
		  d.Value("ENG") = 330
		  d.Value("ETH") = 208
		  d.Value("Eacute") = 201
		  d.Value("Ecaron") = 282
		  d.Value("Ecirc") = 202
		  d.Value("Ecy") = 1069
		  d.Value("Edot") = 278
		  d.Value("Efr") = 120072
		  d.Value("Egrave") = 200
		  d.Value("Element") = 8712
		  d.Value("Emacr") = 274
		  d.Value("EmptySmallSquare") = 9723
		  d.Value("EmptyVerySmallSquare") = 9643
		  d.Value("Eogon") = 280
		  d.Value("Eopf") = 120124
		  d.Value("Epsilon") = 917
		  d.Value("Equal") = 10869
		  d.Value("EqualTilde") = 8770
		  d.Value("Equilibrium") = 8652
		  d.Value("Escr") = 8496
		  d.Value("Esim") = 10867
		  d.Value("Eta") = 919
		  d.Value("Euml") = 203
		  d.Value("Exists") = 8707
		  d.Value("ExponentialE") = 8519
		  d.Value("Fcy") = 1060
		  d.Value("Ffr") = 120073
		  d.Value("FilledSmallSquare") = 9724
		  d.Value("FilledVerySmallSquare") = 9642
		  d.Value("Fopf") = 120125
		  d.Value("ForAll") = 8704
		  d.Value("Fouriertrf") = 8497
		  d.Value("Fscr") = 8497
		  d.Value("GJcy") = 1027
		  d.Value("GT") = 62
		  d.Value("Gamma") = 915
		  d.Value("Gammad") = 988
		  d.Value("Gbreve") = 286
		  d.Value("Gcedil") = 290
		  d.Value("Gcirc") = 284
		  d.Value("Gcy") = 1043
		  d.Value("Gdot") = 288
		  d.Value("Gfr") = 120074
		  d.Value("Gg") = 8921
		  d.Value("Gopf") = 120126
		  d.Value("GreaterEqual") = 8805
		  d.Value("GreaterEqualLess") = 8923
		  d.Value("GreaterFullEqual") = 8807
		  d.Value("GreaterGreater") = 10914
		  d.Value("GreaterLess") = 8823
		  d.Value("GreaterSlantEqual") = 10878
		  d.Value("GreaterTilde") = 8819
		  d.Value("Gscr") = 119970
		  d.Value("Gt") = 8811
		  d.Value("HARDcy") = 1066
		  d.Value("Hacek") = 711
		  d.Value("Hat") = 94
		  d.Value("Hcirc") = 292
		  d.Value("Hfr") = 8460
		  d.Value("HilbertSpace") = 8459
		  d.Value("Hopf") = 8461
		  d.Value("HorizontalLine") = 9472
		  d.Value("Hscr") = 8459
		  d.Value("Hstrok") = 294
		  d.Value("HumpDownHump") = 8782
		  d.Value("HumpEqual") = 8783
		  d.Value("IEcy") = 1045
		  d.Value("IJlig") = 306
		  d.Value("IOcy") = 1025
		  d.Value("Iacute") = 205
		  d.Value("Icirc") = 206
		  d.Value("Icy") = 1048
		  d.Value("Idot") = 304
		  d.Value("Ifr") = 8465
		  d.Value("Igrave") = 204
		  d.Value("Im") = 8465
		  d.Value("Imacr") = 298
		  d.Value("ImaginaryI") = 8520
		  d.Value("Implies") = 8658
		  d.Value("Int") = 8748
		  d.Value("Integral") = 8747
		  d.Value("Intersection") = 8898
		  d.Value("InvisibleComma") = 8291
		  d.Value("InvisibleTimes") = 8290
		  d.Value("Iogon") = 302
		  d.Value("Iopf") = 120128
		  d.Value("Iota") = 921
		  d.Value("Iscr") = 8464
		  d.Value("Itilde") = 296
		  d.Value("Iukcy") = 1030
		  d.Value("Iuml") = 207
		  d.Value("Jcirc") = 308
		  d.Value("Jcy") = 1049
		  d.Value("Jfr") = 120077
		  d.Value("Jopf") = 120129
		  d.Value("Jscr") = 119973
		  d.Value("Jsercy") = 1032
		  d.Value("Jukcy") = 1028
		  d.Value("KHcy") = 1061
		  d.Value("KJcy") = 1036
		  d.Value("Kappa") = 922
		  d.Value("Kcedil") = 310
		  d.Value("Kcy") = 1050
		  d.Value("Kfr") = 120078
		  d.Value("Kopf") = 120130
		  d.Value("Kscr") = 119974
		  d.Value("LJcy") = 1033
		  d.Value("LT") = 60
		  d.Value("Lacute") = 313
		  d.Value("Lambda") = 923
		  d.Value("Lang") = 10218
		  d.Value("Laplacetrf") = 8466
		  d.Value("Larr") = 8606
		  d.Value("Lcaron") = 317
		  d.Value("Lcedil") = 315
		  d.Value("Lcy") = 1051
		  d.Value("LeftAngleBracket") = 10216
		  d.Value("LeftArrow") = 8592
		  d.Value("LeftArrowBar") = 8676
		  d.Value("LeftArrowRightArrow") = 8646
		  d.Value("LeftCeiling") = 8968
		  d.Value("LeftDoubleBracket") = 10214
		  d.Value("LeftDownTeeVector") = 10593
		  d.Value("LeftDownVector") = 8643
		  d.Value("LeftDownVectorBar") = 10585
		  d.Value("LeftFloor") = 8970
		  d.Value("LeftRightArrow") = 8596
		  d.Value("LeftRightVector") = 10574
		  d.Value("LeftTee") = 8867
		  d.Value("LeftTeeArrow") = 8612
		  d.Value("LeftTeeVector") = 10586
		  d.Value("LeftTriangle") = 8882
		  d.Value("LeftTriangleBar") = 10703
		  d.Value("LeftTriangleEqual") = 8884
		  d.Value("LeftUpDownVector") = 10577
		  d.Value("LeftUpTeeVector") = 10592
		  d.Value("LeftUpVector") = 8639
		  d.Value("LeftUpVectorBar") = 10584
		  d.Value("LeftVector") = 8636
		  d.Value("LeftVectorBar") = 10578
		  d.Value("Leftarrow") = 8656
		  d.Value("Leftrightarrow") = 8660
		  d.Value("LessEqualGreater") = 8922
		  d.Value("LessFullEqual") = 8806
		  d.Value("LessGreater") = 8822
		  d.Value("LessLess") = 10913
		  d.Value("LessSlantEqual") = 10877
		  d.Value("LessTilde") = 8818
		  d.Value("Lfr") = 120079
		  d.Value("Ll") = 8920
		  d.Value("Lleftarrow") = 8666
		  d.Value("Lmidot") = 319
		  d.Value("LongLeftArrow") = 10229
		  d.Value("LongLeftRightArrow") = 10231
		  d.Value("LongRightArrow") = 10230
		  d.Value("Longleftarrow") = 10232
		  d.Value("Longleftrightarrow") = 10234
		  d.Value("Longrightarrow") = 10233
		  d.Value("Lopf") = 120131
		  d.Value("LowerLeftArrow") = 8601
		  d.Value("LowerRightArrow") = 8600
		  d.Value("Lscr") = 8466
		  d.Value("Lsh") = 8624
		  d.Value("Lstrok") = 321
		  d.Value("Lt") = 8810
		  d.Value("Map") = 10501
		  d.Value("Mcy") = 1052
		  d.Value("MediumSpace") = 8287
		  d.Value("Mellintrf") = 8499
		  d.Value("Mfr") = 120080
		  d.Value("MinusPlus") = 8723
		  d.Value("Mopf") = 120132
		  d.Value("Mscr") = 8499
		  d.Value("Mu") = 924
		  d.Value("NJcy") = 1034
		  d.Value("Nacute") = 323
		  d.Value("Ncaron") = 327
		  d.Value("Ncedil") = 325
		  d.Value("Ncy") = 1053
		  d.Value("NegativeMediumSpace") = 8203
		  d.Value("NegativeThickSpace") = 8203
		  d.Value("NegativeThinSpace") = 8203
		  d.Value("NegativeVeryThinSpace") = 8203
		  d.Value("NestedGreaterGreater") = 8811
		  d.Value("NestedLessLess") = 8810
		  d.Value("NewLine") = 10
		  d.Value("Nfr") = 120081
		  d.Value("NoBreak") = 8288
		  d.Value("NonBreakingSpace") = 160
		  d.Value("Nopf") = 8469
		  d.Value("Not") = 10988
		  d.Value("NotCongruent") = 8802
		  d.Value("NotCupCap") = 8813
		  d.Value("NotDoubleVerticalBar") = 8742
		  d.Value("NotElement") = 8713
		  d.Value("NotEqual") = 8800
		  d.Value("NotEqualTilde") = 8770
		  d.Value("NotExists") = 8708
		  d.Value("NotGreater") = 8815
		  d.Value("NotGreaterEqual") = 8817
		  d.Value("NotGreaterFullEqual") = 8807
		  d.Value("NotGreaterGreater") = 8811
		  d.Value("NotGreaterLess") = 8825
		  d.Value("NotGreaterSlantEqual") = 10878
		  d.Value("NotGreaterTilde") = 8821
		  d.Value("NotHumpDownHump") = 8782
		  d.Value("NotHumpEqual") = 8783
		  d.Value("NotLeftTriangle") = 8938
		  d.Value("NotLeftTriangleBar") = 10703
		  d.Value("NotLeftTriangleEqual") = 8940
		  d.Value("NotLess") = 8814
		  d.Value("NotLessEqual") = 8816
		  d.Value("NotLessGreater") = 8824
		  d.Value("NotLessLess") = 8810
		  d.Value("NotLessSlantEqual") = 10877
		  d.Value("NotLessTilde") = 8820
		  d.Value("NotNestedGreaterGreater") = 10914
		  d.Value("NotNestedLessLess") = 10913
		  d.Value("NotPrecedes") = 8832
		  d.Value("NotPrecedesEqual") = 10927
		  d.Value("NotPrecedesSlantEqual") = 8928
		  d.Value("NotReverseElement") = 8716
		  d.Value("NotRightTriangle") = 8939
		  d.Value("NotRightTriangleBar") = 10704
		  d.Value("NotRightTriangleEqual") = 8941
		  d.Value("NotSquareSubset") = 8847
		  d.Value("NotSquareSubsetEqual") = 8930
		  d.Value("NotSquareSuperset") = 8848
		  d.Value("NotSquareSupersetEqual") = 8931
		  d.Value("NotSubset") = 8834
		  d.Value("NotSubsetEqual") = 8840
		  d.Value("NotSucceeds") = 8833
		  d.Value("NotSucceedsEqual") = 10928
		  d.Value("NotSucceedsSlantEqual") = 8929
		  d.Value("NotSucceedsTilde") = 8831
		  d.Value("NotSuperset") = 8835
		  d.Value("NotSupersetEqual") = 8841
		  d.Value("NotTilde") = 8769
		  d.Value("NotTildeEqual") = 8772
		  d.Value("NotTildeFullEqual") = 8775
		  d.Value("NotTildeTilde") = 8777
		  d.Value("NotVerticalBar") = 8740
		  d.Value("Nscr") = 119977
		  d.Value("Ntilde") = 209
		  d.Value("Nu") = 925
		  d.Value("OElig") = 338
		  d.Value("Oacute") = 211
		  d.Value("Ocirc") = 212
		  d.Value("Ocy") = 1054
		  d.Value("Odblac") = 336
		  d.Value("Ofr") = 120082
		  d.Value("Ograve") = 210
		  d.Value("Omacr") = 332
		  d.Value("Omega") = 937
		  d.Value("Omicron") = 927
		  d.Value("Oopf") = 120134
		  d.Value("OpenCurlyDoubleQuote") = 8220
		  d.Value("OpenCurlyQuote") = 8216
		  d.Value("Or") = 10836
		  d.Value("Oscr") = 119978
		  d.Value("Oslash") = 216
		  d.Value("Otilde") = 213
		  d.Value("Otimes") = 10807
		  d.Value("Ouml") = 214
		  d.Value("OverBar") = 8254
		  d.Value("OverBrace") = 9182
		  d.Value("OverBracket") = 9140
		  d.Value("OverParenthesis") = 9180
		  d.Value("PartialD") = 8706
		  d.Value("Pcy") = 1055
		  d.Value("Pfr") = 120083
		  d.Value("Phi") = 934
		  d.Value("Pi") = 928
		  d.Value("PlusMinus") = 177
		  d.Value("Poincareplane") = 8460
		  d.Value("Popf") = 8473
		  d.Value("Pr") = 10939
		  d.Value("Precedes") = 8826
		  d.Value("PrecedesEqual") = 10927
		  d.Value("PrecedesSlantEqual") = 8828
		  d.Value("PrecedesTilde") = 8830
		  d.Value("Prime") = 8243
		  d.Value("Product") = 8719
		  d.Value("Proportion") = 8759
		  d.Value("Proportional") = 8733
		  d.Value("Pscr") = 119979
		  d.Value("Psi") = 936
		  d.Value("QUOT") = 34
		  d.Value("Qfr") = 120084
		  d.Value("Qopf") = 8474
		  d.Value("Qscr") = 119980
		  d.Value("RBarr") = 10512
		  d.Value("REG") = 174
		  d.Value("Racute") = 340
		  d.Value("Rang") = 10219
		  d.Value("Rarr") = 8608
		  d.Value("Rarrtl") = 10518
		  d.Value("Rcaron") = 344
		  d.Value("Rcedil") = 342
		  d.Value("Rcy") = 1056
		  d.Value("Re") = 8476
		  d.Value("ReverseElement") = 8715
		  d.Value("ReverseEquilibrium") = 8651
		  d.Value("ReverseUpEquilibrium") = 10607
		  d.Value("Rfr") = 8476
		  d.Value("Rho") = 929
		  d.Value("RightAngleBracket") = 10217
		  d.Value("RightArrow") = 8594
		  d.Value("RightArrowBar") = 8677
		  d.Value("RightArrowLeftArrow") = 8644
		  d.Value("RightCeiling") = 8969
		  d.Value("RightDoubleBracket") = 10215
		  d.Value("RightDownTeeVector") = 10589
		  d.Value("RightDownVector") = 8642
		  d.Value("RightDownVectorBar") = 10581
		  d.Value("RightFloor") = 8971
		  d.Value("RightTee") = 8866
		  d.Value("RightTeeArrow") = 8614
		  d.Value("RightTeeVector") = 10587
		  d.Value("RightTriangle") = 8883
		  d.Value("RightTriangleBar") = 10704
		  d.Value("RightTriangleEqual") = 8885
		  d.Value("RightUpDownVector") = 10575
		  d.Value("RightUpTeeVector") = 10588
		  d.Value("RightUpVector") = 8638
		  d.Value("RightUpVectorBar") = 10580
		  d.Value("RightVector") = 8640
		  d.Value("RightVectorBar") = 10579
		  d.Value("Rightarrow") = 8658
		  d.Value("Ropf") = 8477
		  d.Value("RoundImplies") = 10608
		  d.Value("Rrightarrow") = 8667
		  d.Value("Rscr") = 8475
		  d.Value("Rsh") = 8625
		  d.Value("RuleDelayed") = 10740
		  d.Value("SHCHcy") = 1065
		  d.Value("SHcy") = 1064
		  d.Value("SOFTcy") = 1068
		  d.Value("Sacute") = 346
		  d.Value("Sc") = 10940
		  d.Value("Scaron") = 352
		  d.Value("Scedil") = 350
		  d.Value("Scirc") = 348
		  d.Value("Scy") = 1057
		  d.Value("Sfr") = 120086
		  d.Value("ShortDownArrow") = 8595
		  d.Value("ShortLeftArrow") = 8592
		  d.Value("ShortRightArrow") = 8594
		  d.Value("ShortUpArrow") = 8593
		  d.Value("Sigma") = 931
		  d.Value("SmallCircle") = 8728
		  d.Value("Sopf") = 120138
		  d.Value("Sqrt") = 8730
		  d.Value("Square") = 9633
		  d.Value("SquareIntersection") = 8851
		  d.Value("SquareSubset") = 8847
		  d.Value("SquareSubsetEqual") = 8849
		  d.Value("SquareSuperset") = 8848
		  d.Value("SquareSupersetEqual") = 8850
		  d.Value("SquareUnion") = 8852
		  d.Value("Sscr") = 119982
		  d.Value("Star") = 8902
		  d.Value("Sub") = 8912
		  d.Value("Subset") = 8912
		  d.Value("SubsetEqual") = 8838
		  d.Value("Succeeds") = 8827
		  d.Value("SucceedsEqual") = 10928
		  d.Value("SucceedsSlantEqual") = 8829
		  d.Value("SucceedsTilde") = 8831
		  d.Value("SuchThat") = 8715
		  d.Value("Sum") = 8721
		  d.Value("Sup") = 8913
		  d.Value("Superset") = 8835
		  d.Value("SupersetEqual") = 8839
		  d.Value("Supset") = 8913
		  d.Value("THORN") = 222
		  d.Value("TRADE") = 8482
		  d.Value("TSHcy") = 1035
		  d.Value("TScy") = 1062
		  d.Value("Tab") = 9
		  d.Value("Tau") = 932
		  d.Value("Tcaron") = 356
		  d.Value("Tcedil") = 354
		  d.Value("Tcy") = 1058
		  d.Value("Tfr") = 120087
		  d.Value("Therefore") = 8756
		  d.Value("Theta") = 920
		  d.Value("ThickSpace") = 8287
		  d.Value("ThinSpace") = 8201
		  d.Value("Tilde") = 8764
		  d.Value("TildeEqual") = 8771
		  d.Value("TildeFullEqual") = 8773
		  d.Value("TildeTilde") = 8776
		  d.Value("Topf") = 120139
		  d.Value("TripleDot") = 8411
		  d.Value("Tscr") = 119983
		  d.Value("Tstrok") = 358
		  d.Value("Uacute") = 218
		  d.Value("Uarr") = 8607
		  d.Value("Uarrocir") = 10569
		  d.Value("Ubrcy") = 1038
		  d.Value("Ubreve") = 364
		  d.Value("Ucirc") = 219
		  d.Value("Ucy") = 1059
		  d.Value("Udblac") = 368
		  d.Value("Ufr") = 120088
		  d.Value("Ugrave") = 217
		  d.Value("Umacr") = 362
		  d.Value("UnderBar") = 95
		  d.Value("UnderBrace") = 9183
		  d.Value("UnderBracket") = 9141
		  d.Value("UnderParenthesis") = 9181
		  d.Value("Union") = 8899
		  d.Value("UnionPlus") = 8846
		  d.Value("Uogon") = 370
		  d.Value("Uopf") = 120140
		  d.Value("UpArrow") = 8593
		  d.Value("UpArrowBar") = 10514
		  d.Value("UpArrowDownArrow") = 8645
		  d.Value("UpDownArrow") = 8597
		  d.Value("UpEquilibrium") = 10606
		  d.Value("UpTee") = 8869
		  d.Value("UpTeeArrow") = 8613
		  d.Value("Uparrow") = 8657
		  d.Value("Updownarrow") = 8661
		  d.Value("UpperLeftArrow") = 8598
		  d.Value("UpperRightArrow") = 8599
		  d.Value("Upsi") = 978
		  d.Value("Upsilon") = 933
		  d.Value("Uring") = 366
		  d.Value("Uscr") = 119984
		  d.Value("Utilde") = 360
		  d.Value("Uuml") = 220
		  d.Value("VDash") = 8875
		  d.Value("Vbar") = 10987
		  d.Value("Vcy") = 1042
		  d.Value("Vdash") = 8873
		  d.Value("Vdashl") = 10982
		  d.Value("Vee") = 8897
		  d.Value("Verbar") = 8214
		  d.Value("Vert") = 8214
		  d.Value("VerticalBar") = 8739
		  d.Value("VerticalLine") = 124
		  d.Value("VerticalSeparator") = 10072
		  d.Value("VerticalTilde") = 8768
		  d.Value("VeryThinSpace") = 8202
		  d.Value("Vfr") = 120089
		  d.Value("Vopf") = 120141
		  d.Value("Vscr") = 119985
		  d.Value("Vvdash") = 8874
		  d.Value("Wcirc") = 372
		  d.Value("Wedge") = 8896
		  d.Value("Wfr") = 120090
		  d.Value("Wopf") = 120142
		  d.Value("Wscr") = 119986
		  d.Value("Xfr") = 120091
		  d.Value("Xi") = 926
		  d.Value("Xopf") = 120143
		  d.Value("Xscr") = 119987
		  d.Value("YAcy") = 1071
		  d.Value("YIcy") = 1031
		  d.Value("YUcy") = 1070
		  d.Value("Yacute") = 221
		  d.Value("Ycirc") = 374
		  d.Value("Ycy") = 1067
		  d.Value("Yfr") = 120092
		  d.Value("Yopf") = 120144
		  d.Value("Yscr") = 119988
		  d.Value("Yuml") = 376
		  d.Value("ZHcy") = 1046
		  d.Value("Zacute") = 377
		  d.Value("Zcaron") = 381
		  d.Value("Zcy") = 1047
		  d.Value("Zdot") = 379
		  d.Value("ZeroWidthSpace") = 8203
		  d.Value("Zeta") = 918
		  d.Value("Zfr") = 8488
		  d.Value("Zopf") = 8484
		  d.Value("Zscr") = 119989
		  d.Value("aacute") = 225
		  d.Value("abreve") = 259
		  d.Value("ac") = 8766
		  d.Value("acE") = 8766
		  d.Value("acd") = 8767
		  d.Value("acirc") = 226
		  d.Value("acute") = 180
		  d.Value("acy") = 1072
		  d.Value("aelig") = 230
		  d.Value("af") = 8289
		  d.Value("afr") = 120094
		  d.Value("agrave") = 224
		  d.Value("alefsym") = 8501
		  d.Value("aleph") = 8501
		  d.Value("alpha") = 945
		  d.Value("amacr") = 257
		  d.Value("amalg") = 10815
		  d.Value("amp") = 38
		  d.Value("and") = 8743
		  d.Value("andand") = 10837
		  d.Value("andd") = 10844
		  d.Value("andslope") = 10840
		  d.Value("andv") = 10842
		  d.Value("ang") = 8736
		  d.Value("ange") = 10660
		  d.Value("angle") = 8736
		  d.Value("angmsd") = 8737
		  d.Value("angmsdaa") = 10664
		  d.Value("angmsdab") = 10665
		  d.Value("angmsdac") = 10666
		  d.Value("angmsdad") = 10667
		  d.Value("angmsdae") = 10668
		  d.Value("angmsdaf") = 10669
		  d.Value("angmsdag") = 10670
		  d.Value("angmsdah") = 10671
		  d.Value("angrt") = 8735
		  d.Value("angrtvb") = 8894
		  d.Value("angrtvbd") = 10653
		  d.Value("angsph") = 8738
		  d.Value("angst") = 197
		  d.Value("angzarr") = 9084
		  d.Value("aogon") = 261
		  d.Value("aopf") = 120146
		  d.Value("ap") = 8776
		  d.Value("apE") = 10864
		  d.Value("apacir") = 10863
		  d.Value("ape") = 8778
		  d.Value("apid") = 8779
		  d.Value("apos") = 39
		  d.Value("approx") = 8776
		  d.Value("approxeq") = 8778
		  d.Value("aring") = 229
		  d.Value("ascr") = 119990
		  d.Value("ast") = 42
		  d.Value("asymp") = 8776
		  d.Value("asympeq") = 8781
		  d.Value("atilde") = 227
		  d.Value("auml") = 228
		  d.Value("awconint") = 8755
		  d.Value("awint") = 10769
		  d.Value("bNot") = 10989
		  d.Value("backcong") = 8780
		  d.Value("backepsilon") = 1014
		  d.Value("backprime") = 8245
		  d.Value("backsim") = 8765
		  d.Value("backsimeq") = 8909
		  d.Value("barvee") = 8893
		  d.Value("barwed") = 8965
		  d.Value("barwedge") = 8965
		  d.Value("bbrk") = 9141
		  d.Value("bbrktbrk") = 9142
		  d.Value("bcong") = 8780
		  d.Value("bcy") = 1073
		  d.Value("bdquo") = 8222
		  d.Value("becaus") = 8757
		  d.Value("because") = 8757
		  d.Value("bemptyv") = 10672
		  d.Value("bepsi") = 1014
		  d.Value("bernou") = 8492
		  d.Value("beta") = 946
		  d.Value("beth") = 8502
		  d.Value("between") = 8812
		  d.Value("bfr") = 120095
		  d.Value("bigcap") = 8898
		  d.Value("bigcirc") = 9711
		  d.Value("bigcup") = 8899
		  d.Value("bigodot") = 10752
		  d.Value("bigoplus") = 10753
		  d.Value("bigotimes") = 10754
		  d.Value("bigsqcup") = 10758
		  d.Value("bigstar") = 9733
		  d.Value("bigtriangledown") = 9661
		  d.Value("bigtriangleup") = 9651
		  d.Value("biguplus") = 10756
		  d.Value("bigvee") = 8897
		  d.Value("bigwedge") = 8896
		  d.Value("bkarow") = 10509
		  d.Value("blacklozenge") = 10731
		  d.Value("blacksquare") = 9642
		  d.Value("blacktriangle") = 9652
		  d.Value("blacktriangledown") = 9662
		  d.Value("blacktriangleleft") = 9666
		  d.Value("blacktriangleright") = 9656
		  d.Value("blank") = 9251
		  d.Value("blk12") = 9618
		  d.Value("blk14") = 9617
		  d.Value("blk34") = 9619
		  d.Value("block") = 9608
		  d.Value("bne") = 61
		  d.Value("bnequiv") = 8801
		  d.Value("bnot") = 8976
		  d.Value("bopf") = 120147
		  d.Value("bot") = 8869
		  d.Value("bottom") = 8869
		  d.Value("bowtie") = 8904
		  d.Value("boxDL") = 9559
		  d.Value("boxDR") = 9556
		  d.Value("boxDl") = 9558
		  d.Value("boxDr") = 9555
		  d.Value("boxH") = 9552
		  d.Value("boxHD") = 9574
		  d.Value("boxHU") = 9577
		  d.Value("boxHd") = 9572
		  d.Value("boxHu") = 9575
		  d.Value("boxUL") = 9565
		  d.Value("boxUR") = 9562
		  d.Value("boxUl") = 9564
		  d.Value("boxUr") = 9561
		  d.Value("boxV") = 9553
		  d.Value("boxVH") = 9580
		  d.Value("boxVL") = 9571
		  d.Value("boxVR") = 9568
		  d.Value("boxVh") = 9579
		  d.Value("boxVl") = 9570
		  d.Value("boxVr") = 9567
		  d.Value("boxbox") = 10697
		  d.Value("boxdL") = 9557
		  d.Value("boxdR") = 9554
		  d.Value("boxdl") = 9488
		  d.Value("boxdr") = 9484
		  d.Value("boxh") = 9472
		  d.Value("boxhD") = 9573
		  d.Value("boxhU") = 9576
		  d.Value("boxhd") = 9516
		  d.Value("boxhu") = 9524
		  d.Value("boxminus") = 8863
		  d.Value("boxplus") = 8862
		  d.Value("boxtimes") = 8864
		  d.Value("boxuL") = 9563
		  d.Value("boxuR") = 9560
		  d.Value("boxul") = 9496
		  d.Value("boxur") = 9492
		  d.Value("boxv") = 9474
		  d.Value("boxvH") = 9578
		  d.Value("boxvL") = 9569
		  d.Value("boxvR") = 9566
		  d.Value("boxvh") = 9532
		  d.Value("boxvl") = 9508
		  d.Value("boxvr") = 9500
		  d.Value("bprime") = 8245
		  d.Value("breve") = 728
		  d.Value("brvbar") = 166
		  d.Value("bscr") = 119991
		  d.Value("bsemi") = 8271
		  d.Value("bsim") = 8765
		  d.Value("bsime") = 8909
		  d.Value("bsol") = 92
		  d.Value("bsolb") = 10693
		  d.Value("bsolhsub") = 10184
		  d.Value("bull") = 8226
		  d.Value("bullet") = 8226
		  d.Value("bump") = 8782
		  d.Value("bumpE") = 10926
		  d.Value("bumpe") = 8783
		  d.Value("bumpeq") = 8783
		  d.Value("cacute") = 263
		  d.Value("cap") = 8745
		  d.Value("capand") = 10820
		  d.Value("capbrcup") = 10825
		  d.Value("capcap") = 10827
		  d.Value("capcup") = 10823
		  d.Value("capdot") = 10816
		  d.Value("caps") = 8745
		  d.Value("caret") = 8257
		  d.Value("caron") = 711
		  d.Value("ccaps") = 10829
		  d.Value("ccaron") = 269
		  d.Value("ccedil") = 231
		  d.Value("ccirc") = 265
		  d.Value("ccups") = 10828
		  d.Value("ccupssm") = 10832
		  d.Value("cdot") = 267
		  d.Value("cedil") = 184
		  d.Value("cemptyv") = 10674
		  d.Value("cent") = 162
		  d.Value("centerdot") = 183
		  d.Value("cfr") = 120096
		  d.Value("chcy") = 1095
		  d.Value("check") = 10003
		  d.Value("checkmark") = 10003
		  d.Value("chi") = 967
		  d.Value("cir") = 9675
		  d.Value("cirE") = 10691
		  d.Value("circ") = 710
		  d.Value("circeq") = 8791
		  d.Value("circlearrowleft") = 8634
		  d.Value("circlearrowright") = 8635
		  d.Value("circledR") = 174
		  d.Value("circledS") = 9416
		  d.Value("circledast") = 8859
		  d.Value("circledcirc") = 8858
		  d.Value("circleddash") = 8861
		  d.Value("cire") = 8791
		  d.Value("cirfnint") = 10768
		  d.Value("cirmid") = 10991
		  d.Value("cirscir") = 10690
		  d.Value("clubs") = 9827
		  d.Value("clubsuit") = 9827
		  d.Value("colon") = 58
		  d.Value("colone") = 8788
		  d.Value("coloneq") = 8788
		  d.Value("comma") = 44
		  d.Value("commat") = 64
		  d.Value("comp") = 8705
		  d.Value("compfn") = 8728
		  d.Value("complement") = 8705
		  d.Value("complexes") = 8450
		  d.Value("cong") = 8773
		  d.Value("congdot") = 10861
		  d.Value("conint") = 8750
		  d.Value("copf") = 120148
		  d.Value("coprod") = 8720
		  d.Value("copy") = 169
		  d.Value("copysr") = 8471
		  d.Value("crarr") = 8629
		  d.Value("cross") = 10007
		  d.Value("cscr") = 119992
		  d.Value("csub") = 10959
		  d.Value("csube") = 10961
		  d.Value("csup") = 10960
		  d.Value("csupe") = 10962
		  d.Value("ctdot") = 8943
		  d.Value("cudarrl") = 10552
		  d.Value("cudarrr") = 10549
		  d.Value("cuepr") = 8926
		  d.Value("cuesc") = 8927
		  d.Value("cularr") = 8630
		  d.Value("cularrp") = 10557
		  d.Value("cup") = 8746
		  d.Value("cupbrcap") = 10824
		  d.Value("cupcap") = 10822
		  d.Value("cupcup") = 10826
		  d.Value("cupdot") = 8845
		  d.Value("cupor") = 10821
		  d.Value("cups") = 8746
		  d.Value("curarr") = 8631
		  d.Value("curarrm") = 10556
		  d.Value("curlyeqprec") = 8926
		  d.Value("curlyeqsucc") = 8927
		  d.Value("curlyvee") = 8910
		  d.Value("curlywedge") = 8911
		  d.Value("curren") = 164
		  d.Value("curvearrowleft") = 8630
		  d.Value("curvearrowright") = 8631
		  d.Value("cuvee") = 8910
		  d.Value("cuwed") = 8911
		  d.Value("cwconint") = 8754
		  d.Value("cwint") = 8753
		  d.Value("cylcty") = 9005
		  d.Value("dArr") = 8659
		  d.Value("dHar") = 10597
		  d.Value("dagger") = 8224
		  d.Value("daleth") = 8504
		  d.Value("darr") = 8595
		  d.Value("dash") = 8208
		  d.Value("dashv") = 8867
		  d.Value("dbkarow") = 10511
		  d.Value("dblac") = 733
		  d.Value("dcaron") = 271
		  d.Value("dcy") = 1076
		  d.Value("dd") = 8518
		  d.Value("ddagger") = 8225
		  d.Value("ddarr") = 8650
		  d.Value("ddotseq") = 10871
		  d.Value("deg") = 176
		  d.Value("delta") = 948
		  d.Value("demptyv") = 10673
		  d.Value("dfisht") = 10623
		  d.Value("dfr") = 120097
		  d.Value("dharl") = 8643
		  d.Value("dharr") = 8642
		  d.Value("diam") = 8900
		  d.Value("diamond") = 8900
		  d.Value("diamondsuit") = 9830
		  d.Value("diams") = 9830
		  d.Value("die") = 168
		  d.Value("digamma") = 989
		  d.Value("disin") = 8946
		  d.Value("div") = 247
		  d.Value("divide") = 247
		  d.Value("divideontimes") = 8903
		  d.Value("divonx") = 8903
		  d.Value("djcy") = 1106
		  d.Value("dlcorn") = 8990
		  d.Value("dlcrop") = 8973
		  d.Value("dollar") = 36
		  d.Value("dopf") = 120149
		  d.Value("dot") = 729
		  d.Value("doteq") = 8784
		  d.Value("doteqdot") = 8785
		  d.Value("dotminus") = 8760
		  d.Value("dotplus") = 8724
		  d.Value("dotsquare") = 8865
		  d.Value("doublebarwedge") = 8966
		  d.Value("downarrow") = 8595
		  d.Value("downdownarrows") = 8650
		  d.Value("downharpoonleft") = 8643
		  d.Value("downharpoonright") = 8642
		  d.Value("drbkarow") = 10512
		  d.Value("drcorn") = 8991
		  d.Value("drcrop") = 8972
		  d.Value("dscr") = 119993
		  d.Value("dscy") = 1109
		  d.Value("dsol") = 10742
		  d.Value("dstrok") = 273
		  d.Value("dtdot") = 8945
		  d.Value("dtri") = 9663
		  d.Value("dtrif") = 9662
		  d.Value("duarr") = 8693
		  d.Value("duhar") = 10607
		  d.Value("dwangle") = 10662
		  d.Value("dzcy") = 1119
		  d.Value("dzigrarr") = 10239
		  d.Value("eDDot") = 10871
		  d.Value("eDot") = 8785
		  d.Value("eacute") = 233
		  d.Value("easter") = 10862
		  d.Value("ecaron") = 283
		  d.Value("ecir") = 8790
		  d.Value("ecirc") = 234
		  d.Value("ecolon") = 8789
		  d.Value("ecy") = 1101
		  d.Value("edot") = 279
		  d.Value("ee") = 8519
		  d.Value("efDot") = 8786
		  d.Value("efr") = 120098
		  d.Value("eg") = 10906
		  d.Value("egrave") = 232
		  d.Value("egs") = 10902
		  d.Value("egsdot") = 10904
		  d.Value("el") = 10905
		  d.Value("elinters") = 9191
		  d.Value("ell") = 8467
		  d.Value("els") = 10901
		  d.Value("elsdot") = 10903
		  d.Value("emacr") = 275
		  d.Value("empty") = 8709
		  d.Value("emptyset") = 8709
		  d.Value("emptyv") = 8709
		  d.Value("emsp13") = 8196
		  d.Value("emsp14") = 8197
		  d.Value("emsp") = 8195
		  d.Value("eng") = 331
		  d.Value("ensp") = 8194
		  d.Value("eogon") = 281
		  d.Value("eopf") = 120150
		  d.Value("epar") = 8917
		  d.Value("eparsl") = 10723
		  d.Value("eplus") = 10865
		  d.Value("epsi") = 949
		  d.Value("epsilon") = 949
		  d.Value("epsiv") = 1013
		  d.Value("eqcirc") = 8790
		  d.Value("eqcolon") = 8789
		  d.Value("eqsim") = 8770
		  d.Value("eqslantgtr") = 10902
		  d.Value("eqslantless") = 10901
		  d.Value("equals") = 61
		  d.Value("equest") = 8799
		  d.Value("equiv") = 8801
		  d.Value("equivDD") = 10872
		  d.Value("eqvparsl") = 10725
		  d.Value("erDot") = 8787
		  d.Value("erarr") = 10609
		  d.Value("escr") = 8495
		  d.Value("esdot") = 8784
		  d.Value("esim") = 8770
		  d.Value("eta") = 951
		  d.Value("eth") = 240
		  d.Value("euml") = 235
		  d.Value("euro") = 8364
		  d.Value("excl") = 33
		  d.Value("exist") = 8707
		  d.Value("expectation") = 8496
		  d.Value("exponentiale") = 8519
		  d.Value("fallingdotseq") = 8786
		  d.Value("fcy") = 1092
		  d.Value("female") = 9792
		  d.Value("ffilig") = 64259
		  d.Value("fflig") = 64256
		  d.Value("ffllig") = 64260
		  d.Value("ffr") = 120099
		  d.Value("filig") = 64257
		  d.Value("fjlig") = 102
		  d.Value("flat") = 9837
		  d.Value("fllig") = 64258
		  d.Value("fltns") = 9649
		  d.Value("fnof") = 402
		  d.Value("fopf") = 120151
		  d.Value("forall") = 8704
		  d.Value("fork") = 8916
		  d.Value("forkv") = 10969
		  d.Value("fpartint") = 10765
		  d.Value("frac12") = 189
		  d.Value("frac13") = 8531
		  d.Value("frac14") = 188
		  d.Value("frac15") = 8533
		  d.Value("frac16") = 8537
		  d.Value("frac18") = 8539
		  d.Value("frac23") = 8532
		  d.Value("frac25") = 8534
		  d.Value("frac34") = 190
		  d.Value("frac35") = 8535
		  d.Value("frac38") = 8540
		  d.Value("frac45") = 8536
		  d.Value("frac56") = 8538
		  d.Value("frac58") = 8541
		  d.Value("frac78") = 8542
		  d.Value("frasl") = 8260
		  d.Value("frown") = 8994
		  d.Value("fscr") = 119995
		  d.Value("gE") = 8807
		  d.Value("gEl") = 10892
		  d.Value("gacute") = 501
		  d.Value("gamma") = 947
		  d.Value("gammad") = 989
		  d.Value("gap") = 10886
		  d.Value("gbreve") = 287
		  d.Value("gcirc") = 285
		  d.Value("gcy") = 1075
		  d.Value("gdot") = 289
		  d.Value("ge") = 8805
		  d.Value("gel") = 8923
		  d.Value("geq") = 8805
		  d.Value("geqq") = 8807
		  d.Value("geqslant") = 10878
		  d.Value("ges") = 10878
		  d.Value("gescc") = 10921
		  d.Value("gesdot") = 10880
		  d.Value("gesdoto") = 10882
		  d.Value("gesdotol") = 10884
		  d.Value("gesl") = 8923
		  d.Value("gesles") = 10900
		  d.Value("gfr") = 120100
		  d.Value("gg") = 8811
		  d.Value("ggg") = 8921
		  d.Value("gimel") = 8503
		  d.Value("gjcy") = 1107
		  d.Value("gl") = 8823
		  d.Value("glE") = 10898
		  d.Value("gla") = 10917
		  d.Value("glj") = 10916
		  d.Value("gnE") = 8809
		  d.Value("gnap") = 10890
		  d.Value("gnapprox") = 10890
		  d.Value("gne") = 10888
		  d.Value("gneq") = 10888
		  d.Value("gneqq") = 8809
		  d.Value("gnsim") = 8935
		  d.Value("gopf") = 120152
		  d.Value("grave") = 96
		  d.Value("gscr") = 8458
		  d.Value("gsim") = 8819
		  d.Value("gsime") = 10894
		  d.Value("gsiml") = 10896
		  d.Value("gt") = 62
		  d.Value("gtcc") = 10919
		  d.Value("gtcir") = 10874
		  d.Value("gtdot") = 8919
		  d.Value("gtlPar") = 10645
		  d.Value("gtquest") = 10876
		  d.Value("gtrapprox") = 10886
		  d.Value("gtrarr") = 10616
		  d.Value("gtrdot") = 8919
		  d.Value("gtreqless") = 8923
		  d.Value("gtreqqless") = 10892
		  d.Value("gtrless") = 8823
		  d.Value("gtrsim") = 8819
		  d.Value("gvertneqq") = 8809
		  d.Value("gvnE") = 8809
		  d.Value("hArr") = 8660
		  d.Value("hairsp") = 8202
		  d.Value("half") = 189
		  d.Value("hamilt") = 8459
		  d.Value("hardcy") = 1098
		  d.Value("harr") = 8596
		  d.Value("harrcir") = 10568
		  d.Value("harrw") = 8621
		  d.Value("hbar") = 8463
		  d.Value("hcirc") = 293
		  d.Value("hearts") = 9829
		  d.Value("heartsuit") = 9829
		  d.Value("hellip") = 8230
		  d.Value("hercon") = 8889
		  d.Value("hfr") = 120101
		  d.Value("hksearow") = 10533
		  d.Value("hkswarow") = 10534
		  d.Value("hoarr") = 8703
		  d.Value("homtht") = 8763
		  d.Value("hookleftarrow") = 8617
		  d.Value("hookrightarrow") = 8618
		  d.Value("hopf") = 120153
		  d.Value("horbar") = 8213
		  d.Value("hscr") = 119997
		  d.Value("hslash") = 8463
		  d.Value("hstrok") = 295
		  d.Value("hybull") = 8259
		  d.Value("hyphen") = 8208
		  d.Value("iacute") = 237
		  d.Value("ic") = 8291
		  d.Value("icirc") = 238
		  d.Value("icy") = 1080
		  d.Value("iecy") = 1077
		  d.Value("iexcl") = 161
		  d.Value("iff") = 8660
		  d.Value("ifr") = 120102
		  d.Value("igrave") = 236
		  d.Value("ii") = 8520
		  d.Value("iiiint") = 10764
		  d.Value("iiint") = 8749
		  d.Value("iinfin") = 10716
		  d.Value("iiota") = 8489
		  d.Value("ijlig") = 307
		  d.Value("imacr") = 299
		  d.Value("image") = 8465
		  d.Value("imagline") = 8464
		  d.Value("imagpart") = 8465
		  d.Value("imath") = 305
		  d.Value("imof") = 8887
		  d.Value("imped") = 437
		  d.Value("in") = 8712
		  d.Value("incare") = 8453
		  d.Value("infin") = 8734
		  d.Value("infintie") = 10717
		  d.Value("inodot") = 305
		  d.Value("int") = 8747
		  d.Value("intcal") = 8890
		  d.Value("integers") = 8484
		  d.Value("intercal") = 8890
		  d.Value("intlarhk") = 10775
		  d.Value("intprod") = 10812
		  d.Value("iocy") = 1105
		  d.Value("iogon") = 303
		  d.Value("iopf") = 120154
		  d.Value("iota") = 953
		  d.Value("iprod") = 10812
		  d.Value("iquest") = 191
		  d.Value("iscr") = 119998
		  d.Value("isin") = 8712
		  d.Value("isinE") = 8953
		  d.Value("isindot") = 8949
		  d.Value("isins") = 8948
		  d.Value("isinsv") = 8947
		  d.Value("isinv") = 8712
		  d.Value("it") = 8290
		  d.Value("itilde") = 297
		  d.Value("iukcy") = 1110
		  d.Value("iuml") = 239
		  d.Value("jcirc") = 309
		  d.Value("jcy") = 1081
		  d.Value("jfr") = 120103
		  d.Value("jmath") = 567
		  d.Value("jopf") = 120155
		  d.Value("jscr") = 119999
		  d.Value("jsercy") = 1112
		  d.Value("jukcy") = 1108
		  d.Value("kappa") = 954
		  d.Value("kappav") = 1008
		  d.Value("kcedil") = 311
		  d.Value("kcy") = 1082
		  d.Value("kfr") = 120104
		  d.Value("kgreen") = 312
		  d.Value("khcy") = 1093
		  d.Value("kjcy") = 1116
		  d.Value("kopf") = 120156
		  d.Value("kscr") = 120000
		  d.Value("lAarr") = 8666
		  d.Value("lArr") = 8656
		  d.Value("lAtail") = 10523
		  d.Value("lBarr") = 10510
		  d.Value("lE") = 8806
		  d.Value("lEg") = 10891
		  d.Value("lHar") = 10594
		  d.Value("lacute") = 314
		  d.Value("laemptyv") = 10676
		  d.Value("lagran") = 8466
		  d.Value("lambda") = 955
		  d.Value("lang") = 10216
		  d.Value("langd") = 10641
		  d.Value("langle") = 10216
		  d.Value("lap") = 10885
		  d.Value("laquo") = 171
		  d.Value("larr") = 8592
		  d.Value("larrb") = 8676
		  d.Value("larrbfs") = 10527
		  d.Value("larrfs") = 10525
		  d.Value("larrhk") = 8617
		  d.Value("larrlp") = 8619
		  d.Value("larrpl") = 10553
		  d.Value("larrsim") = 10611
		  d.Value("larrtl") = 8610
		  d.Value("lat") = 10923
		  d.Value("latail") = 10521
		  d.Value("late") = 10925
		  d.Value("lates") = 10925
		  d.Value("lbarr") = 10508
		  d.Value("lbbrk") = 10098
		  d.Value("lbrace") = 123
		  d.Value("lbrack") = 91
		  d.Value("lbrke") = 10635
		  d.Value("lbrksld") = 10639
		  d.Value("lbrkslu") = 10637
		  d.Value("lcaron") = 318
		  d.Value("lcedil") = 316
		  d.Value("lceil") = 8968
		  d.Value("lcub") = 123
		  d.Value("lcy") = 1083
		  d.Value("ldca") = 10550
		  d.Value("ldquo") = 8220
		  d.Value("ldquor") = 8222
		  d.Value("ldrdhar") = 10599
		  d.Value("ldrushar") = 10571
		  d.Value("ldsh") = 8626
		  d.Value("le") = 8804
		  d.Value("leftarrow") = 8592
		  d.Value("leftarrowtail") = 8610
		  d.Value("leftharpoondown") = 8637
		  d.Value("leftharpoonup") = 8636
		  d.Value("leftleftarrows") = 8647
		  d.Value("leftrightarrow") = 8596
		  d.Value("leftrightarrows") = 8646
		  d.Value("leftrightharpoons") = 8651
		  d.Value("leftrightsquigarrow") = 8621
		  d.Value("leftthreetimes") = 8907
		  d.Value("leg") = 8922
		  d.Value("leq") = 8804
		  d.Value("leqq") = 8806
		  d.Value("leqslant") = 10877
		  d.Value("les") = 10877
		  d.Value("lescc") = 10920
		  d.Value("lesdot") = 10879
		  d.Value("lesdoto") = 10881
		  d.Value("lesdotor") = 10883
		  d.Value("lesg") = 8922
		  d.Value("lesges") = 10899
		  d.Value("lessapprox") = 10885
		  d.Value("lessdot") = 8918
		  d.Value("lesseqgtr") = 8922
		  d.Value("lesseqqgtr") = 10891
		  d.Value("lessgtr") = 8822
		  d.Value("lesssim") = 8818
		  d.Value("lfisht") = 10620
		  d.Value("lfloor") = 8970
		  d.Value("lfr") = 120105
		  d.Value("lg") = 8822
		  d.Value("lgE") = 10897
		  d.Value("lhard") = 8637
		  d.Value("lharu") = 8636
		  d.Value("lharul") = 10602
		  d.Value("lhblk") = 9604
		  d.Value("ljcy") = 1113
		  d.Value("ll") = 8810
		  d.Value("llarr") = 8647
		  d.Value("llcorner") = 8990
		  d.Value("llhard") = 10603
		  d.Value("lltri") = 9722
		  d.Value("lmidot") = 320
		  d.Value("lmoust") = 9136
		  d.Value("lmoustache") = 9136
		  d.Value("lnE") = 8808
		  d.Value("lnap") = 10889
		  d.Value("lnapprox") = 10889
		  d.Value("lne") = 10887
		  d.Value("lneq") = 10887
		  d.Value("lneqq") = 8808
		  d.Value("lnsim") = 8934
		  d.Value("loang") = 10220
		  d.Value("loarr") = 8701
		  d.Value("lobrk") = 10214
		  d.Value("longleftarrow") = 10229
		  d.Value("longleftrightarrow") = 10231
		  d.Value("longmapsto") = 10236
		  d.Value("longrightarrow") = 10230
		  d.Value("looparrowleft") = 8619
		  d.Value("looparrowright") = 8620
		  d.Value("lopar") = 10629
		  d.Value("lopf") = 120157
		  d.Value("loplus") = 10797
		  d.Value("lotimes") = 10804
		  d.Value("lowast") = 8727
		  d.Value("lowbar") = 95
		  d.Value("loz") = 9674
		  d.Value("lozenge") = 9674
		  d.Value("lozf") = 10731
		  d.Value("lpar") = 40
		  d.Value("lparlt") = 10643
		  d.Value("lrarr") = 8646
		  d.Value("lrcorner") = 8991
		  d.Value("lrhar") = 8651
		  d.Value("lrhard") = 10605
		  d.Value("lrm") = 8206
		  d.Value("lrtri") = 8895
		  d.Value("lsaquo") = 8249
		  d.Value("lscr") = 120001
		  d.Value("lsh") = 8624
		  d.Value("lsim") = 8818
		  d.Value("lsime") = 10893
		  d.Value("lsimg") = 10895
		  d.Value("lsqb") = 91
		  d.Value("lsquo") = 8216
		  d.Value("lsquor") = 8218
		  d.Value("lstrok") = 322
		  d.Value("lt") = 60
		  d.Value("ltcc") = 10918
		  d.Value("ltcir") = 10873
		  d.Value("ltdot") = 8918
		  d.Value("lthree") = 8907
		  d.Value("ltimes") = 8905
		  d.Value("ltlarr") = 10614
		  d.Value("ltquest") = 10875
		  d.Value("ltrPar") = 10646
		  d.Value("ltri") = 9667
		  d.Value("ltrie") = 8884
		  d.Value("ltrif") = 9666
		  d.Value("lurdshar") = 10570
		  d.Value("luruhar") = 10598
		  d.Value("lvertneqq") = 8808
		  d.Value("lvnE") = 8808
		  d.Value("mDDot") = 8762
		  d.Value("macr") = 175
		  d.Value("male") = 9794
		  d.Value("malt") = 10016
		  d.Value("maltese") = 10016
		  d.Value("map") = 8614
		  d.Value("mapsto") = 8614
		  d.Value("mapstodown") = 8615
		  d.Value("mapstoleft") = 8612
		  d.Value("mapstoup") = 8613
		  d.Value("marker") = 9646
		  d.Value("mcomma") = 10793
		  d.Value("mcy") = 1084
		  d.Value("mdash") = 8212
		  d.Value("measuredangle") = 8737
		  d.Value("mfr") = 120106
		  d.Value("mho") = 8487
		  d.Value("micro") = 181
		  d.Value("mid") = 8739
		  d.Value("midast") = 42
		  d.Value("midcir") = 10992
		  d.Value("middot") = 183
		  d.Value("minus") = 8722
		  d.Value("minusb") = 8863
		  d.Value("minusd") = 8760
		  d.Value("minusdu") = 10794
		  d.Value("mlcp") = 10971
		  d.Value("mldr") = 8230
		  d.Value("mnplus") = 8723
		  d.Value("models") = 8871
		  d.Value("mopf") = 120158
		  d.Value("mp") = 8723
		  d.Value("mscr") = 120002
		  d.Value("mstpos") = 8766
		  d.Value("mu") = 956
		  d.Value("multimap") = 8888
		  d.Value("mumap") = 8888
		  d.Value("nGg") = 8921
		  d.Value("nGt") = 8811
		  d.Value("nGtv") = 8811
		  d.Value("nLeftarrow") = 8653
		  d.Value("nLeftrightarrow") = 8654
		  d.Value("nLl") = 8920
		  d.Value("nLt") = 8810
		  d.Value("nLtv") = 8810
		  d.Value("nRightarrow") = 8655
		  d.Value("nVDash") = 8879
		  d.Value("nVdash") = 8878
		  d.Value("nabla") = 8711
		  d.Value("nacute") = 324
		  d.Value("nang") = 8736
		  d.Value("nap") = 8777
		  d.Value("napE") = 10864
		  d.Value("napid") = 8779
		  d.Value("napos") = 329
		  d.Value("napprox") = 8777
		  d.Value("natur") = 9838
		  d.Value("natural") = 9838
		  d.Value("naturals") = 8469
		  d.Value("nbsp") = 160
		  d.Value("nbump") = 8782
		  d.Value("nbumpe") = 8783
		  d.Value("ncap") = 10819
		  d.Value("ncaron") = 328
		  d.Value("ncedil") = 326
		  d.Value("ncong") = 8775
		  d.Value("ncongdot") = 10861
		  d.Value("ncup") = 10818
		  d.Value("ncy") = 1085
		  d.Value("ndash") = 8211
		  d.Value("ne") = 8800
		  d.Value("neArr") = 8663
		  d.Value("nearhk") = 10532
		  d.Value("nearr") = 8599
		  d.Value("nearrow") = 8599
		  d.Value("nedot") = 8784
		  d.Value("nequiv") = 8802
		  d.Value("nesear") = 10536
		  d.Value("nesim") = 8770
		  d.Value("nexist") = 8708
		  d.Value("nexists") = 8708
		  d.Value("nfr") = 120107
		  d.Value("ngE") = 8807
		  d.Value("nge") = 8817
		  d.Value("ngeq") = 8817
		  d.Value("ngeqq") = 8807
		  d.Value("ngeqslant") = 10878
		  d.Value("nges") = 10878
		  d.Value("ngsim") = 8821
		  d.Value("ngt") = 8815
		  d.Value("ngtr") = 8815
		  d.Value("nhArr") = 8654
		  d.Value("nharr") = 8622
		  d.Value("nhpar") = 10994
		  d.Value("ni") = 8715
		  d.Value("nis") = 8956
		  d.Value("nisd") = 8954
		  d.Value("niv") = 8715
		  d.Value("njcy") = 1114
		  d.Value("nlArr") = 8653
		  d.Value("nlE") = 8806
		  d.Value("nlarr") = 8602
		  d.Value("nldr") = 8229
		  d.Value("nle") = 8816
		  d.Value("nleftarrow") = 8602
		  d.Value("nleftrightarrow") = 8622
		  d.Value("nleq") = 8816
		  d.Value("nleqq") = 8806
		  d.Value("nleqslant") = 10877
		  d.Value("nles") = 10877
		  d.Value("nless") = 8814
		  d.Value("nlsim") = 8820
		  d.Value("nlt") = 8814
		  d.Value("nltri") = 8938
		  d.Value("nltrie") = 8940
		  d.Value("nmid") = 8740
		  d.Value("nopf") = 120159
		  d.Value("not") = 172
		  d.Value("notin") = 8713
		  d.Value("notinE") = 8953
		  d.Value("notindot") = 8949
		  d.Value("notinva") = 8713
		  d.Value("notinvb") = 8951
		  d.Value("notinvc") = 8950
		  d.Value("notni") = 8716
		  d.Value("notniva") = 8716
		  d.Value("notnivb") = 8958
		  d.Value("notnivc") = 8957
		  d.Value("npar") = 8742
		  d.Value("nparallel") = 8742
		  d.Value("nparsl") = 11005
		  d.Value("npart") = 8706
		  d.Value("npolint") = 10772
		  d.Value("npr") = 8832
		  d.Value("nprcue") = 8928
		  d.Value("npre") = 10927
		  d.Value("nprec") = 8832
		  d.Value("npreceq") = 10927
		  d.Value("nrArr") = 8655
		  d.Value("nrarr") = 8603
		  d.Value("nrarrc") = 10547
		  d.Value("nrarrw") = 8605
		  d.Value("nrightarrow") = 8603
		  d.Value("nrtri") = 8939
		  d.Value("nrtrie") = 8941
		  d.Value("nsc") = 8833
		  d.Value("nsccue") = 8929
		  d.Value("nsce") = 10928
		  d.Value("nscr") = 120003
		  d.Value("nshortmid") = 8740
		  d.Value("nshortparallel") = 8742
		  d.Value("nsim") = 8769
		  d.Value("nsime") = 8772
		  d.Value("nsimeq") = 8772
		  d.Value("nsmid") = 8740
		  d.Value("nspar") = 8742
		  d.Value("nsqsube") = 8930
		  d.Value("nsqsupe") = 8931
		  d.Value("nsub") = 8836
		  d.Value("nsubE") = 10949
		  d.Value("nsube") = 8840
		  d.Value("nsubset") = 8834
		  d.Value("nsubseteq") = 8840
		  d.Value("nsubseteqq") = 10949
		  d.Value("nsucc") = 8833
		  d.Value("nsucceq") = 10928
		  d.Value("nsup") = 8837
		  d.Value("nsupE") = 10950
		  d.Value("nsupe") = 8841
		  d.Value("nsupset") = 8835
		  d.Value("nsupseteq") = 8841
		  d.Value("nsupseteqq") = 10950
		  d.Value("ntgl") = 8825
		  d.Value("ntilde") = 241
		  d.Value("ntlg") = 8824
		  d.Value("ntriangleleft") = 8938
		  d.Value("ntrianglelefteq") = 8940
		  d.Value("ntriangleright") = 8939
		  d.Value("ntrianglerighteq") = 8941
		  d.Value("nu") = 957
		  d.Value("num") = 35
		  d.Value("numero") = 8470
		  d.Value("numsp") = 8199
		  d.Value("nvDash") = 8877
		  d.Value("nvHarr") = 10500
		  d.Value("nvap") = 8781
		  d.Value("nvdash") = 8876
		  d.Value("nvge") = 8805
		  d.Value("nvgt") = 62
		  d.Value("nvinfin") = 10718
		  d.Value("nvlArr") = 10498
		  d.Value("nvle") = 8804
		  d.Value("nvlt") = 60
		  d.Value("nvltrie") = 8884
		  d.Value("nvrArr") = 10499
		  d.Value("nvrtrie") = 8885
		  d.Value("nvsim") = 8764
		  d.Value("nwArr") = 8662
		  d.Value("nwarhk") = 10531
		  d.Value("nwarr") = 8598
		  d.Value("nwarrow") = 8598
		  d.Value("nwnear") = 10535
		  d.Value("oS") = 9416
		  d.Value("oacute") = 243
		  d.Value("oast") = 8859
		  d.Value("ocir") = 8858
		  d.Value("ocirc") = 244
		  d.Value("ocy") = 1086
		  d.Value("odash") = 8861
		  d.Value("odblac") = 337
		  d.Value("odiv") = 10808
		  d.Value("odot") = 8857
		  d.Value("odsold") = 10684
		  d.Value("oelig") = 339
		  d.Value("ofcir") = 10687
		  d.Value("ofr") = 120108
		  d.Value("ogon") = 731
		  d.Value("ograve") = 242
		  d.Value("ogt") = 10689
		  d.Value("ohbar") = 10677
		  d.Value("ohm") = 937
		  d.Value("oint") = 8750
		  d.Value("olarr") = 8634
		  d.Value("olcir") = 10686
		  d.Value("olcross") = 10683
		  d.Value("oline") = 8254
		  d.Value("olt") = 10688
		  d.Value("omacr") = 333
		  d.Value("omega") = 969
		  d.Value("omicron") = 959
		  d.Value("omid") = 10678
		  d.Value("ominus") = 8854
		  d.Value("oopf") = 120160
		  d.Value("opar") = 10679
		  d.Value("operp") = 10681
		  d.Value("oplus") = 8853
		  d.Value("or") = 8744
		  d.Value("orarr") = 8635
		  d.Value("ord") = 10845
		  d.Value("order") = 8500
		  d.Value("orderof") = 8500
		  d.Value("ordf") = 170
		  d.Value("ordm") = 186
		  d.Value("origof") = 8886
		  d.Value("oror") = 10838
		  d.Value("orslope") = 10839
		  d.Value("orv") = 10843
		  d.Value("oscr") = 8500
		  d.Value("oslash") = 248
		  d.Value("osol") = 8856
		  d.Value("otilde") = 245
		  d.Value("otimes") = 8855
		  d.Value("otimesas") = 10806
		  d.Value("ouml") = 246
		  d.Value("ovbar") = 9021
		  d.Value("par") = 8741
		  d.Value("para") = 182
		  d.Value("parallel") = 8741
		  d.Value("parsim") = 10995
		  d.Value("parsl") = 11005
		  d.Value("part") = 8706
		  d.Value("pcy") = 1087
		  d.Value("percnt") = 37
		  d.Value("period") = 46
		  d.Value("permil") = 8240
		  d.Value("perp") = 8869
		  d.Value("pertenk") = 8241
		  d.Value("pfr") = 120109
		  d.Value("phi") = 966
		  d.Value("phiv") = 981
		  d.Value("phmmat") = 8499
		  d.Value("phone") = 9742
		  d.Value("pi") = 960
		  d.Value("pitchfork") = 8916
		  d.Value("piv") = 982
		  d.Value("planck") = 8463
		  d.Value("planckh") = 8462
		  d.Value("plankv") = 8463
		  d.Value("plus") = 43
		  d.Value("plusacir") = 10787
		  d.Value("plusb") = 8862
		  d.Value("pluscir") = 10786
		  d.Value("plusdo") = 8724
		  d.Value("plusdu") = 10789
		  d.Value("pluse") = 10866
		  d.Value("plusmn") = 177
		  d.Value("plussim") = 10790
		  d.Value("plustwo") = 10791
		  d.Value("pm") = 177
		  d.Value("pointint") = 10773
		  d.Value("popf") = 120161
		  d.Value("pound") = 163
		  d.Value("pr") = 8826
		  d.Value("prE") = 10931
		  d.Value("prap") = 10935
		  d.Value("prcue") = 8828
		  d.Value("pre") = 10927
		  d.Value("prec") = 8826
		  d.Value("precapprox") = 10935
		  d.Value("preccurlyeq") = 8828
		  d.Value("preceq") = 10927
		  d.Value("precnapprox") = 10937
		  d.Value("precneqq") = 10933
		  d.Value("precnsim") = 8936
		  d.Value("precsim") = 8830
		  d.Value("prime") = 8242
		  d.Value("primes") = 8473
		  d.Value("prnE") = 10933
		  d.Value("prnap") = 10937
		  d.Value("prnsim") = 8936
		  d.Value("prod") = 8719
		  d.Value("profalar") = 9006
		  d.Value("profline") = 8978
		  d.Value("profsurf") = 8979
		  d.Value("prop") = 8733
		  d.Value("propto") = 8733
		  d.Value("prsim") = 8830
		  d.Value("prurel") = 8880
		  d.Value("pscr") = 120005
		  d.Value("psi") = 968
		  d.Value("puncsp") = 8200
		  d.Value("qfr") = 120110
		  d.Value("qint") = 10764
		  d.Value("qopf") = 120162
		  d.Value("qprime") = 8279
		  d.Value("qscr") = 120006
		  d.Value("quaternions") = 8461
		  d.Value("quatint") = 10774
		  d.Value("quest") = 63
		  d.Value("questeq") = 8799
		  d.Value("quot") = 34
		  d.Value("rAarr") = 8667
		  d.Value("rArr") = 8658
		  d.Value("rAtail") = 10524
		  d.Value("rBarr") = 10511
		  d.Value("rHar") = 10596
		  d.Value("race") = 8765
		  d.Value("racute") = 341
		  d.Value("radic") = 8730
		  d.Value("raemptyv") = 10675
		  d.Value("rang") = 10217
		  d.Value("rangd") = 10642
		  d.Value("range") = 10661
		  d.Value("rangle") = 10217
		  d.Value("raquo") = 187
		  d.Value("rarr") = 8594
		  d.Value("rarrap") = 10613
		  d.Value("rarrb") = 8677
		  d.Value("rarrbfs") = 10528
		  d.Value("rarrc") = 10547
		  d.Value("rarrfs") = 10526
		  d.Value("rarrhk") = 8618
		  d.Value("rarrlp") = 8620
		  d.Value("rarrpl") = 10565
		  d.Value("rarrsim") = 10612
		  d.Value("rarrtl") = 8611
		  d.Value("rarrw") = 8605
		  d.Value("ratail") = 10522
		  d.Value("ratio") = 8758
		  d.Value("rationals") = 8474
		  d.Value("rbarr") = 10509
		  d.Value("rbbrk") = 10099
		  d.Value("rbrace") = 125
		  d.Value("rbrack") = 93
		  d.Value("rbrke") = 10636
		  d.Value("rbrksld") = 10638
		  d.Value("rbrkslu") = 10640
		  d.Value("rcaron") = 345
		  d.Value("rcedil") = 343
		  d.Value("rceil") = 8969
		  d.Value("rcub") = 125
		  d.Value("rcy") = 1088
		  d.Value("rdca") = 10551
		  d.Value("rdldhar") = 10601
		  d.Value("rdquo") = 8221
		  d.Value("rdquor") = 8221
		  d.Value("rdsh") = 8627
		  d.Value("real") = 8476
		  d.Value("realine") = 8475
		  d.Value("realpart") = 8476
		  d.Value("reals") = 8477
		  d.Value("rect") = 9645
		  d.Value("reg") = 174
		  d.Value("rfisht") = 10621
		  d.Value("rfloor") = 8971
		  d.Value("rfr") = 120111
		  d.Value("rhard") = 8641
		  d.Value("rharu") = 8640
		  d.Value("rharul") = 10604
		  d.Value("rho") = 961
		  d.Value("rhov") = 1009
		  d.Value("rightarrow") = 8594
		  d.Value("rightarrowtail") = 8611
		  d.Value("rightharpoondown") = 8641
		  d.Value("rightharpoonup") = 8640
		  d.Value("rightleftarrows") = 8644
		  d.Value("rightleftharpoons") = 8652
		  d.Value("rightrightarrows") = 8649
		  d.Value("rightsquigarrow") = 8605
		  d.Value("rightthreetimes") = 8908
		  d.Value("ring") = 730
		  d.Value("risingdotseq") = 8787
		  d.Value("rlarr") = 8644
		  d.Value("rlhar") = 8652
		  d.Value("rlm") = 8207
		  d.Value("rmoust") = 9137
		  d.Value("rmoustache") = 9137
		  d.Value("rnmid") = 10990
		  d.Value("roang") = 10221
		  d.Value("roarr") = 8702
		  d.Value("robrk") = 10215
		  d.Value("ropar") = 10630
		  d.Value("ropf") = 120163
		  d.Value("roplus") = 10798
		  d.Value("rotimes") = 10805
		  d.Value("rpar") = 41
		  d.Value("rpargt") = 10644
		  d.Value("rppolint") = 10770
		  d.Value("rrarr") = 8649
		  d.Value("rsaquo") = 8250
		  d.Value("rscr") = 120007
		  d.Value("rsh") = 8625
		  d.Value("rsqb") = 93
		  d.Value("rsquo") = 8217
		  d.Value("rsquor") = 8217
		  d.Value("rthree") = 8908
		  d.Value("rtimes") = 8906
		  d.Value("rtri") = 9657
		  d.Value("rtrie") = 8885
		  d.Value("rtrif") = 9656
		  d.Value("rtriltri") = 10702
		  d.Value("ruluhar") = 10600
		  d.Value("rx") = 8478
		  d.Value("sacute") = 347
		  d.Value("sbquo") = 8218
		  d.Value("sc") = 8827
		  d.Value("scE") = 10932
		  d.Value("scap") = 10936
		  d.Value("scaron") = 353
		  d.Value("sccue") = 8829
		  d.Value("sce") = 10928
		  d.Value("scedil") = 351
		  d.Value("scirc") = 349
		  d.Value("scnE") = 10934
		  d.Value("scnap") = 10938
		  d.Value("scnsim") = 8937
		  d.Value("scpolint") = 10771
		  d.Value("scsim") = 8831
		  d.Value("scy") = 1089
		  d.Value("sdot") = 8901
		  d.Value("sdotb") = 8865
		  d.Value("sdote") = 10854
		  d.Value("seArr") = 8664
		  d.Value("searhk") = 10533
		  d.Value("searr") = 8600
		  d.Value("searrow") = 8600
		  d.Value("sect") = 167
		  d.Value("semi") = 59
		  d.Value("seswar") = 10537
		  d.Value("setminus") = 8726
		  d.Value("setmn") = 8726
		  d.Value("sext") = 10038
		  d.Value("sfr") = 120112
		  d.Value("sfrown") = 8994
		  d.Value("sharp") = 9839
		  d.Value("shchcy") = 1097
		  d.Value("shcy") = 1096
		  d.Value("shortmid") = 8739
		  d.Value("shortparallel") = 8741
		  d.Value("shy") = 173
		  d.Value("sigma") = 963
		  d.Value("sigmaf") = 962
		  d.Value("sigmav") = 962
		  d.Value("sim") = 8764
		  d.Value("simdot") = 10858
		  d.Value("sime") = 8771
		  d.Value("simeq") = 8771
		  d.Value("simg") = 10910
		  d.Value("simgE") = 10912
		  d.Value("siml") = 10909
		  d.Value("simlE") = 10911
		  d.Value("simne") = 8774
		  d.Value("simplus") = 10788
		  d.Value("simrarr") = 10610
		  d.Value("slarr") = 8592
		  d.Value("smallsetminus") = 8726
		  d.Value("smashp") = 10803
		  d.Value("smeparsl") = 10724
		  d.Value("smid") = 8739
		  d.Value("smile") = 8995
		  d.Value("smt") = 10922
		  d.Value("smte") = 10924
		  d.Value("smtes") = 10924
		  d.Value("softcy") = 1100
		  d.Value("sol") = 47
		  d.Value("solb") = 10692
		  d.Value("solbar") = 9023
		  d.Value("sopf") = 120164
		  d.Value("spades") = 9824
		  d.Value("spadesuit") = 9824
		  d.Value("spar") = 8741
		  d.Value("sqcap") = 8851
		  d.Value("sqcaps") = 8851
		  d.Value("sqcup") = 8852
		  d.Value("sqcups") = 8852
		  d.Value("sqsub") = 8847
		  d.Value("sqsube") = 8849
		  d.Value("sqsubset") = 8847
		  d.Value("sqsubseteq") = 8849
		  d.Value("sqsup") = 8848
		  d.Value("sqsupe") = 8850
		  d.Value("sqsupset") = 8848
		  d.Value("sqsupseteq") = 8850
		  d.Value("squ") = 9633
		  d.Value("square") = 9633
		  d.Value("squarf") = 9642
		  d.Value("squf") = 9642
		  d.Value("srarr") = 8594
		  d.Value("sscr") = 120008
		  d.Value("ssetmn") = 8726
		  d.Value("ssmile") = 8995
		  d.Value("sstarf") = 8902
		  d.Value("star") = 9734
		  d.Value("starf") = 9733
		  d.Value("straightepsilon") = 1013
		  d.Value("straightphi") = 981
		  d.Value("strns") = 175
		  d.Value("sub") = 8834
		  d.Value("subE") = 10949
		  d.Value("subdot") = 10941
		  d.Value("sube") = 8838
		  d.Value("subedot") = 10947
		  d.Value("submult") = 10945
		  d.Value("subnE") = 10955
		  d.Value("subne") = 8842
		  d.Value("subplus") = 10943
		  d.Value("subrarr") = 10617
		  d.Value("subset") = 8834
		  d.Value("subseteq") = 8838
		  d.Value("subseteqq") = 10949
		  d.Value("subsetneq") = 8842
		  d.Value("subsetneqq") = 10955
		  d.Value("subsim") = 10951
		  d.Value("subsub") = 10965
		  d.Value("subsup") = 10963
		  d.Value("succ") = 8827
		  d.Value("succapprox") = 10936
		  d.Value("succcurlyeq") = 8829
		  d.Value("succeq") = 10928
		  d.Value("succnapprox") = 10938
		  d.Value("succneqq") = 10934
		  d.Value("succnsim") = 8937
		  d.Value("succsim") = 8831
		  d.Value("sum") = 8721
		  d.Value("sung") = 9834
		  d.Value("sup1") = 185
		  d.Value("sup2") = 178
		  d.Value("sup3") = 179
		  d.Value("sup") = 8835
		  d.Value("supE") = 10950
		  d.Value("supdot") = 10942
		  d.Value("supdsub") = 10968
		  d.Value("supe") = 8839
		  d.Value("supedot") = 10948
		  d.Value("suphsol") = 10185
		  d.Value("suphsub") = 10967
		  d.Value("suplarr") = 10619
		  d.Value("supmult") = 10946
		  d.Value("supnE") = 10956
		  d.Value("supne") = 8843
		  d.Value("supplus") = 10944
		  d.Value("supset") = 8835
		  d.Value("supseteq") = 8839
		  d.Value("supseteqq") = 10950
		  d.Value("supsetneq") = 8843
		  d.Value("supsetneqq") = 10956
		  d.Value("supsim") = 10952
		  d.Value("supsub") = 10964
		  d.Value("supsup") = 10966
		  d.Value("swArr") = 8665
		  d.Value("swarhk") = 10534
		  d.Value("swarr") = 8601
		  d.Value("swarrow") = 8601
		  d.Value("swnwar") = 10538
		  d.Value("szlig") = 223
		  d.Value("target") = 8982
		  d.Value("tau") = 964
		  d.Value("tbrk") = 9140
		  d.Value("tcaron") = 357
		  d.Value("tcedil") = 355
		  d.Value("tcy") = 1090
		  d.Value("tdot") = 8411
		  d.Value("telrec") = 8981
		  d.Value("tfr") = 120113
		  d.Value("there4") = 8756
		  d.Value("therefore") = 8756
		  d.Value("theta") = 952
		  d.Value("thetasym") = 977
		  d.Value("thetav") = 977
		  d.Value("thickapprox") = 8776
		  d.Value("thicksim") = 8764
		  d.Value("thinsp") = 8201
		  d.Value("thkap") = 8776
		  d.Value("thksim") = 8764
		  d.Value("thorn") = 254
		  d.Value("tilde") = 732
		  d.Value("times") = 215
		  d.Value("timesb") = 8864
		  d.Value("timesbar") = 10801
		  d.Value("timesd") = 10800
		  d.Value("tint") = 8749
		  d.Value("toea") = 10536
		  d.Value("top") = 8868
		  d.Value("topbot") = 9014
		  d.Value("topcir") = 10993
		  d.Value("topf") = 120165
		  d.Value("topfork") = 10970
		  d.Value("tosa") = 10537
		  d.Value("tprime") = 8244
		  d.Value("trade") = 8482
		  d.Value("triangle") = 9653
		  d.Value("triangledown") = 9663
		  d.Value("triangleleft") = 9667
		  d.Value("trianglelefteq") = 8884
		  d.Value("triangleq") = 8796
		  d.Value("triangleright") = 9657
		  d.Value("trianglerighteq") = 8885
		  d.Value("tridot") = 9708
		  d.Value("trie") = 8796
		  d.Value("triminus") = 10810
		  d.Value("triplus") = 10809
		  d.Value("trisb") = 10701
		  d.Value("tritime") = 10811
		  d.Value("trpezium") = 9186
		  d.Value("tscr") = 120009
		  d.Value("tscy") = 1094
		  d.Value("tshcy") = 1115
		  d.Value("tstrok") = 359
		  d.Value("twixt") = 8812
		  d.Value("twoheadleftarrow") = 8606
		  d.Value("twoheadrightarrow") = 8608
		  d.Value("uArr") = 8657
		  d.Value("uHar") = 10595
		  d.Value("uacute") = 250
		  d.Value("uarr") = 8593
		  d.Value("ubrcy") = 1118
		  d.Value("ubreve") = 365
		  d.Value("ucirc") = 251
		  d.Value("ucy") = 1091
		  d.Value("udarr") = 8645
		  d.Value("udblac") = 369
		  d.Value("udhar") = 10606
		  d.Value("ufisht") = 10622
		  d.Value("ufr") = 120114
		  d.Value("ugrave") = 249
		  d.Value("uharl") = 8639
		  d.Value("uharr") = 8638
		  d.Value("uhblk") = 9600
		  d.Value("ulcorn") = 8988
		  d.Value("ulcorner") = 8988
		  d.Value("ulcrop") = 8975
		  d.Value("ultri") = 9720
		  d.Value("umacr") = 363
		  d.Value("uml") = 168
		  d.Value("uogon") = 371
		  d.Value("uopf") = 120166
		  d.Value("uparrow") = 8593
		  d.Value("updownarrow") = 8597
		  d.Value("upharpoonleft") = 8639
		  d.Value("upharpoonright") = 8638
		  d.Value("uplus") = 8846
		  d.Value("upsi") = 965
		  d.Value("upsih") = 978
		  d.Value("upsilon") = 965
		  d.Value("upuparrows") = 8648
		  d.Value("urcorn") = 8989
		  d.Value("urcorner") = 8989
		  d.Value("urcrop") = 8974
		  d.Value("uring") = 367
		  d.Value("urtri") = 9721
		  d.Value("uscr") = 120010
		  d.Value("utdot") = 8944
		  d.Value("utilde") = 361
		  d.Value("utri") = 9653
		  d.Value("utrif") = 9652
		  d.Value("uuarr") = 8648
		  d.Value("uuml") = 252
		  d.Value("uwangle") = 10663
		  d.Value("vArr") = 8661
		  d.Value("vBar") = 10984
		  d.Value("vBarv") = 10985
		  d.Value("vDash") = 8872
		  d.Value("vangrt") = 10652
		  d.Value("varepsilon") = 1013
		  d.Value("varkappa") = 1008
		  d.Value("varnothing") = 8709
		  d.Value("varphi") = 981
		  d.Value("varpi") = 982
		  d.Value("varpropto") = 8733
		  d.Value("varr") = 8597
		  d.Value("varrho") = 1009
		  d.Value("varsigma") = 962
		  d.Value("varsubsetneq") = 8842
		  d.Value("varsubsetneqq") = 10955
		  d.Value("varsupsetneq") = 8843
		  d.Value("varsupsetneqq") = 10956
		  d.Value("vartheta") = 977
		  d.Value("vartriangleleft") = 8882
		  d.Value("vartriangleright") = 8883
		  d.Value("vcy") = 1074
		  d.Value("vdash") = 8866
		  d.Value("vee") = 8744
		  d.Value("veebar") = 8891
		  d.Value("veeeq") = 8794
		  d.Value("vellip") = 8942
		  d.Value("verbar") = 124
		  d.Value("vert") = 124
		  d.Value("vfr") = 120115
		  d.Value("vltri") = 8882
		  d.Value("vnsub") = 8834
		  d.Value("vnsup") = 8835
		  d.Value("vopf") = 120167
		  d.Value("vprop") = 8733
		  d.Value("vrtri") = 8883
		  d.Value("vscr") = 120011
		  d.Value("vsubnE") = 10955
		  d.Value("vsubne") = 8842
		  d.Value("vsupnE") = 10956
		  d.Value("vsupne") = 8843
		  d.Value("vzigzag") = 10650
		  d.Value("wcirc") = 373
		  d.Value("wedbar") = 10847
		  d.Value("wedge") = 8743
		  d.Value("wedgeq") = 8793
		  d.Value("weierp") = 8472
		  d.Value("wfr") = 120116
		  d.Value("wopf") = 120168
		  d.Value("wp") = 8472
		  d.Value("wr") = 8768
		  d.Value("wreath") = 8768
		  d.Value("wscr") = 120012
		  d.Value("xcap") = 8898
		  d.Value("xcirc") = 9711
		  d.Value("xcup") = 8899
		  d.Value("xdtri") = 9661
		  d.Value("xfr") = 120117
		  d.Value("xhArr") = 10234
		  d.Value("xharr") = 10231
		  d.Value("xi") = 958
		  d.Value("xlArr") = 10232
		  d.Value("xlarr") = 10229
		  d.Value("xmap") = 10236
		  d.Value("xnis") = 8955
		  d.Value("xodot") = 10752
		  d.Value("xopf") = 120169
		  d.Value("xoplus") = 10753
		  d.Value("xotime") = 10754
		  d.Value("xrArr") = 10233
		  d.Value("xrarr") = 10230
		  d.Value("xscr") = 120013
		  d.Value("xsqcup") = 10758
		  d.Value("xuplus") = 10756
		  d.Value("xutri") = 9651
		  d.Value("xvee") = 8897
		  d.Value("xwedge") = 8896
		  d.Value("yacute") = 253
		  d.Value("yacy") = 1103
		  d.Value("ycirc") = 375
		  d.Value("ycy") = 1099
		  d.Value("yen") = 165
		  d.Value("yfr") = 120118
		  d.Value("yicy") = 1111
		  d.Value("yopf") = 120170
		  d.Value("yscr") = 120014
		  d.Value("yucy") = 1102
		  d.Value("yuml") = 255
		  d.Value("zacute") = 378
		  d.Value("zcaron") = 382
		  d.Value("zcy") = 1079
		  d.Value("zdot") = 380
		  d.Value("zeetrf") = 8488
		  d.Value("zeta") = 950
		  d.Value("zfr") = 120119
		  d.Value("zhcy") = 1078
		  d.Value("zigrarr") = 8669
		  d.Value("zopf") = 120171
		  d.Value("zscr") = 120015
		  d.Value("zwj") = 8205
		  d.Value("zwnj") = 8204
		  
		  Return d
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function IsASCIIAlphaChar(c As String) As Boolean
		  // Returns True if the passed character `c` is A-Z or a-z.
		  
		  Select Case c.Asc
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
		  
		  Select Case c.Asc
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
		  
		  Select Case c.Asc
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
		  
		  Select Case c.Asc
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
		  Var start As Integer = chars.IndexOf("&")
		  If start = -1 Or chars.IndexOf(";") = -1 Then Return
		  
		  Var c As String
		  Var tmp() As String
		  Var i As Integer = start
		  Var xLimit As Integer
		  Var codePoint As Integer
		  Var seenSemiColon As Boolean = False
		  While i < chars.LastIndex
		    tmp.ResizeTo(-1)
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
		        xLimit = Min(chars.LastIndex, i + 7)
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
		        xLimit = Min(chars.LastIndex, i + 6)
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
		          codePoint = String.FromArray(tmp, "").Val
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
		      xLimit = Min(chars.LastIndex, i + 30)
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
		      Var entityName As String = String.FromArray(tmp, "")
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
		    Var tmp() As String = t.Split("")
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
		  
		  Var chars() As String = t.Split("")
		  Var pos As Integer = 0
		  Var c As String
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
		  
		  Var pos As Integer = 0
		  Var c As String
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


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Static d As Dictionary = InitialiseCharacterReferences
			  Return d
			  
			End Get
		#tag EndGetter
		Shared CharacterReferences As Dictionary
	#tag EndComputedProperty

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
