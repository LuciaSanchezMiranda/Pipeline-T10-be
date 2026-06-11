package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vallegrande.luSanchezMiranda.model.Sale;
import vallegrande.luSanchezMiranda.model.SaleDetail;
import vallegrande.luSanchezMiranda.repository.SaleRepository;
import vallegrande.luSanchezMiranda.service.SaleService;

import java.util.ArrayList;
import java.util.List;

@Service
public class SaleServiceImpl implements SaleService {

    @Autowired
    private SaleRepository repository;

    @Transactional(readOnly = true)
    @Override
    public List<Sale> listar() {
        return repository.findAll();
    }

    @Transactional(readOnly = true)
    @Override
    public Sale listarPorId(Integer id) {
        return repository.findById(id).orElse(null);
    }

    @Transactional
    @Override
    public Sale guardar(Sale sale) {
        sale.setSaleId(null);
        if (sale.getDetails() != null) {
            for (SaleDetail detail : sale.getDetails()) {
                detail.setIdSaleDetail(null);
                detail.setSale(sale);
            }
        }
        return repository.save(sale);
    }

    @Transactional
    @Override
    public Sale actualizar(Integer id, Sale sale) {
        Sale existing = repository.findById(id).orElse(null);
        if (existing != null) {
            if (sale.getSaleDate() != null) existing.setSaleDate(sale.getSaleDate());
            if (sale.getReceiptType() != null) existing.setReceiptType(sale.getReceiptType());
            if (sale.getPaymentMethod() != null) existing.setPaymentMethod(sale.getPaymentMethod());
            if (sale.getStatus() != null) existing.setStatus(sale.getStatus());
            if (sale.getTotalCost() != null) existing.setTotalCost(sale.getTotalCost());
            if (sale.getEmployee() != null) existing.setEmployee(sale.getEmployee());
            if (sale.getCustomer() != null) existing.setCustomer(sale.getCustomer());
            
            if (sale.getDetails() != null) {
                if (existing.getDetails() == null) {
                    existing.setDetails(new ArrayList<>());
                } else {
                    existing.getDetails().clear();
                }
                for (SaleDetail detail : sale.getDetails()) {
                    detail.setIdSaleDetail(null);
                    detail.setSale(existing);
                    existing.getDetails().add(detail);
                }
            }
            return repository.save(existing);
        }
        return null;
    }

    @Transactional
    @Override
    public Sale eliminar(Integer id) {
        Sale existing = repository.findById(id).orElse(null);
        if (existing != null) {
            existing.setStatus("anulada");
            return repository.save(existing);
        }
        return null;
    }
}
