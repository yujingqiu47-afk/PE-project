<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${destination.name} 套餐选择 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .package-card {
            transition: transform 0.3s;
            margin-bottom: 30px;
        }
        .package-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .price-tag {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }
        .feature-list {
            list-style: none;
            padding-left: 0;
        }
        .feature-list li {
            padding: 5px 0;
            border-bottom: 1px solid #eee;
        }
        .feature-list li:before {
            content: "✓ ";
            color: #28a745;
            font-weight: bold;
        }
        .text-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        /* 深色背景上的渐变文字效果 */
        .bg-dark .text-gradient {
            background: linear-gradient(135deg, #87ceeb 0%, #98fb98 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .destination-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 0;
            margin-top: 76px; /* 为fixed导航栏留出空间 */
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow">
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
                        <a class="nav-link" href="my-bookings">我的预定</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="FeedbackServlet">用户反馈</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.username}">
                            <li class="nav-item">
                                <span class="nav-link">欢迎，${sessionScope.username}</span>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="LogoutServlet">退出</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="login.jsp">登录</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="register.jsp">注册</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 目的地头部 -->
    <div class="destination-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-4">${destination.name}</h1>
                    <p class="lead">${destination.description}</p>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="index.jsp" class="text-light">首页</a></li>
                            <li class="breadcrumb-item"><a href="destinations" class="text-light">目的地</a></li>
                            <li class="breadcrumb-item active text-light" aria-current="page">${destination.name}</li>
                        </ol>
                    </nav>
                </div>
                <div class="col-md-4 text-center">
                    <img src="images/Pictures/${destination.image}"
                         class="img-fluid rounded shadow"
                         alt="${destination.name}"
                         style="max-height: 200px;"
                         onerror="this.src='https://via.placeholder.com/300x200?text=图片加载失败'">
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-5">
        <div class="row">
            <div class="col-12">
                <h2 class="text-center mb-5">选择您的旅游套餐</h2>
            </div>
        </div>

        <div class="row">
            <c:forEach var="pkg" items="${packages}">
                <div class="col-md-6 col-lg-4">
                    <div class="card package-card h-100">
                        <div class="card-header bg-primary text-white text-center">
                            <h4 class="card-title mb-0">${pkg.name}</h4>
                        </div>
                        <div class="card-body d-flex flex-column">
                            <p class="card-text">${pkg.description}</p>

                            <div class="price-tag text-center mb-3">
                                ¥<fmt:formatNumber value="${pkg.price}" type="number" maxFractionDigits="0"/>
                            </div>

                            <h6>套餐包含：</h6>
                            <ul class="feature-list flex-grow-1">
                                <c:forEach var="feature" items="${fn:split(pkg.features, ';')}">
                                    <li>${feature}</li>
                                </c:forEach>
                            </ul>

                            <div class="mt-auto">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.username}">
                                        <a href="booking?destinationId=${destination.id}&packageId=${pkg.id}"
                                           class="btn btn-success w-100">立即预订</a>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-outline-primary w-100"
                                                onclick="alert('请先登录后再进行预订')">
                                            需要登录
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty packages}">
            <div class="row">
                <div class="col-12 text-center">
                    <div class="alert alert-warning">
                        <h4>暂无可用套餐</h4>
                        <p>该目的地暂时没有可预订的套餐，请关注我们的更新！</p>
                        <a href="destinations" class="btn btn-primary">返回目的地列表</a>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- 页脚 -->
    <footer class="bg-dark text-light mt-5 py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5 class="text-gradient fw-bold">梦想旅行社</h5>
                    <p>为您提供最优质的旅游服务体验</p>
                    <p class="mb-0">© 2025 梦想旅行社。版权所有。</p>
                </div>
                <div class="col-md-6">
                    <h5>联系我们</h5>
                    <p>电话: 400-123-4567<br>
                       邮箱: info@dreamtravel.com</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
