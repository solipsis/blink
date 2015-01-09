require 'gosu'
#require 'fidget'
require_relative 'player'
require_relative 'particle'
require_relative 'fpscounter'
require_relative 'emitter'


Struct.new("Attribute", :name, :value, :min, :max)

class GameWindow < Gosu::Window
	def initialize
		super 1280, 800, false
		self.caption = "blink"

		@player = Player.new(self)
		@player.blink(500,500)
		@mouse = MouseCursor.new(self)

		@particles = Array.new()
		#@particle_img = Gosu::Image.new(self, "circle_icon.png", false)
		#@particle_img = Gosu::Image.new(self, "verySmallCircle.png", false)
		@particle_img = Gosu::Image.new(self, "smallCircle.png", false)
		@fpsCounter = FPSCounter.new(self)
		@emitters = Array.new()
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
		@totalParticles = 0
		#@particle_img = Gosu::Image.new(self, "cage.jpg", false)
		
		initEmitterAttributes()
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
			createEmitter(mouse_x, mouse_y, @emitterAttributes)
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
		if button_down? Gosu::KbSpace then
			@emitters.clear()
		end

		@particles.each do |p|
			p.update
		end

		@totalParticles = 0
		@emitters.each do |e|
			e.update
			@totalParticles += e.particleCount
		end


		@fpsCounter.update
	end

	def create_splosion(x, y)
		5.times do 
			@particles.push(Particle.new(self, x, y, Random.rand(360), 1, @particle_img))
		end
	end

	def createEmitter(x, y, emitterAttributes)
		@emitters.push(Emitter.new(x, y, @particle_img) do
				self.speed = emitterAttributes["speed"].value
				self.totalParticles = emitterAttributes["totalParticles"].value
				self.red = emitterAttributes["red"].value
				self.blue = emitterAttributes["blue"].value
				self.green = emitterAttributes["green"].value
				self.redVariance = emitterAttributes["red_var"].value
				self.blueVariance = emitterAttributes["blue_var"].value
				self.greenVariance = emitterAttributes["green_var"].value
				self.life = emitterAttributes["life"].value
				self.lifeVariance = emitterAttributes["life_var"].value
				self.angle = emitterAttributes["angle"].value
				self.angleVariance = emitterAttributes["angle_var"].value
				self.emissionRate = emitterAttributes["rate"].value
			end
		)
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
		@font.draw("Total Particles: " + @totalParticles.to_s, 0, 30, 20)

	end


	def initEmitterAttributes
		@emitterAttributes = Hash.new()

		@emitterAttributes["speed"] = Struct::Attribute.new("speed", 5, -1000, 1000)
		puts @emitterAttributes["speed"]
		@emitterAttributes["totalParticles"] = Struct::Attribute.new("Total Particles", 50, 0, 1000)
		@emitterAttributes["red"] = Struct::Attribute.new("red", 150, 0, 255)
		@emitterAttributes["blue"] = Struct::Attribute.new("blue", 150, 0, 255)
		@emitterAttributes["green"] = Struct::Attribute.new("green", 150, 0, 255)
		@emitterAttributes["red_var"] = Struct::Attribute.new("red variance", 100, 0, 255)
		@emitterAttributes["green_var"] = Struct::Attribute.new("green variance", 100, 0, 255)
		@emitterAttributes["blue_var"] = Struct::Attribute.new("blue variance", 100, 0, 255)
		@emitterAttributes["life"] = Struct::Attribute.new("life", 100, 1, 2000)
		@emitterAttributes["life_var"] = Struct::Attribute.new("life variance", 0, 0, 1000)
		@emitterAttributes["angle"] = Struct::Attribute.new("angle", 0, 0, 360)
		@emitterAttributes["angle_var"] = Struct::Attribute.new("angle variance", 360, 0, 360)
		@emitterAttributes["rate"] = Struct::Attribute.new("emission rate", 0, 0, 1000)
		@emitterAttributes["scale"] = Struct::Attribute.new("scale", 1, 0.1, 10.0)
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
