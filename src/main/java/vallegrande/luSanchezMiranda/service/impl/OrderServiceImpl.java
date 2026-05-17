package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vallegrande.luSanchezMiranda.model.Order;
import vallegrande.luSanchezMiranda.repository.OrderRepository;
import vallegrande.luSanchezMiranda.service.OrderService;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderRepository repository;

    @Transactional(readOnly = true)
    @Override
    public List<Order> listar() {
        return repository.findAll();
    }

    @Transactional(readOnly = true)
    @Override
    public Order listarPorId(Integer id) {
        return repository.findById(id).orElse(null);
    }

    @Transactional
    @Override
    public Order guardar(Order order) {
        order.setOrderId(null);
        return repository.save(order);
    }

    @Transactional
    @Override
    public Order actualizar(Integer id, Order order) {
        Order existing = repository.findById(id).orElse(null);
        if (existing != null) {
            if (order.getOrderDate() != null) existing.setOrderDate(order.getOrderDate());
            if (order.getEstimatedDelivery() != null) existing.setEstimatedDelivery(order.getEstimatedDelivery());
            if (order.getStatus() != null) existing.setStatus(order.getStatus());
            if (order.getNotes() != null) existing.setNotes(order.getNotes());
            if (order.getTotalEstimated() != null) existing.setTotalEstimated(order.getTotalEstimated());
            if (order.getEmployee() != null) existing.setEmployee(order.getEmployee());
            if (order.getCustomer() != null) existing.setCustomer(order.getCustomer());
            return repository.save(existing);
        }
        return null;
    }

    @Transactional
    @Override
    public Order eliminarLogico(Integer id) {
        Order existing = repository.findById(id).orElse(null);
        if (existing != null) {
            existing.setStatus("cancelado");
            existing.setDeletedAt(LocalDateTime.now());
            return repository.save(existing);
        }
        return null;
    }

    @Transactional
    @Override
    public Order restaurar(Integer id) {
        Order existing = repository.findById(id).orElse(null);
        if (existing != null) {
            existing.setStatus("pendiente");
            existing.setRestoredAt(LocalDateTime.now());
            return repository.save(existing);
        }
        return null;
    }
}
