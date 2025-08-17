package com.workflow.servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/createTask")
public class CreateTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/workflow_automation";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        if (userId == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String taskName = request.getParameter("taskName");
        String description = request.getParameter("description");
        String dueDateStr = request.getParameter("dueDate");
        String assignedToStr = request.getParameter("assignedTo");
        String workflowIdStr = request.getParameter("workflowId");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO tasks (workflow_id, task_name, description, assigned_to, due_date) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setInt(1, Integer.parseInt(workflowIdStr));
            stmt.setString(2, taskName);
            stmt.setString(3, description != null ? description : null);

            if (assignedToStr != null && !assignedToStr.isEmpty()) {
                stmt.setInt(4, Integer.parseInt(assignedToStr));
            } else {
                stmt.setNull(4, Types.INTEGER);
            }

            if (dueDateStr != null && !dueDateStr.isEmpty()) {
                stmt.setDate(5, Date.valueOf(dueDateStr));
            } else {
                stmt.setNull(5, Types.DATE);
            }

            stmt.executeUpdate();
            stmt.close();
            conn.close();

            response.sendRedirect("dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error creating task: " + e.getMessage());
            request.getRequestDispatcher("create_task.jsp").forward(request, response);
        }
    }
}
