-- 创建U_POWER模式
CREATE SCHEMA [U_POWER] AUTHORIZATION [dbo]
GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for F_GETZFZH
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[F_GETZFZH]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[F_GETZFZH]
GO 

CREATE  FUNCTION  U_POWER.[F_GETZFZH]( @yhid varchar(500))
RETURNS varchar(500) 
 AS  
BEGIN 
    declare @ret  varchar(500)
    declare @tempyhid varchar(500)
    SET @ret = ''
    declare democursor cursor  for
   ( select  zfzbh  from 
      T_XZZF_RYXX A
      where sfyx = '1' and yhid = @yhid
   )
   open democursor
   fetch next from democursor into @tempyhid
   while @@FETCH_STATUS=0 
   begin 
      if(@ret = '')
      begin
       set @ret = @tempyhid
      end else
      begin
      set @ret =  (@tempyhid+','+@ret)
      end
   fetch next from democursor into @tempyhid
   end 
  close democursor 
  

    return  @ret
END


GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for GeoDistance
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[GeoDistance]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[GeoDistance]
GO

CREATE FUNCTION  U_POWER.[GeoDistance](@LatBegin FLOAT, @LngBegin FLOAT, @LatEnd FLOAT, @LngEnd FLOAT) 
RETURNS FLOAT
  AS
BEGIN
  --距离(千米)
  DECLARE @Distance FLOAT
  DECLARE @EARTH_RADIUS FLOAT
  SET @EARTH_RADIUS = 6378.137 
  DECLARE @RadLatBegin FLOAT,@RadLatEnd FLOAT,@RadLatDiff FLOAT,@RadLngDiff FLOAT
  SET @RadLatBegin = @LatBegin *PI()/180.0 
  SET @RadLatEnd = @LatEnd *PI()/180.0 
  SET @RadLatDiff = @RadLatBegin - @RadLatEnd 
  SET @RadLngDiff = @LngBegin *PI()/180.0 - @LngEnd *PI()/180.0  
  SET @Distance = 2 *ASIN(SQRT(POWER(SIN(@RadLatDiff/2), 2)+COS(@RadLatBegin)*COS(@RadLatEnd)*POWER(SIN(@RadLngDiff/2), 2)))
  SET @Distance = @Distance * @EARTH_RADIUS 
  --SET @Distance = Round(@Distance * 10000) / 10000 
  RETURN @Distance
END


GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for GET_DQBZCLR
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[GET_DQBZCLR]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[GET_DQBZCLR]
GO

CREATE FUNCTION  U_POWER.[GET_DQBZCLR](@LCSLBH VARCHAR(50))
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @CLRS VARCHAR(200)
	DECLARE @CLR VARCHAR(50)
	SET @CLRS = ''
	DECLARE MYCUR CURSOR FOR
		SELECT YH.YHMC FROM T_WORKFLOW_DQBZ DQBZ
			LEFT JOIN T_ADMIN_RMS_YH YH ON YH.YHID = DQBZ.CLR
		WHERE DQBZ.LCSLBH = @LCSLBH
	OPEN MYCUR
	FETCH NEXT FROM MYCUR INTO
	@CLR
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF(@CLR!='')
			SET @CLRS += @CLR + ','
		FETCH NEXT FROM MYCUR INTO @CLR
	END
	CLOSE MYCUR
	DEALLOCATE MYCUR
	IF(LEN(@CLRS)>0) SET @CLRS = SUBSTRING(@CLRS,0,LEN(@CLRS))
	RETURN @CLRS
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for getfqpkxx
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[getfqpkxx]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[getfqpkxx]
GO

