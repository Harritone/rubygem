class AddAvarageRatingToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :avarage_rating, :float, default: 0.0, null: false
  end
end
