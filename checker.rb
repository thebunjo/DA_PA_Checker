require 'gtk3'
require 'httparty'

class MainWindow
  def initialize
    @headers = {
      'X-RapidAPI-Key': '171c0ab42bmshaf7648e626281e9p1069f5jsne11dfc4cdf9f',
      'X-RapidAPI-Host': 'domain-da-pa-check.p.rapidapi.com'
    }

    @window = Gtk::Window.new
    @window.title = "DA/PA Checker"
    @window.set_default_size(250, 280)
    @window.signal_connect("destroy") { Gtk.main_quit }

    @vbox = Gtk::Box.new(:vertical, 5)
    @window.add(@vbox)

    @entry = Gtk::Entry.new
    @vbox.pack_start(@entry, expand: false, fill: false, padding: 5)

    @button = Gtk::Button.new(label: "Check DA/PA")
    @button.signal_connect("clicked") { checker }
    @vbox.pack_start(@button, expand: false, fill: false, padding: 5)

    @textview = Gtk::TextView.new
    @textview.editable = false
    @scrolled_window = Gtk::ScrolledWindow.new
    @scrolled_window.add(@textview)
    @vbox.pack_start(@scrolled_window, expand: true, fill: true, padding: 5)

    @window.show_all
  end

  def add_text(target, da, pa, spam)
    @textview.buffer.text += "Target: #{target}\n"
    @textview.buffer.text += "DA: #{da}\n"
    @textview.buffer.text += "PA: #{pa}\n"
    @textview.buffer.text += "Spam: #{spam}\n"
  end

    def send_req(domain)
      @response = HTTParty.get("https://domain-da-pa-check.p.rapidapi.com/?target=#{domain}", headers: @headers)

      target = @response['body']['target']
      da = @response['body']['da_score']
      pa = @response['body']['pa_score']
      spam = @response['body']['spam_score']

      add_text(target, da, pa, spam)
    end

  def checker
    @textview.buffer.text = ""
    domain = @entry.text
    send_req(domain)
  end
end

Gtk.init
MainWindow.new
Gtk.main