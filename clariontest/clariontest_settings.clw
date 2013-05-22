

										MEMBER('ClarionTest.clw')                               ! This is a MEMBER module

	include('DCL_System_IO_Directory.inc'),once



Settings                                PROCEDURE 

DirectoryListing                            DCL_System_IO_Directory
!DirectoryQ                                  DCL_System_IO_DirectoryQueue


!CurrentTab                                  STRING(80)                            !
!ActionMessage                               CSTRING(40)                           !
!QuickWindow                                 WINDOW('Form Settings'),AT(,,466,273),FONT('MS Sans Serif',8,,FONT:regular,CHARSET:DEFAULT), |
!												RESIZE,CENTER,GRAY,IMM,HLP('SettingsForm'),SYSTEM
!												PANEL,AT(13,10,443,231),USE(?PANEL1),BEVEL(1)
!												PROMPT('SMTPS erver:'),AT(20,138),USE(?Set:SMTPServer:Prompt),TRN
!												ENTRY(@s120),AT(104,124,258,10),USE(SET:Domain)
!												ENTRY(@s120),AT(104,138,258,10),USE(SET:SMTPServer)
!												ENTRY(@s120),AT(104,153,258,10),USE(SET:SMTPPort)
!												ENTRY(@s120),AT(104,166,258,10),USE(SET:SMTPUser)
!												ENTRY(@s120),AT(104,180,258,10),USE(SET:SMTPPassword)
!												ENTRY(@s120),AT(104,194,258,10),USE(SET:SenderAddress)
!												ENTRY(@s120),AT(104,209,258,10),USE(SET:FromHeaderAddress)
!												PROMPT('From Header Address:'),AT(20,209),USE(?Set:FromHeaderAddress:Prompt),TRN
!												PROMPT('Sender Address:'),AT(20,194),USE(?Set:SenderAddress:Prompt),TRN
!												PROMPT('SMTPP assword:'),AT(20,180),USE(?Set:SMTPPassword:Prompt),TRN
!												PROMPT('SMTPU ser:'),AT(20,166),USE(?Set:SMTPUser:Prompt),TRN
!												PROMPT('SMTPP ort:'),AT(20,153),USE(?Set:SMTPPort:Prompt),TRN
!												PROMPT('Domain:'),AT(20,124),USE(?Set:Domain:Prompt),TRN
!												CHECK('Auto Run Test On DLL Change'),AT(103,56,120,8),USE(SET:AutoRunTest)
!												CHECK('Launch In Monitor Mode'),AT(103,44,100,8),USE(SET:MonitorMode)
!												PROMPT('From Header Name:'),AT(20,223),USE(?Set:FromHeaderName:Prompt),TRN
!												ENTRY(@s120),AT(104,223,257,9),USE(SET:FromHeaderName)
!												BUTTON('&Cancel'),AT(406,251,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),MSG('Cancel operation'), |
!													TIP('Cancel operation')
!												PROMPT('Folder To Monitor:'),AT(33,31),USE(?Set:FolderToMonitor:Prompt)
!												ENTRY(@s220),AT(104,30,335,10),USE(SET:FolderToMonitor)
!												BUTTON('...'),AT(442,28,12,12),USE(?LookupFile),SKIP
!												BUTTON('OK'),AT(361,251,41),USE(?BUTTON1)
!												BUTTON('Read'),AT(137,251,39,14),USE(?BUTTON1:2)
!											END

!ThisWindow                                  CLASS(WindowManager)
!Init                                            PROCEDURE(),BYTE,PROC,DERIVED
!Kill                                            PROCEDURE(),BYTE,PROC,DERIVED
!TakeAccepted                                    PROCEDURE(),BYTE,PROC,DERIVED
!											END
!
!Toolbar                                     ToolbarClass
!!MyBlowfish                                  CLASS(JPWBlowfish)
!!											END
!
!FileLookup7                                 SelectFileClass
!Resizer                                     CLASS(WindowResizeClass)
!Init                                            PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
!											END
!
!CurCtrlFeq                                  LONG
!FieldColorQueue                             QUEUE
!Feq                                             LONG
!OldColor                                        LONG
!											END

	CODE
