#coding: utf-8
module NoiteHoje
  module Users
    def create_new_account user_hash
      p user_hash

      new_user = api_helper.new_user(
        first_name: user_hash[:name].split.first,
        last_name: user_hash[:name].split[1..-1].join(' '),
        email: user_hash[:email],
        provider: 'facebook',
        uid: user_hash[:uid],
        token: user_hash[:token],
        image: user_hash[:image])

      if new_user['error'].present?
        flash[:error] = 'Desculpe, ocorreu um erro ao criar a sua conta.'
        #TODO: Log the error
        return
      end

      # signin existing user
      # in the session his user id and the service id used for signing in is stored
      session[:user_id] = new_user['id']
      session[:service] = 'facebook'
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
        set_authhash_value :token,    omniauth['credentials']['token']
      elsif service == 'foursquare'
        set_authhash_value :email,    omniauth['extra']['user_hash']['contact']['email']
        set_authhash_value :name,     omniauth['user_info']['name']
        set_authhash_value :uid,      omniauth['extra']['user_hash']['id']
        set_authhash_value :phone,    omniauth['extra']['user_hash']['phone']
        set_authhash_value :provider, omniauth['provider']
        # Skittles.configure do |config|
        #   config.access_token =       omniauth['credentials']['token'] if ENV["RACK_ENV"] != "test"
        # end
      elsif service == 'twitter'
        set_authhash_value :email,    omniauth['user_info']['email']
        set_authhash_value :name,     omniauth['user_info']['name']
        set_authhash_value :uid,      omniauth['uid']
        set_authhash_value :provider, omniauth['provider']
        # Twitter.configure do |config|
        #   config.oauth_token =        omniauth['credentials']['token']
        #   config.oauth_token_secret = omniauth['credentials']['secret']
        # end
      else
        # debug to output the hash that has been returned when adding new services
        puts "Invalid service in hash received: #{omniauth.to_yaml}"
      end
    end

    def set_authhash_value key, value
      @authhash[key] = value.present? ? value.to_s : ""
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
