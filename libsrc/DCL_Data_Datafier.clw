!---------------------------------------------------------------------------------------------!
!
! Copyright © Jeff Slarve
! All Rights Reserved
!
! The Datafier Class is for creation of on-the-fly variables that are usable in a thread-safe manner and accessible globally
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

										MEMBER


  
										map
										end  
   
	Include('DCL_Data_Datafier.inc'),once 
	include('DCL_IncludeInAllClassHeaderFiles.inc'),once
	!include('DCL_System_ErrorManager.inc'),once
	!include('equates.clw'),once

										Itemize,Pre(JSDF)
OK                                          Equate(0)
Notify                                      Equate
Exists                                      Equate
ReadOnly                                    Equate
										end



!==============================================================================================================================================================================================
DCL_Data_Datafier.BindData              Procedure(<String pNameSpace>)
!==============================================================================================================================================================================================
!Binds all of the variables that are set to be "bindable". This allows you to use your dynamic variables in EVALUATE()'d expressions.
!If you only wish to bind a particular namespace, then pass the namespace as a parameter. Otherwise, all bindable variables are bound in all namespaces.

NameSpaceNdx                                Long
Ndx                                         Long

	Code

	If SELF.IsBound
		SELF.UnBindData
	end

	PushBind(TRUE) !Keep existing bound stuff bound
 

	SELF.CSWait()
	If Omitted(pNameSpace) or NOT pNameSpace !Do all of them
		Loop NameSpaceNdx = 1 to Records(SELF.NameSpace)
			Get(SELF.NameSPace,NameSpaceNdx)
			If ErrorCode()
				Break
			end
			Do BindDataQueue
		end
	else
		SELF.NameSpace.NameSpace_Sort = Upper(pNameSpace)
		Get(SELF.NameSpace,SELF.NameSpace.NameSpace_Sort)
		If NOT ErrorCode()
			Do BindDataQueue
		end
	end
  
	SELF.IsBound = TRUE

	SELF.CSRelease()

BindDataQueue                           Routine

	Loop Ndx = 1 to Records(SELF.NameSpace.Q)
		Get(SELF.NameSpace.Q,Ndx)
		If ErrorCode() or NOT SELF.NameSpace.Q.Bindable
			Break
		end
		If SELF.NameSpace.Q.DataType = DataType:JSDFExpression
			BindExpression(SELF.NameSpace.Q.Label,Clip(SELF.NameSpace.Q.Var))
		else
			Bind(SELF.NameSpace.Q.Label,SELF.NameSpace.Q.Var)
		end
	end


!==============================================================================================================================================================================================
DCL_Data_Datafier.ClearValue            Procedure(String pLabel,<Short pDir>,<String pNameSpace>)
!==============================================================================================================================================================================================
!This is calls Clarion's CLEAR() statement, and can be used to clear high or low.
!Not sure what use this has. It was initially put here to demonstrate to myself that the correct datatypes were being assigned. E.G. clearing a DataType:Byte high will yield 255.
!

	Code

	SELF.CSWait()

	Loop 1 Times
		If SELF.FetchNameSpace(pNameSpace)
			Break
		end

		If SELF.Fetch(pLabel)
			Break
		end

		If Omitted(pDir) or NOT pDir
			Clear(SELF.NameSpace.Q.Var)
		else
			Clear(SELF.NameSpace.Q.Var,pDir)
		end
	end
  
	SELF.CSRelease()


!==============================================================================================================================================================================================
DCL_Data_Datafier.Construct             Procedure
!==============================================================================================================================================================================================

	Code

	SELF.IsThreadSafe   = TRUE
	SELF.OptionExplicit = FALSE
	SELF.IsBound        = FALSE

	SELF.NameSpace       &= NEW DCL_DataFier_NameSpaceQType
	SELF.FetchNameSpace(DCL_DataFier_Default_Namespace)
	SELF.QLock &= new DCL_System_Threading_CriticalSection

!==============================================================================================================================================================================================
DCL_Data_Datafier.CSRelease             Procedure
!==============================================================================================================================================================================================
!A wrapper for the critical section .Release() method

	Code

	If SELF.IsThreadSafe
		SELF.QLock.Release
	end

!==============================================================================================================================================================================================
DCL_Data_Datafier.CSWait                Procedure
!==============================================================================================================================================================================================
!A wrapper for the critical section .Wait() method

	Code

	If SELF.IsThreadSafe
		SELF.QLock.Wait
	end

