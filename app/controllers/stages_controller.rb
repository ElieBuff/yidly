class StagesController < UserAuthenticatedController
  # GET /stages
  # GET /stages.json
  def index
    @stages = params[:project_id] ? Stage.find_all_by_project_id(params[:project_id], :order => :position) : Stage.all

    respond_to do |format|
      format.json { render json: @stages }
    end
  end

  # GET /stages/1
  # GET /stages/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @current_stage }
    end
  end

  # GET /stages/new
  # GET /stages/new.json
  def new
    respond_to do |format|
      stage = Stage.new(:project_id => params[:project_id], :name => params[:name], :action => params[:action_name])
      begin
        stage.update_position(params[:position]) 
        format.json { 
          render json: stage
        }
      rescue
        format.json { 
          render :json => {:errors => stage.errors}, :status => :unprocessable_entity 
        }
      end
    end
  end

  #GET /stages/1/edit
  def edit
  end

  # PUT /stages/1
  # PUT /stages/1.json
  def update
    respond_to do |format|
      if @current_stage.update_attributes(params[:stage])
        format.html { redirect_to @current_stage, notice: 'Stage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @current_stage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stages/1
  # DELETE /stages/1.json
  def destroy
    @current_stage.destroy

    respond_to do |format|
      format.html { redirect_to stages_url }
      format.json { head :no_content }
    end
  end
end
