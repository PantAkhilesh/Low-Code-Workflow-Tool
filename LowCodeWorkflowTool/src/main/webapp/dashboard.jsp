<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%@ include file="navbar.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    List<Map<String, String>> workflows = new ArrayList<>();
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/workflow_automation", "root", "");
        String sql = "SELECT * FROM workflows WHERE created_by = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> row = new HashMap<>();
            row.put("id", rs.getString("id"));
            row.put("name", rs.getString("workflow_name"));
            row.put("description", rs.getString("description"));
            row.put("createdAt", rs.getString("created_at"));
            workflows.add(row);
        }
        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Your Workflows</h2>
        <div>
            <a href="create_workflow.jsp" class="btn btn-success me-2">+ New Workflow</a>
            <form action="LogoutServlet" method="post" class="d-inline">
                <button type="submit" class="btn btn-danger">Logout</button>
            </form>
        </div>
    </div>

    <table class="table table-bordered table-hover shadow">
        <thead class="table-dark">
        <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Created At</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            for (Map<String, String> wf : workflows) {
        %>
        <tr>
            <td><%= wf.get("name") %></td>
            <td><%= wf.get("description") %></td>
            <td><%= wf.get("createdAt") %></td>
            <td>
                <a href="viewWorkflow.jsp?id=<%= wf.get("id") %>" class="btn btn-sm btn-primary">View</a>
                <a href="viewTask?workflowId=<%= wf.get("id") %>" class="btn btn-sm btn-info">Tasks</a>
                <a href="create_task.jsp?workflowId=<%= wf.get("id") %>" class="btn btn-sm btn-success">+ Task</a>
                <a href="edit_workflow.jsp?id=<%= wf.get("id") %>" class="btn btn-sm btn-warning">Edit</a>
                <a href="deleteWorkflow?id=<%= wf.get("id") %>" class="btn btn-sm btn-danger"
                   onclick="return confirm('Are you sure you want to delete this workflow?');">Delete</a>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
