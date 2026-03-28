<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>400 - 请求错误 | 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
    <style>
        .error-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            max-width: 600px;
            margin: 20px;
        }
        .error-code {
            font-size: 8rem;
            font-weight: bold;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }
        .btn-outline {
            background: transparent;
            border: 2px solid #667eea;
            color: #667eea;
            padding: 10px 30px;
            border-radius: 50px;
            font-weight: bold;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-outline:hover {
            background: #667eea;
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
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-card">
            <div class="error-icon">⚠️</div>
            <div class="error-code">400</div>
            <h1 class="error-title">请求错误</h1>
            <p class="error-description">
                抱歉，您的请求格式不正确或包含无效数据。<br>
                这可能是由于输入了错误的信息或使用了不支持的操作导致的。
            </p>
            
            <div class="action-buttons">
                <a href="javascript:history.back()" class="btn-outline">返回上一页</a>
                <a href="../index.jsp" class="btn-gradient">回到首页</a>
            </div>
            
            <div class="help-section">
                <h3 class="help-title">可能的解决方案：</h3>
                <ul class="help-list">
                    <li>检查表单中是否填写了所有必需的字段</li>
                    <li>确保输入的数据格式正确（如日期、邮箱等）</li>
                    <li>如果是通过链接访问，请检查链接是否完整</li>
                    <li>尝试刷新页面或清除浏览器缓存</li>
                    <li>如果问题持续存在，请联系客服</li>
                </ul>
            </div>
            
            <div class="mt-4">
                <p class="text-muted">
                    <strong>需要帮助？</strong><br>
                    客服热线：400-123-4567<br>
                    在线客服：周一至周日 8:00-22:00
                </p>
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
    </script>
</body>
</html> 