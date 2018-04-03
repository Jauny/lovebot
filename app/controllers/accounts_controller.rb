class AccountsController < ApplicationController
  def create
    account = Account.update_or_create_from_auth_hash(auth_hash)
    session[:account_name] = account.name
    redirect_to root_path
  end

  def logout
    reset_session
    redirect_to root_path
  end

  def spread_the_love
    account = Account.find(params[:id])
    account.spread_the_love
    account.update active: true

    redirect_to root_path
  end

  def stop
    account = Account.find(params[:id])
    account.update(active: false)

    redirect_to root_path
  end

  private
  def auth_hash
    request.env['omniauth.auth']
  end
end