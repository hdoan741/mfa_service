class UserMailer < ActionMailer::Base
	default from: "mfaservicecs3235@gmail.com"

	def welcome_email(user)
		@user = user
		@url = "http://example.com/login"
		mail(:to => user.email, :subject => "Welcome to My Awesome Site")
	end

	def welcome_add_company_account_email(user)
		@user = user
		@url = "http://example.com/login"
		mail(:to => user.email, :subject => "You have added a sign in for a company")
	end
end
