package vallegrande.luSanchezMiranda.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.Purchase;
import vallegrande.luSanchezMiranda.service.PurchaseService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/purchase")
@Tag(name = "Purchase", description = "CRUD de Órdenes de Compra (Purchases)")
public class PurchaseRest {

    @Autowired
    private PurchaseService service;

    // LISTAR
    @Operation(summary = "Listar compras", description = "Obtiene la lista completa de compras registradas con todos sus detalles.")
    @GetMapping
    public List<Purchase> listar() {
        return service.listar();
    }

    // LISTAR POR ID
    @Operation(summary = "Buscar compra por ID", description = "Obtiene una compra específica con todos sus detalles según su ID.")
    @GetMapping("/{id}")
    public Purchase listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    // LISTAR POR ESTADO
    @Operation(summary = "Listar compras por estado", description = "Obtiene la lista de compras filtrada por estado (ej. COMPLETADO, PENDIENTE, CANCELADO).")
    @GetMapping("/estado/{status}")
    public List<Purchase> listarPorEstado(@PathVariable String status) {
        return service.listarPorEstado(status);
    }

    // CREAR
    @Operation(summary = "Crear nueva compra", description = "Registra una nueva orden de compra con sus detalles. Si el estado es COMPLETADO, incrementa el stock de los productos correspondientes.")
    @PostMapping
    public Purchase guardar(@RequestBody Purchase purchase) {
        return service.guardar(purchase);
    }

    // EDITAR
    @Operation(summary = "Actualizar compra", description = "Modifica los datos y detalles de una compra existente, ajustando el stock de productos de forma consistente.")
    @PutMapping("/{id}")
    public Purchase actualizar(@PathVariable Integer id, @RequestBody Purchase purchase) {
        return service.actualizar(id, purchase);
    }

    // ELIMINAR LOGICO (CANCELAR COMPRA)
    @Operation(summary = "Cancelar compra (Lógico)", description = "Cambia el estado de la compra a CANCELADO y revierte el stock de los productos asociados si estaba COMPLETADA.")
    @PatchMapping("/eliminar/{id}")
    public Purchase eliminar(@PathVariable Integer id) {
        return service.eliminarLogico(id);
    }
}
