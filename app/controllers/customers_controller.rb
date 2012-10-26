class CustomersController < ApplicationController
  require "digest"
  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.json
  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    # check if valid request
    
    @digest = params[:confirm]
    @customer2 = Customer.find(params[:id])

    @digest2 = Digest::MD5.hexdigest(@customer2.email)

    if @digest.to_s == @digest2.to_s
      @customer = Customer.find(params[:id])
    else
      # invalidate the request
      @customer = nil
    end

  end

  # POST /customers
  # POST /customers.json
  def create
    respond_to do |format|
      puts params
      @customer = Customer.new(
        :email => params[:email],
        :name => params[:name],
        :phone => params[:phone],
        :verified => false)
      @company = Company.find(params[:company_id])
      puts @company
      @customer2 = Customer.find_by_email(@customer.email)
      puts @customer2

      @account_created = false
      if @customer2.nil?
        if @customer.save
          puts "success"
          @account_created = true
        else 
          puts "unsucessful"
        end
      else
        puts "account exists. Proceeding to create entry in CompanyCustomer table"
      end

      # TODO: Send OTP 
      if @account_created 
        # Tell the UserMailer to send a welcome Email after save
        @user = @customer
        UserMailer.welcome_email(@user).deliver
      else
        # Nothing
      end

      @customer2 = Customer.find_by_email(@customer.email)
      @customer_company = CompanyCustomer.new(
        :company_id => @company.id, 
        :customer_id => @customer2.id)


      if @customer_company.save
        
        # Tell the User mailer to send a add company account email
        #@user = @customer2
        UserMailer.welcome_add_company_account_email(@user).deliver

        format.html { redirect_to @customer_company, notice: 'Customer Company was successfully created.' }
        format.json { render json: @customer_company, status: :created}
      else
        format.html { render action: "new" }
        format.json { render json: @customer_company.errors, status: :unprocessable_entity }
      end


    end

  end

  # PUT /customers/1
  # PUT /customers/1.json
  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end
end
