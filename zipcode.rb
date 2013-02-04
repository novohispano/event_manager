require "sunlight"

Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"

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