

class SquareEmitter  < Emitter
	def initialize(x, y, img, &block)
		super(x, y, img, &block)
		@rangeX = 200
		@rangeY = 200
	end

	def initParticle(p)
		@angle = (@angle + rand(-@angleVariance..@angleVariance))
		@vel_x = @speed * Math.cos(angle * Math::PI / 180)
		@vel_y = @speed * Math.sin(angle * Math::PI / 180)
		
		@color.red = @red + rand(-@redVariance..@redVariance)
		@color.blue = @blue + rand(-@blueVariance..@blueVariance)
		@color.green = @green + rand(-@greenVariance..@greenVariance)
		p.life = @life + rand(-@lifeVariance..@lifeVariance)
		p.additive = @additive
		p.x = @x + rand(0..@rangeX)
		p.y = @y + rand(0..@rangeY)
		p.vel_x = @vel_x
		p.vel_y = @vel_y
		p.img = @img
		p.color = @color.dup
		p.scale = @scale
		p.alphaDecayRate = @alphaDecayRate
	end
end