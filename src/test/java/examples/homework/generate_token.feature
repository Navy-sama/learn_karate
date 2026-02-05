Feature: Generate Valid Token

    Background: Preconditions
        * url apiUrl

    @token-generator
    Scenario: Generate authentication token
        Given path 'users/login'
        And request {"user":{"email": "#(email)","password":"#(password)"}}
        When method post
        Then status 200
        * match response.user.token == '#present'
        * def globalToken = response.user.token
        * karate.set('globalAuthToken', globalToken)
        * print 'Generated token:', globalToken