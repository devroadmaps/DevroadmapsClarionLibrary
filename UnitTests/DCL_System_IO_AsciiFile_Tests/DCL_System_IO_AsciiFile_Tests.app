hl职!YLI悍槟񷈭顒�v$L睧h-观��  奃仙�7@u尦��         政��!       TmO �+     捄V @/           +       %BeforeGlobalIncludes     +*    e   include('DCL_System_IO_AsciiFile.inc'),once
include('DCL_System_Diagnostics_Logger.inc'),once


 �             +       %GlobalMap     +*       	include('cwutil.inc'),once �  L   M                                                                                                                                                                                                                             �  P蕱鮩滶曚杂镸覀         '���!       �4 �+     讓V @/           +       %ProcessedCode     +*    �  	testfilename = GetTestDirectory() & '\testdata'
	if not exists(testfilename)
		CreateDirectory(testfilename)
	end
	AssertThat(exists(testfilename),IsEqualTo(true),'Directory does not exist: ' & testfilename)
	testfilename = testfilename & '\test2.txt'
	if exists(testfilename)
		remove(testfilename)
	END
	AssertThat(exists(testfilename),IsEqualTo(false),'Could not delete ' & testfilename)
	testfile.createfile(testfilename)
	loop x = 1 to 5
		testfile.write('line ' & x)
	end
	testfile.closefile()
	AssertThat(exists(testfilename),IsEqualTo(true),'Could not create ' & testfilename)

	testfile.openfile(testfilename)
	reccount = 0
	loop while testfile.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount),'Unexpected text found in ' & testfilename)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename)
	
	! Create a queu with six lines
	testfile.openfile(testfilename)
	free(testq)
	loop x = 1 to 6
		testq.txt = 'line ' & x - 1
		add(testq)
	end
	AssertThat(testfile.replace(testfilename,testq,testq.txt),IsEqualTo(level:benign),'Replace method failed')
	

	testfile.openfile(testfilename)
	! Verify the new file
	reccount = 0
	loop while testfile.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount -1),'Unexpected text found in ' & testfilename)
	end
	AssertThat(reccount,IsEqualTo(6),'Wrong number of records in ' & testfilename)


 �  P   }        +       %DataSection     +*    e  testfilename                        cstring(500)
testq                               QUEUE
txt                                     cstring(500)
									end
testfile                            DCL_System_IO_AsciiFile
x                                   long
reccount                            long
txt                                 cstring(500)
 �  D   L                                                �  �#快W緅L剉$mGX�         ����!       3 U @/     3 U @/                                                                                                                                                                                                                            �  tS:+^'kA杫 �	胭$         6���!       � V @/     嵑V @/           +       %ProcessedCode     +*    �       TestDirectory = longpath() & '\DCL_System_IO_AsciiFile_Tests'
    if not exists(TestDirectory) then TestDirectory = LongPath().
    TestDirectory = TestDirectory & '\testdata'
    return TestDirectory
        
        
    
    
 �             +       %LocalDataAfterClasses     +*    )   TestDirectory               cstring(500) �                                                                    �  p蔣�!C閬�(畏         ����!       4 U @/     4 U @/                              ��       dummy         Window                                                                                                                                                      j   ($p歔�D�2鱡�松         蛀��!       �=� �+     !蒚 @/                  %Parameters %                          (*long addr)       %ProcedureParameters                                 %ProcedureParameterName %                   %ProcedureParameters                           addr       %ProcedureParameterOrigName %                   %ProcedureParameters                           addr       %ProcedureParameterType %                   %ProcedureParameters                           long       %ProcedureParameterDefault %                   %ProcedureParameters                                     %ProcedureParameterOmitted                    %ProcedureParameters                                %ProcedureParameterByReference                    %ProcedureParameters                               %GenerateOpenClose                                %GenerateSaveRestore                                %ProcedureParameterConstant                    %ProcedureParameters                                                                                                                                                                                                                                                �  �1M箸LM媞审a怤�         k���!       sl9 �+     謱V @/           +       %ProcessedCode     +*    R  	dbg.SetPrefix('***')

    testfilename = GetTestDirectory() & '\testdata'
    if not exists(testfilename)
		CreateDirectory(testfilename)
	end
	AssertThat(exists(testfilename),IsEqualTo(true),'Directory does not exist: ' & testfilename)
	testfilename = testfilename & '\test.txt'
	if exists(testfilename)
		remove(testfilename)
	END
	AssertThat(exists(testfilename),IsEqualTo(false),'Could not delete ' & testfilename)
	dbg.write('Before CreateFile')
	testfile.createfile(testfilename)
	dbg.write('After CreateFile, before writing lines')
	loop x = 1 to 5
		dbg.write('Writing line ' & x)
		testfile.write('line ' & x)
	end
	dbg.write('Before CloseFile')
	testfile.closefile()
	AssertThat(exists(testfilename),IsEqualTo(true),'Could not create ' & testfilename)
	
	testfile.openfile(testfilename)
	reccount = 0
	loop while testfile.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount),'Unexpected text found in ' & testfilename)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename)
	testfile.CloseFile()

 �     <        +       %DataSection     +*    �  testfilename                        cstring(500)
