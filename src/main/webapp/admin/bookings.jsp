<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>预订管理 - 梦想旅行社</title>
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
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: none;
            transition: transform 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .status-pending {
            background-color: #ffc107 !important;
            color: #000 !important;
        }
        .status-confirmed {
            background-color: #198754 !important;
        }
        .status-cancelled {
            background-color: #dc3545 !important;
        }
        .status-completed {
            background-color: #6c757d !important;
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
        .table th {
            background-color: #f8f9fa;
            border-top: none;
            font-weight: 600;
            color: #495057;
        }
        .badge {
            padding: 6px 12px;
            font-size: 0.85em;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.875rem;
        }
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .modal-header {
            background: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            border-radius: 15px 15px 0 0;
        }
        .customer-info {
            line-height: 1.4;
        }
        .customer-info strong {
            color: #495057;
        }
        .customer-info small {
            display: block;
            color: #6c757d;
        }
        .amount-display {
            font-weight: bold;
            color: #198754;
            font-size: 1.1em;
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
            .table-responsive {
                font-size: 0.875rem;
            }
            .stats-card {
                margin-bottom: 1rem;
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
                <a class="nav-link" href="../admin/">
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
                <a class="nav-link active" href="../admin/bookings">
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>预订管理</h1>
            <div class="d-flex gap-2">
                <select class="form-select" id="statusFilter" onchange="filterBookings()">
                    <option value="">全部状态</option>
                    <option value="pending">待确认</option>
                    <option value="confirmed">已确认</option>
                    <option value="completed">已完成</option>
                    <option value="cancelled">已取消</option>
                </select>
            </div>
        </div>

        <!-- 统计卡片 -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="bi bi-calendar-check text-primary" style="font-size: 2rem;"></i>
                        <h5 class="card-title mt-2">总预订数</h5>
                        <h2 class="text-primary">${totalCount}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="bi bi-clock-history text-warning" style="font-size: 2rem;"></i>
                        <h5 class="card-title mt-2">待确认</h5>
                        <h2 class="text-warning">${pendingCount}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="bi bi-check-circle text-success" style="font-size: 2rem;"></i>
                        <h5 class="card-title mt-2">已确认</h5>
                        <h2 class="text-success">${confirmedCount}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="bi bi-currency-yen text-info" style="font-size: 2rem;"></i>
                        <h5 class="card-title mt-2">总收入</h5>
                        <h2 class="text-info">¥<fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/></h2>
                    </div>
                </div>
            </div>
        </div>

        <!-- 预订列表 -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">预订列表</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="bookingsTable">
                        <thead>
                            <tr>
                                <th style="width: 80px;">预订ID</th>
                                <th style="width: 180px;">客户信息</th>
                                <th style="width: 120px;">目的地</th>
                                <th style="width: 150px;">套餐</th>
                                <th style="width: 100px;">金额</th>
                                <th style="width: 140px;">预订时间</th>
                                <th style="width: 90px;">状态</th>
                                <th style="width: 120px;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookings}">
                                <tr data-status="${booking.status}">
                                    <td class="align-middle">
                                        <span class="badge bg-primary">#${booking.id}</span>
                                    </td>
                                    <td class="align-middle">
                                        <div class="customer-info">
                                            <strong>${booking.customerName}</strong>
                                            <small>${booking.customerEmail}</small>
                                            <small>${booking.customerPhone}</small>
                                        </div>
                                    </td>
                                    <td class="align-middle">
                                        <c:set var="destinationName" value="未知目的地" />
                                        <c:forEach var="destination" items="${destinations}">
                                            <c:if test="${destination.id == booking.destinationId}">
                                                <c:set var="destinationName" value="${destination.name}" />
                                            </c:if>
                                        </c:forEach>
                                        <strong>${destinationName}</strong>
                                    </td>
                                    <td class="align-middle">
                                        <c:set var="packageName" value="未知套餐" />
                                        <c:forEach var="pkg" items="${packages}">
                                            <c:if test="${pkg.id == booking.packageId}">
                                                <c:set var="packageName" value="${pkg.name}" />
                                            </c:if>
                                        </c:forEach>
                                        ${packageName}
                                    </td>
                                    <td class="align-middle">
                                        <span class="amount-display">¥<fmt:formatNumber value="${booking.totalAmount}" type="number" maxFractionDigits="0"/></span>
                                    </td>
                                    <td class="align-middle">
                                        <small><fmt:formatDate value="${booking.bookingDate}" pattern="yyyy-MM-dd"/><br><fmt:formatDate value="${booking.bookingDate}" pattern="HH:mm"/></small>
                                    </td>
                                    <td class="align-middle">
                                        <c:choose>
                                            <c:when test="${booking.status == 'pending'}">
                                                <span class="badge status-pending">待确认</span>
                                            </c:when>
                                            <c:when test="${booking.status == 'confirmed'}">
                                                <span class="badge status-confirmed">已确认</span>
                                            </c:when>
                                            <c:when test="${booking.status == 'completed'}">
                                                <span class="badge status-completed">已完成</span>
                                            </c:when>
                                            <c:when test="${booking.status == 'cancelled'}">
                                                <span class="badge status-cancelled">已取消</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${booking.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="align-middle">
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-info view-details-btn"
                                                    data-booking-id="${booking.id}"
                                                    data-customer-name="${booking.customerName}"
                                                    data-email="${booking.customerEmail}"
                                                    data-phone="${booking.customerPhone}"
                                                    data-destination="${destinationName}"
                                                    data-package="${packageName}"
                                                    data-amount="${booking.totalAmount}"
                                                    data-status="${booking.status}"
                                                    data-booking-date="<fmt:formatDate value="${booking.bookingDate}" pattern="yyyy-MM-dd HH:mm"/>"
                                                    title="查看详情">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <c:if test="${booking.status == 'pending'}">
                                                <button class="btn btn-sm btn-outline-success update-status-btn"
                                                        data-booking-id="${booking.id}"
                                                        data-new-status="confirmed"
                                                        title="确认">
                                                    <i class="bi bi-check-circle"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger update-status-btn"
                                                        data-booking-id="${booking.id}"
                                                        data-new-status="cancelled"
                                                        title="取消">
                                                    <i class="bi bi-x-circle"></i>
                                                </button>
                                            </c:if>
                                            <c:if test="${booking.status == 'confirmed'}">
                                                <button class="btn btn-sm btn-outline-secondary update-status-btn"
                                                        data-booking-id="${booking.id}"
                                                        data-new-status="completed"
                                                        title="完成">
                                                    <i class="bi bi-check2-all"></i>
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <c:if test="${empty bookings}">
                    <div class="text-center text-muted py-5">
                        <i class="bi bi-calendar-x" style="font-size: 3rem; color: #dee2e6;"></i>
                        <p class="mt-3">暂无预订记录</p>
                        <p class="text-muted">当客户预订旅行套餐时，记录将显示在这里</p>
                    </div>
                </c:if>
            </div>

            <!-- 分页控件 -->
            <c:if test="${not empty bookings}">
                <div class="card-footer">
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
                                    <option value="50" ${pageSize == 50 ? 'selected' : ''}>50条/页</option>
                                </select>

                                <!-- 分页按钮 -->
                                <c:if test="${totalPages > 1}">
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
                                </c:if>
                                <c:if test="${totalPages <= 1}">
                                    <span class="text-muted">仅一页数据</span>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- 预订详情模态框 -->
    <div class="modal fade" id="bookingDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">预订详情</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>客户信息</h6>
                            <table class="table table-borderless">
                                <tr>
                                    <td><strong>姓名：</strong></td>
                                    <td id="detailCustomerName"></td>
                                </tr>
                                <tr>
                                    <td><strong>邮箱：</strong></td>
                                    <td id="detailEmail"></td>
                                </tr>
                                <tr>
                                    <td><strong>电话：</strong></td>
                                    <td id="detailPhone"></td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6>预订信息</h6>
                            <table class="table table-borderless">
                                <tr>
                                    <td><strong>目的地：</strong></td>
                                    <td id="detailDestination"></td>
                                </tr>
                                <tr>
                                    <td><strong>套餐：</strong></td>
                                    <td id="detailPackage"></td>
                                </tr>
                                <tr>
                                    <td><strong>金额：</strong></td>
                                    <td id="detailAmount"></td>
                                </tr>
                                <tr>
                                    <td><strong>状态：</strong></td>
                                    <td id="detailStatus"></td>
                                </tr>
                                <tr>
                                    <td><strong>预订时间：</strong></td>
                                    <td id="detailBookingDate"></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 状态更新确认模态框 -->
    <div class="modal fade" id="statusUpdateModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">确认状态更新</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>确定要将预订状态更新为 "<span id="newStatusText"></span>" 吗？</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <form action="../admin/bookings" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" id="updateBookingId" name="bookingId">
                        <input type="hidden" id="newStatus" name="status">
                        <button type="submit" class="btn btn-primary">确认更新</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // DOM加载完成后绑定事件监听器
        document.addEventListener('DOMContentLoaded', function() {
            // 绑定查看详情按钮事件
            document.querySelectorAll('.view-details-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var id = this.getAttribute('data-booking-id');
                    var customerName = this.getAttribute('data-customer-name');
                    var email = this.getAttribute('data-email');
                    var phone = this.getAttribute('data-phone');
                    var destination = this.getAttribute('data-destination');
                    var packageName = this.getAttribute('data-package');
                    var amount = this.getAttribute('data-amount');
                    var status = this.getAttribute('data-status');
                    var bookingDate = this.getAttribute('data-booking-date');

                    viewBookingDetails(id, customerName, email, phone, destination, packageName, amount, status, bookingDate);
                });
            });

            // 绑定状态更新按钮事件
            document.querySelectorAll('.update-status-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    var bookingId = this.getAttribute('data-booking-id');
                    var newStatus = this.getAttribute('data-new-status');
                    updateBookingStatus(bookingId, newStatus);
                });
            });
        });

        // 查看预订详情
        function viewBookingDetails(id, customerName, email, phone, destination, packageName, amount, status, bookingDate) {
            document.getElementById('detailCustomerName').textContent = customerName;
            document.getElementById('detailEmail').textContent = email;
            document.getElementById('detailPhone').textContent = phone;
            document.getElementById('detailDestination').textContent = destination;
            document.getElementById('detailPackage').textContent = packageName;
            document.getElementById('detailAmount').textContent = '¥' + amount;
            document.getElementById('detailStatus').textContent = getStatusText(status);
            document.getElementById('detailBookingDate').textContent = bookingDate;

            var detailsModal = new bootstrap.Modal(document.getElementById('bookingDetailsModal'));
            detailsModal.show();
        }

        // 更新预订状态
        function updateBookingStatus(bookingId, newStatus) {
            document.getElementById('updateBookingId').value = bookingId;
            document.getElementById('newStatus').value = newStatus;
            document.getElementById('newStatusText').textContent = getStatusText(newStatus);

            var statusModal = new bootstrap.Modal(document.getElementById('statusUpdateModal'));
            statusModal.show();
        }

        // 获取状态中文文本
        function getStatusText(status) {
            switch(status) {
                case 'pending': return '待确认';
                case 'confirmed': return '已确认';
                case 'completed': return '已完成';
                case 'cancelled': return '已取消';
                default: return status;
            }
        }

        // 过滤预订列表
        function filterBookings() {
            var statusFilter = document.getElementById('statusFilter').value;
            var rows = document.querySelectorAll('#bookingsTable tbody tr');

            rows.forEach(function(row) {
                var rowStatus = row.getAttribute('data-status');
                if (statusFilter === '' || rowStatus === statusFilter) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // 改变每页条数
        function changePageSize(newPageSize) {
            var currentUrl = new URL(window.location.href);
            currentUrl.searchParams.set('pageSize', newPageSize);
            currentUrl.searchParams.set('page', '1'); // 重置到第一页
            window.location.href = currentUrl.toString();
        }
    </script>
</body>
</html>
