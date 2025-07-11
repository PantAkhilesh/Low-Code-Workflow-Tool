<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>View Tasks</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f8f9fa;
            padding: 20px;
        }
        h2 { color: #333; }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #343a40;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .button {
            padding: 6px 12px;
            text-decoration: none;
            border-radius: 5px;
            color: white;
            background-color: #007BFF;
        }
        .button:hover {
            background-color: #0056b3;
        }
        .danger {
            background-color: red;
        }
        .danger:hover {
            background-color: darkred;
        }
    </style>
</head>
<body>

<h2>Tasks for Workflow ID: ${workflowId}</h2>

<c:if test="${not empty errorMessage}">
    <p style="color:red;">${errorMessage}</p>
</c:if>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Task Name</th>
        <th>Description</th>
        <th>Assigned To</th>
        <th>Due Date</th>
        <th>Created At</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="task" items="${tasks}">
        <tr>
            <td>${task.id}</td>
            <td>${task.task_name}</td>
            <td>${task.description}</td>
            <td>
                <c:choose>
                    <c:when test="${task.assigned_to != null}">
                        ${task.assigned_to}
                    </c:when>
                    <c:otherwise>
                        Unassigned
                    </c:otherwise>
                </c:choose>
            </td>
            <td><c:out value="${task.due_date}" /></td>
            <td><c:out value="${task.created_at}" /></td>
            <td>
                <a class="button" href="editTask.jsp?taskId=${task.id}&workflowId=${workflowId}">Edit</a>
                <a class="button danger"
                   href="deleteTask?taskId=${task.id}&workflowId=${workflowId}"
                   onclick="return confirm('Are you sure you want to delete this task?');">Delete</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

<br/>
<a class="button" href="dashboard.jsp">Back to Dashboard</a>
<a class="button" href="create_task.jsp?workflowId=${workflowId}">+ Add New Task</a>

</body>
</html>