CREATE FUNCTION  U_POWER.[getfqpkxx](@glbh as varchar(50))
returns varchar(4000)
as
begin
	declare @str varchar(4000)
	declare @xh varchar(50)
	declare @pfkbh varchar(50)
	declare @pfkmc varchar(200)
	declare @pfyzsl int
	
	set @str = ''
	declare mycur cursor for
		SELECT XH,PFKBH,PFKMC,(SELECT COUNT(1) FROM T_WRY_FQPFYZ WHERE PFKXH = T_WRY_FQPFK.XH) AS PFYZSL FROM T_WRY_FQPFK 
		 WHERE WRYBH = @glbh 
	open mycur
	fetch next from mycur into
		@xh,@pfkbh,@pfkmc,@pfyzsl
	while @@FETCH_STATUS = 0
		begin
			if(@pfkmc!='')
				set @str += @pfkbh+'-'+@pfkmc+'  '
			else
				set @str += @pfkbh+'   ' 
			if(@pfyzsl>0)
				set @str += '：排放因子是 '+U_POWER.getFqWrwyz(@xh)+'； '	
			set @str += '； '	 
		 fetch next from mycur into    ---获取下一条数据
         @xh,@pfkbh,@pfkmc,@pfyzsl
		end
	close mycur
	deallocate mycur	
	if(len(@str)>0) set @str = substring(@str,0,len(@str))
	return @str;
end

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for getFqWrwyz
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[getFqWrwyz]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[getFqWrwyz]
GO

create FUNCTION  U_POWER.[getFqWrwyz](@pfkxh as varchar(50))
returns varchar(4000)
as
begin
	declare @str varchar(4000);
	declare @wrw varchar(50);
	set @str = ''
	declare mycur cursor for
		SELECT WRW.WRW  FROM T_WRY_FQPFYZ PFYZ
			LEFT JOIN T_COMN_WRWDM WRW ON PFYZ.WRWDM = WRW.WRWDM AND WRW.WRWLB = '2'
			WHERE PFYZ.PFKXH = @pfkxh ;
	OPEN mycur 
	fetch  next from mycur into @wrw
	while @@FETCH_STATUS = 0 
		begin
			set @str += @wrw+',	 ' 
			fetch next from mycur into 
			@wrw 
		end
	close mycur
	deallocate mycur	
	if(len(@str)>0) set @str = substring(@str,0,len(@str)-1)
	return @str;
end;


GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for getfspkxx
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[getfspkxx]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[getfspkxx]
GO

CREATE FUNCTION  U_POWER.[getfspkxx](@glbh as varchar(50))
returns varchar(4000)
as
begin
	declare @str varchar(4000)
	declare @xh varchar(50)
	declare @pfkbh varchar(50)
	declare @pwkmc varchar(200)
	declare @pfyzsl int
	
	set @str = ''
	declare mycur cursor for
		SELECT XH,PFKBH,PWKMC,(SELECT COUNT(1) FROM T_WRY_FSPFYZ WHERE PFKXH = T_WRY_FSPFK.XH) AS PFYZSL FROM T_WRY_FSPFK 
		 WHERE WRYBH = @glbh 
	open mycur
	fetch next from mycur into
		@xh,@pfkbh,@pwkmc,@pfyzsl
	while @@FETCH_STATUS = 0
		begin
			if(@pwkmc!='')
				set @str += @pfkbh+'-'+@pwkmc+'  '
			else
				set @str += @pfkbh+'   ' 
			if(@pfyzsl>0)
				set @str += '：排放因子是 '+U_POWER.getFsWrwyz(@xh)	
			set @str += '； '
		 fetch next from mycur into    ---获取下一条数据
         @xh,@pfkbh,@pwkmc,@pfyzsl
		end
	close mycur
	deallocate mycur	
	if(len(@str)>0) set @str = substring(@str,0,len(@str))
	return @str;
end

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for getFsWrwyz
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[getFsWrwyz]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[getFsWrwyz]
GO

