package vallegrande.luSanchezMiranda.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDate;

@Entity
@Table(name = "Supplier")
@Data
public class Supplier {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_supplier")
    private Integer idSupplier;

    @Column(name = "name")
    private String name;

    @Column(name = "ruc")
    private String ruc;

    @Column(name = "phone")
    private String phone;

    @Column(name = "address")
    private String address;

    @Column(name = "tipo")
    private String tipo;

    @Column(name = "company_name")
    private String companyName;

    @Column(name = "contact_name")
    private String contactName;

    @Column(name = "email")
    private String email;

    @Column(name = "credit_limit")
    private Double creditLimit;

    @Column(name = "created_date")
    private LocalDate createdDate;

    @Column(name = "status")
    private String status; // ACTIVO / INACTIVO
}