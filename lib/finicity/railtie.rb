module Finicity
  class Railtie < ::Rails::Railtie

    config.finicity = ::Finicity.config

    initializer "finicity_configuration" do |app|
      if File.exists?(::Rails.root.join('config', 'finicity.yml'))

        yaml_file = ::YAML.load_file(::Rails.root.join('config', 'finicity.yml'))

        ::Finicity.configure do |config|
          config.base_url = yaml_file['base_url']
          config.partner_id = yaml_file['partner_id']
          config.partner_secret = yaml_file['partner_secret']
          config.app_key = yaml_file['app_key']
        end
      else
        ::Rails.logger.warn("Failed to load finicity.yml")
      end
    end
  end
end