create FUNCTION  U_POWER.[getFsWrwyz](@pfkxh as varchar(50))
returns varchar(4000)
as
begin
	declare @str varchar(4000);
	declare @wrw varchar(50);
	set @str = ''
	declare mycur cursor for
		SELECT WRW.WRW  FROM T_WRY_FSPFYZ PFYZ
			LEFT JOIN T_COMN_WRWDM WRW ON PFYZ.WRWDM = WRW.WRWDM AND WRW.WRWLB = '1'
			WHERE PFYZ.PFKXH = @pfkxh ;
	OPEN mycur 
	fetch  next from mycur into @wrw
	while @@FETCH_STATUS = 0 
		begin
			set @str += @wrw+',	 ' 
			fetch next from mycur into 
			@wrw 
		end
	close mycur
	deallocate mycur	
	if(len(@str)>0) set @str = substring(@str,0,len(@str)-1)
	return @str;
end;


GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for getgtfwxx
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[getgtfwxx]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[getgtfwxx]
GO

CREATE FUNCTION  U_POWER.[getgtfwxx](@glbh as varchar(50))
returns varchar(4000)
as
begin
	declare @str varchar(4000);
	declare @gtfwmc varchar(100);
	set @str = ''
	declare mycur cursor for
		SELECT GTFWMC FROM T_WRY_GTFW
			WHERE WRYBH = @glbh ;
	OPEN mycur 
	fetch  next from mycur into @gtfwmc
	while @@FETCH_STATUS = 0 
		begin
			set @str += @gtfwmc+',	 ' 
			fetch next from mycur into 
			@gtfwmc 
		end
	close mycur
	deallocate mycur	
	if(len(@str)>0) set @str = substring(@str,0,len(@str))
	return @str;
end;

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for GETWRYJC_RWLX
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[GETWRYJC_RWLX]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[GETWRYJC_RWLX]
GO

CREATE FUNCTION  U_POWER.[GETWRYJC_RWLX](@RWLX AS VARCHAR(500))
RETURNS VARCHAR(500)
AS 
BEGIN
	DECLARE @RESULT VARCHAR(500)
	DECLARE @DMNR VARCHAR(100)
	DECLARE @DM VARCHAR(100)
	SET @RESULT = '' 
	DECLARE MYCUR CURSOR FOR
	SELECT DMNR,DM FROM T_COMN_GGDMZ WHERE DMJBH = 'ZFLXXL'	
	OPEN MYCUR
	FETCH NEXT FROM MYCUR INTO
	@DMNR,@DM
	IF(@RWLX IS NOT NULL AND @RWLX != '')
	BEGIN
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF(charindex(@DM,@RWLX)>0)
			BEGIN
				set @RESULT = @RESULT + @DMNR + ',' 
			END
		
		FETCH NEXT FROM MYCUR INTO @DMNR,@DM
		END
	CLOSE MYCUR
	DEALLOCATE MYCUR
	END
	IF(len(@RESULT)>0)
	BEGIN
		SET @RESULT = SUBSTRING(@RESULT,0,len(@RESULT))
	END
	RETURN @RESULT
END 

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for getzypfqk
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[getzypfqk]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[getzypfqk]
GO

CREATE FUNCTION  U_POWER.[getzypfqk](@glbh as varchar(50))
returns varchar(4000)
as
begin
	declare @str varchar(4000);
	declare @zsymc varchar(100);
	set @str = ''
	declare mycur cursor for
		SELECT ZSYMC FROM T_WRY_WRYZS
			WHERE WRYBH = @glbh ;
	OPEN mycur 
	fetch  next from mycur into @zsymc
	while @@FETCH_STATUS = 0 
		begin
			set @str += @zsymc+',	 ' 
			fetch next from mycur into 
			@zsymc 
		end
	close mycur
	deallocate mycur	
	if(len(@str)>0) set @str = substring(@str,0,len(@str))
	return @str;
end;

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_getdate
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_getdate]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_getdate]
GO

CREATE FUNCTION  U_POWER.[p_getdate]()
RETURNS datetime 
 AS  
BEGIN 
      declare @ret  datetime
    
       select @ret = dt  from v_sysdate
    
       return  @ret
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_instr
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_instr]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_instr]
GO

