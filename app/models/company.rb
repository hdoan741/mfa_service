class Company < ActiveRecord::Base
  before_save :generate_secret

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :app_id, :name, :secret_key

  has_many :companycustomers, :class_name => "CompanyCustomer"
  has_many :customers, through: :companycustomers

  def generate_secret
    s = OTP::Secret_Gen.new(self.email)
    secret = s.generate_secret
    self.secret_key = secret
    puts self.to_json
  end
end
