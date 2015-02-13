class PlaylistsController < ApplicationController
	before_action :authenticate_user!

	def index
	end

	def new 
		@playlist = current_user.playlists.build 
	end

	def create
	  @playlist = current_user.playlists.build(playlist_params)

      respond_to do |format|
	      if @playlist.save
	        format.html { redirect_to playlist_path(@playlist), notice: 'Playlist was successfully created.' }
	      else
	        format.html { render :new }
	        format.json { render json: @playlist.errors, status: :unprocessable_entity }
	      end
      end
	end

	def show
		@playlist = Playlist.find(params[:id])
		@user = @playlist.user
	end


	private

		def playlist_params
      		params.require(:playlist).permit(:name, :user_id)
    	end

end
