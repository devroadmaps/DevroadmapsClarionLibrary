                                        MEMBER()

!--- these are usually set as project Defines
!omit('***',_c55_)
!_ABCDllMode_  EQUATE(0)
!_ABCLinkMode_ EQUATE(1)
!***
!
!--------------------------
!ClarionLive Skeleton Class
!--------------------------

    INCLUDE('EQUATES.CLW')  !for ICON: and BEEP: etc.
! INCLUDE('KeyCodes.CLW')

    INCLUDE('util_ReportControls.INC'),ONCE
    INCLUDE('PRM_Utility_ReturnPendingType.INC'),ONCE   
    INCLUDE('UltimateDebug.inc'),ONCE  
    INCLUDE('pos_Transactions.inc'),ONCE

                                        MAP
                                        END

uud                                     UltimateDebug
oTransactions                           pos_Transactions


!----------------------------------------
util_ReportControls.Construct           PROCEDURE()
!----------------------------------------
    CODE


    RETURN

!---------------------------------------
util_ReportControls.Destruct            PROCEDURE()
!---------------------------------------
    CODE


    RETURN


!-----------------------------------
util_ReportControls.Init                PROCEDURE()
!-----------------------------------

    CODE

    SELF.InDebug = FALSE

    RETURN
    
    
!-----------------------------------
util_ReportControls.Kill                PROCEDURE()
!-----------------------------------

    CODE
    
    
    RETURN
    
    
!-----------------------------------------
util_ReportControls.ClearReport         PROCEDURE(ReportControlClass pReportControl)
!-----------------------------------------

    CODE
    
!    pReportControl.DeleteAllRows(FALSE)
!    pReportControl.DeleteAllHeaderRows(FALSE)
!    pReportControl.DeleteAllFooterRows(FALSE)
!    pReportControl.OCXDirectCommand('Columns.DeleteAll','')
    pReportControl.RestoreLayout('<[ReportControlLayout]>',0,0,)
    pReportControl.OCXDirectCommand('Populate','')
    
    RETURN

    
!-----------------------------------------    
util_ReportControls.CreateAPPendingHeader       PROCEDURE(ReportControlClass pReportControl)
!----------------------------------------- 

    CODE
    
    SELF.CreateStandardReportControl(pReportControl,'Invoice','Invoice')
    SELF.CreateStandardReportControl(pReportControl,'Vendor','Vendor',150)
    SELF.CreateStandardReportControl(pReportControl,'PO Number','PO Number')
    SELF.CreateStandardReportControl(pReportControl,'Invoice Date','Invoice Date')
    SELF.CreateStandardReportControl(pReportControl,'Type','Type')
    SELF.CreateStandardReportControl(pReportControl,'Due','Due')
    SELF.CreateStandardReportControl(pReportControl,'Amount','Amount')
    SELF.CreateStandardReportControl(pReportControl,'GUID','GUID',,0)
    SELF.CreateStandardReportControl(pReportControl,'VendorID','VendorID',,0)
    SELF.CreateStandardReportControl(pReportControl,'POID','POID',,0)
    
    RETURN
    
    
!-----------------------------------------
util_ReportControls.GetSelectedValue    PROCEDURE(ReportControlClass pReportControl,STRING pCell)   !,STRING
!-----------------------------------------
    
    CODE
    
    RETURN pReportControl.GetRowCellValue(pReportControl.GetSelectedRowID(),pCell)
    
    
!-----------------------------------------
util_ReportControls.FillAPPendingHeader         PROCEDURE(ReportControlClass pReportControl,UltimateSQL pSQL,STRING pSite)    
!-----------------------------------------

q                                                   QUEUE
Invoice                                                 STRING(20)
VendorID                                                LONG
ID                                                      LONG
InvoiceDate                                             LONG
Type                                                    STRING(3)
Due                                                     DECIMAL(14,2)
Amount                                                  DECIMAL(14,2)  
GUID                                                    STRING(16)
                                                    END

