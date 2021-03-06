class CustomersController < ApplicationController
  before_action :logged_in_customer, only: [:topup, :show, :profile, :edit, :update]
  before_action :correct_customer,   only: [:topup, :show, :profile, :edit, :update]

  def index
    @customers = Customer.paginate(page:params[:page])
    @customers.per_page = 10
  end

  def new
    if logged_in?
      redirect_to current_user
    end
  @customer = Customer.new
  end

  def profile
    @customer = Customer.find(params[:id])
  end

  def gopay
    @customer = Customer.find(params[:id])
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update_attributes(customer_params)
      flash[:success] = "Profile updated"
      redirect_to @customer
    else
      render 'edit'
    end
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      log_in @customer
      flash[:success] = "Welcome to the Go-jek Web Services App"
      redirect_to @customer
    else
      render 'new'
    end
  end

  def orders
    @customer = Customer.find(params[:id])
    @orders = @customer.orders
  end

  def topup
    @customer = Customer.find(params[:id])
  end

  def commit_topup
    @customer = Customer.find(params[:id])

    credit = params[:customer][:gopay]
    if credit.to_i != 0 && !credit.match(/[^0-9]/)
      if @customer.gopay_id.nil?
        new_credit = @customer.create_gopay_service(credit.to_f)
        params[:customer][:gopay_id] = new_credit[:id]
      else
        new_credit = @customer.add_gopay_service(credit.to_f)
        params[:customer][:gopay] = new_credit[:credit]
      end
    end

    if @customer.update(gopay_params)
      flash[:success] = "Topup Success"
      redirect_to @customer
    else
      render 'topup'
    end
  end

  private

    def customer_params
      params.require(:customer).permit(:name, :email, :phone, :password, :password_confirmation, :gopay_id)
    end

    def gopay_params
      params.require(:customer).permit(:gopay, :gopay_id)
    end

    def logged_in_customer
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_customer
      @customer = Customer.find(params[:id])
      redirect_to(root_url) unless @customer == @current_user
    end
end
