class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    #OLD
    #@movies = Movie.order(sort_column + " " + sort_direction)
    #sort_column = sort_column()
    #sort_direction = sort_direction()
    #sort = params[:sort] || session[:sort]
    case sort_column
    when 'title'
      ordering,@title_header = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:order => :release_date}, 'hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    # Set the session variables if necessary
    if params[:sort_column] != session[:sort_column] or params[:ratings] != session[:ratings] or params[:sort_direction] != session[:sort_direction]
      session[:sort_column] = sort_column
      session[:sort_direction] = sort_direction
      session[:ratings] = @selected_ratings
      redirect_to :sort_column => sort_column, :sort_direction => sort_direction, :ratings => @selected_ratings and return
    end

    @movies = Movie.find_all_by_rating(@selected_ratings.keys, sort_column + " " + sort_direction)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def sort_column
    sort = params[:sort_column] || session[:sort_column]
    Movie.column_names.include?(sort) ? sort : "title"
  end

  def sort_direction
    direction = params[:sort_direction] || session[:sort_direction]
    %w[asc desc].include?(direction) ? direction : "asc"
  end

end
