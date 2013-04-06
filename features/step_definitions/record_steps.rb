require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

### UTILITY METHODS ###

### GIVEN ###

When(/^I reschedule a record$/) do
   header 'Accept', 'application/json'
  get '/records/1/reschedule_in_sec.json?delay=1000'
end

Then(/^Record is rescheduled$/) do
   header 'Accept', 'application/json'
   get '/records/1.json'
   record_json = JSON last_response.body
   puts record_json
   record_json['reschedule_count'].should == 1
end

