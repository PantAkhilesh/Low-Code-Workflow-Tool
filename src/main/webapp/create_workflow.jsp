<%@ page session="false" %>
<html>
<head>
    <title>Create Workflow</title>
</head>
<body>
    <h2>Create New Workflow</h2>

    <form action="createWorkflow" method="post">
        <input type="text" name="workflowName" placeholder="Workflow Name" required />
        <br>
        <textarea name="description" placeholder="Description" required></textarea>
        <br>
        <button type="submit">Create Workflow</button>
    </form>

    <br><a href="dashboard.jsp">Back to Dashboard</a>
</body>
</html>
