Feature: Home Work

    Background: Preconditions
        * url apiUrl 

    Scenario: Favorite articles
        # Step 1: Get atricles of the global feed
        Given path 'articles'
        And params {'limit': 10, 'offset': 0}
        When method get
        Then status 200
        * def articles = response.articles
        
        
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def firstArticle = articles[0]
        * def firstArticleSlug = firstArticle.slug
        * def firstArticleFavCount = firstArticle.favoritesCount


        # Step 3: Make POST request to increse favorites count for the first article
        Given path 'users/login'
        And request {"user":{"email": "#(email)","password":"#(password)"}}
        When method post
        Then status 200
        * def authToken = "Token " + response.user.token

        Given path 'articles/' + firstArticleSlug + '/favorite'
        And header Authorization = authToken
        And request {}
        When method post
        Then status 200
        * match response.article.slug == firstArticleSlug
        

        # Step 4: Verify response schema
        * match response == 
        """
        {  
            "article": {
                "id": "#number",
                "slug": "#(firstArticleSlug)",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "tagList": "#array",
                "favorited": true,
                "favoritesCount": "#number",
                "author": {
                    "username": "#string",
                    "bio": "#",
                    "image": "#string",
                    "following": "#boolean"
                },
                "createdAt": "#string",
                "updatedAt": "#string"
            }
        }
        """


        # Step 5: Verify that favorites article incremented by 1
        * def updatedFavCount = response.article.favoritesCount
        * match updatedFavCount == firstArticleFavCount + 1


        # Step 6: Get updated articles list and filter for favorited articles
        Given path 'articles'
        And params {'limit': 10, 'offset': 0}
        And header Authorization = authToken
        When method get
        Then status 200
        * def updatedArticles = response.articles
        * def favoritedArticles = updatedArticles.filter(article => article.favorited == true)


        # Step 7: Verify response schema for each favorited article
        * match each favoritedArticles ==
        """
        {  
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "favorited": true,
            "favoritesCount": "#number",
            "author": {
                "username": "#string",
                "bio": "#",
                "image": "#string",
                "following": "#boolean"
            },
            "createdAt": "#string",
            "updatedAt": "#string"
        }
        """


        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
        * def slugExists = favoritedArticles.filter(article => article.slug == firstArticleSlug).length > 0
        * match slugExists == true


        
    Scenario: Comment articles
        # Step 1: Get atricles of the global feed
        Given path 'articles'
        And params {'limit': 10, 'offset': 0}
        When method get
        Then status 200
        * def articles = response.articles
        
        
        # Step 2: Get the slug ID for the first arice, save it to variable
        * def firstArticle = articles[0]
        * def firstArticleSlug = firstArticle.slug


        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'users/login'
        And request {"user":{"email": "#(email)","password":"#(password)"}}
        When method post
        Then status 200
        * def authToken = "Token " + response.user.token


        Given path 'articles/' + firstArticleSlug + '/comments'
        * header Authorization = authToken
        When method get
        Then status 200
        * def comments = response.comments


        # Step 4: Verify response schema
        * match response == {"comments": "#array"}


        # Step 5: Get the count of the comments array lentgh and save to variable
        * def commentsCount = comments.length


        # Step 6: Make a POST request to publish a new comment
        Given path 'articles/' + firstArticleSlug + '/comments'
        * header Authorization = authToken
        And request {"comment": {"body": "This is a test comment from Navy-sama"}}
        When method post
        Then status 200
        * def newComment = response.comment
        * match response.comment.body == "This is a test comment from Navy-sama"


        # Step 7: Verify response schema that should contain posted comment text
        * match response == 
        """
        {
            "comment": {
                "id": "#number",
                "body": "#string",
                "createdAt": "#string",
                "updatedAt": "#string",
                "author": {
                    "username": "#string",
                    "bio": "#",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
        }
        """

        
        # Step 8: Get the list of all comments for this article one more time
        Given path 'articles/' + firstArticleSlug + '/comments'
        * header Authorization = authToken
        When method get
        Then status 200
        * def newComments = response.comments

        
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        * def newCommentsCount = newComments.length
        * match newCommentsCount == commentsCount + 1

        
        # Step 10: Make a DELETE request to delete comment
        Given path 'articles/' + firstArticleSlug + '/comments/' + newComment.id
        And header Authorization = authToken
        When method delete
        Then status 200

        
        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path 'articles/' + firstArticleSlug + '/comments'
        * header Authorization = authToken
        When method get
        Then status 200
        * def finalComments = response.comments
        * def finalCommentsCount = finalComments.length
        * match finalCommentsCount == newCommentsCount - 1
        * match finalCommentsCount == commentsCount

        