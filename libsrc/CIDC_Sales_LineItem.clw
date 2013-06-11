!---------------------------------------------------------------------------------------------!
! Copyright (c) 2013, CoveComm Inc.
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

										Member
										Map
										End


	include('CIDC_Sales_LineItem.inc'),once
	include('DCL_System_Diagnostics_Logger.inc'),once

dbg                                     DCL_System_Diagnostics_Logger

CIDC_Sales_LineItem.Construct           Procedure()
	code
    !self.Errors &= new DCL_System_ErrorManager
    self.Quantity = 1


CIDC_Sales_LineItem.Destruct            Procedure()
	code
	!dispose(self.Errors)

CIDC_Sales_LineItem.GetExtended         procedure!,real
result                                      decimal(11,2)
    code
    result = self.Quantity * self.Price
    return result
    
CIDC_Sales_LineItem.GetTax              procedure!,real
result                                      decimal(11,2)
    code
    if self.TaxCodes &= null then halt(,'Line item does not have a TaxCodes object').
    self.TaxCodes.GetTaxAmount(self.TaxCode,self.Price,result)
    return result
    
    
CIDC_Sales_LineItem.GetTotal            procedure!,real
    code
    return self.GetExtended() + self.GetTax()

CIDC_Sales_LineItem.SetPrice            procedure(real price)
    code
    self.Price = price
	
CIDC_Sales_LineItem.SetQuantity         procedure(long quantity)
    code
    self.Quantity = quantity
	
CIDC_Sales_LineItem.SetTaxCode          procedure(string taxCode)
    code
    if self.TaxCodes &= null then halt(,'Line item does not have a TaxCodes object').
    if self.TaxCodes.Validate(taxCode) = Level:Benign
        self.TaxCode = taxCode
        return Level:Benign
    end
    return level:fatal




