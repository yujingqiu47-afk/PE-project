<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的预定 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Microsoft YaHei', 'PingFang SC', 'Hiragino Sans GB', sans-serif;
            padding-bottom: 50px;
        }
        .text-gradient {
            background: linear-gradient(45deg, #007bff, #28a745);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .main-content {
            padding-top: 100px;
            min-height: calc(100vh - 200px);
        }
        .booking-card {
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 20px;
        }
        .booking-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .booking-header {
            background: linear-gradient(45deg, #f8f9fa, #e9ecef);
            border-radius: 15px 15px 0 0;
            padding: 20px;
            border-bottom: 1px solid #dee2e6;
        }
        .booking-body {
            padding: 20px;
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 500;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .status-confirmed {
            background-color: #d1edff;
            color: #0c5460;
            border: 1px solid #b8daff;
        }
        .status-completed {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .booking-detail {
            margin-bottom: 10px;
        }
        .booking-detail strong {
            color: #495057;
            display: inline-block;
            width: 100px;
        }
        .price-highlight {
            font-size: 1.5em;
            font-weight: bold;
            color: #28a745;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #dee2e6;
        }
        .pagination-container {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-top: 30px;
        }
        .footer {
            background: #343a40;
            color: white;
            text-align: center;
            padding: 30px 0;
            margin-top: 50px;
        }
        .footer h5 {
            background: linear-gradient(45deg, #87CEEB, #98FB98);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 15px;
        }
        @media (max-width: 768px) {
            .main-content {
                padding-top: 80px;
            }
            .booking-header, .booking-body {
                padding: 15px;
            }
            .booking-detail strong {
                width: auto;
                display: block;
                margin-bottom: 5px;
            }
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
                        <a class="nav-link active" href="my-bookings">我的预定</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="FeedbackServlet">反馈</a>
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

    <!-- 主要内容 -->
    <div class="container main-content">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1><i class="bi bi-calendar-check text-primary"></i> 我的预定</h1>
                    <div class="text-muted">
                        共 ${totalCount} 条预订记录
                    </div>
                </div>

                <!-- 预订列表 -->
                <c:choose>
                    <c:when test="${not empty bookings}">
                        <div class="row">
                            <c:forEach var="booking" items="${bookings}">
                                <div class="col-lg-6 col-xl-4">
                                    <div class="card booking-card">
                                        <div class="booking-header">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <h5 class="mb-0">预订 #${booking.id}</h5>
                                                <c:choose>
                                                    <c:when test="${booking.status == 'pending'}">
                                                        <span class="status-badge status-pending">
                                                            <i class="bi bi-clock"></i> 待确认
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'confirmed'}">
                                                        <span class="status-badge status-confirmed">
                                                            <i class="bi bi-check-circle"></i> 已确认
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'completed'}">
                                                        <span class="status-badge status-completed">
                                                            <i class="bi bi-check2-all"></i> 已完成
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'cancelled'}">
                                                        <span class="status-badge status-cancelled">
                                                            <i class="bi bi-x-circle"></i> 已取消
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge">
                                                            ${booking.status}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="booking-body">
                                            <div class="booking-detail">
                                                <strong>目的地：</strong>
                                                <c:set var="destinationName" value="未知目的地" />
                                                <c:forEach var="destination" items="${destinations}">
                                                    <c:if test="${destination.id == booking.destinationId}">
                                                        <c:set var="destinationName" value="${destination.name}" />
                                                    </c:if>
                                                </c:forEach>
                                                <span class="text-primary">${destinationName}</span>
                                            </div>

                                            <div class="booking-detail">
                                                <strong>套餐：</strong>
                                                <c:set var="packageName" value="未知套餐" />
                                                <c:forEach var="pkg" items="${packages}">
                                                    <c:if test="${pkg.id == booking.packageId}">
                                                        <c:set var="packageName" value="${pkg.name}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${packageName}
                                            </div>

                                            <div class="booking-detail">
                                                <strong>联系人：</strong>
                                                ${booking.customerName}
                                            </div>

                                            <div class="booking-detail">
                                                <strong>联系方式：</strong>
                                                <div class="text-muted small">
                                                    <i class="bi bi-envelope"></i> ${booking.customerEmail}<br>
                                                    <i class="bi bi-phone"></i> ${booking.customerPhone}
                                                </div>
                                            </div>

                                            <div class="booking-detail">
                                                <strong>预订时间：</strong>
                                                <fmt:formatDate value="${booking.bookingDate}" pattern="yyyy-MM-dd HH:mm"/>
                                            </div>

                                            <div class="booking-detail">
                                                <strong>支付方式：</strong>
                                                <c:choose>
                                                    <c:when test="${booking.paymentMethod == 'credit_card'}">信用卡</c:when>
                                                    <c:when test="${booking.paymentMethod == 'alipay'}">支付宝</c:when>
                                                    <c:when test="${booking.paymentMethod == 'wechat'}">微信支付</c:when>
                                                    <c:otherwise>${booking.paymentMethod}</c:otherwise>
                                                </c:choose>
                                            </div>

                                            <hr>
                                            <div class="d-flex justify-content-between align-items-center">
                                                <strong>总金额：</strong>
                                                <span class="price-highlight">
                                                    ¥<fmt:formatNumber value="${booking.totalAmount}" type="number" maxFractionDigits="0"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- 分页控件 -->
                        <c:if test="${totalPages >= 1}">
                            <div class="pagination-container">
                                <div class="row align-items-center">
                                    <div class="col-md-6">
                                        <span class="text-muted">
                                            显示第 ${(currentPage-1)*pageSize + 1} - ${currentPage * pageSize > totalCount ? totalCount : currentPage * pageSize} 条，共 ${totalCount} 条记录
                                        </span>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="d-flex justify-content-end align-items-center gap-2">
                                            <!-- 每页条数选择 -->
                                            <select class="form-select form-select-sm" style="width: auto;" onchange="changePageSize(this.value)">
                                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5条/页</option>
                                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10条/页</option>
                                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20条/页</option>
                                            </select>

                                            <!-- 分页按钮 -->
                                            <nav aria-label="分页导航">
                                                <ul class="pagination pagination-sm mb-0">
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" href="?page=1&pageSize=${pageSize}">首页</a>
                                                    </li>
                                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                        <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}">上一页</a>
                                                    </li>

                                                    <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                            <a class="page-link" href="?page=${pageNum}&pageSize=${pageSize}">${pageNum}</a>
                                                        </li>
                                                    </c:forEach>

                                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}">下一页</a>
                                                    </li>
                                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                        <a class="page-link" href="?page=${totalPages}&pageSize=${pageSize}">末页</a>
                                                    </li>
                                                </ul>
                                            </nav>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-calendar-x"></i>
                            <h3>暂无预订记录</h3>
                            <p class="text-muted">您还没有任何预订记录，快去选择心仪的旅行套餐吧！</p>
                            <a href="packages.jsp" class="btn btn-primary btn-lg">
                                <i class="bi bi-search"></i> 浏览套餐
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- 页脚 -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5 class="text-gradient fw-bold">梦想旅行社</h5>
                    <p>让每一次旅行都成为美好回忆</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p>&copy; 2023 梦想旅行社. 保留所有权利.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function changePageSize(newPageSize) {
            window.location.href = 'my-bookings?page=1&pageSize=' + newPageSize;
        }
    </script>
</body>
</html>
