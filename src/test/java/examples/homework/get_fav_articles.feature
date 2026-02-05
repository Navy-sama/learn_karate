@feat-no-auth
Feature: Get Favorites Articles

     Background: Preconditions
        * url apiUrl

    Scenario: Get my favorite articles
        Given path 'articles'
        And params {'limit': 10, 'offset': 0, 'favorited': "#(username)"}
        When method get
        Then status 200
        
        