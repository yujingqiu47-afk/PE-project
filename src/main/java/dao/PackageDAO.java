package dao;

import model.Package;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PackageDAO {
    
    public List<Package> getPackagesByDestination(int destinationId) {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM packages WHERE destination_id = ? AND is_active = true";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, destinationId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("id"));
                pkg.setDestinationId(rs.getInt("destination_id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setFeatures(rs.getString("features"));
                pkg.setActive(rs.getBoolean("is_active"));
                packages.add(pkg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return packages;
    }
    
    public Package getPackageById(int id) {
        String sql = "SELECT * FROM packages WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("id"));
                pkg.setDestinationId(rs.getInt("destination_id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setFeatures(rs.getString("features"));
                pkg.setActive(rs.getBoolean("is_active"));
                return pkg;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Package> getAllPackages() {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM packages WHERE is_active = true";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("id"));
                pkg.setDestinationId(rs.getInt("destination_id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setFeatures(rs.getString("features"));
                pkg.setActive(rs.getBoolean("is_active"));
                packages.add(pkg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return packages;
    }
    
    // 管理员专用：获取所有套餐（包括已禁用的）
    public List<Package> getAllPackagesForAdmin() {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM packages ORDER BY id DESC";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("id"));
                pkg.setDestinationId(rs.getInt("destination_id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setFeatures(rs.getString("features"));
                pkg.setActive(rs.getBoolean("is_active"));
                packages.add(pkg);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all packages for admin: " + e.getMessage());
            e.printStackTrace();
        }
        return packages;
    }
    
    public boolean createPackage(Package pkg) {
        String sql = "INSERT INTO packages (destination_id, name, description, price, features, is_active) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pkg.getDestinationId());
            pstmt.setString(2, pkg.getName());
            pstmt.setString(3, pkg.getDescription());
            pstmt.setBigDecimal(4, pkg.getPrice());
            pstmt.setString(5, pkg.getFeatures());
            pstmt.setBoolean(6, pkg.isActive());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePackage(Package pkg) {
        String sql = "UPDATE packages SET destination_id = ?, name = ?, description = ?, price = ?, features = ?, is_active = ? WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pkg.getDestinationId());
            pstmt.setString(2, pkg.getName());
            pstmt.setString(3, pkg.getDescription());
            pstmt.setBigDecimal(4, pkg.getPrice());
            pstmt.setString(5, pkg.getFeatures());
            pstmt.setBoolean(6, pkg.isActive());
            pstmt.setInt(7, pkg.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deletePackage(int id) {
        String sql = "DELETE FROM packages WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 分页查询管理员套餐列表
    public List<Package> getPackagesForAdminWithPagination(int page, int pageSize) {
        List<Package> packages = new ArrayList<>();
        String sql = "SELECT * FROM packages ORDER BY id DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Package pkg = new Package();
                pkg.setId(rs.getInt("id"));
                pkg.setDestinationId(rs.getInt("destination_id"));
                pkg.setName(rs.getString("name"));
                pkg.setDescription(rs.getString("description"));
                pkg.setPrice(rs.getBigDecimal("price"));
                pkg.setFeatures(rs.getString("features"));
                pkg.setActive(rs.getBoolean("is_active"));
                packages.add(pkg);
            }
        } catch (SQLException e) {
            System.err.println("Error getting packages with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return packages;
    }
    
    // 获取套餐总数量
    public int getTotalPackageCount() {
        String sql = "SELECT COUNT(*) as total FROM packages";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total package count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
