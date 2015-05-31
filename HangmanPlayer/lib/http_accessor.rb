require 'rest-client'
require 'json'
require_relative './process_support.rb'

class HttpAccessor
  include ProcessSupport
  attr_reader :actions, :player_id
  attr_accessor :session_id

  def initialize player_id, base_url, actions
    @player_id = player_id
    @base_url = base_url
    @actions = actions
  end

  def post action, data
    response_body = {}
    process action do
      response = RestClient.post(@base_url, data,
                                :content_type => :json,
                                :accept => :json)
      response_body = parse response.body
    end
    response_body
  end

  def json_for h = {}
    h.to_json
  end

  def post_for param_hash = {}
    post param_hash[:action], json_for(param_hash.merge sessionId: @session_id)
  end

  def set_session_id
    action = @actions["start_game"]
    response_body = post action, json_for(action: action, playerId: @player_id)
    @session_id = response_body["sessionId"]
    response_body
  end

  def get_next_word
    post_for action: @actions["next_word"]
  end

  def post_guessed_char_of c
    post_for action: @actions["guess_word"], guess: c.upcase
  end

  def get_result
    post_for action: @actions["get_result"]
  end

  def submit_result
    post_for action: @actions["submit_result"]
  end

end
