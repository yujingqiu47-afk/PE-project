<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户登录 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            padding: 40px;
            width: 100%;
            max-width: 400px;
        }
        .brand-logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .brand-logo h2 {
            color: #667eea;
            font-weight: bold;
        }
        .form-control {
            border-radius: 25px;
            padding: 12px 20px;
            border: 2px solid #e9ecef;
            margin-bottom: 20px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 12px;
            font-weight: bold;
            width: 100%;
            margin-top: 20px;
        }
        .btn-login:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .links {
            text-align: center;
            margin-top: 20px;
        }
        .links a {
            color: #667eea;
            text-decoration: none;
        }
        .links a:hover {
            text-decoration: underline;
        }
        .role-selection {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 15px;
            margin: 15px 0;
        }
        .form-check-label {
            cursor: pointer;
            padding: 8px 12px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .form-check-input:checked + .form-check-label {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .form-check-label:hover {
            background: #e9ecef;
        }
        .form-check-input:checked + .form-check-label:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="brand-logo">
            <h2>梦想旅行社</h2>
            <p class="text-muted">用户登录</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="LoginServlet" method="post" id="loginForm">
            <!-- 隐藏字段：重定向URL -->
            <c:if test="${not empty param.redirect}">
                <input type="hidden" name="redirect" value="${param.redirect}">
            </c:if>
            <c:if test="${not empty redirect}">
                <input type="hidden" name="redirect" value="${redirect}">
            </c:if>

            <div class="mb-3">
                <input type="text" class="form-control" id="username" name="username"
                       placeholder="用户名" required autocomplete="username">
            </div>

            <div class="mb-3">
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="密码" required autocomplete="current-password">
            </div>

            <!-- 角色选择 -->
            <div class="mb-3 role-selection">
                <label class="form-label fw-bold">🎭 选择登录身份</label>
                <div class="d-flex gap-2 mt-2">
                    <div class="form-check flex-fill">
                        <input class="form-check-input" type="radio" name="loginRole" id="userRole" value="user" checked>
                        <label class="form-check-label w-100 text-center" for="userRole">
                            <i class="bi bi-person"></i> 普通用户
                        </label>
                    </div>
                    <div class="form-check flex-fill">
                        <input class="form-check-input" type="radio" name="loginRole" id="adminRole" value="admin">
                        <label class="form-check-label w-100 text-center" for="adminRole">
                            <i class="bi bi-person-gear"></i> 管理员
                        </label>
                    </div>
                </div>
                <small class="form-text text-muted d-block mt-2">📝 请选择您要登录的身份类型</small>
            </div>
            <button type="submit" class="btn btn-primary btn-login">登录</button>
        </form>

        <div class="links">
            <p>还没有账户？ <a href="register.jsp">立即注册</a></p>
            <p><a href="index.jsp">返回首页</a></p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 表单验证
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            const selectedRole = document.querySelector('input[name="loginRole"]:checked').value;

            if (!username || !password) {
                e.preventDefault();
                alert('请填写用户名和密码');
                return;
            }

            if (username.length < 3) {
                e.preventDefault();
                alert('用户名至少需要3个字符');
                return;
            }

            if (password.length < 6) {
                e.preventDefault();
                alert('密码至少需要6个字符');
                return;
            }

            // 管理员登录提示
            if (selectedRole === 'admin' && username !== 'admin') {
                const confirmAdmin = confirm('您选择了管理员登录，请确认您的账号是否正确？');
                if (!confirmAdmin) {
                    e.preventDefault();
                    return;
                }
            }
        });
    </script>
</body>
</html>
