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
          github: 'felipecsl',
          linkedin: 'felipecsl'
        },{
          name: 'Otávio Cordeiro',
          role: 'iOS Developer',
          twitter: 'otaviocc',
          github: 'otaviocc',
          linkedin: 'otaviocc'
        },{
          name: 'Leo Tartari',
          role: 'Designer & Frontend Developer',
          twitter: 'leotartari',
          github: 'ltartari',
          linkedin: 'leotartari'
        },{
          name: 'Ico Portela',
          role: 'Designer',
          twitter: 'icoportela',
          github: '',
          linkedin: 'icoportela'
        },{
          name: 'Lúcio Maciel',
          role: 'Android Developer',
          twitter: 'luciofm',
          github: 'luciofm',
          linkedin: 'luciofm'
        },{
          name: 'Vitor Baptista',
          role: 'Backend Developer',
          twitter: 'vitorbaptista',
          github: 'vitorbaptista',
          linkedin: 'vitorbaptista'
        }
      ].sort_by { |team| team[:name]}
      @repos = [
        {
          name: 'iPhone',
          url: ''
        },{
          name: 'iPad',
          url: ''
        },{
          name: 'Web',
          url: ''
        },{
          name: 'Android',
          url: 'soon'
        },{
          name: 'Noite Hoje Gem',
          url: ''
        }
      ].sort_by {|repo| repo[:name]}
      slim :index
    end
    def photo(name)
      name_to_slug = name.gsub(' ', '-').gsub('á', 'a').gsub('ú','u').downcase 
      "<img src='images/home/team/#{name_to_slug}.jpg'>"
    end
    def github_link(username)
      "<a href='http://github.com/#{username}' target='_blank'>&#62208;</a>"
    end
    def twitter_link(username)
      "<a href='http://twitter.com/#{username}' target='_blank'>&#62217;</a>"
    end
    def linkedin_link(username)
      "<a href='http://www.linkedin.com/in/#{username}' target='_blank'>&#62232;</a>"
    end
  end
end