PONumber                                            STRING(20)
Count                                               LONG

    CODE
    
    FREE(q)
    
    pSQL.Query('Select APL_Invoice,APL_V_ID,APL_ID,APL_Type,APL_InvDate,APL_Due,APL_Amount,APL_GUID FROM APLIST Where APL_Site = ' & pSQL.Quote(pSite),|
        q,q.Invoice,q.VendorID,q.ID,q.Type,q.InvoiceDate,q.Due,q.Amount)
    
    LOOP Count = 1 TO RECORDS(q)
        GET(q,Count)
        pReportControl.AddRow(Count)
        
        pReportControl.SetRowCellValue(Count,'Invoice',q.Invoice)
        pReportControl.SetRowCellValue(Count,'Vendor',pSQL.QueryResult('Select VEN_Name FROM APVEND Where VEN_V_ID = ' & q.VendorID)) 
        pReportControl.SetRowCellValue(Count,'PO Number',pSQL.QueryResult('Select PPO_PONM FROM P_PO Where PPO_Site = ' & pSQL.Quote(pSite) & ' AND PPO_POID = ' & q.ID))
        pReportControl.SetRowCellValue(Count,'Invoice Date',FORMAT(q.InvoiceDate,@D17))
        pReportControl.SetRowCellValue(Count,'Type',CHOOSE(q.Type = 'Cre','Credit','Charge'))
        pReportControl.SetRowCellValue(Count,'Due',FORMAT(q.Due,@D17))
        pReportControl.SetRowCellValue(Count,'Amount',FORMAT(q.Amount,@N-11.2)) 
        pReportControl.SetColumnAlignment('Amount', 2)
        
        pReportControl.SetRowCellValue(Count,'GUID',q.GUID)
        pReportControl.SetRowCellValue(Count,'VendorID',q.VendorID)
        pReportControl.SetRowCellValue(Count,'POID',q.ID)
        
    END
    
    RETURN
    
    
!-----------------------------------------
util_ReportControls.CreatePurchaseOrderHistoryDetail    PROCEDURE(ReportControlClass pReportControl) 
!-----------------------------------------     

    CODE
    
    SELF.CreateStandardReportControl(pReportControl,'SKU','SKU')
    SELF.CreateStandardReportControl(pReportControl,'Vendor SKU','Vendor SKU')
    SELF.CreateStandardReportControl(pReportControl,'Description','Description',150)
    SELF.CreateStandardReportControl(pReportControl,'Ordered','Ordered')
    SELF.CreateStandardReportControl(pReportControl,'Received','Received')
    SELF.CreateStandardReportControl(pReportControl,'Cost','Cost')
    SELF.CreateStandardReportControl(pReportControl,'Total','Total')
    SELF.CreateStandardReportControl(pReportControl,'INVNO','INVNO',,0)
    
    
    RETURN


!-----------------------------------------
util_ReportControls.FillPurchaseOrderHistoryDetail      PROCEDURE(ReportControlClass pReportControl,UltimateSQL pSQL,STRING pSite,LONG pPoid,STRING pQuanFormat,STRING pCostFormat)
!-----------------------------------------
q                                                           QUEUE
SKU                                                             STRING(20)
VendorSKU                                                       STRING(20)
Description                                                     STRING(60)
Ordered                                                         DECIMAL(14,4)
Received                                                        DECIMAL(14,4)
Cost                                                            DECIMAL(14,4)        
Invno                                                           LONG
                                                            END

Total                                                       DECIMAL(14,4)
Count                                                       LONG

    CODE
    
    FREE(q)
    
    pSQL.Query('Select PDT_Barcode,PDT_Vino,PDT_Desc,PDT_Quan,PDT_Qrcv,PDT_Cost,PDT_INVNO From P_DT Where PDT_Site = ' & pSQL.Quote(pSite) & ' AND PDT_POID = ' & pPoid,|
        q,q.SKU,q.VendorSKU,q.Description,q.Ordered,q.Received,q.Cost,q.Invno)
    
    LOOP Count = 1 TO RECORDS(q)
        GET(q,Count)
        pReportControl.AddRow(Count)
        
        pReportControl.SetRowCellValue(Count,'SKU',q.SKU)
        pReportControl.SetRowCellValue(Count,'Vendor SKU',q.VendorSKU)
        pReportControl.SetRowCellValue(Count,'Description',q.Description)
        pReportControl.SetRowCellValue(Count,'Ordered',FORMAT(q.Ordered,pQuanFormat))   
        pReportControl.SetColumnAlignment('Ordered', 2)
        pReportControl.SetRowCellValue(Count,'Received',FORMAT(q.Received,pQuanFormat))
        pReportControl.SetColumnAlignment('Received', 2)
        pReportControl.SetRowCellValue(Count,'Cost',FORMAT(q.Cost,pCostFormat))
        pReportControl.SetColumnAlignment('Cost', 2)
        pReportControl.SetRowCellValue(Count,'Total',FORMAT(q.Cost*q.Received,@n-11.2))
        pReportControl.SetColumnAlignment('Total', 2)
        pReportControl.SetRowCellValue(Count,'INVNO',q.Invno)
    END
    
    RETURN


