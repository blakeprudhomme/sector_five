require 'gosu'
require_relative 'player'
require_relative 'bullet'
require_relative 'enemy'
require_relative 'explosion'
require_relative 'credit'

WIDTH = 800
HEIGHT = 600
ENEMY_FREQUENCY = 0.05
MAX_ENEMIES = 100

TEXT = {
  caption: 'Sector Five'
}.freeze

# Sector Five Game
class SectorFive < Gosu::Window
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = TEXT[:caption]
    @background_image = Gosu::Image.new('images/start_screen.png')
    @scene = :start
    @start_music = Gosu::Song.new('sounds/Lost Frontier.ogg')
    @start_music.play(true)
  end

  def initialize_game
    @scene = :game
    @player = Player.new(self)
    @enemies = []
    @bullets = []
    @explosions = []
    @enemies_appeared = @enemies_destroyed = 0
    @start_music = Gosu::Song.new('sounds/Cephalopod.ogg')
    @start_music.play(true)
    @explosion_sound = Gosu::Sample.new('sounds/explosion.ogg')
    @shooting_sound = Gosu::Sample.new('sounds/shoot.ogg')
  end

  def initialize_end(fate)
    case fate
    when :count_reached
      @message = "You made it! You destroyed #{@enemies_destroyed} ships!"
      @message2 = "and #{MAX_ENEMIES - @enemies_destroyed} reached the base."
    when :hit_by_enemy
      @message = "You were struck by an enemy ship."
      @message2 = "Before your ship was destroyed, "
      @message2 += "you took out #{@enemies_destroyed} ships."
    when :off_top
      @message = "You got too close to the enemy mother ship."
      @message2 = "Before your ship was destroyed, "
      @message2 += "you took out #{@enemies_destroyed} ships."
    end
    @bottom_message = "Press P to again, or Q to quit."
    @message_font = Gosu::Font.new(28)
    @credits = []
    y = 700
    File.open('credits.txt'). each do |line|
      @credits.push(Credit.new(self, line.chomp, 100, y))
      y += 30
    end
    @scene = :end
    @end_music = Gosu::Song.new('sounds/FromHere.ogg')
    @end_music.play(true)
  end

  def draw
    case @scene
    when :start
      draw_start
    when :game
      draw_game
    when :end
      draw_end
    end
  end

  def draw_start
    @background_image.draw(0, 0, 0)
  end

  def draw_game
    @player.draw
    @enemies.each(&:draw)
    @bullets.each(&:draw)
    @explosions.each(&:draw)
  end

  def draw_end
    clip_to(50, 140, 700, 360) do
      @credits.each(&:draw)
    end
    draw_line(0, 140, Gosu::Color::RED, WIDTH, 140, Gosu::Color::RED)
    @message_font.draw_text(@message, 40, 40, 1, 1, 1, Gosu::Color::FUCHSIA)
    @message_font.draw_text(@message2, 40, 75, 1, 1, 1, Gosu::Color::FUCHSIA)
    draw_line(0, 500, Gosu::Color::RED, WIDTH, 500, Gosu::Color::RED)
    @message_font.draw_text(@bottom_message, 180, 540, 1, 1, 1, Gosu::Color::AQUA)
  end

  def update
    case @scene
    when :game
      update_game
    when :end
      update_end
    end
  end

  def update_game
    @player.turn_left if button_down?(Gosu::KbLeft)
    @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.move
    if rand < ENEMY_FREQUENCY
      @enemies.push Enemy.new(self)
      @enemies_appeared += 1
    end
    @enemies.each(&:move)
    @bullets.each(&:move)
    detect_collisions
  end

  def update_end
    @credits.each(&:move)
    @credits.each(&:reset) if @credits.last.y < 150
  end

  def button_down(id)
    case @scene
    when :start
      button_down_start(id)
    when :game
      button_down_game(id)
    when :end
      button_down_end(id)
    end
  end

  def button_down_start(_id)
    initialize_game
  end

  def button_down_game(id)
    return unless id == Gosu::KbSpace

    @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
    @shooting_sound.play(0.3)
  end

  def button_down_end(id)
    case id
    when Gosu::KbP
      initialize_game
    when Gosu::KbQ
      close
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
          @enemies_destroyed += 1
          @explosion_sound.play
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
    initialize_end(:count_reached) if @enemies_appeared > MAX_ENEMIES
    @enemies.each do |enemy|
      distance = Gosu.distance(enemy.x, enemy.y, @player.x, @player.y)
      initialize_end(:hit_by_enemy) if distance < @player.radius + enemy.radius
    end
    initialize_end(:off_top) if @player.y < -@player.radius
  end
end

window = SectorFive.new
window.show
