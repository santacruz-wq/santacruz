# 🏛️santa cruz de la plazuela- sistema de pedidos 
aplicacio movil para gestionar el catalogo de productos,usuarios y pedidos de un restaurante, desarrollada con una excelente tecnologia
##🛠️ stack tecnologico
El proyecto utiliza una arquitectura moderna basada en un cliente movil, un servidor backend y una base de datos en la nube, integrando las siguientes tecnologias:
. nodes.js + Express (backend)
. mongoDB atlas (base de datos)
. flutter (frontend)
. JWT para el manejo de sesiones
. liberia de traduccion multi-idioma

## 🚀 caracteristica del proyecto

### 🌍 1. seleccion e idioma
. seleccion de idioma: pantalla inicial donde el ususario elige el idioma ante de ingresar.
. traduccion global: El idioma selecionado aplica a todas la app, incluyendo el contenido dinamico (no solo los textos fijos de la interfaz).
. cambio de idioma en cualquier momento: El usuario puede cambiar el idioma desde caulquier pantalla y toda la app se traduce por completo.

###💼2. modulo de administracion
. CRUD de productos: creacion, actualizacion y gestion de productos y categorias.
. Gestion de categorias: organizacion del menu por categorias (BDcategoria).
. integracion frontend-Backend: conexion completa entre la interfaz y la api con mongoDB.

###🍽️ 3. modulo del usuario
. visualizacion del menu:
exploracion del catalogo de productos en el idioma seleccionado.
. modulo del mesero: Creacion de peididos desde la mesa asignada (BDmesa).
. favoritos y reseñas: Gestion de productos favoritos (BDfavoritos) y reseñas (BDreseña).

###🧑‍🍳 4.modulo de cocina

. notificaciones de pedidos: alertas en tiempo real de nuevos pedidos (BDnotificacion, BDcocina_pedido).
.cambio de estados: actualizacion del estado de los pedidos en cocina.
. Disponibilidad de productos como agotado o disponible (BDinventario, BDinventario_movimiento).

###📄5.Gestion de pedidos

. Detalles de orden: Resgitro detallado de cada pedido (BDorden_detalle, BDordenes).
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

santacruz/
|

