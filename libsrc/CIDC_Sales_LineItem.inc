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

    include('CIDC_Sales_Types.inc'),once
    include('CIDC_Sales_TaxCodes.inc'),once

CIDC_Sales_LineItem                         Class,Type,Module('CIDC_Sales_LineItem.CLW'),Link('CIDC_Sales_LineItem.CLW'),thread
Description                                     cstring(500)
Price                                           like(CIDC_Sales_Type_ItemValue)
Quantity                                        long
TaxCodesUsed                                    &CIDC_Sales_TaxCodes
TaxRate                                         like(CIDC_Sales_Type_TaxRate)
Construct                                       Procedure()
Destruct                                        Procedure()
AddTaxCode                                      procedure(string taxCode)
GetExtended                                     procedure,real
GetTotal                                        procedure,real
!SetDiscountAmount                           procedure(real discountPercent)
!SetDiscountPercent                          procedure(real discountPercent)
SetPrice                                        procedure(real price)
SetQuantity                                     procedure(long quantity)
SetTaxCode                                      procedure(string taxCode)
                                            End

CIDC_Sales_LineItem_Queue                   queue,type
LineNumber                                      long
LineItem                                        &CIDC_Sales_LineItem
                                            end