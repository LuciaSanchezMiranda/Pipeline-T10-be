package vallegrande.luSanchezMiranda.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.SaleDetail;
import vallegrande.luSanchezMiranda.service.SaleDetailService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/saledetail")
@Tag(name = "Sale Detail", description = "CRUD de Detalles de Venta")
public class SaleDetailRest {

    @Autowired
    private SaleDetailService service;

    @Operation(summary = "Listar detalles de venta")
    @GetMapping
    public List<SaleDetail> listar() {
        return service.listar();
    }

    @Operation(summary = "Buscar detalle de venta por ID")
    @GetMapping("/{id}")
    public SaleDetail listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    @Operation(summary = "Crear detalle de venta")
    @PostMapping
    public SaleDetail guardar(@RequestBody SaleDetail saleDetail) {
        return service.guardar(saleDetail);
    }

    @Operation(summary = "Actualizar detalle de venta")
    @PutMapping("/{id}")
    public SaleDetail actualizar(@PathVariable Integer id, @RequestBody SaleDetail saleDetail) {
        return service.actualizar(id, saleDetail);
    }

    @Operation(summary = "Eliminar detalle de venta")
    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable Integer id) {
        service.eliminar(id);
    }
}
