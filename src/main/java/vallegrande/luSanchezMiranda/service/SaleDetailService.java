package vallegrande.luSanchezMiranda.service;

import vallegrande.luSanchezMiranda.model.SaleDetail;
import java.util.List;

public interface SaleDetailService {
    List<SaleDetail> listar();
    SaleDetail listarPorId(Integer id);
    SaleDetail guardar(SaleDetail saleDetail);
    SaleDetail actualizar(Integer id, SaleDetail saleDetail);
    void eliminar(Integer id);
}
