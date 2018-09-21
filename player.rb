# A player controlled ship
class Player
  ROTATION_SPEED = 6
  ACCELERATION = 2
  FRICTION = 0.9
  IMAGE_RADIUS = 20
  IMAGE_WIDTH = 27

  attr_reader :x, :y, :angle, :radius

  def initialize(window)
    @window = window
    @x = center_x
    @y = window.height - 100
    @angle = @velocity_x = @velocity_y = 0
    @image = Gosu::Image.new('images/ship.png')
    @radius = IMAGE_RADIUS
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  def turn_right
    @angle += ROTATION_SPEED
  end

  def turn_left
    @angle -= ROTATION_SPEED
  end

  def accelerate
    @velocity_x += Gosu.offset_x(@angle, ACCELERATION)
    @velocity_y += Gosu.offset_y(@angle, ACCELERATION)
  end

  def move
    @x += @velocity_x
    @y += @velocity_y
    @velocity_x *= FRICTION
    @velocity_y *= FRICTION
    set_right_boundry
    set_left_boundry
    set_bottom_boundry
  end

  private

  def center_x
    (@window.width / 2) - (IMAGE_WIDTH / 2)
  end

  def set_right_boundry
    return unless @x > (@window.width - @radius)
    @velocity_x = 0
    @x = @window.width - @radius
  end

  def set_left_boundry
    return unless @x < @radius
    @velocity_x = 0
    @x = @radius
  end

  def set_bottom_boundry
    return unless @y > (@window.height - @radius)
    @velocity_y = 0
    @y = @window.height - @radius
  end
end
