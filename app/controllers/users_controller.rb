class UsersController < ApplicationController	

    before_action :authenticate_user!, only: [:index, :show, :edit, :update, :destroy]

 	def index
		@users = User.all 
    @time_range = (1.week.ago..Time.now)
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create

		@user = User.new(user_params)

		if @user.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: "Your account was successfully created" }
      end
    else
      respond_to do |format|
        format.json { render :text => "Could not create account", :status => :unprocessable_entity } # placeholder
        format.xml  { head :ok }
        format.html { render :action => :new, :status => :unprocessable_entity }
      end
    end

	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])

    	if params[:provider][:password].blank?
      		[:password, :password_confirmation, :current_password].collect{|p| params[:user].delete(p)}
    	else
      		@provider.errors[:base] << "The password you entered is incorrect." unless @user.valid_password?(params[:user][:current_password])
    	end 

    	respond_to do |format|
      		if @user.update(user_params)
        		sign_in(@user, :bypass => true) # To counter weird Devise error which logs users out after password change
        		format.html { redirect_to root_path, notice: 'Your account details were updated successfully' }
      		else
        		format.html { render :edit }
      		end
    	end
	end

	def destroy
		@user = User.find(params[:id])
    	@user.destroy
 
    	respond_to do |format|
      		format.html { redirect_to root_path, notice: "Your account has been deleted. I must replace this with a whole page for feedback." }      
    	end
	end

	private

	def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :authenticity_token, :first_name, :last_name, :skip_count)
    end


end