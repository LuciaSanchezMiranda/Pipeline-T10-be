package vallegrande.luSanchezMiranda.model;

import jakarta.persistence.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "PRODUCTS_SALE")
@Data
public class ProductSale {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "products_sale_id")
    private Integer productsSaleId;

    @Column(name = "product_name", length = 100, nullable = false)
    private String productName;

    @Column(name = "price", precision = 10, scale = 2, nullable = false)
    private BigDecimal price;

    @Column(name = "available_stock", nullable = false)
    private Integer availableStock = 0;

    @Column(name = "unit_measurement", length = 30, nullable = false)
    private String unitMeasurement;

    @Column(name = "description", columnDefinition = "CHAR(255)", nullable = false)
    private String description;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "restored_at")
    private LocalDateTime restoredAt;

    @Column(name = "category_id", nullable = false)
    private Integer categoryId;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (availableStock == null) {
            availableStock = 0;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}

