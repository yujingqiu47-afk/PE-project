<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0;
        }
        .register-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            padding: 40px;
            width: 100%;
            max-width: 450px;
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
            margin-bottom: 15px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 12px;
            font-weight: bold;
            width: 100%;
            margin-top: 20px;
        }
        .btn-register:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .password-strength {
            height: 5px;
            border-radius: 3px;
            transition: all 0.3s;
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
    </style>
</head>
<body>
    <div class="register-card">
        <div class="brand-logo">
            <h2>梦想旅行社</h2>
            <p class="text-muted">新用户注册</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="RegisterServlet" method="post" id="registerForm">
            <div class="mb-3">
                <input type="text" class="form-control" id="username" name="username" 
                       placeholder="用户名 (3-20个字符)" required>
                <small class="form-text text-muted">用户名只能包含字母、数字和下划线</small>
            </div>
            
            <div class="mb-3">
                <input type="email" class="form-control" id="email" name="email" 
                       placeholder="邮箱地址" required>
            </div>
            
            <div class="mb-3">
                <input type="password" class="form-control" id="password" name="password" 
                       placeholder="密码 (至少6个字符)" required>
                <div class="password-strength mt-1" id="passwordStrength"></div>
                <small class="form-text text-muted" id="passwordHelp">密码强度</small>
            </div>
            
            <div class="mb-3">
                <input type="password" class="form-control" id="confirmPassword" 
                       placeholder="确认密码" required>
                <small class="form-text" id="passwordMatch"></small>
            </div>
            
            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="terms" required>
                <label class="form-check-label" for="terms">
                    我已阅读并同意 <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">服务条款</a> 和 <a href="#" data-bs-toggle="modal" data-bs-target="#privacyModal">隐私政策</a>
                </label>
            </div>
            
            <button type="submit" class="btn btn-primary btn-register">注册</button>
        </form>

        <div class="links">
            <p>已有账户？ <a href="login.jsp">立即登录</a></p>
            <p><a href="index.jsp">返回首页</a></p>
        </div>
    </div>

    <!-- 服务条款模态框 -->
    <div class="modal fade" id="termsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">服务条款</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6>1. 服务说明</h6>
                    <p>梦想旅行社为用户提供旅游信息查询、预订等服务。</p>
                    
                    <h6>2. 用户责任</h6>
                    <p>用户需提供真实、准确的个人信息，并对账户安全负责。</p>
                    
                    <h6>3. 服务变更</h6>
                    <p>我们保留随时修改或终止服务的权利。</p>
                    
                    <h6>4. 免责声明</h6>
                    <p>对于不可抗力因素导致的服务中断，本公司不承担责任。</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 隐私政策模态框 -->
    <div class="modal fade" id="privacyModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">隐私政策</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6>1. 信息收集</h6>
                    <p>我们收集您提供的注册信息和使用服务时产生的数据。</p>
                    
                    <h6>2. 信息使用</h6>
                    <p>收集的信息仅用于提供服务、改善用户体验和法律要求。</p>
                    
                    <h6>3. 信息保护</h6>
                    <p>我们采取合理的安全措施保护您的个人信息。</p>
                    
                    <h6>4. 信息共享</h6>
                    <p>除法律要求外，我们不会向第三方分享您的个人信息。</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 密码强度检测
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrength');
            const helpText = document.getElementById('passwordHelp');
            
            let strength = 0;
            let text = '';
            
            if (password.length >= 6) strength++;
            if (password.match(/[a-z]/)) strength++;
            if (password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^a-zA-Z0-9]/)) strength++;
            
            switch(strength) {
                case 0:
                case 1:
                    strengthBar.style.backgroundColor = '#dc3545';
                    strengthBar.style.width = '20%';
                    text = '密码强度：弱';
                    break;
                case 2:
                    strengthBar.style.backgroundColor = '#fd7e14';
                    strengthBar.style.width = '40%';
                    text = '密码强度：一般';
                    break;
                case 3:
                    strengthBar.style.backgroundColor = '#ffc107';
                    strengthBar.style.width = '60%';
                    text = '密码强度：中等';
                    break;
                case 4:
                    strengthBar.style.backgroundColor = '#20c997';
                    strengthBar.style.width = '80%';
                    text = '密码强度：强';
                    break;
                case 5:
                    strengthBar.style.backgroundColor = '#28a745';
                    strengthBar.style.width = '100%';
                    text = '密码强度：很强';
                    break;
            }
            
            helpText.textContent = text;
        });

        // 密码确认检查
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            const matchText = document.getElementById('passwordMatch');
            
            if (confirmPassword.length > 0) {
                if (password === confirmPassword) {
                    matchText.textContent = '密码匹配';
                    matchText.className = 'form-text text-success';
                } else {
                    matchText.textContent = '密码不匹配';
                    matchText.className = 'form-text text-danger';
                }
            } else {
                matchText.textContent = '';
            }
        });

        // 表单验证
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('terms').checked;

            // 用户名验证
            if (!username || username.length < 3 || username.length > 20) {
                e.preventDefault();
                alert('用户名必须为3-20个字符');
                return;
            }
            
            const usernameRegex = /^[a-zA-Z0-9_]+$/;
            if (!usernameRegex.test(username)) {
                e.preventDefault();
                alert('用户名只能包含字母、数字和下划线');
                return;
            }

            // 邮箱验证
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('请输入有效的邮箱地址');
                return;
            }

            // 密码验证
            if (password.length < 6) {
                e.preventDefault();
                alert('密码至少需要6个字符');
                return;
            }

            // 密码确认验证
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('两次输入的密码不一致');
                return;
            }

            // 服务条款验证
            if (!terms) {
                e.preventDefault();
                alert('请同意服务条款和隐私政策');
                return;
            }
        });
    </script>
</body>
</html>
