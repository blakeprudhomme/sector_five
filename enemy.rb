# A cpu controlled ship
class Enemy
  SPEED = 4
  IMAGE_RADIUS = 20

  attr_reader :x, :y, :radius

  def initialize(window)
    @image = Gosu::Image.new('images/enemy.png')
    @radius = IMAGE_RADIUS
    @x = rand(window.width - 2 * @radius) + @radius
    @y = 0
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end

  def move
    @y += SPEED
  end
end
