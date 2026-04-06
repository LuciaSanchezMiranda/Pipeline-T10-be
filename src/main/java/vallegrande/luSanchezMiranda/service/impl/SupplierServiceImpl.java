package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vallegrande.luSanchezMiranda.model.Supplier;
import vallegrande.luSanchezMiranda.repository.SupplierRepository;
import vallegrande.luSanchezMiranda.service.SupplierService;

import java.time.LocalDate;
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
        supplier.setStatus("ACTIVO");
        supplier.setCreatedDate(LocalDate.now());
        return repository.save(supplier);
    }

    @Override
    public Supplier actualizar(Integer id, Supplier supplier) {
        Optional<Supplier> existente = repository.findById(id);

        if (existente.isPresent()) {
            Supplier s = existente.get();

            s.setName(supplier.getName());
            s.setRuc(supplier.getRuc());
            s.setPhone(supplier.getPhone());
            s.setAddress(supplier.getAddress());
            s.setTipo(supplier.getTipo());
            s.setCompanyName(supplier.getCompanyName());
            s.setContactName(supplier.getContactName());
            s.setEmail(supplier.getEmail());
            s.setCreditLimit(supplier.getCreditLimit());

            return repository.save(s);
        }

        return null;
    }

    @Override
    public Supplier eliminarLogico(Integer id) {
        Supplier s = listarPorId(id);
        if (s != null) {
            s.setStatus("INACTIVO");
            return repository.save(s);
        }
        return null;
    }

    @Override
    public Supplier restaurar(Integer id) {
        Supplier s = listarPorId(id);
        if (s != null) {
            s.setStatus("ACTIVO");
            return repository.save(s);
        }
        return null;
    }
}