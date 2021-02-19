/******************************************************************************
 * Copyright (C) ShenZhen Powerdata Information Technology Co.,Ltd All Rights Reserved.
 * 本软件为深圳市博安达信息技术股份有限公司开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、 复制、修改或发布本软件.
 *****************************************************************************/

package com.szboanda.business;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.szboanda.platform.common.base.BaseController;
import com.szboanda.platform.common.utils.DateUtils;
import com.szboanda.platform.common.utils.StringUtils;

/**
 * @title: 业务处理_控制器
 * @fileName: BaseBusinessController.java
 * @description: 该【业务处理_控制器】继承 平台部门的控制器,具体项目的控制器需要全部继承这个业务处理_控制器
 * @copyright: PowerData Software Co.,Ltd. Rights Reserved.
 * @company: 深圳市博安达信息技术股份有限公司 @author： 唐肖肖 @date： 2016年12月6日 @version： V1.0
 */

public class BaseBusinessController extends BaseController {

    /**
     * 转换字符为日期格式
     * 
     * @param map map对象
     * @param keys 需要转换字符为时间的值
     * @param format 转换的时间格式(例如:yyyy-MM-dd)
     */
    public void parseDate(Map<String, Object> map, String[] keys, String format) {
        if (keys != null && keys.length > 0) {
            for (int i = 0; i < keys.length; i++) {
                if (map != null && map.get(keys[i]) != null) { // 判断map集合是否存在
                    String value = map.get(keys[i]) == null ? "" : map.get(keys[i]).toString(); // 获取map集合对应key值,如果有该key直接赋值,否则为""
                    if (isNumeric(value) == false) { // 判断是否为数字时间格式,如果不为数字才进行转换(不为数字格式的时间)
                        if (!("").equals(value)) {
                            try {
                                map.put(keys[i], DateUtils.parseDateStrictly(value, format)); // 转换字符串为时间格式
                            } catch (ParseException e) {
                                e.printStackTrace();
                            }
                        }
                    } else { // 当时间为数字格式的时间
                        if (!("").equals(value)) {
                            try {
                                map.put(keys[i], DateUtils.parseDateStrictly(numberToDate(value, format), format));// 将“数字时间格式”转换为“时间格式”
                            } catch (ParseException e) {
                                e.printStackTrace();
                            }
                        }

                    }
                }

            }

        }

    }

    /**
     * 判断字符串是否为数字的方法
     * 
     * @param str 校验字符串
     * @return 是否数字
     */
    public static boolean isNumeric(String str) {
        Pattern pattern = Pattern.compile("[0-9]*");
        Matcher isNum = pattern.matcher(str);
        if (!isNum.matches()) {
            return false;
        }
        return true;
    }

    /**
     * 设置orgid,CJR,CJSJ,XGR,XGSJ相关公共的信息
     * 
     * @param map 设置的map集合对象
     * @param primaryKey 业务主键字段
     * @param username 当前登录人用户名称
     * @param orgid 当前登录人所在组织机构代码
     */
    public void setOrgid(Map<String, Object> map, String primaryKey, String username, String orgid) {

        // 判断是添加、修改操作
        if (isExist(map, primaryKey)) { // 修改操作
            map.put("XGR", username); // 修改人
            map.put("XGSJ", new Date()); // 修改时间
            try {
                Date cjsj = null;
                if (map.get("CJSJ") != null) {
                    cjsj = DateUtils.parseDateStrictly(numberToDate(map.get("CJSJ").toString(), "yyyy-MM-dd HH:mm:ss"), "yyyy-MM-dd HH:mm:ss");
                } else {
                    cjsj = new Date();
                }
                map.put("CJSJ", cjsj);// 创建时间
            } catch (ParseException e) {
                e.printStackTrace();
            }
        } else { // 添加操作
            map.put("CJR", username);// 创建人
            map.put("CJSJ", new Date());// 创建时间
            map.put("XGR", username); // 修改人
            map.put("XGSJ", new Date());// 修改时间
        }
        map.put("ORGID", orgid);// 组织机构代码
    }

    /**
     * 将java数字格式转换化为日期字符串，格式：yyyy-MM-dd HH:mm:ss
     * 
     * @param time1 待转换时间格式
     * @param format 时间格式
     * @return
     */
    public static String numberToDate(String time1, String format) {
        if (!time1.equals("")) {
            Long time = Long.parseLong(time1);// 将字符串转换为Long类型
            if (time > 0L) {
                SimpleDateFormat sf = new SimpleDateFormat(format);
                Date date = new Date(time);
                return sf.format(date);
            }
        }
        return "";
    }

    /**
     * 验证某个主键是否为空
     * 
     * @param map
     * @param primaryKey 业务主键字段
     * @return
     */
    private boolean isExist(Map<String, Object> map, String primaryKey) {
        boolean result = true;
        result &= StringUtils.isNotEmpty(map.get(primaryKey));
        return result;
    }

}
