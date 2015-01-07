

class Emitter
	def initialize(window, x, y, img)
		@totalParticles = 50
		@pool = Array.new()
		@img = img
		@x = x
		@y = y
		
		@particleCount = 0
		@emissionRate = 1
		@cooldown = @emissionRate
		@color = Gosu::Color.new(0xFF000000)
		

		restartPool()
	end

	#update all living particles
	def update
		#puts @particleCount
		if (@particleCount < @totalParticles)
			addParticle()
		end
		temp = @pool[0]
		for x in 0..(@particleCount-1) 
			if (@pool[x].alive? == false)
				#swap dead particles to the end of active particles
				temp = @pool[x]
				@pool[x] = @pool[@particleCount-1]
				@pool[@particleCount-1] = temp
				@particleCount -= 1
			end
			@pool[x].update
		end
	end

	#reset the entire pool
	def restartPool
		@pool = Array.new(@totalParticles)
		for x in 0..(@totalParticles-1)
			#puts "poney"
			#puts Particle.new(@x, @y)
			@pool[x] = Particle.new(@x, @y)
			#puts @pool[0]
		end
	end

	#reinitialize one of the dead particles
	def addParticle
		if (@particleCount == @totalParticles)
			return false
		end
		p = @pool[@particleCount]
		initParticle(p)
		@particleCount += 1
	end

	#set the particles initial value
	def initParticle(p)

		speed = 5
		angle = Random.rand(360)
		@vel_x = speed * Math.cos(angle * Math::PI / 180)
		@vel_y = speed * Math.sin(angle * Math::PI / 180)
		@color.red = rand(255)
		@color.blue = rand(255)
		@color.green = rand(255)
		p.life = 200
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