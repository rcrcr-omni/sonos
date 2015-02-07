class PagesController < ApplicationController
  before_filter :get_speaker
  before_filter :set_user

  require 'rubygems'
  require 'sonos'
  require 'rspotify'

  def home
    @playlists = Playlist.all
    @playlist = current_user.playlists.build
  end

  def spotify
    @playlists = Playlist.all
    @playlist = current_user.playlists.build
    @users = User.all
  end
  
  def spotify_search
    if params[:search].empty?
      respond_to do |format| 
        format.html { redirect_to spotify_path, notice: "Try searching for something" }
      end
    else 
      @artists = RSpotify::Artist.search(params[:search])
      @albums = RSpotify::Album.search(params[:search])
      @tracks = RSpotify::Track.search(params[:search])
    end


  end


helper_method :success_path

  def success_path
  end

  def refresh_part
    respond_to do |format|
      format.js
    end
  end

  def play
  	# @speaker.play
    @user = current_user
    @user.play_count = @user.play_count + 1
    @user.save 
  end

  def pause
  	# @speaker.pause
    # if Time.now is between 8.30am and 6pm  
      @user = current_user
      @user.pause_count = @user.pause_count + 1
      @user.save 
  end 

  def next 
    # Count how many times the current user has skipped a song today
    @skips_today = current_user.skips.where("created_at >= ?", Time.zone.now.beginning_of_day).count

    # If they've skipped 1 song, tell them they can't skip again until tomorrow 
    if @skips_today >= 1
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Woah there, Skippy! You can only skip one song a day! I hope it was worth it..." }
      end
    # Otherwise, get the ID of the user who played the song and build the skip   
    else
      @current_track = @speaker.now_playing[:title] 
      @track = Track.where(:name => @current_track)
      # Get user ID of track 
      @user_id = @track.user_id
      current_user.skip(@user_id)

      # Finally, skip the track 
      @speaker.next 
    end

  end

  def add_to_playlist
    @track = current_user.tracks.build
    @track.name = params[:name]
    @track.artist = params[:artist]
    @track.album = params[:album]
    @track.uri = params[:uri]
    @track.save

    @playlist = Playlist.find(params[:playlist_id])
    @playlist.tracks << @track

  end


  def add_to_queue(uri)
    # Set the time range to search for times user has been skipped
    @time_range = (1.week.ago..Time.now)
    @been_skipped_this_week = current_user.been_skipped.where(:created_at => @time_range).count

    # If they've been skipped 3 or more times, alert them that they can't add anything to the queue
      @speaker.add_to_queue 'x-sonos-spotify:' + uri + '?sid=9&amp;flags=32' # replace with variable for spotify URI

  end

  def add_playlist_to_queue
    @playlist = Playlist.find(params[:id])
    @playlist.tracks.each do |track|
      track.add_to_queue(track.uri)
    end
  end

  # def if queue is empty, select random playlist and play  

  # def black list - every user can have 5 tracks they can ban from Spotify - check that no duplicates 


  private 

  def get_speaker
    # system = Sonos::System.new # Auto-discovers your system
    # @speaker = system.groups.first.master_speaker 
  end

  def set_user
    @user = User.find_by_id(current_user.id)
  end

end
