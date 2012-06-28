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

  INCLUDE('UltimateSQLScripts.INC')

  MAP
  END

!----------------------------------------
UltimateSQLScripts.Construct    PROCEDURE()
!----------------------------------------
  CODE


  RETURN

!---------------------------------------
UltimateSQLScripts.Destruct    PROCEDURE()
!---------------------------------------
  CODE


  RETURN


!-----------------------------------
UltimateSQLScripts.Init    PROCEDURE()
!-----------------------------------

  CODE

  SELF.InDebug = FALSE

  RETURN

!-----------------------------------
UltimateSQLScripts.Kill    PROCEDURE()
!-----------------------------------

  CODE

  RETURN


!-----------------------------------------
UltimateSQLScripts.InsertExtendedProperty       PROCEDURE() !,STRING 

    CODE

         
        RETURN 'DECLARE @Object_Id          INTEGER, <13,10>' & |
            '        @Object_Name        SYSNAME, <13,10>' & |
            '        @Property_Name      SYSNAME, <13,10>' & |
            '        @Property_Value     SQL_VARIANT, <13,10>' & |
            '        @Object_Type        SYSNAME, <13,10>' & |
            '        @Part1              SYSNAME, <13,10>' & |
            '        @Part2              SYSNAME, <13,10>' & |
            '        @Part3              SYSNAME, <13,10>' & |
            '        @Part4              SYSNAME, <13,10>' & |
            '        @Database_Name      SYSNAME, <13,10>' & |
            '        @Schema_Name        SYSNAME, <13,10>' & |
            '        @Schema_Object_Name SYSNAME, <13,10>' & |
            '        @Column_Name        SYSNAME, <13,10>' & |
            '        @ERR_MSG            VARCHAR(8000), <13,10>' & |
            '        @ERR_STA            TINYINT, <13,10>' & |
            '        @ERR_SEV            SMALLINT; <13,10>' & |
            '                                      <13,10>' & |
            'SET @Object_Name = <39>[OBJECTNAME]<39> <13,10>' & |
            'SET @Property_Name = <39>[PROPERTYNAME]<39> <13,10>' & |
            'SET @Property_Value = <39>[PROPERTYVALUE]<39> <13,10>' & |
            '                                <13,10>' & |
            'SELECT @Part1 = parsename(@Object_Name, 1) <13,10>' & |
            '	 , @Part2 = parsename(@Object_Name, 2)  <13,10>' & |
            '	 , @Part3 = parsename(@Object_Name, 3)  <13,10>' & |
            '	 , @Part4 = parsename(@Object_Name, 4)  <13,10>' & |
            '	 , @Property_Name = coalesce(@Property_Name, N<39>MS_Description<39>); <13,10>' & |
            ' <13,10>' & |
            'IF @Part4 IS NOT NULL <13,10>' & |
            'BEGIN <13,10>' & |
            '	RAISERROR (N<39>Cannot specify 4-part names in PropInsert.<39>, 18, 127) WITH NOWAIT, SETERROR; <13,10>' & |
            '	IF xact_state() <> 0 <13,10>' & |
            '		ROLLBACK TRANSACTION; <13,10>' & |
            '	RETURN; <13,10>' & |
            'END; <13,10>' & |
            ' <13,10>' & |
            'IF @Part1 IS NULL AND @Part2 IS NULL AND @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
            'BEGIN -- @Object_Type is DATABASE <13,10>' & |
            '	BEGIN TRY <13,10>' & |
            '		EXECUTE sys.sp_addextendedproperty @name = @Property_Name, @value = @Property_Value; <13,10>' & |
            '	END TRY <13,10>' & |
            '	BEGIN CATCH <13,10>' & |
            '		SET @ERR_SEV = error_severity(); <13,10>' & |
            '		SET @ERR_STA = error_state(); <13,10>' & |
            '		SET @ERR_MSG = error_message() + <39> Error occurred while adding property to the current database.<39>; <13,10>' & |
            '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
            '		IF xact_state() <> 0 <13,10>' & |
            '			ROLLBACK TRANSACTION; <13,10>' & |
            '		RETURN; <13,10>' & |
            '	END CATCH <13,10>' & |
            'END <13,10>' & |
            'ELSE <13,10>' & |
            'IF @Part2 IS NULL AND @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
            'BEGIN <13,10>' & |
            '	SET @Object_Type = N<39>SCHEMA<39>; <13,10>' & |
            '	SELECT @Schema_Name = @Part1; <13,10>' & |
            '	BEGIN TRY <13,10>' & |
            '		EXECUTE sys.sp_addextendedproperty @name = @Property_Name, @value = @Property_Value, @level0type = @Object_Type, @level0name = @Schema_Name; <13,10>' & |
            '	END TRY <13,10>' & |
            '	BEGIN CATCH <13,10>' & |
            '		SET @ERR_SEV = error_severity(); <13,10>' & |
            '		SET @ERR_STA = error_state(); <13,10>' & |
            '		SET @ERR_MSG = error_message() + <39> Error occurred while adding property to the [<39> + @Schema_Name + <39>] schema.<39>; <13,10>' & |
            '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
            '		IF xact_state() <> 0 <13,10>' & |
            '			ROLLBACK TRANSACTION; <13,10>' & |
            '		RETURN; <13,10>' & |
            '	END CATCH <13,10>' & |
            'END <13,10>' & |
            'ELSE <13,10>' & |
            'IF @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
            'BEGIN <13,10>' & |
            '	SET @Object_Id = object_id(@Object_Name); <13,10>' & |
            '	SELECT @Object_Type = CASE <13,10>' & |
            '							  WHEN type IN (N<39>U<39>, N<39>IT<39>, N<39>S<39>) THEN <13,10>' & |
            '								  N<39>TABLE<39> <13,10>' & |
            '							  WHEN type = N<39>V<39> THEN <13,10>' & |
            '								  N<39>VIEW<39> <13,10>' & |
            '							  WHEN type IN (N<39>P<39>, N<39>X<39>, N<39>PC<39>) THEN <13,10>' & |
            '								  N<39>PROCEDURE<39> <13,10>' & |
            '							  WHEN type = N<39>AF<39> THEN <13,10>' & |
            '								  N<39>AGGREGATE<39> <13,10>' & |
            '							  WHEN type IN (N<39>FT<39>, N<39>FN<39>, N<39>IF<39>, N<39>TF<39>) THEN <13,10>' & |
            '								  N<39>FUNCTION<39> <13,10>' & |
            '							  WHEN type = N<39>SN<39> THEN <13,10>' & |
            '								  N<39>SYNONYM<39> <13,10>' & |
            '							  WHEN type = N<39>SQ<39> THEN <13,10>' & |
            '								  N<39>QUEUE<39> <13,10>' & |
            '						  END <13,10>' & |
            '		 , @Schema_Object_Name = @Part1 <13,10>' & |
            '		 , @Schema_Name = @Part2 <13,10>' & |
            '	FROM <13,10>' & |
            '		sys.objects <13,10>' & |
            '	WHERE <13,10>' & |
            '		object_id = @Object_Id; <13,10>' & |
            '	BEGIN TRY <13,10>' & |
            '		EXECUTE sys.sp_addextendedproperty @name = @Property_Name, @value = @Property_Value, @level0type = N<39>SCHEMA<39>, @level0name = @Schema_Name, @level1type = @Object_Type, @level1name = @Schema_Object_Name; <13,10>' & |
            '	END TRY <13,10>' & |
            '	BEGIN CATCH <13,10>' & |
            '		SET @ERR_SEV = error_severity(); <13,10>' & |
            '		SET @ERR_STA = error_state(); <13,10>' & |
            '		SET @ERR_MSG = error_message() + <39> Error occurred while adding property to the [<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + <39>] <39> + coalesce(@Object_Type, <39><39>) + <39>.<39>; <13,10>' & |
            '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
            '		IF xact_state() <> 0 <13,10>' & |
            '			ROLLBACK TRANSACTION; <13,10>' & |
            '		RETURN; <13,10>' & |
            '	END CATCH <13,10>' & |
            'END <13,10>' & |
            'ELSE <13,10>' & |
            'IF @Part4 IS NULL <13,10>' & |
            'BEGIN <13,10>' & |
            '	SELECT @Column_Name = @Part1 <13,10>' & |
            '		 , @Schema_Object_Name = @Part2 <13,10>' & |
            '		 , @Schema_Name = @Part3; <13,10>' & |
            ' <13,10>' & |
            '	SET @Object_Id = object_id(N<39>[<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + N<39>]<39>); <13,10>' & |
            '	SELECT @Object_Type = CASE <13,10>' & |
            '							  WHEN type IN (N<39>U<39>, N<39>IT<39>, N<39>S<39>) THEN <13,10>' & |
            '								  N<39>TABLE<39> <13,10>' & |
            '							  WHEN type = N<39>V<39> THEN <13,10>' & |
            '								  N<39>VIEW<39> <13,10>' & |
            '							  WHEN type IN (N<39>P<39>, N<39>X<39>, N<39>PC<39>) THEN <13,10>' & |
            '								  N<39>PROCEDURE<39> <13,10>' & |
            '							  WHEN type = N<39>AF<39> THEN <13,10>' & |
            '								  N<39>AGGREGATE<39> <13,10>' & |
            '							  WHEN type IN (N<39>FT<39>, N<39>FN<39>, N<39>IF<39>, N<39>TF<39>) THEN <13,10>' & |
            '								  N<39>FUNCTION<39> <13,10>' & |
            '							  WHEN type = N<39>SN<39> THEN <13,10>' & |
            '								  N<39>SYNONYM<39> <13,10>' & |
            '							  WHEN type = N<39>SQ<39> THEN <13,10>' & |
            '								  N<39>QUEUE<39> <13,10>' & |
            '						  END <13,10>' & |
            '	FROM <13,10>' & |
            '		sys.objects <13,10>' & |
            '	WHERE <13,10>' & |
            '		object_id = @Object_Id; <13,10>' & |
            ' <13,10>' & |
            '	BEGIN TRY <13,10>' & |
            '		EXECUTE sys.sp_addextendedproperty @name = @Property_Name, @value = @Property_Value, @level0type = N<39>SCHEMA<39>, @level0name = @Schema_Name, @level1type = @Object_Type, @level1name = @Schema_Object_Name, @level2type = N<39>COLUMN<39>, @level2name = @Column_Name; <13,10>' & |
            '	END TRY <13,10>' & |
            '	BEGIN CATCH <13,10>' & |
            '		SET @ERR_SEV = error_severity(); <13,10>' & |
            '		SET @ERR_STA = error_state(); <13,10>' & |
            '		SET @ERR_MSG = error_message() + <39> Error occurred while adding property to the [<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + <39>].[<39> + @Column_Name + <39>] column.<39>; <13,10>' & |
            '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
            '		IF xact_state() <> 0 <13,10>' & |
            '			ROLLBACK TRANSACTION; <13,10>' & |
            '		RETURN; <13,10>' & |
            '	END CATCH <13,10>' & |
            'END <13,10>' 
        
        
