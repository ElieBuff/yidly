Feature: Reschedule
  As a registered user
  I want to reschedule a task
  so it doesn't appear in the current task and it will snooze in the appropriate time

    Scenario: I am logged in and I reschedule a task
       Given I am logged in 
       When I reschedule a record 
       Then Record is rescheduled
