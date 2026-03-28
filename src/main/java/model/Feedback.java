package model;

import java.sql.Timestamp;

public class Feedback {
    private int id;
    private String customerName;
    private String email;
    private int overallRating;
    private String feedbackType;
    private String detailedFeedback;
    private String contactPhone;
    private boolean allowContact;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Feedback() {}

    public Feedback(String customerName, String email, int overallRating, String feedbackType, 
                   String detailedFeedback, String contactPhone, boolean allowContact) {
        this.customerName = customerName;
        this.email = email;
        this.overallRating = overallRating;
        this.feedbackType = feedbackType;
        this.detailedFeedback = detailedFeedback;
        this.contactPhone = contactPhone;
        this.allowContact = allowContact;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getOverallRating() {
        return overallRating;
    }

    public void setOverallRating(int overallRating) {
        this.overallRating = overallRating;
    }

    public String getFeedbackType() {
        return feedbackType;
    }

    public void setFeedbackType(String feedbackType) {
        this.feedbackType = feedbackType;
    }

    public String getDetailedFeedback() {
        return detailedFeedback;
    }

    public void setDetailedFeedback(String detailedFeedback) {
        this.detailedFeedback = detailedFeedback;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public boolean isAllowContact() {
        return allowContact;
    }

    public void setAllowContact(boolean allowContact) {
        this.allowContact = allowContact;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "id=" + id +
                ", customerName='" + customerName + '\'' +
                ", email='" + email + '\'' +
                ", overallRating=" + overallRating +
                ", feedbackType='" + feedbackType + '\'' +
                ", detailedFeedback='" + detailedFeedback + '\'' +
                ", contactPhone='" + contactPhone + '\'' +
                ", allowContact=" + allowContact +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 