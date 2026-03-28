<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预订确认 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .booking-form {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .package-summary {
            background: white;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
        .price-highlight {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }
        .form-label {
            font-weight: 600;
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

    <div class="container mt-4">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="index.jsp">首页</a></li>
                <li class="breadcrumb-item"><a href="destinations">目的地</a></li>
                <li class="breadcrumb-item"><a href="destinations?action=packages&destinationId=${destination.id}">${destination.name}</a></li>
                <li class="breadcrumb-item active" aria-current="page">预订</li>
            </ol>
        </nav>

        <h1 class="text-center mb-5">预订确认</h1>

        <div class="row">
            <!-- 预订表单 -->
            <div class="col-lg-8">
                <div class="booking-form">
                    <h3 class="mb-4">填写预订信息</h3>

                    <c:if test="${not empty currentUser}">
                        <div class="alert alert-info" role="alert">
                            <i class="fas fa-info-circle"></i>
                            预订信息已根据您的账户信息自动填充，您可以根据需要进行修改。
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                            ${error}
                        </div>
                    </c:if>

                    <form action="booking" method="post" id="bookingForm">
                        <input type="hidden" name="destinationId" value="${destination.id}">
                        <input type="hidden" name="packageId" value="${selectedPackage.id}">
                        <input type="hidden" name="totalAmount" value="${selectedPackage.price}">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="customerName" class="form-label">姓名 *</label>
                                <input type="text" class="form-control" id="customerName" name="customerName"
                                       value="${not empty currentUser ? currentUser.username : ''}" required>
                                <small class="form-text text-muted">可修改为您的真实姓名</small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="customerEmail" class="form-label">邮箱 *</label>
                                <input type="email" class="form-control" id="customerEmail" name="customerEmail"
                                       value="${not empty currentUser ? currentUser.email : ''}" required>
                            </div>
                        </div>

                        <c:if test="${not empty currentUser}">
                            <div class="mb-3">
                                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="resetToUserInfo()">
                                    <i class="fas fa-undo"></i> 恢复为账户信息
                                </button>
                            </div>
                        </c:if>

                        <div class="mb-3">
                            <label for="customerPhone" class="form-label">联系电话 *</label>
                            <input type="tel" class="form-control" id="customerPhone" name="customerPhone" required>
                        </div>

                        <h4 class="mt-4 mb-3">支付信息</h4>

                        <div class="mb-3">
                            <label for="paymentMethod" class="form-label">支付方式 *</label>
                            <select class="form-select" id="paymentMethod" name="paymentMethod" required onchange="togglePaymentInfo()">
                                <option value="">请选择支付方式</option>
                                <option value="credit_card">信用卡</option>
                                <option value="alipay">支付宝</option>
                                <option value="wechat">微信支付</option>
                                <option value="bank_transfer">银行转账</option>
                            </select>
                        </div>

                        <div class="mb-3" id="paymentInfoDiv" style="display: none;">
                            <label for="paymentInfo" class="form-label">支付信息 *</label>
                            <input type="text" class="form-control" id="paymentInfo" name="paymentInfo"
                                   placeholder="请输入相关支付信息">
                            <small class="form-text text-muted" id="paymentHint"></small>
                        </div>

                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="terms" required>
                            <label class="form-check-label" for="terms">
                                我已阅读并同意 <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">服务条款</a>
                            </label>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success btn-lg">确认预订</button>
                            <a href="destinations?action=packages&destinationId=${destination.id}" class="btn btn-outline-secondary">返回套餐选择</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 预订摘要 -->
            <div class="col-lg-4">
                <div class="package-summary">
                    <h4 class="mb-3">预订摘要</h4>

                    <div class="mb-3">
                        <img src="images/Pictures/${destination.image}"
                             class="img-fluid rounded"
                             alt="${destination.name}"
                             style="width: 100%; height: 150px; object-fit: cover;"
                             onerror="this.src='https://via.placeholder.com/300x150?text=图片加载失败'">
                    </div>

                    <h5>${destination.name}</h5>
                    <h6 class="text-primary">${selectedPackage.name}</h6>
                    <p class="text-muted">${selectedPackage.description}</p>

                    <hr>

                    <h6>套餐包含：</h6>
                    <ul class="list-unstyled">
                        <c:forEach var="feature" items="${fn:split(selectedPackage.features, ';')}">
                            <li>✓ ${feature}</li>
                        </c:forEach>
                    </ul>

                    <hr>

                    <div class="d-flex justify-content-between align-items-center">
                        <span class="h5">总价：</span>
                        <span class="price-highlight">¥<fmt:formatNumber value="${selectedPackage.price}" type="number" maxFractionDigits="0"/></span>
                    </div>
                </div>
            </div>
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
                    <h6>1. 预订条款</h6>
                    <p>客户在提交预订申请时，需要提供真实有效的个人信息。</p>

                    <h6>2. 取消政策</h6>
                    <p>预订后24小时内可免费取消，超过24小时将收取一定的取消费用。</p>

                    <h6>3. 责任条款</h6>
                    <p>旅行社将为客户提供安全、优质的旅游服务，但不对不可抗力因素承担责任。</p>

                    <h6>4. 隐私保护</h6>
                    <p>我们承诺保护客户的个人信息安全，不会向第三方泄露。</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 存储原始用户信息
        const originalUserInfo = {
            name: '${not empty currentUser ? currentUser.username : ""}',
            email: '${not empty currentUser ? currentUser.email : ""}'
        };

        // 恢复为账户信息函数
        function resetToUserInfo() {
            if (originalUserInfo.name && originalUserInfo.email) {
                document.getElementById('customerName').value = originalUserInfo.name;
                document.getElementById('customerEmail').value = originalUserInfo.email;

                // 显示提示信息
                const alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-success alert-dismissible fade show mt-2';
                alertDiv.innerHTML = `
                    <i class="fas fa-check-circle"></i> 已恢复为您的账户信息
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;

                const form = document.getElementById('bookingForm');
                form.insertBefore(alertDiv, form.firstChild);

                // 3秒后自动隐藏提示
                setTimeout(() => {
                    if (alertDiv.parentNode) {
                        alertDiv.remove();
                    }
                }, 3000);
            }
        }

        function togglePaymentInfo() {
            const paymentMethod = document.getElementById('paymentMethod').value;
            const paymentInfoDiv = document.getElementById('paymentInfoDiv');
            const paymentInfo = document.getElementById('paymentInfo');
            const paymentHint = document.getElementById('paymentHint');

            if (paymentMethod) {
                paymentInfoDiv.style.display = 'block';
                paymentInfo.required = true;

                switch(paymentMethod) {
                    case 'credit_card':
                        paymentInfo.placeholder = '请输入信用卡号（**** **** **** ****）';
                        paymentHint.textContent = '请输入16位信用卡号';
                        break;
                    case 'alipay':
                        paymentInfo.placeholder = '请输入支付宝账号';
                        paymentHint.textContent = '请输入您的支付宝登录账号';
                        break;
                    case 'wechat':
                        paymentInfo.placeholder = '请输入微信号';
                        paymentHint.textContent = '请输入您的微信号';
                        break;
                    case 'bank_transfer':
                        paymentInfo.placeholder = '请输入银行账号';
                        paymentHint.textContent = '请输入您的银行账号';
                        break;
                }
            } else {
                paymentInfoDiv.style.display = 'none';
                paymentInfo.required = false;
            }
        }

        // 表单验证
        document.getElementById('bookingForm').addEventListener('submit', function(e) {
            const customerName = document.getElementById('customerName').value.trim();
            const customerEmail = document.getElementById('customerEmail').value.trim();
            const customerPhone = document.getElementById('customerPhone').value.trim();
            const paymentMethod = document.getElementById('paymentMethod').value;
            const paymentInfo = document.getElementById('paymentInfo').value.trim();
            const terms = document.getElementById('terms').checked;

            if (!customerName || !customerEmail || !customerPhone || !paymentMethod || !paymentInfo || !terms) {
                e.preventDefault();
                alert('请填写所有必填字段并同意服务条款');
                return;
            }

            // 验证邮箱格式
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(customerEmail)) {
                e.preventDefault();
                alert('请输入有效的邮箱地址');
                return;
            }

            // 验证手机号格式
            const phoneRegex = /^1[3-9]\d{9}$/;
            if (!phoneRegex.test(customerPhone)) {
                e.preventDefault();
                alert('请输入有效的手机号码');
                return;
            }

            return confirm('请确认您的预订信息无误，确定要提交预订吗？');
        });
    </script>
</body>
</html>