CREATE  FUNCTION  U_POWER.[p_instr]( @strtemp varchar(500),@findstr varchar(500))
RETURNS int 
 AS  
BEGIN 
    declare @ret  int
    set @ret = CHARINDEX(@findstr,@strtemp,1)
    return  @ret
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_length
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_length]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_length]
GO

CREATE FUNCTION  U_POWER.[p_length]( @strtemp varchar(500))
RETURNS int 
 AS  
BEGIN 
    declare @ret  int
    set @ret = len(@strtemp)
    return  @ret
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_nvl
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_nvl]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_nvl]
GO

CREATE  FUNCTION  U_POWER.[p_nvl]( @strtemp sql_variant,@strvalue sql_variant)
RETURNS varchar(500) 
 AS  
BEGIN 
    declare @ret  varchar(500)
    if(@strtemp = '')
    begin
       set @strtemp = null
    end 
    set @ret = cast(IsNull(@strtemp,@strvalue) as varchar(500) ) 
    return  @ret
END;

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_split
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_split]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_split]
GO

--实现解析split分割后的第一个元素
CREATE FUNCTION  U_POWER.[p_split](@SourceSql varchar(8000),@StrSeprate varchar(10))
RETURNS varchar(200) 
 AS  
BEGIN 
    declare @temp varchar(200)
    declare @i int
	set @SourceSql=rtrim(ltrim(@SourceSql))
	set @i=charindex(@StrSeprate,@SourceSql)
	if @i >=1 
    set @temp = substring(@SourceSql,1,@i - 1)
    else 
    set @temp = @SourceSql
    return @temp
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_substr
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_substr]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_substr]
GO

CREATE FUNCTION  U_POWER.[p_substr]( @strtemp varchar(500),@begin int,@length int)
RETURNS varchar(5000) 
 AS  
BEGIN 
    declare @ret varchar(500)
    if(@begin = 0)
      begin
      set @begin = 1
     end
   
    set @ret = substring(@strtemp,@begin,@length)
    return  @ret
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_substr2
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_substr2]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_substr2]
GO

CREATE  FUNCTION  U_POWER.[p_substr2]( @strtemp varchar(500),
			@beginstr1 varchar(100),@beginstr2 varchar(100),
			@endstr1 varchar(100),@endstr2 varchar(100))
RETURNS varchar(5000) 
 AS  
