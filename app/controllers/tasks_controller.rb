class TasksController < ApplicationController
    
    before_action :require_user_logged_in
    before_action :correct_user, only: [:edit, :show, :update, :destroy]
    
    def index
        @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
    
    def create
        @task = current_user.tasks.build(task_params)
        
        if @task.save
            flash[:success]='タスクが正常に投稿されました'
            redirect_to @task
        else
            flash.now[:danger]='タスクが正常に投稿されませんでした'
            render :new
        end
    end
    
    def new
        @task=Task.new
    end
    
    def edit
        @task=Task.find(params[:id])
    end
    
    def show
        @task=Task.find(params[:id])
    end
    
    def update
        @task=Task.find(params[:id])
       
        
        if @task.update(task_params)
            flash[:success]='タスクが正常に更新されました'
            redirect_to @task
        else
            flash.now[:danger]='タスクが正常に更新されませんでした'
            render :edit
        end
    end
    
    def destroy
        @task=Task.find(params[:id])

        @task.destroy
        
        flash[:success]='タスクが正常に削除されました'
        redirect_to tasks_url
    end
    
    private
    
    
    def task_params
        params.require(:task).permit(:status, :content)
    end
    
    def correct_user
        @task = current_user.tasks.find_by(id: params[:id])
        unless @task
          redirect_to login_path
        end
    end
end
