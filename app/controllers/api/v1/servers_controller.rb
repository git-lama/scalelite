# frozen_string_literal: true

module Api
  module V1
    class ServersController < ApplicationController
      include ApiHelper

      # before_action :verify_checksum

      def index
        respond_to do |format|
          if servers_hash.empty?
            format.json { render json: { errors: 'No servers are configured' }, status: :not_found }
            format.xml  { render xml: { errors: 'No servers are configured' }, status: :not_found }
          else
            format.json { render json: servers_hash.to_json, status: :ok }
            format.xml  { render xml: servers_hash, status: :ok }
          end
        end
      end

      private

      def permitted_params
        params.permit(:format)
      end

      def servers_hash
        servers_list = Server.all
        servers_hash = {}

        unless servers_list.empty?
          servers_list.each do |server|
            servers_hash[server.id] = {
              id: server.id,
              url: server.url,
              secret: server.secret,
              state: server&.state,
              "enabled/disabled": server&.enabled ? 'enabled' : 'disabled',
              load: server.load.presence || 'unavailable',
              load_multiplier: server.load_multiplier.nil? ? 1.0 : server.load_multiplier.to_d,
              "online/offline": server.online ? 'online' : 'offline'
            }
          end
        end

        servers_hash
      end
    end
  end
end
