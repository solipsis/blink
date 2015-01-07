require 'gosu'
require_relative 'player'
require_relative 'particle'
require_relative 'fpscounter'
require_relative 'emitter'

class GameWindow < Gosu::Window
	def initialize
		super 1280, 800, false
		self.caption = "blink"

		@player = Player.new(self)
		@player.blink(500,500)
		@mouse = MouseCursor.new(self)

		@particles = Array.new()
		#@particle_img = Gosu::Image.new(self, "circle_icon.png", false)
		@particle_img = Gosu::Image.new(self, "smallCircle.png", false)
		@fpsCounter = FPSCounter.new(self)
		@emitters = Array.new()
		#@particle_img = Gosu::Image.new(self, "cage.jpg", false)
		

	end

	def needs_cursor?
		true
	end

	def update
		if button_down? Gosu::MsLeft then
			@player.blink(mouse_x, mouse_y)
		#	create_splosion(mouse_x, mouse_y)
		end
		if button_down? Gosu::MsRight then
			createEmitter(mouse_x, mouse_y)
		end
		if button_down? Gosu::KbLeft then
			@player.move("left")
		end
		if button_down? Gosu::KbRight then
			@player.move("right")
		end
		if button_down? Gosu::KbUp then
			@player.move("up")
		end
		if button_down? Gosu::KbDown then
			@player.move("down")
		end

		@particles.each do |p|
			p.update
		end

		@emitters.each do |e|
			e.update
		end

		@fpsCounter.update


	end

	def create_splosion(x, y)
		5.times do 
			@particles.push(Particle.new(self, x, y, Random.rand(360), 1, @particle_img))
		end
	end

	def createEmitter(x, y)
		@emitters.push(Emitter.new(self, x, y, @particle_img))
	end

	def draw
		@player.draw
		@mouse.draw(mouse_x, mouse_y)
		@particles.each do |p|
			p.draw
		end
		@emitters.each do |e|
			e.draw
		end
		@fpsCounter.draw

	end
end

class MouseCursor
	def initialize(window)
		@img = Gosu::Image.new(window, "circle_icon.png", false)
		@delta_x = 0
		@delta_y = 0
		@prev_x = 0
		@prev_y = 0
	end

	def draw(x, y)
		@delta_x = (x - @prev_x) * 0.5
		@delta_y = (y - @prev_y) * 0.5
		@prev_x = x
		@prev_y = y
		@img.draw(x + @delta_x - 10, y + @delta_y - 10, 0)
		#@img.draw(x - 10,y - 10, 1)
	end
end

window = GameWindow.new
window.show
