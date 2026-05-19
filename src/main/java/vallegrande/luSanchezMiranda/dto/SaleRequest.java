package vallegrande.luSanchezMiranda.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class SaleRequest {
    private String receiptType;
    private String paymentMethod;
    private Integer employeeId;
    private Integer idCustomer;
    private List<SaleDetailRequest> details;

    @Data
    public static class SaleDetailRequest {
        private Integer productsSaleId;
        private Integer productAmount;
        private BigDecimal unitPrice;
    }
}