testq                               QUEUE
txt                                     cstring(500)
									end
testfile                            DCL_System_IO_AsciiFile
x                                   long
reccount                            long
txt                             cstring(500)
dbg                             DCL_System_Diagnostics_Logger �                                                                                                                         .  薜軹aI凊竦kJ朊         佝��!       ;Z �,     Dm �,               FilesOpened �                                                                                                                                                                                                                                                                                                                                                                                                                                                           �  	喦WD鐸噐T�<.婯         ����!       �4 �+     �4 �+                                                                                                                                                                                                                            r   >器丠F保D需鈒�         孆��!       3 U @/     埡V @/                  Read50KText_VerifyLength 0闭�	�H幻孭禩吰       (*long addr),long,pascal p蔣�!C閬�(畏      
          Test procedures                        ClarionTest$TestProcedure        Test procedures s @/ B篤       埡V @/           ClarionTest$TestSupport    ����                      %AddressVar %                          addr    
   %TestCode %                                    %TestPriority %                          10       %TestGroup %                                 淋&"OO蒠H+鮕嚄明欝哅彽I5o�   克|v踈BI�%"B虜�#快W緅L剉$mGX�                                                                                                                                            f   $咅〾�$E淚顸N	 l         Ⅻ��!       TmO �+     櫤V @/            )  -- NAMESPACE ClarionDefaultNamespace
#system win32 dll
#model clarion dll
#pragma define(_ABCDllMode_=>0) -- GENERATED
#pragma define(_ABCLinkMode_=>1) -- GENERATED
#compile "DCL_System_IO_AsciiFile_Tests.clw" -- GENERATED
#compile "DCL_System_IO_AsciiFile_Tests001.clw" -- GENERATED
#compile "DCL_System_IO_AsciiFile_Tests003.clw" -- GENERATED
#compile "DCL_System_IO_AsciiFile_Tests004.clw" -- GENERATED
#compile "DCL_System_IO_AsciiFile_Tests005.clw" -- GENERATED
#compile "DCL_System_IO_AsciiFile_Tests006.clw" -- GENERATED
#compile "DCL_System_IO_AsciiFile_Tests_BC0.CLW" -- GENERATED
#compile "DCL_SYSTEM_IO_ASCIIFILE_TESTS_BC.CLW" -- GENERATED
#pragma link("C%V%asc%X%%L%.lib") -- GENERATED
#pragma link("DevRoadmapsClarion.lib") -- GENERATED
#link "DCL_System_IO_AsciiFile_Tests.DLL"
                                                                                                                                                                    �  �0訁駬@�rs襮         ����!       tl9 �+     tl9 �+                              ��       dummy         Window                                                                                                                                                      �  宑9?鲄G挵�&%�         ����!       � V @/     � V @/                                                                                                                                                                                                                            j   淋&"OO蒠H+鮕         蛀��!       3 U @/     4 U @/                  %Parameters %                          (*long addr)       %ProcedureParameters                                 %ProcedureParameterName %                   %ProcedureParameters                           addr       %ProcedureParameterOrigName %                   %ProcedureParameters                           addr       %ProcedureParameterType %                   %ProcedureParameters                           long       %ProcedureParameterDefault %                   %ProcedureParameters                                     %ProcedureParameterOmitted                    %ProcedureParameters                                %ProcedureParameterByReference                    %ProcedureParameters                               %GenerateOpenClose                                %GenerateSaveRestore                                %ProcedureParameterConstant                    %ProcedureParameters                                                                                                                                                                                                                                                j   邰潓苶vG㈨�猲&� Y      Y  収��!       TmO �+     �%V @/        )         %ClassItem %                            ErrorManager             ErrorStatusManager             FuzzyMatcher
   
       
   INIManager
   
       
   Translator       %DefaultBaseClassType %                   %ClassItem                 ErrorManager
   
       
   ErrorClass             ErrorStatusManager             ErrorStatusClass             FuzzyMatcher
   
       
   FuzzyClass
   
       
   INIManager             INIClass
   
       
   Translator             TranslatorClass       %ActualDefaultBaseClassType %                   %ClassItem                 ErrorManager                             ErrorStatusManager                             FuzzyMatcher                
   
       
   INIManager                
   
       
   Translator                       %ClassLines %                  %ClassItem            %ProgramAuthor %                                    %ProgramIcon %                                    %MessageDescription                               %GlobalExternal                                %ExternalSource %                          Dynamic Link Library (DLL)       %GenerateEmbedComments                             	   %INIType %                          NVD_INI    	   %INIFile %                          Program Name.INI    	   %ININame %                                    %INIProgramIniLocation %                          APPDIR       %INICSIDLDirectory %                          SV:CSIDL_PERSONAL       %CSIDLCompanyDir %                                    %CSIDLProductDir %                                    %CSIDLCreate                                %INIInAppDirectory                            	   %REGRoot %                          REG_CLASSES_ROOT       %DisableINISaveWindow                                %PreserveVars                        %PreserveVar %                   %PreserveVars            %EnableExceptionMessage                                %EnableRunTimeTranslator                                %FuzzyMatchingEnabled                               %IgnoreCase                            
   %WordOnly                                %WindowFrameDragging                                %UseDefaultXPManifest                                %GenerateXPManifest                                %LinkGenerateXPManifest                                %AddVistaXPManifest                                %VistaManifestExecutionLevel %             	   	       	   asInvoker       %VistaManifestUIAccess                                %W7ManifestVista                                %W7ManifestW7                                 %ForceMakeTransparentXPManifest                                %ExtUIXPMenuEnableGlobal                                %ExtUIXPMenuColorTypeGlobal %                          OFF       %ExtUIXPMenuDisableImageBar                               %ExtUIXPMenuEnableRuntime                                %ExtUIXPMenuRuntimeVar %                                    %ExtUIXPMenuColorLeftGlobal                     祆�        %ExtUIXPMenuColorRightGlobal                     Е�     (   %ExtUIXPMenuColorSelectionBarLeftGlobal                     祆�     )   %ExtUIXPMenuColorSelectionBarRightGlobal                     祆�        %ExtUIXPMenuSelVertical                            '   %ExtUIXPMenuColorSelectionBorderGlobal                     祆�        %ExtUIXPMenuColorHotLeftGlobal                     祆�         %ExtUIXPMenuColorHotRightGlobal                     祆�     $   %ExtUIXPMenuColorSelectedLeftGlobal                     祆�     %   %ExtUIXPMenuColorSelectedRightGlobal                     祆�     %   %ExtUIXPMenuColorNormalBarLeftGlobal                     祆�     &   %ExtUIXPMenuColorNormalBarRightGlobal                     祆�     &   %ExtUIXPMenuColorItemBackgroundGlobal                       �       %ExtUIXPMenuColorNormalText                                %ExtUIXPMenuColorSelectedText                                %ExtUIXPMenuColorHotText                                %ExtUIXPMenuFlat                               %ExtUIXPMenuShowImageBar                                %ExtUIXPMenuSeparator3D                               %ExtUIXPMenuSeparatorFull                                %ExtUIXPMenuVerticalLine                               %ExtUIMDITabGlobal %                          DISABLE       %ExtUIMDITabStyleGlobal %                          Default       %ExtUITabStyleGlobal %                          Default       %WindowEnableEnhanceFocus                                %SelectedText                               %SelectedRadio                               %SelectedSpin                               %SelectedCheck                               %SelectedDropList                               %SelectedList                               %SelectedDisplayChangeColor                               %SelectedColor                     ��         %SelectedStyle                               %SelectedRequired                                %SelectedRequiredColor                     ��         %SelectedDisplayBox                               %SelectedDisplayBoxFillColor                     ��         %SelectedDisplayBoxBorderColor                                %SelectedDisplayBoxBorderSize %                              %SelectedRequiredBox                             %   %SelectedRequiredDisplayBoxFillColor                     �       '   %SelectedRequiredDisplayBoxBorderColor                                %SelectedCaret                               %SelectedCaretColor                     ���        %SelectedCaretCharacter %                          �    "   %SelectedCaretCharacterSeparation %                          8       %ExcludeSelectedDropList                                %GlobalUseEnterInsteadTab                             !   %GlobalUseEnterInsteadTabExclude %                        %GlobalUseEnterInsteadTabEnable %                          Enable    %   %GlobalUseEnterInsteadTabEnableValue %                          True       %GlobalInterLine %                               %GlobalEnableAutoSizeColumn                                %GlobalEnableListFormatManager                             "   %GlobalUserFieldListFormatManager %                          1       %TableOrigin %                          Application       %FileEquate %             	   	       	   LFM_CFile       %ConfigFilePRE %                          CFG       %ConfigFileOEM                                %ConfigFileTHREAD                               %ConfigFileENCRYPT                                %ConfigFilePASSWORD %                                    %FormatNameSize %                              %FormatBufferSize %                              %VariableBufferSize %                              %ConfigFilePath %                                    %UseConfigFileName %                          Default       %ConfigFileNAME %                          Formats.FDB       %ColonCounter %                                    %WrongSymbol %                                    %DictionaryTableOrigin !                     %GlobalLFMSortOrderMenuText %             	   	       	   SortOrder       %GlobalEnableRebase                                %RBDMethod %                          Specify manually       %RBDImageBase %                          10000000       %DefaultGenerate                                %DefaultRILogout                               %LockRecoverTime %                    
          %DefaultThreaded %                          Use File Setting       %DefaultCreate %                          Use File Setting       %DefaultExternal %                          None External       %DefaultLocalExternal                                %DefaultExternalSource %                                    %DefaultExternalAPP                                %DefaultExport                                %DefaultOpenMode %                          Share       %DefaultUserAccess %             
   
       
   Read/Write       %DefaultOtherAccess %             	   	       	   Deny None       %DefaultLazyOpen                               %GeneratePropDataPath                                %PropDataPathLocation %                          CSIDLLIKEINI       %DataPathCSIDLDirectory %                          SV:CSIDL_PERSONAL       %DataPathCSIDLCompanyDir %                                    %DataPathCSIDLProductDir %                                    %DataPathCSIDLCreate                                %DataPathOtherDirectory %                                    %DataPathOtherDirectoryCreate                                %OverrideGenerate                    %File            %OverrideRILogout %                   %File                                 Use Default       %GlobalObject %                   %ClassItem                 ErrorManager             YES             ErrorStatusManager             YES             FuzzyMatcher             YES
   
       
   INIManager             YES
   
       
   Translator             YES       %ThisObjectName %                   %ClassItem                 ErrorManager             GlobalErrors             ErrorStatusManager             GlobalErrorsStatus             FuzzyMatcher             FuzzyMatcher
   
       
   INIManager             INIMgr
   
       
   Translator
   
       
   Translator       %UseDefaultABCBaseClass                    %ClassItem                 ErrorManager                       ErrorStatusManager                       FuzzyMatcher          
   
       
   INIManager          
   
       
   Translator                 %UseABCBaseClass                    %ClassItem                 ErrorManager                       ErrorStatusManager                       FuzzyMatcher          
   
       
   INIManager          
   
       
   Translator                 %ABCBaseClass %                   %ClassItem                 ErrorManager                             ErrorStatusManager                             FuzzyMatcher                
   
       
   INIManager                
   
       
   Translator                       %ExtBaseClass %                   %ClassItem            %BaseClassIncludeFile %                   %ClassItem            %DeriveFromBaseClass                    %ClassItem                 ErrorManager                        ErrorStatusManager                        FuzzyMatcher           
   
       
   INIManager           
   
       
   Translator                  %NewMethods                   %ClassItem            %NewMethodName %                   %NewMethods            %NewMethodPrototype %                   %NewMethods            %NewClassPropertyItems                   %ClassItem            %NewClassProperty %                   %NewClassPropertyItems            %NewClassDataType %                   %NewClassPropertyItems            %NewClassOtherType %                   %NewClassPropertyItems            %NewClassDataIsRef                    %NewClassPropertyItems            %NewClassDataSize %                   %NewClassPropertyItems            %NewClassDataDim1 %                   %NewClassPropertyItems            %NewClassDataDim2 %                   %NewClassPropertyItems            %NewClassDataDim3 %                   %NewClassPropertyItems            %NewClassDataDim4 %                   %NewClassPropertyItems            %ClassMethods                   %ClassItem            %ClassMethodName %                   %ClassMethods            %ClassMethodPrototype %                   %ClassMethods            %ClassPropertyItems                   %ClassItem            %ClassProperty %                   %ClassPropertyItems            %ClassDataType %                   %ClassPropertyItems            %ClassOtherType %                   %ClassPropertyItems            %ClassDataIsRef                    %ClassPropertyItems            %ClassDataSize %                   %ClassPropertyItems            %ClassDataDim1 %                   %ClassPropertyItems            %ClassDataDim2 %                   %ClassPropertyItems            %ClassDataDim3 %                   %ClassPropertyItems            %ClassDataDim4 %                   %ClassPropertyItems            %OverrideThreaded %                   %File                                 Use Default       %OverrideCreate %                   %File                                 Use Default       %OverrideExternal %                   %File                                 Use Default       %OverrideLocalExternal                    %File            %OverrideExternalSource %                   %File            %OverrideExternalAPP                    %File            %OverrideExport                    %File            %FileDeclarationMode %                   %File                                 Use User Options       %FileDeclarationType                    %File                                      %FileDeclarationThread                    %File                                      %FileDeclarationBindable                    %File                                     %FileDeclarationName %                   %File            %FileDeclarationOver %                   %File            %OverrideOpenMode %                   %File                                 Use Default       %OverrideUserAccess %                   %File                                 Use Default       %OverrideOtherAccess %                   %File                                 Use Default       %OverrideLazyOpen %                   %File                                 Use Default       %StandardExternalModule                    %Module                                              CM_System_IO_AsciiFile_Tests.clw          #   #       #   CM_System_IO_AsciiFile_Tests001.clw          #   #       #   CM_System_IO_AsciiFile_Tests003.clw          #   #       #   CM_System_IO_AsciiFile_Tests004.clw          !   !       !   DCL_System_IO_AsciiFile_Tests.clw          $   $       $   DCL_System_IO_AsciiFile_Tests001.clw          $   $       $   DCL_System_IO_AsciiFile_Tests003.clw          $   $       $   DCL_System_IO_AsciiFile_Tests004.clw          $   $       $   DCL_System_IO_AsciiFile_Tests005.clw          $   $       $   DCL_System_IO_AsciiFile_Tests006.clw                       ExtractProceduresTest.clw                       ExtractProceduresTest001.clw                       ExtractProceduresTest002.clw                       ExtractProceduresTest003.clw                       ExtractProceduresTest004.clw                       System_IO_AsciiFile_Tests.clw                          System_IO_AsciiFile_Tests001.clw                          System_IO_AsciiFile_Tests003.clw                 %NoGenerateGlobals                                %WindowManagerType %                          WindowManager       %ResetOnGainFocus                                %AutoToolbar                               %AutoRefresh                               %ImageClass %                          ImageManager       %ErrorStatusManagerType %                          ErrorStatusClass       %ErrorManagerType %             
   
       
   ErrorClass       %DefaultErrorCategory %                          ABC       %AllowSelectCopy                                %StoreErrorHistory                                %LimitStoredHistory                                %ErrorHistoryThreshold %                    ,         %HistoryViewTrigger %                          Level:Fatal       %PopupClass %             
   
       
   PopupClass       %SelectFileClass %                          SelectFileClass       %ResizerType %                          WindowResizeClass       %ResizerDeFaultFindParents                               %ResizerDefaultOptimizeMoves                               %ResizerDefaultOptimizeRedraws                            
   %INIClass %                          INIClass       %RunTimeTranslatorType %                          TranslatorClass       %ExtractionFilename %                                    %TranslationGroups                        %TranslationFile %                   %TranslationGroups            %TranslationGroup %                   %TranslationGroups            %CalendarManagerType %                          CalendarClass       %GlobalChangeColor                                %GlobalColorSunday                     �          %GlobalColorSaturday                     �          %GlobalColorHoliday                      �         %GlobalColorOther                                %GlobalSelectOnClose %                          Select       %GlobalUseABCClasess                               %FileManagerType %                          FileManager       %ViewManagerType %                          ViewManager       %RelationManagerType %                          RelationManager       %BrowserType %                          BrowseClass       %ActiveInvisible                                %AllowUnfilled                                %RetainRow                               %FileDropManagerType %                          FileDropClass       %FileDropComboManagerType %                          FileDropComboClass       %FormVCRManagerType %                          FormVCRClass       %BrowseEIPManagerType %                          BrowseEIPManager       %EditInPlaceInterface %                          Detailed       %EditInPlaceType %                          EditEntryClass       %EditInPlaceEntryType %                          EditEntryClass       %EditInPlaceTextType %                          EditTextClass       %EditInPlaceCheckType %                          EditCheckClass       %EditInPlaceSpinType %                          EditSpinClass       %EditInPlaceDropListType %                          EditDropListClass       %EditInPlaceDropComboType %                          EditDropComboClass       %EditInPlaceColorType %                          EditColorClass       %EditInPlaceFileType %                          EditFileClass       %EditInPlaceFontType %                          EditFontClass       %EditInPlaceMultiSelectType %                          EditMultiSelectClass       %EditInPlaceCalendarType %                          EditCalendarClass       %EditInPlaceLookupType %                          EditLookupClass       %EditInPlaceOtherType %                          EditEntryClass       %QBEFormType %                          QueryFormClass       %QBEFormVisualType %                          QueryFormVisual       %QBEListType %                          QueryListClass       %QBEListVisualType %                          QueryListVisual       %StepManagerType %             	   	       	   StepClass       %StepManagerLongType %                          StepLongClass       %StepManagerRealType %                          StepRealClass       %StepManagerStringType %                          StepStringClass       %StepManagerCustomType %                          StepCustomClass       %StepLocatorType %                          StepLocatorClass       %EntryLocatorType %                          EntryLocatorClass       %IncrementalLocatorType %                          IncrementalLocatorClass       %FilteredLocatorType %                          FilterLocatorClass       %FuzzyMatcherClass %             
   
       
   FuzzyClass       %GridClass %             	   	       	   GridClass       %SidebarClass %                          SidebarClass       %ProcessType %                          ProcessClass       %PrintPreviewType %                          PrintPreviewClass       %ReportManagerType %                          ReportManager    !   %ReportTargetSelectorManagerType %                          ReportTargetSelectorClass       %BreakManagerType %                          BreakManagerClass       %AsciiViewerClass %                          AsciiViewerClass       %AsciiSearchClass %                          AsciiSearchClass       %AsciiPrintClass %                          AsciiPrintClass       %AsciiFileManagerType %                          AsciiFileClass       %ToolbarClass %                          ToolbarClass       %ToolbarListBoxType %                          ToolbarListboxClass       %ToolbarRelTreeType %                          ToolbarReltreeClass       %ToolbarUpdateClassType %                          ToolbarUpdateClass       %ToolbarFormVCRType %                          ToolbarFormVCRClass       %OverrideAbcSettings                                %AbcSourceLocation %                          LINK       %AbcLibraryName %                                    %AppTemplateFamily %                          ABC       %CWTemplateVersion %                          v8.0       %ABCVersion %                          8000       %NoThemedControlsDependency                                %ForceMakeColorXPManifest                                %ForceSHEETNoTheme                                %IESPreventGlobalExport                                %ButtonMarginsCompatibility                                %W7ManifestW8                                                                                                                                                              �  鴧婘a.嶫�&�         ����!       �4 �+     �4 �+                              ��       dummy         Window                                                                                                                                                      .  壥�!鸉峝@慼譴�         佝��!       ;Z �,     Dm �,               FilesOpened �                                                                                                                                                                                                                                                                                                                                                                                                                                                           p   7\� J�#B�儼忀橮         Z���!       TmO �+     8耉 @/                                                               ABC$ABC         s / �8       捄V @/      奃仙�7@u尦��                                                                                             p   0闭�	�H幻孭禩吰         ^���!       4 U @/     埡V @/           >器丠F保D需鈒�                                                  ABC$GENERATED               埡V @/                                                                                                        r   W/繰W廘棦婡�$輢         嘄��!       怔 /     軐V @/                  CreateTwoFiles_VerifyContents Vn崊oZ!A愭V刯�       (*long addr),long,pascal �ぴ�=J乚x舡      8          Test procedures                        ClarionTest$TestProcedure        Test procedures s @/ }孷       軐V @/           ClarionTest$TestSupport    ����                      %AddressVar %                          addr    
   %TestCode %                                    %TestPriority %                          10       %TestGroup %                                 Z1G5笯客NW闌sT/历�铆纻�)   囉m帀G+xY�$i�)曮x﨑岶1N/k旃                                                                                                                                       j   耕=獞N垊摬gV�         蛀��!       �4 �+     !蒚 @/                  %Parameters %                          (*long addr)       %ProcedureParameters                                 %ProcedureParameterName %                   %ProcedureParameters                           addr       %ProcedureParameterOrigName %                   %ProcedureParameters                           addr       %ProcedureParameterType %                   %ProcedureParameters                           long       %ProcedureParameterDefault %                   %ProcedureParameters                                     %ProcedureParameterOmitted                    %ProcedureParameters                                %ProcedureParameterByReference                    %ProcedureParameters                               %GenerateOpenClose                                %GenerateSaveRestore                                %ProcedureParameterConstant                    %ProcedureParameters                                                                                                                                                                                                                                                j   =2欀B蒯@搅r�         e���!       TmO �+     繭 �+                  %SaveCreateLocalMap %                          1       %GenerationCompleted %                  %Module                    CM_System_IO_AsciiFile_Tests.clw                #   #       #   CM_System_IO_AsciiFile_Tests001.clw                #   #       #   CM_System_IO_AsciiFile_Tests003.clw                #   #       #   CM_System_IO_AsciiFile_Tests004.clw                !   !       !   DCL_System_IO_AsciiFile_Tests.clw             1$   $       $   DCL_System_IO_AsciiFile_Tests001.clw             1$   $       $   DCL_System_IO_AsciiFile_Tests003.clw             1$   $       $   DCL_System_IO_AsciiFile_Tests004.clw             1$   $       $   DCL_System_IO_AsciiFile_Tests005.clw             1$   $       $   DCL_System_IO_AsciiFile_Tests006.clw             1             ExtractProceduresTest.clw             1             ExtractProceduresTest001.clw             1             ExtractProceduresTest002.clw             1             ExtractProceduresTest003.clw             1             ExtractProceduresTest004.clw             1             System_IO_AsciiFile_Tests.clw             1                System_IO_AsciiFile_Tests001.clw             1                System_IO_AsciiFile_Tests003.clw             1                System_IO_AsciiFile_Tests004.clw                       %LastTarget32 %                          1       %LastProgramExtension %                          DLL       %LastApplicationDebug %                                    %LastApplicationLocalLibrary %                                                                                                                                   �  i�)曮x﨑岶1N/k旃         ����!       怔 /     怔 /                                                                                                                                                                                                                            �  V趐梠J�捎翈�
         ����!       sl9 �+     sl9 �+                                                                                                                                                                                                                            p   F坬钕A�'炭G�         ^���!       瞣O �+     絞* �+           59塅�;〩廐�o
