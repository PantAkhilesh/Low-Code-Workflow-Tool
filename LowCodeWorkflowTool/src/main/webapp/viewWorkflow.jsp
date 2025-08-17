<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String workflowId = request.getParameter("id");
    if (workflowId == null || workflowId.trim().isEmpty()) {
        out.println("Invalid workflow ID");
        return;
    }

    String workflowName = "";
    String description = "";
    String createdAt = "";
    int taskCount = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/workflow_automation", "root", "");

        // Get workflow details
        String sql1 = "SELECT * FROM workflows WHERE id = ? AND created_by = ?";
        PreparedStatement stmt1 = conn.prepareStatement(sql1);
        stmt1.setInt(1, Integer.parseInt(workflowId));
        stmt1.setInt(2, userId);
        ResultSet rs1 = stmt1.executeQuery();

        if (rs1.next()) {
            workflowName = rs1.getString("workflow_name");
            description = rs1.getString("description");
            createdAt = rs1.getString("created_at");
        }

        rs1.close();
        stmt1.close();

        // Get task count
        String sql2 = "SELECT COUNT(*) AS task_count FROM tasks WHERE workflow_id = ?";
        PreparedStatement stmt2 = conn.prepareStatement(sql2);
        stmt2.setInt(1, Integer.parseInt(workflowId));
        ResultSet rs2 = stmt2.executeQuery();
        if (rs2.next()) {
            taskCount = rs2.getInt("task_count");
        }
        rs2.close();
        stmt2.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Workflow Details</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4">Workflow Details</h2>

    <div class="card">
        <div class="card-body">
            <p><strong>Name:</strong> <%= workflowName %></p>
            <p><strong>Description:</strong> <%= description %></p>
            <p><strong>Created At:</strong> <%= createdAt %></p>
            <p><strong>Total Tasks:</strong> <%= taskCount %></p>

            <div class="mt-4">
                <a href="viewTask?workflowId=<%= workflowId %>" class="btn btn-primary">View Tasks</a>
                <a href="create_task.jsp?workflowId=<%= workflowId %>" class="btn btn-success ms-2">+ Add New Task</a>
                <a href="dashboard.jsp" class="btn btn-secondary ms-2">Back to Dashboard</a>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
