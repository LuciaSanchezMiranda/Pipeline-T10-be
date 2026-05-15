package vallegrande.luSanchezMiranda.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "SUPPLIER")
@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Supplier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "supplier_id")
    private Integer supplierId;

    @Column(name = "company_name", length = 150, nullable = false)
    private String companyName;

    @Column(name = "ruc", length = 11, nullable = false)
    private String ruc;

    @Column(name = "phone", nullable = false)
    private Long phone;

    @Column(name = "email", length = 100, nullable = false, unique = true)
    private String email;

    @Column(name = "address", length = 200, nullable = false)
    private String address;

    @Column(name = "status", nullable = false)
    private Boolean status = true;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @Column(name = "restored_at")
    private LocalDateTime restoredAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ubigeo_code", nullable = false)
    private Ubigeo ubigeo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (status == null) {
            status = true;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}