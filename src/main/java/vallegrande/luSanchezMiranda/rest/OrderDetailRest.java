package vallegrande.luSanchezMiranda.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.OrderDetail;
import vallegrande.luSanchezMiranda.service.OrderDetailService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/orderdetail")
@Tag(name = "Order Detail", description = "CRUD de Detalles de Pedido")
public class OrderDetailRest {

    @Autowired
    private OrderDetailService service;

    @Operation(summary = "Listar detalles de pedido")
    @GetMapping
    public List<OrderDetail> listar() {
        return service.listar();
    }

    @Operation(summary = "Buscar detalle de pedido por ID")
    @GetMapping("/{id}")
    public OrderDetail listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    @Operation(summary = "Crear detalle de pedido")
    @PostMapping
    public OrderDetail guardar(@RequestBody OrderDetail orderDetail) {
        return service.guardar(orderDetail);
    }

    @Operation(summary = "Actualizar detalle de pedido")
    @PutMapping("/{id}")
    public OrderDetail actualizar(@PathVariable Integer id, @RequestBody OrderDetail orderDetail) {
        return service.actualizar(id, orderDetail);
    }

    @Operation(summary = "Eliminar detalle de pedido")
    @DeleteMapping("/{id}")
    public void eliminar(@PathVariable Integer id) {
        service.eliminar(id);
    }
}
