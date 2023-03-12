class TestsController < Simpler::Controller

  def index

    render plain: "Plain text response\n"
    # render 'tests/index'
  end

  def create

  end

end
