# frozen_string_literal: true

class ServersControllerTest < ActionDispatch::IntegrationTest
  test 'api/v1/servers return the list of all servers in xml format with post request' do
      server = Server.create!(url: 'https://test-1.example.com/bigbluebutton/api/', secret: 'test-1')
      Api::V1::ServersController.stub_any_instance(:verify_checksum, nil) do
        post("/api/v1/servers")
      end

      servers_hash = {
        server.id => {
          "id" => server.id,
          "url" => server.url,
          "secret" => server.secret,
          "state" => server&.state,
          "enabled/disabled" => server&.enabled ? 'enabled' : 'disabled',
          "load" => server.load.presence || 'unavailable',
          "load_multiplier" => server.load_multiplier.nil? ? 1.0 : server.load_multiplier.to_d,
          "online/offline" => server.online ? 'online' : 'offline'
        }
      }

      assert_equal response.body, servers_hash.to_xml
      server.destroy
  end

  test 'api/v1/servers return the list of all servers in json format with post request' do
    server = Server.create!(url: 'https://test-1.example.com/bigbluebutton/api/', secret: 'test-1')
    Api::V1::ServersController.stub_any_instance(:verify_checksum, nil) do
      post("/api/v1/servers.json")
    end
    json_response = JSON.parse(@response.body)
    servers_hash = {
      server.id => {
        "id" => server.id,
        "url" => server.url,
        "secret" => server.secret,
        "state" => server&.state,
        "enabled/disabled" => server&.enabled ? 'enabled' : 'disabled',
        "load" => server.load.presence || 'unavailable',
        "load_multiplier" => server.load_multiplier.nil? ? 1.0 : server.load_multiplier.to_d,
        "online/offline" => server.online ? 'online' : 'offline'
      }
    }
    assert_equal json_response, servers_hash
    server.destroy
  end

  test 'api/v1/servers return the list of all servers in xml format with get request' do
    server = Server.create!(url: 'https://test-1.example.com/bigbluebutton/api/', secret: 'test-1')
    Api::V1::ServersController.stub_any_instance(:verify_checksum, nil) do
      get("/api/v1/servers")
    end

    servers_hash = {
      server.id => {
        "id" => server.id,
        "url" => server.url,
        "secret" => server.secret,
        "state" => server&.state,
        "enabled/disabled" => server&.enabled ? 'enabled' : 'disabled',
        "load" => server.load.presence || 'unavailable',
        "load_multiplier" => server.load_multiplier.nil? ? 1.0 : server.load_multiplier.to_d,
        "online/offline" => server.online ? 'online' : 'offline'
      }
    }

    assert_equal response.body, servers_hash.to_xml
    server.destroy
  end
end
