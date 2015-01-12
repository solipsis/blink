

class Particle
	
	attr_accessor :x
	attr_accessor :y
	attr_accessor :speed
	attr_accessor :img
	attr_accessor :color
	attr_accessor :vel_x
	attr_accessor :vel_y
	attr_accessor :life
	attr_accessor :additive
	attr_accessor :scale
	attr_accessor :alphaDecayRate
	attr_accessor :test
	#attr_accessor :hueChangeRate


	def initialize(x, y)
		@x = x
		@y = y
		@vel_x = 0
		@vel_y = 0
		@life = 5
		@test = 0
		#puts @test.inspect
	end

	def update
		@x += @vel_x
		@y += @vel_y
		@life -= 1
		@color.alpha -= @alphaDecayRate
		@test += 3
		#@color.hue += 0
		#@color.value = @color.value
		#@color.hue = color.hue
		# puts @color.hue
		#puts @hueChangeRate
	end

	def draw
		if @additive == true then
			@img.draw(@x, @y, 1, @scale, @scale, @color, mode = :additive)
		else
			@img.draw(@x, @y, 1, @scale, @scale, @color)
		end
	end

	def alive?
		if @life >= 0
			return true
		end
		return false
	end

end