util_ReportControls.CreateTransactionHeader     PROCEDURE(ReportControlClass pReportControl)   
!-----------------------------------------
    
    CODE
    
    SELF.CreateStandardReportControl(pReportControl,'Type','Type',,,TRUE)
    SELF.CreateStandardReportControl(pReportControl,'Reference','Reference')
    SELF.CreateStandardReportControl(pReportControl,'Name','Name',150,,TRUE)
    SELF.CreateStandardReportControl(pReportControl,'Entered','Entered') 
    pReportControl.SetColumnAlignment('Entered', 2)
    
    SELF.CreateStandardReportControl(pReportControl,'Due','Due')
    pReportControl.SetColumnAlignment('Due', 2)
    
    SELF.CreateStandardReportControl(pReportControl,'TotalwTax','Total w/Tax')  
    pReportControl.SetColumnAlignment('TotalwTax', 2)
    
    SELF.CreateStandardReportControl(pReportControl,'Deposit','Deposit')
    pReportControl.SetColumnAlignment('Deposit', 2)
    
    SELF.CreateStandardReportControl(pReportControl,'Balance','Balance')
    pReportControl.SetColumnAlignment('Balance', 2)
    
    SELF.CreateStandardReportControl(pReportControl,'GUID','GUID',,0)
    SELF.CreateStandardReportControl(pReportControl,'CustID','CustID',,0)
    SELF.CreateStandardReportControl(pReportControl,'ShipID','ShipID',,0)
    
    RETURN
    
    
!-----------------------------------------
util_ReportControls.FillTransactionHeader       PROCEDURE(ReportControlClass pReportControl,UltimateSQL pSQL,STRING pSite)
!-----------------------------------------

q                                                   Queue
Type                                                    STRING(1)
Reference                                               STRING(14)
Name                                                    STRING(80)
Entered                                                 LONG
Due                                                     LONG
Total                                                   DECIMAL(14,2)
Deposit                                                 DECIMAL(14,2)
GUID                                                    STRING(16)       
CustID                                                  STRING(14) 
ShipID                                                  STRING(14)
                                                    END
  
Count                                               LONG

oSetPendingType                                     PRM_Utility_ReturnPendingType

    CODE                  
    
    FREE(q)  
    
    pReportControl.DeleteAllRows(1)
    
    pSQL.Query('Select ORD_Status,ORD_Invoiceno,ORD_Name,ORD_SalesDate,ORD_DateDue,ORD_Deposit,ORD_Total+ORD_Tax1+ORD_Tax2,ORD_GUID,ORD_CustID,ORD_ShipID FROM Orders Where ORD_Status LIKE <39>[OLSQNJ]<39> AND ORD_Site = ' & pSQL.Quote(pSite),|
        q,q.Type,q.Reference,q.Name,q.Entered,q.Due,q.Deposit,q.Total,q.GUID,q.CustID,q.ShipID)
