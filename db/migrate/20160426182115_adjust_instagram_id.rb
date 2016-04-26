class AdjustInstagramId < ActiveRecord::Migration
  def change
    change_column(:instagram_photos, :instagram_id, :text)
  end
end
