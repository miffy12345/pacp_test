create user U_POWER identified by U_PLATFORM_POWER;
/

create or replace function U_POWER.p_userdatediff( D1 date,D2 date)
RETURN NUMBER
AS
BEGIN
    return  (D1-D2);
END p_userdatediff;
/

create or replace function U_POWER.p_trim (v VARCHAR2)  return VARCHAR2
as
begin
return trim(v);
end   p_trim;
/

create or replace function U_POWER.p_to_number(oldvalue in varchar2) return number is
       newvalue number;
begin
       newvalue:= to_number(oldvalue);
return (newvalue);
end p_to_number;
/

create or replace function U_POWER.p_to_date (LEFT VARCHAR2,
       RIGHT VARCHAR2) return DATE
as
begin
return to_date(LEFT,RIGHT);
end  p_to_date;
/

create or replace function U_POWER.p_to_char (LEFT DATE, RIGHT VARCHAR2) return VARCHAR2
as
begin
return to_char(LEFT,RIGHT);
end   p_to_char;
/

create or replace function U_POWER.p_substr(STR1 VARCHAR2,
                  POS PLS_INTEGER,
                  LEN PLS_INTEGER := 2147483647)
        return VARCHAR2
    as
    begin
    return substr(STR1,POS,LEN);
    end p_substr;
/

create or replace function U_POWER.P_REGEXP_REPLACE(srcstr      VARCHAR2,
                          pattern     VARCHAR2,
                          replacestr  VARCHAR2
                                        DEFAULT NULL,
                          position    PLS_INTEGER := 1,
                          occurrence  PLS_INTEGER := 0,
                          modifier    VARCHAR2 DEFAULT NULL)
    return VARCHAR2
    AS
    BEGIN
    RETURN REGEXP_REPLACE(srcstr,pattern,replacestr,position,occurrence,modifier);
    END P_REGEXP_REPLACE;
/

create or replace function U_POWER.p_nvl2(s1  VARCHAR2 ,
               s2  VARCHAR2, s3  VARCHAR2 )
        return VARCHAR2   as
BEGIN
   return (CASE WHEN s1 IS NOT NULL THEN s2 ELSE s3 END);
END p_nvl2;
/

create or replace function U_POWER.p_nvl(s1 VARCHAR2,
               s2 VARCHAR2)
        return VARCHAR2  as
BEGIN
   return nvl(s1,s2);
END p_nvl;
/

create or replace function U_POWER.p_length(ch VARCHAR2) return int
 as
 begin
 return length(ch);
 end p_length;
/

create or replace function U_POWER.p_instr(STR1 VARCHAR2,
                 STR2 VARCHAR2,
                 POS int := 1,
                 NTH int := 1) return int
 as
 begin
 return instr(STR1,STR2,POS,NTH);
 end p_instr;
/

create or replace function U_POWER.p_getdate return DATE
as
begin
return  sysdate;
end  p_getdate;
/

create or replace function U_POWER.P_EMPTY_BLOB return blob
AS
BEGIN
RETURN EMPTY_BLOB;
end P_EMPTY_BLOB;
/

create or replace function U_POWER.p_ceil(n NUMBER) return NUMBER
 as
 begin
 return ceil(n);
 end p_ceil;
/

