class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable
  #acts_as_voter

  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  
  ## CALLBACKS
  
  def self.create_with_omniauth(auth)
    data = auth.extra.raw_info
    case auth["provider"]
    when "twitter"
      user = User.new
#      user.username = data.screen_name
#      user.name = data.name
#      user.email = "#{user.username}@hapful.com"
    when "facebook"
      user = User.find_by_email(data.email)
#      unless user
        user = User.new
#        user.name = data.name
#        user.username = data.name.to_s.downcase.gsub(" ", "-")
#        user.email = data.email
#      end
    end
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.save(:validate => false)
    return user
  end

  def auth
    begin
      JSON.parse(self[:auth])
    rescue
      self[:auth]
    end
  end
  
end
