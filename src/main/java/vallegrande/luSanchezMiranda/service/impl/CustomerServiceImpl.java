package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vallegrande.luSanchezMiranda.model.Customer;
import vallegrande.luSanchezMiranda.repository.CustomerRepository;
import vallegrande.luSanchezMiranda.service.CustomerService;

import java.util.List;
import java.util.Optional;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerRepository repository;

    @Override
    public List<Customer> listar() {
        return repository.findAll();
    }

    @Override
    public Customer listarPorId(Integer id) {
        return repository.findById(id).orElse(null);
    }

    @Override
    public List<Customer> listarPorEstado(String status) {
        return repository.findByStatus(status);
    }

    @Override
    public Customer guardar(Customer customer) {
        customer.setStatus("ACTIVO");
        return repository.save(customer);
    }

    @Override
    public Customer actualizar(Integer id, Customer customer) {
        Optional<Customer> existente = repository.findById(id);

        if (existente.isPresent()) {
            Customer c = existente.get();

            c.setNameCustomer(customer.getNameCustomer());
            c.setLastnameCustomer(customer.getLastnameCustomer());
            c.setTypeCustomer(customer.getTypeCustomer());
            c.setPhone(customer.getPhone());
            c.setAddress(customer.getAddress());
            c.setEmail(customer.getEmail());
            c.setIdUbigeo(customer.getIdUbigeo());
            c.setDocumentType(customer.getDocumentType());
            c.setDocumentNumber(customer.getDocumentNumber());

            return repository.save(c);
        }

        return null;
    }

    @Override
    public Customer eliminarLogico(Integer id) {
        Customer c = listarPorId(id);
        if (c != null) {
            c.setStatus("INACTIVO");
            return repository.save(c);
        }
        return null;
    }

    @Override
    public Customer restaurar(Integer id) {
        Customer c = listarPorId(id);
        if (c != null) {
            c.setStatus("ACTIVO");
            return repository.save(c);
        }
        return null;
    }
}