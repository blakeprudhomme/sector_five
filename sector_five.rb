require 'gosu'
require_relative 'player'
require_relative 'enemy'

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
  end

  def draw
    @player.draw
    @enemies.each(&:draw)
  end

  def update
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move
    @enemies.push Enemy.new(self) if rand < ENEMY_FREQUENCY
    @enemies.each(&:move)
  end
end

window = SectorFive.new
window.show
