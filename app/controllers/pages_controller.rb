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
    @user_id = params[:user_id]
    @user = params[:user_name]
    @user_object = "<@#{@user_id}|#{@user}>"
    @text = params[:text]

    options = {
      icon_emoji: 'arrow_forward'
    }
    @poster = Slack::Poster.new('https://hooks.slack.com/services/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', options)

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


    elsif @text == 'playing'
      @msg = "You are listening to *#{@speaker.now_playing[:title]}* by _#{@speaker.now_playing[:artist]}_"
      render :file => "/pages/msg.json.erb", :content_type => 'application/json' and return
    else
      @msg = "You need to tell me what you want to do! play (play the sonos) pause (pause the sonos) skip (skip this track) playing (find out what is playing now)"
      render :file => "/pages/msg.json.erb", :content_type => 'application/json' and return

    end

  end

  private 

  def get_speaker
    @system = Sonos::System.new # Auto-discovers your system
    # @speakers = @system.speakers.sort! {|a,b| a.ip <=> b.ip}
    @speaker = @system.speakers.first
  end 

end
