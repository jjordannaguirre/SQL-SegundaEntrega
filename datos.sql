
-- Insertar datos en la tabla clientes
INSERT INTO clientes (nombre, telefono) VALUES
('Juan Pérez', '3511111111'),
('Lucía González', '3512222222'),
('Carlos López', '3513333333');

-- Insertar datos en la tabla peluqueros
INSERT INTO peluqueros (nombre) VALUES
('María Esteban'),
('Andrés Silva'),
('Sofía Torres');

-- Insertar datos en la tabla servicios
INSERT INTO servicios (descripcion, precio) VALUES
('Corte de cabello', 1500.00),
('Coloración', 3000.00),
('Peinado', 2000.00);

-- Insertar datos en la tabla turnos
INSERT INTO turnos (fecha_hora, id_cliente, id_peluquero, id_servicio) VALUES
('2025-07-20 10:00:00', 1, 1, 1),
('2025-07-20 11:00:00', 2, 2, 2),
('2025-07-20 12:00:00', 3, 3, 3);
