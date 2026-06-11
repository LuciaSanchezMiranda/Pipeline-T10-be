package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vallegrande.luSanchezMiranda.dto.OrderRequest;
import vallegrande.luSanchezMiranda.dto.OrderResponse;
import vallegrande.luSanchezMiranda.model.*;
import vallegrande.luSanchezMiranda.repository.CustomerRepository;
import vallegrande.luSanchezMiranda.repository.EmployeeRepository;
import vallegrande.luSanchezMiranda.repository.OrderRepository;
import vallegrande.luSanchezMiranda.repository.ProductSaleRepository;
import vallegrande.luSanchezMiranda.service.OrderService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderRepository repository;

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private CustomerRepository customerRepository;

    @Autowired
    private ProductSaleRepository productSaleRepository;

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
            if (order.getDetails() != null) existing.setDetails(order.getDetails());
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

    // Método para convertir OrderRequest a Order
    public Order convertRequestToEntity(OrderRequest request) {
        Order order = new Order();
        order.setEstimatedDelivery(request.getEstimatedDelivery());
        order.setStatus(request.getStatus() != null ? request.getStatus() : "pendiente");
        order.setNotes(request.getNotes());

        // Asignar empleado y cliente
        if (request.getEmployeeId() != null) {
            Employee employee = employeeRepository.findById(request.getEmployeeId()).orElse(null);
            order.setEmployee(employee);
        }

        if (request.getIdCustomer() != null) {
            Customer customer = customerRepository.findById(request.getIdCustomer()).orElse(null);
            order.setCustomer(customer);
        }

        // Convertir detalles
        if (request.getDetails() != null && !request.getDetails().isEmpty()) {
            List<OrderDetail> details = new ArrayList<>();
            BigDecimal total = BigDecimal.ZERO;

            for (OrderRequest.OrderDetailRequest detailRequest : request.getDetails()) {
                OrderDetail detail = new OrderDetail();
                detail.setQuantity(detailRequest.getQuantity());
                detail.setUnitPrice(detailRequest.getUnitPrice());

                BigDecimal subtotal = detailRequest.getUnitPrice()
                        .multiply(BigDecimal.valueOf(detailRequest.getQuantity()));
                detail.setSubtotal(subtotal);
                detail.setOrder(order);

                // Asignar producto
                if (detailRequest.getProductsSaleId() != null) {
                    ProductSale productSale = productSaleRepository
                            .findById(detailRequest.getProductsSaleId()).orElse(null);
                    detail.setProductSale(productSale);
                }

                details.add(detail);
                total = total.add(subtotal);
            }

            order.setDetails(details);
            order.setTotalEstimated(total);
        }

        return order;
    }

    // Método para convertir Order a OrderResponse
    public OrderResponse convertEntityToResponse(Order order) {
        OrderResponse response = new OrderResponse();
        response.setOrderId(order.getOrderId());
        response.setOrderDate(order.getOrderDate());
        response.setEstimatedDelivery(order.getEstimatedDelivery());
        response.setStatus(order.getStatus());
        response.setNotes(order.getNotes());
        response.setTotalEstimated(order.getTotalEstimated());
        response.setCreatedAt(order.getCreatedAt());
        response.setUpdatedAt(order.getUpdatedAt());

        if (order.getEmployee() != null) {
            response.setEmployeeId(order.getEmployee().getEmployeeId());
            response.setEmployeeName(order.getEmployee().getName() + " " + order.getEmployee().getLastName());
        }

        if (order.getCustomer() != null) {
            response.setIdCustomer(order.getCustomer().getIdCustomer());
            response.setCustomerName(order.getCustomer().getCustomerName() + " " + order.getCustomer().getCustomerLastname());
        }

        // Convertir detalles
        if (order.getDetails() != null) {
            List<OrderResponse.OrderDetailResponse> details = order.getDetails().stream()
                    .map(d -> {
                        OrderResponse.OrderDetailResponse detailResponse = new OrderResponse.OrderDetailResponse();
                        detailResponse.setIdOrderDetail(d.getIdOrderDetail());
                        detailResponse.setProductsSaleId(d.getProductSale().getProductsSaleId());
                        detailResponse.setProductName(d.getProductSale().getProductName());
                        detailResponse.setQuantity(d.getQuantity());
                        detailResponse.setUnitPrice(d.getUnitPrice());
                        detailResponse.setSubtotal(d.getSubtotal());
                        return detailResponse;
                    })
                    .collect(Collectors.toList());
            response.setDetails(details);
        }

        return response;
    }
}
