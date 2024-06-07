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



show tables
