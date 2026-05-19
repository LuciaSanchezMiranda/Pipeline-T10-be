package vallegrande.luSanchezMiranda.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "PRODUCTS_SALE")
@Data
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class ProductSale {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "products_sale_id")
    private Integer productsSaleId;

    @NotNull(message = "El nombre del producto no puede ser nulo")
    @Size(max = 100, message = "El nombre del producto no puede exceder los 100 caracteres")
    @Column(name = "product_name", length = 100, nullable = false)
    private String productName;

    @NotNull(message = "El precio no puede ser nulo")
    @DecimalMin(value = "0.01", message = "El precio debe ser mayor a 0")
    @Column(name = "price", precision = 10, scale = 2, nullable = false)
    private BigDecimal price;

    @NotNull(message = "El stock disponible no puede ser nulo")
    @Min(value = 0, message = "El stock disponible no puede ser negativo")
    @Column(name = "available_stock", nullable = false)
    private Integer availableStock = 0;

    @NotNull(message = "La unidad de medida no puede ser nula")
    @Pattern(regexp = "^(UNIDAD|KG|LITRO|SACO|SOBRE|ROLLO)$", message = "La unidad de medida debe ser una de las siguientes: UNIDAD, KG, LITRO, SACO, SOBRE, ROLLO")
    @Column(name = "unit_measurement", length = 30, nullable = false)
    private String unitMeasurement;

    @NotNull(message = "La descripción no puede ser nula")
    @Size(max = 255, message = "La descripción no puede exceder los 255 caracteres")
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

