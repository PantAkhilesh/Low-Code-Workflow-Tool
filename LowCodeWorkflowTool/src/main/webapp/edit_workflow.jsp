<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String workflowId = request.getParameter("id");
    String workflowName = "";
    String workflowDesc = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/workflow_automation", "root", "");
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM workflows WHERE id = ?");
        stmt.setInt(1, Integer.parseInt(workflowId));
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            workflowName = rs.getString("workflow_name");
            workflowDesc = rs.getString("description");
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
    <title>Edit Workflow</title>
</head>
<body>
    <h2>Edit Workflow</h2>
    <form action="EditWorkflowServlet" method="post">
        <input type="hidden" name="id" value="<%= workflowId %>"/>
        <label>Workflow Name:</label><br/>
        <input type="text" name="workflowName" value="<%= workflowName %>" required/><br/><br/>
        <label>Description:</label><br/>
        <textarea name="description"><%= workflowDesc %></textarea><br/><br/>
        <button type="submit">Save Changes</button>
    </form>
    <br/>
    <a href="dashboard.jsp">Back to Dashboard</a>
</body>
</html>
