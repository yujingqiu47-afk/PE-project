package model;

import java.math.BigDecimal;

public class Package {
    private int id;
    private int destinationId;
    private String name;
    private String description;
    private BigDecimal price;
    private String features;
    private boolean isActive;

    public Package() {}

    public Package(int id, int destinationId, String name, String description, 
                  BigDecimal price, String features, boolean isActive) {
        this.id = id;
        this.destinationId = destinationId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.features = features;
        this.isActive = isActive;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getDestinationId() { return destinationId; }
    public void setDestinationId(int destinationId) { this.destinationId = destinationId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getFeatures() { return features; }
    public void setFeatures(String features) { this.features = features; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
