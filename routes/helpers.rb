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
        @current_user ||= User.criteria.for_ids(session[:user_id]).first if session[:user_id]
      end

      def current_user_avatar
        return "" unless current_user
        fb = current_user.services.detect{|s|s.provider == 'facebook'}
        return "http://graph.facebook.com/#{fb.uid}/picture" if fb
        twitter = current_user.services.detect{|tw| tw.provider == 'twitter' }
        return "https://api.twitter.com/1/users/profile_image/#{twiter.uid}" if twitter
      end

      def user_signed_in?
        return 1 if current_user
      end

      def facebook_connect!
        puts "cookies: #{request.cookies}"
        fb_cookie = request.cookies["fbs_#{FACEBOOK_APP_ID}"]
        return unless fb_cookie

        fb_cookie = fb_cookie[1..-1].chop # remove extra quotes

        fb_data = CGI.parse fb_cookie
        uid = fb_data["uid"].first
        token = URI.escape fb_data["access_token"].first
        result = User.criteria.where(:facebook_id => uid)

        if result.any?
          # Returning user. Just sign in back
          @user = result.first if result.any?
          return @user
        end

        # New user. Authenticate him.
        graph_url = "https://graph.facebook.com/#{uid}?access_token=#{token}"
        json = Net::HTTP.get_json graph_url

        new_user = User.new(
          name: json["name"],
          email: json["email"],
          facebook_id: json["id"])

        puts "Failed to create user with id #{json["id"]}" unless new_user.save
        @user = new_user
      end
    end
  end

  helpers NoiteHoje::Helpers
end
