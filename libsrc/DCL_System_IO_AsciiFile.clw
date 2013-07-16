!---------------------------------------------------------------------------------------------!
! Copyright (c) 2012, 2013 CoveComm Inc.
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

                    
                                        MEMBER()
										MAP
										end

	Include('DCL_System_Pool.inc'),Once
    INCLUDE('DCL_System_IO_AsciiFile.inc'),ONCE
    include('DCL_System_Diagnostics_Logger.inc'),once

dbg                                     DCL_System_Diagnostics_Logger

ASCII_IO_RECORD_SIZE                    EQUATE(100000)

!AsciiFilePoolInstance                       class(DCL_System_Pool)
AsciiFilePoolType                       class(DCL_System_Pool),type
Construct                                   procedure
										end

AsciiFilePoolInstance                   &AsciiFilePoolType



AsciiFileName1                          STRING(MaxPathLength),static
AsciiFile1                              FILE,DRIVER('ASCII','/CLIP = on'),CREATE,NAME(AsciiFileName1),PRE(AsciiFile1)
                                            RECORD
Txt                                             STRING(ASCII_IO_RECORD_SIZE)
                                            END
                                        END

AsciiFileName2                          STRING(MaxPathLength),static
AsciiFile2                              FILE,DRIVER('ASCII','/CLIP = on'),CREATE,NAME(AsciiFileName2),PRE(AsciiFile2)
											RECORD
Txt                                             STRING(ASCII_IO_RECORD_SIZE)
											END
										END

AsciiFileName3                          STRING(MaxPathLength),static
AsciiFile3                              FILE,DRIVER('ASCII','/CLIP = on'),CREATE,NAME(AsciiFileName3),PRE(AsciiFile3)
											RECORD
Txt                                             STRING(ASCII_IO_RECORD_SIZE)
											END
										END

AsciiFileName4                          STRING(MaxPathLength),static
AsciiFile4                              FILE,DRIVER('ASCII','/CLIP = on'),CREATE,NAME(AsciiFileName4),PRE(AsciiFile4)
											RECORD
Txt                                             STRING(ASCII_IO_RECORD_SIZE)
											END
										END

AsciiFileName5                          STRING(MaxPathLength),static
AsciiFile5                              FILE,DRIVER('ASCII','/CLIP = on'),CREATE,NAME(AsciiFileName5),PRE(AsciiFile5)
											RECORD
Txt                                             STRING(ASCII_IO_RECORD_SIZE)
											END
										END



!AsciiFilePoolInstance.Construct                 procedure
AsciiFilePoolType.Construct             procedure
	code
	dbg.write('AsciiFilePoolInstance.Construct ' & address(self))
	self.Init(5)
	self.SetStopOnError(true,'DCL_System_IO_AsciiFile: All available ASCII files are in use!')




DCL_System_IO_AsciiFile.Construct        PROCEDURE()
	CODE
	dbg.write('DCL_System_IO_AsciiFile.Construct ' & address(self))
	if AsciiFilePoolInstance &= null then AsciiFilePoolInstance &= new AsciiFilePoolType.
	self.Errors &= new DCL_System_ErrorManager
	self.PoolItemNumber = AsciiFilePoolInstance.GetItemNumber()
	execute self.PoolItemNumber
		self.Init(AsciiFile1,AsciiFile1:Record,AsciiFileName1)
		self.Init(AsciiFile2,AsciiFile2:Record,AsciiFileName2)
		self.Init(AsciiFile3,AsciiFile3:Record,AsciiFileName3)
		self.Init(AsciiFile4,AsciiFile4:Record,AsciiFileName4)
		self.Init(AsciiFile5,AsciiFile5:Record,AsciiFileName5)
	else
		stop('Unable to initialize the ASCIIFile instance - if you continue the program will probably crash')
	end
	
	

DCL_System_IO_AsciiFile.Destruct         PROCEDURE()
	CODE
    SELF.CloseFile()
	AsciiFilePoolInstance.ReleaseItemNumber(self.PoolItemNumber)
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
	! If the file doesn't exist then log the error and return.
	if not exists(self.CurrentFileName) 
		self.Errors.AddError('File does not exist and/or could not be created')
		return level:fatal
	end
	LOOP 50 TIMES
        !dbg.write('trying to open ' & self.FileNameRef)
        OPEN(self.FileRef, OpenMode)
		if errorcode()
			self.Errors.AddError(errorcode(),error())
			!dbg.write('Error: ' & self.Errors.GetLastError())
		else
			!dbg.write('Success opening file')
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
                !g!dbg.write('Long field: ' & qfield)
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
	clear(self.FileTxtRef)
	self.FileTxtRef = CLIP(TextLine)
	!dbg.write('DCL_System_IO_AsciiFile.Write (' & len(clip(TextLine)) & ',' & len(clip(self.FileTxtRef)) & ' chars): ' & self.FileTxtRef)
    ADD(self.FileRef)
	IF ERRORCODE() 
		!dbg.write('Error adding record: ' & error())
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
  
