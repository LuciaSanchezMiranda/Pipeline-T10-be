package vallegrande.luSanchezMiranda.service;

import vallegrande.luSanchezMiranda.model.ProductSale;
import java.util.List;

public interface ProductService {
    List<ProductSale> listar();
    List<ProductSale> listarActivos();
    List<ProductSale> listarInactivos();
    ProductSale listarPorId(Integer id);
    ProductSale guardar(ProductSale product);
    ProductSale actualizar(Integer id, ProductSale product);
    ProductSale eliminarLogico(Integer id);
    ProductSale restaurar(Integer id);
}