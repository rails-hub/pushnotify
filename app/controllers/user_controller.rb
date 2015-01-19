class UserController < ApiController

  skip_before_filter :check_token!

  # username - string
  # password - string
  # email - string
  # phone - string (optional)
  def register_api
    begin
      email = register_api_params[:email].downcase
      @user = User.find_by_email(email)
      if @user.blank?
        @user = User.create(:email => email, :username => register_api_params[:username], :password => register_api_params[:password], :device_token => register_api_params[:device_token], :type => register_api_params[:type])
        PushController.push_message_to_user "Registered", @user, "Registered Successfully", @user.id
        render :json => @user
      else
        render :json => @user
      end
    rescue Exception => e
      error "Please provide all required fields"
    end
  end

  def update_password
    @user = User.find_by_auth_token(params[:auth_token]) unless params[:auth_token].nil?
    if @user.valid_password?(params[:old_password])
      begin
        @user.password = params[:new_password]
        @user.save(:validate => true)
        success "Password Changed Successfully"
      rescue
        error "Something went wrong"
      end
    else
      error "Old Password Doesn't match"
    end
  end

  def admin_log_in
  end

  # username - string (optional)
  # password - string (optional)
  # auth_token - string (optional)
  def login_api
    @user = User.find_for_database_authentication({:username => params[:username].downcase})

    if (!@user.nil?)
      if (!@user.valid_password?(params[:password]))
        @user = nil
      end
    end

    if (@user.nil?)
      @user = User.find_by_auth_token(params[:auth_token]) unless params[:auth_token].nil?
    else
      @user.generate_auth_token
    end

    if @user.nil?
      # Do nothing
      error "Your username or password was incorrect."
    else
      render json: @user
    end
  end

  def update_device_token
    @user = User.find_by_auth_token(params[:auth_token]) unless params[:auth_token].nil?
    if (!@user.nil?)
      begin
        @user.update_attribute('device_token', device_token_api_params[:device_token])
        success "Device Token updated"
      rescue
        error "Something went wrong"
      end
    else
      error "No such user exist"
    end
  end

  def register_api_params
    params.permit(:username, :password, :email, :device_token, :type)
  end

  def login_api_params
    params.permit(:username, :password, :auth_token)
  end

  def device_token_api_params
    params.permit(:device_token, :auth_token)
  end

end
