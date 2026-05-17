package vallegrande.luSanchezMiranda.service;

import vallegrande.luSanchezMiranda.model.Sale;
import java.util.List;

public interface SaleService {
    List<Sale> listar();
    Sale listarPorId(Integer id);
    Sale guardar(Sale sale);
    Sale actualizar(Integer id, Sale sale);
    void eliminar(Integer id);
}
