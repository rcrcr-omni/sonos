class PagesController < ApplicationController
  before_filter :get_speaker
  skip_before_filter :verify_authenticity_token, :only => :sonos_control

  require 'rubygems'
  require 'sonos'
  require 'rspotify'

  def splash
  end

  def sonos_control
    puts 'received a command'
    if params[:token] == ENV['SLACK_TOKEN']
      @user_id = params[:user_id]
      @user = params[:user_name]
      @user_object = "<@#{@user_id}>"
      @text = params[:text]

      @poster = Slack::Poster.new(ENV['INCOMING_SLACK_TOKEN'])

      if @text == 'play'
        @speaker.play
        @msg = @user_object + " started the sonos playing! Good job!" 
        @poster.send_message(@msg)
        render :file => "/pages/msg.json.erb", :content_type => 'application/json' and return

      
      elsif @text == 'pause'
        @speaker.pause
        @msg = @user_object + " just paused the Sonos"
        @poster.send_message(@msg)
        render :file => "/pages/msg.json.erb", :content_type => 'application/json' and return


      elsif @text == 'skip'
        @msg = @user_object + " just skipped *#{@speaker.now_playing[:title]}* by _#{@speaker.now_playing[:artist]}_."
        @speaker.next
        @poster.send_message(@msg)
        render :file => "/pages/msg.json.erb", :content_type => 'application/json' and return

      elsif @text.include?('add')
          @search = @text.downcase.slice('add')
          if @search.include?("by")
            @search = @search.split("by").map(&:strip)
            @track = @search[0]
            @artist = @search[1]
            @tracks = RSpotify::Track.search(@track).sort_by(&:popularity).reverse!
            @your_track = @tracks.find {|t| t.artists[0].name.downcase == @artist}
          else 
            @tracks = RSpotify::Track.search(@search).sort_by(&:popularity).reverse!
            @your_track = @tracks.first 
          end  

          # add the track to the queue
          @speaker.add_spotify_to_queue({id: @your_track.id})

          # send the message to the slack channel
          @msg = "#{@user_object} just added *#{@your_track.name}* by *#{@your_track.artists[0].name}* to the queue: #{@your_track.external_urls['spotify']}"
          puts @msg
          
          @poster.send_message(@msg)
          render :file => "/pages/msg.json.erb", :content_type => 'application/json' and return

      elsif @text == 'playing'
        @msg = "You are listening to *#{@speaker.now_playing[:title]}* by _#{@speaker.now_playing[:artist]}_"
        render :file => "/pages/msg.json.erb", :content_type => 'application/json' and return
      else
        @msg = "You need to tell me what you want to do!\nplay (play the sonos) | pause (pause the sonos) | skip (skip this track) | add [track] by [artist] (add a track to the queue - artist optional) | playing (find out what is playing now)"
        render :file => "/pages/msg.json.erb", :content_type => 'application/json' and return

      end

    else # if slack token doesn't match
      puts "Not sure how this happened, but whoever is trying to access this isn't doing it from the right slack team"
      @msg = "I'm sorry, you're not authorised to do that!"
      render :file => "/pages/msg.json.erb", :content_type => 'application/json' and return
    end # end slack token check 

  end

  private 

  def get_speaker
    @system = Sonos::System.new # Auto-discovers your system
    # @speakers = @system.speakers.sort! {|a,b| a.ip <=> b.ip}
    @speaker = @system.speakers.first
  end 

end
