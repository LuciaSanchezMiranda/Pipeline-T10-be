package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vallegrande.luSanchezMiranda.model.Customer;
import vallegrande.luSanchezMiranda.repository.CustomerRepository;
import vallegrande.luSanchezMiranda.service.CustomerService;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;
import java.time.ZoneId;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerRepository repository;

    // Listar todos los clientes
    @Transactional(readOnly = true)
    @Override
    public List<Customer> listar() {
        return repository.findAll();
    }

    // Buscar cliente por su ID
    @Override
    public Customer listarPorId(Integer id) {
        return repository.findById(id).orElse(null);
    }

    // Filtrar clientes por estado (true/false)
    @Override
    public List<Customer> listarPorEstado(Boolean status) {
        return repository.findByStatus(status);
    }

    // Filtrar clientes por tipo (Natural/Jurídico)
    @Override
    public List<Customer> listarPorTipo(String type) {
        return repository.findByCustomerTypeIgnoreCase(type);
    }

    // Filtrar clientes por estado y tipo simultáneamente
    @Override
    public List<Customer> listarPorEstadoYTipo(Boolean status, String type) {
        return repository.findByStatusAndCustomerTypeIgnoreCase(status, type);
    }

    // Crear un nuevo cliente (asegurando que el ID sea nulo para generar uno nuevo)
    @Transactional
    @Override
    public Customer guardar(Customer customer) {
        customer.setIdCustomer(null); // Forzar creación de nuevo registro
        if (customer.getStatus() == null) {
            customer.setStatus(true);
        }
        return repository.save(customer);
    }

    // Actualizar un cliente existente buscando por ID y mapeando campos
    @Transactional
    @Override
    public Customer actualizar(Integer id, Customer customer) {
        return repository.findById(id).map(existing -> {
            // Solo actualizar los campos que vienen en la petición (soporte para actualizaciones parciales)
            if (customer.getUbigeo() != null) existing.setUbigeo(customer.getUbigeo());
            if (customer.getCustomerName() != null) existing.setCustomerName(customer.getCustomerName());
            if (customer.getCustomerLastname() != null) existing.setCustomerLastname(customer.getCustomerLastname());
            if (customer.getCustomerType() != null) existing.setCustomerType(customer.getCustomerType());
            if (customer.getDocumentType() != null) existing.setDocumentType(customer.getDocumentType());
            if (customer.getDocumentNumber() != null) existing.setDocumentNumber(customer.getDocumentNumber());
            if (customer.getEmail() != null) existing.setEmail(customer.getEmail());
            if (customer.getPhone() != null) existing.setPhone(customer.getPhone());
            if (customer.getAddress() != null) existing.setAddress(customer.getAddress());
            if (customer.getStatus() != null) existing.setStatus(customer.getStatus());
            
            // repository.save sobre un objeto ya gestionado (existing) realiza un UPDATE en vez de INSERT
            return repository.save(existing);
        }).orElse(null);
    }

    // Eliminación lógica del cliente (cambio de estado a inactivo)
    @Transactional
    @Override
    public Customer eliminarLogico(Integer id) {
        return repository.findById(id).map(c -> {
            c.setStatus(false);
            c.setDeletedAt(LocalDateTime.now(ZoneId.of("America/Lima")));
            c.setRestoredAt(null);
            return repository.save(c);
        }).orElse(null);
    }

    // Restauración de un cliente previamente eliminado (cambio de estado a activo)
    @Transactional
    @Override
    public Customer restaurar(Integer id) {
        return repository.findById(id).map(c -> {
            c.setStatus(true);
            c.setRestoredAt(LocalDateTime.now(ZoneId.of("America/Lima")));
            c.setDeletedAt(null);
            return repository.save(c);
        }).orElse(null);
    }
}