!---------------------------------------------------------------------------------------------!
! Copyright (c) 2012, CoveComm Inc.
! All rights reserved.
!---------------------------------------------------------------------------------------------!
!region
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
!endregion
!
! This file contains various source needed by the ClarionTest
! unit testing framework.


	
    Section('GlobalData')
    include('DCL_ClarionTest_TestResult.inc'),once
    include('DCL_System_Diagnostics_logger.inc'),once

!logger                                  DCL_System_Diagnostics_Logger
UnitTestResult                          DCL_ClarionTest_TestResult
UnitTestType                            long
UnitTestVariableType                    long
UnitTestExpectedString                  &string
UnitTestExpectedLong                    Long

	
    Section('GlobalMap')
!	MODULE('Winapi')
!		ODS(*CSTRING),PASCAL,RAW,NAME('OutputDebugStringA')                   !32-bit only
!	END
BeginUnitTest                           Procedure(string testName)
AssertThat                              procedure(string testResult,byte b,<string debugMessage>,<string successMessage>),byte,proc
IsEmpty                                 procedure(*? object),byte
IsEqualTo                               procedure(string expected),byte,proc
IsNotEqualTo                            procedure(string expected),byte
IsNull                                  procedure(*? object),byte
SetUnitTestFailed                       procedure(string stdMessage,<string userMessage>)
SetUnitTestIgnored                      procedure(string stdMessage,<string userMessage>)
SetUnitTestStatus                       procedure(long status,string stdMessage,<string userMessage>)




    Section('ProgramProcedures')

!Debug                                   procedure(string s)
!    CODE
!    !gdbg.write('ClarionTest global code: ' & s)
	

BeginUnitTest                           procedure(string testName)
    CODE
    clear(UnitTestResult)
    UnitTestResult.Status        = DCL_ClarionTest_Status_Pass
    UnitTestResult.ProcedureName = testName
	
AssertThat                              procedure(string testResult,byte b,<string userMessage>,<string successMessage>)
Info                                        cstring(1000)
singlequote                                 equate('''')
    CODE
    !logger.write('** AssertThat receives testresult ' & singlequote & testresult & singlequote)
    !logger.write('** UnitTestExpectedString: ' & singlequote & UnitTestExpectedString & singlequote)
    if not omitted(userMessage)
        info = userMessage
    end
    if UnitTestResult.Status <> DCL_ClarionTest_Status_Pass then return false.
!	if UnitTestVariableType <> DCL_ClarionTest_UnitTestVariableTypes:StringType
!		SetUnitTestFailed('Strings can only be compared with other strings')
!	END
    if UnitTestExpectedString &= null
        SetUnitTestFailed('Expected string may not be null - use IsNull instead',info)
        return false
    end
    case UnitTestType
    of DCL_ClarionTest_UnitTestTypes:IsEqualTo
        !logger.write('DCL_ClarionTest_UnitTestTypes:IsEqualTo - comparing ' & singlequote & clip(testResult) & singlequote & ' with ' & singlequote & clip(UnitTestExpectedString) & singlequote)
        if testResult <> UnitTestExpectedString
            SetUnitTestFailed('Expected ' & singlequote & UnitTestExpectedString & singlequote & ', received ' & singlequote & testResult & singlequote, info)
            RETURN false
        END
    of DCL_ClarionTest_UnitTestTypes:IsNotEqualTo
        !logger.write('DCL_ClarionTest_UnitTestTypes:IsNotEqualTo - comparing ' & singlequote & clip(testResult) & singlequote & ' with ' & singlequote & clip(UnitTestExpectedString) & singlequote)
        if testResult = UnitTestExpectedString
            SetUnitTestFailed('Values are identical', info)
            RETURN false
        END
    ELSE
        SetUnitTestFailed('Unknown test type')
        return false
    end
    if not omitted(successMessage)
        UnitTestResult.Description = successMessage
    end
    return true

IsEqualTo                               procedure(string s)
!MG: By Clipping the string, you're (probably) adding a limitation 
    CODE
    UnitTestType            = DCL_ClarionTest_UnitTestTypes:IsEqualTo
    UnitTestVariableType    = DCL_ClarionTest_UnitTestVariableTypes:StringType
    UnitTestExpectedString &= new string(len(clip(s)))
    UnitTestExpectedString  = s
    !logger.write('IsEqualTo created new string(' & len(clip(s)) & '), value ''' & UnitTestExpectedString & '''')
    return true
	
IsEmpty                                 procedure(*? object)!,byte
    code
    if IsNull(object) then return true.
    if object = '' then return true.
    return FALSE
    
IsNull                                  procedure(*? object)
    CODE
    if object &= null
        return true
    end
    return false
	

IsNotEqualTo                            procedure(string s)
    CODE
    IsEqualTo(s)
    UnitTestType = DCL_ClarionTest_UnitTestTypes:IsNotEqualTo
    return true
	
	
!SetUnitTestFailed                       procedure(string stdMessage)
!    CODE
!    SetUnitTestFailed(stdMessage,'')
	
SetUnitTestFailed                       procedure(string stdMessage,<string userMessage>)
	CODE
	!logger.write('calling SetUnitTestFailed')
	if omitted(userMessage)
		SetUnitTestStatus(DCL_ClarionTest_Status_Fail,stdMessage)
	else
		SetUnitTestStatus(DCL_ClarionTest_Status_Fail,stdMessage,userMessage)
	end
		
SetUnitTestIgnored                       procedure(string stdMessage,<string userMessage>)
	CODE
	if omitted(userMessage)
		SetUnitTestStatus(DCL_ClarionTest_Status_Ignore,stdMessage)
	else
		SetUnitTestStatus(DCL_ClarionTest_Status_Ignore,stdMessage,userMessage)
	end
	
		
SetUnitTestStatus                       procedure(long status,string stdMessage,<string userMessage>)
	CODE
	!logger.write('SetUnitTestStatus ' & stdMessage)
	UnitTestResult.Status = status
	!UnitTestResult.Message = stdMessage & ' ' & userMessage
	if omitted(userMessage)  
		UnitTestResult.Message = clip(stdMessage)
	else
		UnitTestResult.Message = clip(stdMessage) & ' (' & userMessage & ')'
	end
	!logger.write('Set UnitTestResult.Message to ' & UnitTestResult.Message)
		
