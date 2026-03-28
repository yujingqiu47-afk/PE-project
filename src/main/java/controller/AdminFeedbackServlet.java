package controller;

import dao.FeedbackDAO;
import model.Feedback;
import util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/admin/feedback")
public class AdminFeedbackServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 检查管理员权限
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        
        if (username == null || !"admin".equals(role)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        try {
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            
            // 分页参数
            int page = 1;
            int pageSize = 10;
            
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // 筛选参数
            String feedbackType = request.getParameter("feedbackType");
            String ratingParam = request.getParameter("rating");
            Integer rating = null;
            if (ratingParam != null && !ratingParam.isEmpty()) {
                try {
                    rating = Integer.parseInt(ratingParam);
                } catch (NumberFormatException e) {
                    rating = null;
                }
            }
            
            // 获取反馈列表
            List<Feedback> feedbackList;
            int totalCount;
            
            if (feedbackType != null && !feedbackType.isEmpty()) {
                feedbackList = feedbackDAO.getFeedbackByType(feedbackType);
                totalCount = feedbackList.size();
                // 手动分页
                int startIndex = (page - 1) * pageSize;
                int endIndex = Math.min(startIndex + pageSize, feedbackList.size());
                if (startIndex < feedbackList.size()) {
                    feedbackList = feedbackList.subList(startIndex, endIndex);
                } else {
                    feedbackList = Collections.emptyList();
                }
            } else if (rating != null) {
                feedbackList = feedbackDAO.getFeedbackByRating(rating);
                totalCount = feedbackList.size();
                // 手动分页
                int startIndex = (page - 1) * pageSize;
                int endIndex = Math.min(startIndex + pageSize, feedbackList.size());
                if (startIndex < feedbackList.size()) {
                    feedbackList = feedbackList.subList(startIndex, endIndex);
                } else {
                    feedbackList = Collections.emptyList();
                }
            } else {
                feedbackList = feedbackDAO.getFeedbackWithPagination(page, pageSize);
                totalCount = feedbackDAO.getTotalFeedbackCount();
            }
            
            // 计算分页信息
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);
            
            // 获取统计信息
            double averageRating = feedbackDAO.getAverageRating();
            
            // 设置请求属性
            request.setAttribute("feedbackList", feedbackList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("feedbackType", feedbackType);
            request.setAttribute("rating", rating);
            
            // 转发到反馈管理页面
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误：" + e.getMessage());
            request.getRequestDispatcher("feedback.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 检查管理员权限
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        
        if (username == null || !"admin".equals(role)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deleteFeedback(request, response);
        } else {
            response.sendRedirect("feedback");
        }
    }
    
    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("feedback?error=invalid_id");
            return;
        }
        
        try {
            int feedbackId = Integer.parseInt(idParam);
            
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            boolean success = feedbackDAO.deleteFeedback(feedbackId);
            
            if (success) {
                response.sendRedirect("feedback?success=deleted");
            } else {
                response.sendRedirect("feedback?error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("feedback?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("feedback?error=system_error");
        }
    }
} 