@�                                                  ABC$GENERATED               絞* �+                                                                                                        �  �ぴ�=J乚x舡         ����!       佞 /     佞 /                              ��       dummy         Window                                                                                                                                                      �  鹜p紘�6G涸榺A酼         ����!       �=� �+     �=� �+                              ��       dummy         Window                                                                                                                                                      �  �2颉珁禕#*辘虵         ����!       瞣O �+     穙O �+                                                                                                                                                                                                                            r   59塅�;〩廐�o
@�         N���!      瞣O �+     穙O �+                  Main F坬钕A�'炭G�               
                                                  穙O �+        �2颉珁禕#*辘虵                                                                               j   =m歘K期@�  6痈6         咙��!       3"V @/     �%V @/                  %ProcedureParameters                        %ProcedureParameterName %                   %ProcedureParameters            %ProcedureParameterOrigName %                   %ProcedureParameters            %ProcedureParameterType %                   %ProcedureParameters            %ProcedureParameterDefault %                   %ProcedureParameters            %ProcedureParameterOmitted                    %ProcedureParameters            %ProcedureParameterByReference                    %ProcedureParameters            %ProcedureParameterConstant                    %ProcedureParameters            %Parameters %                                    %GenerateOpenClose                                %GenerateSaveRestore                                                                                                                                                                                                                           r   笽N媨瀢B挤)*L@G�         慅��!       rl9 �+     謱V @/                  CreateFile_VerifyContents �TVa@L�1"G涆�       (*long addr),long,pascal �0訁駬@�rs襮      
          Test procedures                        ClarionTest$TestProcedure        Test procedures s @/ ;V       謱V @/           ClarionTest$TestSupport    ����                      %AddressVar %                          addr    
   %TestCode %                                    %TestPriority %                    
          %TestGroup %                                 ;;�∠K悳47,�3�1M箸LM媞审a怤�   薜軹aI凊竦kJ朊V趐梠J�捎翈�
                                                                                                                                                 .  克|v踈BI�%"B虜         佝��!       3 U @/     3 U @/               FilesOpened �                                                                                                                                                                                                                                                                                                                                                                                                                                                           j   ;;�∠K悳47,�3         蛀��!       sl9 �+     !蒚 @/                  %Parameters %                          (*long addr)       %ProcedureParameters                                 %ProcedureParameterName %                   %ProcedureParameters                           addr       %ProcedureParameterOrigName %                   %ProcedureParameters                           addr       %ProcedureParameterType %                   %ProcedureParameters                           long       %ProcedureParameterDefault %                   %ProcedureParameters                                     %ProcedureParameterOmitted                    %ProcedureParameters                                %ProcedureParameterByReference                    %ProcedureParameters                               %GenerateOpenClose                                %GenerateSaveRestore                                %ProcedureParameterConstant                    %ProcedureParameters                                                                                                                                                                                                                                                r   a魂惙�I��a}m         孆��!       �4 �+     讓V @/                  CreateFile_CompareAgainstQueue �TVa@L�1"G涆�       (*long addr),long,pascal 鴧婘a.嶫�&�      ?          Test procedures                        ClarionTest$TestProcedure        Test procedures s @/ 瑃V       讓V @/           ClarionTest$TestSupport    ����                      %AddressVar %                          addr    
   %TestCode %                                    %TestPriority %                    
          %TestGroup %                                 耕=獞N垊摬gV�P蕱鮩滶曚杂镸覀   壥�!鸉峝@慼譴�	喦WD鐸噐T�<.婯                                                                                                                                            .  犋eb遾‥瓷78�,         佝��!       ;Z �,     Dm �,               FilesOpened �                                                                                                                                                                                                                                                                                                                                                                                                                                                           j   Z1G5笯客NW闌s         蛀��!       助 /     !蒚 @/                  %Parameters %                          (*long addr)       %ProcedureParameters                                 %ProcedureParameterName %                   %ProcedureParameters                           addr       %ProcedureParameterOrigName %                   %ProcedureParameters                           addr       %ProcedureParameterType %                   %ProcedureParameters                           long       %ProcedureParameterDefault %                   %ProcedureParameters                                     %ProcedureParameterOmitted                    %ProcedureParameters                                %ProcedureParameterByReference                    %ProcedureParameters                               %GenerateOpenClose                                %GenerateSaveRestore                                %ProcedureParameterConstant                    %ProcedureParameters                                                                                                                                                                                                                                                d   顒�v$L睧h-观�         o���!       TmO �+     8耉 @/        !   $咅〾�$E淚顸N	 l=2欀B蒯@搅r�   7\� J�#B�儼忀橮F坬钕A�'炭G須TVa@L�1"G涆扸n崊oZ!A愭V刯�0闭�	�H幻孭禩吰6瀈衛B瓾莭�                59塅�;〩廐�o
