  MEMBER('Allfiles.clw')

  INCLUDE('ABFILE.INC'),ONCE

  MAP
Allfiles_BC0:DctInit    PROCEDURE
Allfiles_BC0:DctKill    PROCEDURE
Allfiles_BC0:FilesInit  PROCEDURE
  END

Hide:Access:Customer CLASS(FileManager),TYPE               ! FileManager for Customer
Init                   PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
PrimeFields            PROCEDURE(),PROC,DERIVED            ! Method added to host embed code
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED ! Method added to host embed code
                     END


Hide:Relate:Customer CLASS(RelationManager),TYPE           ! RelationManager for Customer
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
                     END

Hide:Access:Orders   CLASS(FileManager),TYPE               ! FileManager for Orders
Init                   PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
PrimeFields            PROCEDURE(),PROC,DERIVED            ! Method added to host embed code
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED ! Method added to host embed code
ValidateFieldServer    PROCEDURE(UNSIGNED Id,BYTE HandleErrors),BYTE,PROC,DERIVED ! Method added to host embed code
                     END


Hide:Relate:Orders   CLASS(RelationManager),TYPE           ! RelationManager for Orders
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
                     END

Hide:Access:Detail   CLASS(FileManager),TYPE               ! FileManager for Detail
Init                   PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED ! Method added to host embed code
ValidateFieldServer    PROCEDURE(UNSIGNED Id,BYTE HandleErrors),BYTE,PROC,DERIVED ! Method added to host embed code
                     END


Hide:Relate:Detail   CLASS(RelationManager),TYPE           ! RelationManager for Detail
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
                     END

Hide:Access:Products CLASS(FileManager),TYPE               ! FileManager for Products
Init                   PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED ! Method added to host embed code
                     END


Hide:Relate:Products CLASS(RelationManager),TYPE           ! RelationManager for Products
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
                     END

Hide:Access:Phones   CLASS(FileManager),TYPE               ! FileManager for Phones
Init                   PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED ! Method added to host embed code
                     END


Hide:Relate:Phones   CLASS(RelationManager),TYPE           ! RelationManager for Phones
Init                   PROCEDURE
DeferedAddRelations    PROCEDURE(),DERIVED                 ! Method added to host embed code
Kill                   PROCEDURE(),DERIVED                 ! Method added to host embed code
                     END


_Hide:Access:Customer &Hide:Access:Customer,AUTO,THREAD
_Hide:Relate:Customer &Hide:Relate:Customer,AUTO,THREAD
_Hide:Access:Orders  &Hide:Access:Orders,AUTO,THREAD
_Hide:Relate:Orders  &Hide:Relate:Orders,AUTO,THREAD
_Hide:Access:Detail  &Hide:Access:Detail,AUTO,THREAD
_Hide:Relate:Detail  &Hide:Relate:Detail,AUTO,THREAD
_Hide:Access:Products &Hide:Access:Products,AUTO,THREAD
_Hide:Relate:Products &Hide:Relate:Products,AUTO,THREAD
_Hide:Access:Phones  &Hide:Access:Phones,AUTO,THREAD
_Hide:Relate:Phones  &Hide:Relate:Phones,AUTO,THREAD


Allfiles_BC0:DctInit PROCEDURE
  CODE
  _Hide:Access:Customer &= NEW(Hide:Access:Customer)
  _Hide:Relate:Customer &= NEW(Hide:Relate:Customer)
  _Hide:Access:Orders &= NEW(Hide:Access:Orders)
  _Hide:Relate:Orders &= NEW(Hide:Relate:Orders)
  _Hide:Access:Detail &= NEW(Hide:Access:Detail)
  _Hide:Relate:Detail &= NEW(Hide:Relate:Detail)
  _Hide:Access:Products &= NEW(Hide:Access:Products)
  _Hide:Relate:Products &= NEW(Hide:Relate:Products)
  _Hide:Access:Phones &= NEW(Hide:Access:Phones)
  _Hide:Relate:Phones &= NEW(Hide:Relate:Phones)
  Relate:Customer &= _Hide:Relate:Customer
  Relate:Orders &= _Hide:Relate:Orders
  Relate:Detail &= _Hide:Relate:Detail
  Relate:Products &= _Hide:Relate:Products
  Relate:Phones &= _Hide:Relate:Phones


