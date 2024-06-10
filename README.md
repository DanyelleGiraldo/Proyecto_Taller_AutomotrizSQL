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

## Subconsultas

1. **Obtener el cliente que ha gastado más en reparaciones durante el último año:**
    - **Enunciado:**
        Obtener el cliente que ha gastado más en reparaciones durante el último año.
    - **Solución:**
        ```sql
        SELECT c.Nombre AS nombre_cliente, c.Apellido AS apellido_cliente, total_gastado 
        FROM cliente c 
        JOIN 
        (SELECT v.ClienteID, SUM(r.CostoTotal) AS total_gastado
            FROM vehiculo v 
            JOIN Reparacion r ON v.VehiculoID = r.VehiculoID
            WHERE r.Fecha >= CURDATE() - INTERVAL 1 YEAR
            GROUP BY v.ClienteID
        ) AS total_reparacion ON c.ClienteID = total_reparacion.ClienteID
        ORDER BY total_gastado DESC LIMIT 1;
        ```
    - **Explicación:**
        Esta consulta obtiene el cliente que ha gastado más en reparaciones durante el último año sumando los costos totales de las reparaciones de cada cliente y ordenándolos en orden descendente, limitando el resultado al primer registro.

2. **Obtener la pieza más utilizada en reparaciones durante el último mes:**
    - **Enunciado:**
        Obtener la pieza más utilizada en reparaciones durante el último mes.
    - **Solución:**
        ```sql
        SELECT p.Nombre, COUNT(rp.reparacionID) AS usos
        FROM pieza p
        JOIN reparacion_pieza rp ON rp.piezaID = p.piezaID
        JOIN reparacion r ON r.ReparacionID = rp.reparacionID
        WHERE r.fecha >= CURDATE() - INTERVAL 1 MONTH
        GROUP BY p.Nombre
        HAVING COUNT(rp.reparacionID) = 
        (SELECT COUNT(rp2.reparacionID) 
        FROM reparacion_pieza rp2
        JOIN reparacion r2 ON rp2.reparacionID = r2.ReparacionID
        WHERE r2.fecha >= CURDATE() - INTERVAL 1 MONTH
        GROUP BY rp2.piezaID
        ORDER BY COUNT(rp2.reparacionID) DESC
        LIMIT 1)
        ```
    - **Explicación:**
        Esta consulta identifica la pieza más utilizada en reparaciones durante el último mes. Agrupa las piezas por nombre y cuenta el número de veces que cada pieza ha sido utilizada en reparaciones, comparando con la pieza más utilizada.

3. **Obtener los proveedores que suministran las piezas más caras:**
    - **Enunciado:**
        Obtener los proveedores que suministran las piezas más caras.
    - **Solución:**
        ```sql
        SELECT p.Nombre AS nombre_proveedor, pi.Nombre AS nombre_pieza, pi.precio
        FROM proveedor p 
        JOIN pieza pi ON pi.proveedorID = p.ProveedorID
        WHERE pi.precio = 
        (SELECT MAX(pi2.precio) FROM pieza pi2);
        ```
    - **Explicación:**
        Esta consulta obtiene los proveedores que suministran las piezas más caras comparando los precios de todas las piezas y seleccionando la máxima.

4. **Listar las reparaciones que no utilizaron piezas específicas durante el último año:**
    - **Enunciado:**
        Listar las reparaciones que no utilizaron piezas específicas durante el último año.
    - **Solución:**
        ```sql
        SELECT r.ReparacionID, r.Fecha, r.Descripcion 
        FROM reparacion r
        JOIN reparacion_pieza rp ON rp.reparacionID = r.ReparacionID
        JOIN pieza p ON rp.piezaID = p.piezaID
        WHERE r.Fecha >= CURDATE() - INTERVAL 1 YEAR 
        AND r.ReparacionID NOT IN(
            SELECT rp.reparacionID FROM reparacion_pieza rp
            WHERE rp.piezaID IN
            (SELECT piezaID FROM pieza
                WHERE piezaID = 1
            )
        );
        ```
    - **Explicación:**
        Esta consulta lista las reparaciones realizadas en el último año que no utilizaron una pieza específica (piezaID = 1).