!     uud.DebugQueue(q)                                                        
    LOOP Count = 1 TO RECORDS(q)
        GET(q,Count)
        pReportControl.AddRow(Count)
        
        pReportControl.SetRowCellValue(Count,'Type',oSetPendingType.PendingDescription(q.Type))
        pReportControl.SetRowCellValue(Count,'Reference',q.Reference)
        pReportControl.SetRowCellValue(Count,'Name',q.Name)
        pReportControl.SetRowCellValue(Count,'Entered',FORMAT(q.Entered,@D17))
        pReportControl.SetRowCellValue(Count,'Due',FORMAT(q.Due,@D17))
        pReportControl.SetRowCellValue(Count,'TotalwTax',FORMAT(q.Total,@N14.2))
        pReportControl.SetRowCellValue(Count,'Deposit',FORMAT(q.Deposit,@N14.2))
        pReportControl.SetRowCellValue(Count,'Balance',FORMAT(q.Total-q.Deposit,@N14.2))
        pReportControl.SetRowCellValue(Count,'GUID',q.GUID)
        pReportControl.SetRowCellValue(Count,'CustID',q.CustID)
        pReportControl.SetRowCellValue(Count,'ShipID',q.ShipID)
    END    
    
    RETURN


!-----------------------------------------
util_ReportControls.CreateTransactionDetail     PROCEDURE(ReportControlClass pReportControl,BYTE pHeaderType = eHeaderTypeStandard)   
!-----------------------------------------

    CODE
    
    SELF.CreateStandardReportControl(pReportControl,'Section', 'Section',,0)
    SELF.CreateStandardReportControl(pReportControl,'SKU', 'SKU')  
    pReportControl.SetColumnTree('SKU', 1)
    
    SELF.CreateStandardReportControl(pReportControl,'Description', 'Description',150) 
    pReportControl.SetColumnAlignment('Description', 16)
    SELF.CreateStandardReportControl(pReportControl,'Quantity', 'Quantity')  
    pReportControl.SetColumnAlignment('Quantity', 2)
    SELF.CreateStandardReportControl(pReportControl,'BackOrder', 'BackOrder')
    pReportControl.SetColumnAlignment('BackOrder', 2)
    SELF.CreateStandardReportControl(pReportControl,'Price', 'Price')
    pReportControl.SetColumnAlignment('Price', 2)
    SELF.CreateStandardReportControl(pReportControl,'Total', 'Total') 
    pReportControl.SetColumnAlignment('Total', 2)
    SELF.CreateStandardReportControl(pReportControl,'GUID', 'GUID',,0) 
    
    pReportControl.OCXDirectCommand('Populate','')
    
    RETURN                 
    
 
!-----------------------------------------
util_ReportControls.CreateStandardReportControl PROCEDURE(ReportControlClass pReportControl,STRING pColumnID,STRING pColumnName,USHORT pWidth=50,BYTE pVisible=1,BYTE pGroupable=0)
!-----------------------------------------
ReportControl_ColumnCreated                         BYTE(0)
ReportControl_Ctrl                                  CSTRING(20)

    CODE
    
    ReportControl_ColumnCreated = TRUE
    ReportControl_Ctrl          = pReportControl.AddColumn(pColumnID, pColumnName, pWidth, 1)
    pReportControl.SetColumnCaption(pColumnID, pColumnName)
    pReportControl.SetColumnAlignment(pColumnID, 0)
    pReportControl.SetColumnAutoSize(pColumnID, 1)
    pReportControl.SetColumnBestFitMode(pColumnID, 1)
    pReportControl.SetColumnDrag(pColumnID, 0)
    pReportControl.SetColumnFieldSelector(pColumnID, 0)
    pReportControl.SetColumnEditable(pColumnID, 0)
    pReportControl.SetColumnExpandable(pColumnID, FALSE, 0)
    pReportControl.SetColumnFiltrable(pColumnID, 0)
    pReportControl.SetColumnFooterFont(pColumnID, 'Tahoma', '8.25', 0, 0, 0, 0)
    pReportControl.SetColumnGroupable(pColumnID, pGroupable)
    pReportControl.SetColumnIsHyperlink(pColumnID, FALSE)
    pReportControl.SetColumnMinimumWidth(pColumnID, 50)
    pReportControl.SetColumnRemove(pColumnID, 0)
    pReportControl.SetColumnResizable(pColumnID, 1)
    pReportControl.SetColumnSortable(pColumnID, 1)
    pReportControl.SetColumnSortGrouped(pColumnID, 0)
    pReportControl.SetColumnTree(pColumnID, 0)
    IF ReportControl_ColumnCreated = TRUE THEN pReportControl.SetColumnVisible(pColumnID, pVisible).     
    