!-----------------------------------------
UltimateSQLScripts.UpdateExtendedProperty       PROCEDURE()  !,STRING

    CODE

        RETURN 'DECLARE @Object_Id          INTEGER, <13,10>' & |
        '        @Object_Type        SYSNAME, <13,10>' & |
        '        @Object_Name        SYSNAME, <13,10>' & |
        '        @Property_Name      SYSNAME, <13,10>' & |
        '        @Property_Value     SQL_VARIANT, <13,10>' & |
        '        @Part1              SYSNAME, <13,10>' & |
        '        @Part2              SYSNAME, <13,10>' & |
        '        @Part3              SYSNAME, <13,10>' & |
        '        @Part4              SYSNAME, <13,10>' & |
        '        @Database_Name      SYSNAME, <13,10>' & |
        '        @Schema_Name        SYSNAME, <13,10>' & |
        '        @Schema_Object_Name SYSNAME, <13,10>' & |
        '        @Column_Name        SYSNAME, <13,10>' & |
        '        @ERR_MSG            VARCHAR(8000), <13,10>' & |
        '        @ERR_STA            TINYINT, <13,10>' & |
        '        @ERR_SEV            SMALLINT; <13,10>' & |
        ' <13,10>' & |
        'SET @Object_Name = <39>[OBJECTNAME]<39> <13,10>' & |
        'SET @Property_Name = <39>[PROPERTYNAME]<39> <13,10>' & |
        'SET @Property_Value = <39>[PROPERTYVALUE]<39> <13,10>' & |
        ' <13,10>' & |
        'SELECT @Part1 = parsename(@Object_Name, 1) <13,10>' & |
        '	 , @Part2 = parsename(@Object_Name, 2) <13,10>' & |
        '	 , @Part3 = parsename(@Object_Name, 3) <13,10>' & |
        '	 , @Part4 = parsename(@Object_Name, 4) <13,10>' & |
        '	 , @Property_Name = coalesce(@Property_Name, N<39>MS_Description<39>); <13,10>' & |
        ' <13,10>' & |
        'IF @Part4 IS NOT NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	RAISERROR (N<39>Cannot specify 4-part names in PropUpdate.<39>, 18, 127) WITH NOWAIT, SETERROR; <13,10>' & |
        '	IF xact_state() <> 0 <13,10>' & |
        '		ROLLBACK TRANSACTION; <13,10>' & |
        '	RETURN; <13,10>' & |
        'END; <13,10>' & |
        ' <13,10>' & |
        'IF @Part1 IS NULL AND @Part2 IS NULL AND @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
        'BEGIN -- @Object_Type is DATABASE <13,10>' & |
        '	BEGIN TRY <13,10>' & |
        '		EXECUTE sys.sp_updateextendedproperty @name = @Property_Name, @value = @Property_Value; <13,10>' & |
        '	END TRY <13,10>' & |
        '	BEGIN CATCH <13,10>' & |
        '		SET @ERR_SEV = error_severity(); <13,10>' & |
        '		SET @ERR_STA = error_state(); <13,10>' & |
        '		SET @ERR_MSG = error_message() + <39> Error occurred while updating property on the current database.<39>; <13,10>' & |
        '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
        '		IF xact_state() <> 0 <13,10>' & |
        '			ROLLBACK TRANSACTION; <13,10>' & |
        '		RETURN; <13,10>' & |
        '	END CATCH <13,10>' & |
        'END <13,10>' & |
        'ELSE <13,10>' & |
        'IF @Part2 IS NULL AND @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	SET @Object_Type = N<39>SCHEMA<39>; <13,10>' & |
        '	SELECT @Schema_Name = @Part1; <13,10>' & |
        '	BEGIN TRY <13,10>' & |
        '		EXECUTE sys.sp_updateextendedproperty @name = @Property_Name, @value = @Property_Value, @level0type = @Object_Type, @level0name = @Schema_Name; <13,10>' & |
        '	END TRY <13,10>' & |
        '	BEGIN CATCH <13,10>' & |
        '		SET @ERR_SEV = error_severity(); <13,10>' & |
        '		SET @ERR_STA = error_state(); <13,10>' & |
        '		SET @ERR_MSG = error_message() + <39> Error occurred while updating property on the [<39> + @Schema_Name + <39>] schema.<39>; <13,10>' & |
        '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
        '		IF xact_state() <> 0 <13,10>' & |
        '			ROLLBACK TRANSACTION; <13,10>' & |
        '		RETURN; <13,10>' & |
        '	END CATCH <13,10>' & |
        'END <13,10>' & |
        'ELSE <13,10>' & |
        'IF @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	SET @Object_Id = object_id(@Object_Name); <13,10>' & |
        '	SELECT @Object_Type = CASE <13,10>' & |
        '							  WHEN type IN (N<39>U<39>, N<39>IT<39>, N<39>S<39>) THEN <13,10>' & |
        '								  N<39>TABLE<39> <13,10>' & |
        '							  WHEN type = N<39>V<39> THEN <13,10>' & |
        '								  N<39>VIEW<39> <13,10>' & |
        '							  WHEN type IN (N<39>P<39>, N<39>X<39>, N<39>PC<39>) THEN <13,10>' & |
        '								  N<39>PROCEDURE<39> <13,10>' & |
        '							  WHEN type = N<39>AF<39> THEN <13,10>' & |
        '								  N<39>AGGREGATE<39> <13,10>' & |
        '							  WHEN type IN (N<39>FT<39>, N<39>FN<39>, N<39>IF<39>, N<39>TF<39>) THEN <13,10>' & |
        '								  N<39>FUNCTION<39> <13,10>' & |
        '							  WHEN type = N<39>SN<39> THEN <13,10>' & |
        '								  N<39>SYNONYM<39> <13,10>' & |
        '							  WHEN type = N<39>SQ<39> THEN <13,10>' & |
        '								  N<39>QUEUE<39> <13,10>' & |
        '						  END <13,10>' & |
        '		 , @Schema_Object_Name = @Part1 <13,10>' & |
        '		 , @Schema_Name = @Part2 <13,10>' & |
        '	FROM <13,10>' & |
        '		sys.objects <13,10>' & |
        '	WHERE <13,10>' & |
        '		object_id = @Object_Id; <13,10>' & |
        '	BEGIN TRY <13,10>' & |
        '		EXECUTE sys.sp_updateextendedproperty @name = @Property_Name, @value = @Property_Value, @level0type = N<39>SCHEMA<39>, @level0name = @Schema_Name, @level1type = @Object_Type, @level1name = @Schema_Object_Name; <13,10>' & |
        '	END TRY <13,10>' & |
        '	BEGIN CATCH <13,10>' & |
        '		SET @ERR_SEV = error_severity(); <13,10>' & |
        '		SET @ERR_STA = error_state(); <13,10>' & |
        '		SET @ERR_MSG = error_message() + <39> Error occurred while updating property on the [<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + <39>] <39> + coalesce(@Object_Type, <39><39>) + <39>.<39>; <13,10>' & |
        '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
        '		IF xact_state() <> 0 <13,10>' & |
        '			ROLLBACK TRANSACTION; <13,10>' & |
        '		RETURN; <13,10>' & |
        '	END CATCH <13,10>' & |
        'END <13,10>' & |
        'ELSE <13,10>' & |
        'IF @Part4 IS NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	SELECT @Column_Name = @Part1 <13,10>' & |
        '		 , @Schema_Object_Name = @Part2 <13,10>' & |
        '		 , @Schema_Name = @Part3; <13,10>' & |
        ' <13,10>' & |
        '	BEGIN TRY <13,10>' & |
        '		SET @Object_Id = object_id(N<39>[<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + N<39>]<39>); <13,10>' & |
        '		SELECT @Object_Type = CASE <13,10>' & |
        '								  WHEN type IN (N<39>U<39>, N<39>IT<39>, N<39>S<39>) THEN <13,10>' & |
        '									  N<39>TABLE<39> <13,10>' & |
        '								  WHEN type = N<39>V<39> THEN <13,10>' & |
        '									  N<39>VIEW<39> <13,10>' & |
        '								  WHEN type IN (N<39>P<39>, N<39>X<39>, N<39>PC<39>) THEN <13,10>' & |
        '									  N<39>PROCEDURE<39> <13,10>' & |
        '								  WHEN type = N<39>AF<39> THEN <13,10>' & |
        '									  N<39>AGGREGATE<39> <13,10>' & |
        '								  WHEN type IN (N<39>FT<39>, N<39>FN<39>, N<39>IF<39>, N<39>TF<39>) THEN <13,10>' & |
        '									  N<39>FUNCTION<39> <13,10>' & |
        '								  WHEN type = N<39>SN<39> THEN <13,10>' & |
        '									  N<39>SYNONYM<39> <13,10>' & |
        '								  WHEN type = N<39>SQ<39> THEN <13,10>' & |
        '									  N<39>QUEUE<39> <13,10>' & |
        '							  END <13,10>' & |
        '		FROM <13,10>' & |
        '			sys.objects <13,10>' & |
        '		WHERE <13,10>' & |
        '			object_id = @Object_Id; <13,10>' & |
        ' <13,10>' & |
        '		EXECUTE sys.sp_updateextendedproperty @name = @Property_Name, @value = @Property_Value, @level0type = N<39>SCHEMA<39>, @level0name = @Schema_Name, @level1type = @Object_Type, @level1name = @Schema_Object_Name, @level2type = N<39>COLUMN<39>, @level2name = @Column_Name; <13,10>' & |
        '	END TRY <13,10>' & |
        '	BEGIN CATCH <13,10>' & |
        '		SET @ERR_SEV = error_severity(); <13,10>' & |
        '		SET @ERR_STA = error_state(); <13,10>' & |
        '		SET @ERR_MSG = error_message() + <39> Error occurred while updating property on the [<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + <39>].[<39> + @Column_Name + <39>] column.<39>; <13,10>' & |
        '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
        '		IF xact_state() <> 0 <13,10>' & |
        '			ROLLBACK TRANSACTION; <13,10>' & |
        '		RETURN; <13,10>' & |
        '	END CATCH <13,10>' & |
        'END'

