package vallegrande.luSanchezMiranda.rest;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.ProductSale;
import vallegrande.luSanchezMiranda.service.ProductSaleService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/product-sale")
public class ProductSaleRest {

    @Autowired
    private ProductSaleService service;

    // LISTAR TODOS
    @GetMapping
    public List<ProductSale> listar() {
        return service.listar();
    }

    // LISTAR ACTIVOS
    @GetMapping("/activos")
    public List<ProductSale> listarActivos() {
        return service.listarActivos();
    }

    // LISTAR INACTIVOS (ELIMINADOS)
    @GetMapping("/inactivos")
    public List<ProductSale> listarInactivos() {
        return service.listarInactivos();
    }

    // BUSCAR POR ID
    @GetMapping("/{id}")
    public ProductSale listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    // GUARDAR
    @PostMapping
    public ProductSale guardar(@Valid @RequestBody ProductSale product) {
        return service.guardar(product);
    }

    // ACTUALIZAR
    @PutMapping("/{id}")
    public ProductSale actualizar(@PathVariable Integer id, @Valid @RequestBody ProductSale product) {
        return service.actualizar(id, product);
    }

    // ELIMINAR LOGICO
    @PatchMapping("/eliminar/{id}")
    public ProductSale eliminarLogico(@PathVariable Integer id) {
        return service.eliminarLogico(id);
    }

    // RESTAURAR
    @PatchMapping("/restaurar/{id}")
    public ProductSale restaurar(@PathVariable Integer id) {
        return service.restaurar(id);
    }
}