!-----------------------------------------
util_ReportControls.FillTransactionDetail       PROCEDURE(ReportControlClass pReportControl,UltimateSQL pSQL,STRING pSite,LONG pInvoiceno,STRING pStatus,BYTE pShowCost)
!-----------------------------------------

q                                                   Queue
Barcode                                                 STRING(20)
Delivered                                               STRING(1)
Description                                             STRING(20)
Disc                                                    Decimal(7,2)
DQuan                                                   DECIMAL(14,4)  
ID                                                      LONG
InStock                                                 Decimal(14,4)
ItemCost                                                Decimal(14,4)
LineNote                                                STRING(5000)
LineTotal                                               DECIMAL(14,4)
LocationDescription                                     STRING(20)
Notation                                                STRING(66)
PRICE                                                   DECIMAL(14,4)
Quantity                                                DECIMAL(14,4)
ReferencePrice                                          Decimal(14,4)
rPRICE                                                  DECIMAL(14,4)
ShowPrice                                               BYTE(0)
SNQuan                                                  LONG
SNUM                                                    STRING(30) 
Spec                                                    STRING(1)
T_QN                                                    STRING(1)
T_SN                                                    STRING(1)
Tag                                                     STRING(1)
TaxAmount                                               Decimal(14,4)
TBord                                                   Decimal(14,4)
Weight                                                  STRING(7)
GUID                                                    STRING(16)
                                                    END

PackageParentID                                     LONG
SectionParentID                                     LONG
IsPackage                                           BYTE(0)
IsSection                                           BYTE(0)

Count                                               LONG  

oTLI                                                GROUP(LineItemGroup)
                                                    END


    CODE                  
    
    FREE(q)
    CLEAR(q)
    
