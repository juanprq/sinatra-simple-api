# Importación de la gema sinatra para la implementación de los servicios.
require 'sinatra'

# Importación de la gema json para el formato en que responden los servicios.
require 'json'

# Colección de usuarios a ser empleada por el sistema.
@@users = {
  1 => {name: "Juan", last_name: "Ramírez", document: 1094891516},
  2 => {name: "Daniel", last_name: "Arbelaez", document: 1094673845},
  3 => {name: "José", last_name: "Ortiz", document: 1094627938},
  4 => {name: "Carlos", last_name: "Ariza", document: 1090341289},
  5 => {name: "Yamit", last_name: "Ospina", document: 1087649032}
}

# Filtro que se ejecuta antes de cada ruta.
before do
  # se pone el contenido que se responde en formato json y con un encoding de utf-8
  content_type :json, charset: 'utf-8'
end

# Servicio para obtener la colección de usuarios del sistema.
get '/users' do
  # Se convierte el contenido de la colección a json.
  @@users.to_json
end

# Servicio para la creación del recurso usuario.
post '/users' do
  
end

# Servicio para obtener un usuario en específico.
get '/users/{id}' do |id|
  # Se obtiene el usuario de la colección.
  user = @@users[id]

  # Se verifica si el usuario si es retornado.
  if user != nil
    # Se retorna el objeto encontrado.
    users.to_json
  else
    # En caso de no encontrarse en la colección se responde con el código 404 indicando que el recurso no existe.
    halt 404
end