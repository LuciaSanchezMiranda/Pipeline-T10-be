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

    // ✅ Listar todos
    @GetMapping
    public ResponseEntity<List<Product>> getAllProducts() {
        List<Product> products = productService.getAllProducts();
        return ResponseEntity.ok(products);
    }

    // ✅ Listar x ID
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Integer id) {
        Optional<Product> product = productService.getProductById(id);
        return product.map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    // ✅ Listar x Estado
    @GetMapping("/estado/{estado}")
    public ResponseEntity<List<Product>> findByEstado(@PathVariable String estado) {
        List<Product> products = productService.findByEstado(estado);
        return ResponseEntity.ok(products);
    }

    // ✅ Crear
    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        Product createdProduct = productService.createProduct(product);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdProduct);
    }

    // ✅ Editar
    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Integer id, @RequestBody Product productDetails) {
        try {
            Product updatedProduct = productService.updateProduct(id, productDetails);
            return ResponseEntity.ok(updatedProduct);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // ✅ Eliminar lógico (PATCH) → estado = "Inactivo"
    @PatchMapping("/{id}/eliminar")
    public ResponseEntity<Product> eliminarProducto(@PathVariable Integer id) {
        try {
            Product updatedProduct = productService.eliminarProducto(id);
            return ResponseEntity.ok(updatedProduct);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // ✅ Restaurar lógico (PATCH) → estado = "Activo"
    @PatchMapping("/{id}/restaurar")
    public ResponseEntity<Product> restaurarProducto(@PathVariable Integer id) {
        try {
            Product updatedProduct = productService.restaurarProducto(id);
            return ResponseEntity.ok(updatedProduct);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Búsquedas adicionales
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
}