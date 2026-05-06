package vallegrande.luSanchezMiranda.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "CUSTOMER")
@Data
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_customer")
    private Integer idCustomer;

    @Column(name = "ubigeo_code", nullable = false)
    private Integer ubigeoCode;

    @Column(name = "customer_type", length = 20, nullable = false)
    private String customerType;

    @Column(name = "customer_number", length = 15, nullable = false)
    private String customerNumber;

    @Column(name = "customer_name", length = 50, nullable = false)
    private String customerName;

    @Column(name = "customer_lastname", length = 60)
    private String customerLastname;

    @Column(name = "phone", length = 9, nullable = false)
    private String phone;

    @Column(name = "email", length = 150, nullable = false)
    private String email;

    @Column(name = "address", length = 255, nullable = false)
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
        createdAt = LocalDateTime.now();
        if (status == null) {
            status = "activo";
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}