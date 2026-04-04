package vallegrande.luSanchezMiranda.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "customer")
@Data
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id_customer;

    private String nameCustomer;
    private String lastnameCustomer;
    private String typeCustomer;

    private String phone;
    private String address;
    private String email;

    private Integer idUbigeo;

    private String documentType;
    private String documentNumber;

    private String status; // ACTIVO / INACTIVO
}