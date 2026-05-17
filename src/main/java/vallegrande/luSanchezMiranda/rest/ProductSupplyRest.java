package vallegrande.luSanchezMiranda.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.ProductSupply;
import vallegrande.luSanchezMiranda.service.ProductSupplyService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/product-supply")
public class ProductSupplyRest {

    @Autowired
    private ProductSupplyService service;

    // LISTAR TODOS
    @GetMapping
    public List<ProductSupply> listar() {
        return service.listar();
    }

    // LISTAR ACTIVOS
    @GetMapping("/activos")
    public List<ProductSupply> listarActivos() {
        return service.listarActivos();
    }

    // LISTAR INACTIVOS (ELIMINADOS)
    @GetMapping("/inactivos")
    public List<ProductSupply> listarInactivos() {
        return service.listarInactivos();
    }

    // BUSCAR POR ID
    @GetMapping("/{id}")
    public ProductSupply listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    // GUARDAR
    @PostMapping
    public ProductSupply guardar(@RequestBody ProductSupply product) {
        return service.guardar(product);
    }

    // ACTUALIZAR
    @PutMapping("/{id}")
    public ProductSupply actualizar(@PathVariable Integer id, @RequestBody ProductSupply product) {
        return service.actualizar(id, product);
    }

    // ELIMINAR LOGICO
    @PatchMapping("/eliminar/{id}")
    public ProductSupply eliminarLogico(@PathVariable Integer id) {
        return service.eliminarLogico(id);
    }

    // RESTAURAR
    @PatchMapping("/restaurar/{id}")
    public ProductSupply restaurar(@PathVariable Integer id) {
        return service.restaurar(id);
    }
}
