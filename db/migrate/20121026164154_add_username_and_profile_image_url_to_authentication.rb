class AddUsernameAndProfileImageUrlToAuthentication < ActiveRecord::Migration
  def change
    add_column :authentications, :username, :string
    add_column :authentications, :profile_image_url, :string
  end
end