BEGIN 
    declare @ret varchar(500)
    declare @beginnum int
    declare @endnum int
   
   if(@strtemp !='' and @strtemp is not null) 
   begin
   if(@beginstr1 != '' and @beginstr1 is not null)
		begin
		 set @beginnum = CHARINDEX(@beginstr1,@strtemp,1)
			if(@beginnum = 0 )
				begin 
					set @beginnum = CHARINDEX(@beginstr2,@strtemp,1)
					if(@beginnum = 0)
						begin 
							set @beginnum = 1
						end
					else
						begin
							if @beginnum = 1
						    begin
								set @beginnum = @beginnum + len(@beginstr2)
						    end
						    else
						    begin
								set @beginnum = 1
						    end		 
						end
				end
			else
				begin 
					if(@beginnum = 1)
					begin
						set @beginnum = @beginnum + len(@beginstr1)
					end
					else
					begin
						set @beginnum = CHARINDEX(@beginstr2,@strtemp,1)
					if(@beginnum = 0)
						begin 
							set @beginnum = 1
						end
					else
						begin
							if @beginnum = 1
						    begin
								set @beginnum = @beginnum + len(@beginstr2)
						    end
						    else
						    begin
								set @beginnum = 1
						    end		 
						end
					end
				end
		end
   else 
		begin 
			set @beginnum = 1 
		end
	
	if(@endstr1 != '' and @endstr1 is not null)
		begin
		 set @endnum = CHARINDEX(REVERSE(@endstr1),REVERSE(@strtemp),1)
			if(@endnum = 0 )
				begin 
					set @endnum = CHARINDEX(REVERSE(@endstr2),REVERSE(@strtemp),1)
					if(@endnum = 0)
						begin 
							set @endnum = len(@strtemp) - @beginnum +1
						end
					else
						begin
							if @endnum = 1
							begin
								if(LEN(@endstr2)>1)
								begin
									set @endnum = len(@strtemp) - @endnum  - @beginnum -LEN(@endstr2) +2
								end
								else
								begin
									set @endnum = len(@strtemp) - @endnum  - @beginnum +1
								end 	
							end
							else
							begin
								set @endnum = len(@strtemp) - @beginnum +1
							end
						end
				end
			else
				begin 
				 if @endnum = 1
					begin
						if(LEN(@endstr1)>1)
						begin
							set @endnum =  len(@strtemp) - @endnum  - @beginnum -LEN(@endstr1) +2
						end
						else
						begin
							set @endnum =  len(@strtemp) - @endnum  - @beginnum +1
						end
					end
				else
					begin
						set @endnum = CHARINDEX(REVERSE(@endstr2),REVERSE(@strtemp),1)
					if(@endnum = 0)
						begin 
							set @endnum = len(@strtemp) - @beginnum +1
						end
					else
						begin
							if @endnum = 1
							begin
								if(LEN(@endstr2)>1)
								begin
									set @endnum = len(@strtemp) - @endnum  - @beginnum -LEN(@endstr2) +2
								end
								else
								begin
									set @endnum = len(@strtemp) - @endnum  - @beginnum +1
								end 	
							end
							else
							begin
								set @endnum = len(@strtemp) - @beginnum +1
							end
						end
					end		
				end
		end
   else 
		begin 
			set @endnum = len(@strtemp) 
		end
    set @ret = substring(@strtemp,@beginnum,@endnum)
    end
    else 
    begin
		set @ret = ''
    end  
    return  @ret
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_to_char
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_to_char]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_to_char]
GO

CREATE   FUNCTION  U_POWER.[p_to_char] (@rq datetime , @rqgs varchar(50))  
RETURNS varchar(50)  AS  
BEGIN 
   declare @ret varchar(50)
   declare @year varchar(50)
   declare @month varchar(50)
   declare @day varchar(50)
  
    if(@rqgs = 'yyyyMMddHHmmss')
    begin
		set @ret = REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(100),getdate(), 120),'-',''),' ',''),':','')
    end
    if(@rqgs = 'yyyyMMDD')
      begin
      set  @ret = ( select CONVERT(varchar(100),@rq, 112) )
      end
     if(@rqgs = 'yyyy-MM-dd'  or  @rqgs = 'YYYY-MM-DD'  or  @rqgs = 'yyyy-mm-dd'    )
      begin
      set  @ret = ( select CONVERT(varchar(100),@rq, 23) )
      end 
     if(@rqgs = 'yyyy-MM-dd hh:mm:ss'  or @rqgs = 'yyyy-MM-dd HH:mm:ss'  or @rqgs = 'yyyy-MM-dd HH24:mm:ss' or @rqgs ='yyyy-MM-dd HH24:mi:ss'  or @rqgs=' YYYYMMDD HH24:MI:ss'  )
      begin
      set  @ret = ( select CONVERT(varchar(100),@rq, 120) )
      end 
      if(@rqgs = 'yyyy-MM-dd hh:mm'  or @rqgs = 'yyyy-MM-dd HH:mm'  or @rqgs = 'yyyy-MM-dd HH24:mm' or @rqgs ='yyyy-MM-dd HH24:mi'  or @rqgs=' YYYYMMDD HH24:MI'  )
      begin
      set  @ret = ( select CONVERT(varchar(16),@rq, 120) )
      end 
     if(@rqgs = 'dd-MM-yyyy')
      begin
      set  @ret = ( select CONVERT(varchar(100),@rq, 110) )
      end
	if(@rqgs = 'hh24:mi' or @rqgs = 'HH24:MI' or @rqgs = 'hh:mi' or @rqgs = 'HH:MI')
	begin
		set  @ret = ( select substring(CONVERT(varchar(100),@rq, 108),1,5) )
	end
	if(@rqgs = 'hh24' or @rqgs = 'HH24' or  @rqgs = 'HH')
	begin
		set  @ret = ( select substring(CONVERT(varchar(100),@rq, 108),1,2) )
	end
     if(@rqgs = 'yyyy' or @rqgs = 'YYYY' )
      begin
      set  @ret = (  SELECT DATENAME(year, @rq )   )
      end

     if(@rqgs = 'mm' or @rqgs = 'MM' )
      begin
      set  @ret = (  SELECT DATENAME(month, @rq )   )
      end

     if(@rqgs = 'dd' or @rqgs = 'DD' )
      begin
      set  @ret = (  SELECT DATENAME(day, @rq )   )
      end

     if(@rqgs = 'yyyy.mm.dd' or @rqgs = 'YYYY.MM.DD' )
      begin
      set  @ret = ( DATENAME(year,  @rq)+'.'+DATENAME(month,  @rq)+'.'+DATENAME(day,  @rq)   )
      end

     if(@rqgs = 'YYYYMMDD' or @rqgs = 'yyyymmdd' )
      begin
      set  @ret = ( select CONVERT(varchar(100),@rq, 112) )
      end

     if(@rqgs = 'YYYYMM' or @rqgs = 'yyyymm' )
      begin
      set  @ret = (  DATENAME(year,  @rq)+DATENAME(month,  @rq) )
      end

     if(@rqgs = 'YYYY-MM')
      begin
	set  @year = (  DATENAME(year,  @rq) )
	set  @month = (  DATENAME(month,  @rq) )	
	set  @ret=@year+'-'+@month
      end

      if(@rqgs = 'YY-MM-DD')
      begin
	set  @year = (  DATENAME(year,  @rq) )
	set  @month = (  DATENAME(month,  @rq) )
        set  @day = (  DATENAME(day,  @rq) )		
	set  @ret=substring(@year,3,2)+'-'+@month+'-'+@day
      end


  return @ret
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_to_date
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_to_date]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_to_date]
GO

