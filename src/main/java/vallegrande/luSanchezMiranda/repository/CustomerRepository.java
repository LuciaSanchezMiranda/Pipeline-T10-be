package vallegrande.luSanchezMiranda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import vallegrande.luSanchezMiranda.model.Customer;

import java.util.List;

public interface CustomerRepository extends JpaRepository<Customer, Integer> {

    List<Customer> findByStatusIgnoreCase(String status);
    List<Customer> findByCustomerTypeIgnoreCase(String customerType);
    List<Customer> findByStatusIgnoreCaseAndCustomerTypeIgnoreCase(String status, String customerType);

}