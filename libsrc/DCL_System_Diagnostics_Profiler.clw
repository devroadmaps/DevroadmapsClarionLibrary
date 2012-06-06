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

                                        member()

    ! Do NOT remove the following line. It turns off profiling for this
    ! module and is needed by DCL_System_Diagnostics_Profiler
    pragma('define(profile=>0)')



                                        MAP
                                        END


    include('DCL_System_Diagnostics_Profiler.inc'),once
    include('DCL_System_Stack.inc'),once




                                        map
                                            EnterProc(UNSIGNED Line,*CSTRING Proc,*CSTRING File),NAME('Profile:EnterProc')
                                            LeaveProc(),NAME('Profile:LeaveProc')
                                            module('')
                                                SetErrorCode(LONG ErrorCode),NAME('Cla$seterror')
                                            end
                                            MODULE('Winapi')
                                                ODS(*CSTRING),PASCAL,RAW,NAME('OutputDebugStringA')
                                            END
                                        end

TraceOn                                 bool(false)
ProfilerRef                             &DCL_System_Diagnostics_Profiler
SuppressIndentLevel                     LONG ! jcm


!-----------------------------------------------------------------------------!
LeaveProc                               PROCEDURE()
    code
    if ~ProfilerRef &= null
        if TraceOn then ProfilerRef.ProcEnd(Thread()).
    end
	

!-----------------------------------------------------------------------------!
EnterProc                               procedure(unsigned Line,*cstring ProcName,*cstring FileName)
    code
    if ~ProfilerRef &= null
        if TraceOn then ProfilerRef.ProcStart(thread(),ProcName,FileName,Line).
    end
	

!-----------------------------------------------------------------------------!
DCL_System_Diagnostics_Profiler.Construct        procedure
    code
    self.RoutinesQ &= new DCL_System_Diagnostics_Profiler_RoutinesQueue
    ProfilerRef &= self
    !HACK  Should TraceOn default to true?
    TraceOn = true
    self.AutoCollapse = True
    !TODO  Are any other collapse strings needed?
    self.AddCollapseString('constantclass')
    self.AddCollapseString('popupclass')
    self.AddCollapseString('.next')
    self.AddCollapseString('.previous')
    self.AddCollapseString('apply')
    self.AddCollapseString('resize')
    self.AddCollapseString('.settips')
!
!-----------------------------------------------------------------------------!
DCL_System_Diagnostics_Profiler.Destruct procedure
x                                           short
    code
    TraceOn = False
    self.WriteTrace()
    free(self.RoutinesQ)
    dispose(self.RoutinesQ)
!
!-----------------------------------------------------------------------------!
DCL_System_Diagnostics_Profiler.ProcStart        procedure(long Thread,*cstring ProcName,*cstring FileName,unsigned Line)
x                                                   short
y                                                   short
NewProcName                                         string(200)
NoParam                                             byte
SkipROUTINE                                         byte ! jcm
SavedErrorCode                                      long
    code
    SavedErrorCode = ERRORCODE()
    self.GetThread(Thread)
    x = instring('(',ProcName,1,1)
    y = instring(',',ProcName,1,x)
    NoParam = False
    if not y
        NoParam = True
        y = instring(')',ProcName,1,x)
    end
    if x and y
        if NoParam
            NewProcName = ProcName[x+1:y-1] & '.' & ProcName[1:x] & ProcName[(y):(len(ProcName))]
        else
            NewProcName = ProcName[x+1:y-1] & '.' & ProcName[1:x] & ProcName[(y+1):(len(ProcName))]
        end
    else
        NewProcName = ProcName
    end
