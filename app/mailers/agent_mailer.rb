class AgentMailer < ApplicationMailer
  default from: "property_sphere@yopmail.com"

  def send_email(property, message)
    @user = params[:user]
    @url  = "http://example.com/login"
    mail(
      to: "test111@yopmail.com",
      subject: "Show of interest in property with address: #{property.address}",
      body: message
    )
  end
end
