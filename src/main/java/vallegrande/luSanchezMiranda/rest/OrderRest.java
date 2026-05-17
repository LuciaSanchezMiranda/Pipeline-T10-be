package vallegrande.luSanchezMiranda.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.Order;
import vallegrande.luSanchezMiranda.service.OrderService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/order")
@Tag(name = "Order", description = "CRUD de Pedidos")
public class OrderRest {

    @Autowired
    private OrderService service;

    @Operation(summary = "Listar pedidos")
    @GetMapping
    public List<Order> listar() {
        return service.listar();
    }

    @Operation(summary = "Buscar pedido por ID")
    @GetMapping("/{id}")
    public Order listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    @Operation(summary = "Crear pedido")
    @PostMapping
    public Order guardar(@RequestBody Order order) {
        return service.guardar(order);
    }

    @Operation(summary = "Actualizar pedido")
    @PutMapping("/{id}")
    public Order actualizar(@PathVariable Integer id, @RequestBody Order order) {
        return service.actualizar(id, order);
    }

    @Operation(summary = "Eliminación lógica de pedido")
    @DeleteMapping("/{id}")
    public Order eliminar(@PathVariable Integer id) {
        return service.eliminarLogico(id);
    }

    @Operation(summary = "Restaurar pedido inactivo")
    @PatchMapping("/restaurar/{id}")
    public Order restaurar(@PathVariable Integer id) {
        return service.restaurar(id);
    }
}
