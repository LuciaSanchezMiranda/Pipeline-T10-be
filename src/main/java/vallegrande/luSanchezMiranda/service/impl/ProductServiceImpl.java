package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vallegrande.luSanchezMiranda.model.Product;
import vallegrande.luSanchezMiranda.repository.ProductRepository;
import vallegrande.luSanchezMiranda.service.ProductService;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;

@Service
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductRepository productRepository;

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Optional<Product> getProductById(Integer id) {
        return productRepository.findById(id);
    }

    @Override
    public List<Product> findByEstado(String estado) {
        return productRepository.findByEstado(estado);
    }

    @Override
    public Product createProduct(Product product) {
        product.setCreatedAt(LocalDateTime.now());
        product.setUpdatedAt(LocalDateTime.now());
        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Integer id, Product productDetails) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado con id: " + id));

        product.setNombreProducto(productDetails.getNombreProducto());
        product.setIdCategoria(productDetails.getIdCategoria());
        product.setPrecio(productDetails.getPrecio());
        product.setUnidadMedida(productDetails.getUnidadMedida());
        product.setIdProveedor(productDetails.getIdProveedor());
        product.setStockDisponible(productDetails.getStockDisponible());
        product.setEstado(productDetails.getEstado());
        product.setUpdatedAt(LocalDateTime.now());

        return productRepository.save(product);
    }

    // ✅ Eliminar lógico → cambia estado a "Inactivo"
    @Override
    public Product eliminarProducto(Integer id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado con id: " + id));
        product.setEstado("Inactivo");
        product.setDeletedAt(LocalDateTime.now());
        return productRepository.save(product);
    }

    // ✅ Restaurar lógico → cambia estado a "Activo"
    @Override
    public Product restaurarProducto(Integer id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Producto no encontrado con id: " + id));
        product.setEstado("Activo");
        product.setRestoredAt(LocalDateTime.now());
        return productRepository.save(product);
    }

    @Override
    public List<Product> findByNombreProducto(String nombreProducto) {
        return productRepository.findByNombreProductoContainingIgnoreCase(nombreProducto);
    }

    @Override
    public List<Product> findByIdCategoria(Integer idCategoria) {
        return productRepository.findByIdCategoria(idCategoria);
    }

    @Override
    public List<Product> findByIdProveedor(Integer idProveedor) {
        return productRepository.findByIdProveedor(idProveedor);
    }
}