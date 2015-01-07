

class Emitter

	attr_accessor :particleCount

	def initialize(window, x, y, img)
		@totalParticles = 30
		@pool = Array.new()
		@img = img
		@x = x
		@y = y
		
		@particleCount = 0
		@emissionRate = 0
		@cooldown = @emissionRate
		@color = Gosu::Color.new(0xFF000000)

		@frames = 0
		

		restartPool()
	end

	#update all living particles
	def update
		@cooldown -= 1
		while (@particleCount < @totalParticles && @cooldown <= 0)
			addParticle()
			@cooldown = @emissionRate
		end
		i = 0
		while (i <= (@particleCount-1))
			if (@pool[i].alive? == false)
				#swap dead particles to the end of active particles
				@pool[i], @pool[@particleCount-1] = @pool[@particleCount-1], @pool[i]
				@particleCount -= 1
			end
			@pool[i].update
			i += 1
		end
	end


	#reset the entire pool
	def restartPool
		@pool = Array.new(@totalParticles)
		for x in 0..(@totalParticles-1)
			@pool[x] = Particle.new(@x, @y)
		end
	end


	#reinitialize one of the dead particles
	def addParticle
		if (@particleCount == @totalParticles)
			return false
		else
			initParticle(@pool[@particleCount])
			@particleCount += 1
		end
	end


	#set the particles initial value
	def initParticle(p)

		speed = 5
		angle = Random.rand(360)
		@vel_x = speed * Math.cos(angle * Math::PI / 180)
		@vel_y = speed * Math.sin(angle * Math::PI / 180)
		#@vel_x = 8
		#@vel_y = 0
		@color.red = rand(255)
		@color.blue = rand(255)
		@color.green = rand(255)
		p.life = 60
		p.x = @x
		p.y = @y
		p.vel_x = @vel_x
		p.vel_y = @vel_y
		p.speed = 5
		p.img = @img
		p.color = @color.dup
	end


	#draw the particles
	def draw
		for x in 0..(@particleCount-1)
			@pool[x].draw
		end
	end

end