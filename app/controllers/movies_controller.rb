class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.all_ratings

    if params[:key]
      session[:key] = params[:key]
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
   
   
    if !(session[:ratings].nil?) and session[:ratings].is_a?(Hash)
      @movies = Movie.where(rating: session[:ratings].keys)
      #@checked_ratings = session[:ratings].keys
    else
      @movies = Movie.all
      #@checked_ratings = @all_ratings
    end
    
    if session[:key] == 'title'
     @movies = @movies.order(:title)
     @title_css = 'hilite'
    elsif session[:key] == 'releases'
     @movies = @movies.order(:release_date)
     @release_css = 'hilite'
    end
    
    if (params[:ratings].nil?) and (params[:key].nil?) 
      cached_params = { key: session[:key], ratings: session[:ratings] }
      flash.keep
      redirect_to movies_path(cached_params)
      return
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
    session.clear
    redirect_to movies_path
  end

end
