class TransactionsController < ApplicationController
  before_filter :custom_login_required
  
  include ActionView::Helpers
  
  def index
    
  end
  
  def create
    @transaction = Transaction.new(params[:transaction])
    if params[:transaction_type] == "debt"
      @transaction.creditor_email = params[:email]
      @transaction.debtor         = current_user
    else
      @transaction.creditor       = current_user
      @transaction.debtor_email   = params[:email]
    end
    
    if @transaction.save
      update = {:balances => render_to_string(:partial => 'start/balances', :locals => {:user => current_user})}
      update.merge!(global_updates)
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
