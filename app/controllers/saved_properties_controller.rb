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
      flash[:alert] = 'There was an error'
      redirect_to request.referrer
    end
  end

  def agent_create
    @saved_property = SavedProperty.new(saved_properties_params)
    @saved_property.user_id = current_user.id
    if @saved_property.save
      flash[:notice] = 'Added to wishlist'

      AgentMailer.with(user: current_user).send_email(@saved_property, saved_properties_param[:message])

      format.html { redirect_to saved_properties_path, notice: "Email was sent successfully" }

    else
      flash[:alert] = 'There was an error'
    end
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
