package vallegrande.luSanchezMiranda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import vallegrande.luSanchezMiranda.model.SaleDetail;

public interface SaleDetailRepository extends JpaRepository<SaleDetail, Integer> {
    void deleteBySale_SaleId(Integer saleId);
}
