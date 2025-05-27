-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS facturacion_rd;
USE facturacion_rd;

-- Tabla de Monedas
CREATE TABLE monedas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(3) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    simbolo VARCHAR(5) NOT NULL,
    tasa_cambio DECIMAL(10,4) NOT NULL,
    activa BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de Empresas
CREATE TABLE empresas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    rnc VARCHAR(20) NOT NULL UNIQUE,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100),
    logo_url VARCHAR(255),
    moneda_principal_id INT,
    activa BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (moneda_principal_id) REFERENCES monedas(id)
);

-- Tabla de Tipos de Comprobantes Fiscales
CREATE TABLE tipos_ncf (
    id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(2) NOT NULL UNIQUE,
    descripcion VARCHAR(100) NOT NULL,
    activo BOOLEAN DEFAULT true
);

-- Tabla de Secuencias NCF
CREATE TABLE secuencias_ncf (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    tipo_ncf_id INT NOT NULL,
    serie VARCHAR(1) NOT NULL,
    secuencia_inicial INT NOT NULL,
    secuencia_actual INT NOT NULL,
    secuencia_final INT NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    activa BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id),
    FOREIGN KEY (tipo_ncf_id) REFERENCES tipos_ncf(id)
);

-- Tabla de Tipos de Cliente
CREATE TABLE tipos_cliente (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

-- Tabla de Clientes
CREATE TABLE clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo_cliente_id INT NOT NULL,
    tipo_documento ENUM('RNC', 'Cédula', 'Pasaporte') NOT NULL,
    documento VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    nombre_comercial VARCHAR(100),
    direccion TEXT,
    sector VARCHAR(100),
    ciudad VARCHAR(100),
    provincia VARCHAR(100),
    pais VARCHAR(100) DEFAULT 'República Dominicana',
    telefono VARCHAR(20),
    celular VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100),
    limite_credito DECIMAL(15,2) DEFAULT 0,
    dias_credito INT DEFAULT 0,
    contacto_nombre VARCHAR(100),
    contacto_telefono VARCHAR(20),
    contacto_email VARCHAR(100),
    notas TEXT,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tipo_cliente_id) REFERENCES tipos_cliente(id)
);

-- Tabla de Categorías de Productos
CREATE TABLE categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    categoria_padre_id INT,
    activa BOOLEAN DEFAULT true,
    FOREIGN KEY (categoria_padre_id) REFERENCES categorias(id)
);

-- Tabla de Marcas
CREATE TABLE marcas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT,
    activa BOOLEAN DEFAULT true
);

-- Tabla de Suplidores
CREATE TABLE suplidores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rnc VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    nombre_comercial VARCHAR(100),
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100),
    contacto_nombre VARCHAR(100),
    contacto_telefono VARCHAR(20),
    contacto_email VARCHAR(100),
    notas TEXT,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de Productos
CREATE TABLE productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    codigo_barras VARCHAR(100),
    codigo_qr VARCHAR(100),
    referencia VARCHAR(100),
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    marca_id INT,
    categoria_id INT,
    suplidor_id INT,
    modelo VARCHAR(100),
    unidad_medida VARCHAR(20),
    precio_compra DECIMAL(15,2) NOT NULL,
    precio_venta DECIMAL(15,2) NOT NULL,
    stock_minimo INT DEFAULT 0,
    stock_actual INT DEFAULT 0,
    itbis BOOLEAN DEFAULT true,
    activo BOOLEAN DEFAULT true,
    imagen_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (marca_id) REFERENCES marcas(id),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (suplidor_id) REFERENCES suplidores(id)
);

-- Tabla de Facturas
CREATE TABLE facturas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    cliente_id INT NOT NULL,
    ncf VARCHAR(19) NOT NULL UNIQUE,
    fecha DATE NOT NULL,
    fecha_vencimiento DATE,
    moneda_id INT NOT NULL,
    tasa_cambio DECIMAL(10,4) NOT NULL,
    subtotal DECIMAL(15,2) NOT NULL,
    descuento DECIMAL(15,2) DEFAULT 0,
    itbis DECIMAL(15,2) DEFAULT 0,
    total DECIMAL(15,2) NOT NULL,
    estado ENUM('Pendiente', 'Pagada', 'Anulada') DEFAULT 'Pendiente',
    notas TEXT,
    qr_validacion VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (moneda_id) REFERENCES monedas(id)
);

-- Tabla de Detalles de Factura
CREATE TABLE detalles_factura (
    id INT PRIMARY KEY AUTO_INCREMENT,
    factura_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(15,2) NOT NULL,
    descuento DECIMAL(15,2) DEFAULT 0,
    itbis DECIMAL(15,2) DEFAULT 0,
    total DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (factura_id) REFERENCES facturas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Tabla de Reportes DGII
CREATE TABLE reportes_dgii (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    tipo ENUM('606', '607', '608') NOT NULL,
    periodo VARCHAR(6) NOT NULL, -- AAAAMM
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    archivo_url VARCHAR(255),
    estado ENUM('Pendiente', 'Generado', 'Enviado') DEFAULT 'Pendiente',
    FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

-- Tabla de Configuración
CREATE TABLE configuracion (
    id INT PRIMARY KEY AUTO_INCREMENT,
    empresa_id INT NOT NULL,
    tema_color VARCHAR(7) DEFAULT '#007bff',
    tema_oscuro BOOLEAN DEFAULT false,
    logo_url VARCHAR(255),
    correo_notificaciones VARCHAR(100),
    firma_digital TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

-- Datos iniciales para monedas
INSERT INTO monedas (codigo, nombre, simbolo, tasa_cambio) VALUES
('DOP', 'Peso Dominicano', 'RD$', 1),
('USD', 'Dólar Estadounidense', '$', 58.50),
('EUR', 'Euro', '€', 63.75);

-- Datos iniciales para tipos de NCF
INSERT INTO tipos_ncf (codigo, descripcion) VALUES
('01', 'Factura de Crédito Fiscal'),
('02', 'Factura de Consumo'),
('03', 'Nota de Débito'),
('04', 'Nota de Crédito'),
('11', 'Comprobante de Compras'),
('12', 'Registro Único de Ingresos'),
('13', 'Registro de Gastos Menores'),
('14', 'Régimen Especial'),
('15', 'Comprobante Gubernamental');

-- Datos iniciales para tipos de cliente
INSERT INTO tipos_cliente (nombre, descripcion) VALUES
('Consumidor Final', 'Cliente sin RNC'),
('Crédito Fiscal', 'Cliente con RNC'),
('Gubernamental', 'Entidad del gobierno'),
('Especial', 'Cliente con condiciones especiales');
