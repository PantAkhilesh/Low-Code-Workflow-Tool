<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Map, java.util.HashMap" %>
<%@ page session="true" %>
<%
    int taskId = Integer.parseInt(request.getParameter("taskId"));
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    Map<String, String> task = new HashMap<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/workflow_automation", "root", "");
        stmt = conn.prepareStatement("SELECT * FROM tasks WHERE id = ?");
        stmt.setInt(1, taskId);
        rs = stmt.executeQuery();

        if (rs.next()) {
            task.put("id", rs.getString("id"));
            task.put("task_name", rs.getString("task_name"));
            task.put("description", rs.getString("description"));
            task.put("assigned_to", rs.getString("assigned_to"));
            task.put("due_date", rs.getString("due_date"));
            task.put("workflow_id", rs.getString("workflow_id"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); if (stmt != null) stmt.close(); if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<html>
<head>
    <title>Edit Task</title>
</head>
<body>
    <h2>Edit Task</h2>
    <form action="editTask" method="post">
        <input type="hidden" name="taskId" value="<%= task.get("id") %>"/>
        <input type="hidden" name="workflowId" value="<%= task.get("workflow_id") %>"/>

        <label>Task Name:</label><br/>
        <input type="text" name="taskName" value="<%= task.get("task_name") %>" required/><br/><br/>

        <label>Description:</label><br/>
        <textarea name="description"><%= task.get("description") %></textarea><br/><br/>

        <label>Assigned To (User ID):</label><br/>
        <input type="number" name="assignedTo" value="<%= task.get("assigned_to") %>"/><br/><br/>

        <label>Due Date:</label><br/>
        <input type="date" name="dueDate" value="<%= task.get("due_date") %>"/><br/><br/>

        <button type="submit">Update Task</button>
    </form>

    <br/>
    <a href="viewTask?workflowId=<%= task.get("workflow_id") %>">Cancel</a>
</body>
</html>
