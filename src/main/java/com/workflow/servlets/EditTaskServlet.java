package com.workflow.servlets;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;

@WebServlet("/editTask")
public class EditTaskServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/workflow_automation";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        int workflowId = Integer.parseInt(request.getParameter("workflowId"));

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            String sql = "SELECT * FROM tasks WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, taskId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("task", rsToTask(rs));
                request.setAttribute("workflowId", workflowId);
                RequestDispatcher dispatcher = request.getRequestDispatcher("editTask.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("viewTasks?workflowId=" + workflowId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int taskId = Integer.parseInt(request.getParameter("taskId"));
        int workflowId = Integer.parseInt(request.getParameter("workflowId"));
        String taskName = request.getParameter("taskName");
        String description = request.getParameter("description");
        String assignedToStr = request.getParameter("assignedTo");
        String dueDateStr = request.getParameter("dueDate");

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
            String sql = "UPDATE tasks SET task_name = ?, description = ?, assigned_to = ?, due_date = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, taskName);
            stmt.setString(2, description);
            if (assignedToStr != null && !assignedToStr.isEmpty()) {
                stmt.setInt(3, Integer.parseInt(assignedToStr));
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            if (dueDateStr != null && !dueDateStr.isEmpty()) {
                stmt.setDate(4, Date.valueOf(LocalDate.parse(dueDateStr)));
            } else {
                stmt.setNull(4, Types.DATE);
            }
            stmt.setInt(5, taskId);

            stmt.executeUpdate();
            response.sendRedirect("viewTasks?workflowId=" + workflowId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error updating task: " + e.getMessage());
            request.getRequestDispatcher("editTask.jsp").forward(request, response);
        }
    }

    private Task rsToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setId(rs.getInt("id"));
        task.setTask_name(rs.getString("task_name"));
        task.setDescription(rs.getString("description"));
        task.setAssigned_to(rs.getInt("assigned_to"));
        task.setDue_date(rs.getDate("due_date"));
        task.setCreated_at(rs.getTimestamp("created_at"));
        return task;
    }

    // Dummy Task class. Replace with your actual Task bean or model.
    public class Task {
        private int id;
        private String task_name;
        private String description;
        private int assigned_to;
        private Date due_date;
        private Timestamp created_at;

        // Getters
        public int getId() {
            return id;
        }

        public String getTask_name() {
            return task_name;
        }

        public String getDescription() {
            return description;
        }

        public int getAssigned_to() {
            return assigned_to;
        }

        public Date getDue_date() {
            return due_date;
        }

        public Timestamp getCreated_at() {
            return created_at;
        }

        // Setters
        public void setId(int id) {
            this.id = id;
        }

        public void setTask_name(String task_name) {
            this.task_name = task_name;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public void setAssigned_to(int assigned_to) {
            this.assigned_to = assigned_to;
        }

        public void setDue_date(Date due_date) {
            this.due_date = due_date;
        }

        public void setCreated_at(Timestamp created_at) {
            this.created_at = created_at;
        }
    }

}
