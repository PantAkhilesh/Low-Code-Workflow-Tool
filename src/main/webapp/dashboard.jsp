<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
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

<html>
<head>
    <title>Dashboard</title>
</head>
<body>
    <h2>Your Workflows</h2>

    <div style="display: flex; justify-content: space-between; margin-bottom: 20px;">
        <!-- Create Workflow Button -->
        <a href="create_workflow.jsp">+ Create New Workflow</a>

        <!-- Logout Button -->
        <form action="LogoutServlet" method="post">
            <button type="submit" style="background-color: red; color: white;">Logout</button>
        </form>
    </div>

    <table border="1" style="width:100%; text-align:left;">
        <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Created At</th>
            <th>Actions</th>
        </tr>
        <%
            for (Map<String, String> wf : workflows) {
        %>
        <tr>
            <td><%= wf.get("name") %></td>
            <td><%= wf.get("description") %></td>
            <td><%= wf.get("createdAt") %></td>
            <td>
                <a href="viewWorkflow.jsp?id=<%= wf.get("id") %>">View</a> |
                <a href="viewTask?workflowId=<%= wf.get("id") %>">View Tasks</a> |
                <a href="create_task.jsp?workflowId=<%= wf.get("id") %>">+ Add Task</a>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</body>
</html>
