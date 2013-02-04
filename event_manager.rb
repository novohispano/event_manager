###
# EventManager
# by Jorge Tellez
# Completed 2/1/13
###

require "csv"
require "erb"

require_relative "phone"
require_relative "zipcode"
require_relative "date_and_time"

class EventAttendee

	def initialize(file)
		@contents = CSV.open(file, :headers => true )
	end

	def creating_letters
		puts "Creating letters for attendees"

		template_letter = File.read "form_letter.erb"
		erb_template = ERB.new template_letter

		@contents.each do |line|
			id = line[0]
			first_name = line["first_Name"]

			zipcode = ZipCode.new(line["Zipcode"])
			zipcode.clean_zipcode
			representatives = zipcode.zipcode_to_representatives(zipcode)

			form_letter = erb_template.result(binding)

			save_thank_you_letters(id, form_letter)
		end
	end

	def get_most_common_day
		puts "Getting most common day of the week"

		days = [""]
		@contents.each do |line|
			date_time = DateAndTime.new(line["RegDate"])
			days << date_time.get_days
		end

		grouped_days = days.group_by(&:to_s)
		puts "#{grouped_days.values.max_by(&:size).first}rd of the week"
	end

	def get_most_common_hour
		puts "Getting most common registration hour"

		hours = [""]
		@contents.each do |line|
			date_time = DateAndTime.new(line["RegDate"])
			hours << date_time.get_hours
		end

		grouped_hours = hours.group_by(&:to_s)
		puts grouped_hours.values.max_by(&:size).first
	end

	def get_phone_numbers
		puts "Getting phones"

		@contents.each do |line|
			phone = Phone.new(line["HomePhone"])
			puts phone
		end
	end

	def save_thank_you_letters(id, form_letter)
		Dir.mkdir("letters") unless Dir.exists? "letters"

		filename = "letters/thanks_#{id}.html"

		File.open(filename, 'w') do |file|
			file.puts form_letter
		end
	end
end

attendees = EventAttendee.new("event_attendees.csv")

# select a method to run (e.g. attendee.get_phone_numbers)