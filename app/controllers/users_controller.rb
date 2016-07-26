class UsersController < ApplicationController

  def new
    @user = User.new
  end

###################### Twilio Auth ########################

  def create  
    @user = User.new(user_params)
    if @user.save

    # Save the user_id to the session object
    session[:current_user] = @user.id

    # Create user on Authy, will return an id on the object
    authy = Authy::API.register_user(
      email: @user.email,
      cellphone: @user.phone,
      country_code: @user.country_code
    )
    @user.update(authy_id: authy.id)

    # Send an SMS to your user
    Authy::API.request_sms(id: @user.authy_id)
    redirect_to verify_path

    else
      render :new
    end
  end

  def verify
    @user = current_user
    # Use Authy to send the verification token
    token = Authy::API.verify(id: @user.authy_id, token: params[:token])

    if token.ok?
      # Mark the user as verified for get /user/:id
      @user.update(verified: true)

      # Send an SMS to the user 'success'
      send_message("You did it! Signup complete :)")

      # Show the user profile
      redirect_to user_path(@user.id)
    else
      flash.now[:danger] = "Incorrect code, please try again"
      render :show_verify
    end
  end

  def resend
    @user = current_user
    Authy::API.request_sms(id: @user.authy_id)
    flash[:notice] = "Verification code re-sent"
    redirect_to verify_path
  end

  def send_message(message)
    @user = current_user
    twilio_number = '9146103945'
    @client = Twilio::REST::Client.new ENV['twilio_account_sid'], ENV['twilio_auth_token']
    message = @client.account.messages.create(
      :from => twilio_number,
      :to => @user.country_code+@user.phone,
      :body => message
    )
    puts message.to
  end

########################################################

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    @user.update(user_params)

    if @user.save
      redirect_to @user

      # CHANGE THE LANDING PAGE AFTER UPDATING
    else
      render :show
    end    
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :country_code, :phone, :username, :password)
  end

end