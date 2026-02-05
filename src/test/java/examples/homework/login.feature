Feature: Login

    Background: Preconditions
        * url apiUrl 

    Scenario: Login
        Given path 'users/login'
        And request {"user":{"email": "#(email)","password":"#(password)"}}
        When method post
        Then status 200