package vallegrande.luSanchezMiranda.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import vallegrande.luSanchezMiranda.model.Customer;
import vallegrande.luSanchezMiranda.service.CustomerService;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/customer")
public class CustomerRest {

    @Autowired
    private CustomerService service;

    // LISTAR
    @GetMapping
    public List<Customer> listar() {
        return service.listar();
    }

    // LISTAR POR ID
    @GetMapping("/{id}")
    public Customer listarPorId(@PathVariable Integer id) {
        return service.listarPorId(id);
    }

    // LISTAR POR ESTADO
    @GetMapping("/estado/{status}")
    public List<Customer> listarPorEstado(@PathVariable String status) {
        return service.listarPorEstado(status);
    }

    // CREAR
    @PostMapping
    public Customer guardar(@RequestBody Customer customer) {
        return service.guardar(customer);
    }

    // EDITAR
    @PutMapping("/{id}")
    public Customer actualizar(@PathVariable Integer id, @RequestBody Customer customer) {
        return service.actualizar(id, customer);
    }

    // ELIMINAR LOGICO
    @DeleteMapping("/{id}")
    public Customer eliminar(@PathVariable Integer id) {
        return service.eliminarLogico(id);
    }

    // RESTAURAR
    @PatchMapping("/restaurar/{id}")
    public Customer restaurar(@PathVariable Integer id) {
        return service.restaurar(id);
    }
}