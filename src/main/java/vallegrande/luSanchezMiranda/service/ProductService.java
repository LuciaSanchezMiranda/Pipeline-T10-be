package vallegrande.luSanchezMiranda.service;

import vallegrande.luSanchezMiranda.model.Product;
import java.util.List;
import java.util.Optional;

public interface ProductService {

    List<Product> getAllProducts();

    Optional<Product> getProductById(Integer id);

    List<Product> findByEstado(String estado);

    Product createProduct(Product product);

    Product updateProduct(Integer id, Product product);

    // ✅ Eliminar lógico → Inactivo
    Product eliminarProducto(Integer id);

    // ✅ Restaurar lógico → Activo
    Product restaurarProducto(Integer id);

    List<Product> findByNombreProducto(String nombreProducto);

    List<Product> findByIdCategoria(Integer idCategoria);

    List<Product> findByIdProveedor(Integer idProveedor);
}