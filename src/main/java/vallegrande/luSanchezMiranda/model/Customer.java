package vallegrande.luSanchezMiranda.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.time.ZoneId;

@Entity
@Table(name = "CUSTOMER")
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
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

    @Column(name = "document_type", columnDefinition = "char(3)", nullable = false)
    private String documentType;

    @Column(name = "document_number", length = 15, nullable = false, unique = true)
    private String documentNumber;

    @Column(name = "email", length = 150, nullable = false, unique = true)
    private String email;

    @Column(name = "phone", columnDefinition = "char(9)", nullable = false)
    private String phone;

    @Column(name = "address", length = 200, nullable = false, columnDefinition = "nvarchar(200)")
    private String address;

    @Column(name = "status", nullable = false)
    private Boolean status = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "restored_at")
    private LocalDateTime restoredAt;

    @PrePersist
    protected void onCreate() {
        LocalDateTime now = LocalDateTime.now(ZoneId.of("America/Lima"));
        this.createdAt = now;
        this.updatedAt = now;
        if (this.status == null) {
            this.status = true;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now(ZoneId.of("America/Lima"));
    }
}