create or replace function U_POWER.money_to_chinese(money in VARCHAR2)
  return varchar2 is
    c_money  VARCHAR2(12);
    m_string VARCHAR2(60) := '分角圆拾佰仟万拾佰仟亿';
    n_string VARCHAR2(40) := '壹贰叁肆伍陆柒捌玖';
    b_string VARCHAR2(80);
    n        CHAR;
    len      NUMBER(3);
    i        NUMBER(3);
    tmp      NUMBER(12);
    is_zero  BOOLEAN;
    z_count  NUMBER(3);
    l_money  NUMBER;
    l_sign   VARCHAR2(10);
  BEGIN
    l_money := abs(money);
    IF money < 0 THEN
      l_sign := '负' ;
    ELSE
      l_sign := '';
    END IF;
    tmp     := round(l_money, 2) * 100;
    c_money := rtrim(ltrim(to_char(tmp, '999999999999')));
    len     := length(c_money);
    is_zero := TRUE;
    z_count := 0;
    i       := 0;
    WHILE i < len LOOP
      i := i + 1;
      n := substr(c_money, i, 1);
      IF n = '0' THEN
        IF len - i = 6 OR len - i = 2 OR len = i THEN
          IF is_zero THEN
            b_string := substr(b_string, 1, length(b_string) - 1);
            is_zero  := FALSE;
          END IF;
          IF len - i = 6 THEN
            b_string := b_string || '万';
          END IF;
          IF len - i = 2 THEN
            b_string := b_string || '圆';
          END IF;
          IF len = i THEN
            b_string := b_string || '整';
          END IF;
          z_count := 0;
        ELSE
          IF z_count = 0 THEN
            b_string := b_string || '零';
            is_zero  := TRUE;
          END IF;
          z_count := z_count + 1;
        END IF;
      ELSE
        b_string := b_string || substr(n_string, to_number(n), 1) ||
                    substr(m_string, len - i + 1, 1);
        z_count  := 0;
        is_zero  := FALSE;
      END IF;
    END LOOP;
    b_string := l_sign || b_string ;
    RETURN b_string;
exception
  --异常处理
   WHEN OTHERS THEN
      RETURN(SQLERRM);
END;
/

create or replace function U_POWER.MD5 (vin_string IN VARCHAR2) RETURN VARCHAR2 IS
--
-- Return an MD5 hash of the input string.
--
BEGIN
RETURN UPPER(Dbms_Obfuscation_Toolkit.Md5 ( input => utl_raw.cast_to_raw(vin_string)));
END;
/

create or replace function U_POWER.ISNULL(PARAM1 IN VARCHAR2,PARAM2 IN VARCHAR2)
  RETURN VARCHAR2
  AS
    resultVar VARCHAR2(4000);
  BEGIN
    IF (PARAM1 IS NULL) THEN
      resultVar := PARAM2;
    ELSE
      resultVar := PARAM1;
    END IF;
    RETURN resultVar;
  END;
/

create or replace function U_POWER.F_TO_CHAR(DT in DATE) return varchar2 is
  Result varchar2(20) := '';
begin
   IF DT = NULL THEN
   RETURN Result;
   END IF;
   RESULT := TO_CHAR(DT,'YYYY')||'年'||TO_CHAR(DT,'MM')||'月'||TO_CHAR(DT,'DD')||'日';
  return(Result);
end F_TO_CHAR;
/

create or replace function U_POWER."DATEDIFF" (p_what in varchar2, p_d1   in date, p_d2   in date ) return number
as
l_result    number;
begin
    l_result:=null;
    if (upper(p_what) ='HH') then
      l_result:=((p_d2-p_d1)*24);
    end if;
    if (upper(p_what) ='DD') then
      l_result:=(p_d2-p_d1);
    end if;
    if (upper(p_what) = 'MM') then
      l_result:=round(MONTHS_BETWEEN(p_d2,p_d1),0);
    end if;
    if (upper(p_what) ='QQ') then
      l_result:=((floor(MONTHS_BETWEEN(p_d2,TRUNC(p_d2,'YEAR'))/3)+1) - (floor(MONTHS_BETWEEN(p_d1,TRUNC(p_d1,'YEAR'))/3)+1) + (((to_char(p_d2, 'yyyy')) - (to_char(p_d1,'yyyy')))*4));
    end if;
  l_result:=floor(l_result);
  return l_result;
end;
/

create or replace function U_POWER."CREATEYWLSH"(xksxbh varchar2, yxtwylsh VARCHAR2) return varchar2 is
  Result varchar2(100);
BEGIN
  RESULT  := xksxbh || '-' || dbms_obfuscation_toolkit.MD5( input => utl_raw.cast_to_raw(yxtwylsh) );
  return(Result);
end CreateYwlsh;