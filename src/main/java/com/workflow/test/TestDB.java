package com.workflow.test;

import java.sql.Connection;
import com.workflow.utils.DBConnection;

public class TestDB {
    public static void main(String[] args) {
        try {
            Connection conn = DBConnection.getConnection();
            if (conn != null) {
                System.out.println("✅ Connected to database successfully!");
                conn.close();
            } else {
                System.out.println("❌ Failed to connect to database.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
