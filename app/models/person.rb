class Person < ActiveRecord::Base
  is_gravtastic! :rating => 'PG'
  
  has_many :worked_on, :dependent => :destroy
  has_many :projects, :through => :worked_on
  has_many :invoice_allocations
  
  has_one :account, :dependent => :destroy

  belongs_to :user, :dependent => :destroy
  belongs_to :team

  accepts_nested_attributes_for :user
  
  validates_presence_of :email

  after_create :create_account

  def name
    "#{first_name} #{last_name}"
  end

  def allocated_total
    sum_allocations_less_commission(invoice_allocations)
  end

  def pending_total
    sum_allocations_less_commission(invoice_allocations.pending)
  end

  private
  def create_account
    Account.create(:person_id => id)
  end

  def sum_allocations_less_commission allocations
    allocations.inject(0) {|total,allocation| total += allocation.amount * (1 - allocation.commission)}
  end
end
