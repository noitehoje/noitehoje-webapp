#coding: utf-8

module NoiteHoje
  class Services < Sinatra::Base
    set :views, 'views/services'
    helpers Sinatra::NoiteHoje::Helpers
    use HoptoadNotifier::Rack if ENV['RACK_ENV'] != 'development'

    get '/services' do
      redirect '/signin' unless current_user
      @services = current_user.services.order('provider asc')
      slim :index
    end

    get '/signin' do
      slim :signin
    end

    # POST to remove an authentication service
    post '/services/destroy' do
      # remove an authentication service linked to the current user
      @service = current_user.services.find(params[:id])

      if session[:service_id] == @service.id
        flash[:error] = 'You are currently signed in with this account!'
      else
        @service.destroy
      end

      redirect '/services'
    end

    # Sign out current user
    get '/signout' do
      if current_user
        session[:user_id] = nil
        session[:service_id] = nil
        session.delete :user_id
        session.delete :service_id
        flash[:notice] = 'You have been signed out!'
      end
      redirect '/'
    end

    get '/auth/:service/callback' do
      # get the service parameter from the Rails router
      params[:service] ? service_route = params[:service] : service_route = 'No service recognized (invalid callback)'

      # get the full hash from omniauth
      omniauth = request.env['omniauth.auth']

      # continue only if hash and parameter exist
      if omniauth and params[:service]
        # map the returned hashes to our variables first - the hashes differs for every service

        # create a new hash
        @authhash = Hash.new

        if ['facebook'].index(service_route) != nil
          set_authhash_value :email,    omniauth['extra']['user_hash']['email']
          set_authhash_value :name,     omniauth['extra']['user_hash']['name']
          set_authhash_value :uid,      omniauth['extra']['user_hash']['id']
          set_authhash_value :image,    omniauth['extra']['user_hash']['image']
          set_authhash_value :provider, omniauth['provider']
        elsif ['foursquare'].index(service_route) != nil
          set_authhash_value :email,    omniauth['extra']['user_hash']['contact']['email']
          set_authhash_value :name,     omniauth['user_info']['name']
          set_authhash_value :uid,      omniauth['extra']['user_hash']['id']
          set_authhash_value :phone,    omniauth['extra']['user_hash']['phone']
          set_authhash_value :provider, omniauth['provider']
          # set the oauth2 access token to Skittles
          Skittles.configure { |config| config.access_token = omniauth['credentials']['token'] } if ENV["RACK_ENV"] != "test"
        # elsif service_route == 'github'
        #   omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        #   omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        #   omniauth['extra']['user_hash']['id'] ? @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
        #   omniauth['provider'] ? @authhash[:provider] =  omniauth['provider'] : @authhash[:provider] = ''
        elsif ['twitter'].index(service_route) != nil
          omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
          omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
          omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
          omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
        else
          # debug to output the hash that has been returned when adding new services
          render :text => omniauth.to_yaml
          return
        end

        if @authhash[:uid] != '' and @authhash[:provider] != ''

          auth = Service.where(provider: @authhash[:provider], uid: @authhash[:uid]).first

          # if the user is currently signed in, he/she might want to add another account to signin
          if user_signed_in?
            if auth
              flash[:notice] = 'Your account at ' + @authhash[:provider].capitalize + ' is already connected with this site.'
              redirect '/services'
            else
              current_user.services.create!(
                provider: @authhash[:provider],
                uid: @authhash[:uid],
                uname: @authhash[:name],
                uemail: @authhash[:email])
              flash[:notice] = 'Your ' + @authhash[:provider].capitalize + ' account has been added for signing in at this site.'
              redirect '/services'
            end
          else
            if auth
              # signin existing user
              # in the session his user id and the service id used for signing in is stored
              session[:user_id] = auth.user.id
              session[:service_id] = auth.id

              flash[:notice] = 'Signed in successfully via ' + @authhash[:provider].capitalize + '.'
              redirect '/'
            else
              # this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
              create_new_account
              redirect '/'
            end
          end
        else
          flash[:error] =  'Error while authenticating via ' + service_route + '/' + @authhash[:provider].capitalize + '. The service returned invalid data for the user id.'
          redirect '/signin'
        end
      else
        flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '. The service did not return valid data.'
        redirect '/signin'
      end
    end

    # callback: failure
    get '/auth/failure' do
      flash[:error] = 'There was an error at the remote authentication service. You have not been signed in.'
      redirect '/'
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

    def set_authhash_value key, value
      @authhash[key] = value.present? ? value.to_s : ""
    end

    def create_new_account
      @newuser = User.new(
        name: @authhash[:name],
        email: @authhash[:email],
        phone: @authhash[:phone],
        image: @authhash[:image])

      unless @newuser.save
        flash[:error] = 'This is embarrassing! There was an error while creating your account from which we were not able to recover.'
        return
      end

      @newuser.services << Service.new(
        provider: @authhash[:provider],
        uid: @authhash[:uid],
        uname: @authhash[:name],
        uemail: @authhash[:email])

      @newuser.save
      # signin existing user
      # in the session his user id and the service id used for signing in is stored
      session[:user_id] = @newuser.id
      session[:service_id] = @newuser.services.first.id

      flash[:notice] = 'Your account has been created and you have been signed in!'
    end
  end
end
