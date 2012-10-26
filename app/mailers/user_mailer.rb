class UserMailer < ActionMailer::Base
	default from: "mfaservicecs3235@gmail.com"

	def welcome_email(user)
		@user = user
		@url = root_url
		mail(:to => user.email, :subject => "Welcome to My Awesome Site")
	end

	def welcome_add_company_account_email(user)
		@user = user
		@url = root_url
		mail(:to => user.email, :subject => "You have added a sign in for a company")
	end

	def password_link_email(user, digest)
		@user = user
		@digest = digest
		@url = root_url + "/customers/" + @user.id.to_s + "/edit?confirm=" + @digest.to_s
		mail(:to => @user.email, :subject => "You have requested a link to edit details")
	end
end
