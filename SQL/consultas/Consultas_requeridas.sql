use taller_automotriz;

-- 1. Obtener el historial de reparaciones de un vehículo específico
select ReparacionID, Fecha, VehiculoID, ServicioID, CostoTotal, Descripcion, duracion from Reparacion where VehiculoID= 4;

-- 2. Calcular el costo total de todas las reparaciones realizadas por un empleado
-- específico en un período de tiempo

select sum(CostoTotal) as costo_todas_reparacion from Reparacion r join Empleado_reparacion e on e.reparacionID = r.ReparacionID where e.empleadoID = 3;

-- 3. Listar todos los clientes y los vehículos que poseen
select c.nombre as nombre_dueño, v.Marca as marca_carro, v.Modelo as modelo_carro from Cliente c join Vehiculo v on v.ClienteID = c.ClienteID;

-- 4. Obtener la cantidad de piezas en inventario para cada pieza
select piezaID, cantidad from inventario;

-- 5. Obtener las citas programadas para un día específico

select citaID, fechaHora, clienteID, vehiculoID, servicioID from cita where date(fechaHora) = '2024-06-20';

-- 6. Obtener una factura para un cliente específico en una fecha determinada

select * from factura where clienteID = 11 and date(fecha)= '2024-06-03';

-- 7. Listar todas las órdenes de compra y sus detalles
select oc.ordenID as compraID, od.pieza_id, od.cantidad, od.precio  from orden_compra oc join orden_detalle od ;

-- 8. Obtener el costo total de piezas utilizadas en una reparación específica
select sum(p.precio * rp.cantidad) as costo_total_piezas from Reparacion r 
join reparacion_pieza rp on rp.reparacionID = r.ReparacionID 
join pieza p on rp.piezaID = p.piezaID 
where r.ReparacionID = 3;

/*
9. Obtener el inventario de piezas que necesitan ser reabastecidas (cantidad
menor que un umbral)
*/
select piezaID, cantidad, ubicacionID from inventario where cantidad < 10;

-- 10. Obtener la lista de servicios más solicitados en un período específico

select servicioID, count(servicioID) as total_solicitudes from Reparacion GROUP BY servicioID ORDER BY total_solicitudes Desc limit 1;

/*
11. Obtener el costo total de reparaciones para cada cliente en un período
específico
*/
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

/*
12. Listar los empleados con mayor cantidad de reparaciones realizadas en un
período específico
*/
select e.nombre as nombre_empleado, e.apellido as apellido_empleado, count(er.reparacionID) as numero_reparaciones
from empleado_reparacion er
join empleado e on er.empleadoID = e.empleadoID 
join reparacion r on r.ReparacionID = er.reparacionID
where r.fecha BETWEEN '2024-01-01' and '2024-12-01'
GROUP BY e.nombre, e.apellido
ORDER BY count(er.reparacionID) DESC;

/*
13. Obtener las piezas más utilizadas en reparaciones durante un período
específico
*/
select p.nombre as nombre_pieza, p.descripcion, count(rp.reparacionID) as numero_usos 
from pieza p 
join reparacion_pieza rp on rp.piezaID = p.piezaID
join reparacion r on r.ReparacionID = rp.reparacionID
where r.Fecha BETWEEN '2024-01-01' and '2024-06-01'
GROUP BY p.nombre, p.descripcion
ORDER BY numero_usos DESC
limit 5;

-- 14. Calcular el promedio de costo de reparaciones por vehículo
select v.placa, v.marca, avg(r.CostoTotal) as promedio_costo
from vehiculo v
join reparacion r on r.VehiculoID = v.VehiculoID
GROUP BY v.placa, v.marca;

-- 15. Obtener el inventario de piezas por proveedor
select pr.nombre as nombre_proveedor,pi.nombre as nombre_pieza, i.cantidad as cantidad_piezas
from pieza pi
join proveedor pr on pr.ProveedorID = pi.proveedorID
join inventario i on i.piezaID = pi.piezaID
order by pr.ProveedorID, pi.Nombre;

-- 16. Listar los clientes que no han realizado reparaciones en el último año
select c.clienteID,c.Nombre,c.Apellido, c.Email
from Cliente c
where c.clienteID not in(
    select v.ClienteID
    from vehiculo v
    join Reparacion r on v.VehiculoID = r.VehiculoID
    where r.Fecha >= CURDATE() - INTERVAL 1 year
)

-- 17. Obtener las ganancias totales del taller en un período específico
SELECT 
    SUM(f.total) AS ganancias_totales
FROM 
    factura f
WHERE 
    f.fecha BETWEEN '2024-01-01' AND '2024-06-01';

/*
18. Listar los empleados y el total de horas trabajadas en reparaciones en un
período específico (asumiendo que se registra la duración de cada reparación)
*/

select e.Nombre as nombre_empleado, e.Apellido as apellido_empleado, sum(r.duracion) as horas_trabajadas
from empleado e 
join empleado_reparacion er on e.empleadoID = er.empleadoID 
join reparacion r on r.ReparacionID = er.reparacionID 
where r.Fecha BETWEEN '2024-01-01' AND '2024-06-01'
GROUP BY e.Nombre,e.Apellido;


/*
19. Obtener el listado de servicios prestados por cada empleado en un período
específico
*/
select e.nombre as nombre_empleado, e.apellido as apellido_empleado, s.Nombre as nombre_servicio
from empleado e
join empleado_reparacion er on e.empleadoID = er.empleadoID 
join reparacion r on er.reparacionID = r.ReparacionID 
join servicio s on s.ServicioID = r.ServicioID
where r.Fecha BETWEEN '2024-01-01' AND '2024-06-01';

