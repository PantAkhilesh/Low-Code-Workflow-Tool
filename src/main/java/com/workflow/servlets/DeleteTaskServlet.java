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

        String taskIdStr = request.getParameter("taskId");
        String workflowIdStr = request.getParameter("workflowId");

        if (taskIdStr == null || workflowIdStr == null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        int taskId = Integer.parseInt(taskIdStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "DELETE FROM tasks WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, taskId);
            stmt.executeUpdate();

            stmt.close();
            conn.close();

            response.sendRedirect("viewTask?workflowId=" + workflowIdStr);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error deleting task: " + e.getMessage());
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
}
