require 'thor'
require 'json'

class Buildbook < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"

  desc "process input.json changes.json out.json", "process the changes in the provided files"
  def process(input_path, changes_path, output_path)
    puts "running"
    input_file = JSON.parse(File.read(input_path))
    changes_file = JSON.parse(File.read(changes_path))
    output_file = File.new(output_path, 'w')

    output_file.write(JSON.pretty_generate(apply_changes(input_file, changes_file)))
  end

  private

  def apply_changes(spotify, changes)

    # Add songs to playlists
    changes['added_songs'].each do |new_song|
      pl = spotify['playlists'].select { |pl| pl['id'] == new_song['playlist_id'] }.first
      pl['song_ids'].push(new_song['song_id'])
    end

    # Add playlists
    playlist_ids = spotify['playlists'].map { |pl| pl["id"].to_i }.sort
    changes['added_playlists'].each do |new_playlist|
      new_pl_id = playlist_ids.last + 1
      playlist_ids.push(new_pl_id)
      spotify['playlists'].push({
        id: new_pl_id.to_s,
        owner_id: new_playlist['owner_id'],
        song_ids: new_playlist['song_ids']
      })
    end

    # remove playlists
    changes['removed_playlist_ids'].each do |removed_id|
      spotify['playlists'] = spotify['playlists'].reject do |pl|
        pl['id'] == removed_id
      end
    end

    return spotify
  end
end

Buildbook.start(ARGV)