require 'gosu'
require_relative 'player'

WIDTH = 800
HEIGHT = 600

TEXT = {
  caption: 'Sector Five'
}.freeze

# Sector Five Game
class SectorFive < Gosu::Window
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = TEXT[:caption]
    @player = Player.new(self)
  end

  def draw
    @player.draw
  end

  def update
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move
  end
end

window = SectorFive.new
window.show
