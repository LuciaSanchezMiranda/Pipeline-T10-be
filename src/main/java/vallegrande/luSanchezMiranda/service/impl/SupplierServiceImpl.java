package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vallegrande.luSanchezMiranda.model.Supplier;
import vallegrande.luSanchezMiranda.repository.SupplierRepository;
import vallegrande.luSanchezMiranda.service.SupplierService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class SupplierServiceImpl implements SupplierService {

    @Autowired
    private SupplierRepository repository;

    @Override
    public List<Supplier> listar() {
        return repository.findAll();
    }

    @Override
    public Supplier listarPorId(Integer id) {
        return repository.findById(id).orElse(null);
    }

    @Override
    public List<Supplier> listarPorEstado(String status) {
        return repository.findByStatus(status);
    }

    @Override
    public Supplier guardar(Supplier supplier) {
        supplier.setStatus("activo");
        return repository.save(supplier);
    }

    @Override
    public Supplier actualizar(Integer id, Supplier supplier) {
        Optional<Supplier> existente = repository.findById(id);

        if (existente.isPresent()) {
            Supplier s = existente.get();

            s.setUbigeoCode(supplier.getUbigeoCode());
            s.setCategoryId(supplier.getCategoryId());
            s.setCompanyName(supplier.getCompanyName());
            s.setRuc(supplier.getRuc());
            s.setPhone(supplier.getPhone());
            s.setEmail(supplier.getEmail());
            s.setAddress(supplier.getAddress());
            // No copiar fechas de auditoría del request, se manejan con JPA callbacks

            return repository.save(s);
        }

        return null;
    }

    @Override
    public Supplier eliminarLogico(Integer id) {
        Supplier s = listarPorId(id);
        if (s != null) {
            s.setStatus("inactivo");
            s.setDeletedAt(LocalDateTime.now());
            return repository.save(s);
        }
        return null;
    }

    @Override
    public Supplier restaurar(Integer id) {
        Supplier s = listarPorId(id);
        if (s != null) {
            s.setStatus("activo");
            s.setDeletedAt(null);
            s.setRestoredAt(LocalDateTime.now());
            return repository.save(s);
        }
        return null;
    }
}