!!    IF SELF.QuantityFormat = ''
!!        SELF.QuantityFormat = '@N11.2'
!!    END
!!    IF SELF.PriceFormat = ''
!!        SELF.PriceFormat = '@N11.2'
!!    END
!!    IF SELF.CostFormat = ''
!!        SELF.CostFormat = '@11.2'
!!    END
        
    oTransactions.QuanFormat        = SELF.QuanFormat
    oTransactions.PriceFormat       = SELF.PriceFormat
    oTransactions.CostFormat        = SELF.CostFormat
    oTransactions.HBO               = SELF.HBO
    oTransactions.BOI               = SELF.BOI
    oTransactions.ShowPriority      = SELF.ShowPriority
    oTransactions.PriceIncludesTax  = SELF.PriceIncludesTax
    
    pReportControl.DeleteAllRows(1)
    
    pSQL.Query('Select IND_Barcode,IND_Delivered,IND_Description,IND_Disc,IND_DQuan,IND_ID,IND_InStock,IND_ItemCost,IND_LineNote,IND_LocationDescription,IND_Notation,' & |         
        'IND_PRICE,IND_Quantity,IND_ReferencePrice,IND_rPRICE,IND_ShowPrice,IND_SNQuan,IND_SNUM,IND_Spec,IND_T_QN,IND_T_SN,IND_Tag,IND_TaxAmount,IND_TBord,IND_Weight,IND_GUID FROM INVDET ' & |
        'Where IND_Site = ' & pSQL.Quote(pSite) & ' AND IND_Invoiceno = ' & pInvoiceno & ' ORDER BY IND_InvoiceItem',|
        q,q.Barcode,q.Delivered,q.Description,q.Disc,q.DQuan,q.ID,q.InStock,q.ItemCost,q.LineNote,q.LocationDescription,q.Notation,q.PRICE,q.Quantity,q.ReferencePrice,q.rPRICE, |   
        q.ShowPrice,q.SNQuan,q.SNUM,q.Spec,q.T_QN,q.T_SN,q.Tag,q.TaxAmount,q.TBord,q.Weight,q.GUID)
                                                             
    LOOP Count = 1 TO RECORDS(q)
        GET(q,Count) 
        
        IF q.Barcode = 'NOTE:' AND q.LineNote = '';CYCLE.
        
        IF q.Barcode = '*SECTION/*' AND SectionParentID
            SectionParentID = ''
        END
        
        
        IF PackageParentID
            pReportControl.AddChildRow(PackageParentID,Count)
        ELSE   
            IF SectionParentID
                pReportControl.AddChildRow(SectionParentID,Count)
            ELSE    
                pReportControl.AddRow(Count)
            END
        END
        
        IF PackageParentID AND q.Barcode = 'SUBTOTAL'
            PackageParentID = ''
        END
        
        
        
        oTLI.Barcode                 = q.Barcode            
        oTLI.Delivered               = q.Delivered         
        oTLI.Description             = q.Description       
        oTLI.Disc                    = q.Disc              
        oTLI.DQuan                   = q.DQuan             
        oTLI.ID                      = q.ID                
        oTLI.InStock                 = q.InStock           
        oTLI.ItemCost                = q.ItemCost          
        oTLI.LineNote                = q.LineNote          
        oTLI.LineTotal               = q.LineTotal         
        oTLI.LocationDescription     = q.LocationDescription 
        oTLI.Notation                = q.Notation          
        oTLI.PRICE                   = q.PRICE             
        oTLI.Quantity                = q.Quantity          
        oTLI.ReferencePrice          = q.ReferencePrice    
        oTLI.rPRICE                  = q.rPRICE            
        oTLI.ShowPrice               = q.ShowPrice         
        oTLI.SNQuan                  = q.SNQuan            
        oTLI.SNUM                    = q.SNUM              
        oTLI.Spec                    = q.Spec              
        oTLI.T_QN                    = q.T_QN              
        oTLI.T_SN                    = q.T_SN              
        oTLI.Tag                     = q.Tag               
        oTLI.TaxAmount               = q.TaxAmount         
        oTLI.TBord		             = q.TBord 
        oTLI.Weight                  = q.Weight
        
        oTransactions.BuildLineItems(oTLI,pStatus,pShowCost)
        
        IF q.Barcode = '*SECTION/*'
            pReportControl.SetRowCellValue(Count,'Description',oTransactions.Description)
            pReportControl.SetRowBold(Count,TRUE)  
        ELSIF q.LineNote   
            pReportControl.AddChildRow(Count-1,Count)
            pReportControl.SetRowCellValue(Count,'Description',CLIP(oTransactions.LineNote)  )
        ELSE
            pReportControl.SetRowCellValue(Count,'SKU',oTransactions.SKU)
            pReportControl.SetRowCellValue(Count,'Description',oTransactions.Description)
            pReportControl.SetRowCellValue(Count,'Quantity',oTransactions.Quantity)
            pReportControl.SetRowCellValue(Count,'BackOrder',oTransactions.Bord)
            pReportControl.SetRowCellValue(Count,'Price',oTransactions.Price)
            pReportControl.SetRowCellValue(Count,'Total',oTransactions.LineTotal)
            pReportControl.SetRowCellValue(Count,'GUID',q.GUID)     
        END   
           
        IF q.Barcode = 'PACKAGE'
            PackageParentID = Count 
        END
        
        IF q.Barcode = '*SECTION/*'
            SectionParentID = Count 
        END
                
        
    END    
    
    pReportControl.ExpandAllRows()
    
    RETURN

    
!-----------------------------------------
util_ReportControls.CreateTransactionTotals     PROCEDURE(ReportControlClass pReportControl)
!-----------------------------------------
 
    CODE
    
    SELF.CreateStandardReportControl(pReportControl,'Description', 'Description')
    SELF.CreateStandardReportControl(pReportControl,'Amount', 'Amount')
    
    RETURN


!-----------------------------------------
util_ReportControls.FillTransactionTotals       PROCEDURE(ReportControlClass pReportControl,UltimateSQL pSQL,STRING pGUID,STRING pPriceFormat)    
!-----------------------------------------