!-----------------------------------------
UltimateSQLScripts.RemoveExtendedProperty       PROCEDURE()  !,STRING    

    CODE

        RETURN 'DECLARE @Object_Id          INTEGER, <13,10>' & |
        '        @Object_Type        SYSNAME, <13,10>' & |
        '        @Object_Name        SYSNAME, <13,10>' & |
        '        @Property_Name      SYSNAME, <13,10>' & |
        '        @Part1              SYSNAME, <13,10>' & |
        '        @Part2              SYSNAME, <13,10>' & |
        '        @Part3              SYSNAME, <13,10>' & |
        '        @Part4              SYSNAME, <13,10>' & |
        '        @Database_Name      SYSNAME, <13,10>' & |
        '        @Schema_Name        SYSNAME, <13,10>' & |
        '        @Schema_Object_Name SYSNAME, <13,10>' & |
        '        @Column_Name        SYSNAME, <13,10>' & |
        '        @ERR_MSG            VARCHAR(8000), <13,10>' & |
        '        @ERR_STA            TINYINT, <13,10>' & |
        '        @ERR_SEV            SMALLINT; <13,10>' & |
        ' <13,10>' & |
        'SET @Object_Name = <39>[OBJECTNAME]<39> <13,10>' & |
        'SET @Property_Name = <39>[PROPERTYNAME]<39> <13,10>' & |
        ' <13,10>' & |
        'SELECT @Part1 = parsename(@Object_Name, 1) <13,10>' & |
        '	 , @Part2 = parsename(@Object_Name, 2) <13,10>' & |
        '	 , @Part3 = parsename(@Object_Name, 3) <13,10>' & |
        '	 , @Part4 = parsename(@Object_Name, 4) <13,10>' & |
        '	 , @Property_Name = coalesce(@Property_Name, N<39>MS_Description<39>); <13,10>' & |
        ' <13,10>' & |
        'IF @Part4 IS NOT NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	RAISERROR (N<39>Cannot specify 4-part names in PropDelete.<39>, 18, 127) WITH NOWAIT, SETERROR; <13,10>' & |
        '	IF xact_state() <> 0 <13,10>' & |
        '		ROLLBACK TRANSACTION; <13,10>' & |
        '	RETURN; <13,10>' & |
        'END; <13,10>' & |
        ' <13,10>' & |
        'IF @Part1 IS NULL AND @Part2 IS NULL AND @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
        'BEGIN -- @Object_Type is DATABASE <13,10>' & |
        '	BEGIN TRY <13,10>' & |
        '		EXECUTE sys.sp_dropextendedproperty @name = @Property_Name; <13,10>' & |
        '	END TRY <13,10>' & |
        '	BEGIN CATCH <13,10>' & |
        '		SET @ERR_SEV = error_severity(); <13,10>' & |
        '		SET @ERR_STA = error_state(); <13,10>' & |
        '		SET @ERR_MSG = error_message() + <39> Error occurred while dropping property from the current database.<39>; <13,10>' & |
        '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
        '		IF xact_state() <> 0 <13,10>' & |
        '			ROLLBACK TRANSACTION; <13,10>' & |
        '		RETURN; <13,10>' & |
        '	END CATCH <13,10>' & |
        'END <13,10>' & |
        'ELSE <13,10>' & |
        'IF @Part2 IS NULL AND @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	SET @Object_Type = N<39>SCHEMA<39>; <13,10>' & |
        '	SELECT @Schema_Name = @Part1; <13,10>' & |
        '	BEGIN TRY <13,10>' & |
        '		EXECUTE sys.sp_dropextendedproperty @name = @Property_Name, @level0type = @Object_Type, @level0name = @Schema_Name; <13,10>' & |
        '	END TRY <13,10>' & |
        '	BEGIN CATCH <13,10>' & |
        '		SET @ERR_SEV = error_severity(); <13,10>' & |
        '		SET @ERR_STA = error_state(); <13,10>' & |
        '		SET @ERR_MSG = error_message() + <39> Error occurred while dropping property from the [<39> + @Schema_Name + <39>] schema.<39>; <13,10>' & |
        '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
        '		IF xact_state() <> 0 <13,10>' & |
        '			ROLLBACK TRANSACTION; <13,10>' & |
        '		RETURN; <13,10>' & |
        '	END CATCH <13,10>' & |
        'END <13,10>' & |
        'ELSE <13,10>' & |
        'IF @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	SET @Object_Id = object_id(@Object_Name); <13,10>' & |
        '	SELECT @Object_Type = CASE <13,10>' & |
        '							  WHEN type IN (N<39>U<39>, N<39>IT<39>, N<39>S<39>) THEN <13,10>' & |
        '								  N<39>TABLE<39> <13,10>' & |
        '							  WHEN type = N<39>V<39> THEN <13,10>' & |
        '								  N<39>VIEW<39> <13,10>' & |
        '							  WHEN type IN (N<39>P<39>, N<39>X<39>, N<39>PC<39>) THEN <13,10>' & |
        '								  N<39>PROCEDURE<39> <13,10>' & |
        '							  WHEN type = N<39>AF<39> THEN <13,10>' & |
        '								  N<39>AGGREGATE<39> <13,10>' & |
        '							  WHEN type IN (N<39>FT<39>, N<39>FN<39>, N<39>IF<39>, N<39>TF<39>) THEN <13,10>' & |
        '								  N<39>FUNCTION<39> <13,10>' & |
        '							  WHEN type = N<39>SN<39> THEN <13,10>' & |
        '								  N<39>SYNONYM<39> <13,10>' & |
        '							  WHEN type = N<39>SQ<39> THEN <13,10>' & |
        '								  N<39>QUEUE<39> <13,10>' & |
        '						  END <13,10>' & |
        '		 , @Schema_Object_Name = @Part1 <13,10>' & |
        '		 , @Schema_Name = @Part2 <13,10>' & |
        '	FROM <13,10>' & |
        '		sys.objects <13,10>' & |
        '	WHERE <13,10>' & |
        '		object_id = @Object_Id; <13,10>' & |
        '	BEGIN TRY <13,10>' & |
        '		EXECUTE sys.sp_dropextendedproperty @name = @Property_Name, @level0type = N<39>SCHEMA<39>, @level0name = @Schema_Name, @level1type = @Object_Type, @level1name = @Schema_Object_Name; <13,10>' & |
        '	END TRY <13,10>' & |
        '	BEGIN CATCH <13,10>' & |
        '		SET @ERR_SEV = error_severity(); <13,10>' & |
        '		SET @ERR_STA = error_state(); <13,10>' & |
        '		SET @ERR_MSG = error_message() + <39> Error occurred while dropping property from the [<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + <39>] <39> + coalesce(@Object_Type, <39><39>) + <39>.<39>; <13,10>' & |
        '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
        '		IF xact_state() <> 0 <13,10>' & |
        '			ROLLBACK TRANSACTION; <13,10>' & |
        '		RETURN; <13,10>' & |
        '	END CATCH <13,10>' & |
        'END <13,10>' & |
        'ELSE <13,10>' & |
        'IF @Part4 IS NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	SELECT @Column_Name = @Part1 <13,10>' & |
        '		 , @Schema_Object_Name = @Part2 <13,10>' & |
        '		 , @Schema_Name = @Part3; <13,10>' & |
        ' <13,10>' & |
        '	SET @Object_Id = object_id(N<39>[<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + N<39>]<39>); <13,10>' & |
        '	SELECT @Object_Type = CASE <13,10>' & |
        '							  WHEN type IN (N<39>U<39>, N<39>IT<39>, N<39>S<39>) THEN <13,10>' & |
        '								  N<39>TABLE<39> <13,10>' & |
        '							  WHEN type = N<39>V<39> THEN <13,10>' & |
        '								  N<39>VIEW<39> <13,10>' & |
        '							  WHEN type IN (N<39>P<39>, N<39>X<39>, N<39>PC<39>) THEN <13,10>' & |
        '								  N<39>PROCEDURE<39> <13,10>' & |
        '							  WHEN type = N<39>AF<39> THEN <13,10>' & |
        '								  N<39>AGGREGATE<39> <13,10>' & |
        '							  WHEN type IN (N<39>FT<39>, N<39>FN<39>, N<39>IF<39>, N<39>TF<39>) THEN <13,10>' & |
        '								  N<39>FUNCTION<39> <13,10>' & |
        '							  WHEN type = N<39>SN<39> THEN <13,10>' & |
        '								  N<39>SYNONYM<39> <13,10>' & |
        '							  WHEN type = N<39>SQ<39> THEN <13,10>' & |
        '								  N<39>QUEUE<39> <13,10>' & |
        '						  END <13,10>' & |
        '	FROM <13,10>' & |
        '		sys.objects <13,10>' & |
        '	WHERE <13,10>' & |
        '		object_id = @Object_Id; <13,10>' & |
        ' <13,10>' & |
        '	BEGIN TRY <13,10>' & |
        '		EXECUTE sys.sp_dropextendedproperty @name = @Property_Name, @level0type = N<39>SCHEMA<39>, @level0name = @Schema_Name, @level1type = @Object_Type, @level1name = @Schema_Object_Name, @level2type = N<39>COLUMN<39>, @level2name = @Column_Name; <13,10>' & |
        '	END TRY <13,10>' & |
        '	BEGIN CATCH <13,10>' & |
        '		SET @ERR_SEV = error_severity(); <13,10>' & |
        '		SET @ERR_STA = error_state(); <13,10>' & |
        '		SET @ERR_MSG = error_message() + <39> Error occurred while dropping property from the [<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + <39>].[<39> + @Column_Name + <39>] column.<39>; <13,10>' & |
        '		RAISERROR (@ERR_MSG, @ERR_SEV, @ERR_STA); <13,10>' & |
        '		IF xact_state() <> 0 <13,10>' & |
        '			ROLLBACK TRANSACTION; <13,10>' & |
        '		RETURN; <13,10>' & |
        '	END CATCH <13,10>' & |
        'END'

 
