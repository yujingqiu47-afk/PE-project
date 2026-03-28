<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户反馈 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .feedback-section {
            padding: 100px 0;
            background: #f8f9fa;
        }

        .text-gradient {
            background: linear-gradient(45deg, #007bff, #28a745);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .feedback-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 40px;
            margin-top: -50px;
        }
        .star-rating {
            color: #ffc107;
            font-size: 1.5rem;
        }
        .star-rating .star {
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .star-rating .star:hover {
            transform: scale(1.2);
        }
        .hero-small {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 0;
            position: relative;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow">
        <div class="container">
            <a class="navbar-brand text-gradient fw-bold" href="index.jsp">梦想旅行社</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">首页</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="destinations">目的地</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="FeedbackServlet">用户反馈</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="my-bookings">我的预定</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.username}">
                            <li class="nav-item">
                                <span class="nav-link">欢迎，${sessionScope.username}</span>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="LogoutServlet">退出登录</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="login.jsp">登录</a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-primary ms-2" href="register.jsp">立即注册</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 页面标题 -->
    <section class="hero-small">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <h1 class="display-5 fw-bold mb-3">用户反馈</h1>
                    <p class="lead">您的意见对我们很重要，请分享您的旅行体验和建议</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 反馈表单区域 -->
    <section class="feedback-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="feedback-card">
                        <h3 class="text-center mb-4">分享您的体验</h3>

                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="FeedbackServlet" method="post" id="feedbackForm">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="customerName" class="form-label">您的姓名 <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="customerName" name="customerName" 
                                           value="${not empty currentUser ? currentUser.username : (not empty param.customerName ? param.customerName : '')}" required>
                                    <c:if test="${not empty currentUser}">
                                        <small class="form-text text-muted">已自动填充为账户信息</small>
                                    </c:if>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="customerEmail" class="form-label">邮箱地址 <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="customerEmail" name="customerEmail" 
                                           value="${not empty currentUser ? currentUser.email : (not empty param.customerEmail ? param.customerEmail : '')}" required>
                                    <c:if test="${not empty currentUser}">
                                        <small class="form-text text-muted">已自动填充为账户信息</small>
                                    </c:if>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="destination" class="form-label">您体验的目的地（可选）</label>
                                <select class="form-select" id="destination" name="destination">
                                    <option value="">请选择目的地</option>
                                    <option value="海洋水族馆">海洋水族馆</option>
                                    <option value="蜜蜂农场">蜜蜂农场</option>
                                    <option value="科技体验馆">科技体验馆</option>
                                    <option value="自然探索之旅">自然探索之旅</option>
                                    <option value="其他">其他</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">整体满意度 <span class="text-danger">*</span></label>
                                <div class="star-rating" id="starRating">
                                    <span class="star" data-rating="1">★</span>
                                    <span class="star" data-rating="2">★</span>
                                    <span class="star" data-rating="3">★</span>
                                    <span class="star" data-rating="4">★</span>
                                    <span class="star" data-rating="5">★</span>
                                </div>
                                <input type="hidden" id="rating" name="rating" value="" required>
                                <small class="form-text text-muted">请点击星星进行评分（1-5星）</small>
                            </div>

                            <div class="mb-3">
                                <label for="feedbackType" class="form-label">反馈类型 <span class="text-danger">*</span></label>
                                <select class="form-select" id="feedbackType" name="feedbackType" required>
                                    <option value="">请选择反馈类型</option>
                                    <option value="服务表扬">服务表扬</option>
                                    <option value="服务投诉">服务投诉</option>
                                    <option value="建议意见">建议意见</option>
                                    <option value="产品咨询">产品咨询</option>
                                    <option value="其他">其他</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="feedbackContent" class="form-label">详细反馈 <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="feedbackContent" name="feedbackContent" rows="5"
                                          placeholder="请详细描述您的体验、建议或遇到的问题..." required></textarea>
                                <small class="form-text text-muted">至少输入10个字符</small>
                            </div>

                            <div class="mb-3">
                                <label for="contactPhone" class="form-label">联系电话（可选）</label>
                                <input type="tel" class="form-control" id="contactPhone" name="contactPhone"
                                       placeholder="如需电话回访，请留下您的联系方式">
                            </div>

                            <div class="mb-3 form-check">
                                <input class="form-check-input" type="checkbox" id="allowContact" name="allowContact" value="true">
                                <label class="form-check-label" for="allowContact">
                                    我同意梦想旅行社就此反馈与我联系
                                </label>
                            </div>

                            <div class="text-center">
                                <button type="submit" class="btn btn-primary btn-lg px-5">提交反馈</button>
                                <button type="reset" class="btn btn-outline-secondary btn-lg px-5 ms-3">重置表单</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- 联系方式卡片 -->
            <div class="row mt-5">
                <div class="col-lg-4">
                    <div class="card h-100 text-center">
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="feature-icon mx-auto">📞</div>
                            </div>
                            <h5 class="card-title">电话咨询</h5>
                            <p class="card-text">客服热线：400-123-4567<br>工作时间：8:00-22:00</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card h-100 text-center">
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="feature-icon mx-auto">📧</div>
                            </div>
                            <h5 class="card-title">邮箱联系</h5>
                            <p class="card-text">客服邮箱：service@dreamtravel.com<br>24小时内回复</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card h-100 text-center">
                        <div class="card-body">
                            <div class="mb-3">
                                <div class="feature-icon mx-auto">💬</div>
                            </div>
                            <h5 class="card-title">在线客服</h5>
                            <p class="card-text">微信客服：DreamTravel2024<br>即时响应</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 页脚 -->
    <footer class="bg-dark text-light py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>梦想旅行社</h5>
                    <p>为您提供最优质的旅游服务体验</p>
                    <p class="mb-0">© 2025 梦想旅行社。版权所有。</p>
                </div>
                <div class="col-md-6">
                    <h5>快速链接</h5>
                    <ul class="list-unstyled">
                        <li><a href="destinations" class="text-light">旅游目的地</a></li>
                        <li><a href="login.jsp" class="text-light">用户登录</a></li>
                        <li><a href="register.jsp" class="text-light">新用户注册</a></li>
                        <li><a href="FeedbackServlet" class="text-light">用户反馈</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 星级评分功能
        document.addEventListener('DOMContentLoaded', function() {
            const stars = document.querySelectorAll('.star');
            const ratingInput = document.getElementById('rating');

            stars.forEach((star, index) => {
                star.addEventListener('click', function() {
                    const rating = this.getAttribute('data-rating');
                    ratingInput.value = rating;

                    // 更新星星显示
                    stars.forEach((s, i) => {
                        if (i < rating) {
                            s.style.color = '#ffc107';
                        } else {
                            s.style.color = '#e0e0e0';
                        }
                    });
                });

                star.addEventListener('mouseover', function() {
                    const rating = this.getAttribute('data-rating');
                    stars.forEach((s, i) => {
                        if (i < rating) {
                            s.style.color = '#ffc107';
                        } else {
                            s.style.color = '#e0e0e0';
                        }
                    });
                });
            });

            // 鼠标离开时恢复当前评分
            document.querySelector('.star-rating').addEventListener('mouseleave', function() {
                const currentRating = ratingInput.value;
                stars.forEach((s, i) => {
                    if (i < currentRating) {
                        s.style.color = '#ffc107';
                    } else {
                        s.style.color = '#e0e0e0';
                    }
                });
            });
        });

        // 表单验证
        document.getElementById('feedbackForm').addEventListener('submit', function(e) {
            const rating = document.getElementById('rating').value;
            const content = document.getElementById('feedbackContent').value;

            if (!rating) {
                e.preventDefault();
                alert('请选择满意度评分！');
                return;
            }

            if (content.length < 10) {
                e.preventDefault();
                alert('反馈内容至少需要10个字符！');
                return;
            }
        });

        // 字符计数
        document.getElementById('feedbackContent').addEventListener('input', function() {
            const content = this.value;
            const minLength = 10;
            const currentLength = content.length;

            if (currentLength < minLength) {
                this.style.borderColor = '#dc3545';
            } else {
                this.style.borderColor = '#198754';
            }
        });
    </script>

    <style>
        .feature-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            margin: 0 auto 20px;
        }

        .star {
            color: #e0e0e0;
        }

        .star.active {
            color: #ffc107;
        }

        .card {
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
    </style>
</body>
</html>
