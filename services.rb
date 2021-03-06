# Importación de la gema sinatra para la implementación de los servicios.
require 'sinatra'

# Importación de la gema json para el formato en que responden los servicios.
require 'json'

# Colección de usuarios a ser empleada por el sistema.
set(:users, {
  1 => {name: "Juan", last_name: "Ramírez", document: "1094891516"},
  2 => {name: "Daniel", last_name: "Arbelaez", document: "1094673845"},
  3 => {name: "José", last_name: "Ortiz", document: "1094627938"},
  4 => {name: "Carlos", last_name: "Ariza", document: "1090341289"},
  5 => {name: "Yamit", last_name: "Ospina", document: "1087649032"}
})

# Filtro que se ejecuta antes de cada ruta.
before do
  # se pone el contenido que se responde en formato json y con un encoding de utf-8
  content_type :json, charset: 'utf-8'
end

# Inscripción de helpers de la aplicación.
helpers do
  
  # Se encarga de seleccionar solo los campos especificados de un Hash.
  def accept_params(params, *fields)
    result = Hash.new
    fields.each do |name|
      result[name] = params[name] if params[name]
    end
    result
  end

  # Valida que el valor del identificador sean dígitos.
  def valid_id?(id)
    id && id.to_s =~ /^\d+$/
  end

end

# Servicio para obtener la colección de usuarios del sistema.
get '/users' do
  logger.info 'Se retorna la colección de usuarios.'
  # Se convierte el contenido de la colección a json.
  settings.users.to_json
end

# Servicio para la creación del recurso usuario.
post '/users' do
  # Se recibe y se parsea el contenido json que llega
  data = JSON.parse(request.body.string)
  logger.info "Se va a crear un nuevo usuario con los datos: #{data.to_json}"

  if(valid_id?(data['id'])) 
    # Se verifica el identificador que no esté repetido.
    id = data['id'].to_i

    if settings.users[id].nil?
      # Se asignan los valores al objeto de usuario.
      user = accept_params(data['user'], 'name', 'last_name', 'document')

      settings.users[id] = user
      headers["Location"] = "/users/#{id}"
      status 201
    else
      logger.error 'Ocurrió un error al tratar de crear un nuevo usuario'
      # Se envía un código de error al cliente para indicarle que algo asalió mal.
      status 409
    end
  else
    status 404
  end
end

# Servicio para obtener un usuario en específico.
get '/users/:id' do |id|
  logger.info 'Se va a obtener el usuario con id: #{id}'

  if valid_id?(id)
    # Se obtiene el usuario de la colección.
    user = settings.users[id.to_i]

    # Se verifica si el usuario si es retornado.
    if user.nil?
      logger.info "El usuario con id: #{id} no fué encontrado en el sistema"
      # En caso de no encontrarse en la colección se responde con el código 404 indicando que el recurso no existe.
      status 404
    else
      # Se retorna el objeto encontrado.
      user.to_json
    end
  else
    status 404
  end
end

# Servicio para actualizar un recurso.
put '/users/:id' do |id|
  # Se parsea el contenido a json
  data = JSON.parse(request.body.string)

  logger.info "Se va a actualizar el usuario con id: #{id} con los datos: #{data}"

  if valid_id?(id)
    # Se castea a entero.
    id = id.to_i
    if settings.users[id].nil?
      logger.info "El usuario con id #{id} no fué encontrado"
      # Se responde con el código de error ya que el recurso no fué encontrado.
      status 404
    else
      # Se pasan los parámetros a la variable usuario
      user = accept_params(data, 'name', 'last_name', 'document')

      # Se actualiza el valor del usuario en la colección de objetos.
      settings.users[id] = user

      # Se responde el código 204 para indicar que fué exitosa la operación pero no hay un contenido para responder.
      status 204
    end
  else
    status 404
  end
end

# Servicio para eliminar un recurso.
delete '/users/:id' do |id|
  logger.info "Se va a eliminar el usuario con id: #{id}"

  if valid_id?(id)
    # Se castea a entero
    id = id.to_i
    # Se verifica la existencia del recurso en el sistema.
    if settings.users[id].nil?
      logger.info "El usuario con id: #{id} no fué encontrado"
      # En caso de no encontrarlo se retorna el código de error.
      status 404    
    else
      # Se remueve el recurso de la colección
      user = settings.users.delete(id)

      # Se retorna un código de éxito y el contenido del usuario.
      status 200
      user.to_json
    end
  else
    status 404
  end
end

# Respuesta cuando no se encuentra el recurso.
not_found do
  status 404
  return '404, not found'
end