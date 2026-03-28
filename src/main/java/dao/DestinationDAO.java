package dao;

import model.Destination;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DestinationDAO {
    
    public List<Destination> getAllDestinations() {
        List<Destination> destinations = new ArrayList<>();
        String sql = "SELECT * FROM destinations WHERE is_active = true";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Destination destination = new Destination();
                destination.setId(rs.getInt("id"));
                destination.setName(rs.getString("name"));
                destination.setDescription(rs.getString("description"));
                destination.setImage(rs.getString("image"));
                destination.setActive(rs.getBoolean("is_active"));
                destinations.add(destination);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return destinations;
    }
    
    // 管理员专用：获取所有目的地（包括已禁用的）
    public List<Destination> getAllDestinationsForAdmin() {
        List<Destination> destinations = new ArrayList<>();
        String sql = "SELECT * FROM destinations ORDER BY id DESC";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Destination destination = new Destination();
                destination.setId(rs.getInt("id"));
                destination.setName(rs.getString("name"));
                destination.setDescription(rs.getString("description"));
                destination.setImage(rs.getString("image"));
                destination.setActive(rs.getBoolean("is_active"));
                destinations.add(destination);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all destinations for admin: " + e.getMessage());
            e.printStackTrace();
        }
        return destinations;
    }
    
    public Destination getDestinationById(int id) {
        String sql = "SELECT * FROM destinations WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Destination destination = new Destination();
                destination.setId(rs.getInt("id"));
                destination.setName(rs.getString("name"));
                destination.setDescription(rs.getString("description"));
                destination.setImage(rs.getString("image"));
                destination.setActive(rs.getBoolean("is_active"));
                return destination;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean createDestination(Destination destination) {
        String sql = "INSERT INTO destinations (name, description, image, is_active) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, destination.getName());
            pstmt.setString(2, destination.getDescription());
            pstmt.setString(3, destination.getImage());
            pstmt.setBoolean(4, destination.isActive());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateDestination(Destination destination) {
        String sql = "UPDATE destinations SET name = ?, description = ?, image = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, destination.getName());
            pstmt.setString(2, destination.getDescription());
            pstmt.setString(3, destination.getImage());
            pstmt.setBoolean(4, destination.isActive());
            pstmt.setInt(5, destination.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteDestination(int id) {
        String sql = "DELETE FROM destinations WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 分页查询管理员目的地列表
    public List<Destination> getDestinationsForAdminWithPagination(int page, int pageSize) {
        List<Destination> destinations = new ArrayList<>();
        String sql = "SELECT * FROM destinations ORDER BY id DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Destination destination = new Destination();
                destination.setId(rs.getInt("id"));
                destination.setName(rs.getString("name"));
                destination.setDescription(rs.getString("description"));
                destination.setImage(rs.getString("image"));
                destination.setActive(rs.getBoolean("is_active"));
                destinations.add(destination);
            }
        } catch (SQLException e) {
            System.err.println("Error getting destinations with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return destinations;
    }
    
    // 获取目的地总数量
    public int getTotalDestinationCount() {
        String sql = "SELECT COUNT(*) as total FROM destinations";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total destination count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // 分页查询活跃的目的地（前台使用）
    public List<Destination> getDestinationsWithPagination(int page, int pageSize) {
        List<Destination> destinations = new ArrayList<>();
        String sql = "SELECT * FROM destinations WHERE is_active = true ORDER BY id DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Destination destination = new Destination();
                destination.setId(rs.getInt("id"));
                destination.setName(rs.getString("name"));
                destination.setDescription(rs.getString("description"));
                destination.setImage(rs.getString("image"));
                destination.setActive(rs.getBoolean("is_active"));
                destinations.add(destination);
            }
        } catch (SQLException e) {
            System.err.println("Error getting active destinations with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return destinations;
    }
    
    // 获取活跃目的地的总数量（前台使用）
    public int getTotalActiveDestinationCount() {
        String sql = "SELECT COUNT(*) as total FROM destinations WHERE is_active = true";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total active destination count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
