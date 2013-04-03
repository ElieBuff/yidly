class RecordsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user

  def correct_user
    respond_to do |format|
      format.json { render json: {:errors => ["incorrect user"]}, status: :unprocessable_entity }
    end unless (params[:id].nil? or controller_name.classify.constantize.find(params[:id]).user == current_user)
  end

  # GET /records
  # GET /records.json
  def index
    @records = current_user.records

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @records }
    end
  end

  # GET /records/1
  # GET /records/1.json
  def show
    @record = Record.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @record }
    end
  end

  # GET /records/new
  # GET /records/new.json
  def new
    @record = Record.create! :name=>params[:name], :project_id=>params[:project_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @record }
    end
  end

  # GET /records/1/edit
  def edit
  end
  
  # GET /records/1/reschedule_in_sec
  def reschedule_in_sec
    @record = Record.find(params[:id])
    @record.update_attributes({
      :actionable_at => Time.now + params[:delay].to_i
    })
    @record.save
    respond_to do |format|
      format.json { render json: @record}
    end
  end

  # GET /records/1/move_to_next_stage
  def move_to_next_stage
    respond_to do |format|
      format.json { render json: Record.find(params[:id]).move_to_next_stage }
    end
  end


  # POST /records
  # POST /records.json
  def create
    @record = Record.new(params[:record])

    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
        format.json { render json: @record, status: :created, location: @record }
      else
        format.html { render action: "new" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /records/1
  # PUT /records/1.json
  def update
    @record = Record.find(params[:id])

    respond_to do |format|
      if @record.update_attributes(params[:record])
        format.html { redirect_to @record, notice: 'Record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record = Record.find(params[:id])
    @record.destroy

    respond_to do |format|
      format.html { redirect_to records_url }
      format.json { head :no_content }
    end
  end
end
