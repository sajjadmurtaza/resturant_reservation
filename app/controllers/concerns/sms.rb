class Sms
  class << self
    def send from = '+1 618-596-3852' , to = '+1 618-596-3852', body= ''
	  TWILIO_CLIENT.account.messages.create({:from => from, :to => to,:body => body})
	end
  end
end