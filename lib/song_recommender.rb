class SongRecommender
    include Predictor::Base

    input_matrix :users, weight: 3.0
    input_matrix :tags, weight: 2.0
    input_matrix :topics, weight: 1.0, measure: :sorensen_coefficient # Use Sorenson over Jaccard
end