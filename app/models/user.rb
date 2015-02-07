class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :playlists
  accepts_nested_attributes_for :playlists
  has_many :tracks, :through => :playlists

  # Skip relationships
  has_many :skips, class_name:  "Skip", foreign_key: "skipper_id", dependent: :destroy
  has_many :skipped_users, through: :active_relationships, source: :skipped # Users whose tracks you've skipped
  has_many :been_skipped, class_name:  "Skip", foreign_key: "skipped_id", dependent:   :destroy
  has_many :skipping_users, through: :passive_relationships # Users who have skipped your tracks

  # Skip method - builds a record of skip 
  def skip(other_user)
    skips.create(skipped_id: other_user)
  end

  def been_skipped_this_week(user)
  	@user = User.find(id: user)
  	@time_range = (1.week.ago..Time.now)

  	@user.been_skipped.where(:created_at => @time_range).count
  end


end
