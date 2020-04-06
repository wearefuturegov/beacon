# frozen_string_literal: true

Rails.application.configure do
  console do
    PaperTrail.request.whodunnit = lambda {
      @paper_trail_whodunnit ||= begin
        name = nil
        until name.present?
          print 'What is your name (used by PaperTrail to record who changed records)? '
          name = gets.chomp
        end
        puts "Thank you, #{name}! Have a wonderful time!"
        name
      end
    }
  end
end
