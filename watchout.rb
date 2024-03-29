require 'yaml'

Shoes.app :width => 240, :height => 330 do
  @seconds = 0
  @paused = true

  @what_yo_doing_text = "What are you doing?"

  image "statics/IMG_0040.jpg"

  def projects
    YAML::load(File.open("#{Dir.home}/.watchout/projects.yml"))
  end

  @project = projects.first

  def write_project(seconds)
    begin 
      day = Time.now
      time_spent = sprintf("%02d:%02d:%02d",(seconds / (60*60)),(seconds / 60 % 60),(seconds % 60))
      content_line = "#{@project};#{day.day}.#{day.month}.#{day.year};#{time_spent};#{@what_yo_doing.text}\n"
      File.open("#{Dir.home}/.watchout/spent.csv", 'a') {|f| f.write(content_line) }
      alert "Spent time written!"
    rescue
      alert "Somethin went wrong. Sry. :-("
    end
  end

  list_box :items => projects,:width=>240,:choose => projects.first do |list|
    @project = list.text
  end

  def display_time
    @display.clear do
      title "%02d:%02d:%02d" % [
        @seconds / (60*60),
        @seconds / 60 % 60,
        @seconds % 60
      ], :stroke => @paused ? gray : black
    end
  end

  def init_what_yo_doing_line(str=nil)
    str = @what_yo_doing_text if str.nil?
    @what_yo_doing.text = str
  end

  @what_yo_doing = edit_line :width => 230   
  init_what_yo_doing_line

  @display = stack :margin => 20
  display_time

  button "Start", :width => '25%' do
    @paused = false
    display_time
    if @what_yo_doing.text.eql?(@what_yo_doing_text)
      init_what_yo_doing_line("")
    end
    @what_yo_doing.focus
  end

  button "Pause", :width => '25%' do
    @paused = !@paused
    display_time
  end

  button "Stop", :width => '25%' do
    @paused = true
    write_project(@seconds)
    init_what_yo_doing_line
    @seconds = 0
  end
  
  button "Reset", :width => '25%' do
    @seconds = 0
    display_time
  end

  animate(1) do
    @seconds += 1 unless @paused
    display_time
  end

  
end