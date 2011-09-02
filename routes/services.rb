#coding: utf-8

module NoiteHoje
  class Services < Sinatra::Base
    set :views, 'views/services'
    helpers Sinatra::NoiteHoje::Helpers
    use HoptoadNotifier::Rack if ENV['RACK_ENV'] != 'development'
    include NoiteHoje::Users

    get '/services' do
      redirect '/signin' unless current_user
      @services = current_user['services'].sort_by{|s| s['provider'] }
      slim :index
    end

    get '/signin' do
      slim :signin
    end

    # POST to remove an authentication service
    post '/services/destroy' do
      # remove an authentication service linked to the current user
      @service = current_user['services'].detect{|s| s['_id'] == params[:id] }

      if session[:service_id] == @service['id']
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
      service_route = params[:service] || 'No service recognized (invalid callback)'
      omniauth = request.env['omniauth.auth']

      # continue only if hash and parameter exist
      if !omniauth || !params[:service]
        flash[:error] = "Ocorreu um erro autenticando via #{service_route.capitalize}. O serviço retornou dados inválidos."
        redirect '/signin'
      end

      create_authhash omniauth, service_route

      if @authhash[:uid].blank? || @authhash[:provider].blank?
        flash[:error] =  "Ocorreu um erro autenticando via #{service_route}/#{@authhash[:provider].capitalize}. O serviço retornou dados inválidos."
        redirect '/signin'
      end

      existing_user = api_helper.user_by_service @authhash[:provider], @authhash[:uid]

      # if the user is currently signed in, he/she might want to add another account to signin
      if user_signed_in?
        if existing_user['_id']
          flash[:notice] = "Sua conta #{@authhash[:provider].capitalize} já está conectada ao Noite Hoje."
        else
          api_helper.add_service(
            current_user['_id'], {
              provider: @authhash[:provider],
              uid: @authhash[:uid],
              uname: @authhash[:name],
              uemail: @authhash[:email]
            })

          flash[:notice] = "Sua conta #{@authhash[:provider].capitalize} foi adicionada com sucesso."
        end

        redirect '/services'
      else
        if existing_user['_id']
          # signin existing user
          # in the session his user id and the service id used for signing in is stored
          existing_service = existing_user['services'].detect{|s| s['provider'] == @authhash[:provider] }
          session[:user_id] = existing_user['_id']
          session[:service_id] = existing_service['_id']

          flash[:notice] = "Você entrou utilizando o serviço #{@authhash[:provider].capitalize}."
        else
          # this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
          create_new_account @authhash

          flash[:notice] = 'Sua conta foi criada com sucesso!'
        end

        redirect '/'
      end
    end

    # callback: failure
    get '/auth/failure' do
      flash[:error] = 'There was an error at the remote authentication service. You have not been signed in.'
      redirect '/'
    end
  end
end