@�                ;�: */ ;�: */      	   ABC$ToDo                        ABC               捄V @/            ClarionTest$TestSupportIncludes    ����                      %TestProcedures                                                                                                                                                                   %TestProceduresProcedureName %                   %TestProcedures                           CreateFile_VerifyContents                       CreateFile_CompareAgainstQueue                       CreateFile_Replace_Verify    !   %TestProceduresProcedurePriority %                   %TestProcedures                     
                    
                          10       %TestProceduresProcedureGroup %                   %TestProcedures                                                                                         %TestGroups %                            Default       %ShowHelpComments                                %TestClasses %                       %IncludeDevRoadmapsClarionLib                            邰潓苶vG㈨�猲&�                                                                                                                   �  a8~褢�L�<e�聯         ����!       =� �+     =� �+                                                                                                                                                                                                                            �  T/历�铆纻�)         v���!       助 /     軐V @/           +       %ProcessedCode     +*    �  	dbg.SetPrefix('***')
	
	!----- Set up testfile1 ---

    testfilename1 = GetTestDirectory() & '\testdata'
    if not exists(testfilename1)
		CreateDirectory(testfilename1)
	end
	AssertThat(exists(testfilename1),IsEqualTo(true),'Directory does not exist: ' & testfilename1)
	testfilename1 = testfilename1 & '\test1.txt'
	if exists(testfilename1)
		remove(testfilename1)
	END
	AssertThat(exists(testfilename1),IsEqualTo(false),'Could not delete ' & testfilename1)
	dbg.write('Before CreateFile')
	testfile1.createfile(testfilename1)
	
	!----- Set up testfile2 ---

    testfilename2 = GetTestDirectory() & '\testdata'
    if not exists(testfilename2)
		CreateDirectory(testfilename2)
	end
	AssertThat(exists(testfilename2),IsEqualTo(true),'Directory does not exist: ' & testfilename2)
	testfilename2 = testfilename2 & '\test2.txt'
	if exists(testfilename2)
		remove(testfilename2)
	END
	AssertThat(exists(testfilename2),IsEqualTo(false),'Could not delete ' & testfilename2)
	dbg.write('Before CreateFile')
	testfile2.createfile(testfilename2)
	
	
	!--- Write out the text to both files
	dbg.write('After CreateFile, before writing lines')
	loop x = 1 to 5
		dbg.write('Writing line ' & x)
		testfile1.write('line ' & x)
		testfile2.write('line ' & x + 10)
	end
	dbg.write('Before CloseFile')
	testfile1.closefile()
	testfile2.closefile()
	AssertThat(exists(testfilename1),IsEqualTo(true),'Could not create ' & testfilename1)
	AssertThat(exists(testfilename2),IsEqualTo(true),'Could not create ' & testfilename2)
	
	
	!-- Verify file 1 
	testfile1.openfile(testfilename1)
	reccount = 0
	loop while testfile1.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount),'Unexpected text found in ' & testfilename1)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename1)
	testfile1.CloseFile()

	!-- Verify file 2 
	testfile2.openfile(testfilename2)
	reccount = 0
	loop while testfile2.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount + 10),'Unexpected text found in ' & testfilename2)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename2)
	testfile2.CloseFile()
 �  R   �        +       %DataSection     +*      testfilename1                        cstring(500)