Allfiles_BC0:FilesInit PROCEDURE
  CODE
  _Hide:Relate:Customer.Init
  _Hide:Relate:Orders.Init
  _Hide:Relate:Detail.Init
  _Hide:Relate:Products.Init
  _Hide:Relate:Phones.Init


Allfiles_BC0:DctKill PROCEDURE
  CODE
  _Hide:Relate:Customer.Kill
  DISPOSE(_Hide:Relate:Customer)
  _Hide:Relate:Orders.Kill
  DISPOSE(_Hide:Relate:Orders)
  _Hide:Relate:Detail.Kill
  DISPOSE(_Hide:Relate:Detail)
  _Hide:Relate:Products.Kill
  DISPOSE(_Hide:Relate:Products)
  _Hide:Relate:Phones.Kill
  DISPOSE(_Hide:Relate:Phones)


Hide:Relate:Customer.Init PROCEDURE
  CODE
  _Hide:Access:Customer.Init
  SELF.Init(Access:Customer,1)


Hide:Access:Customer.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= CUS:Record
  SELF.FileNameValue = 'Customer'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Customer
  PARENT.Init
  Access:Customer &= SELF


Hide:Access:Customer.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Customer &= NULL                                  ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Customer.PrimeFields PROCEDURE

  CODE
  CUS:State = 'FL'                                         ! Assign initial field value
  PARENT.PrimeFields


Hide:Access:Customer.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Customer,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(CUS:KeyCustNumber,'CUS:KeyCustNumber',1)
    SELF.AddKey(CUS:KeyCompany,'CUS:KeyCompany',0)
    SELF.AddKey(CUS:KeyZipCode,'CUS:KeyZipCode',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Customer.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Orders,RI:CASCADE,RI:RESTRICT,ORD:KeyCustNumber)
  SELF.AddRelationLink(CUS:CustNumber,ORD:CustNumber)

  SELF.AddRelation(Relate:Phones,RI:CASCADE,RI:RESTRICT,PHO:KeyCustNumber)
  SELF.AddRelationLink(CUS:CustNumber,PHO:CustNumber)


Hide:Relate:Customer.Kill PROCEDURE

  CODE
  _Hide:Access:Customer.Kill                               ! Kill the file manager
  PARENT.Kill
  Relate:Customer &= NULL                                  ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Customer)                           ! destroy the file manager


Hide:Relate:Orders.Init PROCEDURE
  CODE
  _Hide:Access:Orders.Init
  SELF.Init(Access:Orders,1)


Hide:Access:Orders.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= ORD:Record
  SELF.FileNameValue = 'Orders'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Orders
  PARENT.Init
  Access:Orders &= SELF


Hide:Access:Orders.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Orders &= NULL                                    ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Orders.PrimeFields PROCEDURE

  CODE
  ORD:OrderDate = TODAY()                                  ! Assign initial field value
  PARENT.PrimeFields


Hide:Access:Orders.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Orders,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(ORD:KeyOrderNumber,'ORD:KeyOrderNumber',1)
    SELF.AddKey(ORD:KeyCustNumber,'ORD:KeyCustNumber',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Access:Orders.ValidateFieldServer PROCEDURE(UNSIGNED Id,BYTE HandleErrors)

ReturnValue          BYTE,AUTO

Save:Customer1     USHORT,AUTO
  CODE
  ReturnValue = PARENT.ValidateFieldServer(Id,HandleErrors)
  CASE Id
  OF 1
    GlobalErrors.SetField('ORD:CustNumber')
    Save:Customer1 = Access:Customer.SaveFile()
    CUS:CustNumber = ORD:CustNumber
    ReturnValue = Access:Customer.TryFetch(CUS:KeyCustNumber)
    IF ReturnValue <> Level:Benign
      IF HandleErrors                                      ! Display message if handling errors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldNotInFile,'Customer')
      END
    END
    Access:Customer.RestoreFile(Save:Customer1)
  END
  RETURN ReturnValue


