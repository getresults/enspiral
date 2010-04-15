class Admin::InvoicesController < Admin::Base
  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(params[:invoice])
    if @invoice.save
      redirect_to admin_invoice_path(@invoice)
    else
      render :new
    end
  end

  def index
    @invoices = Invoice.unpaid
  end

  def old
    @invoices = Invoice.paid
    render :index
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_allocation = InvoiceAllocation.new(:invoice_id => @invoice.id)
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    if @invoice.destroy
      flash[:notice] = "Invoice destroyed"
    else
      flash[:error] = "Could not destroy invoice"
    end
    redirect_to admin_invoices_path
  end

end
