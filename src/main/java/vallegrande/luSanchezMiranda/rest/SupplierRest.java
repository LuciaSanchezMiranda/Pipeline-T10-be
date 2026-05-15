package vallegrande.luSanchezMiranda.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.Supplier;
import vallegrande.luSanchezMiranda.service.SupplierService;

import java.util.List;

@RestController
@RequestMapping("/api/supplier")
public class SupplierRest {

    @Autowired
    private SupplierService service;

    // LISTAR
    @GetMapping
    public List<Supplier> listar() {
        return service.listar();
    }

    // LISTAR POR ID
    @GetMapping("/{id}")
    public Supplier listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    // LISTAR POR ESTADO
    @GetMapping("/estado/{status}")
    public List<Supplier> listarPorEstado(@PathVariable Boolean status) {
        return service.listarPorEstado(status);
    }

    // CREAR
    @PostMapping
    public Supplier guardar(@RequestBody Supplier supplier) {
        return service.guardar(supplier);
    }

    // EDITAR
    @PutMapping("/{id}")
    public Supplier actualizar(@PathVariable Integer id, @RequestBody Supplier supplier) {
        return service.actualizar(id, supplier);
    }

    // ELIMINAR LOGICO
    @PatchMapping("/eliminar/{id}")
    public Supplier eliminar(@PathVariable Integer id) {
        return service.eliminarLogico(id);
    }

    // RESTAURAR
    @PatchMapping("/restaurar/{id}")
    public Supplier restaurar(@PathVariable Integer id) {
        return service.restaurar(id);
    }
}
