class Movie < ActiveRecord::Base
    def self.all_ratings
        self.all.pluck(:rating).uniq.sort
    end
    def self.with_ratings(ratings)
        self.where("rating: [:ratings].keys")        
    end
    
end