Hide:Relate:Orders.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Detail,RI:CASCADE,RI:RESTRICT,DTL:KeyOrderNumber)
  SELF.AddRelationLink(ORD:OrderNumber,DTL:OrderNumber)

  SELF.AddRelation(Relate:Customer)


Hide:Relate:Orders.Kill PROCEDURE

  CODE
  _Hide:Access:Orders.Kill                                 ! Kill the file manager
  PARENT.Kill
  Relate:Orders &= NULL                                    ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Orders)                             ! destroy the file manager


Hide:Relate:Detail.Init PROCEDURE
  CODE
  _Hide:Access:Detail.Init
  SELF.Init(Access:Detail,1)


Hide:Access:Detail.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= DTL:Record
  SELF.FileNameValue = 'Detail'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Detail
  PARENT.Init
  Access:Detail &= SELF


Hide:Access:Detail.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Detail &= NULL                                    ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Detail.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Detail,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(DTL:KeyProdNumber,'DTL:KeyProdNumber',0)
    SELF.AddKey(DTL:KeyOrderNumber,'DTL:KeyOrderNumber',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Access:Detail.ValidateFieldServer PROCEDURE(UNSIGNED Id,BYTE HandleErrors)

ReturnValue          BYTE,AUTO

Save:Products2     USHORT,AUTO
  CODE
  ReturnValue = PARENT.ValidateFieldServer(Id,HandleErrors)
  CASE Id
  OF 2
    GlobalErrors.SetField('DTL:ProdNumber')
    Save:Products2 = Access:Products.SaveFile()
    PRD:ProdNumber = DTL:ProdNumber
    ReturnValue = Access:Products.TryFetch(PRD:KeyProdNumber)
    IF ReturnValue <> Level:Benign
      IF HandleErrors                                      ! Display message if handling errors
        ReturnValue = GlobalErrors.ThrowMessage(Msg:FieldNotInFile,'Products')
      END
    END
    Access:Products.RestoreFile(Save:Products2)
  END
  RETURN ReturnValue


Hide:Relate:Detail.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Orders)

  SELF.AddRelation(Relate:Products)


Hide:Relate:Detail.Kill PROCEDURE

  CODE
  _Hide:Access:Detail.Kill                                 ! Kill the file manager
  PARENT.Kill
  Relate:Detail &= NULL                                    ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Detail)                             ! destroy the file manager


Hide:Relate:Products.Init PROCEDURE
  CODE
  _Hide:Access:Products.Init
  SELF.Init(Access:Products,1)


Hide:Access:Products.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= PRD:Record
  SELF.FileNameValue = 'Products'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Products
  PARENT.Init
  Access:Products &= SELF


Hide:Access:Products.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Products &= NULL                                  ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Products.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Products,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(PRD:KeyProdNumber,'PRD:KeyProdNumber',1)
    SELF.AddKey(PRD:KeyProdDesc,'PRD:KeyProdDesc',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Products.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Detail,RI:RESTRICT,RI:RESTRICT,DTL:KeyProdNumber)
  SELF.AddRelationLink(PRD:ProdNumber,DTL:ProdNumber)


Hide:Relate:Products.Kill PROCEDURE

  CODE
  _Hide:Access:Products.Kill                               ! Kill the file manager
  PARENT.Kill
  Relate:Products &= NULL                                  ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Products)                           ! destroy the file manager


Hide:Relate:Phones.Init PROCEDURE
  CODE
  _Hide:Access:Phones.Init
  SELF.Init(Access:Phones,1)


Hide:Access:Phones.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= PHO:Record
  SELF.FileNameValue = 'Phones'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Phones
  PARENT.Init
  Access:Phones &= SELF


Hide:Access:Phones.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Phones &= NULL                                    ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Phones.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Phones,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(PHO:KeyCustNumber,'PHO:KeyCustNumber',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Phones.DeferedAddRelations PROCEDURE

  CODE
  DO AddRelations_1
  
  PARENT.DeferedAddRelations

AddRelations_1 ROUTINE
  SELF.AddRelation(Relate:Customer)


Hide:Relate:Phones.Kill PROCEDURE

  CODE
  _Hide:Access:Phones.Kill                                 ! Kill the file manager
  PARENT.Kill
  Relate:Phones &= NULL                                    ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Phones)                             ! destroy the file manager

