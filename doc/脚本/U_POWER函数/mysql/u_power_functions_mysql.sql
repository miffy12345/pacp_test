-- 创建U_POWER数据库
CREATE DATABASE U_POWER;

-- ----------------------------
-- Function structure for p_getdate
-- ----------------------------
DROP FUNCTION IF EXISTS U_POWER.`p_getdate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION U_POWER.`p_getdate`() RETURNS datetime
BEGIN
	RETURN now();
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for p_instr
-- ----------------------------
DROP FUNCTION IF EXISTS U_POWER.`p_instr`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION U_POWER.`p_instr`(`STR1` varchar(3000),`STR2` varchar(100),`POS` int,`NTH` int ) RETURNS int(10) unsigned
BEGIN
      -- Created by ytt. Simulating Oracle instr function.  
      -- Date 2015/12/5.  
      DECLARE i INT DEFAULT 0; -- Postion iterator  
      DECLARE j INT DEFAULT 0; -- Times compare.  
      DECLARE v_substr_len INT UNSIGNED DEFAULT 0; -- Length for Parameter 1.  
      DECLARE v_str_len INT UNSIGNED DEFAULT 0;  -- Length for Parameter 2.  
      SET v_str_len = LENGTH(STR1);   
      SET v_substr_len = LENGTH(STR2);  
      -- Unsigned.  
      IF POS > 0 THEN  
        SET i = POS;  
        SET j = 0;  
        WHILE i <= v_str_len  
        DO  
          IF INSTR(LEFT(SUBSTR(STR1,i),v_substr_len),STR2) > 0 THEN  
            SET j = j + 1;  
            IF j = NTH THEN  
              RETURN i;  
            END IF;  
          END IF;  
          SET i = i + 1;  
        END WHILE;  
      -- Signed.  
      ELSEIF POS <0 THEN  
        SET i = v_str_len + POS+1;  
        SET j = 0;  
        WHILE i <= v_str_len AND i > 0   
        DO  
          IF INSTR(RIGHT(SUBSTR(STR1,1,i),v_substr_len),STR2) > 0 THEN  
            SET j = j + 1;  
            IF j = NTH THEN  
              RETURN i - v_substr_len + 1;  
            END IF;  
          END IF;  
          SET i = i - 1;  
        END WHILE;  
      -- Equal to 0.  
      ELSE  
        RETURN 0;  
      END IF;  
      RETURN 0;  
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for p_nvl
-- ----------------------------
DROP FUNCTION IF EXISTS U_POWER.`p_nvl`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION U_POWER.`p_nvl`(str VARCHAR(255), def varchar(255)) RETURNS varchar(255) CHARSET utf8
BEGIN
	RETURN ifnull(str, def);
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for p_substr
-- ----------------------------
DROP FUNCTION IF EXISTS U_POWER.`p_substr`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION U_POWER.`p_substr`(str VARCHAR(255), pos numeric, len numeric) RETURNS varchar(255) CHARSET utf8
BEGIN
	RETURN substring(str, pos, len);
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for p_to_char
-- ----------------------------
DROP FUNCTION IF EXISTS U_POWER.`p_to_char`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION U_POWER.`p_to_char`(fdate datetime, format varchar(255)) RETURNS varchar(255) CHARSET utf8
BEGIN
set format = REPLACE(format, 'yyyy', '%Y');
set format = REPLACE(format, 'YYYY', '%Y');
set format = REPLACE(format, 'YY', '%y');
set format = REPLACE(format, 'MM', '%m');
set format = REPLACE(format, 'mm', '%m');
set format = REPLACE(format, 'dd', '%d');
set format = REPLACE(format, 'DD', '%d');
set format = REPLACE(format, 'HH24', '%H');
	set format = REPLACE(format, 'hh24', '%H');
set format = REPLACE(format, 'mi', '%i');
set format = REPLACE(format, 'ss', '%S');
set format = REPLACE(format, 'SS', '%S');
RETURN date_format(fdate,format);
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for p_to_date
-- ----------------------------
DROP FUNCTION IF EXISTS U_POWER.`p_to_date`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION U_POWER.`p_to_date`(fdate VARCHAR(255), format VARCHAR(255)) RETURNS datetime
BEGIN
	set format = REPLACE(format, 'yyyy', '%Y');
	set format = REPLACE(format, 'YYYY', '%Y');
	set format = REPLACE(format, 'YY', '%y');
	set format = REPLACE(format, 'MM', '%m');
	set format = REPLACE(format, 'mm', '%m');
	set format = REPLACE(format, 'dd', '%d');
	set format = REPLACE(format, 'DD', '%d');
	set format = REPLACE(format, 'HH24', '%H');
	set format = REPLACE(format, 'hh24', '%H');
	set format = REPLACE(format, 'mi', '%i');
	set format = REPLACE(format, 'MI', '%i');
	set format = REPLACE(format, 'ss', '%S');
	set format = REPLACE(format, 'SS', '%S');
	RETURN str_to_date(fdate,format);
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for P_TO_NUMBER
-- ----------------------------
DROP FUNCTION IF EXISTS U_POWER.`p_TO_NUMBER`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION U_POWER.`p_TO_NUMBER`(snu VARCHAR(255)) RETURNS decimal(10,0)
BEGIN
	RETURN cast(snu as signed integer);
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for p_trim
-- ----------------------------
DROP FUNCTION IF EXISTS U_POWER.`p_trim`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION U_POWER.`p_trim`(`str` varchar(255)) RETURNS varchar(255) CHARSET utf8
BEGIN
	RETURN TRIM(`str`);
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for p_userdatediff
-- ----------------------------
DROP FUNCTION IF EXISTS U_POWER.`p_userdatediff`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION U_POWER.`p_userdatediff`(d1 datetime, d2 datetime) RETURNS decimal(30,16)
BEGIN
	RETURN TIMESTAMPDIFF(second, d2, d1)/60/60/24;
END
;;
DELIMITER ;