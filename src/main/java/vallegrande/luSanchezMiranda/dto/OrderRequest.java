package vallegrande.luSanchezMiranda.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
public class OrderRequest {
    private LocalDate estimatedDelivery;
    private String status;
    private Integer employeeId;
    private Integer idCustomer;
    private List<OrderDetailRequest> details;

    @Data
    public static class OrderDetailRequest {
        private Integer productsSaleId;
        private Integer quantity;
        private BigDecimal unitPrice;
    }
}
