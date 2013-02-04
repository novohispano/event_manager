require "date"

class DateAndTime

	def initialize(date)
		@date = DateTime.strptime(date, "%m/%d/%y %k:%M")
	end

	def get_hours
    	@date.hour
	end

	def get_days
		@date.wday
	end
end