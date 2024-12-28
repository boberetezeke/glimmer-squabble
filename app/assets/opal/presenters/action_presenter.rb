class ActionPresenter
  def play_pressed
    @play_pressed.call
  end

  def pass_pressed
    @pass_pressed.call
  end

  def on_play_pressed(&block)
    @play_pressed = block
  end

  def on_pass_pressed(&block)
    @pass_pressed = block
  end
end