!-----------------------------------------------------------------------------!
! There's a problem in Clarion's treatment of routines. If you do a return
! from a routine, no LeaveProc is called for that routine, or for any routines
! which may have called it. The simplest solution (implemented here) is to
! just skip known routines which have a return. The more complex solution is
! to track the last non-routine and back out to that point.
!-----------------------------------------------------------------------------!
    if not instring('.',NewProcName)
        case upper(FileName)
        of 'ABBROWSE.CLW'
            case upper(ProcName)
            of 'EDITCLASSACTION'
            orof 'ALIENFIELDEVENT'
            orof 'TAKEFOCUSLOSS'
            orof 'SAVEOUT'
            orof 'CANCELREQUEST'
            orof 'CREATECONTROLS'
            orof 'PROCESSREQ'
            orof 'UNSETCOLUMN'
            orof 'SETCOLUMN'
            orof 'SEEKCOLUMN'
            orof 'RESETCURRENTCHOICE'
            orof 'CHECKLOCATOR'
            orof 'HANDLEDOUT'
            orof 'CHECKINSERT'
            orof 'CHECKCHANGE'
                !return            ! jcm
                SkipROUTINE = True ! jcm
            end
        of 'ABDROPS.CLW'
            case upper(ProcName)
            of 'RESETQUEUE'
                !return            ! jcm
                SkipROUTINE = True ! jcm
            end
        of 'ABFILE.CLW'
            case upper(ProcName)
            of 'VIRTUALOPEN'
            orof 'REALOPEN'
            orof 'HARDERROR'
            orof 'OKOUT'
            orof 'CHECKERROR'
            orof 'RET'
            orof 'CLOSEDOWN'
                !return            ! jcm
                SkipROUTINE = True ! jcm
            end
        of 'ABPOPUP.CLW'
            case upper(ProcName)
            of 'ADDITEM'
            orof 'CHECKMIMICS'
                !return            ! jcm
                SkipROUTINE = True ! jcm
            end
        of 'ABWINDOW.CLW'
            case upper(ProcName)
            of 'INSERTACTION'
            orof 'CHANGEACTION'
            orof 'DELETEACTION'
                SkipROUTINE = True ! jcm
            end
        end
        IF SkipROUTINE = True      ! jcm
            self.TraceIn('?? Skipped ROUTINE ('& ProcName &') with no LeaveProc details')
            return
        end
    end
    IF NewProcName[1:12] = 'FILECALLBACK'            |           ! jcm - Necessary to prevent LOOPing in Browse Procs
        AND NOT SuppressIndentLevel                                  ! jcm
        SuppressIndentLevel = SELF.IndentLevel                     ! jcm
    ELSIF SELF.NoiseSuppression                      |           ! jcm - Selectable via Template-wrapper
        AND NOT SuppressIndentLevel                   |           ! jcm
        AND NOT SELF.IndentLevel = 1                  |           ! jcm
        AND(NewProcName[1: 8] = 'CRITICAL'            |           ! jcm - Remove some "noise"
        OR NewProcName[1: 9] = 'INICLASS.'           |           ! jcm
        OR NewProcName[1:11] = 'ERRORCLASS.'         |           ! jcm
        OR NewProcName[1:12] = 'ILISTCONTROL'        |           ! jcm
        OR NewProcName[1:18] = 'WINDOWRESIZECLASS.')             ! jcm
        SuppressIndentLevel = SELF.IndentLevel                 ! jcm
    end
    IF SuppressIndentLevel                                       ! jcm
        SELF.IndentLevel += 1                                      ! jcm
    ELSE                                                         ! jcm
        self.TraceIn('-> ' & NewProcName)
    END                                                          ! jcm (Using END instead of 'dot' in deference to DH)
    IF SavedErrorCode THEN SetErrorCode(SavedErrorCode).

!-----------------------------------------------------------------------------!
DCL_System_Diagnostics_Profiler.ProcEnd  procedure(long Thread)
    code
    IF SuppressIndentLevel                                       ! jcm
        SELF.IndentLevel -= 1                                      ! jcm
        IF SELF.IndentLevel = SuppressIndentLevel                  ! jcm - End of "noise" removal
            SuppressIndentLevel = 0                                  ! jcm
        ELSE                                                       ! jcm
        END                                                        ! jcm
    ELSE                                                         ! jcm
        self.TraceOut('<<- exiting procedure/routine')
        IF self.IndentLevel = 1                                    ! jcm
            self.Trace('')                                           ! jcm
        END                                                        ! jcm
    END                                                          ! jcm (Using END instead of 'dot' in deference to DH)
    !TODO  verify that indent level is restored
    !self.IndentLevel -= 1

DCL_System_Diagnostics_Profiler.WritePerformanceSummary  PROCEDURE
stack                                                       DCL_System_Stack
x                                                           LONG
PerfQ                                                       QUEUE
ProcName                                                        cstring(100)
StartTime                                                       like(Int64Type)
EndTime                                                         like(Int64Type)
                                                            end
