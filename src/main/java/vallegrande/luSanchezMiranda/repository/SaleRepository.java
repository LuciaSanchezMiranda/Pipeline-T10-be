package vallegrande.luSanchezMiranda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import vallegrande.luSanchezMiranda.model.Sale;

public interface SaleRepository extends JpaRepository<Sale, Integer> {
}
