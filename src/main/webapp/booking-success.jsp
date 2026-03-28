<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预订成功 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .success-icon {
            font-size: 4rem;
            color: #28a745;
        }
        .booking-details {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
            border: 1px solid #dee2e6;
        }
        .detail-row {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">梦想旅行社</a>
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
                    <li class="nav-item">
                        <span class="nav-link">欢迎，${sessionScope.username}</span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">退出</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- 成功消息 -->
                <div class="text-center mb-5">
                    <div class="success-icon">✓</div>
                    <h1 class="text-success mb-3">预订成功！</h1>
                    <p class="lead">感谢您的预订，我们将为您提供最优质的旅游服务体验</p>
                </div>

                <!-- 预订详情 -->
                <div class="booking-details">
                    <h3 class="mb-4">预订详情</h3>

                    <div class="detail-row">
                        <div class="row">
                            <div class="col-4"><strong>预订人：</strong></div>
                            <div class="col-8">${booking.customerName}</div>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="row">
                            <div class="col-4"><strong>联系邮箱：</strong></div>
                            <div class="col-8">${booking.customerEmail}</div>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="row">
                            <div class="col-4"><strong>联系电话：</strong></div>
                            <div class="col-8">${booking.customerPhone}</div>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="row">
                            <div class="col-4"><strong>目的地：</strong></div>
                            <div class="col-8">${destination.name}</div>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="row">
                            <div class="col-4"><strong>选择套餐：</strong></div>
                            <div class="col-8">${selectedPackage.name}</div>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="row">
                            <div class="col-4"><strong>套餐描述：</strong></div>
                            <div class="col-8">${selectedPackage.description}</div>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="row">
                            <div class="col-4"><strong>支付方式：</strong></div>
                            <div class="col-8">
                                <c:choose>
                                    <c:when test="${booking.paymentMethod == 'credit_card'}">信用卡</c:when>
                                    <c:when test="${booking.paymentMethod == 'alipay'}">支付宝</c:when>
                                    <c:when test="${booking.paymentMethod == 'wechat'}">微信支付</c:when>
                                    <c:when test="${booking.paymentMethod == 'bank_transfer'}">银行转账</c:when>
                                    <c:otherwise>${booking.paymentMethod}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="row">
                            <div class="col-4"><strong>总金额：</strong></div>
                            <div class="col-8">
                                <span class="text-success h5">¥<fmt:formatNumber value="${booking.totalAmount}" type="number" maxFractionDigits="0"/></span>
                            </div>
                        </div>
                    </div>

                    <div class="detail-row">
                        <div class="row">
                            <div class="col-4"><strong>预订状态：</strong></div>
                            <div class="col-8">
                                <span class="badge bg-success">${booking.status == 'confirmed' ? '已确认' : booking.status}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 下一步信息 -->
                <div class="alert alert-info mt-4">
                    <h5 class="alert-heading">下一步操作：</h5>
                    <ul class="mb-0">
                        <li>我们的客服人员将在24小时内联系您确认详细行程</li>
                        <li>请保持您的联系方式畅通</li>
                        <li>如有任何疑问，请致电客服热线：400-123-4567</li>
                        <li>预订确认邮件已发送至您的邮箱</li>
                    </ul>
                </div>

                <!-- 操作按钮 -->
                <div class="text-center mt-4">
                    <a href="destinations" class="btn btn-primary me-3">继续浏览目的地</a>
                    <a href="index.jsp" class="btn btn-outline-secondary">返回首页</a>
                </div>
            </div>
        </div>
    </div>

    <!-- 页脚 -->
    <footer class="bg-dark text-light mt-5 py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>梦想旅行社</h5>
                    <p>为您提供最优质的旅游服务体验</p>
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
