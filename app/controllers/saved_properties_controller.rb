class SavedPropertiesController < ApplicationController
  def index
    @saved_properties = SavedProperty.where(user_id: current_user.id)
  end

  def create
    @saved_property = SavedProperty.new(saved_properties_param)
    @saved_property.user_id = current_user.id
    @saved_property.save!
  end

  def show
    @saved_property = current_user.saved_properties.select { |property| property.id == params[:id] }
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
