package controller;

import dao.BookingDAO;
import dao.DestinationDAO;
import dao.PackageDAO;
import model.Booking;
import model.Destination;
import model.Package;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/my-bookings")
public class MyBookingsServlet extends HttpServlet {
    private BookingDAO bookingDAO;
    private DestinationDAO destinationDAO;
    private PackageDAO packageDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        destinationDAO = new DestinationDAO();
        packageDAO = new PackageDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        // 检查用户是否登录
        if (username == null) {
            // 未登录，重定向到登录页面
            response.sendRedirect("login.jsp?redirect=my-bookings");
            return;
        }
        
        // 获取分页参数
        int page = 1;
        int pageSize = 10;
        
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
            
            String pageSizeParam = request.getParameter("pageSize");
            if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                pageSize = Integer.parseInt(pageSizeParam);
            }
        } catch (NumberFormatException e) {
            // 使用默认值
        }
        
        // 确保分页参数有效
        page = Math.max(page, 1);
        pageSize = Math.max(pageSize, 5);
        pageSize = Math.min(pageSize, 50);
        
        // 查询用户的预订记录
        List<Booking> bookings = bookingDAO.getBookingsByUserWithPagination(username, page, pageSize);
        int totalCount = bookingDAO.getTotalBookingCountByUser(username);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        // 计算分页显示范围
        int startPage = Math.max(1, page - 2);
        int endPage = Math.min(totalPages, page + 2);
        
        // 获取所有目的地和套餐信息以便显示名称
        List<Destination> destinations = destinationDAO.getAllDestinations();
        List<Package> packages = packageDAO.getAllPackages();
        
        // 设置请求属性
        request.setAttribute("bookings", bookings);
        request.setAttribute("destinations", destinations);
        request.setAttribute("packages", packages);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("username", username);
        
        // 转发到JSP页面
        request.getRequestDispatcher("my-bookings.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 