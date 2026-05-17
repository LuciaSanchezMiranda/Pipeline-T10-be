package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import vallegrande.luSanchezMiranda.model.*;
import vallegrande.luSanchezMiranda.repository.*;
import vallegrande.luSanchezMiranda.service.SupplierService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class SupplierServiceImpl implements SupplierService {

    @Autowired
    private SupplierRepository repository;

    @Autowired
    private UbigeoRepository ubigeoRepository;

    @Autowired
    private CategoryRepository categoryRepository;

    @Override
    public List<Supplier> listar() {
        return repository.findAllWithDetails();
    }

    @Override
    public Supplier listarPorId(Integer id) {
        return repository.findByIdWithDetails(id).orElse(null);
    }

    @Override
    public List<Supplier> listarPorEstado(Boolean status) {
        return repository.findByStatusWithDetails(status);
    }

    @Override
    public Supplier guardar(Supplier supplier) {
        // Buscar Ubigeo y Category completos por su ID del JSON recibido
        if (supplier.getUbigeo() != null) {
            Ubigeo ubigeo = ubigeoRepository.findById(supplier.getUbigeo().getUbigeoCode()).orElse(null);
            supplier.setUbigeo(ubigeo);
        }
        if (supplier.getCategory() != null) {
            Category category = categoryRepository.findById(supplier.getCategory().getCategoryId()).orElse(null);
            supplier.setCategory(category);
        }
        supplier.setStatus(true);

        Supplier saved = repository.save(supplier);
        // Re-fetch con JOIN FETCH para retornar todos los campos (sin nulls)
        return repository.findByIdWithDetails(saved.getSupplierId()).orElse(saved);
    }

    @Override
    public Supplier actualizar(Integer id, Supplier supplier) {
        Optional<Supplier> existente = repository.findById(id);

        if (existente.isPresent()) {
            Supplier s = existente.get();

            // Buscar Ubigeo y Category completos por su ID del JSON recibido
            if (supplier.getUbigeo() != null) {
                Ubigeo ubigeo = ubigeoRepository.findById(supplier.getUbigeo().getUbigeoCode()).orElse(null);
                s.setUbigeo(ubigeo);
            }
            if (supplier.getCategory() != null) {
                Category category = categoryRepository.findById(supplier.getCategory().getCategoryId()).orElse(null);
                s.setCategory(category);
            }
            s.setCompanyName(supplier.getCompanyName());
            s.setRuc(supplier.getRuc());
            s.setPhone(supplier.getPhone());
            s.setEmail(supplier.getEmail());
            s.setAddress(supplier.getAddress());

            Supplier saved = repository.save(s);
            // Re-fetch con JOIN FETCH para retornar todos los campos (sin nulls)
            return repository.findByIdWithDetails(saved.getSupplierId()).orElse(saved);
        }

        return null;
    }

    @Override
    public Supplier eliminarLogico(Integer id) {
        Supplier s = repository.findById(id).orElse(null);
        if (s != null) {
            s.setStatus(false);
            s.setDeletedAt(LocalDateTime.now());
            Supplier saved = repository.save(s);
            return repository.findByIdWithDetails(saved.getSupplierId()).orElse(saved);
        }
        return null;
    }

    @Override
    public Supplier restaurar(Integer id) {
        Supplier s = repository.findById(id).orElse(null);
        if (s != null) {
            s.setStatus(true);
            s.setDeletedAt(null);
            s.setRestoredAt(LocalDateTime.now());
            Supplier saved = repository.save(s);
            return repository.findByIdWithDetails(saved.getSupplierId()).orElse(saved);
        }
        return null;
    }
}
