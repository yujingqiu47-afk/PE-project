<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>套餐管理 - 梦想旅行社</title>
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
        .form-control {
            border-radius: 8px;
            border: 1px solid #ced4da;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        .form-select {
            border-radius: 8px;
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
                <a class="nav-link active" href="../admin/packages">
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>套餐管理</h1>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPackageModal">
                <i class="bi bi-plus-circle"></i> 添加套餐
            </button>
        </div>

        <!-- 套餐列表 -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>套餐名称</th>
                                <th>目的地</th>
                                <th>价格</th>
                                <th>描述</th>
                                <th>特色功能</th>
                                <th>状态</th>
                                <th>操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pkg" items="${packages}">
                                <tr>
                                    <td>${pkg.id}</td>
                                    <td>${pkg.name}</td>
                                    <td>
                                        <c:forEach var="destination" items="${destinations}">
                                            <c:if test="${destination.id == pkg.destinationId}">
                                                ${destination.name}
                                            </c:if>
                                        </c:forEach>
                                    </td>
                                    <td>¥<fmt:formatNumber value="${pkg.price}" type="number" maxFractionDigits="0"/></td>
                                    <td style="max-width: 200px;">
                                        <c:choose>
                                            <c:when test="${fn:length(pkg.description) > 30}">
                                                ${fn:substring(pkg.description, 0, 30)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${pkg.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="max-width: 200px;">
                                        <c:choose>
                                            <c:when test="${fn:length(pkg.features) > 30}">
                                                ${fn:substring(pkg.features, 0, 30)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${pkg.features}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${pkg.active}">
                                                <span class="badge bg-success">启用</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">禁用</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary"
                                                    data-id="${pkg.id}"
                                                    data-destination-id="${pkg.destinationId}"
                                                    data-name="<c:out value='${pkg.name}'/>"
                                                    data-description="<c:out value='${pkg.description}'/>"
                                                    data-price="${pkg.price}"
                                                    data-features="<c:out value='${pkg.features}'/>"
                                                    data-active="${pkg.active}"
                                                    onclick="editPackage(this)"
                                                    title="编辑">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger"
                                                    data-id="${pkg.id}"
                                                    data-name="<c:out value='${pkg.name}'/>"
                                                    onclick="deletePackage(this)"
                                                    title="删除">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <c:if test="${empty packages}">
                    <div class="text-center text-muted py-5">
                        <i class="bi bi-box" style="font-size: 3rem; color: #dee2e6;"></i>
                        <p class="mt-3">暂无套餐数据</p>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPackageModal">
                            <i class="bi bi-plus-circle"></i> 添加第一个套餐
                        </button>
                    </div>
                </c:if>
            </div>

            <!-- 分页控件 -->
            <c:if test="${not empty packages}">
                <div class="card-footer bg-light">
                    <div class="row align-items-center">
                        <div class="col-md-4 col-sm-12 mb-2 mb-md-0">
                            <div class="d-flex align-items-center">
                                <span class="me-2">每页显示:</span>
                                <select class="form-select form-select-sm" style="width: auto;" onchange="changePageSize(this.value)">
                                    <option value="5" <c:if test="${pageSize == 5}">selected</c:if>>5</option>
                                    <option value="10" <c:if test="${pageSize == 10}">selected</c:if>>10</option>
                                    <option value="20" <c:if test="${pageSize == 20}">selected</c:if>>20</option>
                                    <option value="50" <c:if test="${pageSize == 50}">selected</c:if>>50</option>
                                </select>
                                <span class="ms-2 text-muted">条记录</span>
                            </div>
                        </div>

                        <div class="col-md-4 col-sm-12 text-center mb-2 mb-md-0">
                            <span class="text-muted">
                                共 ${totalCount} 条记录，第 ${currentPage} / ${totalPages} 页
                            </span>
                        </div>

                        <div class="col-md-4 col-sm-12">
                            <c:choose>
                                <c:when test="${totalPages > 1}">
                                    <nav aria-label="分页导航">
                                        <ul class="pagination pagination-sm justify-content-center justify-content-md-end mb-0">
                                            <!-- 首页 -->
                                            <li class="page-item <c:if test="${currentPage == 1}">disabled</c:if>">
                                                <a class="page-link" href="?page=1&pageSize=${pageSize}" aria-label="首页">
                                                    <i class="bi bi-chevron-double-left"></i>
                                                </a>
                                            </li>

                                            <!-- 上一页 -->
                                            <li class="page-item <c:if test="${currentPage == 1}">disabled</c:if>">
                                                <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}" aria-label="上一页">
                                                    <i class="bi bi-chevron-left"></i>
                                                </a>
                                            </li>

                                            <!-- 页码 -->
                                            <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                                                <li class="page-item <c:if test="${pageNum == currentPage}">active</c:if>">
                                                    <a class="page-link" href="?page=${pageNum}&pageSize=${pageSize}">${pageNum}</a>
                                                </li>
                                            </c:forEach>

                                            <!-- 下一页 -->
                                            <li class="page-item <c:if test="${currentPage == totalPages}">disabled</c:if>">
                                                <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}" aria-label="下一页">
                                                    <i class="bi bi-chevron-right"></i>
                                                </a>
                                            </li>

                                            <!-- 末页 -->
                                            <li class="page-item <c:if test="${currentPage == totalPages}">disabled</c:if>">
                                                <a class="page-link" href="?page=${totalPages}&pageSize=${pageSize}" aria-label="末页">
                                                    <i class="bi bi-chevron-double-right"></i>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted">
                                        <small>仅一页数据</small>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- 添加套餐模态框 -->
    <div class="modal fade" id="addPackageModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">添加套餐</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="../admin/packages" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create">
                        <div class="mb-3">
                            <label for="destinationId" class="form-label">目的地</label>
                            <select class="form-select" id="destinationId" name="destinationId" required>
                                <option value="">请选择目的地</option>
                                <c:forEach var="destination" items="${destinations}">
                                    <c:if test="${destination.active}">
                                        <option value="${destination.id}">${destination.name}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="name" class="form-label">套餐名称</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">套餐描述</label>
                            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="price" class="form-label">价格（元）</label>
                            <input type="number" class="form-control" id="price" name="price" min="0" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label for="features" class="form-label">特色功能</label>
                            <textarea class="form-control" id="features" name="features" rows="2"
                                      placeholder="例如：含导游服务，包含门票，免费WiFi" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">添加</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 编辑套餐模态框 -->
    <div class="modal fade" id="editPackageModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑套餐</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="../admin/packages" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="editId" name="id">
                        <div class="mb-3">
                            <label for="editDestinationId" class="form-label">目的地</label>
                            <select class="form-select" id="editDestinationId" name="destinationId" required>
                                <c:forEach var="destination" items="${destinations}">
                                    <option value="${destination.id}">${destination.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="editName" class="form-label">套餐名称</label>
                            <input type="text" class="form-control" id="editName" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="editDescription" class="form-label">套餐描述</label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="editPrice" class="form-label">价格（元）</label>
                            <input type="number" class="form-control" id="editPrice" name="price" min="0" step="0.01" required>
                        </div>
                        <div class="mb-3">
                            <label for="editFeatures" class="form-label">特色功能</label>
                            <textarea class="form-control" id="editFeatures" name="features" rows="2" required></textarea>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="editIsActive" name="isActive" value="true">
                                <label class="form-check-label" for="editIsActive">启用</label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="submit" class="btn btn-primary">保存</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 删除确认模态框 -->
    <div class="modal fade" id="deletePackageModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">确认删除</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>确定要删除套餐 "<span id="deletePackageName"></span>" 吗？</p>
                    <p class="text-danger">此操作无法撤销！</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <form action="../admin/packages" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" id="deletePackageId" name="id">
                        <button type="submit" class="btn btn-danger">确认删除</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editPackage(button) {
            const id = button.getAttribute('data-id');
            const destinationId = button.getAttribute('data-destination-id');
            const name = button.getAttribute('data-name');
            const description = button.getAttribute('data-description');
            const price = button.getAttribute('data-price');
            const features = button.getAttribute('data-features');
            const isActive = button.getAttribute('data-active') === 'true';

            document.getElementById('editId').value = id;
            document.getElementById('editDestinationId').value = destinationId;
            document.getElementById('editName').value = name;
            document.getElementById('editDescription').value = description;
            document.getElementById('editPrice').value = price;
            document.getElementById('editFeatures').value = features;
            document.getElementById('editIsActive').checked = isActive;

            var editModal = new bootstrap.Modal(document.getElementById('editPackageModal'));
            editModal.show();
        }

        function deletePackage(button) {
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name');

            document.getElementById('deletePackageId').value = id;
            document.getElementById('deletePackageName').textContent = name;

            var deleteModal = new bootstrap.Modal(document.getElementById('deletePackageModal'));
            deleteModal.show();
        }

        // 改变每页显示数量
        function changePageSize(newPageSize) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('pageSize', newPageSize);
            urlParams.set('page', '1'); // 重置到第一页
            window.location.href = '?' + urlParams.toString();
        }

        // 跳转到指定页面
        function goToPage(page) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('page', page);
            window.location.href = '?' + urlParams.toString();
        }

        // 页面加载完成后的初始化
        document.addEventListener('DOMContentLoaded', function() {
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
        });
    </script>
</body>
</html>
