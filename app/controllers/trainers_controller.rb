class TrainersController < ApplicationController
	before_filter :authenticate_trainer!

	def show
		@trainer = Trainer.find(params[:id])
	end

	def index
		@trainers = Trainer.all
	end
end