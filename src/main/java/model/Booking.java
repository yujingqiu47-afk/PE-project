package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Booking {
    private int id;
    private String username;
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    private int destinationId;
    private int packageId;
    private String paymentMethod;
    private String paymentInfo;
    private BigDecimal totalAmount;
    private Timestamp bookingDate;
    private String status;

    public Booking() {}

    public Booking(int id, String username, String customerName, String customerEmail, 
                  String customerPhone, int destinationId, int packageId, String paymentMethod,
                  String paymentInfo, BigDecimal totalAmount, Timestamp bookingDate, String status) {
        this.id = id;
        this.username = username;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.customerPhone = customerPhone;
        this.destinationId = destinationId;
        this.packageId = packageId;
        this.paymentMethod = paymentMethod;
        this.paymentInfo = paymentInfo;
        this.totalAmount = totalAmount;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }

    public int getPackageId() { return packageId; }
    public void setPackageId(int packageId) { this.packageId = packageId; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentInfo() { return paymentInfo; }
    public void setPaymentInfo(String paymentInfo) { this.paymentInfo = paymentInfo; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public Timestamp getBookingDate() { return bookingDate; }
    public void setBookingDate(Timestamp bookingDate) { this.bookingDate = bookingDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
