class TransactionsController < ApplicationController
  before_filter :custom_login_required
  
  include ActionView::Helpers
  
  def create
    @transaction = Transaction.new(params[:transaction])
    if params[:transaction_type] == "debt"
      @transaction.creditor = User.find_by_email(params[:email])
      @transaction.debtor   = current_user
    else
      @transaction.creditor = current_user
      @transaction.debtor   = User.find_by_email(params[:email])
    end
    
    if @transaction.save
      if params[:transaction_type] == "debt"
        content = render_to_string(:partial => '/start/debt_report', :locals => {:user => current_user})
        update = {:debts => content}
      else
        content = render_to_string(:partial => '/start/credit_report', :locals => {:user => current_user})
        update = {:credits => content}
      end
      # pending_content = render_to_string(:partial => '/start/pending_report', :user => current_user)
      render :json => {
        :update => update,
        :messages => {:success => "Transaction Successfully Added"}
      }
    else
      render :status => 422, :json => {
        :messages => {:error => "#{escape_javascript(@transaction.errors.full_messages.join('<br/>'))}"}
      }
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
