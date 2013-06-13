!---------------------------------------------------------------------------------------------!
! Copyright (c) 2013, CoveComm Inc.
! All rights reserved.
!---------------------------------------------------------------------------------------------!
!region
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
!endregion


                                            Member
                                            Map
                                            End

    include('CIDC_Sales_TaxList.inc'),once
    !include('DCL_System_Diagnostics_Logger.inc'),once

!dbg                                     DCL_System_Diagnostics_Logger

CIDC_Sales_TaxList.Construct                Procedure()
    code
    self.TaxQ &= new CIDC_Sales_Tax_Queue

CIDC_Sales_TaxList.Destruct                 Procedure()
x                                               long
    code
    loop x = 1 to records(self.TaxQ)
        get(self.TaxQ,x)
        dispose(self.TaxQ.Tax)
    end
    free(self.TaxQ)
    
CIDC_Sales_TaxList.AddTax                   procedure(string taxCode, real taxRate, <string abbreviation>,<string description>,long EffectiveDate=0)
    code
    clear(self.TaxQ)
    self.TaxQ.Tax &= new CIDC_Sales_Tax
    self.TaxQ.Tax.Rate = taxRate
    self.TaxQ.Tax.TaxCode = upper(taxCode)
    if not omitted(abbreviation)
        self.TaxQ.Tax.Abbreviation = abbreviation
    end
    if not omitted(description)
        self.TaxQ.Tax.Description = description
    end
    self.TaxQ.EffectiveDate = EffectiveDate
    self.TaxQ.TaxCode = upper(TaxCode)
    add(self.TaxQ)
    
CIDC_Sales_TaxList.GetTax                   procedure(string taxCode,long taxDate=0)!,*CIDC_Sales_Tax
x                                               long
    code
    sort(self.TaxQ,self.TaxQ.TaxCode,self.TaxQ.EffectiveDate)
    loop x = 1 to records(self.TaxQ)
        get(self.TaxQ,x)
        if self.TaxQ.TaxCode = upper(taxCode) and self.TaxQ.EffectiveDate =< taxDate
            return self.TaxQ.Tax
        end
    end
    return null
        
CIDC_Sales_TaxList.GetTaxAmount             procedure(string taxCode,real amount,*? taxAmount)!,long
CurrentTax                                      &CIDC_Sales_Tax
    code
    CurrentTax &= self.GetTax(taxCode)
    if CurrentTax &= null then return level:fatal.
    taxAmount = CurrentTax.GetTaxOn(amount)
    return level:benign 