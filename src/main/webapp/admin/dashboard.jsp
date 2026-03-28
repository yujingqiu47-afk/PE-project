<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员控制台 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Microsoft YaHei', 'PingFang SC', 'Hiragino Sans GB', sans-serif;
            padding-bottom: 50px;
        }
        .sidebar {
            width: 250px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: #343a40;
            padding-top: 70px;
            z-index: 1000;
            overflow-y: auto;
        }
        .sidebar .nav-link {
            color: #adb5bd;
            padding: 12px 20px;
            border-radius: 5px;
            margin: 2px 10px;
            transition: all 0.3s ease;
        }
        .sidebar .nav-link:hover {
            color: #ffffff;
            background: #495057;
        }
        .sidebar .nav-link.active {
            color: #ffffff;
            background: #007bff;
        }
        .main-content {
            margin-left: 250px;
            padding: 20px 30px;
            min-height: calc(100vh - 70px);
            padding-top: 90px;
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .stats-card .card-body {
            padding: 25px;
        }
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin: 10px 0;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }
        .card {
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: none;
        }
        .card-header {
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            font-weight: 600;
        }
        .quick-action-btn {
            padding: 12px;
            margin-bottom: 10px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .quick-action-btn:hover {
            transform: translateX(5px);
        }
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                padding-top: 0;
            }
            .main-content {
                margin-left: 0;
                padding-top: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- 顶部导航栏 -->
    <nav class="navbar navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">梦想旅行社 - 管理后台</a>
            <div class="d-flex">
                <span class="navbar-text me-3">管理员：${sessionScope.username}</span>
                <a href="../LogoutServlet" class="btn btn-outline-light btn-sm">退出登录</a>
            </div>
        </div>
    </nav>

    <!-- 侧边栏 -->
    <nav class="sidebar">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link active" href="../admin/">
                    <i class="bi bi-house-door"></i> 控制台首页
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="../admin/destinations">
                    <i class="bi bi-geo-alt"></i> 目的地管理
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="../admin/packages">
                    <i class="bi bi-box"></i> 套餐管理
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="../admin/bookings">
                    <i class="bi bi-calendar-check"></i> 预订管理
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="../admin/feedback">
                    <i class="bi bi-chat-text"></i> 用户反馈
                </a>
            </li>
        </ul>
    </nav>

    <!-- 主要内容区域 -->
    <div class="main-content">
        <h1 class="mb-4">控制台概览</h1>

        <!-- 统计卡片 -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <i class="bi bi-geo-alt stats-number"></i>
                        <div class="stats-number">${destinations.size()}</div>
                        <div>目的地数量</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <i class="bi bi-box stats-number"></i>
                        <div class="stats-number">${packages.size()}</div>
                        <div>套餐数量</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check stats-number"></i>
                        <div class="stats-number">${bookings.size()}</div>
                        <div>总预订数</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <i class="bi bi-currency-dollar stats-number"></i>
                        <div class="stats-number">
                            <c:set var="totalRevenue" value="0" />
                            <c:forEach var="booking" items="${bookings}">
                                <c:set var="totalRevenue" value="${totalRevenue + booking.totalAmount}" />
                            </c:forEach>
                            <fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/>
                        </div>
                        <div>总收入</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- 最新预订 -->
            <div class="col-lg-8">
            <div class="card">
            <div class="card-header">
            <h5 class="mb-0">最新预订</h5>
            </div>
            <div class="card-body p-0">
            <div class="table-responsive">
            <table class="table table-hover mb-0">
            <thead>
            <tr>
            <th style="width: 80px;">预订ID</th>
            <th style="width: 120px;">客户姓名</th>
            <th style="width: 150px;">目的地</th>
            <th style="width: 100px;">金额</th>
            <th style="width: 80px;">状态</th>
            <th style="width: 120px;">预订时间</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="booking" items="${bookings}" begin="0" end="9">
            <tr>
            <td class="align-middle">
                <span class="badge bg-primary">#${booking.id}</span>
            </td>
            <td class="align-middle">${booking.customerName}</td>
            <td class="align-middle">
            <c:forEach var="destination" items="${destinations}">
            <c:if test="${destination.id == booking.destinationId}">
                    <strong>${destination.name}</strong>
                    </c:if>
                </c:forEach>
            </td>
            <td class="align-middle">
            <span class="text-success fw-bold">¥<fmt:formatNumber value="${booking.totalAmount}" type="number" maxFractionDigits="0"/></span>
            </td>
            <td class="align-middle">
                <span class="badge bg-success">
                ${booking.status == 'confirmed' ? '已确认' : booking.status}
                </span>
                </td>
                    <td class="align-middle">
                            <small><fmt:formatDate value="${booking.bookingDate}" pattern="MM-dd HH:mm"/></small>
                            </td>
                            </tr>
                        </c:forEach>
                </tbody>
            </table>
            </div>
            <c:if test="${empty bookings}">
                    <div class="text-center text-muted py-5">
                            <i class="bi bi-calendar-check" style="font-size: 3rem; color: #dee2e6;"></i>
                                <p class="mt-3">暂无预订记录</p>
                                <a href="../admin/bookings" class="btn btn-outline-primary">
                                    <i class="bi bi-plus-circle"></i> 查看所有预订
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- 快速操作 -->
            <div class="col-lg-4">
                <div class="card">
                    <div class="card-header">
                        <h5>快速操作</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="../admin/destinations" class="btn btn-primary quick-action-btn">
                                <i class="bi bi-plus-circle"></i> 添加新目的地
                            </a>
                            <a href="../admin/packages" class="btn btn-success quick-action-btn">
                                <i class="bi bi-plus-circle"></i> 添加新套餐
                            </a>
                            <a href="../admin/bookings" class="btn btn-info quick-action-btn">
                                <i class="bi bi-list-check"></i> 查看所有预订
                            </a>
                            <a href="../destinations" class="btn btn-outline-secondary quick-action-btn">
                                <i class="bi bi-eye"></i> 预览网站
                            </a>
                        </div>
                    </div>
                </div>

                <!-- 热门目的地 -->
                <div class="card mt-3">
                    <div class="card-header">
                        <h5>热门目的地</h5>
                    </div>
                    <div class="card-body">
                        <c:forEach var="destination" items="${destinations}" begin="0" end="4">
                            <div class="d-flex align-items-center mb-2">
                                <img src="../src/main/resources/Pictures/${destination.image}" 
                                     class="rounded me-2" 
                                     style="width: 40px; height: 40px; object-fit: cover;"
                                     alt="${destination.name}"
                                     onerror="this.src='https://via.placeholder.com/40x40'">
                                <div>
                                    <div class="fw-bold">${destination.name}</div>
                                    <small class="text-muted">
                                        <c:set var="destBookingCount" value="0" />
                                        <c:forEach var="booking" items="${bookings}">
                                            <c:if test="${booking.destinationId == destination.id}">
                                                <c:set var="destBookingCount" value="${destBookingCount + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        ${destBookingCount} 次预订
                                    </small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 页面加载完成后的初始化
        document.addEventListener('DOMContentLoaded', function() {
            // 为统计卡片添加动画效果
            const statsCards = document.querySelectorAll('.stats-card');
            statsCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
            
            // 为表格行添加悬停效果
            const tableRows = document.querySelectorAll('tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function() {
                    this.style.backgroundColor = '#f8f9fa';
                });
                row.addEventListener('mouseleave', function() {
                    this.style.backgroundColor = '';
                });
            });
            
            // 数字动画效果
            const animateNumbers = () => {
                const numbers = document.querySelectorAll('.stats-number');
                numbers.forEach(num => {
                    const target = parseInt(num.textContent) || 0;
                    if (target > 0) {
                        let current = 0;
                        const increment = target / 50;
                        const timer = setInterval(() => {
                            current += increment;
                            if (current >= target) {
                                current = target;
                                clearInterval(timer);
                            }
                            num.textContent = Math.floor(current);
                        }, 30);
                    }
                });
            };
            
            // 延迟执行数字动画
            setTimeout(animateNumbers, 500);
        });
    </script>
</body>
</html>
