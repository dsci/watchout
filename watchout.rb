require 'yaml'

Shoes.app :width => 240, :height => 300 do
  @seconds = 0
  @paused = true
  


  image "statics/IMG_0040.jpg"

  def projects
    YAML::load(File.open("#{Dir.home}/.watchout/projects.yml"))
  end

  @project = projects.first

  def write_project(seconds)
    day = Time.now
    content_line = "#{@project};#{day.day}.#{day.month}.#{day.year};#{seconds}\n"
    File.open("#{Dir.home}/.watchout/spent.csv", 'a') {|f| f.write(content_line) }
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

  @display = stack :margin => 20
  display_time

  button "Start", :width => '25%' do
    @paused = false
    display_time
  end

  button "Pause", :width => '25%' do
    @paused = !@paused
    display_time
  end

  button "Stop", :width => '25%' do
    @paused = true
    write_project(@seconds)
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