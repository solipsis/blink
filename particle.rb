

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

	#def initialize(x, y, *angle, *speed, *img)
	#	@x = x
	#	@y = y
#
#		@img = img
#		@color = Gosu::Color.new(0xff000000)
#		@color.red = rand(256 - 40) + 40
#	
#		@color.green = rand(256 - 40) + 40
#		@color.green = 0
#		@color.blue = rand(256 - 40) + 40
#		@color.blue = 0
#		@color.hue = rand(360)
#		@life = 255#

	#end


	def initialize(x, y)
		#@additive = false
		@x = x
		@y = y
		@vel_x = 0
		@vel_y = 0
		@life = 5
	end

	def update
		@x += @vel_x
		@y += @vel_y
		@life -= 1
		#@color.value -= 1
		#@color.value -= 1
		#@color.hue -= 5
		#@color.alpha -= 1
		#if @color.alpha == 0 then 
		#	@color.alpha = 255
		#end
		#@color.green = 5000
		#@color.red = 5000
		#@color.blue = 0
	end

	def draw
		#puts @additive
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