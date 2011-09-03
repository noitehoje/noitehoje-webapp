#coding: utf-8

module Sinatra
  module NoiteHoje
    module Helpers
      def twitter_and_gravatar(username, email_address)
        "<a href='http://twitter.com/#{username}' rel='nofollow' target='_blank'><img src='http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email_address.downcase)}?s=24'>@#{username}</a>"
      end

      def admin?
        request.cookies[settings.username] == settings.token
      end

      def no_mobile!
        redirect to("/mobile") if request.env['X_MOBILE_DEVICE']
      end

      def protected!
        redirect to('/admin/login') unless admin?
      end

      def current_user
        @current_user ||= api_helper.user_details(session[:user_id]) if session[:user_id]
      end

      def current_user_avatar
        return "" unless current_user
        fb = current_user['services'].detect{|s| s['provider'] == 'facebook'}
        return "http://graph.facebook.com/#{fb['uid']}/picture" if fb
        twitter = current_user['services'].detect{|s| s['provider'] == 'twitter' }
        return "https://api.twitter.com/1/users/profile_image/#{twiter['uid']}" if twitter
      end

      def user_is_connected_to_service? provider
        return false unless user_signed_in?
        current_user['services'].detect {|s| s['provider'] == provider }
      end

      def user_signed_in?
        return 1 if current_user
      end

      def api_helper
        @api_helper ||= ApiHelper.new(::NoiteHoje::App.config.api_keys.first)
      end
    end
  end

  helpers NoiteHoje::Helpers
end
