class ProjectsController < UserAuthenticatedController
  # GET /projects
  # GET /projects.json
  def index
    @projects = current_user.projects  
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        render json: current_user.projects.map {|prj| 
          prj.extended
        }
      }
    end
  end

  def display
    respond_to do |format|
      format.html #display.html
      format.json { render json: @current_project.stages_and_records }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @current_project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /projects/1/edit
  def edit
    @project = @current_project
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new params[:project]
    @project.user = current_user
    @project.save
=begin
    inflating: decision.jpg
      inflating: panel interview.jpg
          inflating: hiring manager.jpg
            inflating: phone interview.jpg
=end
    [
      ["Review", "review", "/assets/actions/review.jpg"], 
      ["Initial Contact", "contact", "/assets/actions/email.jpg"], 
      ["Phone Screen", "schedule a meeting", "/assets/actions/phone_interview.jpg"], 
      ["First Interview", "pass to manager", "/assets/actions/hiring_manager.jpg"], 
      ["Further Interviews","wait", "/assets/actions/panel_interview.jpg"], 
      ["Decision","wait", "/assets/actions/decision.jpg"], 
    ].each {|stage, action, icon|
      Stage.create! :name => stage, :action => action, :icon => icon, :project_id => @project.id
    }

    respond_to do |format|
      if @project.save
        format.json { render json: @project.extended }
      else
        format.json { render action: "new" }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    respond_to do |format|
      if @current_project.update_attributes(params[:project])
        format.html { redirect_to @current_project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @current_project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @current_project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  # GET /stages.json/1/first_stage
  def first_stage
    respond_to do |format|
      format.html { redirect_to @current_project, notice: 'Project was successfully updated.' }
      format.json { render json: @current_project.first_stage }
    end
  end
end
