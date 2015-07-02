require "grape-swagger-rails/engine"

module GrapeSwaggerRails
  class Options < OpenStruct
    def before_filter(&block)
      if block_given?
        self.before_filter_proc = block
      else
        self.before_filter_proc
      end
    end
  end

  mattr_accessor :options

  self.options = Options.new(

    url:                  '/swagger_doc',
    app_name:             'Swagger',
    app_url:              'http://swagger.wordnik.com',
    app_description:      nil,
    hide_base_url:        false,
    
    headers:              {},

    styles:               {},
    
    api_auth:             '',        # 'basic'
    api_key_name:         'api_key', # 'Authorization'
    api_key_type:         'query',   # 'header'
    api_app_id_name:      'app_id',  # 'Application ID'
    api_app_id_type:      'header',

    authentication_proc:  nil # Proc used as a controller before filter that returns a boolean
  )

end
