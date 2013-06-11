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


    include('CIDC_Sales_TaxCodes.inc'),once
    include('DCL_System_Diagnostics_Logger.inc'),once

dbg                                     DCL_System_Diagnostics_Logger

CIDC_Sales_TaxCodes.Construct           Procedure()
    code
    self.TaxCodeQ &= new CIDC_Sales_TaxCodes_TaxQueue
    !self.Errors &= new DCL_System_ErrorManager

CIDC_Sales_TaxCodes.Destruct            Procedure()
    code
    !dispose(self.Errors)
    free(self.TaxCodeQ)
    dispose(self.TaxCodeQ)

CIDC_Sales_TaxCodes.AddTaxCode          procedure(string taxCode, real taxRate, string abbreviation, string description)
    code
    clear(self.TaxCodeQ)
    self.TaxCodeQ.taxCode = taxCode
    self.TaxCodeQ.TaxRate = taxRate
    self.TaxCodeQ.abbreviation = abbreviation
    self.TaxCodeQ.description = description
    add(self.TaxCodeQ,self.TaxCodeQ.taxCode)
    
CIDC_Sales_TaxCodes.GetTaxAmount        procedure(string taxCode, real itemValue,*? taxAmount)!,long
TaxRate                                     decimal(5,2)
    code
    if self.GetTaxRate(taxCode,TaxRate) = Level:Benign
        dbg.write('got tax rate: ' & TaxRate)
        dbg.write('value: '& itemValue)
        taxAmount = (TaxRate / 100) * itemValue
        dbg.write('tax amount: ' & taxAmount)
        return Level:Benign
    else
        dbg.write('Could not get a tax rate for code ' & taxCode)
    end
    taxAmount = 0
    return level:fatal

CIDC_Sales_TaxCodes.GetTaxRate          procedure(string taxCode, *? taxRate)!,long
    code
    clear(self.TaxCodeQ)
    self.TaxCodeQ.TaxCode = taxCode
    get(self.TaxCodeQ,self.TaxCodeQ.taxCode)
    if not errorcode()
        taxRate = self.TaxCodeQ.TaxRate
        return Level:Benign
    end
    return level:fatal
    
    
CIDC_Sales_TaxCodes.Validate            procedure(string taxCode)!,long
TaxRate                                     decimal(5,2)
    code
    ! TaxRate is a throwaway value to avoid creating another
    ! method that gets the taxcodeq record.
    return self.GetTaxRate(taxCode,taxRate)

    
                  