-- Subconsultas

-- 1. Obtener el cliente que ha gastado más en reparaciones durante el último año.

select c.Nombre as nombre_cliente, c.Apellido as apellido_cliente, total_gastado 
from cliente c 
join 
(select v.ClienteID, sum(r.CostoTotal) as total_gastado
    from vehiculo v 
    join Reparacion r on v.VehiculoID = r.VehiculoID
    where r.Fecha >= CURDATE() - interval 1 year
    GROUP BY v.ClienteID
) as total_reparacion on c.ClienteID = total_reparacion.ClienteID
ORDER BY total_gastado Desc LIMIT 1;

-- 2. Obtener la pieza más utilizada en reparaciones durante el último mes

select p.Nombre, count(rp.reparacionID) as usos
from pieza p
join reparacion_pieza rp on rp.piezaID = p.piezaID
join reparacion r on r.ReparacionID = rp.reparacionID
where r.fecha >= CURDATE() - INTERVAL 1 MONTH
GROUP BY p.Nombre
HAVING count(rp.reparacionID) = 
(select count(rp2.reparacionID) 
from reparacion_pieza rp2
join reparacion r2 on rp2.reparacionID = r2.ReparacionID
where r2.fecha >= CURDATE() - INTERVAL 1 MONTH
GROUP BY rp2.piezaID
ORDER BY count(rp2.reparacionID) DESC
limit 1
)

-- 3. Obtener los proveedores que suministran las piezas más caras
select p.Nombre as nombre_proveedor, pi.Nombre as Nombre_pieza, pi.precio
from proveedor p 
join pieza pi on pi.proveedorID = p.ProveedorID
where pi.precio = 
(select max(pi2.precio) from pieza pi2);

/*
4. Listar las reparaciones que no utilizaron piezas específicas durante el último año
*/
select r.ReparacionID, r.Fecha, r.Descripcion from reparacion r
join reparacion_pieza rp on rp.reparacionID = r.ReparacionID
join pieza p on rp.piezaID = p.piezaID
where r.Fecha >= CURDATE() - INTERVAL 1 YEAR 
and r.ReparacionID not in(
    select rp.reparacionID from reparacion_pieza rp
    where rp.piezaID in
    (select piezaID from pieza
        where piezaID = 1
    ));

-- 5. Obtener las piezas que están en inventario por debajo del 10% del stock inicial
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


-- 1. Crear un procedimiento almacenado para insertar una nueva reparación.
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

-- 2. Crear un procedimiento almacenado para actualizar el inventario de una pieza.

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


-- 3. Crear un procedimiento almacenado para eliminar una cita

DELIMITER $$
CREATE PROCEDURE eliminarcita(
    in acitaID INT
)
begin
    delete from cita where citaID = acitaID;
end $$
Delimiter ;

-- 4. Crear un procedimiento almacenado para generar una factura
DELIMITER $$
CREATE PROCEDURE generarfactura(
    in afacturaID int, 
    in afecha DATE, 
    in aclienteID int, 
    in atotal decimal(10,2)
)
begin 
INSERT INTO factura (facturaID, fecha, clienteID, total) VALUES
    (afacturaID, afecha, aclienteID, atotal);
END $$
DELIMITER ;

-- 5. Crear un procedimiento almacenado para obtener el historial de reparaciones
-- de un vehículo

DELIMITER $$ 
CREATE PROCEDURE historialvehiculo(
    in avehiculoID INT
)
BEGIN
    select ReparacionID, Fecha, VehiculoID, ServicioID, CostoTotal, Descripcion, duracion from reparacion where VehiculoID = avehiculoID;
END $$
DELIMITER ;

-- 6. Crear un procedimiento almacenado para calcular el costo total de
-- reparaciones de un cliente en un período
DELIMITER $$ 
CREATE PROCEDURE totalcliente(
    in aclienteID int,
    in fecha1 date,
    in fecha2 date
)
begin
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
end $$
DELIMITER ;


-- 7. Crear un procedimiento almacenado para obtener la lista de vehículos que
-- requieren mantenimiento basado en el kilometraje.



-- 8. Crear un procedimiento almacenado para insertar una nueva orden de compra

DELIMITER $$
CREATE Procedure crearordencompra(
    in aordenID int, 
    in afecha date, 
    in aproveedorID int, 
    in aempleadoID int, 
    in atotal DECIMAL(10,2)
)
begin
    INSERT INTO orden_compra (ordenID, fecha, proveedorID, empleadoID, total) VALUES
    (aordenID, afecha, aproveedorID, aempleadoID, atotal);
end $$
DELIMITER ;

-- 9. Crear un procedimiento almacenado para actualizar los datos de un cliente

DELIMITER $$
CREATE PROCEDURE actualizarcliente(
    in aClienteID INT,
    in aNombre VARCHAR(25),
    in aApellido VARCHAR(25),
    in aEmail VARCHAR(100)
)
begin 

UPDATE cliente 
    SET  Nombre = aNombre, Apellido = aApellido, Email = aEmail
    WHERE ClienteID = aClienteID;

end $$
DELIMITER ;

-- 10. Crear un procedimiento almacenado para obtener los servicios más solicitados
-- en un período

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



show tables;
