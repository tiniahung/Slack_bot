class AddPlaylistsTable < ActiveRecord::Migration[5.0]
  def change
  create_table :playlists do |t|
  t.string :playlist
  t.string :song_name
  t.integer :song_number
  t.string :artist
  t.integer :song_length
  t.string :user_id
  t.string :team_id
  end
end
end
