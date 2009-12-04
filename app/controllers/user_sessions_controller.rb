class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
    
  def new_api
    @user_session = UserSession.new(params.slice(:email,:password))
    respond_to do |format|
      if @user_session.save
        @user_session.user.send_ip = request.remote_ip
        if @user_session.user.save
          format.json { render :json => {:success => true} }
        else
          format.json { render :json => {:success => false, :message => 'couldn\'t save your ip address'} }
        end
      else
        format.json { render :json => {:success => false, :message => 'incorrect username or password'}, :status => :unauthorized }
      end
    end
  end
end
