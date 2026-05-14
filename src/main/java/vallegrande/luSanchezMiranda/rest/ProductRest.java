package vallegrande.luSanchezMiranda.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.ProductSale;
import vallegrande.luSanchezMiranda.service.ProductService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/products")
public class ProductRest {

    @Autowired
    private ProductService service;

    // LISTAR TODOS
    @GetMapping
    public List<ProductSale> listar() {
        return service.listar();
    }

    // LISTAR ACTIVOS
    @GetMapping("/active")
    public List<ProductSale> listarActivos() {
        return service.listarActivos();
    }

    // LISTAR INACTIVOS (ELIMINADOS)
    @GetMapping("/inactive")
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
    public ProductSale guardar(@RequestBody ProductSale product) {
        return service.guardar(product);
    }

    // ACTUALIZAR
    @PutMapping("/{id}")
    public ProductSale actualizar(@PathVariable Integer id, @RequestBody ProductSale product) {
        return service.actualizar(id, product);
    }

    // ELIMINAR LOGICO
    @PatchMapping("/delete/{id}")
    public ProductSale eliminarLogico(@PathVariable Integer id) {
        return service.eliminarLogico(id);
    }

    // RESTAURAR
    @PatchMapping("/restore/{id}")
    public ProductSale restaurar(@PathVariable Integer id) {
        return service.restaurar(id);
    }
}