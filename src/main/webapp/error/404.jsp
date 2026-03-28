<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>页面未找到 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            max-width: 500px;
        }
        .error-icon {
            font-size: 4rem;
            color: #6c757d;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="error-card">
        <div class="error-icon">🗺️</div>
        <h1 class="display-4 text-muted">404</h1>
        <h3 class="mb-3">页面未找到</h3>
        <p class="text-muted mb-4">抱歉，您访问的页面不存在或已被移除。</p>
        
        <div class="d-grid gap-2">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">返回首页</a>
            <a href="${pageContext.request.contextPath}/admin/" class="btn btn-outline-secondary">管理员控制台</a>
            <a href="${pageContext.request.contextPath}/test-db" class="btn btn-outline-info btn-sm">测试数据库连接</a>
        </div>
        
        <hr class="mt-4">
        <small class="text-muted">
            如果您认为这是一个错误，请联系系统管理员。<br>
            请求路径: ${pageContext.request.requestURI}
        </small>
    </div>
</body>
</html>
