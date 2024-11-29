class ContactFormController < ApplicationController
  before_action :set_property, only: %i[create]

  def create
    @name = params[:contact_form][:name]
    @last_name = params[:contact_form][:last_name]
    @email = params[:contact_form][:email]
    @message = params[:contact_form][:message]

    # Perform any necessary actions with the form data
    flash[:success] = "Your message has been sent successfully."
    redirect_to property_path(@property)

  end

  private
  def set_property
    @property = Property.find(params[:id])
  end
end
