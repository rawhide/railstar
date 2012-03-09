require 'rails/source_annotation_extractor'
module Railstar
  class GeneralController < ApplicationController
    layout "railstar/application"

    def index
    end

    def database
      @connection = ActiveRecord::Base.connection
      @tables = @connection.tables.sort
      @tables.delete "schema_migrations"

      @cols = %w(name human_name sql_type klass default type null)
    end

    def routes
      Rails.application.reload_routes!
      @routes = Rails.application.routes.routes
    end
  end
end
