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

                    
                                        MEMBER()
                                        MAP
                                        end


    INCLUDE('DCL_System_IO_AsciiFile.inc'),ONCE
    include('DCL_System_Diagnostics_Logger.inc'),once

!dbg                                    DCL_System_Diagnostics_Logger

DCL_System_IO_AsciiFileInstanceAInternal CLASS(DCL_System_IO_AsciiFile),MODULE('DCL_System_IO_AsciiFile.clw'),LINK('DCL_System_IO_AsciiFile.clw',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
!DCL_AsciiFileA                           CLASS(DCL_System_IO_AsciiFile),MODULE('DCL_System_IO_AsciiFile.clw')
Construct                                   procedure()
                                        end

DCL_System_IO_AsciiFileInstanceBInternal CLASS(DCL_System_IO_AsciiFile),MODULE('DCL_System_IO_AsciiFile.clw'),LINK('DCL_System_IO_AsciiFile.clw',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
!DCL_AsciiFileB                           CLASS(DCL_System_IO_AsciiFile),MODULE('DCL_System_IO_AsciiFile.clw')
Construct                                   procedure()
                                        end

DCL_System_IO_AsciiFileInstanceCInternal CLASS(DCL_System_IO_AsciiFile),MODULE('DCL_System_IO_AsciiFile.clw'),LINK('DCL_System_IO_AsciiFile.clw',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
!DCL_AsciiFileC                           CLASS(DCL_System_IO_AsciiFile),MODULE('DCL_System_IO_AsciiFile.clw')
Construct                                   procedure()
                                        end


AsciiFileNameA                          STRING(MaxPathLength),static

AsciiFileA                              FILE,DRIVER('ASCII','/CLIP = on'),CREATE,NAME(AsciiFileNameA),PRE(ASCIIA)
                                            RECORD
Txt                                             STRING(ASCII_IO_RECORD_SIZE)
                                            END
                                        END

AsciiFileNameB                          STRING(MaxPathLength),static

AsciiFileB                              FILE,DRIVER('ASCII','/CLIP = on'),CREATE,NAME(AsciiFileNameB),PRE(ASCIIB)
                                            RECORD
Txt                                             STRING(ASCII_IO_RECORD_SIZE)
                                            END
                                        END

AsciiFileNameC                          STRING(MaxPathLength),static

AsciiFileC                              FILE,DRIVER('ASCII','/CLIP = on'),CREATE,NAME(AsciiFileNameC),PRE(ASCIIC)
                                            RECORD
Txt                                             STRING(ASCII_IO_RECORD_SIZE)
                                            END
                                        END


!dbg                                     DCL_System_Diagnostics_Logger


DCL_System_IO_AsciiFile.Construct        PROCEDURE()
    CODE
    self.Errors &= new DCL_System_ErrorManager

DCL_System_IO_AsciiFile.Destruct         PROCEDURE()
    CODE
    SELF.CloseFile()
    dispose(self.Errors)

DCL_System_IO_AsciiFile.CloseFile        PROCEDURE()
    CODE
    !dbg.write('Closing ' & self.filenameref & ' from DCL_System_IO_AsciiFile.CloseFile')
    close(self.fileref)
    

DCL_System_IO_AsciiFile.CreateFile       PROCEDURE(STRING AsciiFileName, LONG OpenMode=ReadWrite+DenyWrite)
    CODE
    RETURN SELF.Init(AsciiFileName, True, OpenMode)
    
DCL_System_IO_AsciiFile.GetName          PROCEDURE()
    CODE
    RETURN SELF.FileNameRef

DCL_System_IO_AsciiFile.Init             PROCEDURE(FILE AFile,*STRING FileLine,*STRING FName)
    CODE
    self.fileref &= aFile
    self.FileTxtRef &= FileLine
    self.FileNameRef &= fname
    
DCL_System_IO_AsciiFile.Init             PROCEDURE(<STRING AsciiFileName>, BYTE CreateFile=False, LONG OpenMode=ReadWrite+DenyWrite)
    CODE
    !dbg.SetPrefix('DCL_System_IO_AsciiFile.InitFile')
    if self.fileRef &= NULL
        !dbg.write('self.FileRef is null')
        self.Errors.AddError(0,'self.FileRef was null')
        return Level:Fatal
    end
	IF OMITTED(AsciiFileName)
		!dbg.Write('file name omitted, self.CurrentFileName = ' & self.currentfilename)
		IF STATUS(self.FileRef) = SELF.OpenMode AND NAME(self.FileRef) = SELF.CurrentFileName 
			!dbg.write('file is already open')
			RETURN LEVEL:Benign
		END
		OpenMode = SELF.OpenMode
	ELSE
		self.CurrentFileName = CLIP(AsciiFileName)
		!dbg.Write('self.CurrentFileName = ' & self.currentfilename)
	END
	! dgh Sept 2012 return an error if the file doesn't exist!
	if not exists(self.CurrentFileName) then return level:fatal.
    self.FileNameRef = SELF.CurrentFileName
    IF STATUS(self.FileRef) 
        !dbg.write('closing ' & self.FileNameRef & ' from DCL_System_IO_AsciiFile.Init')
        CLOSE(self.FileRef)
    end
    IF CreateFile
        !dbg.write('creating file')
        LOOP 50 TIMES
            REMOVE(self.CurrentFileName)
            REMOVE(self.FileRef)
            CREATE(self.FileRef)
            if errorcode()
                self.Errors.AddError(errorcode(),error())
            else
                break
            end
        end
        IF ERRORCODE() THEN RETURN LEVEL:Notify.
    END
    LOOP 50 TIMES
        !dbg.write('trying to open ' & self.FileNameRef)
        OPEN(self.FileRef, OpenMode)
        if errorcode()
            self.Errors.AddError(errorcode(),error())
        else
            break
        end
    end
    IF ERRORCODE() 
        !dbg.write('Error opening file: ' & error())
    !ASSERT(False, ERROR())
        RETURN LEVEL:Notify
    END
    IF ~OMITTED(2) 
        SELF.CurrentFileName      = NAME(self.FileRef)
        SELF.OpenMode      = STATUS(self.FileRef)
    END
    !dbg.write('file successfully opened, issuing set')
    set(self.FileRef)
    RETURN LEVEL:Benign
    
DCL_System_IO_AsciiFile.IsOpen           PROCEDURE !,byte
    CODE
    IF STATUS(self.FileRef) = SELF.OpenMode AND NAME(self.FileRef) = SELF.CurrentFileName 
        return TRUE
    END
    return false

DCL_System_IO_AsciiFile.LoadFile         PROCEDURE(*Queue q,*cstring qField)
    code
    loop while self.Read(qField) = Level:Benign
        add(q)
    end
  
DCL_System_IO_AsciiFile.OpenFile         PROCEDURE(STRING fname, LONG OpenMode=ReadWrite+DenyWrite)!, BYTE, PROC
    CODE
    RETURN SELF.Init(fName, False, OpenMode)

DCL_System_IO_AsciiFile.Read             PROCEDURE(*CSTRING TextLine)!, BYTE, PROC	
    CODE
    if self.fileref &= null
        return Level:Fatal
    END
    !dbg.write('Reading record from ' & self.FileRef{prop:name})
    next(self.fileref)
    if errorcode()
        return Level:Fatal
    end 
    TextLine = clip(self.FileTxtRef)
    return Level:Benign





DCL_System_IO_AsciiFile.Replace          procedure(string filename,*queue q,*cstring qfield)	
txt                                         cstring(5000)
reccount                                    long
replace                                     byte(true)
    code
    !dbg.SetPrefix('DCL_System_IO_AsciiFile.Replace')
    if exists(filename)
        if self.Init(filename) <> Level:Benign
            return Level:Fatal
        else
            !dbg.write('Comparing queue to ' & filename)
            reccount = 0 
            replace = false
            loop while self.read(txt) = level:benign
                reccount += 1
                if reccount > records(q)
                    !dbg.write('more records in file than in queue')
                    replace = TRUE
                    BREAK
                END
                get(q,reccount)
                if qfield <> txt
                !dbg.write('text differs: ' & txt & ' <<> ' & q)
                    replace = TRUE
                    BREAK
                END
            end
            if reccount < records(q)
                !dbg.write('more queue records than file records')
                replace = TRUE
            END
        end
        self.closefile()
    end
    if replace = TRUE
        !dbg.write('replacing')
        if self.Init(filename,true) <> Level:Benign
            !dbg.write('fatal error')
            return Level:Fatal
        end
            !dbg.write('Init succeeded')
        loop reccount = 1 to records(q)
            get(q,reccount)
            !dbg.write('writing line ' & reccount & ' '  & clip(qfield))
            if len(clip(qfield)) > 200
                !gdbg.write('Long field: ' & qfield)
            end
            if self.write(clip(qfield) & ' ') <> level:benign
                    !dbg.write('write failed')
                self.closefile()
                !dbg.write('fatal error')
                return Level:Fatal
            end
        END
        !dbg.write('closing file')
        self.closefile()
    end
    return level:benign




DCL_System_IO_AsciiFile.Write            PROCEDURE(STRING TextLine)
ReturnValue                                 BYTE(LEVEL:Benign)
    CODE
    IF ~SELF.FileNameRef THEN RETURN LEVEL:Fatal.
    IF SELF.AutoFlush
        SELF.Init()
    end
    self.FileTxtRef = CLIP(TextLine)
    ADD(self.FileRef)
    IF ERRORCODE() 
        ReturnValue = LEVEL:Notify
    END
    IF SELF.AutoFlush  
        CLOSE(self.FileRef)
        !dbg.write('closing ' & self.FileNameRef & ' from DCL_System_IO_AsciiFile.Write (autoflush)')
    end
    RETURN ReturnValue	
  
DCL_System_IO_AsciiFile.Write            procedure(*queue q,*cstring qfield)  
x                                           long
    code
    loop x = 1 to records(q)
        get(q,x)
        self.Write(qfield)
    end
 
  

    
DCL_System_IO_AsciiFileInstanceAInternal.Construct       PROCEDURE
    CODE
    self.Init(AsciiFileA,AsciifileA.Txt,AsciifileNameA)
    
DCL_System_IO_AsciiFileInstanceBInternal.Construct       PROCEDURE
    CODE
    self.Init(AsciiFileB,AsciifileB.Txt,AsciifileNameB)
                                    
DCL_System_IO_AsciiFileInstanceCInternal.Construct       PROCEDURE
    CODE
    self.Init(AsciiFileC,AsciifileC.Txt,AsciifileNameC)

    
    


DCL_System_IO_AsciiFileManager.GetAsciiFileInstance      procedure(long instanceNumber)!,*DCL_System_IO_AsciiFile    
    code
    case instanceNumber
    of DCL_System_IO_AsciiFile_InstanceNumber1
        return DCL_System_IO_AsciiFileInstanceAInternal
    of DCL_System_IO_AsciiFile_InstanceNumber2
        return DCL_System_IO_AsciiFileInstanceBInternal
    of DCL_System_IO_AsciiFile_InstanceNumber3
        return DCL_System_IO_AsciiFileInstanceCInternal
    end
    return null
            
        





