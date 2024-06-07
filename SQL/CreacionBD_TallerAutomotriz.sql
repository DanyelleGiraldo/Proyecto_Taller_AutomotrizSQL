create database taller_automotriz;
use taller_automotriz;


CREATE TABLE Proveedor (
    ProveedorID INT PRIMARY KEY,
    TipoProducto ENUM('M', 'P') not null,
    Nombre VARCHAR(50) not null,
    apellido1 varchar(20) not null,
    apellido2 varchar(20),
    Contacto VARCHAR(100) not null,
    Email VARCHAR(100) unique
);

CREATE TABLE Servicio (
    ServicioID INT PRIMARY KEY,
    Nombre VARCHAR(25) not null,
    Descripcion TEXT not null,
    Costo DECIMAL(10,2) not null
);

CREATE TABLE ubicacion (
    ubicacionID INT PRIMARY KEY,
    nombre VARCHAR(50) not null,
    descripcion VARCHAR(100) not null
);

CREATE TABLE cargo (
    cargoID INT PRIMARY KEY,
    Nombre VARCHAR(25) not null,
    Descripcion VARCHAR(100) not null
);

CREATE TABLE pieza (
    piezaID INT PRIMARY KEY,
    Nombre VARCHAR(25) not null,
    Descripcion TEXT not null,
    precio DECIMAL(10,2) not null, 
    proveedorID INT not null,
    FOREIGN KEY (proveedorID) REFERENCES Proveedor(ProveedorID)
);

CREATE TABLE inventario (
    inventarioID INT PRIMARY KEY,
    piezaID INT not null,
    cantidad INT not null,
    ubicacionID INT not null,
    FOREIGN KEY (piezaID) REFERENCES pieza(piezaID),
    FOREIGN KEY (ubicacionID) REFERENCES ubicacion(ubicacionID)
);

CREATE TABLE Empleado (
    empleadoID INT PRIMARY KEY,
    Nombre VARCHAR(25) not null,
    Apellido VARCHAR(25) not null,
    cargoID INT not null,
    FOREIGN KEY (cargoID) REFERENCES cargo(cargoID)
);

CREATE TABLE Cliente (
    ClienteID INT PRIMARY KEY,
    Nombre VARCHAR(25) not null,
    Apellido VARCHAR(25) not null,
    Email VARCHAR(100) not null unique
);

CREATE TABLE orden_compra (
    ordenID INT PRIMARY KEY,
    fecha DATE not null,
    proveedorID INT not null,
    empleadoID INT not null,
    total DECIMAL(10,2) not null,
    FOREIGN KEY (proveedorID) REFERENCES Proveedor(ProveedorID),
    FOREIGN KEY (empleadoID) REFERENCES Empleado(empleadoID)
);

CREATE TABLE orden_detalle (
    ordenID INT not null,
    pieza_id INT not null,
    cantidad INT not null,
    precio DECIMAL(10,2) not null,
    PRIMARY KEY (ordenID, pieza_id),
    FOREIGN KEY (ordenID) REFERENCES orden_compra(ordenID),
    FOREIGN KEY (pieza_id) REFERENCES pieza(piezaID)
);

CREATE TABLE Vehiculo (
    VehiculoID INT PRIMARY KEY,
    Placa VARCHAR(6) not null,
    Marca VARCHAR(25) not null,
    Modelo VARCHAR(50) not null,
    Año INT not null,
    ClienteID INT not null,
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID)
);

CREATE TABLE Reparacion (
    ReparacionID INT PRIMARY KEY,
    Fecha DATE not null,
    VehiculoID INT not null,
    ServicioID INT not null,
    CostoTotal DECIMAL(10,2) not null,
    Descripcion TEXT not null,
    duracion INT not null,
    FOREIGN KEY (VehiculoID) REFERENCES Vehiculo(VehiculoID),
    FOREIGN KEY (ServicioID) REFERENCES Servicio(ServicioID)
);

CREATE TABLE reparacion_pieza (
    reparacionID INT not null,
    piezaID INT not null,
    cantidad INT not null,
    PRIMARY KEY (reparacionID, piezaID),
    FOREIGN KEY (reparacionID) REFERENCES Reparacion(ReparacionID),
    FOREIGN KEY (piezaID) REFERENCES pieza(piezaID)
);

CREATE TABLE Empleado_reparacion (
    empleadoID INT ,
    reparacionID INT not null,
    PRIMARY KEY (empleadoID, reparacionID),
    FOREIGN KEY (empleadoID) REFERENCES Empleado(empleadoID),
    FOREIGN KEY (reparacionID) REFERENCES Reparacion(ReparacionID)
);

CREATE TABLE factura (
    facturaID INT PRIMARY KEY,
    fecha DATE not null,
    clienteID INT not null,
    total DECIMAL(10,2) not null,
    FOREIGN KEY (clienteID) REFERENCES Cliente(ClienteID)
);

CREATE TABLE factura_detalle (
    facturaID INT ,
    reparacionID INT not null,
    cantidad INT not null,
    precio DECIMAL(10,2) not null, 
    PRIMARY KEY (facturaID, reparacionID),
    FOREIGN KEY (facturaID) REFERENCES factura(facturaID),
    FOREIGN KEY (reparacionID) REFERENCES Reparacion(ReparacionID)
);

CREATE TABLE telefono (
    telefonoID INT PRIMARY KEY AUTO_INCREMENT,
    entidadID INT not null,
    tipotelefono VARCHAR(30) not null,
    numero VARCHAR(20) not null,
    tipopersona ENUM('C', 'E', 'P') not null,
    FOREIGN KEY (entidadID) REFERENCES Cliente(ClienteID),
    FOREIGN KEY (entidadID) REFERENCES Empleado(empleadoID),
    FOREIGN KEY (entidadID) REFERENCES Proveedor(ProveedorID)
);

CREATE TABLE direccion (
    clienteID INT,
    direccion VARCHAR(30) not null,
    codigopostal VARCHAR(20) not null,
    ciudad VARCHAR(20) not null,
    pais VARCHAR(20) not null,
    PRIMARY KEY (clienteID),
    FOREIGN KEY (clienteID) REFERENCES Cliente(ClienteID)
);

CREATE TABLE cita (
    citaID INT PRIMARY KEY,
    fechaHora DATETIME not null,
    clienteID INT not null,
    vehiculoID INT not null,
    servicioID INT not null,
    FOREIGN KEY (clienteID) REFERENCES Cliente(ClienteID),
    FOREIGN KEY (vehiculoID) REFERENCES Vehiculo(VehiculoID),
    FOREIGN KEY (servicioID) REFERENCES Servicio(ServicioID)
);
