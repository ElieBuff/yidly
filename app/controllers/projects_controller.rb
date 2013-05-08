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
        }.sort_by {|prj|
          prj['job_title']
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
    [
      ["received", "review", "http://www.tienganh123.com/file/luyen-thi-toeic/part3%20practice/test%204.jpg"], 
      ["reviewed", "contact", "http://www.skinz.org/free-clipart/email-graphics/envelope-circle-clipart.gif"], 
      ["contacted", "schedule a meeting", "http://www.rock.k12.nc.us//cms/lib6/NC01000985/Centricity/Domain/153/Phone.jpg"], 
      ["meeting_scheduled", "pass to manager", "http://www.best-of-web.com/_images_300/Realistic_Style_Quarterback_Throwing_the_Football_100308-164108-094042.jpg"], 
      ["passed to manager",""], 
      ["offer",""], 
      ["closed",""]
    ].each {|stage, action, icon|
      Stage.create! :name => stage, :action => action, :icon => icon, :project_id => @project.id
    }

    respond_to do |format|
      if @project.save
        format.html { redirect_to root_path, notice: 'Project was successfully created.' }
      else
        format.html { render action: "new" }
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
end
