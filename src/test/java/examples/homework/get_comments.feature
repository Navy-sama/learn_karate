@ignore
Feature: Get comments

    Background: Preconditions
        * url apiUrl

    Scenario: Get my comments for oan article
        Given path 'articles/' + firstArticleSlug + '/comments'
        * header Authorization = authToken
        When method get
        Then status 200
        
        