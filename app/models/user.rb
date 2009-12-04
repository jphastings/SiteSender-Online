class User < ActiveRecord::Base
  has_many :bookmarks
  acts_as_authentic
  
  def initialize(options = nil)
    super(options)
    changetoken
  end
  
  def changetoken
    self.token = Digest::SHA1.hexdigest(rand(10000).to_s<<Time.now.to_s<<rand(10000).to_s)
  end
end
