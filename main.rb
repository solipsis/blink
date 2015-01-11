require 'gosu'
require 'rubygems'
#require 'fidgit'
#require 'Chingu'
require_relative 'player'
require_relative 'particle'
require_relative 'fpscounter'
require_relative 'emitter'


Struct.new("Attribute", :name, :value, :min, :max)

class GameWindow < Gosu::Window
#class GameWindow < Chingu::Window
	def initialize
		super 1280, 800, false
		self.caption = "blink"


		#@selectedKey = "speed"
		@selectedKeyIndex = 0
		@player = Player.new(self)
		@player.blink(500,500)
		@mouse = MouseCursor.new(self)

		@particles = Array.new()
		#@particle_img = Gosu::Image.new(self, "circle_icon.png", false)
		#@particle_img = Gosu::Image.new(self, "verySmallCircle.png", false)
		@particle_img = Gosu::Image.new(self, "verySmallCircle.png", false)
		@fpsCounter = FPSCounter.new(self)
		@emitters = Array.new()
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
		@totalParticles = 0
		@additive = true
		@alphaDecayRate = 2
		#@particle_img = Gosu::Image.new(self, "cage.jpg", false)
		
		initEmitterAttributes()
		
	end

	def needs_cursor?
		true
	end

	def update
		if button_down? Gosu::MsLeft then
			@player.blink(mouse_x, mouse_y)
			#create_splosion(mouse_x, mouse_y)
		end
		if button_down? Gosu::MsRight then
			createEmitter(mouse_x, mouse_y, @emitterAttributes)
		end
		if button_down? Gosu::KbLeft then
			@player.move("left")
			decrementAttribute()
		end
		if button_down? Gosu::KbRight then
			@player.move("right")
			incrementAttribute()
		end
		if button_down? Gosu::KbUp then
			@player.move("up")
			
			if @selectedKeyIndex > 0
				@selectedKeyIndex -= 1
			end
		end
		if button_down? Gosu::KbDown then
			@player.move("down")
			
			if @selectedKeyIndex < (@emitterAttributes.keys.size-1)
				@selectedKeyIndex += 1
			end
		end
		if button_down? Gosu::MsWheelDown then
			if @selectedKeyIndex < (@emitterAttributes.keys.size-1)
				@selectedKeyIndex += 1
			end
		end
		if button_down?(Gosu::MsWheelUp)
			if @selectedKeyIndex > 0
				@selectedKeyIndex -= 1
			end
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

	def button_down(id)
		case id
		when Gosu::MsWheelUp
			if @selectedKeyIndex > 0
				@selectedKeyIndex -= 1
			end	
		when Gosu::MsWheelDown
			if @selectedKeyIndex < (@emitterAttributes.keys.size-1)
				@selectedKeyIndex += 1
			end
		end
	end

	def button_up(id)
		case id
		when Gosu::MsLeft
			if @additive == false 
				@additive = true
			else @additive == true
				@additive = false
			end
		end
	end



	def incrementAttribute()
		attribute = @emitterAttributes[@emitterAttributes.keys[@selectedKeyIndex]]
		#attribute.value += attribute.max / 500
		attribute.value += 1
		if attribute.value > attribute.max
			attribute.value = attribute.max 
		end
	end

	def decrementAttribute()
		attribute = @emitterAttributes[@emitterAttributes.keys[@selectedKeyIndex]]
		# attribute.value -= attribute.max / 500
		attribute.value -= 1
		if attribute.value < attribute.min
			attribute.value = attribute.min 
		end
	end


	def create_splosion(x, y)
		5.times do 
			@particles.push(Particle.new(self, x, y, Random.rand(360), 1, @particle_img))
		end
	end

	def createEmitter(x, y, emitterAttributes)
		additive = @additive
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
				self.scale = emitterAttributes["scale"].value
				# puts "potato"
				# puts emitterAttributes["alpha_decay_rate"].value
				self.alphaDecayRate = emitterAttributes["alpha_decay_rate"].value

				self.additive = additive
			end
		)
		#puts @additive
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
		drawAttributes() 
	end


	def drawAttributes
		y = 55
	
		index = 0
		for key in @emitterAttributes.keys
			if (index == @selectedKeyIndex)
				@font.draw("***" + @emitterAttributes[key].name.to_s + "***: " + @emitterAttributes[key].value.to_s, 0, y, 10)
			else
				@font.draw(@emitterAttributes[key].name.to_s + ": " + @emitterAttributes[key].value.to_s, 0, y, 10)
			end
			y += 20
			index += 1
		end
		@font.draw("additive rendering: " + @additive.to_s, 0, y, 10)
		@font.draw("use mouse wheel to select attributes to change. use left and right arrow keys to change the values. Use space to clear the view", 0, 700, 10)
		@font.draw("hold right click to place particle emitters with the chosen attributes. Press left click to toggle additive rendering", 0, 720, 10)
		@font.draw("more features soon and a better gui", 0, 740, 10)

	end	

	def initEmitterAttributes
		@emitterAttributes = Hash.new()

		@emitterAttributes["speed"] = Struct::Attribute.new("speed", 5, 0, 100)
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
		@emitterAttributes["rate"] = Struct::Attribute.new("emission rate", 0, 0, 20)
		@emitterAttributes["scale"] = Struct::Attribute.new("scale", 1, 0.1, 10.0)
		@emitterAttributes["alpha_decay_rate"] = Struct::Attribute.new("Alpha decay rate", 2, 0, 60)
	end
end

#-------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------

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



#window = GameWindow.new
#window.show
GameWindow.new.show
