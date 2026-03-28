package controller;

import dao.BookingDAO;
import dao.DestinationDAO;
import dao.PackageDAO;
import model.Booking;
import model.Destination;
import model.Package;
import model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
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

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String destinationIdStr = request.getParameter("destinationId");
        String packageIdStr = request.getParameter("packageId");

        if (destinationIdStr != null && packageIdStr != null) {
            try {
                int destinationId = Integer.parseInt(destinationIdStr);
                int packageId = Integer.parseInt(packageIdStr);

                Destination destination = destinationDAO.getDestinationById(destinationId);
                Package selectedPackage = packageDAO.getPackageById(packageId);

                // 获取当前登录用户信息
                User currentUser = (User) session.getAttribute("user");

                request.setAttribute("destination", destination);
                request.setAttribute("selectedPackage", selectedPackage);
                request.setAttribute("currentUser", currentUser);
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect("destinations");
            }
        } else {
            response.sendRedirect("destinations");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // 获取表单数据
            String customerName = request.getParameter("customerName");
            String customerEmail = request.getParameter("customerEmail");
            String customerPhone = request.getParameter("customerPhone");
            int destinationId = Integer.parseInt(request.getParameter("destinationId"));
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            String paymentMethod = request.getParameter("paymentMethod");
            String paymentInfo = request.getParameter("paymentInfo");
            BigDecimal totalAmount = new BigDecimal(request.getParameter("totalAmount"));

            // 创建预订对象
            Booking booking = new Booking();
            booking.setUsername(username);
            booking.setCustomerName(customerName);
            booking.setCustomerEmail(customerEmail);
            booking.setCustomerPhone(customerPhone);
            booking.setDestinationId(destinationId);
            booking.setPackageId(packageId);
            booking.setPaymentMethod(paymentMethod);
            booking.setPaymentInfo(paymentInfo);
            booking.setTotalAmount(totalAmount);
            // 待确认
            booking.setStatus("pending");

            // 保存预订
            boolean success = bookingDAO.createBooking(booking);

            if (success) {
                // 获取目的地和套餐信息用于确认页面
                Destination destination = destinationDAO.getDestinationById(destinationId);
                Package selectedPackage = packageDAO.getPackageById(packageId);

                request.setAttribute("booking", booking);
                request.setAttribute("destination", destination);
                request.setAttribute("selectedPackage", selectedPackage);
                request.getRequestDispatcher("/booking-success.jsp").forward(request, response);
            } else {
                // 获取目的地和套餐信息重新显示页面
                Destination destination = destinationDAO.getDestinationById(destinationId);
                Package selectedPackage = packageDAO.getPackageById(packageId);
                User currentUser = (User) session.getAttribute("user");

                request.setAttribute("destination", destination);
                request.setAttribute("selectedPackage", selectedPackage);
                request.setAttribute("currentUser", currentUser);
                request.setAttribute("error", "预订失败，请稍后重试");
                request.getRequestDispatcher("/booking.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                // 获取参数重新显示页面
                int destinationId = Integer.parseInt(request.getParameter("destinationId"));
                int packageId = Integer.parseInt(request.getParameter("packageId"));

                Destination destination = destinationDAO.getDestinationById(destinationId);
                Package selectedPackage = packageDAO.getPackageById(packageId);
                User currentUser = (User) session.getAttribute("user");

                request.setAttribute("destination", destination);
                request.setAttribute("selectedPackage", selectedPackage);
                request.setAttribute("currentUser", currentUser);
            } catch (Exception ex) {
                // 如果获取数据也失败，只设置错误信息
            }
            request.setAttribute("error", "预订过程中发生错误：" + e.getMessage());
            request.getRequestDispatcher("/booking.jsp").forward(request, response);
        }
    }
}
