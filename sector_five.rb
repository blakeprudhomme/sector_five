require 'gosu'

WIDTH = 800
HEIGHT = 600

TEXT = {
  caption: 'Sector Five',
}.freeze

class SectorFive < Gosu::Window
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = TEXT[:caption]
  end
end

window = SectorFive.new
window.show
