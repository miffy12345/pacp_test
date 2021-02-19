package com.szboanda.platform.v3.workflow.tools;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import com.szboanda.platform.common.constants.CommonConstants;
import com.szboanda.platform.common.utils.StringUtils;
import com.szboanda.platform.common.utils.Toolkit;

/**
 * 
 * @Title: ConnectionHelper 
 * @author 罗九波 
 * @date 2016年6月27日
 * @version V1.0
 */
public class ConnectionHelper {
    

    /**
     * 返回数据库连接Connection，通过SqlSession获取保证连接一致
     * 注意需要保证该方法在Spring创建了Connection地方才有效，如@Service限定了的应用了切面的方法中
     * @return
     * @throws SQLException
     */
    public static Connection getConnection() throws SQLException {
        return ConnectionHelper.getConnection(null);
    }

    /**
     * 返回数据库连接Connection，通过SqlSession获取保证连接一致
     * 注意需要保证该方法在Spring创建了Connection地方才有效，如@Service限定了的应用了切面的方法中
     * 
     * @return
     * @throws SQLException
     */
    public static Connection getConnection(String dataSourceName) throws SQLException {
        if (StringUtils.isEmpty(dataSourceName)) {
            dataSourceName = CommonConstants.DEFAULT_DATA_SOURCE_NAME;
        }
        DataSource dataSource = (DataSource) Toolkit.getSpringBean(dataSourceName);
        return dataSource.getConnection();
        // return DataSourceUtils.getConnection(dataSource);
    }
    /**
     * 该方法返回的数据源获取Connection无法保证在同一事务中
     * @return
     */
    public static DataSource getDataSource() {
        return ((DataSource) Toolkit.getSpringBean(CommonConstants.DEFAULT_DATA_SOURCE_NAME));
    }

    /**
     * 该方法返回的数据源获取Connection无法保证在同一事务中
     * 
     * @return
     */
    public static DataSource getDataSource(String dataSourceName) {
        return ((DataSource) Toolkit.getSpringBean(dataSourceName));
    }

}
