ENV['RACK_ENV'] = 'test'

# Importación del archivo sobre el cual se van a realizar las pruebas.
require './services'
# Importación de las librerías para realizar las pruebas.
require 'minitest/autorun'
# Importación de las librerías para realizar pruebas sobre rack.
require 'rack/test'
# Librería para el parseo de datos que responden los servicios.
require 'json'

# Clase que extiende de TestCase del framework de pruebas.
class ServicesTest < Minitest::Test
  # Se incluyen los métodos para facilitar la implementación de las pruebas.
  include Rack::Test::Methods

  # Define el tipo de aplicación que se va a probar.
  def app
    Sinatra::Application
  end

  # Prueba el funcionamiento del servicio para obtener la colección de usuarios.
  def test_get_users
    get '/users'
    assert last_response.ok?, 'Código de respuesta incorrecto'
  end

  # Prueba el funcionamiento del servicio para obtener la resperentación de un usuario en específico.
  def test_get_user
    get '/users/1'
    assert last_response.ok?, 'Código de respuesta incorrecto'

    data = JSON.parse last_response.body
    assert_equal "Juan", data['name'], 'El valor de la propiedad name es incorrecto'
    assert_equal "Ramírez", data['last_name'], ' El valor de la propiedad last_name es incorrecto'
    assert_equal "1094891516", data['document'], 'El valor de la propiedad document es incorrecto'
  end

  # Prueba el servicio al tratar de obtener un usuario con un identificador inválido.
  def test_get_invalid_user
    get '/users/invalid'
    assert_equal 404, last_response.status, 'No se respondio el código esperado 404'
  end

  # Prueba el servicio para crear un usuario.
  def test_post_user
    json_data = '{"id" : 7, "user": {"name":"juan", "last_name":"test", "document" : "123"}}'
    post '/users', json_data
    assert_equal 201, last_response.status, 'Código de respuesta incorrecto'
    assert_equal '/users/7', last_response.headers['Location'], 'El valor del header Location es incorrecto'
  end

  # Prueba la respuesta del servicio al tratar de crear un usuario inválido.
  def test_post_invalid_user
    json_data = '{"invalid" : "json"}'
    post '/users', json_data
    assert_equal 404, last_response.status, 'No se respondió el códido esperado 404'
  end

  # Prueba la respuesta del servicio al tratar de crear un usuario repetido.
  def test_post_duplicate_user
    json_data = '{"id" : 1, "user": {"name":"test", "last_name":"test 2", "document" : "456"}}'
    post '/users', json_data
    assert_equal 409, last_response.status, 'No se respondió el códido esperado 404'
  end

  # Prueba el servicio para actualizar un usuario.
  def test_put_user
    json_data = '{"name":"test", "last_name":"test", "document" : "098"}'
    put '/users/4', json_data
    assert_equal 204, last_response.status, 'Código de respuesta incorrecto'
  end

  # Prueba la respuesta del servicio al tratar de actualizar un usuario inválido.
  def test_put_invalid_user_id
    json_data = '{"name":"test", "last_name":"test", "document" : "098"}'
    put '/users/zzz', json_data
    assert_equal 404, last_response.status, 'No se respondió el código esperado 404'
  end

  # Prueba el servicio para eliminar un usuario.
  def test_delete_user
    delete '/users/2'
    data = JSON.parse last_response.body

    assert_equal 'Daniel', data['name'], 'Propiedad name incorrecta'
    assert_equal 'Arbelaez', data['last_name'], 'Propiedad last_name incorrecta'
    assert_equal '1094673845', data['document'], 'propiedad document incorrecta'
  end

  # Prueba la respuesta del servicio al tratar de eliminar un usuario inválido.
  def test_delete_invalid_user
    delete '/users/invalid'
    assert_equal 404, last_response.status, 'No se respondió el código esperado 404'
  end

end