package vallegrande.luSanchezMiranda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import vallegrande.luSanchezMiranda.model.Supplier;

import java.util.List;
import java.util.Optional;

public interface SupplierRepository extends JpaRepository<Supplier, Integer> {

    // Carga ubigeo y category junto con el supplier (resuelve los nulls)
    @Query("SELECT s FROM Supplier s JOIN FETCH s.ubigeo JOIN FETCH s.category")
    List<Supplier> findAllWithDetails();

    @Query("SELECT s FROM Supplier s JOIN FETCH s.ubigeo JOIN FETCH s.category WHERE s.status = :status")
    List<Supplier> findByStatusWithDetails(@Param("status") Boolean status);

    @Query("SELECT s FROM Supplier s JOIN FETCH s.ubigeo JOIN FETCH s.category WHERE s.supplierId = :id")
    Optional<Supplier> findByIdWithDetails(@Param("id") Integer id);

    List<Supplier> findByStatus(Boolean status);

}