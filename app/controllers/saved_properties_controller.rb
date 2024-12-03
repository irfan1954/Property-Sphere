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

  def update
    @saved_property = SavedProperty.find(params[:id])
    if @saved_property.update(comment_param)
      respond_to do |format|
        format.turbo_stream # For Turbo updates
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
    redirect_to saved_properties_path, notice: "Bookmark deleted." if @saved_property.destroy
  end

  private

  def saved_properties_param
    params.require(:saved_property).permit(:property_id)
  end

  def comment_param
    params.require(:saved_property).permit(:comment)
  end
end
