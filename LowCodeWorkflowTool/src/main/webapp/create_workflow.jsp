<%@ page session="true" %>
<%@ include file="navbar.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Workflow</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4">Create New Workflow</h2>

    <form action="createWorkflow" method="post" class="needs-validation" novalidate>
        <div class="mb-3">
            <label for="workflowName" class="form-label">Workflow Name</label>
            <input type="text" class="form-control" id="workflowName" name="workflowName" required>
            <div class="invalid-feedback">
                Please provide a workflow name.
            </div>
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">Description</label>
            <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
            <div class="invalid-feedback">
                Please provide a description.
            </div>
        </div>

        <button type="submit" class="btn btn-primary">Create Workflow</button>
        <a href="dashboard.jsp" class="btn btn-secondary ms-2">Back to Dashboard</a>
    </form>
</div>

<%@ include file="footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Enable Bootstrap form validation
    (() => {
        'use strict'
        const forms = document.querySelectorAll('.needs-validation')
        Array.from(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault()
                    event.stopPropagation()
                }
                form.classList.add('was-validated')
            }, false)
        })
    })()
</script>
</body>
</html>
