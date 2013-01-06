#coding: utf-8

module NoiteHoje
  class Home < Sinatra::Base
    set :views, 'views/home'
    helpers Sinatra::NoiteHoje::Helpers

    use Rack::MobileDetect

    get '/home' do
      @team = [
        {
          name: 'Felipe Lima',
          role: 'iOS & Backend Developer',
          twitter: 'felipecsl',
          github: 'felipecsl'
        },{
          name: 'Otávio Cordeiro',
          role: 'iOS Developer',
          twitter: 'otaviocc',
          github: 'otaviocc'
        },{
          name: 'Leo Tartari',
          role: 'Designer & Frontend Developer',
          twitter: 'leotartari',
          github: 'ltartari'
        },{
          name: 'Ico Portela',
          role: 'Designer',
          twitter: 'icoportela',
          github: ''
        },{
          name: 'Lúcio Maciel',
          role: 'Android Developer',
          twitter: 'luciofm',
          github: 'luciofm'
        },{
          name: 'Vitor Baptista',
          role: 'Backend Developer',
          twitter: 'vitorbaptista',
          github: 'vitorbaptista'
        }
      ].sort_by { |team| team[:name]}
      slim :index
    end
    def photo(name)
      name_to_slug = name.gsub(' ', '-').gsub('á', 'a').gsub('ú','u').downcase 
      "<img src='images/home/team/#{name_to_slug}.jpg'>"
    end
    def github_link(username)
      "<a href='http://github.com/#{username}' target='_blank'></a>"
    end
    def twitter_link(username)
      "<a href='http://twitter.com/#{username}' target='_blank'></a>"
    end
  end
end
