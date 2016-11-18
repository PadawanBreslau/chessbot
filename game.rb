require 'redis'
require 'philio_uci'

class Game
  FEN_START = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
  ENGINE_OPTIONS =  {:engine_path => 'engine/stockfish_8_x64' , :movetime => 2000}

  class << self

    def execute_move(start_field, finish_field, user_id)
      engine = PhilioUCI::Engine.new(ENGINE_OPTIONS)
      last_move = get_new_position(engine, user_id, start_field, finish_field) 
    end


    def get_new_position(engine, user_id, start_field, finish_field)
      old_moves = get_moves_from_storage(user_id) || ''
      current_moves = old_moves + " #{start_field}#{finish_field}"
      engine.send_command('uci')
      engine.send_command('position', "startpos moves #{current_moves}")
      engine.send_command('go', 'infinite')
      sleep 5
      result = engine.send_command('stop')
      parsed_result = PhilioUCI::DataParser.parse_eval_strings result.select{|res| res.match('seldepth')}
      computer_move = parsed_result.fetch parsed_result.keys.last
      new_moves = current_moves + " #{computer_move[:variation][0..3]}"
      store_moves(user_id, new_moves)
      computer_move
    end

    def resign(user_id)
      @redis ||= Redis.new
      @redis.del("Move::#{user_id}")
    end

    def store_moves(user_id, moves)
      @redis ||= Redis.new
      @redis.set("Move::#{user_id}", moves)
    end

    def get_moves_from_storage(user_id)
      @redis ||= Redis.new
      @redis.get("Move::#{user_id}")
    end
  end
end
