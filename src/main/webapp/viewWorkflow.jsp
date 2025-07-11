<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String workflowId = request.getParameter("id");
    if (workflowId == null) {
        out.println("<h3>No workflow selected</h3>");
        return;
    }

    String workflowName = "";
    String description = "";
    String createdAt = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/workflow_automation", "root", "");
        String sql = "SELECT * FROM workflows WHERE id = ? AND created_by = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(workflowId));
        stmt.setInt(2, userId);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            workflowName = rs.getString("workflow_name");
            description = rs.getString("description");
            createdAt = rs.getString("created_at");
        } else {
            out.println("<h3>No such workflow found or you don't have access.</h3>");
            return;
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error fetching workflow: " + e.getMessage() + "</p>");
    }
%>

<html>
<head>
    <title>View Workflow</title>
</head>
<body>
    <h2>Workflow Details</h2>
    <p><strong>Name:</strong> <%= workflowName %></p>
    <p><strong>Description:</strong> <%= description %></p>
    <p><strong>Created At:</strong> <%= createdAt %></p>

    <hr>

    <!-- Optional: Future extension for tasks under this workflow -->
    <a href="dashboard.jsp">← Back to Dashboard</a>
</body>
</html>
