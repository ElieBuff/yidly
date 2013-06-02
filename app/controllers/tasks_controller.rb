class TasksController < UserAuthenticatedController
  HOUR = 3600
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


  def time_slot(timestamp, point_before, point_after, before, between, after)
    (timestamp < point_before) ? before :
      (timestamp < point_after) ? between : after
  end
  def urgent_and_today
    tipping_point_today = Time.at params[:tipping_point].to_i/1000
    tipping_point_later = tipping_point_today + 24*HOUR
    tasks = {
      :urgent => [],
      :today => [],
      :later => []
    }.merge all.group_by {|task|
      time_slot task[:actionable_at], tipping_point_today, tipping_point_later, :urgent, :today, :later
    }
    respond_to do |format|
      format.json { render json: {
        :urgent => Hash[tasks[:urgent].sort_by {|t| t[:actionable_at]}.group_by {|t| t[:project]}.sort],
        :today => Hash[tasks[:today].sort_by {|t| t[:actionable_at]}.group_by {|t| Time.at t[:actionable_at].beginning_of_hour}.sort],
        :later => Hash[tasks[:later].sort_by {|t| t[:actionable_at]}.group_by {|t| t[:actionable_at].beginning_of_day}.sort]
      }
      }

    end
  end
end
