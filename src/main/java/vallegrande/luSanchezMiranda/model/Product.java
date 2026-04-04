package vallegrande.luSanchezMiranda.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "PRODUCTO")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_producto")
    private Integer idProducto;

    @Column(name = "Nombre_Producto", length = 30, nullable = false)
    private String nombreProducto;

    @Column(name = "id_Categoria", nullable = false)
    private Integer idCategoria;

    @Column(name = "Precio", precision = 10, scale = 2, nullable = false)
    private BigDecimal precio;

    @Column(name = "Unidad_medida", length = 10, nullable = false)
    private String unidadMedida;

    @Column(name = "id_proveedor", nullable = false)
    private Integer idProveedor;

    @Column(name = "stock_disponible", precision = 10, scale = 2, nullable = false)
    private BigDecimal stockDisponible;

    @Column(name = "Estado", length = 20, nullable = false)
    private String estado;

    // Constructores
    public Product() {
    }

    public Product(String nombreProducto, Integer idCategoria, BigDecimal precio,
                   String unidadMedida, Integer idProveedor, BigDecimal stockDisponible, String estado) {
        this.nombreProducto = nombreProducto;
        this.idCategoria = idCategoria;
        this.precio = precio;
        this.unidadMedida = unidadMedida;
        this.idProveedor = idProveedor;
        this.stockDisponible = stockDisponible;
        this.estado = estado;
    }

    // Getters y Setters
    public Integer getIdProducto() {
        return idProducto;
    }

    public void setIdProducto(Integer idProducto) {
        this.idProducto = idProducto;
    }

    public String getNombreProducto() {
        return nombreProducto;
    }

    public void setNombreProducto(String nombreProducto) {
        this.nombreProducto = nombreProducto;
    }

    public Integer getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(Integer idCategoria) {
        this.idCategoria = idCategoria;
    }

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public String getUnidadMedida() {
        return unidadMedida;
    }

    public void setUnidadMedida(String unidadMedida) {
        this.unidadMedida = unidadMedida;
    }

    public Integer getIdProveedor() {
        return idProveedor;
    }

    public void setIdProveedor(Integer idProveedor) {
        this.idProveedor = idProveedor;
    }

    public BigDecimal getStockDisponible() {
        return stockDisponible;
    }

    public void setStockDisponible(BigDecimal stockDisponible) {
        this.stockDisponible = stockDisponible;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return "Product{" +
                "idProducto=" + idProducto +
                ", nombreProducto='" + nombreProducto + '\'' +
                ", idCategoria=" + idCategoria +
                ", precio=" + precio +
                ", unidadMedida='" + unidadMedida + '\'' +
                ", idProveedor=" + idProveedor +
                ", stockDisponible=" + stockDisponible +
                ", estado='" + estado + '\'' +
                '}';
    }
}
