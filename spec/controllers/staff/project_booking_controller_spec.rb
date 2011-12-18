require 'spec_helper'

describe Staff::ProjectBookingsController do

  before(:each) do
    @user = User.make
    @user.save!

    @person = Person.make :user => @user
    @person.save!

    @project = Project.make!
    @project_membership = ProjectMembership.make! :person => @person, :project => @project

    log_in @user
    controller.stub(:current_person) { @person }
  end

  describe "GET index" do
    it "assigns default_time_available as the users default time" do
      get :index
      assigns(:default_time_available).should eq(@person.default_hours_available)
    end

    it 'assigns all the project bookings that the user owns, with no dates given' do
      project_times = Hash.new
      project_times[(Date.today).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today).time
      project_times[(Date.today + 1.week).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today + 1.week).time
      project_times[(Date.today + 2.week).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today + 2.week).time
      project_times[(Date.today + 3.week).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today + 3.week).time
      project_times[(Date.today + 4.week).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today + 4.week).time


      ProjectBooking.make! :person => @person, :project => @project, :week => Date.today + 5.weeks


      get :index
      assigns(:project_bookings).should eq({@project.id => project_times})

    end

    it 'assigns all the project bookings for the given dates that the user owns' do
      ProjectBooking.make! :person => @person, :project => @project, :week => Date.today

      project_times = Hash.new
      project_times[(Date.today + 1.week).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today + 1.week).time
      project_times[(Date.today + 2.week).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today + 2.week).time
      project_times[(Date.today + 3.week).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today + 3.week).time
      project_times[(Date.today + 4.week).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today + 4.week).time
      project_times[(Date.today + 5.week).beginning_of_week] = ProjectBooking.make!(:person => @person, :project => @project, :week => Date.today + 5.week).time



      get :index, :dates => [Date.today + 1.week, Date.today + 2.weeks, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks]
      assigns(:project_bookings).should eq({@project.id => project_times})
    end

    it 'assigns project_bookings_sum as the sum of all the projects time for no given weeks' do
      project = Project.make!
      project_membership = ProjectMembership.make! :person => @person, :project => project

      bookings_sum = Hash.new
      for i in (0..6)
        ProjectBooking.make! :person => @person, :project => project, :week => Date.today + i.weeks, :time => 20
        ProjectBooking.make! :person => @person, :project => @project, :week => Date.today + i.weeks, :time => 30
        if i < 5
          bookings_sum[(Date.today + i.weeks).beginning_of_week] = 50
        end
      end

      get :index
      assigns(:project_bookings_sum).should eq(bookings_sum)
    end

    it 'assigns project_bookings_sum as the sum of all the projects time for the given weeks' do
      project = Project.make!
      project_membership = ProjectMembership.make! :person => @person, :project => project

      bookings_sum = Hash.new
      for i in (0..6)
        ProjectBooking.make! :person => @person, :project => project, :week => Date.today + i.weeks, :time => 20
        ProjectBooking.make! :person => @person, :project => @project, :week => Date.today + i.weeks, :time => 30
        if i > 1
          bookings_sum[(Date.today + i.weeks).beginning_of_week] = 50
        end
      end

      get :index, :dates => [Date.today + 2.week, Date.today + 3.weeks, Date.today + 4.weeks, Date.today + 5.weeks, Date.today + 6.weeks]
      assigns(:project_bookings_sum).should eq(bookings_sum)

    end
  end

  describe "GET edit" do
    it "assigns a given project's bookings for the next five weeks as @project_bookings, when no dates are specified" do
      
      #get :edit, :project_booking_ids
      #assigns(:project_bookings).should eq()
    end

    it "assigns a given project's bookings for the next five weeks as @project_bookings, when no dates are specified" do
      
      #get :edit, :project_booking_ids
      #assigns(:project_bookings).should eq()
    end

  end

  describe "PUT update" do
    before(:each) do
      @av1 = ProjectBooking.make! :person => @person, :week => Date.today + 8
      @av2 = ProjectBooking.make! :person => @person, :week => Date.today + 16
    end

  it "updates or creates a batch of given project_bookings" do
      before_time = @av2.time
      put :update, :project_bookings => [{:id => @av1.id, :time => @av1.time}, {:id => @av2.id, :time => before_time + 5}]
      ProjectBooking.last.time.should == before_time + 5
    end

    it "redirects to the project_bookings list" do
      put :update, :project_bookings => [{:id => @av1.id, :time => @av1.time}, {:id => @av2.id, :time => @av2.time}]
      response.should redirect_to(staff_capacity_url)
    end
  end
end