SummaryPerfQ                                                QUEUE
ProcName                                                        cstring(100)
Count                                                           long
TotalTime                                                       like(Int64Type)
AverageTime                                                     like(Int64Type)
                                                            end

    code
    loop x = 1 to records(self.TraceQ)
        get(self.traceq,x)
        if len(self.TraceQ.Text) > 3 
            if self.traceq.text[1 : 3] = '-> '
                PerfQ.ProcName = self.TraceQ.Text[4 : len(self.traceq.Text) - 4]
                PerfQ.StartTime = self.TraceQ.Timestamp
                add(PerfQ)
                stack.push(records(PerfQ))
            elsif self.traceq.text[1 : 3] = '<<- '
                if ~stack.IsEmpty()
                    get(PerfQ,stack.StackNode.NodeVal)
                    PerfQ.EndTime = self.TraceQ.Timestamp
                    put(PerfQ)
                END
                stack.pop()
            END
        END
    END
    self.Trace('-------------- Begin raw PerfQ data ---------------')
    loop x = 1 to records(PerfQ)
        get(PerfQ,x)
        self.trace(x & ' ' & perfq.ProcName & ' ' & perfq.STartTime & ' ' & perfq.EndTime)
    END
    self.Trace('---------------------------------------------------')
    
    loop x = 1 to records(PerfQ)
        get(PerfQ,x)
        SummaryPerfQ.ProcName = PerfQ.ProcName
        get(SummaryPerfQ,SummaryPerfQ.Procname)
        if errorcode()
            SummaryPerfQ.ProcName = PerfQ.ProcName
            SummaryPerfQ.Count = 1
            SummaryPerfQ.TotalTime = PerfQ.EndTime - PerfQ.StartTime
            add(SummaryPerfQ,SummaryPerfQ.ProcName)
        ELSE
            SummaryPerfQ.Count += 1
            SummaryPerfQ.TotalTime += (PerfQ.EndTime - PerfQ.StartTime)
            put(SummaryPerfQ)
        END
    END
    loop x = 1 to records(SummaryPerfQ)
        get(SummaryPerfQ,x)
        SummaryPerfQ.AverageTime = SummaryPerfQ.TotalTime / SummaryPerfQ.Count
        put(SummaryPerfQ)
    END

    sort(SummaryPerfQ,-SummaryPerfQ.TotalTime)
    self.Trace('-------------- Begin summary PerfQ data sorted by total time  ---------------')
    self.Trace('Procedure name                                               Count   TotalTime  AvgTime ')
    loop x = 1 to records(SummaryPerfQ)
        get(SummaryPerfQ,x)
        self.trace(sub(SummaryPerfQ.ProcName,1,60) & ' ' & format(SummaryPerfQ.Count,@n06) & '  ' & format(SummaryPerfQ.totaltime,@n010) & ' ' & format(SummaryPerfQ.averagetime,@n010))
    END
    self.Trace('-----------------------------------------------------------------------------')
    
    sort(SummaryPerfQ,-SummaryPerfQ.AverageTime)
    self.Trace('-------------- Begin summary PerfQ data sorted by average time  -------------')
    self.Trace('Procedure name                                               Count   TotalTime  AvgTime ')
    loop x = 1 to records(SummaryPerfQ)
        get(SummaryPerfQ,x)
        self.trace(sub(SummaryPerfQ.ProcName,1,60) & ' ' & format(SummaryPerfQ.Count,@n06) & '  ' & format(SummaryPerfQ.totaltime,@n010) & ' ' & format(SummaryPerfQ.averagetime,@n010))
    END
    self.Trace('-----------------------------------------------------------------------------')
    
    sort(SummaryPerfQ,-SummaryPerfQ.Count)
    self.Trace('-------------- Begin summary PerfQ data sorted by count  --------------------')
    self.Trace('Procedure name                                               Count   TotalTime  AvgTime ')
    loop x = 1 to records(SummaryPerfQ)
        get(SummaryPerfQ,x)
        self.trace(sub(SummaryPerfQ.ProcName,1,60) & ' ' & format(SummaryPerfQ.Count,@n06) & '  ' & format(SummaryPerfQ.totaltime,@n010) & ' ' & format(SummaryPerfQ.averagetime,@n010))
    END
    self.Trace('-----------------------------------------------------------------------------')
    
            
            
            
        
        

        
                
    
    
