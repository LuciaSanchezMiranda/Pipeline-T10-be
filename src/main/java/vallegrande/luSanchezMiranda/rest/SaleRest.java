package vallegrande.luSanchezMiranda.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.Sale;
import vallegrande.luSanchezMiranda.service.SaleService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/sale")
@Tag(name = "Sale", description = "CRUD de Ventas")
public class SaleRest {

    @Autowired
    private SaleService service;

    @Operation(summary = "Listar ventas")
    @GetMapping
    public List<Sale> listar() {
        return service.listar();
    }

    @Operation(summary = "Buscar venta por ID")
    @GetMapping("/{id}")
    public Sale listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    @Operation(summary = "Crear venta")
    @PostMapping
    public Sale guardar(@RequestBody Sale sale) {
        return service.guardar(sale);
    }

    @Operation(summary = "Actualizar venta")
    @PutMapping("/{id}")
    public Sale actualizar(@PathVariable Integer id, @RequestBody Sale sale) {
        return service.actualizar(id, sale);
    }

    @Operation(summary = "Eliminar venta")
    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable Integer id) {
        service.eliminar(id);
    }
}
