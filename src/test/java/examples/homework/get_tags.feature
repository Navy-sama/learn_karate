@feat-no-auth
Feature: Get Tags

    Background: Preconditions
        * url apiUrl

    Scenario: Get article's tags
        Given path 'tags'
        When method get
        Then status 200
        
        