require "grape-swagger-rails/engine"

module GrapeSwaggerRails
  class Options < Struct.new(:url, :api_key_name, :api_key_type, :api_auth, :headers, :app_name, :app_url, :app_description, :authentication_proc, :hide_base_url)
    def authenticate_with(&block)
      self.authentication_proc = block
    end
  end
  
  mattr_accessor :options
  
  self.options = Options.new(
    
    url:                  '/swagger_doc.json',
    app_name:             'Swagger',
    app_url:              'http://swagger.wordnik.com',
    app_description:      nil,
    hide_base_url:        false,
    
    headers:              {},
    
    api_auth:             '',        # 'basic'
    api_key_name:         'api_key', # 'Authorization'
    api_key_type:         'query',   # 'header'
    
    authentication_proc:  nil # Proc used as a controller before filter that returns a boolean
  )
  
end