Count                                               LONG              
Total                                               Decimal(14,2)
Tax1                                                Decimal(14,2)
Tax2                                                Decimal(14,2)
Deposit                                             Decimal(14,2)


    CODE
    
    pReportControl.DeleteAllRows(1)
    
    pSQL.Query('Select ORD_Total,ORD_Tax1,ORD_Tax2,ORD_Deposit FROM Orders Where ORD_Guid = ' & pSQL.Quote(pGUID),,|
        Total,Tax1,Tax2,Deposit)
    
    Count +=1
    pReportControl.AddRow(Count)
    
    pReportControl.SetRowCellValue(Count,'Description','Amount')
    pReportControl.SetRowCellValue(Count,'Amount',Format(Total,pPriceFormat)) 
    
    Count +=1
    pReportControl.AddRow(Count)
    pReportControl.SetRowCellValue(Count,'Description','Tax 1')
    pReportControl.SetRowCellValue(Count,'Amount',Format(Tax1,pPriceFormat))
    
    Count +=1
    pReportControl.AddRow(Count)
    pReportControl.SetRowCellValue(Count,'Description','Tax 2')
    pReportControl.SetRowCellValue(Count,'Amount',Format(Tax2,pPriceFormat))
                                                    
    Count +=1
    pReportControl.AddRow(Count)
    pReportControl.SetRowCellValue(Count,'Description','SubTotal')
    pReportControl.SetRowCellValue(Count,'Amount',Format(Total+Tax1+Tax2,pPriceFormat))
    
    Count +=1
    pReportControl.AddRow(Count)
    pReportControl.SetRowCellValue(Count,'Description','Deposit')
    pReportControl.SetRowCellValue(Count,'Amount',Format(Deposit,pPriceFormat))
    
    Count +=1
    pReportControl.AddRow(Count)
    pReportControl.SetRowCellValue(Count,'Description',CHOOSE(Total+Tax1+Tax2-Deposit < 0,'Total Owed','Total Due') )
    pReportControl.SetRowCellValue(Count,'Amount',Format(Total+Tax1+Tax2-Deposit,pPriceFormat))
    
    
    RETURN

!-----------------------------------------
util_ReportControls.CreateVendorNotes   PROCEDURE(ReportControlClass pReportControl)
!-----------------------------------------

    CODE
      
    SELF.CreateStandardReportControl(pReportControl,'Date', 'Date',10)
    SELF.CreateStandardReportControl(pReportControl,'Time', 'Time',10)
    SELF.CreateStandardReportControl(pReportControl,'ID', 'ID',5)
    SELF.CreateStandardReportControl(pReportControl,'Note', 'Note')      
    pReportControl.SetColumnAlignment('Note', 16)
    SELF.CreateStandardReportControl(pReportControl,'GUID', 'GUID',,FALSE)
    
    RETURN


!-----------------------------------------
util_ReportControls.FillVendorNotes     PROCEDURE(ReportControlClass pReportControl,UltimateSQL pSQL,LONG pVendorID)
!-----------------------------------------  

Count                                       LONG              

q                                           QUEUE
TheDate                                         LONG
TheTime                                         LONG
TheID                                           STRING(6)
TheNote                                         STRING(10000)
                                            END

    CODE
    
    pReportControl.DeleteAllRows(1)
    
    
    pSQL.Query('Select NTS_ODTE, NTS_OTIM, NTS_T_ID, NTS_NOTE FROM NOTES Where NTS_Type = ' & pSQL.Quote('V') & ' AND NTS_N_ID = ' & pVendorID & ' ORDER BY NTS_ODTE Desc,NTS_OTIM Desc',|
        q,q.TheDate,q.TheTime,q.TheID,q.TheNote)
    
    LOOP Count = 1 TO RECORDS(q)
        GET(q,Count)
        pReportControl.AddRow(Count)
        
        pReportControl.SetRowCellValue(Count,'Date',FORMAT(q.TheDate,@D17))
        pReportControl.SetRowCellValue(Count,'Time',FORMAT(q.TheTime,@T7))
        pReportControl.SetRowCellValue(Count,'ID',q.TheID)
        pReportControl.SetRowCellValue(Count,'Note',q.TheNote)     
        
    END

    

!---------------------------------------------------------
util_ReportControls.RaiseError          PROCEDURE(STRING pErrorMsg)
!---------------------------------------------------------

    CODE

    IF SELF.InDebug = TRUE
        BEEP(BEEP:SystemExclamation)
        MESSAGE(CLIP(pErrorMsg), 'ClarionLive Error', ICON:EXCLAMATION)
    END

    RETURN
