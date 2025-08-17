package com.workflow.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/editTask")
public class EditTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/workflow_automation";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int taskId = Integer.parseInt(request.getParameter("taskId"));
        int workflowId = Integer.parseInt(request.getParameter("workflowId"));
        String taskName = request.getParameter("taskName");
        String description = request.getParameter("description");
        String assignedToStr = request.getParameter("assignedTo");
        String dueDate = request.getParameter("dueDate");

        Integer assignedTo = (assignedToStr == null || assignedToStr.isEmpty()) ? null : Integer.parseInt(assignedToStr);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "UPDATE tasks SET task_name = ?, description = ?, assigned_to = ?, due_date = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, taskName);
            stmt.setString(2, description);
            if (assignedTo != null) {
                stmt.setInt(3, assignedTo);
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            stmt.setString(4, dueDate);
            stmt.setInt(5, taskId);

            stmt.executeUpdate();
            stmt.close();
            conn.close();

            response.sendRedirect("viewTask?workflowId=" + workflowId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating task: " + e.getMessage());
            request.getRequestDispatcher("editTask.jsp").forward(request, response);
        }
    }
}
