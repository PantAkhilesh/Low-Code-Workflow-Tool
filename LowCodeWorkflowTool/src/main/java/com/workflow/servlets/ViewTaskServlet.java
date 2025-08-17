package com.workflow.servlets;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/viewTask")
public class ViewTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/workflow_automation";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String workflowIdStr = request.getParameter("workflowId");
        if (workflowIdStr == null || workflowIdStr.isEmpty()) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        int workflowId = Integer.parseInt(workflowIdStr);
        List<Map<String, Object>> tasks = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

           String sql = "SELECT t.*, u.username AS assigned_user_name " +
             "FROM tasks t LEFT JOIN users u ON t.assigned_to = u.id " +
             "WHERE t.workflow_id = ?";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, workflowId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> task = new HashMap<>();
                task.put("id", rs.getInt("id"));
                task.put("task_name", rs.getString("task_name"));
                task.put("description", rs.getString("description"));
                //task.put("assigned_to", rs.getObject("assigned_to"));
                task.put("assigned_user_name", rs.getString("assigned_user_name"));
                task.put("due_date", rs.getDate("due_date"));
                task.put("created_at", rs.getTimestamp("created_at"));
                tasks.add(task);
            }

            rs.close();
            stmt.close();
            conn.close();

            request.setAttribute("tasks", tasks);
            request.setAttribute("workflowId", workflowId);
            RequestDispatcher dispatcher = request.getRequestDispatcher("view_task.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to load tasks: " + e.getMessage());
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
}
