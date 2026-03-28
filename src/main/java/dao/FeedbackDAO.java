package dao;

import model.Feedback;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    /**
     * 保存反馈信息到数据库
     */
    public boolean saveFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (customer_name, email, overall_rating, feedback_type, " +
                    "detailed_feedback, contact_phone, allow_contact) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, feedback.getCustomerName());
            pstmt.setString(2, feedback.getEmail());
            pstmt.setInt(3, feedback.getOverallRating());
            pstmt.setString(4, feedback.getFeedbackType());
            pstmt.setString(5, feedback.getDetailedFeedback());
            pstmt.setString(6, feedback.getContactPhone());
            pstmt.setBoolean(7, feedback.isAllowContact());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                // 获取生成的主键
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    feedback.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error saving feedback: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 根据ID获取反馈信息
     */
    public Feedback getFeedbackById(int id) {
        String sql = "SELECT * FROM feedback WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToFeedback(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting feedback by id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 获取所有反馈信息
     */
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM feedback ORDER BY created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                feedbackList.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all feedback: " + e.getMessage());
            e.printStackTrace();
        }
        return feedbackList;
    }

    /**
     * 分页查询反馈信息
     */
    public List<Feedback> getFeedbackWithPagination(int page, int pageSize) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM feedback ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                feedbackList.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting feedback with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return feedbackList;
    }

    /**
     * 获取反馈总数
     */
    public int getTotalFeedbackCount() {
        String sql = "SELECT COUNT(*) as total FROM feedback";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total feedback count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 根据反馈类型查询反馈
     */
    public List<Feedback> getFeedbackByType(String feedbackType) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE feedback_type = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, feedbackType);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                feedbackList.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting feedback by type: " + e.getMessage());
            e.printStackTrace();
        }
        return feedbackList;
    }

    /**
     * 根据评分查询反馈
     */
    public List<Feedback> getFeedbackByRating(int rating) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE overall_rating = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, rating);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                feedbackList.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error getting feedback by rating: " + e.getMessage());
            e.printStackTrace();
        }
        return feedbackList;
    }

    /**
     * 获取平均评分
     */
    public double getAverageRating() {
        String sql = "SELECT AVG(overall_rating) as avg_rating FROM feedback";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        } catch (SQLException e) {
            System.err.println("Error getting average rating: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * 按评分统计反馈数量
     */
    public int getFeedbackCountByRating(int rating) {
        String sql = "SELECT COUNT(*) as count FROM feedback WHERE overall_rating = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, rating);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.err.println("Error getting feedback count by rating: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 删除反馈信息
     */
    public boolean deleteFeedback(int id) {
        String sql = "DELETE FROM feedback WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting feedback: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 将ResultSet映射为Feedback对象
     */
    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getInt("id"));
        feedback.setCustomerName(rs.getString("customer_name"));
        feedback.setEmail(rs.getString("email"));
        feedback.setOverallRating(rs.getInt("overall_rating"));
        feedback.setFeedbackType(rs.getString("feedback_type"));
        feedback.setDetailedFeedback(rs.getString("detailed_feedback"));
        feedback.setContactPhone(rs.getString("contact_phone"));
        feedback.setAllowContact(rs.getBoolean("allow_contact"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        feedback.setUpdatedAt(rs.getTimestamp("updated_at"));
        return feedback;
    }
} 