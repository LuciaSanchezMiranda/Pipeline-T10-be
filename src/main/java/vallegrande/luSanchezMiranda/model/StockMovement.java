package vallegrande.luSanchezMiranda.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "STOCK_MOVEMENT")
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class StockMovement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "movement")
    private Integer movement;

    @Column(name = "movement_type", length = 20, nullable = false)
    private String movementType;

    @Column(name = "movement_reason", length = 100, nullable = false)
    private String movementReason;

    @Column(name = "quantity", precision = 10, scale = 2, nullable = false)
    private BigDecimal quantity;

    @Column(name = "stock_before", precision = 10, scale = 2, nullable = false)
    private BigDecimal stockBefore;

    @Column(name = "stock_after", precision = 10, scale = 2, nullable = false)
    private BigDecimal stockAfter;

    @Column(name = "comments", length = 500, nullable = false)
    private String comments;

    @Column(name = "movement_date", nullable = false)
    private LocalDateTime movementDate;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @ManyToOne
    @JoinColumn(name = "sale_id", nullable = false)
    private Sale sale;

    @ManyToOne
    @JoinColumn(name = "batch_id", nullable = false)
    private ProductionBatch productionBatch;

    @ManyToOne
    @JoinColumn(name = "products_sale_id", nullable = false)
    private ProductSale productSale;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private ProductSupply productSupply;

    @ManyToOne
    @JoinColumn(name = "id_purchase", nullable = false)
    private Purchase purchase;

    @PrePersist
    protected void onCreate() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
        if (movementDate == null) {
            movementDate = LocalDateTime.now();
        }
    }
}
