package com.workflow.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/deleteTask")
public class DeleteTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/workflow_automation";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String taskId = request.getParameter("taskId");
        String workflowId = request.getParameter("workflowId");

        if (taskId == null || workflowId == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "DELETE FROM tasks WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(taskId));
            stmt.executeUpdate();

            stmt.close();
            conn.close();

            // Redirect back to view tasks for the same workflow
            response.sendRedirect("viewTask?workflowId=" + workflowId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to delete task.");
            request.getRequestDispatcher("view_task.jsp").forward(request, response);
        }
    }
}
