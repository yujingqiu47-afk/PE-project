package controller;

import dao.UserDAO;
import model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("loginRole"); // 获取用户选择的角色
        String redirectUrl = request.getParameter("redirect"); // 获取重定向URL

        if (userDAO.validateUser(username, password)) {
            User user = userDAO.findUserByUsername(username);
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("user", user);

            // 检查用户选择的角色是否与数据库中的角色匹配
            if ("admin".equals(selectedRole)) {
                // 用户选择了管理员登录
                if ("admin".equals(user.getRole())) {
                    session.setAttribute("role", "admin");
                    // 使用重定向而不是转发，避免重复请求
                    response.sendRedirect(request.getContextPath() + "/admin/");
                } else {
                    request.setAttribute("error", "您不是管理员，无法以管理员身份登录");
                    request.setAttribute("redirect", redirectUrl); // 保持重定向参数
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // 用户选择了普通用户登录
                session.setAttribute("role", "user");
                // 如果有重定向URL，优先重定向到指定页面
                if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/" + redirectUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/destinations");
                }
            }
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.setAttribute("redirect", redirectUrl); // 保持重定向参数
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
