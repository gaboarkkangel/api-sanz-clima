class Api::V1::SessionsController < Devise::SessionsController
    
    before_action :ensure_params_exist, only: :create
    before_action :sign_in_params, only: :create
    before_action :load_user, only: :create

    # sign in
    def create
        if @user.valid_password?(sign_in_params[:password])
            sign_in "user", @user
            json_response "Signed In Successfully", true, {user: @user}, :ok
        else
            json_response "Unauthorized", false, {}, :unauthorized
        end
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
end