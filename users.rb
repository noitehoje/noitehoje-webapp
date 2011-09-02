module NoiteHoje
  module Users
    def add_user_service options
    end

    def create_new_account user_hash
      @newuser = User.new(
        name: user_hash[:name],
        email: user_hash[:email],
        phone: user_hash[:phone],
        image: user_hash[:image])

      unless @newuser.save
        flash[:error] = 'Desculpe, ocorreu um erro ao criar a sua conta.'
        return
      end

      @newuser.services << Service.new(
        provider: user_hash[:provider],
        uid: user_hash[:uid],
        uname: user_hash[:name],
        uemail: user_hash[:email])

      @newuser.save
      # signin existing user
      # in the session his user id and the service id used for signing in is stored
      session[:user_id] = @newuser.id
      session[:service_id] = @newuser.services.first.id
    end

    def create_authhash omniauth, service
      # create a new hash
      @authhash = Hash.new

      if service == 'facebook'
        set_authhash_value :email,    omniauth['extra']['user_hash']['email']
        set_authhash_value :name,     omniauth['extra']['user_hash']['name']
        set_authhash_value :uid,      omniauth['extra']['user_hash']['id']
        set_authhash_value :image,    omniauth['extra']['user_hash']['image']
        set_authhash_value :provider, omniauth['provider']
      elsif service == 'foursquare'
        set_authhash_value :email,    omniauth['extra']['user_hash']['contact']['email']
        set_authhash_value :name,     omniauth['user_info']['name']
        set_authhash_value :uid,      omniauth['extra']['user_hash']['id']
        set_authhash_value :phone,    omniauth['extra']['user_hash']['phone']
        set_authhash_value :provider, omniauth['provider']
        Skittles.configure do |config|
          # set the oauth2 access token to Skittles
          config.access_token =       omniauth['credentials']['token'] if ENV["RACK_ENV"] != "test"
        end
      elsif service == 'twitter'
        set_authhash_value :email, omniauth['user_info']['email']
        set_authhash_value :name, omniauth['user_info']['name']
        set_authhash_value :uid, omniauth['uid']
        set_authhash_value :provider, omniauth['provider']
      else
        # debug to output the hash that has been returned when adding new services
        puts "Invalid service in hash received: #{omniauth.to_yaml}"
      end
    end

    def set_authhash_value key, value
      @authhash[key] = value.present? ? value.to_s : ""
    end

    def current_user
      @current_user ||= User.criteria.for_ids(session[:user_id]).first if session[:user_id]
    end

    def user_signed_in?
      return 1 if current_user
    end

    def authenticate_user!
      if !current_user
        flash[:error] = 'You need to sign in before accessing this page!'
        redirect '/signin'
      end
    end
  end
end
