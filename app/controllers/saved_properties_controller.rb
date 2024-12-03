class SavedPropertiesController < ApplicationController
  def index
    @bookmarks = SavedProperty.where(user_id: current_user.id)
  end

  def create
    @saved_property = SavedProperty.new
    @saved_property.user_id = current_user.id
    @saved_property.property_id = saved_properties_param[:property_id]
    if @saved_property.save!
      flash[:notice] = 'Added to wishlist'

      AgentMailer.with(user: current_user).send_email(@saved_property, saved_properties_param[:message])

      format.html { redirect_to saved_properties_path, notice: "Email was sent successfully" }

    else
      flash[:alert] = 'There was an error'
    end
  end

  def destroy
    @saved_property = SavedProperty.find(params[:id])
    redirect_to saved_properties_path, notice: "Bookmark deleted." if @saved_property.destroy
  end

  private

  def saved_properties_param
    params.require(:saved_properties).permit(:property_id, :message, :comment)
  end
end
