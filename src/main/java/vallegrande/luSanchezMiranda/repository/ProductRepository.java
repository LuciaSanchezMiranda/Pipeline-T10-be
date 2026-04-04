package vallegrande.luSanchezMiranda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vallegrande.luSanchezMiranda.model.Product;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {
    
    List<Product> findByNombreProductoContainingIgnoreCase(String nombreProducto);
    
    List<Product> findByIdCategoria(Integer idCategoria);
    
    List<Product> findByIdProveedor(Integer idProveedor);
    
    List<Product> findByEstado(String estado);
    
    Optional<Product> findByNombreProducto(String nombreProducto);
}