testfilename2                        cstring(500)
!testq                               QUEUE
!txt                                     cstring(500)
!									end
testfile1                            DCL_System_IO_AsciiFile
testfile2                            DCL_System_IO_AsciiFile
testfile3                            DCL_System_IO_AsciiFile
testfile4                            DCL_System_IO_AsciiFile
testfile5                            DCL_System_IO_AsciiFile
!testfile6                            DCL_System_IO_AsciiFile
x                                   long
reccount                            long
txt                             cstring(500)
dbg                                 DCL_System_Diagnostics_Logger


 �  =   N                                                                                                                               �  嚄明欝哅彽I5o�         挈��!       3 U @/     埡V @/           +       %ProcessedCode     +*    �      testfilename = GetTestDirectory()
    if not exists(testfilename)
		CreateDirectory(testfilename)
	end
	AssertThat(exists(testfilename),IsEqualTo(true),'Directory does not exist: ' & testfilename)
	testfilename = testfilename & '\longrecord.txt'
	testfile.openfile(testfilename)
    AssertThat(testfile.read(txt),IsEqualTo(level:benign),'Could not read text file ' & testfilename)
    AssertThat(len(txt),IsEqualTo(57390),'Wrong text length')


 �     !        +       %DataSection     +*    �   testfilename                        cstring(500)
