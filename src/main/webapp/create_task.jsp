<%@ page import="java.util.*, java.sql.*" %>
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

        PreparedStatement stmt = conn.prepareStatement("SELECT id, workflow_name FROM workflows WHERE created_by = ?");
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> wf = new HashMap<>();
            wf.put("id", rs.getString("id"));
            wf.put("name", rs.getString("workflow_name"));
            workflows.add(wf);
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
    <title>Create Task</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h2>Create a New Task</h2>
    <form action="createTask" method="post">
        <label>Workflow:</label>
        <select name="workflowId" required>
            <option value="">--Select Workflow--</option>
            <% for (Map<String, String> wf : workflows) { %>
                <option value="<%= wf.get("id") %>"><%= wf.get("name") %></option>
            <% } %>
        </select>
        <br><br>

        <label>Task Name:</label>
        <input type="text" name="taskName" required />
        <br><br>

        <label>Description:</label>
        <textarea name="description"></textarea>
        <br><br>

        <label>Due Date:</label>
        <input type="date" name="dueDate" />
        <br><br>

        <label>Assign To (User ID):</label>
        <input type="number" name="assignedTo" />
        <br><br>

        <input type="submit" value="Create Task" />
    </form>

    <br>
    <a href="dashboard.jsp">Back to Dashboard</a>
</body>
</html>
