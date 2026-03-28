package filter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

/**
 * 字符编码过滤器
 * 用于设置请求和响应的字符编码为UTF-8，解决中文乱码问题
 */
@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    private boolean forceEncoding = false;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // 从配置中读取编码设置
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null) {
            this.encoding = encodingParam;
        }
        
        String forceParam = filterConfig.getInitParameter("forceEncoding");
        if (forceParam != null) {
            this.forceEncoding = "true".equalsIgnoreCase(forceParam);
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // 设置请求编码
        if (request.getCharacterEncoding() == null || forceEncoding) {
            request.setCharacterEncoding(encoding);
        }
        
        // 设置响应编码
        if (response.getCharacterEncoding() == null || forceEncoding) {
            response.setCharacterEncoding(encoding);
            response.setContentType("text/html; charset=" + encoding);
        }
        
        // 继续过滤器链
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // 清理资源
    }
} 