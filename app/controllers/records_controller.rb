class RecordsController < UserAuthenticatedController
  # GET /records
  # GET /records.json
  def index
    if params[:project_id]
      @project = Project.find(params['project_id'])
      @records = @project.records.find_all
    else
      @records = current_user.records
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @records }
    end
  end

  # GET /records/1
  # GET /records/1.json
  def show
    @record = @current_record
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @record }
    end
  end

  def set_first_stages_with_project_name
    @first_stages_with_project_name = current_user.first_stages.collect {|p| [ p.project.job_title, p.id ] }
  end
  # GET /records/new
  # GET /records/new.json
  def new
    @current_record = Record.new 
    set_first_stages_with_project_name

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /records/1/edit
  def edit
    @first_stages_with_project_name = current_user.first_stages.collect {|p| [ p.project.job_title, p.id ] }
  end
  
  # GET /records/1/reschedule_in_sec
  def reschedule_in_sec
    respond_to do |format|
      format.json { render json: @current_record.reschedule_in_sec(params[:delay].to_i)}
    end
  end

  # GET /records/1/reschedule_in_sec
  def wait_for_sec
    respond_to do |format|
      format.json { render json: @current_record.wait_for_sec(params[:delay].to_i)}
    end
  end


  # GET /records/1/move_to_next_stage
  def move_to_next_stage
    respond_to do |format|
      format.json { render json: @current_record.move_to_next_stage }
    end
  end

  # GET /records/1/move_to_stage/1
  def move_to_stage
    respond_to do |format|
      format.json { render json: @current_record.move_to_stage(params[:stage].to_i) }
    end
  end

  # GET /records/1/reject
  def reject
    respond_to do |format|
      format.json { render json: @current_record.reject }
    end
  end


  def my_edit
    record = @current_record.update_attributes(params.select { |k,v|
                                Record.attribute_names.include? k.to_s
                            })
    respond_to do |format|
      format.json { render json: record }
    end

  end
  def my_create
    record = Record.create(params.select { |k,v|
                                Record.attribute_names.include? k.to_s
                            })
    respond_to do |format|
      format.json { render json: record }
    end
  end

  # POST /records
  # POST /records.json
  def create
    @record = Record.new(params[:record])
    respond_to do |format|
      if @record.save
        format.html { redirect_to root_path, notice: 'Record was successfully created.' }
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
    respond_to do |format|
      if @current_record.update_attributes(params[:record])
        format.html { redirect_to @current_record, notice: 'Record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @current_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @current_record.destroy

    respond_to do |format|
      format.html { redirect_to records_url }
      format.json { head :no_content }
    end
  end
end
