class PokemonsController < ApplicationController
	def new
		@pokemon = Pokemon.new
	end

	def damage
		@pokemon = Pokemon.find params[:id]
		@pokemon.health -= 10
		@pokemon.save
		redirect_to trainer_path(current_trainer)
		if @pokemon.health <= 0
			exp = [((@pokemon.level ** 2) / attacker.level), 2].max
			attacker.add_exp(exp)
			attacker.save

			flash.alert = "You gained #{exp} experience."
			redirect_to trainer_path(:id => @pokemon.trainer.id)
		end
	end

	def capture
		@pokemon = Pokemon.find params[:id]

		if not @pokemon.trainer
			@pokemon.trainer = current_trainer
			@pokemon.save

			redirect_to :root
		else
			redirect_to :back, :alert => "That pokemon can't be captured!"
	end

	def create
		@pokemon = Pokemon.new(pokemon_params)
		@pokemon.health = 100
		@pokemon.level = 1
		@pokemon.trainer = current_trainer

		if @pokemon.save
			redirect_to trainer_path(:id => current_trainer.id)
		else
			flash[:error] = pokemon.errors.full_messages.to_sentence
			redirect_to :back
		end
	end

	def heal
		@pokemon = Pokemon.find(params[:id])

		if @pokemon.trainer == current_trainer
			@pokemon.health += 10
			if @pokemon.health > 100
				@pokemon.health = 100
			end

			@pokemon.save
			redirect_to trainer_path(:id => @pokemon.trainer.id)
		else
			redirect_to :back, :alert => "That's not your Pokemon -_-"
		end
	end

	private
	def pokemon_params
		params.require(:pokemon).permit(:name)
	end
end