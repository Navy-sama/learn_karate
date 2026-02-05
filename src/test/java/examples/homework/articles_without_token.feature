Feature: Articles Operations Without Token

    Background: Preconditions
        * url apiUrl

    @no-token @articles
    Scenario: Get articles from global feed
        Given path 'articles'
        When method get
        Then status 200
        * match response.articles == '#array'
        * match each response.articles == '#object'

    @no-token @tags  
    Scenario: Get available tags
        Given path 'tags'
        When method get
        Then status 200
        * match response.tags == '#array'