!==============================================================================================================================================================================================
DCL_Data_Datafier.Declare               Procedure(String pLabel,<String pNameSpace>,Byte pBindable=FALSE)
!==============================================================================================================================================================================================
!If the .OptionExplicit property is set, then .Declare() must be called before the variable can be used.

ReturnVal                                   Long,Auto

	Code

	ReturnVal = JSDF:OK

	SELF.CSWait()

	SELF.FetchNameSpace(pNameSpace)
  
	If SELF.Fetch(pLabel)
		Clear(SELF.NameSpace.Q)
		SELF.NameSpace.Q.Label      = pLabel
		SELF.NameSpace.Q.Label_Sort = Upper(pLabel)
		SELF.NameSpace.Q.DataType   = DataType:JSDFUnset
		SELF.NameSpace.Q.Bindable   = pBindable
		Add(SELF.NameSpace.Q,-SELF.NameSpace.Q.Bindable)
	else
		ReturnVal = JSDF:Exists
	end

	SELF.CSRelease()

	Return ReturnVal

!==============================================================================================================================================================================================
DCL_Data_Datafier.Destruct              Procedure
!==============================================================================================================================================================================================

Ndx                                         Long

	Code

	If SELF.NameSpace.Q &= NULL
		Return
	end

	SELF.CSWait()

	Loop
		Get(SELF.NameSpace,1)
		If ErrorCode()
			Break
		end
		Loop Ndx = Records(SELF.NameSpace.Q) to 1 by -1
			Get(SELF.NameSpace.Q,Ndx)
			If ErrorCode()
				Break
			end
			If SELF.DisposeValue(SELF.NameSpace.Q.Label,TRUE,TRUE)
				Break
			end
		end
		Dispose(SELF.NameSpace.Q)
		Delete(SELF.NameSpace)
	end

	Dispose(SELF.NameSpace)

	SELF.CSRelease()

	dispose(SELF.QLock)

!==============================================================================================================================================================================================
DCL_Data_Datafier.DisposeValue          Procedure(String pLabel,Byte pNoLock=False,Byte pUseCurrent=FALSE,<String pNameSpace>)
!==============================================================================================================================================================================================
!Disposes of a variable

rByte                                       &byte
rShort                                      &Short
rUshort                                     &Ushort
rDate                                       &Date
rTime                                       &Time
rLong                                       &Long
rULong                                      &ULong
rSReal                                      &Sreal
rReal                                       &Real
rDecimal                                    &Decimal
rPDecimal                                   &PDecimal
rBFloat4                                    &BFloat4
rBFloat8                                    &BFloat8
rString                                     &String
rCString                                    &CString
rPString                                    &PString

ReturnVal                                   Long,Auto

	Code

	ReturnVal = JSDF:OK

	If NOT pNoLock
		SELF.CSWait()
	end
	Loop 1 times

		If SELF.FetchNameSpace(pNameSpace,pUseCurrent)
			ReturnVal = JSDF:Notify
			Break
		end

		If NOT SELF.Fetch(pLabel,pUseCurrent)
			Case SELF.NameSpace.Q.DataType
			of DataType:Byte
				rByte &= (SELF.NameSpace.Q.Address)
				Dispose(rByte)
			of DataType:Short
				rShort &= (SELF.NameSpace.Q.Address)
				Dispose(rShort)
			of DataType:UShort
				rUShort &= (SELF.NameSpace.Q.Address)
				Dispose(rUShort)
			of DataType:Date
				rDate &= (SELF.NameSpace.Q.Address)
				Dispose(rDate)
			of DataType:Time
				rTime &= (SELF.NameSpace.Q.Address)
				Dispose(rTime)
			of DataType:Long
				rLong &= (SELF.NameSpace.Q.Address)
				Dispose(rLong)
			of DataType:ULong
				rULong &= (SELF.NameSpace.Q.Address)
				Dispose(rULong)
			of DataType:SReal
				rSReal &= (SELF.NameSpace.Q.Address)
				Dispose(rSReal)
			of DataType:Real
				rReal &= (SELF.NameSpace.Q.Address)
				Dispose(rReal)
			of DataType:Decimal
				rDecimal &= (SELF.NameSpace.Q.Address)
				dispose(rDecimal)
			of DataType:PDecimal
				rPDecimal &= (SELF.NameSpace.Q.Address)
				Dispose(rPDecimal)
			of DataType:BFLOAT4
				rBfloat4 &= (SELF.NameSpace.Q.Address)
				Dispose(rBFloat4)
			of DataType:BFLOAT8
				rBfloat8 &= (SELF.NameSpace.Q.Address)
				Dispose(rBfloat8)
			of DataType:String
				rSTring &= (SELF.NameSpace.Q.Address)
				Dispose(rString)
			of DataType:CString
				rCSTring &= (SELF.NameSpace.Q.Address)
				Dispose(rCString)
			of DataType:PString
				rPString &= (SELF.NameSpace.Q.Address)
				Dispose(rPString)
			else
				!Don't dispose
			end

			SELF.NameSpace.Q.Var &= NULL
			Delete(SELF.NameSpace.Q)
		end
	end

	If NOT pNoLock
		SELF.CSRelease()
	end

	Return ReturnVal

