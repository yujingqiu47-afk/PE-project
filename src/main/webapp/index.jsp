<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>梦想旅行社 - 开启您的完美旅程</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
            position: relative;
            overflow: hidden;
        }
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 100" fill="white" opacity="0.1"><polygon points="0,0 1000,100 1000,100 0,100"/></svg>');
            background-size: cover;
        }
        .destination-card {
            height: 300px;
            background-size: cover;
            background-position: center;
            border-radius: 15px;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        .destination-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }
        .text-gradient {
            background: linear-gradient(45deg, #007bff, #28a745);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .destination-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.8));
            color: white;
            padding: 30px 20px 20px;
        }
        .stats-section {
            background: #f8f9fa;
        }
        .stat-item {
            text-align: center;
            padding: 40px 20px;
        }
        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            color: #667eea;
        }
        .fixed-img {
            height: 200px;
            object-fit: cover;
            object-position: center;
            border-radius: 10px;
        }
        .carousel-item img {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .feature-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            margin: 0 auto 20px;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow">
        <div class="container">
            <a class="navbar-brand text-gradient fw-bold" href="#">梦想旅行社</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">首页</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="destinations">目的地</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="FeedbackServlet">用户反馈</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="my-bookings">我的预定</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">关于我们</a>
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

    <!-- 主要横幅区域 -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4 fade-in-up">探索世界的奇妙之旅</h1>
                    <p class="lead mb-4">与梦想旅行社一起，发现隐藏的天堂，体验独一无二的冒险，创造属于您的美好回忆。</p>
                    <div class="d-flex gap-3">
                        <a href="destinations" class="btn btn-light btn-lg">立即探索</a>
                        <a href="#about" class="btn btn-outline-light btn-lg">了解更多</a>
                    </div>
                </div>
                <div class="col-lg-6 text-center">
                    <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4000">
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img src="images/carouseImages/promo1.png"
                                     class="d-block w-100"
                                     style="height: 400px; object-fit: cover;"
                                     alt="精彩旅程">
                            </div>
                            <div class="carousel-item">
                                <img src="images/carouseImages/promo2.png"
                                     class="d-block w-100"
                                     style="height: 400px; object-fit: cover;"
                                     alt="梦想之旅">
                            </div>
                        </div>
                        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon"></span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon"></span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 统计数据区域 -->
    <section class="stats-section py-5">
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">1000+</div>
                        <p class="mb-0">满意客户</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">50+</div>
                        <p class="mb-0">精选目的地</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">24/7</div>
                        <p class="mb-0">客户服务</p>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">5★</div>
                        <p class="mb-0">服务评级</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 热门目的地 -->
    <section class="py-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <h2 class="mb-4 text-center">热门目的地</h2>
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="destination-card" style="background-image: url('images/Pictures/Aquarium.png');">
                                <div class="destination-overlay">
                                    <h5 class="fw-bold">海洋水族馆</h5>
                                    <p class="mb-2">探索神秘的海洋世界，与海洋生物亲密接触</p>
                                    <a href="destinations?action=packages&destinationId=1" class="btn btn-light btn-sm">查看详情</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="destination-card" style="background-image: url('images/Pictures/Buzzy bees.png');">
                                <div class="destination-overlay">
                                    <h5 class="fw-bold">蜜蜂农场</h5>
                                    <p class="mb-2">体验田园生活，了解蜜蜂的世界</p>
                                    <a href="destinations?action=packages&destinationId=2" class="btn btn-light btn-sm">查看详情</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="destination-card" style="background-image: url('images/Pictures/Dimension.png');">
                                <div class="destination-overlay">
                                    <h5 class="fw-bold">科技体验馆</h5>
                                    <p class="mb-2">感受前沿科技的魅力</p>
                                    <a href="destinations?action=packages&destinationId=3" class="btn btn-light btn-sm">查看详情</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="destination-card" style="background-image: url('images/Pictures/Exploration.png');">
                                <div class="destination-overlay">
                                    <h5 class="fw-bold">自然探索之旅</h5>
                                    <p class="mb-2">深入大自然，探索未知的奥秘</p>
                                    <a href="destinations?action=packages&destinationId=4" class="btn btn-light btn-sm">查看详情</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="text-center mt-4">
                        <a href="destinations" class="btn btn-primary btn-lg">查看所有目的地</a>
                    </div>
                </div>

                <!-- 侧边栏推广 -->
                <div class="col-lg-4">
                    <div class="sticky-top" style="top: 100px;">
                        <div class="card shadow-lg">
                            <div class="card-body text-center">
                                <h5 class="card-title text-gradient">🎉 特别优惠</h5>
                                <p class="card-text">注册新用户即可享受首次预订85折优惠！</p>
                                <a href="register.jsp" class="btn btn-primary">立即注册</a>
                            </div>
                        </div>

                        <div class="card shadow-lg mt-4">
                            <div class="card-body">
                                <h5 class="card-title">📞 联系我们</h5>
                                <p class="card-text mb-2"><strong>客服热线：</strong><br>400-123-4567</p>
                                <p class="card-text mb-2"><strong>营业时间：</strong><br>周一至周日 8:00-22:00</p>
                                <p class="card-text"><strong>紧急联系：</strong><br>139-8888-6666</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 服务特色 -->
    <section class="py-5 bg-light">
        <div class="container">
            <h2 class="text-center mb-5">为什么选择我们</h2>
            <div class="row">
                <div class="col-md-4 text-center mb-4">
                    <div class="feature-icon">🏆</div>
                    <h5>专业品质</h5>
                    <p>超过10年的旅游服务经验，为您提供最专业的旅游规划</p>
                </div>
                <div class="col-md-4 text-center mb-4">
                    <div class="feature-icon">💰</div>
                    <h5>优惠价格</h5>
                    <p>直接与目的地合作，为您省去中间环节，享受最优惠的价格</p>
                </div>
                <div class="col-md-4 text-center mb-4">
                    <div class="feature-icon">🛡️</div>
                    <h5>安全保障</h5>
                    <p>全程保险覆盖，24小时应急支持，让您的旅程安心无忧</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 关于我们 -->
    <section id="about" class="py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h2 class="mb-4">关于梦想旅行社</h2>
                    <p class="lead">梦想旅行社成立于2010年，致力于为每一位旅行者创造独特而难忘的旅游体验。</p>
                    <p>我们相信，旅行不仅仅是到达目的地，更是一次心灵的探索和成长的旅程。我们的专业团队精心挑选每一个目的地，设计每一个行程，确保您能够在旅途中收获最美好的回忆。</p>
                    <p>从神秘的海洋世界到宁静的田园风光，从前沿的科技体验到原始的自然探索，我们为您打开通往世界各个角落的大门。</p>
                    <div class="row mt-4">
                        <div class="col-6">
                            <h4 class="text-gradient">使命</h4>
                            <p>让每一次旅行都成为人生中最珍贵的体验</p>
                        </div>
                        <div class="col-6">
                            <h4 class="text-gradient">愿景</h4>
                            <p>成为最受信赖的旅游服务提供商</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <img src="images/Pictures/Exploration.png"
                         class="img-fluid rounded shadow-lg"
                         alt="关于我们">
                </div>
            </div>
        </div>
    </section>

    <!-- 联系我们 -->
    <section id="contact" class="py-5 gradient-bg text-white">
        <div class="container">
            <div class="row">
                <div class="col-lg-8 mx-auto text-center">
                    <h2 class="mb-4">准备开始您的旅程了吗？</h2>
                    <p class="lead mb-4">立即联系我们，让专业的旅游顾问为您规划完美的旅程</p>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="destinations" class="btn btn-light btn-lg">浏览目的地</a>
                        <a href="register.jsp" class="btn btn-outline-light btn-lg">免费注册</a>
                    </div>
                </div>
            </div>
            <div class="row mt-5">
                <div class="col-md-4 text-center">
                    <h5>📍 公司地址</h5>
                    <p>北京市朝阳区梦想大厦8楼</p>
                </div>
                <div class="col-md-4 text-center">
                    <h5>📧 邮箱地址</h5>
                    <p>info@dreamtravel.com</p>
                </div>
                <div class="col-md-4 text-center">
                    <h5>📱 微信客服</h5>
                    <p>DreamTravel2024</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 页脚 -->
    <footer class="bg-dark text-light py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>梦想旅行社</h5>
                    <p>为您提供最优质的旅游服务体验</p>
                    <p class="mb-0">© 2025 梦想旅行社。版权所有。</p>
                </div>
                <div class="col-md-6">
                    <h5>快速链接</h5>
                    <ul class="list-unstyled">
                        <li><a href="destinations" class="text-light">旅游目的地</a></li>
                        <li><a href="login.jsp" class="text-light">用户登录</a></li>
                        <li><a href="register.jsp" class="text-light">新用户注册</a></li>
                        <li><a href="#contact" class="text-light">联系我们</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 平滑滚动
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // 滚动动画效果
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.style.backgroundColor = 'rgba(255, 255, 255, 0.95)';
                navbar.style.backdropFilter = 'blur(10px)';
            } else {
                navbar.style.backgroundColor = 'white';
                navbar.style.backdropFilter = 'none';
            }
        });
    </script>
</body>
</html>
