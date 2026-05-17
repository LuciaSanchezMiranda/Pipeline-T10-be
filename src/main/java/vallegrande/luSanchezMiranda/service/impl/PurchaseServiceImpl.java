package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vallegrande.luSanchezMiranda.model.*;
import vallegrande.luSanchezMiranda.repository.*;
import vallegrande.luSanchezMiranda.service.PurchaseService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class PurchaseServiceImpl implements PurchaseService {

    @Autowired
    private PurchaseRepository repository;

    @Autowired
    private SupplierRepository supplierRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private ProductSupplyRepository productSupplyRepository;

    @Override
    public List<Purchase> listar() {
        return repository.findAllWithDetails();
    }

    @Override
    public Purchase listarPorId(Integer id) {
        return repository.findByIdWithDetails(id).orElse(null);
    }

    @Override
    public List<Purchase> listarPorEstado(String status) {
        return repository.findByStatusWithDetails(status);
    }

    @Override
    @Transactional
    public Purchase guardar(Purchase purchase) {
        // Cargar Supplier y Employee correspondientes
        if (purchase.getSupplier() != null) {
            Supplier supplier = supplierRepository.findById(purchase.getSupplier().getSupplierId()).orElse(null);
            purchase.setSupplier(supplier);
        }
        if (purchase.getEmployee() != null) {
            Employee employee = employeeRepository.findById(purchase.getEmployee().getEmployeeId()).orElse(null);
            purchase.setEmployee(employee);
        }

        BigDecimal totalAmount = BigDecimal.ZERO;

        if (purchase.getDetails() != null) {
            for (PurchaseDetail detail : purchase.getDetails()) {
                detail.setPurchase(purchase);
                if (detail.getProduct() != null) {
                    ProductSupply product = productSupplyRepository.findById(detail.getProduct().getProductId()).orElse(null);
                    detail.setProduct(product);

                    // Recalcular costos
                    BigDecimal cost = detail.getUnitPrice().multiply(BigDecimal.valueOf(detail.getAmountProduct()));
                    detail.setTotalCost(cost);
                    totalAmount = totalAmount.add(cost);

                    // Afectar stock si el estado es COMPLETADO
                    if ("COMPLETADO".equalsIgnoreCase(purchase.getStatus()) && product != null) {
                        BigDecimal newStock = product.getAvailableStock().add(BigDecimal.valueOf(detail.getAmountProduct()));
                        product.setAvailableStock(newStock);
                        productSupplyRepository.save(product);
                    }
                }
            }
        }
        purchase.setTotalAmount(totalAmount);

        Purchase saved = repository.save(purchase);
        return repository.findByIdWithDetails(saved.getIdPurchase()).orElse(saved);
    }

    @Override
    @Transactional
    public Purchase actualizar(Integer id, Purchase purchase) {
        Optional<Purchase> existenteOpt = repository.findByIdWithDetails(id);
        if (existenteOpt.isPresent()) {
            Purchase existente = existenteOpt.get();

            // Si el estado anterior era COMPLETADO, revertimos temporalmente el stock del detalle viejo
            if ("COMPLETADO".equalsIgnoreCase(existente.getStatus())) {
                for (PurchaseDetail detail : existente.getDetails()) {
                    ProductSupply product = detail.getProduct();
                    if (product != null) {
                        BigDecimal revertedStock = product.getAvailableStock().subtract(BigDecimal.valueOf(detail.getAmountProduct()));
                        product.setAvailableStock(revertedStock);
                        productSupplyRepository.save(product);
                    }
                }
            }

            // Actualizar datos básicos
            if (purchase.getSupplier() != null) {
                Supplier supplier = supplierRepository.findById(purchase.getSupplier().getSupplierId()).orElse(null);
                existente.setSupplier(supplier);
            }
            if (purchase.getEmployee() != null) {
                Employee employee = employeeRepository.findById(purchase.getEmployee().getEmployeeId()).orElse(null);
                existente.setEmployee(employee);
            }
            if (purchase.getDatePurchases() != null) {
                existente.setDatePurchases(purchase.getDatePurchases());
            }
            if (purchase.getStatus() != null) {
                existente.setStatus(purchase.getStatus());
            }

            // Actualizar detalles si se envían en el cuerpo
            if (purchase.getDetails() != null) {
                // Limpiar detalles viejos
                existente.getDetails().clear();

                BigDecimal totalAmount = BigDecimal.ZERO;
                for (PurchaseDetail detail : purchase.getDetails()) {
                    detail.setPurchase(existente);
                    if (detail.getProduct() != null) {
                        ProductSupply product = productSupplyRepository.findById(detail.getProduct().getProductId()).orElse(null);
                        detail.setProduct(product);

                        BigDecimal cost = detail.getUnitPrice().multiply(BigDecimal.valueOf(detail.getAmountProduct()));
                        detail.setTotalCost(cost);
                        totalAmount = totalAmount.add(cost);

                        existente.getDetails().add(detail);
                    }
                }
                existente.setTotalAmount(totalAmount);
            } else {
                // Si no se envían nuevos detalles, recalculamos sobre los existentes
                BigDecimal totalAmount = BigDecimal.ZERO;
                for (PurchaseDetail detail : existente.getDetails()) {
                    BigDecimal cost = detail.getUnitPrice().multiply(BigDecimal.valueOf(detail.getAmountProduct()));
                    detail.setTotalCost(cost);
                    totalAmount = totalAmount.add(cost);
                }
                existente.setTotalAmount(totalAmount);
            }

            // Si el NUEVO estado es COMPLETADO, aplicamos el incremento de stock
            if ("COMPLETADO".equalsIgnoreCase(existente.getStatus())) {
                for (PurchaseDetail detail : existente.getDetails()) {
                    ProductSupply product = detail.getProduct();
                    if (product != null) {
                        BigDecimal newStock = product.getAvailableStock().add(BigDecimal.valueOf(detail.getAmountProduct()));
                        product.setAvailableStock(newStock);
                        productSupplyRepository.save(product);
                    }
                }
            }

            Purchase saved = repository.save(existente);
            return repository.findByIdWithDetails(saved.getIdPurchase()).orElse(saved);
        }
        return null;
    }

    @Override
    @Transactional
    public Purchase eliminarLogico(Integer id) {
        Purchase p = repository.findByIdWithDetails(id).orElse(null);
        if (p != null) {
            // Si el estado era COMPLETADO, debemos revertir el incremento del stock
            if ("COMPLETADO".equalsIgnoreCase(p.getStatus())) {
                for (PurchaseDetail detail : p.getDetails()) {
                    ProductSupply product = detail.getProduct();
                    if (product != null) {
                        BigDecimal newStock = product.getAvailableStock().subtract(BigDecimal.valueOf(detail.getAmountProduct()));
                        product.setAvailableStock(newStock);
                        productSupplyRepository.save(product);
                    }
                }
            }
            // Cambiar el estado a CANCELADO como eliminación lógica
            p.setStatus("CANCELADO");
            Purchase saved = repository.save(p);
            return repository.findByIdWithDetails(saved.getIdPurchase()).orElse(saved);
        }
        return null;
    }
}