testfile                            DCL_System_IO_AsciiFile
txt                                 cstring(65000)
 �                                                                                                                                                                                                                                                        �  T84
J嚒子H�         ��!       �=� �+     蹖V @/           +       %ProcessedCode     +*           !gdbg.write('test') 2              +*    �      testfilename = GetTestDirectory() & '\testdata'
    if not exists(testfilename)
		CreateDirectory(testfilename)
	end
	AssertThat(exists(testfilename),IsEqualTo(true),'Directory does not exist: ' & testfilename)
	testfilename = testfilename & '\test.txt'
	if exists(testfilename)
		remove(testfilename)
	END
	AssertThat(exists(testfilename),IsEqualTo(false),'Could not delete ' & testfilename)
	loop x = 1 to 5
        testq.txt = 'line ' & x
        add(testq)
	end
	AssertThat(testfile.Replace(testfilename,testq,testq.txt),IsEqualTo(Level:Benign),'Replace method failed')
	AssertThat(exists(testfilename),IsEqualTo(true),'Could not create ' & testfilename)
	
	testfile.openfile(testfilename)
	reccount = 0
	loop while testfile.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount),'Unexpected text found in ' & testfilename)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename)

 �     5        +       %DataSection     +*    ]  testfilename                        cstring(500)