!==============================================================================================================================================================================================
DCL_Data_Datafier.Fetch                 Procedure(String pLabel,Byte pUseCurrent=False)!,Byte,Private
!==============================================================================================================================================================================================
!Internally used fetching mechanism.

	Code

	If NOT pUseCurrent
		SELF.NameSpace.Q.Label_Sort = Upper(pLabel)
		Get(SELF.NameSpace.Q, SELF.NameSpace.Q.Label_Sort)
		Return ErrorCode()
	else
		If NOT Pointer(SELF.NameSpace.Q)
			Return 33 !Record Not Available
		end
	end
	Return 0

!==============================================================================================================================================================================================
DCL_Data_Datafier.FetchNameSpace        Procedure(<String pNameSpace>,Byte pUseCurrent=FALSE)!,Long,Private
!==============================================================================================================================================================================================
!Since the namespace queue is a queue containing a queue reference, this method makes sure that the correct stuff happens when adding a namespace that doesn't exist.

NameSpace                                   CString(60)

	Code

	If pUseCurrent
		If Pointer(SELF.NameSpace)
			RETURN JSDF:OK
		else
			RETURN JSDF:Notify
		end
	end
	If Omitted(pNameSpace) OR NOT pNameSpace
		NameSpace = DCL_DataFier_Default_Namespace
	else
		NameSpace = pNameSpace
	end
	SELF.NameSpace.NameSpace_Sort = Upper(NameSpace)
	Get(SELF.NameSpace,SELF.NameSpace.NameSpace_Sort)
	If ErrorCode()
		SELF.NameSpace.NameSpace      = NameSpace
		SELF.NameSpace.NameSpace_Sort = Upper(NameSpace)
		SELF.NameSpace.Q             &= NEW DCL_DataFier_QType
		Add(SELF.NameSpace)
	end
	Return JSDF:OK

!==============================================================================================================================================================================================
DCL_Data_Datafier.GetAddress            Procedure(String pLabel,<String pNameSpace>)!,Long
!==============================================================================================================================================================================================
!This is could have a great use if used in a thread-safe manner.

LOC:Address                                 Long

	Code

	SELF.CSWait()

	SELF.FetchNameSpace(pNameSpace)

	If NOT SELF.Fetch(pLabel)
		LOC:Address = SELF.NameSpace.Q.Address
	end

	SELF.CSRelease()

	Return LOC:Address

!==============================================================================================================================================================================================
DCL_Data_Datafier.GetValue              Procedure(String pLabel,Byte pFormatted=False,<String pNameSpace>)!ANY
!==============================================================================================================================================================================================
!Retrieves the value of the named variable.
!Optionally returns a formatted string based on picture.
!If the datatype is DataType:JSDFExpression, then the result is EVALUATE()'d

A                                           ANY

	Code

	SELF.CSWait()

	SELF.FetchNameSpace(pNameSpace)

	If NOT SELF.Fetch(pLabel)
		If SELF.NameSpace.Q.DataType = DataType:JSDFExpression
			A = Evaluate(SELF.NameSpace.Q.Var)
		else
			If pFormatted AND Self.NameSpace.Q.Picture
				A = Clip(Left(Format(SELF.NameSpace.Q.Var,SELF.NameSpace.Q.Picture)))
			else
				A = SELF.NameSpace.Q.Var
			end
		end
	end

	SELF.CSRelease()

	Return A

