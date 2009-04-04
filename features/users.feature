
Scenario: Login an existing user

  Given I go to login
  And I login with credentials "michael" and "mikemike"
  Then I should be on the homepage