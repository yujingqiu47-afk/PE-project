<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>目的地管理 - 梦想旅行社</title>
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
        .destination-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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
                <a class="nav-link active" href="../admin/destinations">
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>目的地管理</h1>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addDestinationModal">
                <i class="bi bi-plus-circle"></i> 添加目的地
            </button>
        </div>

        <!-- 目的地列表 -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">目的地列表</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th style="width: 60px;">ID</th>
                                <th style="width: 80px;">图片</th>
                                <th style="width: 150px;">名称</th>
                                <th style="min-width: 200px;">描述</th>
                                <th style="width: 80px;">状态</th>
                                <th style="width: 120px;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="destination" items="${destinations}">
                                <tr>
                                    <td class="align-middle">${destination.id}</td>
                                    <td class="align-middle">
                                        <img src="../images/Pictures/${destination.image}"
                                             class="destination-img"
                                             alt="${destination.name}"
                                             onerror="this.src='https://via.placeholder.com/60x60'">
                                    </td>
                                    <td class="align-middle">
                                        <strong>${destination.name}</strong>
                                    </td>
                                    <td class="align-middle">
                                        <div style="max-width: 300px; word-wrap: break-word;">
                                            <c:choose>
                                                <c:when test="${fn:length(destination.description) > 80}">
                                                    <span title="${destination.description}">
                                                        ${fn:substring(destination.description, 0, 80)}...
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    ${destination.description}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td class="align-middle">
                                        <c:choose>
                                            <c:when test="${destination.active}">
                                                <span class="badge bg-success">启用</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">禁用</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="align-middle">
                                        <div class="btn-group" role="group">
                                            <button class="btn btn-sm btn-outline-primary"
                                                    data-id="${destination.id}"
                                                    data-name="<c:out value='${destination.name}'/>"
                                                    data-description="<c:out value='${destination.description}'/>"
                                                    data-image="${destination.image}"
                                                    data-active="${destination.active}"
                                                    onclick="editDestination(this)"
                                                    title="编辑">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger"
                                                    data-id="${destination.id}"
                                                    data-name="<c:out value='${destination.name}'/>"
                                                    onclick="deleteDestination(this)"
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
                <c:if test="${empty destinations}">
                    <div class="text-center text-muted py-5">
                        <i class="bi bi-geo-alt" style="font-size: 3rem; color: #dee2e6;"></i>
                        <p class="mt-3">暂无目的地数据</p>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addDestinationModal">
                            <i class="bi bi-plus-circle"></i> 添加第一个目的地
                        </button>
                    </div>
                </c:if>
            </div>
            </div>

            <!-- 分页控件 -->
            <c:if test="${not empty destinations}">
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

    <!-- 添加目的地模态框 -->
    <div class="modal fade" id="addDestinationModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">添加目的地</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="../admin/destinations" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="create">
                        <div class="mb-3">
                            <label for="name" class="form-label">目的地名称</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">描述</label>
                            <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="imageFile" class="form-label">目的地图片</label>
                            <div class="input-group">
                                <input type="file" class="form-control" id="imageFile" name="imageFile" accept="image/*" onchange="previewImage(this, 'addImagePreview')">
                            </div>
                            <small class="form-text text-muted">支持 JPG、PNG、GIF 格式，文件大小不超过 5MB</small>
                            <!-- 图片预览 -->
                            <div class="mt-2" id="addImagePreview" style="display: none;">
                                <img id="addPreviewImg" src="" alt="图片预览" style="max-width: 200px; max-height: 150px; border-radius: 8px; border: 1px solid #ddd;">
                                <div class="mt-1">
                                    <small class="text-muted">预览图片</small>
                                    <button type="button" class="btn btn-sm btn-outline-danger ms-2" onclick="removeImagePreview('addImagePreview', 'imageFile')">移除</button>
                                </div>
                            </div>
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

    <!-- 编辑目的地模态框 -->
    <div class="modal fade" id="editDestinationModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">编辑目的地</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="../admin/destinations" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" id="editId" name="id">
                        <input type="hidden" id="editOldImage" name="oldImage">
                        <div class="mb-3">
                            <label for="editName" class="form-label">目的地名称</label>
                            <input type="text" class="form-control" id="editName" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="editDescription" class="form-label">描述</label>
                            <textarea class="form-control" id="editDescription" name="description" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">目的地图片</label>
                            <!-- 当前图片显示 -->
                            <div class="mb-2" id="editCurrentImage">
                                <div class="d-flex align-items-center">
                                    <img id="editCurrentImg" src="" alt="当前图片" style="width: 80px; height: 60px; object-fit: cover; border-radius: 8px; border: 1px solid #ddd;">
                                    <div class="ms-3">
                                        <small class="text-muted">当前图片</small>
                                        <div><small id="editCurrentImageName" class="text-muted"></small></div>
                                    </div>
                                </div>
                            </div>
                            <!-- 上传新图片 -->
                            <div class="input-group">
                                <input type="file" class="form-control" id="editImageFile" name="imageFile" accept="image/*" onchange="previewImage(this, 'editImagePreview')">
                            </div>
                            <small class="form-text text-muted">上传新图片替换当前图片，支持 JPG、PNG、GIF 格式，文件大小不超过 5MB</small>
                            <!-- 新图片预览 -->
                            <div class="mt-2" id="editImagePreview" style="display: none;">
                                <img id="editPreviewImg" src="" alt="新图片预览" style="max-width: 200px; max-height: 150px; border-radius: 8px; border: 1px solid #ddd;">
                                <div class="mt-1">
                                    <small class="text-success">新图片预览</small>
                                    <button type="button" class="btn btn-sm btn-outline-danger ms-2" onclick="removeImagePreview('editImagePreview', 'editImageFile')">取消上传</button>
                                </div>
                            </div>
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
    <div class="modal fade" id="deleteDestinationModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">确认删除</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>确定要删除目的地 "<span id="deleteDestinationName"></span>" 吗？</p>
                    <p class="text-danger">此操作将同时删除该目的地下的所有套餐，且无法撤销！</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <form action="../admin/destinations" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" id="deleteId" name="id">
                        <button type="submit" class="btn btn-danger">确认删除</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editDestination(button) {
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name');
            const description = button.getAttribute('data-description');
            const image = button.getAttribute('data-image');
            const isActive = button.getAttribute('data-active') === 'true';

            document.getElementById('editId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editDescription').value = description;
            document.getElementById('editOldImage').value = image;
            document.getElementById('editIsActive').checked = isActive;
            
            // 显示当前图片
            const currentImg = document.getElementById('editCurrentImg');
            const currentImageName = document.getElementById('editCurrentImageName');
            currentImg.src = '../images/Pictures/' + image;
            currentImageName.textContent = image;
            
            // 清空文件上传和预览
            document.getElementById('editImageFile').value = '';
            document.getElementById('editImagePreview').style.display = 'none';

            var editModal = new bootstrap.Modal(document.getElementById('editDestinationModal'));
            editModal.show();
        }

        function deleteDestination(button) {
            const id = button.getAttribute('data-id');
            const name = button.getAttribute('data-name');

            document.getElementById('deleteId').value = id;
            document.getElementById('deleteDestinationName').textContent = name;

            var deleteModal = new bootstrap.Modal(document.getElementById('deleteDestinationModal'));
            deleteModal.show();
        }

        // 图片预览功能
        function previewImage(input, previewContainerId) {
            const file = input.files[0];
            const previewContainer = document.getElementById(previewContainerId);
            
            if (file) {
                // 检查文件类型
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                if (!allowedTypes.includes(file.type)) {
                    alert('请选择有效的图片文件 (JPG, PNG, GIF)');
                    input.value = '';
                    previewContainer.style.display = 'none';
                    return;
                }
                
                // 检查文件大小 (5MB = 5 * 1024 * 1024 bytes)
                const maxSize = 5 * 1024 * 1024;
                if (file.size > maxSize) {
                    alert('文件大小不能超过 5MB，请选择更小的图片');
                    input.value = '';
                    previewContainer.style.display = 'none';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    const imgElement = previewContainer.querySelector('img');
                    imgElement.src = e.target.result;
                    previewContainer.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                previewContainer.style.display = 'none';
            }
        }

        // 移除图片预览
        function removeImagePreview(previewContainerId, inputId) {
            document.getElementById(previewContainerId).style.display = 'none';
            document.getElementById(inputId).value = '';
        }

        // 解码HTML实体
        function decodeHTMLEntities(text) {
            var textArea = document.createElement('textarea');
            textArea.innerHTML = text;
            return textArea.value;
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
            
            // 重置表单时清空预览
            document.getElementById('addDestinationModal').addEventListener('hidden.bs.modal', function() {
                document.getElementById('addImagePreview').style.display = 'none';
                document.getElementById('imageFile').value = '';
            });
            
            document.getElementById('editDestinationModal').addEventListener('hidden.bs.modal', function() {
                document.getElementById('editImagePreview').style.display = 'none';
                document.getElementById('editImageFile').value = '';
            });
        });

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
    </script>
</body>
</html>
