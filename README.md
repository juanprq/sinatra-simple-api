Simple api de ejemplo implementada en sinatra
=============================================

Introducción
------------

Implementación de una api *REST* sencilla que responde en formato *JSON* que sirve como ejemplo de base, oepraciones basadas sobre el recurso users:

* GET /users: retorna la colección de usuarios del sistema.
* GET /users/{id}: retorna el usuario especificado, 404 en caso de no encontrar el recurso.
* POST /users: crea un nuevo usuario en el sistema respondiendo con 201 y en el Location el vínculo donde quedó el recurso, en caso de ya existir el identificador se retorna el código de error 409, el objeto se envía en formato JSON: *{"id" : 10, "user" : {"name" : "test", "last_name" : "test", "document", "123"}}*.
* PUT /users/{id}: actualiza el usuario que se está especificando en el identificador y retorna 204, en caso de no encontrar el recurso el servicio responde con el código 404, el objeto se envia en formato JSON: *{"name" : "test", "last_name" : "test", "document", "123"}*.
* DELETE /users/{id}: elimina el recurso especificado en el identificador y retorna el código 200 junto con la representación del objeto que acabó de eliminar, en caso que el recurso no exista responde con el código 404.

Dependencias
------------

Es necesario tener ruby y su gestor de gemas(gem) instalado en el sistema, para ello se recomienda el uso de cualquiera de los administradores de ambiente conocidos como: RVM o rvenv.

* sinatra
* json

Configuración del ambiente local
--------------------------------

Para correr el archivo services es necesario tener todas las dependencias instaladas; para correr la aplicación se ejecuta el comando:

    ruby services.rb

Para probar su funcionamiento se puede hacer uso de cualquier cliente http, he aquí unos ejemplos con cURL:

    curl -i -X GET http://localhost:4567/users/
    curl -i -X GET http://localhost:4567/users/1
    curl -i -X POST -d '{"id" : 7, "user": {"name":"juan", "last_name":"test", "document" : "123"}}' http://localhost:4567/users
    curl -i -X PUT -d '{"name":"test", "last_name":"test", "document" : "098"}' http://localhost:4567/users/7
    curl -i -X DELETE http://localhost:4567/users/6