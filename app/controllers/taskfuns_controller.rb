class TaskfunsController < WebsocketRails::BaseController
  def initialize_session
    controller_store[:message_count] = 0
  end
  def get_all
   #tasks = current_user.records.map {|record|
    #  record.to_task
    #} 
    tasks = (1..rand(20)).map {
      {:action => rand(300), :name => rand(100)}
    }
    p tasks
  
    send_message :receive_all, tasks, :namespace => :tasks
  end
end
