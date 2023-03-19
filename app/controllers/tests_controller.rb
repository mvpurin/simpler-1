class TestsController < Simpler::Controller

  def index
    # render plain: "Plain text response\n"
    render 'tests/index'
    status 200
  end

  def create
    status 201
  end

  def show
    # status 200
    @test_id = params[:id].to_i
    render 'tests/show'
  end

end
