-- =============================================
-- BASE DE DATOS: Peluquería - Control Integral
-- =============================================

CREATE DATABASE IF NOT EXISTS peluqueria_turnos;
USE peluqueria_turnos;

-- =======================
-- TABLAS PRINCIPALES
-- =======================

-- Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Empleados (incluye peluqueros y admins)
CREATE TABLE IF NOT EXISTS empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    telefono VARCHAR(20),
    id_rol INT
);

-- Roles de empleados
CREATE TABLE IF NOT EXISTS roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50)
);

-- Servicios
CREATE TABLE IF NOT EXISTS servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100),
    precio DECIMAL(8,2)
);

-- Turnos (transaccional)
CREATE TABLE IF NOT EXISTS turnos (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME,
    id_cliente INT,
    id_empleado INT,
    id_servicio INT,
    estado VARCHAR(20) DEFAULT 'activo',
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);

-- Agenda de peluqueros
CREATE TABLE IF NOT EXISTS agenda_peluqueros (
    id_agenda INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT,
    fecha DATE,
    hora TIME,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- Pagos (transaccional)
CREATE TABLE IF NOT EXISTS pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_turno INT,
    id_metodo_pago INT,
    monto DECIMAL(10,2),
    fecha_pago DATETIME,
    FOREIGN KEY (id_turno) REFERENCES turnos(id_turno)
);

-- Métodos de pago
CREATE TABLE IF NOT EXISTS metodos_pago (
    id_metodo_pago INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50)
);

-- Productos (shampoo, tinturas, etc.)
CREATE TABLE IF NOT EXISTS productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(8,2),
    stock INT
);

-- Ventas de productos
CREATE TABLE IF NOT EXISTS ventas_productos (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    fecha DATETIME,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Promociones
CREATE TABLE IF NOT EXISTS promociones (
    id_promocion INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100),
    descuento DECIMAL(5,2),
    fecha_inicio DATE,
    fecha_fin DATE
);

-- Fidelización de clientes
CREATE TABLE IF NOT EXISTS clientes_fidelidad (
    id_fidelidad INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    puntos INT DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Proveedores
CREATE TABLE IF NOT EXISTS proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Compras de insumos
CREATE TABLE IF NOT EXISTS compras_insumos (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_proveedor INT,
    fecha DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

-- Historial de precios (tabla auxiliar)
CREATE TABLE IF NOT EXISTS historial_precios (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_servicio INT,
    precio_anterior DECIMAL(8,2),
    precio_nuevo DECIMAL(8,2),
    fecha_cambio DATETIME,
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);

-- =======================
-- VISTAS
-- =======================

-- Vista 1: Turnos detallados
CREATE OR REPLACE VIEW vista_turnos_detallados AS
SELECT t.id_turno, t.fecha_hora, 
       c.nombre AS cliente, 
       e.nombre AS peluquero, 
       s.descripcion AS servicio, 
       s.precio
FROM turnos t
JOIN clientes c ON t.id_cliente = c.id_cliente
JOIN empleados e ON t.id_empleado = e.id_empleado
JOIN servicios s ON t.id_servicio = s.id_servicio;

-- Vista 2: Ingresos por peluquero
CREATE OR REPLACE VIEW vista_ingresos_peluquero AS
SELECT e.nombre AS peluquero, SUM(s.precio) AS total_ingresos
FROM turnos t
JOIN empleados e ON t.id_empleado = e.id_empleado
JOIN servicios s ON t.id_servicio = s.id_servicio
GROUP BY e.nombre;

-- Vista 3: Servicios más solicitados
CREATE OR REPLACE VIEW vista_servicios_populares AS
SELECT s.descripcion, COUNT(*) AS cantidad_turnos
FROM turnos t
JOIN servicios s ON t.id_servicio = s.id_servicio
GROUP BY s.descripcion
ORDER BY cantidad_turnos DESC;

-- Vista 4: Clientes con mayor gasto
CREATE OR REPLACE VIEW vista_clientes_top AS
SELECT c.nombre, SUM(s.precio) AS total_gastado
FROM turnos t
JOIN clientes c ON t.id_cliente = c.id_cliente
JOIN servicios s ON t.id_servicio = s.id_servicio
GROUP BY c.nombre
ORDER BY total_gastado DESC;

-- Vista 5: Ranking de productos vendidos
CREATE OR REPLACE VIEW vista_productos_populares AS
SELECT p.nombre, SUM(v.cantidad) AS total_vendidos
FROM ventas_productos v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY p.nombre
ORDER BY total_vendidos DESC;

-- =======================
-- FUNCIONES
-- =======================

DELIMITER //
-- Función 1: Total gastado por cliente
CREATE FUNCTION total_gastado_cliente(cliente_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE total DECIMAL(10,2);
  SELECT SUM(s.precio)
  INTO total
  FROM turnos t
  JOIN servicios s ON t.id_servicio = s.id_servicio
  WHERE t.id_cliente = cliente_id;
  RETURN IFNULL(total, 0);
END;
//

-- Función 2: Cantidad de turnos de un peluquero
CREATE FUNCTION cantidad_turnos_peluquero(peluquero_id INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE cant INT;
  SELECT COUNT(*)
  INTO cant
  FROM turnos
  WHERE id_empleado = peluquero_id;
  RETURN IFNULL(cant, 0);
END;
//
DELIMITER ;

-- =======================
-- STORED PROCEDURES
-- =======================

DELIMITER //
-- SP 1: Registrar turno
CREATE PROCEDURE registrar_turno (
  IN fecha DATETIME, 
  IN cliente INT, 
  IN peluquero INT, 
  IN servicio INT
)
BEGIN
  INSERT INTO turnos (fecha_hora, id_cliente, id_empleado, id_servicio)
  VALUES (fecha, cliente, peluquero, servicio);
END;
//

-- SP 2: Cancelar turno
CREATE PROCEDURE cancelar_turno (
  IN turno_id INT
)
BEGIN
  UPDATE turnos SET estado = 'cancelado' WHERE id_turno = turno_id;
END;
//
DELIMITER ;

-- =======================
-- TRIGGERS
-- =======================

DELIMITER //
-- Trigger 1: Guardar cambios de precio
CREATE TRIGGER tr_cambio_precio
BEFORE UPDATE ON servicios
FOR EACH ROW
BEGIN
  IF OLD.precio != NEW.precio THEN
    INSERT INTO historial_precios (id_servicio, precio_anterior, precio_nuevo, fecha_cambio)
    VALUES (OLD.id_servicio, OLD.precio, NEW.precio, NOW());
  END IF;
END;
//

-- Trigger 2: Validar que no se dupliquen turnos en misma fecha/hora/peluquero
CREATE TRIGGER tr_validar_turno
BEFORE INSERT ON turnos
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM turnos 
             WHERE fecha_hora = NEW.fecha_hora 
             AND id_empleado = NEW.id_empleado
             AND estado = 'activo') THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El peluquero ya tiene un turno en ese horario.';
  END IF;
END;
//
DELIMITER ;
