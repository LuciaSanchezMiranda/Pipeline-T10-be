package vallegrande.luSanchezMiranda.dto;

import lombok.Data;
import vallegrande.luSanchezMiranda.model.Sale;
import vallegrande.luSanchezMiranda.model.SaleDetail;
import vallegrande.luSanchezMiranda.model.Employee;
import vallegrande.luSanchezMiranda.model.Customer;
import vallegrande.luSanchezMiranda.model.ProductSale;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Data
public class SaleRequest {
    private String receiptType;
    private String paymentMethod;
    private BigDecimal totalCost;
    private EmployeeIdRequest employee;
    private CustomerIdRequest customer;
    private List<SaleDetailRequest> details;

    @Data
    public static class EmployeeIdRequest {
        private Integer employeeId;
    }

    @Data
    public static class CustomerIdRequest {
        private Integer idCustomer;
    }

    @Data
    public static class SaleDetailRequest {
        private BigDecimal unitPrice;
        private Integer productAmount;
        private BigDecimal subtotalCost;
        private ProductSaleIdRequest productSale;
    }

    @Data
    public static class ProductSaleIdRequest {
        private Integer productsSaleId;
    }

    public Sale toEntity() {
        Sale sale = new Sale();
        sale.setReceiptType(this.receiptType);
        sale.setPaymentMethod(this.paymentMethod);
        sale.setTotalCost(this.totalCost);

        if (this.employee != null && this.employee.getEmployeeId() != null) {
            Employee emp = new Employee();
            emp.setEmployeeId(this.employee.getEmployeeId());
            sale.setEmployee(emp);
        }

        if (this.customer != null && this.customer.getIdCustomer() != null) {
            Customer cust = new Customer();
            cust.setIdCustomer(this.customer.getIdCustomer());
            sale.setCustomer(cust);
        }

        if (this.details != null) {
            List<SaleDetail> list = new ArrayList<>();
            for (SaleDetailRequest reqDetail : this.details) {
                SaleDetail detail = new SaleDetail();
                detail.setUnitPrice(reqDetail.getUnitPrice());
                detail.setProductAmount(reqDetail.getProductAmount());
                detail.setSubtotalCost(reqDetail.getSubtotalCost());
                if (reqDetail.getProductSale() != null && reqDetail.getProductSale().getProductsSaleId() != null) {
                    ProductSale prod = new ProductSale();
                    prod.setProductsSaleId(reqDetail.getProductSale().getProductsSaleId());
                    detail.setProductSale(prod);
                }
                detail.setSale(sale);
                list.add(detail);
            }
            sale.setDetails(list);
        }
        return sale;
    }
}
