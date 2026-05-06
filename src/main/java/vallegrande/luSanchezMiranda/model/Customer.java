package vallegrande.luSanchezMiranda.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "CUSTOMER")
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_customer")
    private Integer idCustomer;

    @ManyToOne
    @JoinColumn(name = "ubigeo_code", nullable = false)
    private Ubigeo ubigeo;

    @Column(name = "customer_name", length = 50, nullable = false)
    private String customerName;

    @Column(name = "customer_lastname", length = 60, nullable = false)
    private String customerLastname;

    @Column(name = "customer_type", length = 20, nullable = false)
    private String customerType;

    @Column(name = "document_type", length = 5, nullable = false)
    private String documentType;

    @Column(name = "document_number", length = 15, nullable = false)
    private String documentNumber;

    @Column(name = "email", length = 150, nullable = false)
    private String email;

    @Column(name = "phone", columnDefinition = "char(9)", nullable = false)
    private String phone;

    @org.hibernate.annotations.ColumnTransformer(read = "address.STAsText()", write = "geography::STGeomFromText(?, 4326)")
    @Column(name = "address", columnDefinition = "geography", nullable = false)
    private String address;

    @Column(name = "status", length = 10, nullable = false)
    private String status = "activo";

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "restored_at")
    private LocalDateTime restoredAt;

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now();
        this.createdAt = now;
        this.updatedAt = now;
        if (this.status == null) {
            this.status = "activo";
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}