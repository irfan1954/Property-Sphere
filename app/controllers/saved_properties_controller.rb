class SavedPropertiesController < ApplicationController
  def index
    @saved_property = SavedProperty.all
  end

  # Is new necessary with no form needed?
        # def new
        #   @saved_property = SavedProperty.new
        # end

  def create
    # Property should be added to saved_properties list
    @saved_property = SavedProperty.new(saved_properties_param)
    @saved_property.user_id = current_user.id
    @saved_property.save!
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
