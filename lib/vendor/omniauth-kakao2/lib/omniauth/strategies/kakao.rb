require 'omniauth-oauth2'

# https://developers.kakao.com/docs/latest/ko/kakaologin/rest-api#req-user-info
module OmniAuth
  module Strategies
    class Kakao < OmniAuth::Strategies::OAuth2

      option :name, 'kakao'

      option :client_options, {
        :site => 'https://kauth.kakao.com',
        :authorize_path => 'https://kauth.kakao.com/oauth/authorize',
        :token_url => 'https://kauth.kakao.com/oauth/token',
      }

      uid { raw_info['id'].to_s }

      info do
        {
          'name' => raw_properties['nickname'],
          'image' => raw_properties['thumbnail_image'],
        }
      end

      extra do
        {'properties' => raw_properties}
      end

    private
      def raw_info
        @raw_info ||= access_token.get('https://kapi.kakao.com/v2/user/me', { 
          :property_keys=> ["kakao_account.email"]
        }).parsed || {}
      end

      def raw_properties
        @raw_properties ||= raw_info['properties']
      end
    end
  end
end

OmniAuth.config.add_camelization 'kakao', 'Kakao'