!	GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
!
!!---------------------------------------------------------------------------
!DefineListboxStyle                      ROUTINE
!!|
!!| This routine create all the styles to be shared in this window
!!| It`s called after the window open
!!|
!!---------------------------------------------------------------------------
!
!ThisWindow.Init                         PROCEDURE
!
!ReturnValue                                 BYTE,AUTO
!
!	CODE
!!	GlobalErrors.SetProcedureName('SettingsForm')
!!	SELF.Request = GlobalRequest                             ! Store the incoming request
!!	ReturnValue = PARENT.Init()
!!	IF ReturnValue THEN RETURN ReturnValue.
!!	SELF.FirstField = ?PANEL1
!!	SELF.VCRRequest &= VCRRequest
!!	SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
!!	SELF.AddItem(Toolbar)
!!	CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
!!	CLEAR(GlobalResponse)
!!	SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
!!	SELF.Open(QuickWindow)                                   ! Open window
!!	!WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
!!	Do DefineListboxStyle
!!	IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
!!		?SET:Domain{PROP:ReadOnly} = True
!!		?SET:SMTPServer{PROP:ReadOnly} = True
!!		?SET:SMTPPort{PROP:ReadOnly} = True
!!		?SET:SMTPUser{PROP:ReadOnly} = True
!!		?SET:SMTPPassword{PROP:ReadOnly} = True
!!		?SET:SenderAddress{PROP:ReadOnly} = True
!!		?SET:FromHeaderAddress{PROP:ReadOnly} = True
!!		?SET:FromHeaderName{PROP:ReadOnly} = True
!!		?SET:FolderToMonitor{PROP:ReadOnly} = True
!!		DISABLE(?LookupFile)
!!		DISABLE(?BUTTON1)
!!		DISABLE(?BUTTON1:2)
!!	END
!!	Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
!!	SELF.AddItem(Resizer)                                    ! Add resizer to window manager
!!	INIMgr.Fetch('SettingsForm',QuickWindow)                 ! Restore window settings from non-volatile store
!!	Resizer.Resize                                           ! Reset required after window size altered by INI manager
!!	FileLookup7.Init
!!	FileLookup7.ClearOnCancel = True
!!	FileLookup7.Flags=BOR(FileLookup7.Flags,FILE:LongName)   ! Allow long filenames
!!	FileLookup7.Flags=BOR(FileLookup7.Flags,FILE:Directory)  ! Allow Directory Dialog
!!	FileLookup7.SetMask('All Files','*.*')                   ! Set the file mask
!!	FileLookup7.WindowTitle='Select Path'
!!	!ds_VisibleOnDesktop()
!!	SELF.SetAlerts()
!!	RETURN ReturnValue
!!
!!
!!ThisWindow.Kill                         PROCEDURE
!!
!!ReturnValue                                 BYTE,AUTO
!!
!!	CODE
!!	!If self.opened Then WinAlert().
!!	ReturnValue = PARENT.Kill()
!!	IF ReturnValue THEN RETURN ReturnValue.
!!	IF SELF.Opened
!!		INIMgr.Update('SettingsForm',QuickWindow)              ! Save window data to non-volatile store
!!	END
!!	GlobalErrors.SetProcedureName
!!	RETURN ReturnValue
!!
!!
!!ThisWindow.TakeAccepted                 PROCEDURE
!!
!!ReturnValue                                 BYTE,AUTO
!!
!!Looped                                      BYTE
!!	CODE
!!	LOOP                                                     ! This method receive all EVENT:Accepted's
!!		IF Looped
!!			RETURN Level:Notify
!!		ELSE
!!			Looped = 1
!!		END
!!		CASE ACCEPTED()
!!		OF ?Cancel
!!			!
!!		END
!!		ReturnValue = PARENT.TakeAccepted()
!!		CASE ACCEPTED()
!!		OF ?LookupFile
!!			ThisWindow.Update
!!			SET:FolderToMonitor = FileLookup7.Ask(1)
!!			DISPLAY
!!		OF ?BUTTON1
!!			ThisWindow.Update
!!!			if not xml:createXMLFILE('Myconfig.xml')
!!!				xml:CreateParent('Configuration')
!!!				XML:CreateAttribute('Version','1.00')
!!!				xml:AddParent()
!!!				! encrypt here(blowfish encryption from Gary at Strategy ONLINE) FREE !!@!@!!!!  USE HEX!!!
!!!				if SET:SMTPPassword <> ''
!!!					MyBlowfish.Key32 = MyKey
!!!					MyBlowfish.Size = len(clip(Set:SMTPPassword)) + (8-(len(clip(Set:SMTPPassword))%8))
!!!					loop X = (len(clip(Set:SMTPPassword))+1) to MyBlowfish.Size
!!!						Set:SMTPPassword[X] = '<0>'
!!!					end
!!!					MyBlowfish.BinData = address(Set:SMTPPassword)
!!!					MyBlowfish.EncodeHex()
!!!				END
!!!      				
!!!				xml:AddFromgroup(Setup,'SMTPSettings',True)
!!!				if SET:SMTPPassword <> ''
!!!					! put it back here
!!!					MyBlowfish.Key32 = MyKey
!!!					MyBlowfish.BinData = address(Set:SMTPPassword)
!!!					MyBlowfish.DecodeHex()
!!!					MyBlowfish.Clip (Set:SMTPPassword)
!!!				END
!!!				xml:CloseParent()
!!!				!      			xml:CreateParent('UserSettings');xml:addParent()
!!!				!      			! here
!!!				!      			xml:closeParent()
!!!      	
!!!				xml:closeXMLFILE(True)
!!!			END	
!!			!xml:viewfile('myconfig.xml')
!!			ReturnValue = Level:Fatal
!!      
!!      
!!		OF ?BUTTON1:2
!!			ThisWindow.Update
!!!			if not xml:LoadFromFIle('myconfig.xml')
!!!				recs = xml:loadQueue(MyConfigQueue,true,true)
!!!				if recs <> 1
!!!					message('WE REALLY MESSED UP')
!!!				ELSE
!!!					get(MyConfigQueue,1)
!!!				END
!!!				xml:DebugMyQueue(myconfigqueue,'this is my queue')
!!!				clear(Setup)	
!!!				Setup :=: myConfigQueue
!!!				MyBlowfish.Key32 = MyKey
!!!				MyBlowfish.BinData = address(Set:SMTPPassword)
!!!				MyBlowfish.DecodeHex()
!!!				MyBlowfish.Clip (Set:SMTPPassword)
!!!				xml:free()
!!!			END
!!!			!        Message(Set:SMTPPassword)
!!            
!!		END
!!		RETURN ReturnValue
!!	END
!!	ReturnValue = Level:Fatal
!!	RETURN ReturnValue
!!
!!
!!Resizer.Init                            PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
!!
!!
!!	CODE
!!	PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
!!	SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window
!!
!!!!! <summary>
!!!!! Generated from procedure template - Window
!!!!! </summary>
