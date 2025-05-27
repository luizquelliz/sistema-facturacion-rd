# Sistema de Facturación RD

Sistema de facturación diseñado específicamente para la República Dominicana, con soporte para comprobantes fiscales y futura integración con comprobantes electrónicos.

## Características

- Gestión de ventas con comprobantes fiscales
- Manejo de clientes (contado y crédito)
- Consulta de contribuyentes desde la DGII
- Control de inventarios
- Gestión de usuarios y permisos
- Generación de reportes
- Configuración de base de datos MariaDB
- Soporte para múltiples empresas

## Tecnologías Utilizadas

- Next.js 14
- TypeScript
- Tailwind CSS
- Shadcn/ui
- MariaDB

## Requisitos

- Node.js 18 o superior
- MariaDB 10.5 o superior

## Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/tu-usuario/facturacion-rd.git
cd facturacion-rd
```

2. Instalar dependencias:
```bash
npm install
```

3. Configurar variables de entorno:
```bash
cp .env.example .env
```
Editar el archivo `.env` con las credenciales de la base de datos y otras configuraciones necesarias.

4. Iniciar el servidor de desarrollo:
```bash
npm run dev
```

La aplicación estará disponible en `http://localhost:8000`

## Estructura del Proyecto

```
src/
├── app/                    # Páginas de la aplicación
│   ├── facturacion/       # Módulo de facturación
│   ├── clientes/          # Módulo de clientes
│   ├── inventario/        # Módulo de inventario
│   ├── reportes/          # Módulo de reportes
│   ├── configuracion/     # Módulo de configuración
│   └── usuarios/          # Módulo de usuarios
├── components/            # Componentes reutilizables
│   ├── ui/               # Componentes de interfaz
│   └── ...
├── lib/                  # Utilidades y helpers
└── ...
```

## Módulos Principales

### Facturación
- Emisión de facturas con NCF
- Gestión de comprobantes fiscales
- Cálculo automático de impuestos

### Clientes
- Gestión de clientes
- Historial de transacciones
- Límites de crédito
- Consulta DGII

### Inventario
- Control de stock
- Múltiples categorías
- Alertas de bajo inventario
- Historial de movimientos

### Reportes
- Informes de ventas
- Estado de inventario
- Análisis de clientes
- Exportación a Excel/PDF

### Configuración
- Configuración de base de datos
- Gestión de empresas
- Parámetros del sistema

### Usuarios
- Control de acceso
- Roles y permisos
- Registro de actividades

## Contribución

Si deseas contribuir al proyecto:

1. Haz un fork del repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Haz commit de tus cambios (`git commit -m 'Agrega nueva característica'`)
4. Haz push a la rama (`git push origin feature/nueva-caracteristica`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## Soporte

Para soporte y consultas, por favor abrir un issue en el repositorio o contactar a través de [correo@ejemplo.com](mailto:correo@ejemplo.com).
