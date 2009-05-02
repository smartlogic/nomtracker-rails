class TransactionsController < ApplicationController
  before_filter :custom_login_required
  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction.valid?
    unless @transaction.creditor == current_user or @transaction.debtor == current_user
      @transaction.errors.add("You", "must be the creditor or debtor of this transaction")
    end
    render :update do |page|
      if @transaction.errors.empty? and @transaction.save
        page.replace_html 'report',
          :partial => '/start/report', 
          :locals => { :user => current_user } 
        page.replace_html 'debt-form', :partial => '/start/add_debt' 
      else
        page.replace_html 'flash', @transaction.errors.full_messages.join("<br/>")
      end
    end
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update_attributes(params[:transaction])
      head :ok
    else
      update_flash @transaction.errors
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    if @transaction.destroy
      head :ok
    else
      update_flash @transaction.errors
    end
  end
end
