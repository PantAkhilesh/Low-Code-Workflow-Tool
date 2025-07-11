<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Edit Task</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background-color: #f2f2f2;
        }
        form {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            max-width: 500px;
            margin: auto;
        }
        input, textarea, select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            box-sizing: border-box;
        }
        input[type=submit] {
            background-color: #28a745;
            color: white;
            border: none;
            cursor: pointer;
        }
        input[type=submit]:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <h2>Edit Task</h2>

    <c:if test="${not empty errorMessage}">
        <p style="color:red;">${errorMessage}</p>
    </c:if>

    <form action="editTask" method="post">
        <input type="hidden" name="taskId" value="${task.id}" />
        <input type="hidden" name="workflowId" value="${workflowId}" />

        <label>Task Name:</label>
        <input type="text" name="taskName" value="${task.task_name}" required />

        <label>Description:</label>
        <textarea name="description">${task.description}</textarea>

        <label>Assigned To (User ID):</label>
        <input type="number" name="assignedTo" value="${task.assigned_to}" />

        <label>Due Date:</label>
        <input type="date" name="dueDate" value="${task.due_date}" />

        <input type="submit" value="Update Task" />
    </form>
</body>
</html>
