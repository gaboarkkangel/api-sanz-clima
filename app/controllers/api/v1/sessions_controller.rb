class Api::V1::SessionsController < Devise::SessionsController
    
    before_action       :ensure_params_exist, only: :create
    before_action       :sign_in_params, only: :create
    before_action       :load_user, only: :create
    before_action       :valid_token, only: :destroy
    skip_before_action  :verify_signed_out_user, only: :destroy 

    # sign in
    def create
        if @user.valid_password?(sign_in_params[:password])
            sign_in "user", @user
            json_response "Signed In Successfully", true, {user: @user}, :ok
        else
            json_response "Unauthorized", false, {}, :unauthorized
        end
    end

    # log out
    def destroy
        sign_out @user
        @user.generate_new_authentication_token
        json_response "Log out successfully", true, {}, :ok
    end

    private
    def sign_in_params
       params.require(:sign_in).permit(:email, :password)        
    end

    def load_user
        @user = User.find_for_database_authentication(email: sign_in_params[:email])
        if @user
            return @user
        else
            json_response "Cannot get User", false, {}, :not_found
        end
    end

    def ensure_params_exist
        return if params[:sign_in].present?
        json_response "Missing Params", false, {}, :bad_request 
    end

    def valid_token
        @user = User.find_by authentication_token: request.headers["AUTH-TOKEN"]

        if @user
            return @user
        else
            json_response "Invalid Token", false, {}, :bad_request
        end
    end
end