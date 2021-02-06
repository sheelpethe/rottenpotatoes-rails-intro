class Movie < ActiveRecord::Base

	@all_ratings = ['G', 'PG', 'PG-13', 'R']
	@ratings_to_show = []

	def self.with_ratings(ratings)
	  @ratings_to_show = ratings
		@movies = Movie.where(rating: ratings)
	end

	def self.all_ratings
		return @all_ratings
	end

	def self.ratings_to_show
		return @ratings_to_show
	end

end
