package dao;

import model.Booking;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {
    
    public boolean createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (username, customer_name, customer_email, customer_phone, " +
                    "destination_id, package_id, payment_method, payment_info, total_amount, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, booking.getUsername());
            pstmt.setString(2, booking.getCustomerName());
            pstmt.setString(3, booking.getCustomerEmail());
            pstmt.setString(4, booking.getCustomerPhone());
            pstmt.setInt(5, booking.getDestinationId());
            pstmt.setInt(6, booking.getPackageId());
            pstmt.setString(7, booking.getPaymentMethod());
            pstmt.setString(8, booking.getPaymentInfo());
            pstmt.setBigDecimal(9, booking.getTotalAmount());
            pstmt.setString(10, booking.getStatus());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Booking> getBookingsByUser(String username) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE username = ? ORDER BY booking_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUsername(rs.getString("username"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setCustomerEmail(rs.getString("customer_email"));
                booking.setCustomerPhone(rs.getString("customer_phone"));
                booking.setDestinationId(rs.getInt("destination_id"));
                booking.setPackageId(rs.getInt("package_id"));
                booking.setPaymentMethod(rs.getString("payment_method"));
                booking.setPaymentInfo(rs.getString("payment_info"));
                booking.setTotalAmount(rs.getBigDecimal("total_amount"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setStatus(rs.getString("status"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY booking_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUsername(rs.getString("username"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setCustomerEmail(rs.getString("customer_email"));
                booking.setCustomerPhone(rs.getString("customer_phone"));
                booking.setDestinationId(rs.getInt("destination_id"));
                booking.setPackageId(rs.getInt("package_id"));
                booking.setPaymentMethod(rs.getString("payment_method"));
                booking.setPaymentInfo(rs.getString("payment_info"));
                booking.setTotalAmount(rs.getBigDecimal("total_amount"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setStatus(rs.getString("status"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    
    public Booking getBookingById(int id) {
        String sql = "SELECT * FROM bookings WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUsername(rs.getString("username"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setCustomerEmail(rs.getString("customer_email"));
                booking.setCustomerPhone(rs.getString("customer_phone"));
                booking.setDestinationId(rs.getInt("destination_id"));
                booking.setPackageId(rs.getInt("package_id"));
                booking.setPaymentMethod(rs.getString("payment_method"));
                booking.setPaymentInfo(rs.getString("payment_info"));
                booking.setTotalAmount(rs.getBigDecimal("total_amount"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setStatus(rs.getString("status"));
                return booking;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateBookingStatus(int id, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // 分页查询所有预订记录
    public List<Booking> getAllBookingsWithPagination(int page, int pageSize) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings ORDER BY booking_date DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUsername(rs.getString("username"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setCustomerEmail(rs.getString("customer_email"));
                booking.setCustomerPhone(rs.getString("customer_phone"));
                booking.setDestinationId(rs.getInt("destination_id"));
                booking.setPackageId(rs.getInt("package_id"));
                booking.setPaymentMethod(rs.getString("payment_method"));
                booking.setPaymentInfo(rs.getString("payment_info"));
                booking.setTotalAmount(rs.getBigDecimal("total_amount"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setStatus(rs.getString("status"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            System.err.println("Error getting bookings with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }
    
    // 获取预订总数量
    public int getTotalBookingCount() {
        String sql = "SELECT COUNT(*) as total FROM bookings";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total booking count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // 按状态统计预订数量
    public int getBookingCountByStatus(String status) {
        String sql = "SELECT COUNT(*) as total FROM bookings WHERE status = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error getting booking count by status: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // 获取总收入（已确认和已完成的预订）
    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_amount) as total FROM bookings WHERE status IN ('confirmed', 'completed')";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
        } catch (SQLException e) {
            System.err.println("Error getting total revenue: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }
    
    // 分页查询指定用户的预订记录
    public List<Booking> getBookingsByUserWithPagination(String username, int page, int pageSize) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE username = ? ORDER BY booking_date DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setInt(2, pageSize);
            pstmt.setInt(3, (page - 1) * pageSize);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUsername(rs.getString("username"));
                booking.setCustomerName(rs.getString("customer_name"));
                booking.setCustomerEmail(rs.getString("customer_email"));
                booking.setCustomerPhone(rs.getString("customer_phone"));
                booking.setDestinationId(rs.getInt("destination_id"));
                booking.setPackageId(rs.getInt("package_id"));
                booking.setPaymentMethod(rs.getString("payment_method"));
                booking.setPaymentInfo(rs.getString("payment_info"));
                booking.setTotalAmount(rs.getBigDecimal("total_amount"));
                booking.setBookingDate(rs.getTimestamp("booking_date"));
                booking.setStatus(rs.getString("status"));
                bookings.add(booking);
            }
        } catch (SQLException e) {
            System.err.println("Error getting user bookings with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return bookings;
    }
    
    // 获取指定用户的预订总数量
    public int getTotalBookingCountByUser(String username) {
        String sql = "SELECT COUNT(*) as total FROM bookings WHERE username = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("Error getting user booking count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
}
