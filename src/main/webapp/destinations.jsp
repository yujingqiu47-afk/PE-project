<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>旅游目的地 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        body {
            padding-top: 80px; /* 为固定导航栏预留空间 */
        }
        .destination-card {
            transition: transform 0.3s ease;
            margin-bottom: 30px;
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .text-gradient {
            background: linear-gradient(45deg, #007bff, #28a745);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .destination-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
        }
        .card-img-top {
            height: 250px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .destination-card:hover .card-img-top {
            transform: scale(1.05);
        }
        .card-body {
            padding: 1.5rem;
        }
        .card-title {
            color: #333;
            font-weight: 600;
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 60px 0;
            margin-bottom: 50px;
        }
        .pagination-container {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-top: 40px;
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
                        <a class="nav-link active" href="destinations">目的地</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="FeedbackServlet">用户反馈</a>
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
                                <a class="nav-link" href="LogoutServlet">退出</a>
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

    <!-- 页面头部 -->
    <section class="page-header">
        <div class="container text-center">
            <h1 class="display-4 fw-bold mb-3">探索精彩目的地</h1>
            <p class="lead">选择您心仪的旅游目的地，开启难忘的旅程</p>
        </div>
    </section>

    <div class="container">
        <div class="row">
            <c:forEach var="destination" items="${destinations}">
                <div class="col-md-6 col-lg-4">
                    <div class="card destination-card h-100">
                        <img src="images/Pictures/${destination.image}"
                             class="card-img-top"
                             alt="${destination.name}"
                             onerror="this.src='https://via.placeholder.com/300x250?text=图片加载失败'">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">${destination.name}</h5>
                            <p class="card-text flex-grow-1">${destination.description}</p>
                            <div class="mt-auto">
                                <a href="destinations?action=packages&destinationId=${destination.id}"
                                   class="btn btn-primary w-100">查看套餐</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty destinations}">
            <div class="row">
                <div class="col-12 text-center">
                    <div class="alert alert-info rounded-3 shadow-sm">
                        <h4 class="alert-heading">暂无可用目的地</h4>
                        <p class="mb-0">请稍后再来查看我们的精彩旅游目的地！</p>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- 分页控件 -->
        <c:if test="${not empty destinations}">
            <div class="pagination-container">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <div class="d-flex align-items-center">
                            <span class="me-2">每页显示:</span>
                            <select class="form-select form-select-sm" style="width: auto;" onchange="changePageSize(this.value)">
                                <option value="6" <c:if test="${pageSize == 6}">selected</c:if>>6</option>
                                <option value="9" <c:if test="${pageSize == 9}">selected</c:if>>9</option>
                                <option value="12" <c:if test="${pageSize == 12}">selected</c:if>>12</option>
                                <option value="18" <c:if test="${pageSize == 18}">selected</c:if>>18</option>
                            </select>
                            <span class="ms-2 text-muted">个目的地</span>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="d-flex justify-content-end align-items-center">
                            <span class="text-muted me-3">
                                共 ${totalCount} 个目的地，第 ${currentPage} / ${totalPages} 页
                            </span>

                            <c:choose>
                                <c:when test="${totalPages > 1}">
                                    <nav aria-label="分页导航">
                                        <ul class="pagination pagination-sm mb-0">
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
                                    <span class="text-muted">仅一页数据</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
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
    <script>
        // 改变每页显示数量
        function changePageSize(newPageSize) {
            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('pageSize', newPageSize);
            urlParams.set('page', '1'); // 重置到第一页
            window.location.href = '?' + urlParams.toString();
        }

        // 平滑滚动到顶部
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }

        // 分页按钮点击后平滑滚动到顶部
        document.addEventListener('DOMContentLoaded', function() {
            const paginationLinks = document.querySelectorAll('.pagination .page-link');
            paginationLinks.forEach(link => {
                link.addEventListener('click', function() {
                    setTimeout(() => {
                        scrollToTop();
                    }, 100);
                });
            });
        });
    </script>
</body>
</html>
