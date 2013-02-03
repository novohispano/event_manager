###
# EventManager
# by Jorge Tellez
# Completed 2/1/13
###

require "csv"
require "sunlight"
require "erb"
require "date"

Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"

class Date_and_Time

	def initialize(date)
		@date = DateTime.strptime(date, "%m/%d/%y %k:%M")
	end

	def get_hours
		hours = @date.hour
	end

	def get_days
		days = @date.wday
	end	
end

class Phone
	
	def initialize(phone)
		@phone = phone.tr("-. \(\)", "")
	end

	def clean_phone
		phone_length = @phone.length
		case phone_length
			when 0..9
				@phone = "0000000000"
			when 10
				@phone
			when 11
				if @phone[0] == "1"
				  @phone = @phone[1..9]
				else
				  @phone = "0000000000"
				end
			else
				@phone = "0000000000"
		end
	end
end 

class ZipCode

	def initialize(zipcode)
		@zipcode = zipcode
	end

	def clean_zipcode
		if @zipcode.nil?
			"00000"
		else
			"0"*(5 - @zipcode.length) + @zipcode
		end
	end

	def zipcode_to_representatives(zipcode)
		Sunlight::Legislator.all_in_zipcode(@zipcode)
	end
end

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
			date_time = Date_and_Time.new(line["RegDate"])
			days << date_time.get_days
		end

		grouped_days = days.group_by(&:to_s)
		puts "#{grouped_days.values.max_by(&:size).first}rd of the week"
	end

	def get_most_common_hour
		puts "Getting most common registration hour"

		hours = [""]
		@contents.each do |line|
			date_time = Date_and_Time.new(line["RegDate"])
			hours << date_time.get_hours
		end

		grouped_hours = hours.group_by(&:to_s)
		puts grouped_hours.values.max_by(&:size).first
	end

	def get_phone_numbers
		puts "Getting phones"

		@contents.each do |line|
			phone = Phone.new(line["HomePhone"])
			puts phone.clean_phone
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