testq                               QUEUE
txt                                     cstring(500)
									end
x                                   long
reccount                            long
txt                             cstring(500)
TestFile                        DCL_System_IO_AsciiFile
 �                                                                                                                                                                                                                                                                       .  囉m帀G+xY�$         佝��!       助 /     助 /               FilesOpened �                                                                                                                                                                                                                                                                                                                                                                                                                                                           r   ,陜菘+TD矯讕生骠         婟��!       k=� �+     蹖V @/                  CreateFile_Replace_Verify Vn崊oZ!A愭V刯�       (*long addr),long,pascal 鹜p紘�6G涸榺A酼      
          Test procedures                        ClarionTest$TestProcedure        Test procedures s @/ 苲V       蹖V @/           ClarionTest$TestSupport    ����                      %AddressVar %                          addr    
   %TestCode %                                    %TestPriority %                          10       %TestGroup %                                 ($p歔�D�2鱡�松T84
J嚒子H�   犋eb遾‥瓷78�,a8~褢�L�<e�聯                                                                                                                                           p   Vn崊oZ!A愭V刯�         N���!       �=� �+     軐V @/           ,陜菘+TD矯讕生骠W/繰W廘棦婡�$輢                                                  ABC$GENERATED               軐V @/                                                                                        p   �TVa@L�1"G涆�         N���!       7F �+     讓V @/           笽N媨瀢B挤)*L@G產魂惙�I��a}m                                                  ABC$GENERATED               讓V @/                                                                                        r   e崆�L絆�閶7bd�         ���!       � V @/     嵑V @/                  GetTestDirectory 6瀈衛B瓾莭�    
   (),string        
                                   ABC$Source         s @/ ヾV       嵑V @/     =m歘K期@�  6痈6tS:+^'kA杫 �	胭$ 宑9?鲄G挵�&%�    p   6瀈衛B瓾莭�         ^���!       3"V @/     嵑V @/           e崆�L絆�閶7bd�                                                  ABC$GENERATED               嵑V @/                                                                                                                                    