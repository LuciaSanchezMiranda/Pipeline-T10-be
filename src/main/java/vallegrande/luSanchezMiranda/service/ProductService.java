package vallegrande.luSanchezMiranda.service;

import vallegrande.luSanchezMiranda.model.Product;
import java.util.List;
import java.util.Optional;

public interface ProductService {
    
    List<Product> getAllProducts();
    
    Optional<Product> getProductById(Integer id);
    
    Product createProduct(Product product);
    
    Product updateProduct(Integer id, Product product);
    
    void deleteProduct(Integer id);
    
    List<Product> findByNombreProducto(String nombreProducto);
    
    List<Product> findByIdCategoria(Integer idCategoria);
    
    List<Product> findByIdProveedor(Integer idProveedor);
    
    List<Product> findByEstado(String estado);
}
