

class Particle
	def initialize(window, x, y, angle, speed, img)
		@x = x
		@y = y

		@vel_x = speed * Math.cos(angle * Math::PI / 180)
		@vel_y = speed * Math.sin(angle * Math::PI / 180)
		@img = img
		@color = Gosu::Color.new(0xff000000)
		@color.red = rand(256 - 40) + 40
	
		@color.green = rand(256 - 40) + 40
		#@color.green = 0
		@color.blue = rand(256 - 40) + 40
		#@color.blue = 0
		@color.hue = rand(360)
	end

	def update
		@x += @vel_x
		@y += @vel_y
	end

	def draw
		@img.draw(@x, @y, 1, 1, 1, @color)
	end

end