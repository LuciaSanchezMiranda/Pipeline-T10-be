package vallegrande.luSanchezMiranda.service;

import vallegrande.luSanchezMiranda.dto.StockMovementRequest;
import vallegrande.luSanchezMiranda.dto.StockMovementResponse;

import java.util.List;

public interface StockMovementService {
    List<StockMovementResponse> listar();
    StockMovementResponse listarPorId(Integer id);
    StockMovementResponse guardar(StockMovementRequest request);
    StockMovementResponse actualizar(Integer id, StockMovementRequest request);
    void eliminar(Integer id);
}
