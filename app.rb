require 'sinatra'
require 'json'
require './game'

post '/gateway' do
  user = params.keys.join(',')
  message = params[:text]
  action, *params = message.split(' ')
  case action
  when 'start'
    @game = Game.new
  when 'move'
    handle_move_message(params)

  when 'help'
    handle_help_messages(params, user)
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


def handle_move_message params
  return respond_message 'You need to start the game first' unless @game
  start_move, finish_move = parse_move_params(params)
  validate_move_valid?(start_move, finish_move)
  execute_move(start_move, finish_move)
  answer = prepare_answer
 
  respond_message answer
end


def handle_help_messages params, user
  if params.empty?
    help_msg = ""
    help_msg << "Glad you asked: #{user}. Avaliable commands: start move eval resign draw"
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

def execute_move(start_field, finish_field)
  true
  # @game.execute_move(start_field, finish_field)
  #TODO raise error and return
end

def prepare_answer
  'e7-e5'
end

