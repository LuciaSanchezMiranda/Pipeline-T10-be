package vallegrande.luSanchezMiranda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import vallegrande.luSanchezMiranda.model.Supplier;

import java.util.List;

public interface SupplierRepository extends JpaRepository<Supplier, Integer> {

    List<Supplier> findByStatus(Boolean status);

}