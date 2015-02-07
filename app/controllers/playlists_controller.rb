class PlaylistsController < ApplicationController

	before_filter :set_user

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
	end


	private

		def set_user
		  @user = User.find_by_id(current_user.id)
		end

		def playlist_params
      		params.require(:playlist).permit(:name, :user_id)
    	end

end
