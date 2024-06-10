# Proyecto_Taller_AutomotrizSQL.
El objetivo de este proyecto es desarrollar un sistema de gestión de base de datos
avanzada para un taller automotriz, utilizando MySQL, que permita administrar de
manera eficiente todos los aspectos operativos del taller. Este sistema centralizará
la información de clientes, vehículos, servicios, reparaciones, empleados,
proveedores, citas, inventarios, órdenes de compra y facturación, asegurando la
integridad y consistencia de los datos a través de técnicas de normalización.

## Diagrama de entidad relacion 
![](https://github.com/DanyelleGiraldo/Proyecto_Taller_AutomotrizSQL/blob/main/Diagramas/Diagrama_tallerAutomotriz.png)

## Consultas requeridas 

1. **Obtener el historial de reparaciones de un vehículo específico:**
    - **Enunciado:**
        Obtener el historial de reparaciones de un vehículo específico.
    - **Solución:**
        ```sql
        SELECT ReparacionID, Fecha, VehiculoID, ServicioID, CostoTotal, Descripcion, duracion 
        FROM Reparacion 
        WHERE VehiculoID = 4;
        ```
    - **Explicación:**
        Esta consulta selecciona todas las reparaciones realizadas en el vehículo con VehiculoID igual a 4, mostrando los detalles de cada reparación.

2. **Calcular el costo total de todas las reparaciones realizadas por un empleado específico en un período de tiempo:**
    - **Enunciado:**
        Calcular el costo total de todas las reparaciones realizadas por un empleado específico.
    - **Solución:**
        ```sql
        SELECT SUM(CostoTotal) AS costo_todas_reparacion 
        FROM Reparacion r 
        JOIN Empleado_reparacion e ON e.reparacionID = r.ReparacionID 
        WHERE e.empleadoID = 3;
        ```
    - **Explicación:**
        Esta consulta suma el costo total de las reparaciones en las que participó el empleado con empleadoID igual a 3.

3. **Listar todos los clientes y los vehículos que poseen:**
    - **Enunciado:**
        Listar todos los clientes y los vehículos que poseen.
    - **Solución:**
        ```sql
        SELECT c.nombre AS nombre_dueño, v.Marca AS marca_carro, v.Modelo AS modelo_carro 
        FROM Cliente c 
        JOIN Vehiculo v ON v.ClienteID = c.ClienteID;
        ```
    - **Explicación:**
        Esta consulta lista los nombres de los clientes y los vehículos que poseen.

4. **Obtener la cantidad de piezas en inventario para cada pieza:**
    - **Enunciado:**
        Obtener la cantidad de piezas en inventario para cada pieza.
    - **Solución:**
        ```sql
        SELECT piezaID, cantidad 
        FROM inventario;
        ```
    - **Explicación:**
        Esta consulta selecciona el piezaID y la cantidad de piezas disponibles en el inventario.

5. **Obtener las citas programadas para un día específico:**
    - **Enunciado:**
        Obtener las citas programadas para un día específico.
    - **Solución:**
        ```sql
        SELECT citaID, fechaHora, clienteID, vehiculoID, servicioID 
        FROM cita 
        WHERE DATE(fechaHora) = '2024-06-20';
        ```
    - **Explicación:**
        Esta consulta selecciona las citas programadas para el día 2024-06-20.

6. **Obtener una factura para un cliente específico en una fecha determinada:**
    - **Enunciado:**
        Obtener una factura para un cliente específico en una fecha determinada.
    - **Solución:**
        ```sql
        SELECT * 
        FROM factura 
        WHERE clienteID = 11 AND DATE(fecha) = '2024-06-03';
        ```
    - **Explicación:**
        Esta consulta selecciona todas las facturas para el cliente con clienteID igual a 11 en la fecha 2024-06-03.

7. **Listar todas las órdenes de compra y sus detalles:**
    - **Enunciado:**
        Listar todas las órdenes de compra y sus detalles.
    - **Solución:**
        ```sql
        SELECT oc.ordenID AS compraID, od.pieza_id, od.cantidad, od.precio  
        FROM orden_compra oc 
        JOIN orden_detalle od;
        ```
    - **Explicación:**
        Esta consulta lista todas las órdenes de compra y los detalles de cada orden.

8. **Obtener el costo total de piezas utilizadas en una reparación específica:**
    - **Enunciado:**
        Obtener el costo total de piezas utilizadas en una reparación específica.
    - **Solución:**
        ```sql
        SELECT SUM(p.precio * rp.cantidad) AS costo_total_piezas 
        FROM Reparacion r 
        JOIN reparacion_pieza rp ON rp.reparacionID = r.ReparacionID 
        JOIN pieza p ON rp.piezaID = p.piezaID 
        WHERE r.ReparacionID = 3;
        ```
    - **Explicación:**
        Esta consulta calcula el costo total de las piezas utilizadas en la reparación con ReparacionID igual a 3.

9. **Obtener el inventario de piezas que necesitan ser reabastecidas (cantidad menor que un umbral):**
    - **Enunciado:**
        Obtener el inventario de piezas que necesitan ser reabastecidas.
    - **Solución:**
        ```sql
        SELECT piezaID, cantidad, ubicacionID 
        FROM inventario 
        WHERE cantidad < 10;
        ```
    - **Explicación:**
        Esta consulta selecciona las piezas cuyo inventario está por debajo del umbral de 10 unidades.

10. **Obtener la lista de servicios más solicitados en un período específico:**
    - **Enunciado:**
        Obtener la lista de servicios más solicitados en un período específico.
    - **Solución:**
        ```sql
        SELECT servicioID, COUNT(servicioID) AS total_solicitudes 
        FROM Reparacion 
        GROUP BY servicioID 
        ORDER BY total_solicitudes DESC 
        LIMIT 1;
        ```
    - **Explicación:**
        Esta consulta cuenta las solicitudes de cada servicio en el período especificado y ordena los resultados de mayor a menor.

11. **Obtener el costo total de reparaciones para cada cliente en un período específico:**
    - **Enunciado:**
        Obtener el costo total de reparaciones para cada cliente en un período específico.
    - **Solución:**
        ```sql
        SELECT 
            Cliente.ClienteID,
            Cliente.Nombre,
            Cliente.Apellido,
            SUM(Reparacion.CostoTotal) AS TotalCostoReparaciones
        FROM 
            Cliente
        JOIN 
            Vehiculo ON Cliente.ClienteID = Vehiculo.ClienteID
        JOIN 
            Reparacion ON Vehiculo.VehiculoID = Reparacion.VehiculoID
        WHERE 
            Reparacion.Fecha BETWEEN '2024-01-01' AND '2024-12-31'
        GROUP BY 
            Cliente.ClienteID, Cliente.Nombre, Cliente.Apellido;
        ```
    - **Explicación:**
        Esta consulta calcula el costo total de reparaciones para cada cliente en el período especificado.

12. **Listar los empleados con mayor cantidad de reparaciones realizadas en un período específico:**
    - **Enunciado:**
        Listar los empleados con mayor cantidad de reparaciones realizadas en un período específico.
    - **Solución:**
        ```sql
        SELECT e.nombre AS nombre_empleado, e.apellido AS apellido_empleado, COUNT(er.reparacionID) AS numero_reparaciones
        FROM empleado_reparacion er
        JOIN empleado e ON er.empleadoID = e.empleadoID 
        JOIN reparacion r ON r.ReparacionID = er.reparacionID
        WHERE r.fecha BETWEEN '2024-01-01' AND '2024-12-01'
        GROUP BY e.nombre, e.apellido
        ORDER BY COUNT(er.reparacionID) DESC;
        ```
    - **Explicación:**
        Esta consulta cuenta las reparaciones realizadas por cada empleado en el período especificado y las ordena de mayor a menor.

13. **Obtener las piezas más utilizadas en reparaciones durante un período específico:**
    - **Enunciado:**
        Obtener las piezas más utilizadas en reparaciones durante un período específico.
    - **Solución:**
        ```sql
        SELECT p.nombre AS nombre_pieza, p.descripcion, COUNT(rp.reparacionID) AS numero_usos 
        FROM pieza p 
        JOIN reparacion_pieza rp ON rp.piezaID = p.piezaID
        JOIN reparacion r ON r.ReparacionID = rp.reparacionID
        WHERE r.Fecha BETWEEN '2024-01-01' AND '2024-06-01'
        GROUP BY p.nombre, p.descripcion
        ORDER BY numero_usos DESC
        LIMIT 5;
        ```
    - **Explicación:**
        Esta consulta cuenta las veces que se utilizaron las piezas en las reparaciones en el período especificado y las ordena de mayor a menor.

14. **Calcular el promedio de costo de reparaciones por vehículo:**
    - **Enunciado:**
        Calcular el promedio de costo de reparaciones por vehículo.
    - **Solución:**
        ```sql
        SELECT v.placa, v.marca, AVG(r.CostoTotal) AS promedio_costo
        FROM vehiculo v
        JOIN reparacion r ON r.VehiculoID = v.VehiculoID
        GROUP BY v.placa, v.marca;
        ```
    - **Explicación:**
        Esta consulta calcula el costo promedio de reparaciones para cada vehículo.

15. **Obtener el inventario de piezas por proveedor:**
    - **Enunciado:**
        Obtener el inventario de piezas por proveedor.
    - **Solución:**
        ```sql
        SELECT pr.nombre AS nombre_proveedor, pi.nombre AS nombre_pieza, i.cantidad AS cantidad_piezas
        FROM pieza pi
        JOIN proveedor pr ON pr.ProveedorID = pi.proveedorID
        JOIN inventario i ON i.piezaID = pi.piezaID
        ORDER BY pr.ProveedorID, pi.Nombre;
        ```
    - **Explicación:**
        Esta consulta lista las piezas en inventario agrupadas por proveedor.

16. **Listar los clientes que no han realizado reparaciones en el último año:**
    - **Enunciado:**
        Listar los clientes que no han realizado reparaciones en el último año.
    - **Solución:**
        ```sql
        SELECT c.clienteID, c.Nombre, c.Apellido, c.Email
        FROM Cliente c
        WHERE c.clienteID NOT IN (
            SELECT v.ClienteID
            FROM vehiculo v
            JOIN Reparacion r ON v.VehiculoID = r.VehiculoID
            WHERE r.Fecha >= CURDATE() - INTERVAL 1 YEAR
        );
        ```
    - **Explicación:**
        Esta consulta selecciona los clientes que no han realizado ninguna reparación en el último año.

17. **Obtener las ganancias totales del taller en un período específico:**
    - **Enunciado:**
        Obtener las ganancias totales del taller en un período específico.
    - **Solución:**
        ```sql
        SELECT 
            SUM(f.total) AS ganancias_totales
        FROM 
            factura f
        WHERE 
            f.fecha BETWEEN '2024-01-01' AND '2024-06-01';
        ```
    - **Explicación:**
        Esta consulta suma el total de las facturas emitidas en el período especificado.

18. **Listar los empleados y el total de horas trabajadas en reparaciones en un período específico:**
    - **Enunciado:**
        Listar los empleados y el total de horas trabajadas en reparaciones en un período específico.
    - **Solución:**
        ```sql
        SELECT e.Nombre AS nombre_empleado, e.Apellido AS apellido_empleado, SUM(r.duracion) AS horas_trabajadas
        FROM empleado e 
        JOIN empleado_reparacion er ON e.empleadoID = er.empleadoID 
        JOIN reparacion r ON r.ReparacionID = er.reparacionID 
        WHERE r.Fecha BETWEEN '2024-01-01' AND '2024-06-01'
        GROUP BY e.Nombre, e.Apellido;
        ```
    - **Explicación:**
        Esta consulta suma las horas trabajadas por cada empleado en reparaciones en el período especificado.

19. **Obtener el listado de servicios prestados por cada empleado en un período específico:**
    - **Enunciado:**
        Obtener el listado de servicios prestados por cada empleado en un período específico.
    - **Solución:**
        ```sql
        SELECT e.nombre AS nombre_empleado, e.apellido AS apellido_empleado, s.Nombre AS nombre_servicio
        FROM empleado e
        JOIN empleado_reparacion er ON e.empleadoID = er.empleadoID 
        JOIN reparacion r ON er.reparacionID = r.ReparacionID 
        JOIN servicio s ON s.ServicioID = r.ServicioID
        WHERE r.Fecha BETWEEN '2024-01-01' AND '2024-06-01';
        ```
    - **Explicación:**
        Esta consulta lista los servicios realizados por cada empleado en el período especificado.
