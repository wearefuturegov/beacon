Rails.application.configure do
  console do
    PaperTrail.request.whodunnit = ->() {
      @paper_trail_whodunnit ||= (
        name = nil
        until name.present? do
          print "What is your name (used by PaperTrail to record who changed records)? "
          name = gets.chomp
        end
        puts "Thank you, #{name}! Have a wonderful time!"
        name
      )
    }
  end
end
