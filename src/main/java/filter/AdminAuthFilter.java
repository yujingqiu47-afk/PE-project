package filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 初始化代码（如果需要的话）
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // 检查用户是否已登录并且是管理员
        if (session == null || 
            session.getAttribute("username") == null || 
            !"admin".equals(session.getAttribute("role"))) {
            
            // 重定向到登录页面，并带上错误消息
            String contextPath = httpRequest.getContextPath();
            httpResponse.sendRedirect(contextPath + "/login.jsp?error=您需要管理员权限才能访问此页面");
            return;
        }
        
        // 如果验证通过，继续执行请求
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 清理代码（如果需要的话）
    }
}
