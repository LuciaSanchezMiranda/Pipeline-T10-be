package vallegrande.luSanchezMiranda.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.Product;
import vallegrande.luSanchezMiranda.service.ProductService;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "*")
public class ProductRest {

    @Autowired
    private ProductService productService;

    @GetMapping
    public ResponseEntity<List<Product>> getAllProducts() {
        List<Product> products = productService.getAllProducts();
        return ResponseEntity.ok(products);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Integer id) {
        Optional<Product> product = productService.getProductById(id);
        return product.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        Product createdProduct = productService.createProduct(product);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdProduct);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Integer id, @RequestBody Product productDetails) {
        try {
            Product updatedProduct = productService.updateProduct(id, productDetails);
            return ResponseEntity.ok(updatedProduct);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Integer id) {
        try {
            productService.deleteProduct(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/search/nombre")
    public ResponseEntity<List<Product>> findByNombreProducto(@RequestParam String nombre) {
        List<Product> products = productService.findByNombreProducto(nombre);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/search/categoria/{idCategoria}")
    public ResponseEntity<List<Product>> findByIdCategoria(@PathVariable Integer idCategoria) {
        List<Product> products = productService.findByIdCategoria(idCategoria);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/search/proveedor/{idProveedor}")
    public ResponseEntity<List<Product>> findByIdProveedor(@PathVariable Integer idProveedor) {
        List<Product> products = productService.findByIdProveedor(idProveedor);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/search/estado/{estado}")
    public ResponseEntity<List<Product>> findByEstado(@PathVariable String estado) {
        List<Product> products = productService.findByEstado(estado);
        return ResponseEntity.ok(products);
    }
}
