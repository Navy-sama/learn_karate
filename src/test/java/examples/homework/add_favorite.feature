Feature: Add to Favorites

    Background: Preconditions
        * url apiUrl

    Scenario: Add article to favorites
        Given path 'articles/' + slug + '/favorite'
        And header Authorization = authToken
        And request {}
        When method post
        Then status 200
        * match response.article.slug == slug