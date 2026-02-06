@ignore
Feature: Delete Comment

    Background: Preconditions
        * url apiUrl

    Scenario: Delete a specific comment for an article
        Given path 'articles/' + slug + '/comments/' + id
        And header Authorization = authToken
        When method delete
        Then status 200"