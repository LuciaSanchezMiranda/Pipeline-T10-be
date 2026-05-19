package vallegrande.luSanchezMiranda.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.dto.StockMovementRequest;
import vallegrande.luSanchezMiranda.dto.StockMovementResponse;
import vallegrande.luSanchezMiranda.service.StockMovementService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/stock-movement")
@Tag(name = "StockMovement", description = "CRUD de Movimientos de Stock")
public class StockMovementRest {

    @Autowired
    private StockMovementService service;

    @Operation(summary = "Listar movimientos de stock", description = "Obtiene la lista completa de movimientos de stock.")
    @GetMapping
    public List<StockMovementResponse> listar() {
        return service.listar();
    }

    @Operation(summary = "Buscar movimiento por ID", description = "Obtiene los datos de un movimiento de stock específico según su ID.")
    @GetMapping("/{id}")
    public StockMovementResponse listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    @Operation(summary = "Crear nuevo movimiento de stock", description = "Registra un nuevo movimiento de stock en el sistema.")
    @PostMapping
    public StockMovementResponse guardar(@RequestBody StockMovementRequest request) {
        return service.guardar(request);
    }

    @Operation(summary = "Actualizar movimiento de stock", description = "Modifica los datos de un movimiento de stock existente.")
    @PutMapping("/{id}")
    public StockMovementResponse actualizar(@PathVariable Integer id, @RequestBody StockMovementRequest request) {
        return service.actualizar(id, request);
    }

    @Operation(summary = "Eliminar movimiento de stock", description = "Elimina un movimiento de stock de la base de datos por su ID.")
    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable Integer id) {
        service.eliminar(id);
    }
}
