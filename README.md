
# Santa Cruz de la Plazuela

Sistema de gestión para restaurante, con módulos de administración, pedidos, cocina y visualización de menú.

Para trabajar en el proyecto:

1. Clona el repositorio:
git clone https://github.com/santacruz-wq/santacruz.git

2. Entra a la carpeta del backend:
cd santacruz/backend

3. Instala las dependencias:
npm install

4. Crea un archivo llamado .env dentro de la carpeta backend, y pega exactamente esto (reemplaza TU_CONTRASEÑA por la contraseña real de MongoDB):

MONGO_URI=mongodb+srv://santacruzdelaplazuela_db_user:TU_CONTRASEÑA@cluster0.ctxzlqk.mongodb.net/santacruz?appName=Cluster0
JWT_SECRET=el_secreto_que_uses
EMAIL_USER=santacruzdelaplazuela@gmail.com
EMAIL_PASS=la_contraseña_de_aplicacion

5. Levanta el servidor:
node index.js
