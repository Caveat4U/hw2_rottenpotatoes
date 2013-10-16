class Movie < ActiveRecord::Base
  # Statically return ratings in the system
  #def self.all_ratings
  #  %w(G PG PG-13 NC-17 R)
  #end

  #Dynamically fetch all ratings in the system
  def self.all_ratings
    all_ratings = []
    self.select(:rating).group(:rating).each do |mo|
      all_ratings << mo.rating
    end
    return all_ratings
  end
end
