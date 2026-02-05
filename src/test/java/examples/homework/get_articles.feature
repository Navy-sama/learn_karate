@feat-no-auth
Feature: Get Articles

    Background: Preconditions
        * url apiUrl

    Scenario: Get articles of the global feed
        Given path 'articles'
        And params {'limit': 10, 'offset': 0}
        When method get
        Then status 200
        
        