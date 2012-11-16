class Marketing::PeopleController < MarketingController
  
  def index
    @title = "People"
    @people = Person.active.published.with_image.shuffle
  end

  def show
    if params[:id]
      @person = Person.find_by_slug(params[:id])
      @person_projects = @person.projects.published
      @title = "People | #{@person.name}"
      render '/marketing/people/show'
    else
      @title = "People"
      @people = Person.active
      render '/marketing/people/index'
    end
  end
end
