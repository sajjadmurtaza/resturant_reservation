require 'rubygems' # not necessary with ruby 1.9 but included for completeness
require 'twilio-ruby'

# put your own credentials here
# account_sid = 'AC20aef60110fea26f6ba10374ede11cbd'
# auth_token = 'f8a93cc98d52c2c3c19fa290d141d6da'
account_sid = 'AC37b586c1d70dceaa2f846eb79796244e'
auth_token = 'be54c90f63c8ba60b3b0fee872dfdb21'

# set up a client to talk to the Twilio REST API
TWILIO_CLIENT = Twilio::REST::Client.new account_sid, auth_token