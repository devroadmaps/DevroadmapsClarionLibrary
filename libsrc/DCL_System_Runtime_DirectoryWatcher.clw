!---------------------------------------------------------------------------------------------!
! Copyright (c) 2012, CoveComm Inc.
! All rights reserved.
! 
! 
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met: 
! 
! 1. Redistributions of source code must retain the above copyright notice, this
!    list of conditions and the following disclaimer. 
! 2. Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution. 
! 3. The use of this software in a paid-for programming toolkit (that is, a commercial 
!    product that is intended to assist in the process of writing software) is 
!    not permitted.
! 
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
! ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
! WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
! DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
! ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
! (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
! ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
! (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
! SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
! 
! The views and conclusions contained in the software and documentation are those
! of the authors and should not be interpreted as representing official policies, 
! either expressed or implied, of www.DevRoadmaps.com or www.ClarionMag.com.
! 
! If you find this software useful, please support its creation and maintenance
! by taking out a subscription to www.DevRoadmaps.com.
!---------------------------------------------------------------------------------------------!
! Originally published as DCL_System_Runtime_DirectoryWatcher in http://www.clarionmag.com/cmag/v9/v9n09threading.html
! article and code by Alan Telford
!
! 16-Aug-2006 Alan    Added noNotifyOnStartup property; so by default a dirchange is notified on startup
! 03-Aug-2006 Alan    Created; based on Jim Kane cnotifcl.clw, but updated for Clarion 6

                                            MEMBER()

    INCLUDE('DCL_System_Runtime_DirectoryWatcher.inc'),ONCE



!--------------------------------------------------------------------
! MODULE MAP
!--------------------------------------------------------------------

                                            MAP
WaitProc                                        PROCEDURE(STRING pClass)
                                                Module('mtapi')
MT_WaitForMultipleObjects                           procedure(long,long,long,long),raw,long,pascal,proc,name('WaitForMultipleObjects')
MT_FindFirstChangeNotification                      procedure(*cstring, bool,long),raw,unsigned,pascal,name('FindFirstChangeNotificationA')
MT_FindNextChangeNotification                       procedure(unsigned),raw,bool,pascal,name('FindNextChangeNotification'),proc
MT_FindCloseChangeNotification                      procedure(unsigned),raw,bool,pascal,name('FindCloseChangeNotification'),proc
MT_closehandle                                      procedure(unsigned),raw,bool,pascal,proc,name('closehandle')
MT_getlasterror                                     procedure(),ulong,pascal,name('getlasterror')
MT_CreateEvent                                      procedure(long,long,long,long),unsigned,raw,pascal,proc,name('createeventa')
MT_setevent                                         procedure(unsigned),bool,raw,pascal,proc,name('setevent')
MT_Sleep                                            procedure(UNSIGNED xMilliSeconds),PASCAL,NAME('SLEEP')
mt_OutputDebugString                                procedure(*CSTRING),PASCAL,RAW,NAME('OutputDebugStringA')
                                                end
                                            END

!--------------------------------------------------------------------
! MODULE DATA
!--------------------------------------------------------------------

!global data for this module
Invalid_handle_Value                        equate(-1)
Return:Benign                               equate(0)
Return:Fatal                                equate(3)
Return:Notify                               equate(5)


!--------------------------------------------------------------------
! MODULE SOURCE
!--------------------------------------------------------------------
WaitProc                                    PROCEDURE(STRING pClass)
!-------------------------------------------------------------------------------
cWait                                           &DCL_System_Runtime_DirectoryWatcher
infinite                                        equate(-1) 
Wait_object_0                                   equate(0)
initialised                                     byte(0)
    CODE
    cWait &= pClass + 0 ! get a reference to the class
    cWait.debugstring('WAITPROC - created')
    if not cWait.noNotifyOnStartup
        ! trigger one event immediately to catch any waiting files
        notify(cWait.cwnotifycode, cWait.cwthread, cWait.cwnotifyParam)
    end  
    loop
        !if waitstruct.notifhandle has becomes signaled then send a message
        if MT_waitForMultipleObjects(2,address(cWait.WaitStruct.notifhandle),0,infinite)=Wait_object_0  then
            cWait.debugstring('WAITPROC - dirchange received')
            notify(cWait.cwnotifycode, cWait.cwthread, cWait.cwnotifyParam)
            if cWait.autoreset then
                MT_FindNextchangeNotification(cWait.WaitStruct.notifhandle)
                cycle
            end
        end
        cWait.debugstring('WAITPROC - exit event received')
        break
    end !sleep again if reset
    clear(cWait.waitThread)
    cWait.debugstring('WAITPROC - exiting')
    return
!-------------------------------------------------------------------------------
DCL_System_Runtime_DirectoryWatcher.destruct                   procedure()
!-------------------------------------------------------------------------------
    code
    ! ensure that the cleanup is called to prevent memory leaks
    self.kill()
    return
!-------------------------------------------------------------------------------
DCL_System_Runtime_DirectoryWatcher.debugString                procedure(string p:text)
!-------------------------------------------------------------------------------
lCstr                                           &Cstring
    CODE
    if self.debugMode
        lCstr &= new(cstring(len(clip(p:Text))+21))
        lcstr =  'NC:'&self.cwnotifycode&':'&self.cwnotifyparam & '  '&p:text
        mt_OutputDebugString(lCstr)
        dispose(lcstr)
    end
    return
!-------------------------------------------------------------------------------
DCL_System_Runtime_DirectoryWatcher.Init                       Procedure(string pTargetdir, long pCWThread, long pCWNotifyCode, long pCWNotifyParam, |
                                                long pNotifType, long pWatchSubtree=0, long pautoreset=1)
! pTargetDir      = folder to watch
! pCWThread = THREAD() to notify when a directory change is made
! pCWNotifyCode   = code to signal (eg use different codes for different folders)
! pCWNotifyParam  = code to signal (eg use different codes for different folders)
! pNotifType      = what directory changes to watch out for
! pWatchSubtree   = TRUE=watch all sub folders as well
! pautoreset      = automatically reset and watch for further changes; alternative is to call obj.RESET()
!-------------------------------------------------------------------------------
savedproc                                       long,auto
threadid                                        long,auto
Targetdir                                       CSTRING(512)
    Code
    Clear(SELF.WaitStruct)

    SELF.AutoReset = pAutoReset
    self.CWThread = pCWThread
    self.cwnotifycode = pCWNotifyCode
    self.CWNotifyParam = pCWNotifyParam
    clear(self.waitthread)

    !create an event object that will tell the alt thread the app is closing
    SELF.WaitStruct.hEvent = MT_createevent(0,1,0,0)
    if ~SELF.WaitStruct.hEvent then
        SELF.kill()
        return return:fatal
    end

    !intiate change notification
    Targetdir = clip(pTargetdir)
    SELF.waitstruct.NotifHandle = MT_findFirstchangeNotification(Targetdir,pWatchSubTree,pnotifType)
    If SELF.waitstruct.NotifHandle = Invalid_handle_value then
        SELF.Kill()
        return return:fatal
    end
    self.debugstring('INIT - dir='&TargetDir)

    !create a thread to listen
    SELF.waitThread = start(WaitProc,,address(self))
    If ~SELF.waitThread then
        SELF.Kill()
        return Return:Fatal
    end
    resume(self.waitThread)
    Return Return:benign

!-------------------------------------------------------------------------------
DCL_System_Runtime_DirectoryWatcher.Kill                       Procedure()
!-------------------------------------------------------------------------------
!destroy any dynamic objects and clean up
    Code

    !kill the alt thread
    If SELF.waitThread and SELF.WaitStruct.hEvent then
        MT_SetEvent(SELF.WaitStruct.hevent)
        MT_closehandle(SELF.waitstruct.hevent)
        clear(SELF.WaitStruct.hEvent)
    end

    !Close the notificaiton process
    If SELF.WaitStruct.NotifHandle then
        MT_FindCloseChangeNotification(SELF.WaitStruct.NotifHandle)
        clear(SELF.WaitStruct.Notifhandle)
    end
    self.debugstring('DCL_System_Runtime_DirectoryWatcher.reset - end')
    RETURN
!-------------------------------------------------------------------------------
DCL_System_Runtime_DirectoryWatcher.reset                      Procedure()
!-------------------------------------------------------------------------------
! Only needed if pAutoReset=false on init.
! This function sets up the wait again
    code
    self.debugstring('DCL_System_Runtime_DirectoryWatcher.reset - start')
    If SELF.waitThread then
        self.debugstring('DCL_System_Runtime_DirectoryWatcher.reset - setting event')
        MT_SetEvent(SELF.WaitStruct.hevent)
        MT_sleep(100)
    end
    If SELF.WaitStruct.NotifHandle then
        self.debugstring('DCL_System_Runtime_DirectoryWatcher.reset - findind next')
        MT_FindNextchangeNotification(SELF.WaitStruct.Notifhandle)
        SELF.waitThread = start(WaitProc,,address(self))
        resume(SELF.waitThread)
    end
    Return

!-------------------------------------------------------------------------------
