package vallegrande.luSanchezMiranda.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "customer")
@Data
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_customer")
    private Integer idCustomer;

    @Column(name = "name_customer")
    private String nameCustomer;

    @Column(name = "lastname_customer")
    private String lastnameCustomer;

    @Column(name = "type_customer")
    private String typeCustomer;

    @Column(name = "phone")
    private String phone;

    @Column(name = "address")
    private String address;

    @Column(name = "email")
    private String email;

    @Column(name = "id_ubigeo")
    private Integer idUbigeo;

    @Column(name = "document_type")
    private String documentType;

    @Column(name = "document_number")
    private String documentNumber;

    @Column(name = "status")
    private String status; // ACTIVO / INACTIVO
}