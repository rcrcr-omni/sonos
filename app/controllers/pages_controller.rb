class PagesController < ApplicationController
  before_filter :get_speaker

  require 'rubygems'
  require 'sonos'
  require 'rspotify'

  def home
  end

  def spotify
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
  	@speaker.play
  end

  def pause
  	@speaker.pause
  end 

  def next 
    # Get ID of current_user 
    # Check if they've skipped a song today 
    # If > 1 'Sorry, you can only skip one song a day. Next time, make sure you really hate it!''
    # else
    # prompt 'You can only skip one song a day, are you sure you hate this that much?'
    @speaker.next 

    # Get ID of user who added current song 
    # Add 1 to user.skipped 
    # Get ID of current_user 
    # Add 1 to user.daily_skips 
  end

  def add_to_queue

    # Get ID of current_user
    # Check how many skips they've had this week 
    # if > 3, 'You can't add any more songs this week. Too many have been skipped!' 
    # else 

    @uri = params[:uri] 
    @speaker.add_to_queue 'x-sonos-spotify:spotify:track:2CJtimCSGAn8x6RE3irZFVsid=9&amp;flags=32' # replace with variable for spotify URI
  end 

  # def if queue is empty, select random playlist and play 

  # def clear number of user.skipped each week 

  # def clear user.daily_skips at midnight every night 

  # def black list - every user can have 5 tracks they can ban from Spotify - check that no duplicates 

  private 

  def get_speaker
    # system = Sonos::System.new # Auto-discovers your system
    # @speaker = system.groups.first.master_speaker 
  end

end
