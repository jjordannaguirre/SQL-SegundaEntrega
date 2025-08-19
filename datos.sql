-- ===============================
-- SCRIPT DE INSERCIÓN DE DATOS
-- Base de datos: Peluquería
-- ===============================

-- ====== ROLES ======
INSERT INTO roles (id_rol, descripcion) VALUES
(1, 'Peluquero/a'),
(2, 'Recepcionista'),
(3, 'Colorista'),
(4, 'Administrador');

-- ====== EMPLEADOS ======
INSERT INTO empleados (id_empleado, nombre, telefono, id_rol) VALUES
(1, 'María Gómez', '3515551111', 1),
(2, 'Lucía Torres', '3515552222', 3),
(3, 'Juan Pérez', '3515553333', 1),
(4, 'Laura Rodríguez', '3515554444', 2),
(5, 'Carlos Medina', '3515555555', 4);

-- ====== CLIENTES ======
INSERT INTO clientes (id_cliente, nombre, telefono, email) VALUES
(1, 'Sofía Martínez', '3514441111', 'sofia.martinez@mail.com'),
(2, 'Diego López', '3514442222', 'diego.lopez@mail.com'),
(3, 'Valentina Castro', '3514443333', 'valentina.castro@mail.com'),
(4, 'Martín Fernández', '3514444444', 'martin.fernandez@mail.com'),
(5, 'Camila Herrera', '3514445555', 'camila.herrera@mail.com');

-- ====== SERVICIOS ======
INSERT INTO servicios (id_servicio, descripcion, precio) VALUES
(1, 'Corte de cabello', 2500),
(2, 'Coloración completa', 6500),
(3, 'Peinado de fiesta', 4000),
(4, 'Tratamiento capilar', 5500),
(5, 'Reflejos', 4800);

-- ====== TURNOS ======
INSERT INTO turnos (id_turno, fecha_hora, id_cliente, id_empleado, id_servicio, estado) VALUES
(1, '2025-08-01 10:00:00', 1, 1, 1, 'Completado'),
(2, '2025-08-01 11:30:00', 2, 2, 2, 'Completado'),
(3, '2025-08-02 15:00:00', 3, 3, 3, 'Completado'),
(4, '2025-08-02 17:00:00', 4, 1, 4, 'Pendiente'),
(5, '2025-08-03 09:30:00', 5, 2, 5, 'Completado');

-- ====== MÉTODOS DE PAGO ======
INSERT INTO metodos_pago (id_metodo_pago, descripcion) VALUES
(1, 'Efectivo'),
(2, 'Tarjeta de Crédito'),
(3, 'Tarjeta de Débito'),
(4, 'Transferencia Bancaria');

-- ====== PAGOS ======
INSERT INTO pagos (id_pago, id_turno, id_metodo_pago, monto, fecha_pago) VALUES
(1, 1, 1, 2500, '2025-08-01'),
(2, 2, 2, 6500, '2025-08-01'),
(3, 3, 3, 4000, '2025-08-02'),
(4, 5, 2, 4800, '2025-08-03');

-- ====== PRODUCTOS ======
INSERT INTO productos (id_producto, nombre, precio, stock) VALUES
(1, 'Shampoo nutritivo', 2000, 25),
(2, 'Acondicionador reparador', 2200, 30),
(3, 'Laca fijadora', 1800, 15),
(4, 'Serum capilar', 3500, 10),
(5, 'Tintura rubio ceniza', 2800, 20);

-- ====== VENTAS DE PRODUCTOS ======
INSERT INTO ventas_productos (id_venta, id_cliente, id_producto, cantidad, fecha) VALUES
(1, 1, 1, 2, '2025-08-01'),
(2, 2, 3, 1, '2025-08-01'),
(3, 3, 2, 1, '2025-08-02'),
(4, 4, 5, 2, '2025-08-03'),
(5, 5, 4, 1, '2025-08-03');

-- ====== PROVEEDORES ======
INSERT INTO proveedores (id_proveedor, nombre, telefono, email) VALUES
(1, 'Distribuidora Belleza SA', '3515556666', 'ventas@belleza.com'),
(2, 'Cosméticos Premium SRL', '3515557777', 'contacto@cosmeticospremium.com'),
(3, 'Insumos Peluquería Córdoba', '3515558888', 'info@insumoscordoba.com');

-- ====== COMPRAS DE INSUMOS ======
INSERT INTO compras_insumos (id_compra, id_proveedor, fecha, total) VALUES
(1, 1, '2025-07-28', 15000),
(2, 2, '2025-07-29', 12000),
(3, 3, '2025-07-30', 18000);

-- ====== HISTORIAL DE PRECIOS ======
INSERT INTO historial_precios (id_historial, id_servicio, precio_anterior, precio_nuevo, fecha_cambio) VALUES
(1, 1, 2200, 2500, '2025-07-01'),
(2, 2, 6000, 6500, '2025-07-10'),
(3, 3, 3800, 4000, '2025-07-15');
