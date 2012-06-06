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
    include('DCL_IncludeInAllClassHeaderFiles.inc'),once


    include('DCL_System_Diagnostics_Timer.inc'),once


DCL_System_Diagnostics_Tracer_TraceQueue queue,type
Text                                        cstring(1000)
IndentLevel                                 long
Timestamp                                   like(Int64Type)
                                        end

DCL_System_Diagnostics_Tracer_ThreadIndentQueue  queue,type
IndentLevel                                         long
Thread                                              long
                                                end


DCL_System_Diagnostics_Tracer_EventNameQueue     queue,type
no                                                  long
name                                                string(30)
                                                end

DCL_System_Diagnostics_Tracer_SimpleQueue        queue,type
Text                                                string(30)
                                                end

DCL_System_Diagnostics_Tracer            class,type,module('DCL_System_Diagnostics_Tracer.clw'),link('DCL_System_Diagnostics_Tracer.clw',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
AutoCollapse                                byte(False)
CacheSize                                   long,protected
CollapseQ                                   &DCL_System_Diagnostics_Tracer_SimpleQueue
CurrThread                                  long,private
Disabled                                    bool
EnabledCount                                LONG       ! jcm
EventNameQ                                  &DCL_System_Diagnostics_Tracer_EventNameQueue,protected
IndentLevel                                 long(1),protected
IndentSpacing                               byte(3)
LevelsToShow                                long(25)
LogFileName                                 cstring(500),protected
LogFileOpen                                 bool
NextLineToWrite                             long,protected
NoiseSuppression                            BYTE(True) ! jcm
StayOnLastLine                              byte(1)
ThreadAware                                 bool(True)
ThreadQ                                     &DCL_System_Diagnostics_Tracer_ThreadIndentQueue
Timer                                       &DCL_System_Diagnostics_Timer
ToolboxThread                               long,protected
TraceQ                                      &DCL_System_Diagnostics_Tracer_TraceQueue,protected
TreeView                                    bool(True)
WriteToLogFile                              bool(true)
WriteToWin32Debug                           bool(true)
!--- constructor/destructor --------------------------------------!
Construct                                   procedure
Destruct                                    procedure
!--- methods -----------------------------------------------------!
AddEvent                                    procedure(string EventName,long EventNo)
AddCollapseString                           procedure(string Collapse)
CloseLogFile                                procedure,protected,virtual
Count                                       procedure,long
FindEvent                                   procedure(long EventNo),byte,private
Flush                                       procedure()
FormatQueue                                 procedure(bool TreeView=False)
FormatText                                  procedure(string Text,bool TreeView=False),string
GetEventName                                procedure(long EventNo),string
GetThread                                   procedure(long Thread)
GetTrace                                    procedure(long index, bool showIndent = false),string
HideTraceToolbox                            procedure
OpenLogFile                                 procedure,protected,virtual,bool
Reset                                       procedure
SetCacheSize                                procedure(long cacheSize)
SetFilename                                 procedure(string filename)
SetIndentLevel                              procedure(long IndentLevel)
ShowTraceToolbox                            procedure
Trace                                       procedure(string Text)
TraceIn                                     procedure(string Text)
TraceOut                                    procedure(string Text)
ViewTrace                                   procedure
WriteTrace                                  procedure,virtual,protected
                                        end

!gTracer                         DCL_System_Diagnostics_Tracer

                                            
