# 🏛️SANTA CRUZ DE LA PLAZUELA- SISTEMA DE PEDIDOS 
Aplicacio movil para gestionar el catalogo de productos,usuarios y pedidos de un restaurante, desarrollada con una excelente tecnologia

##🛠️ stack Tecnologico

El proyecto utiliza una arquitectura moderna basada en un cliente movil, un servidor backend y una base de datos en la nube, integrando las siguientes tecnologias:
. Nodes.js + Express (backend)
. MongoDB Atlas (base de datos)
. Flutter (frontend)
. JWT para el manejo de sesiones
. liberia de traduccion multi-idioma

## 🚀 Caracteristica del proyecto

### 🌍 1. Seleccion e idioma
. seleccion de idioma: pantalla inicial donde el ususario elige el idioma ante de ingresar.
. Traduccion Global: El idioma selecionado aplica a todas la app, incluyendo el contenido dinamico (no solo los textos fijos de la interfaz).
. cambio de idioma en Cualquier momento: El usuario puede cambiar el idioma desde cualquier pantalla y toda la app se traduce por completo.

###💼2. Modulo de Administracion
. CRUD de productos: creacion, actualizacion y gestion de productos y categorias.
. Gestion de Categorias: Organizacion del menu por categorias (BDcategoria).
. integracion frontend-Backend: Conexion completa entre la interfaz y la Api con mongoDB.

###🍽️ 3. Modulo del usuario
. Visualizacion del menu:
Exploracion del catalogo de productos en el idioma seleccionado.
. Modulo del Mesero: Creacion de pedidos desde la mesa asignada (BDmesa).
. favoritos y reseñas: Gestion de productos favoritos (BDfavoritos) y reseñas (BDreseña).

###🧑‍🍳 4.Modulo de cocina

. notificaciones de pedidos: Alertas en tiempo real de nuevos pedidos (BDnotificacion, BDcocina_pedido).
.Cambio de Estados: actualizacion del estado de los pedidos en cocina.
. Disponibilidad de productos: Marcado de productos como agotado o disponible (BDinventario, BDinventario_movimiento )

###📄5.Gestion de pedidos

. Detalles de Orden: Resgitro detallado de cada pedido (BDorden_detalle, BDordenes).
. Historial de pedidos: seguimiento del flujo completo de la orden.

##⚙️ instalacion y configuracion

###🔗 1. clonar el repositorio

. git clone https://github.com/santacruz-wq/santacruz.git
. instalacion de node 
. npm install
.instalar liberia de mongoDB
.Instalar liberia de traduccion (Flutter)

### 2.Ejecutar el servidor
. npm run dev

## Estructura del proyecto

 ```
santacruz/
├── backend/
│ ├── controllers/ # Lógica para usuarios, productos y pedidos
│ ├── db/ # Conexión a MongoDB Atlas
│ ├── middlewares/ # Validación de JWT y roles
│ ├── models/ # Esquemas de datos (Productos, Usuarios, Órdenes)
│ ├── routes/ # Definición de rutas API
│ ├── .env
│ ├── .gitignore
│ ├── index.js # Servidor principal
│ └── package.json
└── frontend/
    └── lib/ # Aplicación Flutter
```

##👤 Autores

. *Javier Trujillo*- Desarrollador Full Stack
-Eespecialidad: Modulo de administracion, gestion de productos, categorias y Api con MongoDB;
integracion frontend y backend.
.*Juan Rivas*-Desarrollador Full Stack
-Especialidad: Modulo del usuario (visualizacion del menu y traduccion a varios idiomas) y modulo del mesero para creacion de pedidos
.*Jhon mauricio*- Desarrollador Full Stack
-Especialidad: Modulo de cocina, notificaciones de nuevos pedidos, cambio de estados, disponibilidad de productos, pruebas e integracion con el backend.

