class TasksController < ApplicationController
  def index
    tasks = current_user.records.map {|record|
      record.to_task
    }
    respond_to do |format|
      format.json { render json: tasks}
    end
  end
end
