# coding: utf-8
module NoiteHoje
  class Config
    attr_reader :api_keys, :supported_cities

    def initialize
      # 1. iPhone app key
      # 2. webapp key
      @api_keys = ['crEjew8r', 'saQ8jFnb']
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
