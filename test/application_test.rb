require_relative 'test_helper'

class TestApp < Feet::Application
end

class FeetTestApp < Minitest::Test
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get '/'

    assert last_response.ok?
    body = last_response.body
    p body
    p last_response
    assert body['Hello']
  end

  def test_path
    get '/path'

    assert !last_response.ok?
    p last_response
  end
