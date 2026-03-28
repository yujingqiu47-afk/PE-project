<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - 服务器错误 | 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
    <style>
        .error-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .error-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 50px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            color: #333;
            max-width: 650px;
            margin: 20px;
        }
        .error-code {
            font-size: 8rem;
            font-weight: bold;
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            line-height: 1;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 2.5rem;
            margin-bottom: 20px;
            color: #333;
        }
        .error-description {
            font-size: 1.2rem;
            margin-bottom: 30px;
            color: #666;
            line-height: 1.6;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-gradient {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-gradient:hover {
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(220, 53, 69, 0.4);
        }
        .btn-outline {
            background: transparent;
            border: 2px solid #dc3545;
            color: #dc3545;
            padding: 10px 30px;
            border-radius: 50px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-outline:hover {
            background: #dc3545;
            color: white;
            transform: translateY(-2px);
        }
        .error-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.8;
        }
        .help-section {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid #eee;
        }
        .help-title {
            font-size: 1.3rem;
            margin-bottom: 15px;
            color: #333;
        }
        .help-list {
            text-align: left;
            color: #666;
            margin-bottom: 0;
        }
        .help-list li {
            margin-bottom: 8px;
        }
        .error-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
            border-left: 4px solid #dc3545;
        }
        .error-details h4 {
            color: #dc3545;
            margin-bottom: 10px;
            font-size: 1.1rem;
        }
        .error-details p {
            margin: 0;
            color: #666;
            font-size: 0.9rem;
            font-family: monospace;
        }
        .maintenance-info {
            background: linear-gradient(135deg, #17a2b8 0%, #20c997 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-card">
            <div class="error-icon">🚨</div>
            <div class="error-code">500</div>
            <h1 class="error-title">服务器内部错误</h1>
            <p class="error-description">
                抱歉，服务器遇到了意外错误，无法完成您的请求。<br>
                我们的技术团队已经收到了错误报告，正在紧急处理中。
            </p>
            
            <% if (exception != null && request.getParameter("debug") != null) { %>
            <div class="error-details">
                <h4>🔍 错误详情</h4>
                <p>错误类型: <%= exception.getClass().getSimpleName() %></p>
                <p>错误信息: <%= exception.getMessage() != null ? exception.getMessage() : "无详细信息" %></p>
                <p>请求时间: <%= new java.util.Date() %></p>
                <p>请求URI: <%= request.getRequestURI() %></p>
            </div>
            <% } %>
            
            <div class="action-buttons">
                <a href="javascript:location.reload()" class="btn-outline">重新加载</a>
                <a href="../index.jsp" class="btn-gradient">回到首页</a>
            </div>
            
            <div class="maintenance-info">
                <h4>🔧 系统维护提醒</h4>
                <p>如果您经常遇到此问题，可能是系统正在维护。我们通常在凌晨 2:00-6:00 进行系统维护，请在此时间段外重试。</p>
            </div>
            
            <div class="help-section">
                <h3 class="help-title">您可以尝试：</h3>
                <ul class="help-list">
                    <li>稍等片刻后刷新页面重试</li>
                    <li>检查您的网络连接是否正常</li>
                    <li>返回首页重新开始操作</li>
                    <li>如果是在进行预订，请稍后重试</li>
                    <li>联系我们的技术支持获取帮助</li>
                </ul>
            </div>
            
            <div class="mt-4">
                <p class="text-muted">
                    <strong>紧急技术支持：</strong><br>
                    24小时技术热线：400-123-4567<br>
                    技术支持邮箱：tech@dreamtravel.com<br>
                    在线客服：周一至周日 8:00-22:00
                </p>
            </div>
            
            <div class="mt-3">
                <small class="text-muted">
                    错误ID: ERR-<%= System.currentTimeMillis() %><br>
                    报告时间: <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %>
                </small>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 添加简单的动画效果
        window.addEventListener('load', function() {
            const card = document.querySelector('.error-card');
            card.style.opacity = '0';
            card.style.transform = 'translateY(50px)';
            card.style.transition = 'all 0.6s ease';
            
            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 100);
        });

        // 自动重试功能（可选）
        let retryCount = 0;
        const maxRetries = 3;
        
        function autoRetry() {
            if (retryCount < maxRetries) {
                retryCount++;
                console.log(`自动重试第 ${retryCount} 次...`);
                setTimeout(() => {
                    location.reload();
                }, 30000); // 30秒后自动重试
            }
        }
        
        // 可以根据需要启用自动重试
        // autoRetry();
    </script>
</body>
</html> 