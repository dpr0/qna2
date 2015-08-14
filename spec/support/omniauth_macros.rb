# in spec/support/omniauth_macros.rb
module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new('provider' => 'vkontakte',
                                                                   'uid' => '999999999',
                                                                   'info' => {
                                                                     'name' => 'mockuser',
                                                                     'email' => 'testvk@mail.com'
                                                                   },
                                                                   'credentials' => {
                                                                     'token' => 'mock_token',
                                                                     'secret' => 'mock_secret'
                                                                   })
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new('provider' => 'facebook',
                                                                  'uid' => '999999',
                                                                  'info' => {
                                                                    'name' => 'mockuser',
                                                                    'email' => 'testfb@mail.com'
                                                                  })
  end
end
