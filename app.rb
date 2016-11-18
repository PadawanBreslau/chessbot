require 'sinatra'
require 'json'
require './game'


# token,team_id,team_domain,service_id,channel_id,channel_name,timestamp,user_id,user_name,text,trigger_word
post '/gateway' do
  user_name = params[:user_name]
  user_id = params[:user_id]
  message = params[:text]
  action, *action_params = message.split(' ')
  case action
  #when 'start'
  when 'move'
    handle_move_message(action_params, user_id)

  when 'help'
    handle_help_messages(action_params, user_name)
  end

end


def respond_message message
  content_type :json
  {:text => message}.to_json
end

#######
## Supported formats
#  e2 e4 ; e2-e4 ; Sf3 e5 ; Sf3-e5 ;
def parse_move_params params
  params = params.split('-') if params.size == '1' && params.first.include?('-')
  params
end


def handle_move_message(params, user_id)
  start_move, finish_move = parse_move_params(params)
  validate_move_valid?(start_move, finish_move)
  answer = execute_move(start_move, finish_move, user_id)[:variation][0..3]
 
  respond_message answer
end


def handle_help_messages(params, user_name)
  if params.empty?
    help_msg = ""
    help_msg << "Glad you asked: #{user_name}. Avaliable commands: start move eval resign draw"
    respond_message help_msg
  else
    help_msg = ""
    case params.first
    when 'move'
      help_msg << "Syntax:  move MOVE_VALUE. "
      help_msg << "Available MOVE_VALUE syntax: e2-e4 ; e2 e4 ; Sf3 e5 ; Sf3-e5"
      respond_message help_msg
    when 'eval' , 'resign', 'draw'
      help_msg << "No parameter required"
      respond_message help_msg
    end
  end
end

def validate_move_valid?(start_field, finish_field)
  true
  #TODO raise error and return
end

def execute_move(start_field, finish_field, user_id)
  Game.execute_move(start_field, finish_field, user_id)
  #TODO raise error and return
end


