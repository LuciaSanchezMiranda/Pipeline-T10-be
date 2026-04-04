package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vallegrande.luSanchezMiranda.model.Product;
import vallegrande.luSanchezMiranda.repository.ProductRepository;
import vallegrande.luSanchezMiranda.service.ProductService;

import java.util.List;
import java.util.Optional;

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
    public Product createProduct(Product product) {
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
        
        return productRepository.save(product);
    }

    @Override
    public void deleteProduct(Integer id) {
        if (!productRepository.existsById(id)) {
            throw new RuntimeException("Producto no encontrado con id: " + id);
        }
        productRepository.deleteById(id);
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

    @Override
    public List<Product> findByEstado(String estado) {
        return productRepository.findByEstado(estado);
    }
}
