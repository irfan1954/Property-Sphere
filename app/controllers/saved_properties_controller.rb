class SavedPropertiesController < ApplicationController
  def index
    @bookmarks = SavedProperty.where(user_id: current_user.id)
  end

  def create
    @property = Property.find(params[:property_id])
    @saved_property = SavedProperty.find_or_initialize_by(user_id: current_user.id, property_id: @property.id)

    if @saved_property.new_record?
      # If it's a new record, assign the additional attributes and save
      @saved_property.contacted = true
      if @saved_property.save
        flash[:notice] = 'Sent and added to wishlist'
        redirect_to request.referrer
      else
        flash[:alert] = 'There was an error saving the property'
        redirect_to request.referrer
        return
      end
    else
      # If the record exists, update the `contacted` status
      @saved_property.contacted = true
      @saved_property.save
      redirect_to request.referrer
      flash[:notice] = 'Message sent'
    end
    # AgentMailer.with(user: current_user).send_email(@saved_property, saved_properties_params[:message])
    # format.html { redirect_to saved_properties_path, notice: "Email was sent successfully" }
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
    params.require(:saved_property).permit(:property_id)
  end

  def comment_param
    params.require(:saved_property).permit(:comment)
  end
end
