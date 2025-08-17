package com.workflow.servlets;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/deleteWorkflow")
public class DeleteWorkflowServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/workflow_automation";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int workflowId = Integer.parseInt(request.getParameter("id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Delete associated tasks first
            String deleteTasksSql = "DELETE FROM tasks WHERE workflow_id = ?";
            PreparedStatement deleteTasksStmt = conn.prepareStatement(deleteTasksSql);
            deleteTasksStmt.setInt(1, workflowId);
            deleteTasksStmt.executeUpdate();
            deleteTasksStmt.close();

            // Delete the workflow
            String deleteWorkflowSql = "DELETE FROM workflows WHERE id = ?";
            PreparedStatement deleteWorkflowStmt = conn.prepareStatement(deleteWorkflowSql);
            deleteWorkflowStmt.setInt(1, workflowId);
            deleteWorkflowStmt.executeUpdate();
            deleteWorkflowStmt.close();

            conn.close();
            response.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=Unable+to+delete+workflow");
        }
    }
}
