class Phone

  attr_reader :raw

	def initialize(phone)
		@raw = phone.to_s.tr("-. \(\)", "")
	end
  
  def to_s
    clean
  end

  private

	def clean
		phone_length = @raw.length
		case phone_length
			when 0..9
				invalid_number
			when 10
				@raw
			when 11
				if @raw[0] == "1"
				  @raw = @raw[1..-1]
				else
				  invalid_number
				end
			else
				invalid_number
		end
	end

  def invalid_number
    "0000000000"
  end
end