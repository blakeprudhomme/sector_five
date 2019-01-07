require 'gosu'
require_relative 'player'
require_relative 'bullet'
require_relative 'enemy'
require_relative 'explosion'

WIDTH = 800
HEIGHT = 600
ENEMY_FREQUENCY = 0.05

TEXT = {
  caption: 'Sector Five'
}.freeze

# Sector Five Game
class SectorFive < Gosu::Window
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = TEXT[:caption]
    @player = Player.new(self)
    @enemies = []
    @bullets = []
    @explosions = []
  end

  def draw
    @player.draw
    @enemies.each(&:draw)
    @bullets.each(&:draw)
    @explosions.each(&:draw)
  end

  def update
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move
    @enemies.push Enemy.new(self) if rand < ENEMY_FREQUENCY
    @enemies.each(&:move)
    @bullets.each(&:move)
    detect_collisions
  end

  def button_down(id)
    if id == Gosu::KbSpace
      @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
    end
  end

  private

  def detect_collisions
    @enemies.dup.each do |enemy|
      @bullets.dup.each do |bullet|
        distance = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y)
        if distance < enemy.radius + bullet.radius
          @enemies.delete(enemy)
          @bullets.delete(bullet)
          @explosions.push Explosion.new(self, enemy.x, enemy.y)
        end
      end
    end
    @explosions.dup.each do |explosion|
      @explosions.delete explosion if explosion.finished
    end
    @enemies.dup.each do |enemy|
      @enemies.delete enemy if enemy.y > HEIGHT + enemy.radius
    end
    @bullets.dup.each do |bullet|
      @bullets.delete bullet unless bullet.onscreen?
    end
  end
end

window = SectorFive.new
window.show
