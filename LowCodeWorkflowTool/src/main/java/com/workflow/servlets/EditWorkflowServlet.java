package com.workflow.servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/EditWorkflowServlet")
public class EditWorkflowServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        String name = request.getParameter("workflowName");
        String desc = request.getParameter("description");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/workflow_automation", "root", "");
            PreparedStatement stmt = conn.prepareStatement("UPDATE workflows SET workflow_name = ?, description = ? WHERE id = ?");
            stmt.setString(1, name);
            stmt.setString(2, desc);
            stmt.setInt(3, Integer.parseInt(id));
            stmt.executeUpdate();

            stmt.close();
            conn.close();

            response.sendRedirect("dashboard.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error updating workflow.");
        }
    }
}
