require 'spec_helper'

describe Invoice do

  describe "creating a new invoice" do
    before(:each) do
      @invoice = Invoice.new Invoice.plan
    end
    it "should be successful" do
      @invoice.save.should be_true
    end
  end

  describe "an unpaid invoice" do
    before(:each) do
      @invoice = Invoice.make(:paid => false)
    end

    describe "with 1 allocation" do
      before(:each) do
        @allocation = make_invoice_allocation_for(@invoice, Person.make)
      end

      it "should have many invoice_allocations" do
        @invoice.allocations.should include(@allocation)
      end

      it "should disburse funds upon payment" do
        @allocation.should_receive(:disburse).and_return true
        @invoice.stub(:allocations).and_return([@allocation])
        @invoice.mark_as_paid
        @invoice.paid.should be_true
      end

      it "should summ allocated amount correctly" do
        a2 = make_invoice_allocation_for(@invoice, Person.make, 0.1)
        @invoice.allocated.should == @allocation.amount + a2.amount
      end

      it "should destroy the allocations when destroyed" do
        @invoice.destroy
        lambda {
          @allocation.reload
        }.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should not allow a paid invoice to be destroyed" do
        @invoice.mark_as_paid
        lambda {
          @invoice.destroy
        }.should raise_error
      end
    end
  end

  describe "named scopes" do
    it "should find paid invoices" do
      invoice = Invoice.make
      Invoice.paid.should_not include(invoice)
      invoice.mark_as_paid
      Invoice.paid.should include(invoice)
    end

    it "should find unpaid invoices" do
      i = Invoice.make(:paid => nil)
      i2 = Invoice.make(:paid => false)

      Invoice.unpaid.should include(i)
      Invoice.unpaid.should include(i2)
      i.mark_as_paid
      i2.mark_as_paid
      Invoice.unpaid.should_not include(i)
      Invoice.unpaid.should_not include(i2)
    end
  end
end