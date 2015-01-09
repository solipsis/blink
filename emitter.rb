

class Emitter

	attr_accessor :particleCount

	attr_accessor :speed, :totalParticles, :red, :green, :blue
	attr_accessor :redVariance, :blueVariance, :greenVariance, :life
	attr_accessor :lifeVariance, :angle, :angleVariance, :emissionRate, :scale


	def initialize(x, y, img, &block)

		#initAttributes()
		#@EmitterAttributes["speed"] = Struct::Attribute.new("speed", 5, -1000, 1000)
		#@EmitterAttributes["totalParticles"] = Struct::Attribute.new("Total Particles", 50, 0, 1000)
		#@EmitterAttributes["red"] = Struct::Attribute.new("red", 150, 0, 255)
		#@EmitterAttributes["blue"] = Struct::Attribute.new("blue", 150, 0, 255)
		#@EmitterAttributes["green"] = Struct::Attribute.new("green", 150, 0, 255)
		#@EmitterAttributes["red_var"] = Struct::Attribute.new("red variance", 100, 0, 255)
		#@EmitterAttributes["green_var"] = Struct::Attribute.new("green variance", 100, 0, 255)
		#@EmitterAttributes["blue_var"] = Struct::Attribute.new("blue variance", 100, 0, 255)
		#@EmitterAttributes["life"] = Struct::Attribute.new("life", 100, 1, 2000)
		#@EmitterAttributes["life_var"] = Struct::Attribute.new("life variance", 0, 0, 1000)
		#@EmitterAttributes["angle"] = Struct::Attribute.new("angle", 0, 0, 360)
		#@EmitterAttributes["angle_var"] = Struct::Attribute.new("angle variance", 0, 0, 360)
		@speed = 5
		@totalParticles = 50
		@red = 150
		@green = 150
		@blue = 150
		@redVariance = 255
		@blueVariance = 255
		@greenVariance = 255
		@life = 100
		@lifeVariance = 0
		@angle = 0
		@angleVariance = 360
		@emissionRate = 0
		@scale = 1


		#@totalParticles = 30
		@pool = Array.new()
		@img = img
		@x = x
		@y = y
		
		@particleCount = 0
		@emissionRate = 0
		@cooldown = @emissionRate
		@color = Gosu::Color.new(0xFF000000)

		@frames = 0

		#set values from block
		instance_eval &block if block_given?
		

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

		#speed = 5
		@angle = (@angle + rand(-@angleVariance..@angleVariance))
		@vel_x = @speed * Math.cos(angle * Math::PI / 180)
		@vel_y = @speed * Math.sin(angle * Math::PI / 180)
		#@vel_x = 8
		#@vel_y = 0
		@color.red = @red + rand(-@redVariance..@redVariance)
		@color.blue = @blue + rand(-@blueVariance..@blueVariance)
		@color.green = @green + rand(-@greenVariance..@greenVariance)
		p.life = @life + rand(-@lifeVariance..@lifeVariance)
		p.x = @x
		p.y = @y
		p.vel_x = @vel_x
		p.vel_y = @vel_y
		p.img = @img
		p.color = @color.dup
		p.scale = @scale
		p.additive = true
	end


	def initAttributes
		

	end

	#draw the particles
	def draw
		for x in 0..(@particleCount-1)
			@pool[x].draw
		end
	end

end