-- Base de datos para Peluquería - Control de Turnos

CREATE DATABASE IF NOT EXISTS peluqueria_turnos;
USE peluqueria_turnos;

-- Tabla clientes
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    telefono VARCHAR(20)
);

-- Tabla peluqueros
CREATE TABLE IF NOT EXISTS peluqueros (
    id_peluquero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
);

-- Tabla servicios
CREATE TABLE IF NOT EXISTS servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100),
    precio DECIMAL(8,2)
);

-- Tabla turnos
CREATE TABLE IF NOT EXISTS turnos (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME,
    id_cliente INT,
    id_peluquero INT,
    id_servicio INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_peluquero) REFERENCES peluqueros(id_peluquero),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);

-- Vista: vista_turnos_detallados
CREATE VIEW IF NOT EXISTS vista_turnos_detallados AS
SELECT t.id_turno, t.fecha_hora, 
       c.nombre AS cliente, 
       p.nombre AS peluquero, 
       s.descripcion AS servicio, 
       s.precio
FROM turnos t
JOIN clientes c ON t.id_cliente = c.id_cliente
JOIN peluqueros p ON t.id_peluquero = p.id_peluquero
JOIN servicios s ON t.id_servicio = s.id_servicio;

-- Función: total_gastado_cliente
DELIMITER //
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
DELIMITER ;

-- Stored Procedure: registrar_turno
DELIMITER //
CREATE PROCEDURE registrar_turno (
  IN fecha DATETIME, 
  IN cliente INT, 
  IN peluquero INT, 
  IN servicio INT
)
BEGIN
  INSERT INTO turnos (fecha_hora, id_cliente, id_peluquero, id_servicio)
  VALUES (fecha, cliente, peluquero, servicio);
END;
//
DELIMITER ;

-- Tabla auxiliar: historial_precios
CREATE TABLE IF NOT EXISTS historial_precios (
  id_historial INT AUTO_INCREMENT PRIMARY KEY,
  id_servicio INT,
  precio_anterior DECIMAL(8,2),
  precio_nuevo DECIMAL(8,2),
  fecha_cambio DATETIME
);

-- Trigger: tr_cambio_precio
DELIMITER //
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
DELIMITER ;
