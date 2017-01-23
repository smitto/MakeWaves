Predictor.redis = Redis.new(:url => ENV["PREDICTOR_REDIS"])

# Add Possible Genres to Predictor
require './lib/song_recommender.rb' 
recommender = SongRecommender.new
recommender.add_to_matrix!(:topics, "Rock", "Classical", "Country", "Electronic", "Hip-Hop", "Pop", "World")
