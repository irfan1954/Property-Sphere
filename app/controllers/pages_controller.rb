class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @postcodes = Location.all_postcodes
  end
end
