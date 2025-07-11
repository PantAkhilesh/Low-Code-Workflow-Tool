package com.workflow.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/workflow_automation";
    private static final String USERNAME = "root";
    private static final String PASSWORD = ""; // or your MySQL password

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Return connection
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
