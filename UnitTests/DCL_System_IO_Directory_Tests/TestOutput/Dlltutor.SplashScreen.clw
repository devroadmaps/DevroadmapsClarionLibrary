!================================================================================
! Dlltutor.Main
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\testdata\DLLTUTOR001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\testoutput\Dlltutor.SplashScreen.clw
!
! This file may also be included in a combined source file called
! Dlltutor._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Dlltutor.Main will have a more complete history than
! Dlltutor.allprocedures.clw provided the original extracted procedure
! file was renamed in the version control system)
!================================================================================
! Start of original module header
!================================================================================
!
!
!   MEMBER('Dlltutor.clw')                                  ! This is a MEMBER module
!
!
!   INCLUDE('ABTOOLBA.INC'),ONCE
!   INCLUDE('ABWINDOW.INC'),ONCE
!
!                     MAP
!                       INCLUDE('DLLTUTOR001.INC'),ONCE        !Local module procedure declarations
!                     END
!
!
!================================================================================
! End of original module header
!================================================================================
SplashScreen PROCEDURE                                     ! Generated from procedure template - Splash

window               WINDOW,AT(,,204,112),FONT('MS Sans Serif',8,,FONT:regular),NOFRAME,CENTER,GRAY,MDI
                       PANEL,AT(0,-42,204,154),BEVEL(6)
                       PANEL,AT(7,6,191,98),BEVEL(-2,1)
                       STRING('DLL Example Application'),AT(13,12,182,10),USE(?String2),CENTER
                       STRING(''),AT(24,23),USE(?String3)
                       IMAGE('sv_small.jpg'),AT(68,61),USE(?Image1)
                       PANEL,AT(12,33,182,12),BEVEL(-1,1,9)
                       STRING('Created with Clarion!'),AT(13,48,182,10),USE(?String1),CENTER
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED       ! Method added to host embed code
Kill                   PROCEDURE(),BYTE,PROC,DERIVED       ! Method added to host embed code
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED       ! Method added to host embed code
                     END

Toolbar              ToolbarClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('SplashScreen')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?String2
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.Open(window)                                        ! Open window
  Do DefineListboxStyle
  TARGET{Prop:Timer} = 500                                 ! Close window on timer event, so configure timer
  TARGET{Prop:Alrt,255} = MouseLeft                        ! Alert mouse clicks that will close window
  TARGET{Prop:Alrt,254} = MouseLeft2
  TARGET{Prop:Alrt,253} = MouseRight
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:AlertKey
      CASE KEYCODE()
      OF MouseLeft
      OROF MouseLeft2
      OROF MouseRight
        POST(Event:CloseWindow)                            ! Splash window will close on mouse click
      END
    OF EVENT:LoseFocus
        POST(Event:CloseWindow)                            ! Splash window will close when focus is lost
    OF Event:Timer
      POST(Event:CloseWindow)                              ! Splash window will close on event timer
    OF Event:AlertKey
      CASE KEYCODE()                                       ! Splash window will close on mouse click
      OF MouseLeft
      OROF MouseLeft2
      OROF MouseRight
        POST(Event:CloseWindow)
      END
    ELSE
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

