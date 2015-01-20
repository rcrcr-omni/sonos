class PagesController < ApplicationController

require 'rubygems'
require 'sonos'
system = Sonos::System.new # Auto-discovers your system
speaker = system.speakers.first

def home
	system = Sonos::System.new # Auto-discovers your system
	@speaker = system.speakers.first
end


end