UltimateSQLScripts.GetExtendedProperty          PROCEDURE()  !,STRING

    CODE
        
    RETURN 'DECLARE @Object_Id          INTEGER, <13,10>' & |
        '        @Object_Type        SYSNAME, <13,10>' & |
        '        @Object_Name        SYSNAME, <13,10>' & |
        '        @Property_Name      SYSNAME, <13,10>' & |
        '        @Part1              SYSNAME, <13,10>' & |
        '        @Part2              SYSNAME, <13,10>' & |
        '        @Part3              SYSNAME, <13,10>' & |
        '        @Part4              SYSNAME, <13,10>' & |
        '        @Database_Name      SYSNAME, <13,10>' & |
        '        @Schema_Name        SYSNAME, <13,10>' & |
        '        @Schema_Object_Name SYSNAME, <13,10>' & |
        '        @Column_Name        SYSNAME, <13,10>' & |
        '        @ERR_MSG            VARCHAR(8000), <13,10>' & |
        '        @ERR_STA            TINYINT, <13,10>' & |
        '        @ERR_SEV            SMALLINT; <13,10>' & |
        ' <13,10>' & |
        'SET @Object_Name = <39>[OBJECTNAME]<39> <13,10>' & |
        'SET @Property_Name = <39>[PROPERTYNAME]<39> <13,10>' & |
        ' <13,10>' & |
        'SELECT @Part1 = parsename(@Object_Name, 1) <13,10>' & |
        '	 , @Part2 = parsename(@Object_Name, 2) <13,10>' & |
        '	 , @Part3 = parsename(@Object_Name, 3) <13,10>' & |
        '	 , @Part4 = parsename(@Object_Name, 4); <13,10>' & |
        '	 <13,10>' & |
        ' <13,10>' & |
        'IF @Part1 IS NULL AND @Part2 IS NULL AND @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
        'BEGIN -- @Object_Type is DATABASE <13,10>' & |
        '	 <13,10>' & |
        '		SELECT [SELECTOPERATION] FROM fn_listextendedproperty (@Property_Name,NULL, NULL, NULL, NULL, NULL, NULL) <13,10>' & |
        '	 <13,10>' & |
        'END <13,10>' & |
        'ELSE <13,10>' & |
        'IF @Part2 IS NULL AND @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	SET @Object_Type = N<39>SCHEMA<39>; <13,10>' & |
        '	SELECT @Schema_Name = @Part1; <13,10>' & |
        '	    SELECT [SELECTOPERATION] FROM fn_listextendedproperty (@Property_Name,@Object_Type, @Schema_Name, NULL, NULL, NULL, NULL) <13,10>' & |
        'END <13,10>' & |
        'ELSE <13,10>' & |
        'IF @Part3 IS NULL AND @Part4 IS NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	SET @Object_Id = object_id(@Object_Name); <13,10>' & |
        '	SELECT @Object_Type = CASE <13,10>' & |
        '							  WHEN type IN (N<39>U<39>, N<39>IT<39>, N<39>S<39>) THEN <13,10>' & |
        '								  N<39>TABLE<39> <13,10>' & |
        '							  WHEN type = N<39>V<39> THEN <13,10>' & |
        '								  N<39>VIEW<39> <13,10>' & |
        '							  WHEN type IN (N<39>P<39>, N<39>X<39>, N<39>PC<39>) THEN <13,10>' & |
        '								  N<39>PROCEDURE<39> <13,10>' & |
        '							  WHEN type = N<39>AF<39> THEN <13,10>' & |
        '								  N<39>AGGREGATE<39> <13,10>' & |
        '							  WHEN type IN (N<39>FT<39>, N<39>FN<39>, N<39>IF<39>, N<39>TF<39>) THEN <13,10>' & |
        '								  N<39>FUNCTION<39> <13,10>' & |
        '							  WHEN type = N<39>SN<39> THEN <13,10>' & |
        '								  N<39>SYNONYM<39> <13,10>' & |
        '							  WHEN type = N<39>SQ<39> THEN <13,10>' & |
        '								  N<39>QUEUE<39> <13,10>' & |
        '						  END <13,10>' & |
        '		 , @Schema_Object_Name = @Part1 <13,10>' & |
        '		 , @Schema_Name = @Part2 <13,10>' & |
        '	FROM <13,10>' & |
        '		sys.objects <13,10>' & |
        '	WHERE <13,10>' & |
        '		object_id = @Object_Id;	 		 <13,10>' & |
        '		SELECT [SELECTOPERATION] FROM fn_listextendedproperty (@Property_Name,N<39>SCHEMA<39>, @Schema_Name, @Object_Type, @Schema_Object_Name, NULL, NULL) <13,10>' & |
        '	 <13,10>' & |
        'END <13,10>' & |
        'ELSE <13,10>' & |
        'IF @Part4 IS NULL <13,10>' & |
        'BEGIN <13,10>' & |
        '	SELECT @Column_Name = @Part1 <13,10>' & |
        '		 , @Schema_Object_Name = @Part2 <13,10>' & |
        '		 , @Schema_Name = @Part3; <13,10>' & |
        ' <13,10>' & |
        '	SET @Object_Id = object_id(N<39>[<39> + @Schema_Name + <39>].[<39> + @Schema_Object_Name + N<39>]<39>); <13,10>' & |
        '	SELECT @Object_Type = CASE <13,10>' & |
        '							  WHEN type IN (N<39>U<39>, N<39>IT<39>, N<39>S<39>) THEN <13,10>' & |
        '								  N<39>TABLE<39> <13,10>' & |
        '							  WHEN type = N<39>V<39> THEN <13,10>' & |
        '								  N<39>VIEW<39> <13,10>' & |
        '							  WHEN type IN (N<39>P<39>, N<39>X<39>, N<39>PC<39>) THEN <13,10>' & |
        '								  N<39>PROCEDURE<39> <13,10>' & |
        '							  WHEN type = N<39>AF<39> THEN <13,10>' & |
        '								  N<39>AGGREGATE<39> <13,10>' & |
        '							  WHEN type IN (N<39>FT<39>, N<39>FN<39>, N<39>IF<39>, N<39>TF<39>) THEN <13,10>' & |
        '								  N<39>FUNCTION<39> <13,10>' & |
        '							  WHEN type = N<39>SN<39> THEN <13,10>' & |
        '								  N<39>SYNONYM<39> <13,10>' & |
        '							  WHEN type = N<39>SQ<39> THEN <13,10>' & |
        '								  N<39>QUEUE<39> <13,10>' & |
        '						  END <13,10>' & |
        '	FROM <13,10>' & |
        '		sys.objects <13,10>' & |
        '	WHERE <13,10>' & |
        '		object_id = @Object_Id; <13,10>' & |
        '		SELECT [SELECTOPERATION] FROM fn_listextendedproperty (@Property_Name,N<39>SCHEMA<39>, @Schema_Name, @Object_Type, @Schema_Object_Name, N<39>COLUMN<39>, @Column_Name) <13,10>' & |
        '	 <13,10>' & |
        'END'

