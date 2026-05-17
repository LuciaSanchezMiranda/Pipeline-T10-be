package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vallegrande.luSanchezMiranda.model.SaleDetail;
import vallegrande.luSanchezMiranda.repository.SaleDetailRepository;
import vallegrande.luSanchezMiranda.service.SaleDetailService;

import java.util.List;

@Service
public class SaleDetailServiceImpl implements SaleDetailService {

    @Autowired
    private SaleDetailRepository repository;

    @Transactional(readOnly = true)
    @Override
    public List<SaleDetail> listar() {
        return repository.findAll();
    }

    @Transactional(readOnly = true)
    @Override
    public SaleDetail listarPorId(Integer id) {
        return repository.findById(id).orElse(null);
    }

    @Transactional
    @Override
    public SaleDetail guardar(SaleDetail saleDetail) {
        saleDetail.setIdSaleDetail(null);
        return repository.save(saleDetail);
    }

    @Transactional
    @Override
    public SaleDetail actualizar(Integer id, SaleDetail saleDetail) {
        SaleDetail existing = repository.findById(id).orElse(null);
        if (existing != null) {
            if (saleDetail.getUnitPrice() != null) existing.setUnitPrice(saleDetail.getUnitPrice());
            if (saleDetail.getProductAmount() != null) existing.setProductAmount(saleDetail.getProductAmount());
            if (saleDetail.getSubtotalCost() != null) existing.setSubtotalCost(saleDetail.getSubtotalCost());
            if (saleDetail.getProductSale() != null) existing.setProductSale(saleDetail.getProductSale());
            if (saleDetail.getSale() != null) existing.setSale(saleDetail.getSale());
            return repository.save(existing);
        }
        return null;
    }

    @Transactional
    @Override
    public void eliminar(Integer id) {
        repository.deleteById(id);
    }
}
