class MarketingController < ApplicationController
  def person
  end

  def country
  end

  def company
  end

  def companies
    @companies = Company.all
    render '/marketing/companies/index'
  end

  def project
  end
end