UltimateSQLScripts.DropAllDependencies          PROCEDURE()  !,STRING

    CODE
        
        RETURN 'DECLARE @tablename nvarchar(500), <13,10>' & | 
            '@columnname nvarchar(500) <13,10>' & |
            'SELECT  @tablename = <39>[PASSEDTABLE]<39>, <13,10>' & |
            '@columnname = <39>[PASSEDCOLUMN]<39> <13,10>' & |
            'SELECT CONSTRAINT_NAME, <39>C<39> AS type <13,10>' & |
            '    INTO #dependencies <13,10>' & |
            'FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WHERE TABLE_NAME = @tablename AND COLUMN_NAME = @columnname <13,10>' & |
            'INSERT INTO #dependencies <13,10>' & |
            'select d.name, <39>C<39> <13,10>' & |
            'from sys.default_constraints d <13,10>' & |
            'join sys.columns c ON c.column_id = d.parent_column_id AND c.object_id = d.parent_object_id <13,10>' & |
            'join sys.objects o ON o.object_id = d.parent_object_id <13,10>' & |
            'WHERE o.name = @tablename AND c.name = @columnname <13,10>' & |
            'INSERT INTO #dependencies <13,10>' & |
            'SELECT i.name, <39>I<39> <13,10>' & |
            'FROM sys.indexes i <13,10>' & |
            'JOIN sys.index_columns ic ON ic.index_id = i.index_id and ic.object_id=i.object_id <13,10>' & |
            'JOIN sys.columns c ON c.column_id = ic.column_id and c.object_id=i.object_id <13,10>' & |
            'JOIN sys.objects o ON o.object_id = i.object_id <13,10>' & |
            'where o.name = @tableName AND i.type=2 AND c.name = @columnname AND is_unique_constraint = 0 <13,10>' & |
            'INSERT INTO #dependencies <13,10>' & |
            'SELECT s.NAME, <39>S<39> <13,10>' & |
            'FROM sys.stats AS s <13,10>' & |
            'INNER JOIN sys.stats_columns AS sc <13,10>' & |
            'ON s.object_id = sc.object_id AND s.stats_id = sc.stats_id <13,10>' & |
            'INNER JOIN sys.columns AS c <13,10>' & |
            'ON sc.object_id = c.object_id AND c.column_id = sc.column_id <13,10>' & |
            'WHERE s.object_id = OBJECT_ID(@tableName) <13,10>' & |
            '                    AND c.NAME = @columnname <13,10>' & |
            '                    AND s.NAME LIKE <39>_dta_stat%<39> <13,10>' & |
            '                    DECLARE @dep_name nvarchar(500) <13,10>' & |
            '                    DECLARE @type nchar(1) <13,10>' & |
            'DECLARE dep_cursor CURSOR <13,10>' & |
            'FOR SELECT * FROM #dependencies <13,10>' & |
            'OPEN dep_cursor <13,10>' & |
            'FETCH NEXT FROM dep_cursor  <13,10>' & |
            '                    INTO @dep_name, @type; <13,10>' & |
            '                    DECLARE @sql nvarchar(max) <13,10>' & |
            '                WHILE @@FETCH_STATUS = 0 <13,10>' & |
            '                BEGIN <13,10>' & |
            '                    SET @sql =  <13,10>' & |
            '                    CASE @type <13,10>' & |
            '                        WHEN <39>C<39> THEN <39>ALTER TABLE [<39> + @tablename + <39>] DROP CONSTRAINT [<39> + @dep_name + <39>]<39> <13,10>' & |
            '                        WHEN <39>I<39> THEN <39>DROP INDEX [<39> + @dep_name + <39>] ON dbo.[<39> + @tablename + <39>]<39> <13,10>' & |
            '                        WHEN <39>S<39> THEN <39>DROP STATISTICS [<39> + @tablename + <39>].[<39> + @dep_name + <39>]<39> <13,10>' & |
            '                    END <13,10>' & |
            '                    print @sql <13,10>' & |
            'EXEC sp_executesql @sql <13,10>' & |
            'FETCH NEXT FROM dep_cursor  <13,10>' & |
            '                    INTO @dep_name, @type; <13,10>' & |
            '                END <13,10>' & |
            'DEALLOCATE dep_cursor <13,10>' & |
            'DROP TABLE #dependencies'  
        
        
        
        
        
