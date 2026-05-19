package vallegrande.luSanchezMiranda.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vallegrande.luSanchezMiranda.dto.StockMovementRequest;
import vallegrande.luSanchezMiranda.dto.StockMovementResponse;
import vallegrande.luSanchezMiranda.model.StockMovement;
import vallegrande.luSanchezMiranda.repository.*;
import vallegrande.luSanchezMiranda.service.StockMovementService;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class StockMovementServiceImpl implements StockMovementService {

    @Autowired
    private StockMovementRepository repository;

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private SaleRepository saleRepository;

    @Autowired
    private ProductionBatchRepository productionBatchRepository;

    @Autowired
    private ProductSaleRepository productSaleRepository;

    @Autowired
    private ProductSupplyRepository productSupplyRepository;

    @Autowired
    private PurchaseRepository purchaseRepository;

    @Override
    public List<StockMovementResponse> listar() {
        return repository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public StockMovementResponse listarPorId(Integer id) {
        return repository.findById(id)
                .map(this::toResponse)
                .orElse(null);
    }

    @Override
    @Transactional
    public StockMovementResponse guardar(StockMovementRequest req) {
        StockMovement sm = toEntity(req);

        // Calcular stock_before y stock_after si no vienen en el Request
        BigDecimal before = req.getStockBefore();
        BigDecimal after = req.getStockAfter();

        if (before == null || after == null) {
            before = BigDecimal.ZERO;
            after = BigDecimal.ZERO;

            if ("SALIDA".equalsIgnoreCase(req.getMovementType())) {
                if (sm.getProductSale() != null) {
                    before = BigDecimal.valueOf(sm.getProductSale().getAvailableStock());
                    after = before.subtract(req.getQuantity());
                    // Actualizar el stock del producto de venta
                    sm.getProductSale().setAvailableStock(after.intValue());
                    productSaleRepository.save(sm.getProductSale());
                } else if (sm.getProductSupply() != null) {
                    before = sm.getProductSupply().getAvailableStock();
                    after = before.subtract(req.getQuantity());
                    // Actualizar el stock del insumo
                    sm.getProductSupply().setAvailableStock(after);
                    productSupplyRepository.save(sm.getProductSupply());
                }
            } else if ("ENTRADA".equalsIgnoreCase(req.getMovementType())) {
                if (sm.getProductSale() != null) {
                    before = BigDecimal.valueOf(sm.getProductSale().getAvailableStock());
                    after = before.add(req.getQuantity());
                    // Actualizar el stock del producto de venta
                    sm.getProductSale().setAvailableStock(after.intValue());
                    productSaleRepository.save(sm.getProductSale());
                } else if (sm.getProductSupply() != null) {
                    before = sm.getProductSupply().getAvailableStock();
                    after = before.add(req.getQuantity());
                    // Actualizar el stock del insumo
                    sm.getProductSupply().setAvailableStock(after);
                    productSupplyRepository.save(sm.getProductSupply());
                }
            }
        }

        sm.setStockBefore(before);
        sm.setStockAfter(after);

        StockMovement saved = repository.save(sm);
        return toResponse(saved);
    }

    @Override
    @Transactional
    public StockMovementResponse actualizar(Integer id, StockMovementRequest req) {
        Optional<StockMovement> existente = repository.findById(id);

        if (existente.isPresent()) {
            StockMovement sm = existente.get();
            sm.setMovementType(req.getMovementType());
            sm.setMovementReason(req.getMovementReason());
            sm.setQuantity(req.getQuantity());
            if (req.getStockBefore() != null) sm.setStockBefore(req.getStockBefore());
            if (req.getStockAfter() != null) sm.setStockAfter(req.getStockAfter());
            sm.setComments(req.getComments());
            if (req.getMovementDate() != null) sm.setMovementDate(req.getMovementDate());

            if (req.getEmployeeId() != null) {
                sm.setEmployee(employeeRepository.findById(req.getEmployeeId()).orElse(null));
            }
            if (req.getSaleId() != null) {
                sm.setSale(saleRepository.findById(req.getSaleId()).orElse(null));
            }
            if (req.getBatchId() != null) {
                sm.setProductionBatch(productionBatchRepository.findById(req.getBatchId()).orElse(null));
            }
            if (req.getProductsSaleId() != null) {
                sm.setProductSale(productSaleRepository.findById(req.getProductsSaleId()).orElse(null));
            }
            if (req.getProductId() != null) {
                sm.setProductSupply(productSupplyRepository.findById(req.getProductId()).orElse(null));
            }
            if (req.getIdPurchase() != null) {
                sm.setPurchase(purchaseRepository.findById(req.getIdPurchase()).orElse(null));
            }

            StockMovement updated = repository.save(sm);
            return toResponse(updated);
        }

        return null;
    }

    @Override
    public void eliminar(Integer id) {
        repository.deleteById(id);
    }

    private StockMovementResponse toResponse(StockMovement sm) {
        if (sm == null) return null;
        StockMovementResponse res = new StockMovementResponse();
        res.setMovement(sm.getMovement());
        res.setMovementType(sm.getMovementType());
        res.setMovementReason(sm.getMovementReason());
        res.setQuantity(sm.getQuantity());
        res.setStockBefore(sm.getStockBefore());
        res.setStockAfter(sm.getStockAfter());
        res.setComments(sm.getComments());
        res.setMovementDate(sm.getMovementDate());
        res.setCreatedAt(sm.getCreatedAt());

        if (sm.getEmployee() != null) {
            res.setEmployeeId(sm.getEmployee().getEmployeeId());
            res.setEmployeeName(sm.getEmployee().getName() + " " + sm.getEmployee().getLastName());
        }
        if (sm.getSale() != null) {
            res.setSaleId(sm.getSale().getSaleId());
        }
        if (sm.getProductionBatch() != null) {
            res.setBatchId(sm.getProductionBatch().getBatchId());
        }
        if (sm.getProductSale() != null) {
            res.setProductsSaleId(sm.getProductSale().getProductsSaleId());
            res.setProductSaleName(sm.getProductSale().getProductName());
        }
        if (sm.getProductSupply() != null) {
            res.setProductId(sm.getProductSupply().getProductId());
            res.setProductSupplyName(sm.getProductSupply().getProductName());
        }
        if (sm.getPurchase() != null) {
            res.setIdPurchase(sm.getPurchase().getIdPurchase());
        }
        return res;
    }

    private StockMovement toEntity(StockMovementRequest req) {
        if (req == null) return null;
        StockMovement sm = new StockMovement();
        sm.setMovementType(req.getMovementType());
        sm.setMovementReason(req.getMovementReason());
        sm.setQuantity(req.getQuantity());
        sm.setComments(req.getComments());
        sm.setMovementDate(req.getMovementDate() != null ? req.getMovementDate() : LocalDateTime.now());

        if (req.getEmployeeId() != null) {
            sm.setEmployee(employeeRepository.findById(req.getEmployeeId()).orElse(null));
        }
        if (req.getSaleId() != null) {
            sm.setSale(saleRepository.findById(req.getSaleId()).orElse(null));
        }
        if (req.getBatchId() != null) {
            sm.setProductionBatch(productionBatchRepository.findById(req.getBatchId()).orElse(null));
        }
        if (req.getProductsSaleId() != null) {
            sm.setProductSale(productSaleRepository.findById(req.getProductsSaleId()).orElse(null));
        }
        if (req.getProductId() != null) {
            sm.setProductSupply(productSupplyRepository.findById(req.getProductId()).orElse(null));
        }
        if (req.getIdPurchase() != null) {
            sm.setPurchase(purchaseRepository.findById(req.getIdPurchase()).orElse(null));
        }
        return sm;
    }
}
