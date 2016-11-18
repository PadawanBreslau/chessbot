class Game
  def initialize(init_position = nil)
    @position = generate_initial_position(init_position)
    store_position
  end

  def execute_move(start_field, finish_field)
    get_position_from_storage
    
    store_position
  end


  private

  def generate_initial_position position
  end

  def store_position
  end

  def get_position_from_store
  end
end