!==============================================================================================================================================================================================
DCL_Data_Datafier.GetValueList          Procedure(*Queue pQ,Short pLabelColumn=1,Short pValueColumn=2,Short pSortLabelColumn=3,Byte pFormatted=False,<String pNameSpace>)
!==============================================================================================================================================================================================
!Copies values to a queue passed by the user so they can be manipulated locally by the user without thread worries

LabelColumn                                 ANY
ValueColumn                                 ANY
SortLabelColumn                             ANY
Ndx                                         LONG

	Code

	SELF.CSWait()

	SELF.FetchNameSpace(pNameSpace)

	If pLabelColumn
		LabelColumn &= WHAT(pQ,pLabelColumn)
	end
	If pValueColumn
		ValueColumn &= WHAT(pQ,pValueColumn)
	end
	If pSortLabelColumn
		SortLabelColumn &= WHAT(pQ,pSortLabelColumn)
	end
	Loop Ndx = 1 to Records(SELF.NameSpace.Q)
		Get(Self.NameSpace.Q,Ndx)
		LabelColumn = SELF.NameSpace.Q.Label
		If pFormatted AND Self.NameSpace.Q.Picture
			ValueColumn = Clip(Left(Format(SELF.NameSpace.Q.Var,SELF.NameSpace.Q.Picture)))
		else
			ValueColumn = SELF.NameSpace.Q.Var
		end
		SortLabelColumn = Upper(LabelColumn)
		Add(pQ)
	end

	LabelColumn     &= NULL
	ValueColumn     &= NULL
	SortLabelColumn &= NULL

	SELF.CSRelease()


!==============================================================================================================================================================================================
DCL_Data_Datafier.SetReadOnly           Procedure(String pLabel,<String pNameSpace>,Byte pReadOnly=TRUE)
!==============================================================================================================================================================================================
!Sets a variable to readonly or not readonly

	Code
  
	SELF.CSWait()
  
	SELF.FetchNameSpace(pNameSpace)
  
	If NOT SELF.Fetch(pLabel)
		SELF.NameSpace.Q.ReadOnly = Choose(pReadOnly)
		Put(SELF.NameSpace.Q)
	end
  
	SELF.CSRelease()


!==============================================================================================================================================================================================
DCL_Data_Datafier.SetValue              Procedure(String pLabel,? pValue,<String pPicture>,Byte pDataType=0,Byte pDigits=0,Byte pPrecision=0,Byte pBindable=FALSE,<String pNameSpace>)!,Long,Proc
!==============================================================================================================================================================================================
!Sets the value of a variable.
!pLabel     = The name of the variable
!pValue     = The desired value
!pPicture   = A string containing a valid Clarion picture token.
!pDatatype  = Any of the expected DataTypes as defined in EQUATES.CLW, with the exception of DataType:JSDFExpression. 
!             If it is DataType:JSDFExpression, then the data is stored as a string and evaluated when GetValue() occurs.            
!pDigits    = Number of digits (e.g. in a Decimal) or characters(e.g. in a String)
!pPrecision = Precision, where applicable (e.g. in a Decimal)
!pBindable  = Whether or not you wish to be able to bind() this field in the .BindData() method.
!pNamespace = If specified, it will place the data in that namespace.

ReturnVal                                   Long,Auto

	Code

	ReturnVal = JSDF:OK

	Self.CSWait()

	SELF.FetchNameSpace(pNameSpace)

	Loop 1 times
		If SELF.Fetch(pLabel)
			If SELF.OptionExplicit !Must be "declared"
				ReturnVal = JSDF:Notify
				Break
			end
			Clear(SELF.NameSpace.Q)
			SELF.NameSpace.Q.Label      = Clip(pLabel)
			SELF.NameSpace.Q.Label_Sort = Upper(SELF.NameSpace.Q.Label)
			SELF.NameSpace.Q.Bindable   = pBindable
			Do PrimeFields
			Do SetDataType
			SELF.NameSpace.Q.Var        = pValue
			Add(SELF.NameSpace.Q,-SELF.NameSpace.Q.Bindable)
		else
			If SELF.NameSpace.Q.ReadOnly
				ReturnVal = JSDF:ReadOnly
				Break
			end
			If SELF.NameSpace.Q.DataType = DataType:JSDFUnset !Was "Declared"
				Do PrimeFields
				Do SetDataType
			end
			SELF.NameSpace.Q.Var        = pValue
			Put(SELF.NameSpace.Q)
		end
	end

	Self.CSRelease()

	Return ReturnVal

