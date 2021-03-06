class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

		if params[:commit] == "Refresh"
			session[:ratings] = params[:ratings]
		end

		if params[:ratings].nil? and session[:ratings].nil?
			@ratings_to_show = Movie.all_ratings
		  @movies = Movie.all
		else
			if params[:ratings].nil?
				params[:ratings] = session[:ratings]
				redirect_to(movies_path(ratings: params[:ratings], sort: params[:sort]))
			end
			@movies = Movie.with_ratings(params[:ratings].keys)
      @ratings_to_show = Movie.ratings_to_show
			session[:ratings] = params[:ratings]
		end

		unless params[:sort].nil? and session[:sort].nil?
			if params[:sort].nil?
				params[:sort] = session[:sort]
			end
			@sort_field = params[:sort]
			@movies = Movie.sort_by(@movies, params[:sort])
			session[:sort] = params[:sort]
		end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
