class TransactionsController < ApplicationController
  before_filter :custom_login_required
  include ActionView::Helpers

  def index

  end

  def create
    set_iphone_params if params[:format] == "json"
    @transaction = Transaction.new(params[:transaction])

    if params[:transaction_type] == "debt"
      @transaction.creditor_email = params[:email]
      @transaction.debtor         = current_user
    else
      @transaction.creditor       = current_user
      @transaction.debtor_email   = params[:email]
    end

    if @transaction.save
      if params[:format] == "json"
        render :json => @transaction
      else
        update = {
          :balances     => render_to_string(:partial => 'start/balances', :locals => {:user => current_user}),
          :transactions => render_to_string(:partial => 'transactions/recent', :locals => {:user => current_user, :transactions => current_user.transactions.sorted.find(:all, :limit => 5)})
        }
        update.merge!(global_updates)
        render :json => {
          :update => update,
          :messages => {:success => "Transaction Successfully Added"}
        }
      end
    else
      if params[:format] == "json"
        render :status => 422, :json => @transaction.errors
      else
        render :status => 422, :json => {
          :messages => {:error => "#{escape_javascript(@transaction.errors.full_messages.join('<br/>'))}"}
        }
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

  private
  def set_iphone_params
    params[:email] = params[:transaction].delete(:email)
    params[:transaction_type] = params[:transaction].delete(:transaction_type)
  end
end

