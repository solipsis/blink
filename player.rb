class Player
	def initialize(window)
		@img = Gosu::Image.new(window, "kappa.jpg", false)
		@x = @y = 0.0
	end

	def draw
		@img.draw_rot(@x, @y, 1, 0)
	end

	def blink(x, y)
		@x, @y = x, y
	end

	def move(dir)
		case dir 
		when "up"
			@y -= 5
		when "down"
			@y += 5
		when "right"
			@x += 5
		when "left"
			@x -= 5
		end

		@x %= 1280
		@y %= 800
	end
end