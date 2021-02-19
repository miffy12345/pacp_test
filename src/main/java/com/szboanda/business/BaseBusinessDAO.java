/******************************************************************************
 * Copyright (C) ShenZhen Powerdata Information Technology Co.,Ltd All Rights
 * Reserved. 本软件为深圳市博安达信息技术股份有限公司开发研制。未经本公司正式书面同意，其他任何个人、团体不得使用、 复制、修改或发布本软件.
 *****************************************************************************/

package com.szboanda.business;

import com.szboanda.platform.common.annotation.AutoLoadDAO;
import com.szboanda.platform.common.base.BaseDAO;

/**
 * @title:       业务处理DAO
 * @fileName:    BaseBusinessDAO.java
 * @description: 该【业务处理DAO】继承 平台部门的DAO,具体项目的DAO需要全部集继承这个业务处理DAO
 * @copyright:   PowerData Software Co.,Ltd. Rights Reserved.
 * @company:     深圳市博安达信息技术股份有限公司
 * @author：                 唐肖肖
 * @date：                       2016年12月6日  
 * @version：              V1.0
 */
@AutoLoadDAO
public interface BaseBusinessDAO extends BaseDAO {

}
