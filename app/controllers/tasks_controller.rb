class TasksController < ApplicationController
  def index
    tasks = current_user.records.find(:all, :order => :actionable_at).map {|record|
      record.to_task
    }.reject { |task|
      task[:action].empty?
    }
    #tasks = (1..rand(20)).map {
    #  {:action => rand(300), :name => rand(100)}
    #
    respond_to do |format|
      format.html
      format.json { render json: tasks}
    end
  end
end
