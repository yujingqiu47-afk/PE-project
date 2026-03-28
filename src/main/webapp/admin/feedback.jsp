<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户反馈管理 - 梦想旅行社</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            position: fixed;
            top: 56px;
            bottom: 0;
            left: 0;
            z-index: 100;
            padding: 48px 0 0;
            box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
            width: 240px;
            background: #343a40;
        }
        .sidebar .nav-link {
            color: #ffffff;
            font-weight: 500;
            padding: 12px 20px;
            border-radius: 5px;
            margin: 5px 15px;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover {
            color: #ffffff;
            background: rgba(255,255,255,0.1);
        }
        .sidebar .nav-link.active {
            color: #ffffff;
            background: #007bff;
        }
        .sidebar .nav-link i {
            margin-right: 10px;
        }
        .main-content {
            margin-left: 240px;
            padding: 20px;
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
        .feedback-content {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .rating-stars {
            color: #ffc107;
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .filter-card {
            border-left: 4px solid #007bff;
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
    <nav class="navbar navbar-dark bg-primary fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">梦想旅行社 - 管理后台</a>
            <div class="d-flex">
                <span class="navbar-text me-3">管理员：${sessionScope.username}</span>
                <a href="../LogoutServlet" class="btn btn-outline-light btn-sm">退出登录</a>
            </div>
        </div>
    </nav>

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
                <a class="nav-link" href="../admin/bookings">
                    <i class="bi bi-calendar-check"></i> 预订管理
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="../admin/feedback">
                    <i class="bi bi-chat-text"></i> 用户反馈
                </a>
            </li>
        </ul>
    </nav>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1>用户反馈管理</h1>
        </div>

        <c:if test="${param.success == 'deleted'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> 反馈删除成功！
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${param.error == 'delete_failed'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> 删除失败，请重试！
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <i class="bi bi-chat-text display-4"></i>
                        <h3 class="mt-2">${totalCount}</h3>
                        <p class="mb-0">总反馈数</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <i class="bi bi-star-fill display-4"></i>
                        <h3 class="mt-2">
                            <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/>
                        </h3>
                        <p class="mb-0">平均评分</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card filter-card mb-4">
            <div class="card-header">
                <h5 class="mb-0"><i class="bi bi-funnel"></i> 筛选反馈</h5>
            </div>
            <div class="card-body">
                <form method="get" action="feedback" class="row g-3">
                    <div class="col-md-4">
                        <label for="feedbackType" class="form-label">反馈类型</label>
                        <select class="form-select" id="feedbackType" name="feedbackType">
                            <option value="">全部类型</option>
                            <option value="service_quality" ${feedbackType == 'service_quality' ? 'selected' : ''}>服务质量</option>
                            <option value="product_experience" ${feedbackType == 'product_experience' ? 'selected' : ''}>产品体验</option>
                            <option value="price_value" ${feedbackType == 'price_value' ? 'selected' : ''}>价格价值</option>
                            <option value="booking_process" ${feedbackType == 'booking_process' ? 'selected' : ''}>预订流程</option>
                            <option value="customer_support" ${feedbackType == 'customer_support' ? 'selected' : ''}>客户支持</option>
                            <option value="website_usability" ${feedbackType == 'website_usability' ? 'selected' : ''}>网站可用性</option>
                            <option value="general_suggestion" ${feedbackType == 'general_suggestion' ? 'selected' : ''}>一般建议</option>
                            <option value="complaint" ${feedbackType == 'complaint' ? 'selected' : ''}>投诉</option>
                            <option value="compliment" ${feedbackType == 'compliment' ? 'selected' : ''}>表扬</option>
                            <option value="other" ${feedbackType == 'other' ? 'selected' : ''}>其他</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="rating" class="form-label">评分</label>
                        <select class="form-select" id="rating" name="rating">
                            <option value="">全部评分</option>
                            <option value="5" ${rating == 5 ? 'selected' : ''}>5星 (非常满意)</option>
                            <option value="4" ${rating == 4 ? 'selected' : ''}>4星 (满意)</option>
                            <option value="3" ${rating == 3 ? 'selected' : ''}>3星 (一般)</option>
                            <option value="2" ${rating == 2 ? 'selected' : ''}>2星 (不满意)</option>
                            <option value="1" ${rating == 1 ? 'selected' : ''}>1星 (非常不满意)</option>
                        </select>
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary me-2">
                            <i class="bi bi-search"></i> 筛选
                        </button>
                        <a href="feedback" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-clockwise"></i> 重置
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">反馈列表</h5>
                <span class="badge bg-primary">共 ${totalCount} 条反馈</span>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty feedbackList}">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>客户姓名</th>
                                        <th>邮箱</th>
                                        <th>评分</th>
                                        <th>反馈类型</th>
                                        <th>反馈内容</th>
                                        <th>联系电话</th>
                                        <th>允许联系</th>
                                        <th>提交时间</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="feedback" items="${feedbackList}">
                                        <tr>
                                            <td><span class="badge bg-primary">#${feedback.id}</span></td>
                                            <td>${feedback.customerName}</td>
                                            <td class="text-break">${feedback.email}</td>
                                            <td>
                                                <div class="rating-stars">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="bi ${i <= feedback.overallRating ? 'bi-star-fill' : 'bi-star'}"></i>
                                                    </c:forEach>
                                                    <small class="text-muted">(${feedback.overallRating})</small>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${feedback.feedbackType == 'service_quality'}">服务质量</c:when>
                                                    <c:when test="${feedback.feedbackType == 'product_experience'}">产品体验</c:when>
                                                    <c:when test="${feedback.feedbackType == 'price_value'}">价格价值</c:when>
                                                    <c:when test="${feedback.feedbackType == 'booking_process'}">预订流程</c:when>
                                                    <c:when test="${feedback.feedbackType == 'customer_support'}">客户支持</c:when>
                                                    <c:when test="${feedback.feedbackType == 'website_usability'}">网站可用性</c:when>
                                                    <c:when test="${feedback.feedbackType == 'general_suggestion'}">一般建议</c:when>
                                                    <c:when test="${feedback.feedbackType == 'complaint'}">投诉</c:when>
                                                    <c:when test="${feedback.feedbackType == 'compliment'}">表扬</c:when>
                                                    <c:otherwise>其他</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="feedback-content" title="${feedback.detailedFeedback}">
                                                    ${feedback.detailedFeedback}
                                                </div>
                                            </td>
                                            <td>${feedback.contactPhone}</td>
                                            <td>
                                                <span class="badge ${feedback.allowContact ? 'bg-success' : 'bg-secondary'}">
                                                    ${feedback.allowContact ? '是' : '否'}
                                                </span>
                                            </td>
                                            <td>
                                                <small>
                                                    <fmt:formatDate value="${feedback.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                                </small>
                                            </td>
                                            <td>
                                                <form method="post" action="feedback" style="display: inline;" onsubmit="return confirm('确定要删除这条反馈吗？')">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="id" value="${feedback.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-5">
                            <i class="bi bi-chat-text display-1 text-muted"></i>
                            <h4 class="mt-3 text-muted">暂无反馈数据</h4>
                            <p class="text-muted">当前筛选条件下没有找到相关反馈</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${totalPages > 1}">
            <nav aria-label="分页导航" class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="feedback?page=1<c:if test='${not empty feedbackType}'>&feedbackType=${feedbackType}</c:if><c:if test='${not empty rating}'>&rating=${rating}</c:if>">首页</a>
                        </li>
                    </c:if>
                    
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="feedback?page=${currentPage - 1}<c:if test='${not empty feedbackType}'>&feedbackType=${feedbackType}</c:if><c:if test='${not empty rating}'>&rating=${rating}</c:if>">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="${currentPage > 3 ? currentPage - 2 : 1}" 
                               end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="feedback?page=${i}<c:if test='${not empty feedbackType}'>&feedbackType=${feedbackType}</c:if><c:if test='${not empty rating}'>&rating=${rating}</c:if>">${i}</a>
                        </li>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="feedback?page=${currentPage + 1}<c:if test='${not empty feedbackType}'>&feedbackType=${feedbackType}</c:if><c:if test='${not empty rating}'>&rating=${rating}</c:if>">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="feedback?page=${totalPages}<c:if test='${not empty feedbackType}'>&feedbackType=${feedbackType}</c:if><c:if test='${not empty rating}'>&rating=${rating}</c:if>">末页</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 