class Pokemon < ActiveRecord::Base
	valideates :name, presence: true, uniqueness: true
	belongs_to: trainer

	def add_exp(exp)
		self.experience += exp
		if exp > exp_needed()
			self.experience = exp - exp_needed()
			self.level += 1
		end
	end

	def exp_needed
		return self.level ** 2 - self.experience
	end
end