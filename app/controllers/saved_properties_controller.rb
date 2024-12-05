class SavedPropertiesController < ApplicationController
  def index
    @bookmarks = SavedProperty.where(user_id: current_user.id)
  end

  def create
    @saved_property = SavedProperty.new
    @saved_property.user_id = current_user.id
    @property = Property.find(params[:property_id])
    @saved_property.property = @property
    if @saved_property.save
      flash[:notice] = 'Added to wishlist'
      redirect_to request.referrer
    else
      flash[:alert] = 'Already in your wishlist'
      redirect_to request.referrer
    end
  end

  def agent_create
    @property = Property.find(params[:property_id])
    # Check if the property already exists for the current user
    @saved_property = SavedProperty.find_or_initialize_by(user_id: current_user.id, property_id: @property.id)

    if @saved_property.new_record?
      # If it's a new record, assign the additional attributes and save
      @saved_property.assign_attributes(saved_properties_param)
      if @saved_property.save
        flash[:notice] = 'Added to wishlist'
      else
        flash[:alert] = 'There was an error saving the property'
        return
      end
    else
      # If the record exists, update the `contacted` status
      @saved_property.contacted = true
      @saved_property.save
    end
    # AgentMailer.with(user: current_user).send_email(@saved_property, saved_properties_params[:message])
    format.html { redirect_to saved_properties_path, notice: "Email was sent successfully" }
  end

  def update
    @saved_property = SavedProperty.find(params[:id])
    if @saved_property.update(comment_param)
      respond_to do |format|
        format.json # For Turbo updates
        format.html { redirect_to bookmarks_path, notice: "Comment updated successfully." }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @saved_property = SavedProperty.find(params[:id])
    redirect_to saved_properties_path, notice: "Bookmark removed" if @saved_property.destroy
  end

  private

  def saved_properties_param
    params.require(:saved_property).permit(:property_id, :message, :comment)
  end

  def comment_param
    params.require(:saved_property).permit(:comment)
  end
end
