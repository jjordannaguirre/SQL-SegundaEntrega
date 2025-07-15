-- Base de datos para Peluquería - Control de Turnos

CREATE DATABASE peluqueria_turnos;
USE peluqueria_turnos;

-- Tabla clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    telefono VARCHAR(20)
);

-- Tabla peluqueros
CREATE TABLE peluqueros (
    id_peluquero INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50)
);

-- Tabla servicios
CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100),
    precio DECIMAL(8,2)
);

-- Tabla turnos
CREATE TABLE turnos (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME,
    id_cliente INT,
    id_peluquero INT,
    id_servicio INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_peluquero) REFERENCES peluqueros(id_peluquero),
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
);