UltimateSQLScripts.CreateQueryTable     PROCEDURE()  !,STRING

    CODE
        
    RETURN     '/****** Object:  Table [dbo].[Queries]    Script Date: 06/08/2012 17:22:14 ******/ <13,10>' & |
        'SET ANSI_NULLS ON <13,10>' & |
        ' <13,10>' & |
        'SET QUOTED_IDENTIFIER ON <13,10>' & |
        ' <13,10>' & |
        'SET ANSI_PADDING ON <13,10>' & |
        ' <13,10>' & |
        'CREATE TABLE [dbo].[Queries]( <13,10>' & |
        '	[C01] [varchar](max) NULL, <13,10>' & |
        '	[C02] [varchar](max) NULL, <13,10>' & |
        '	[C03] [varchar](max) NULL, <13,10>' & |
        '	[C04] [varchar](255) NULL, <13,10>' & |
        '	[C05] [varchar](255) NULL, <13,10>' & |
        '	[C06] [varchar](255) NULL, <13,10>' & |
        '	[C07] [varchar](255) NULL, <13,10>' & |
        '	[C08] [varchar](255) NULL, <13,10>' & |
        '	[C09] [varchar](255) NULL, <13,10>' & |
        '	[C10] [varchar](255) NULL, <13,10>' & |
        '	[C11] [varchar](255) NULL, <13,10>' & |
        '	[C12] [varchar](255) NULL, <13,10>' & |
        '	[C13] [varchar](255) NULL, <13,10>' & |
        '	[C14] [varchar](255) NULL, <13,10>' & |
        '	[C15] [varchar](255) NULL, <13,10>' & |
        '	[C16] [varchar](255) NULL, <13,10>' & |
        '	[C17] [varchar](255) NULL, <13,10>' & |
        '	[C18] [varchar](255) NULL, <13,10>' & |
        '	[C19] [varchar](255) NULL, <13,10>' & |
        '	[C20] [varchar](255) NULL, <13,10>' & |
        '	[C21] [varchar](255) NULL, <13,10>' & |
        '	[C22] [varchar](255) NULL, <13,10>' & |
        '	[C23] [varchar](255) NULL, <13,10>' & |
        '	[C24] [varchar](255) NULL, <13,10>' & |
        '	[C25] [varchar](255) NULL, <13,10>' & |
        '	[C26] [varchar](255) NULL, <13,10>' & |
        '	[C27] [varchar](255) NULL, <13,10>' & |
        '	[C28] [varchar](255) NULL, <13,10>' & |
        '	[C29] [varchar](255) NULL, <13,10>' & |
        '	[C30] [varchar](255) NULL <13,10>' & |
        ') ON [PRIMARY] <13,10>' & |
        ' <13,10>' & |
        'SET ANSI_PADDING OFF <13,10>'
         
!---------------------------------------------------------
UltimateSQLScripts.RaiseError    PROCEDURE(STRING pErrorMsg)
!---------------------------------------------------------

  CODE

  IF SELF.InDebug = TRUE
    BEEP(BEEP:SystemExclamation)
    MESSAGE(CLIP(pErrorMsg), 'ClarionLive Error', ICON:EXCLAMATION)
  END

  RETURN
