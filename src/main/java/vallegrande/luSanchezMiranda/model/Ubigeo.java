package vallegrande.luSanchezMiranda.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "UBIGEO")
@Data
public class Ubigeo {

    @Id
    @Column(name = "ubigeo_code")
    private Integer ubigeoCode;

    @Column(name = "department", length = 100, nullable = false)
    private String department;

    @Column(name = "province", length = 100, nullable = false)
    private String province;

    @Column(name = "district", length = 100, nullable = false)
    private String district;
}
