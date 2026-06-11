# Estructura Unificada de Pedidos (Order + OrderDetail)

## Cambios Realizados

Se ha unificado la estructura de `Order` con `OrderDetail` para poder visualizar y crear pedidos completos con sus detalles a través de Swagger.

### Modificaciones:

1. **Modelo Order** - Agregada relación OneToMany con OrderDetail
2. **OrderServiceImpl** - Agregados métodos de conversión DTO ↔ Entity
3. **OrderRest Controller** - Actualizado para usar OrderRequest/OrderResponse DTOs

---

## Ejemplo de JSON para Crear un Pedido

### POST /api/order

**Request Body (OrderRequest):**

```json
{
  "estimatedDelivery": "2024-06-20",
  "status": "pendiente",
  "notes": "Pedido urgente",
  "employeeId": 1,
  "idCustomer": 5,
  "details": [
    {
      "productsSaleId": 10,
      "quantity": 5,
      "unitPrice": 150.00
    },
    {
      "productsSaleId": 15,
      "quantity": 3,
      "unitPrice": 200.50
    }
  ]
}
```

**Response (OrderResponse):**

```json
{
  "orderId": 42,
  "orderDate": "2024-06-11T14:30:45.123456",
  "estimatedDelivery": "2024-06-20",
  "status": "pendiente",
  "notes": "Pedido urgente",
  "totalEstimated": 1351.50,
  "createdAt": "2024-06-11T14:30:45.123456",
  "updatedAt": "2024-06-11T14:30:45.123456",
  "employeeId": 1,
  "employeeName": "Juan Pérez",
  "idCustomer": 5,
  "customerName": "Carlos García López",
  "details": [
    {
      "idOrderDetail": 101,
      "productsSaleId": 10,
      "productName": "Producto A",
      "quantity": 5,
      "unitPrice": 150.00,
      "subtotal": 750.00
    },
    {
      "idOrderDetail": 102,
      "productsSaleId": 15,
      "productName": "Producto B",
      "quantity": 3,
      "unitPrice": 200.50,
      "subtotal": 601.50
    }
  ]
}
```

---

## Endpoints Disponibles

### GET /api/order
- **Descripción:** Listar todos los pedidos con sus detalles
- **Response:** List<OrderResponse>

### GET /api/order/{id}
- **Descripción:** Obtener un pedido específico con sus detalles
- **Parámetro:** `id` - ID del pedido
- **Response:** OrderResponse

### POST /api/order
- **Descripción:** Crear un nuevo pedido con sus detalles
- **Request:** OrderRequest (con array de details)
- **Response:** OrderResponse (con detalles completos)

### PUT /api/order/{id}
- **Descripción:** Actualizar un pedido existente
- **Parámetro:** `id` - ID del pedido
- **Request:** OrderRequest
- **Response:** OrderResponse

### DELETE /api/order/{id}
- **Descripción:** Eliminación lógica de pedido (cambia estado a "cancelado")
- **Parámetro:** `id` - ID del pedido
- **Response:** OrderResponse

### PATCH /api/order/restaurar/{id}
- **Descripción:** Restaurar un pedido cancelado
- **Parámetro:** `id` - ID del pedido
- **Response:** OrderResponse

---

## Características de la Solución

✅ **Estructura Unificada**: Un JSON que incluye Order + detalles
✅ **Cálculo Automático**: El total (`totalEstimated`) se calcula automáticamente
✅ **Cascade Operations**: Al eliminar un pedido, se eliminan automáticamente sus detalles
✅ **Información Enriquecida**: La respuesta incluye nombres de empleado, cliente y producto
✅ **Visualización en Swagger**: Los DTOs se muestran claramente con sus propiedades anidadas
✅ **Validaciones**: El servicio valida referencias a empleados, clientes y productos

---

## Cómo Visualizar en Swagger

1. Inicia la aplicación Spring Boot
2. Abre Swagger UI en: `http://localhost:8080/swagger-ui.html`
3. Busca el endpoint **POST /api/order**
4. Haz clic en **"Try it out"**
5. Verás el esquema JSON con la estructura completa incluyendo el array `details`
6. Modifica el ejemplo con tus datos y ejecuta

---

## Notas Técnicas

- **Fetch Strategy**: EAGER para OrderDetail (carga automática)
- **Cascade**: ALL + orphanRemoval para mantener integridad
- **DTOs**: Separan la lógica de negocio de la presentación
- **Conversión**: Se realiza automáticamente en el servicio