5. **Obtener las piezas que están en inventario por debajo del 10% del stock inicial:**
    - **Enunciado:**
        Obtener las piezas que están en inventario por debajo del 10% del stock inicial.
    - **Solución:**
        ```sql
        SELECT 
            p.piezaID,
            p.Nombre AS nombre_pieza,
            i.cantidad AS stock_actual,
            (i.cantidad * 100) / (
                SELECT cantidad 
                FROM inventario 
                WHERE piezaID = p.piezaID 
                ORDER BY inventarioID ASC 
                LIMIT 1
            ) AS porcentaje_stock
        FROM 
            pieza p
        JOIN 
            inventario i ON p.piezaID = i.piezaID
        HAVING 
            porcentaje_stock < 10;
        ```
    - **Explicación:**
        Esta consulta obtiene las piezas cuyo stock actual está por debajo del 10% del stock inicial. Calcula el porcentaje de stock actual sobre el stock inicial para cada pieza y selecciona las que están por debajo del 10%.
     
## Procedimientos Almacenados 

1. **Crear un procedimiento almacenado para insertar una nueva reparación:**
    - **Enunciado:**
        Crear un procedimiento almacenado para insertar una nueva reparación.
    - **Solución:**
        ```sql
        DELIMITER $$
        CREATE PROCEDURE insertarreparacion(
            IN p_ReparacionID INT,
            IN p_Fecha DATE, 
            IN p_VehiculoID INT, 
            IN p_ServicioID INT, 
            IN p_CostoTotal DECIMAL(10,2), 
            IN p_Descripcion TEXT, 
            IN p_duracion INT
        )
        BEGIN
            INSERT INTO Reparacion (ReparacionID, Fecha, VehiculoID, ServicioID, CostoTotal, Descripcion, duracion) 
            VALUES (p_ReparacionID, p_Fecha, p_VehiculoID, p_ServicioID, p_CostoTotal, p_Descripcion, p_duracion);
        END $$
        DELIMITER ;
        ```
    - **Explicación:**
        Este procedimiento inserta una nueva reparación en la tabla `Reparacion` utilizando los parámetros proporcionados.

2. **Crear un procedimiento almacenado para actualizar el inventario de una pieza:**
    - **Enunciado:**
        Crear un procedimiento almacenado para actualizar el inventario de una pieza.
    - **Solución:**
        ```sql
        DELIMITER $$ 
        CREATE PROCEDURE actualizarinventariopieza(
            IN ainventarioID INT, 
            IN apiezaID INT, 
            IN acantidad INT, 
            IN aubicacionID INT
        )
        BEGIN
            UPDATE inventario 
            SET cantidad = acantidad, ubicacionID = aubicacionID
            WHERE inventarioID = ainventarioID AND piezaID = apiezaID;
        END $$
        DELIMITER ;
        ```
    - **Explicación:**
        Este procedimiento actualiza la cantidad y ubicación de una pieza específica en el inventario.

3. **Crear un procedimiento almacenado para eliminar una cita:**
    - **Enunciado:**
        Crear un procedimiento almacenado para eliminar una cita.
    - **Solución:**
        ```sql
        DELIMITER $$
        CREATE PROCEDURE eliminarcita(
            IN acitaID INT
        )
        BEGIN
            DELETE FROM cita WHERE citaID = acitaID;
        END $$
        DELIMITER ;
        ```
    - **Explicación:**
        Este procedimiento elimina una cita específica de la tabla `cita` utilizando el identificador de la cita.

4. **Crear un procedimiento almacenado para generar una factura:**
    - **Enunciado:**
        Crear un procedimiento almacenado para generar una factura.
    - **Solución:**
        ```sql
        DELIMITER $$
        CREATE PROCEDURE generarfactura(
            IN afacturaID INT, 
            IN afecha DATE, 
            IN aclienteID INT, 
            IN atotal DECIMAL(10,2)
        )
        BEGIN 
            INSERT INTO factura (facturaID, fecha, clienteID, total) VALUES
            (afacturaID, afecha, aclienteID, atotal);
        END $$
        DELIMITER ;
        ```
    - **Explicación:**
        Este procedimiento inserta una nueva factura en la tabla `factura` con los parámetros especificados.

5. **Crear un procedimiento almacenado para obtener el historial de reparaciones de un vehículo:**
    - **Enunciado:**
        Crear un procedimiento almacenado para obtener el historial de reparaciones de un vehículo.
    - **Solución:**
        ```sql
        DELIMITER $$ 
        CREATE PROCEDURE historialvehiculo(
            IN avehiculoID INT
        )
        BEGIN
            SELECT ReparacionID, Fecha, VehiculoID, ServicioID, CostoTotal, Descripcion, duracion 
            FROM reparacion 
            WHERE VehiculoID = avehiculoID;
        END $$
        DELIMITER ;
        ```
    - **Explicación:**
        Este procedimiento recupera el historial de reparaciones de un vehículo específico.

