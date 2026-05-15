package vallegrande.luSanchezMiranda.service;

import vallegrande.luSanchezMiranda.model.Supplier;

import java.util.List;

public interface SupplierService {

    List<Supplier> listar();
    Supplier listarPorId(Integer id);
    List<Supplier> listarPorEstado(Boolean status);

    Supplier guardar(Supplier supplier);
    Supplier actualizar(Integer id, Supplier supplier);

    Supplier eliminarLogico(Integer id);
    Supplier restaurar(Integer id);
}