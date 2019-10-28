require 'sinatra/base'

module Helpers

  def self.current_user(session_hash)
    @user = Scientist.find(session_hash[:scientist_id])
    @user
  end

  def self.is_logged_in?(session_hash)
    !!session_hash[:scientist_id]
  end

end
