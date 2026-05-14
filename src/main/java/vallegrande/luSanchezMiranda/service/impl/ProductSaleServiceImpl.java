package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vallegrande.luSanchezMiranda.model.ProductSale;
import vallegrande.luSanchezMiranda.repository.ProductSaleRepository;
import vallegrande.luSanchezMiranda.service.ProductSaleService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ProductSaleServiceImpl implements ProductSaleService {

    @Autowired
    private ProductSaleRepository repository;

    @Override
    public List<ProductSale> listar() {
        return repository.findAll();
    }

    @Override
    public ProductSale listarPorId(Integer id) {
        return repository.findById(id).orElse(null);
    }

    @Override
    public List<ProductSale> listarActivos() {
        return repository.findByDeletedAtIsNull();
    }

    @Override
    public List<ProductSale> listarInactivos() {
        return repository.findByDeletedAtIsNotNull();
    }

    @Override
    public ProductSale guardar(ProductSale product) {
        return repository.save(product);
    }

    @Override
    public ProductSale actualizar(Integer id, ProductSale product) {
        Optional<ProductSale> existente = repository.findById(id);

        if (existente.isPresent()) {
            ProductSale p = existente.get();

            p.setCategoryId(product.getCategoryId());
            p.setProductName(product.getProductName());
            p.setPrice(product.getPrice());
            p.setAvailableStock(product.getAvailableStock());
            p.setUnitMeasurement(product.getUnitMeasurement());
            p.setDescription(product.getDescription());
            // No copiar fechas de auditoría del request

            return repository.save(p);
        }

        return null;
    }

    @Override
    public ProductSale eliminarLogico(Integer id) {
        ProductSale p = listarPorId(id);
        if (p != null) {
            p.setDeletedAt(LocalDateTime.now());
            return repository.save(p);
        }
        return null;
    }

    @Override
    public ProductSale restaurar(Integer id) {
        ProductSale p = listarPorId(id);
        if (p != null) {
            p.setDeletedAt(null);
            return repository.save(p);
        }
        return null;
    }
}