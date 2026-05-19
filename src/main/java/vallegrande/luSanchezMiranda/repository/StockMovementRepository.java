package vallegrande.luSanchezMiranda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import vallegrande.luSanchezMiranda.model.StockMovement;

public interface StockMovementRepository extends JpaRepository<StockMovement, Integer> {
}
