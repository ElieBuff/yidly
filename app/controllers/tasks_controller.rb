class TasksController < UserAuthenticatedController
  before_filter :authenticate_user!

  def all
    tasks = current_user.records.find(:all, 
                                          :order => :actionable_at, 
                                          :conditions => "rejected_at is NULL"
        ).map {|record|
          record.to_task
        }.reject { |task|
          task[:action].empty?
        }
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: all}
    end
  end


  def urgent_and_today
    tipping_point = Time.parse params[:tipping_point]
    tasks = {
      :urgent => [],
      :today => []
    }.merge all.group_by {|task|
      (task[:actionable_at] < tipping_point) ? :urgent : :today
    }
    respond_to do |format|
      format.json { render json: {
        :urgent => Hash[tasks[:urgent].sort_by {|t| t[:actionable_at]}.group_by {|t| t[:project]}.sort],
        :today => Hash[tasks[:today].sort_by {|t| t[:actionable_at]}.group_by {|t| t[:actionable_at].hour}.sort]
      }
      }

    end
  end
end
