class PagesController < ApplicationController

  layout 'holding'
  
  def holding
  end

  def about
  end

  def recruitment
  end

  def index
  end

  def services
  end
  
  def contact
    @phone_number = '04 123 1234'
  end
  
end
