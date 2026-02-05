Feature: Publish Comment

    Background: Preconditions
        * url apiUrl

    Scenario: Create new comment for an article
        Given path 'articles/' + slug + '/comments'
        * header Authorization = authToken
        And request {"comment": {"body": "This is a test comment from Navy-sama"}}
        When method post
        Then status 200
        * match response.comment.body == "This is a test comment from Navy-sama"