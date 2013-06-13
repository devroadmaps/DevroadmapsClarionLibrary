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

    include('CIDC_Sales_Invoice.inc'),once
    include('DCL_System_Diagnostics_Logger.inc'),once

dbg                                     DCL_System_Diagnostics_Logger

CIDC_Sales_Invoice.Construct                Procedure()
    code
    self.LineItemQ &= new CIDC_Sales_LineItem_Queue
    self.TaxCodesUsed &= new CIDC_Sales_TaxCodes

CIDC_Sales_Invoice.Destruct                 Procedure()
x                                               long
    code
    loop x = 1 to records(self.LineItemQ)
        get(self.LineItemQ,x)
        dispose(self.LineItemQ.LineItem)
    end
    free(self.LineItemQ)
    dispose(self.LineItemQ)
    dispose(self.TaxCodesUsed)

CIDC_Sales_Invoice.AddDetail                procedure!,*CIDC_Sales_LineItem
LineItem                                        &CIDC_Sales_LineItem
    code
    clear(self.LineItemQ)
    self.LineItemQ.LineItem &= new CIDC_Sales_LineItem
    add(self.LineItemQ)
    return self.LineItemQ.LineItem
	
CIDC_Sales_Invoice.Calculate                procedure
x                                               long
y                                               long
LineItem                                        &CIDC_Sales_LineItem
taxAmount                                       like(CIDC_Sales_Type_ItemValue)
    code
    self.Total = 0
    self.PreTaxTotal = 0
    self.TaxTotal = 0
    self.TaxCodesUsed.Reset()
    loop x = 1 to records(self.LineItemQ)
        get(self.LineItemQ,x)
        LineItem &= self.LineItemQ.LineItem
        dbg.write('Item ' & LineItem.Description)
        self.PreTaxTotal += LineItem.GetExtended()
        ! Sum up the taxable amounts for each tax
        loop y = 1 to LineItem.TaxCodesUsed.GetCount()
            dbg.write('Tax code: ' & LineItem.TaxCodesUsed.GetCode(y) & ', extended ' & LineItem.GetExtended())
            self.TaxCodesUsed.AddToTaxableAmount(LineItem.TaxCodesUsed.GetCode(y),LineItem.GetExtended())
        end
    end
    ! Calculate the taxes payable for each tax code
    dbg.write('Looping through invoice tax codes')
    loop x = 1 to self.TaxCodesUsed.GetCount()
        get(self.TaxCodesUsed.TaxCodeQ,x)
        if self.TaxList.GetTaxAmount(self.TaxCodesUsed.TaxCodeQ.TaxCode,self.TaxCodesUsed.TaxCodeQ.TaxableTotal,taxAmount) = Level:Fatal
            stop('Unable to calculate tax: there is no tax object for the tax code ' & self.TaxCodesUsed.TaxCodeQ.TaxCode)
        end
        dbg.write('Tax code: ' & self.TaxCodesUsed.TaxCodeQ.TaxCode & ', total ' & self.TaxCodesUsed.TaxCodeQ.TaxableTotal & ', tax ' & taxAmount)
        self.TaxTotal += taxAmount
    end
    self.Total = self.PreTaxTotal + self.TaxTotal
    
CIDC_Sales_Invoice.GetTax                   procedure!,real
    code
    self.Calculate()
    return self.TaxTotal

CIDC_Sales_Invoice.GetTotal                 procedure!,real
    code
    self.Calculate()
    return self.Total

CIDC_Sales_Invoice.Init                     procedure(*CIDC_Sales_TaxList TaxList)
    code
    self.TaxList &= TaxList