6. **Crear un procedimiento almacenado para calcular el costo total de reparaciones de un cliente en un período:**
    - **Enunciado:**
        Crear un procedimiento almacenado para calcular el costo total de reparaciones de un cliente en un período.
    - **Solución:**
        ```sql
        DELIMITER $$ 
        CREATE PROCEDURE totalcliente(
            IN aclienteID INT,
            IN fecha1 DATE,
            IN fecha2 DATE
        )
        BEGIN
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
                Reparacion.Fecha BETWEEN fecha1 AND fecha2 AND aclienteID = cliente.clienteID
            GROUP BY 
                Cliente.ClienteID, Cliente.Nombre, Cliente.Apellido;
        END $$
        DELIMITER ;
        ```
    - **Explicación:**
        Este procedimiento calcula el costo total de reparaciones de un cliente en un período especificado.

7. **Crear un procedimiento almacenado para obtener la lista de vehículos que requieren mantenimiento basado en el kilometraje:**
    - **Enunciado:**
        Crear un procedimiento almacenado para obtener la lista de vehículos que requieren mantenimiento basado en el kilometraje.
    - No pude hacer este procedimiento ya que en mi estructura de tablas, la tabla de vehiculo no contaba con el atributo de kilometraje
    - **Explicación:**
        Este procedimiento se usaría para recuperar la lista de vehículos que requieren mantenimiento basado en su kilometraje.

8. **Crear un procedimiento almacenado para insertar una nueva orden de compra:**
    - **Enunciado:**
        Crear un procedimiento almacenado para insertar una nueva orden de compra.
    - **Solución:**
        ```sql
        DELIMITER $$
        CREATE PROCEDURE crearordencompra(
            IN aordenID INT, 
            IN afecha DATE, 
            IN aproveedorID INT, 
            IN aempleadoID INT, 
            IN atotal DECIMAL(10,2)
        )
        BEGIN
            INSERT INTO orden_compra (ordenID, fecha, proveedorID, empleadoID, total) VALUES
            (aordenID, afecha, aproveedorID, aempleadoID, atotal);
        END $$
        DELIMITER ;
        ```
    - **Explicación:**
        Este procedimiento inserta una nueva orden de compra en la tabla `orden_compra` con los parámetros especificados.

9. **Crear un procedimiento almacenado para actualizar los datos de un cliente:**
    - **Enunciado:**
        Crear un procedimiento almacenado para actualizar los datos de un cliente.
    - **Solución:**
        ```sql
        DELIMITER $$
        CREATE PROCEDURE actualizarcliente(
            IN aClienteID INT,
            IN aNombre VARCHAR(25),
            IN aApellido VARCHAR(25),
            IN aEmail VARCHAR(100)
        )
        BEGIN 
            UPDATE cliente 
            SET  Nombre = aNombre, Apellido = aApellido, Email = aEmail
            WHERE ClienteID = aClienteID;
        END $$
        DELIMITER ;
        ```
    - **Explicación:**
        Este procedimiento actualiza los datos de un cliente en la tabla `cliente` utilizando los parámetros proporcionados.

10. **Crear un procedimiento almacenado para obtener los servicios más solicitados en un período:**
    - **Enunciado:**
        Crear un procedimiento almacenado para obtener los servicios más solicitados en un período.
    - **Solución:**
        ```sql
        DELIMITER $$
        CREATE PROCEDURE serviciosMasSolicitados(
            IN fechaInicio DATE,
            IN fechaFin DATE
        )
        BEGIN
            SELECT 
                s.ServicioID,
                s.Nombre,
                COUNT(r.ServicioID) AS NumeroSolicitudes
            FROM 
                Servicio s
            JOIN 
                Reparacion r ON s.ServicioID = r.ServicioID
            WHERE 
                r.Fecha BETWEEN fechaInicio AND fechaFin
            GROUP BY 
                s.ServicioID, s.Nombre
            ORDER BY 
                NumeroSolicitudes DESC;
        END $$
        DELIMITER ;
        ```
    - **Explicación:**
        Este procedimiento obtiene los servicios más solicitados en un período de tiempo especificado, ordenándolos de mayor a menor número de solicitudes.