CREATE   FUNCTION  U_POWER.[p_to_date]( @rqstr varchar(50) , @rqgs varchar(50) )
RETURNS datetime 
 AS  
BEGIN 
      declare @ret  datetime
      declare @date varchar(50)

      if(@rqgs='yyyy-MM')
	begin
         set @date = @rqstr + '-01'
	 set @ret = cast(@date as datetime)
	end
      else
        begin
         set @ret = cast(@rqstr as datetime)
        end
      return  @ret
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_to_number
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_to_number]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_to_number]
GO

CREATE  FUNCTION  U_POWER.[p_to_number]( @strtemp sql_variant)
RETURNS decimal 
 AS  
BEGIN 
    declare @ret  decimal
    set @ret =cast(  @strtemp as decimal ) 
    return  @ret
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_trim
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_trim]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_trim]
GO

CREATE  FUNCTION  U_POWER.[p_trim]( @strtemp sql_variant)
RETURNS varchar(500) 
 AS  
BEGIN 
    declare @ret  varchar(500)
    set @ret =   rtrim( ltrim( cast( @strtemp  as varchar(500) ) ) ) 
    return  @ret
END

GO

-- ----------------------------
-- FUNCTION  U_POWER.structure for p_userdatediff
-- ----------------------------

IF EXISTS (SELECT * FROM DBO.SYSOBJECTS WHERE ID = OBJECT_ID(N'[U_POWER].[p_userdatediff]') AND XTYPE IN (N'FN', N'IF', N'TF')) 
DROP FUNCTION U_POWER.[p_userdatediff]
GO

CREATE FUNCTION  U_POWER.[p_userdatediff]( @date1 datetime,@date2 datetime)
RETURNS int 
 AS  
BEGIN 
    declare @ret  int
    set @ret = convert( int  , (@date1-@date2) ) 
    return  @ret
END

GO