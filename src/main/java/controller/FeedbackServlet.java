package controller;

import dao.FeedbackDAO;
import model.Feedback;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() throws ServletException {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        // 检查用户是否登录
        if (username == null) {
            // 未登录，重定向到登录页面
            response.sendRedirect("login.jsp?redirect=FeedbackServlet");
            return;
        }
        
        // 已登录，自动填充用户信息
        request.setAttribute("currentUser", session.getAttribute("user"));
        
        // 转发到反馈页面
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 获取表单数据
        String customerName = request.getParameter("customerName");
        String customerEmail = request.getParameter("customerEmail");
        String destination = request.getParameter("destination"); // 用于显示，不存储到数据库
        String ratingStr = request.getParameter("rating");
        String feedbackType = request.getParameter("feedbackType");
        String feedbackContent = request.getParameter("feedbackContent");
        String contactPhone = request.getParameter("contactPhone");
        String allowContact = request.getParameter("allowContact");

        // 基本验证
        if (isEmptyOrNull(customerName) || isEmptyOrNull(customerEmail) || 
            isEmptyOrNull(ratingStr) || isEmptyOrNull(feedbackType) || 
            isEmptyOrNull(feedbackContent)) {
            
            setErrorAndForward(request, response, "请填写所有必填项！");
            return;
        }

        // 验证邮箱格式
        if (!isValidEmail(customerEmail)) {
            setErrorAndForward(request, response, "请输入有效的邮箱地址！");
            return;
        }

        // 验证反馈内容长度
        if (feedbackContent.trim().length() < 10) {
            setErrorAndForward(request, response, "反馈内容至少需要10个字符！");
            return;
        }

        // 验证和解析评分
        int rating;
        try {
            rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                setErrorAndForward(request, response, "评分必须在1-5之间！");
                return;
            }
        } catch (NumberFormatException e) {
            setErrorAndForward(request, response, "评分格式不正确！");
            return;
        }

        // 验证联系电话格式（如果提供）
        if (!isEmptyOrNull(contactPhone) && !isValidPhone(contactPhone)) {
            setErrorAndForward(request, response, "请输入有效的联系电话！");
            return;
        }

        // 创建Feedback对象
        Feedback feedback = new Feedback();
        feedback.setCustomerName(customerName.trim());
        feedback.setEmail(customerEmail.trim());
        feedback.setOverallRating(rating);
        feedback.setFeedbackType(feedbackType);
        feedback.setDetailedFeedback(feedbackContent.trim());
        feedback.setContactPhone(isEmptyOrNull(contactPhone) ? null : contactPhone.trim());
        feedback.setAllowContact("true".equals(allowContact));

        try {
            // 保存反馈到数据库
            boolean success = feedbackDAO.saveFeedback(feedback);
            
            if (success) {
                // 设置成功消息
                String successMessage = buildSuccessMessage(feedback, destination);
                request.setAttribute("successMessage", successMessage);
                
                // 记录日志
                System.out.println("Feedback saved successfully: ID=" + feedback.getId() + 
                                 ", Customer=" + feedback.getCustomerName() + 
                                 ", Rating=" + feedback.getOverallRating());
            } else {
                setErrorAndForward(request, response, "保存反馈失败，请稍后再试！");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndForward(request, response, "系统错误，请稍后再试！");
            return;
        }

        // 转发回反馈页面显示结果
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    /**
     * 构建成功消息
     */
    private String buildSuccessMessage(Feedback feedback, String destination) {
        StringBuilder message = new StringBuilder();
        message.append("感谢您的反馈，").append(feedback.getCustomerName()).append("！");
        message.append("我们已收到您对");
        
        // 添加目的地信息（如果提供）
        if (!isEmptyOrNull(destination)) {
            message.append("「").append(destination).append("」");
        } else {
            message.append("我们服务");
        }
        
        message.append("的").append(feedback.getOverallRating()).append("星评价");
        
        // 根据反馈类型添加不同的回复
        switch (feedback.getFeedbackType()) {
            case "服务表扬":
                message.append("和表扬。您的认可是我们前进的动力！");
                break;
            case "服务投诉":
                message.append("和投诉。我们会认真对待并及时改进。");
                break;
            case "建议意见":
                message.append("和宝贵建议。我们会仔细考虑您的意见。");
                break;
            case "产品咨询":
                message.append("和产品咨询。我们会尽快为您提供详细信息。");
                break;
            default:
                message.append("和反馈意见。");
        }

        if (feedback.isAllowContact() && feedback.getContactPhone() != null) {
            message.append("我们会在24小时内通过您提供的联系方式与您取得联系。");
        }

        return message.toString();
    }

    /**
     * 设置错误消息并转发
     */
    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response, 
                                  String errorMessage) throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        
        // 保持表单数据
        request.setAttribute("formData", request.getParameterMap());
        
        request.getRequestDispatcher("feedback.jsp").forward(request, response);
    }

    /**
     * 检查字符串是否为空或null
     */
    private boolean isEmptyOrNull(String str) {
        return str == null || str.trim().isEmpty();
    }

    /**
     * 验证邮箱格式
     */
    private boolean isValidEmail(String email) {
        if (isEmptyOrNull(email)) return false;
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return email.matches(emailRegex);
    }

    /**
     * 验证手机号格式
     */
    private boolean isValidPhone(String phone) {
        if (isEmptyOrNull(phone)) return true; // 手机号是可选的
        // 简单的手机号验证（支持国内外格式）
        String phoneRegex = "^[\\d\\s\\-\\(\\)\\+]{7,20}$";
        return phone.matches(phoneRegex);
    }
}