!............................................................
PrimeFields                             Routine
!''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	SELF.NameSpace.Q.Picture    = Clip(pPicture)
	SELF.NameSpace.Q.DataType   = pDataType

!............................................................
SetDataType                             Routine
!''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	Data

rByte   &byte
rShort  &Short
rUshort &Ushort
rDate   &Date
rTime   &Time
rLong   &Long
rULong  &ULong
rSReal  &Sreal
rReal   &Real
rDecimal        &Decimal
rPDecimal       &PDecimal
rBFloat4        &BFloat4
rBFloat8        &BFloat8
rString &String
rCString        &CString
rPString        &PString

	Code

	Case pDataType
	of 0
		Exit
	of DataType:Byte
		rByte &= NEW Byte
		SELF.NameSpace.Q.Var &= rByte
		SELF.NameSpace.Q.Address = Address(rByte)
	of DataType:Short
		rShort &= NEW Short
		SELF.NameSpace.Q.Var &= rShort
		SELF.NameSpace.Q.Address = Address(rShort)
	of DataType:UShort
		rUShort &= NEW UShort
		SELF.NameSpace.Q.Var &= rUShort
		SELF.NameSpace.Q.Address = Address(rUShort)
	of DataType:Date
		rDate &= NEW Date
		SELF.NameSpace.Q.Var &= rDate
		SELF.NameSpace.Q.Address = Address(rDate)
	of DataType:Time
		rTime &= NEW Time
		SELF.NameSpace.Q.Var &= rTime
		SELF.NameSpace.Q.Address = Address(rTime)
	of DataType:Long
		rLong &= NEW Long
		SELF.NameSpace.Q.Var &= rLong
		SELF.NameSpace.Q.Address = Address(rLong)
	of DataType:ULong
		rULong &= NEW ULong
		SELF.NameSpace.Q.Var &= rULong
		SELF.NameSpace.Q.Address = Address(rULong)
	of DataType:SReal
		rSReal &= NEW SReal
		SELF.NameSpace.Q.Var &= rSreal
		SELF.NameSpace.Q.Address = Address(rSReal)
	of DataType:Real
		rReal &= NEW Real
		SELF.NameSpace.Q.Var &= rReal
		SELF.NameSpace.Q.Address = Address(rReal)
	of DataType:Decimal
		If pDigits > pPrecision
			rDecimal &= NEW Decimal(pDigits,pPrecision)
			SELF.NameSpace.Q.Var &= rDecimal
			SELF.NameSpace.Q.Address = Address(rDecimal)
		end
	of DataType:PDecimal
		If pDigits > pPrecision
			rPDecimal &= NEW PDecimal(pDigits,pPrecision)
			SELF.NameSpace.Q.Var &= rPDecimal
			SELF.NameSpace.Q.Address = Address(rPDecimal)
		end
	of DataType:BFLOAT4
		rBfloat4 &= NEW bFLoat4
		SELF.NameSpace.Q.Var &= rBFloat4
		SELF.NameSpace.Q.Address = Address(rBfloat4)
	of DataType:BFLOAT8
		rBfloat8 &= NEW bFLoat8
		SELF.NameSpace.Q.Var &= rBFloat8
		SELF.NameSpace.Q.Address = Address(rBfloat8)
	of DataType:String
		If pDigits
			rSTring &= NEW String(pDigits)
			SELF.NameSpace.Q.Var &= rString
			SELF.NameSpace.Q.Address = Address(rString)
		end
	of DataType:CString
		If pDigits > 1
			rCSTring &= NEW CString(pDigits)
			SELF.NameSpace.Q.Var &= rCstring
			SELF.NameSpace.Q.Address = Address(rCString)
		end
	of DataType:PString
		If Inrange(pDigits,2,256)
			rPString &= NEW pString(pDigits)
			SELF.NameSpace.Q.Var &= rPString
			SELF.NameSpace.Q.Address = Address(rPString)
		end
	else
		!We'll just use the Any as is
	end


!==============================================================================================================================================================================================
DCL_Data_Datafier.UnBindData            Procedure
!==============================================================================================================================================================================================
!Does a PopBind()
	Code

	If SELF.IsBound
		SELF.IsBound = FALSE
		PopBind()
	end
