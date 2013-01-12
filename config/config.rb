# coding: utf-8
module NoiteHoje
  class Config
    attr_reader :api_key, :supported_cities

    def initialize
      @api_key = API_KEY
      @supported_cities = []
      add_supported_cities "Porto Alegre", "São Paulo", "Rio de Janeiro", "Belo Horizonte", "Curitiba", "Florianópolis"
    end

   private
    def add_supported_cities *cities
      cities.each do |c|
        @supported_cities << {
          name: c,
          parameter: c.parameterize
        }
      end
    end
  end
end
