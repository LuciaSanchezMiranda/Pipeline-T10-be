package vallegrande.luSanchezMiranda.service;

import vallegrande.luSanchezMiranda.model.Customer;

import java.util.List;

public interface CustomerService {

    List<Customer> listar();
    Customer listarPorId(Integer id);
    List<Customer> listarPorEstado(String status);

    Customer guardar(Customer customer);
    Customer actualizar(Integer id, Customer customer);

    Customer eliminarLogico(Integer id);
    Customer restaurar(Integer id);
}