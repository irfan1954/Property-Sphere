class SavedPropertiesController < ApplicationController
  def index
    @bookmarks = SavedProperty.where(user_id: current_user.id)
  end

  def create
    @saved_property = SavedProperty.new
    @saved_property.user_id = current_user.id
    @saved_property.property_id = params[:property_id]
    if @saved_property.save!
      flash[:notice] = 'Added to wishlist'
    else
      flash[:alert] = 'There was an error'
    end
  end

  def destroy
    @saved_property = SavedProperty.find(params[:id])
    @saved_property.destroy
  end

  private

  def saved_properties_param
    params.require(:saved_properties).permit(:property_id)
  end
end
