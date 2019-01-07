# Bullets fired by the player
class Bullet
  SPEED = 5

  attr_reader :x, :y, :radius

  def initialize(window, x, y, angle)
    @window = window
    @x = x
    @y = y
    @direction = angle
    @radius = 3
    @image = Gosu::Image.new('images/bullet.png')
  end

  def draw
    @image.draw(@x - @radius, @y - @radius, 1)
  end

  def move
    @x += Gosu.offset_x(@direction, SPEED)
    @y += Gosu.offset_y(@direction, SPEED)
  end

  def onscreen?
    right = @window.width + radius
    left = -@radius
    top = -@radius
    bottom = @window.height + radius
    @x > left && @x < right && @y > top && @y < bottom
  end
end
