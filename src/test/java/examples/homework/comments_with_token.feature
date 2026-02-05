Feature: Comments Operations With Token

    Background: Preconditions
        * url apiUrl
        * def login = call read('login.feature')
        * def authToken = "Token " + login.response.user.token
        * def comment_schema = read('json/comment.json')

    @with-token @comments @token-init
    Scenario: Manage article comments
        # Get articles
        * def articlesResponse = call read('get_articles.feature')
        * def articles = articlesResponse.response.articles
        * def firstArticleSlug = articles[0].slug
        
        # Get existing comments count
        * def commentsResponse = call read('get_comments.feature')
        * def initialCommentsCount = commentsResponse.response.comments.length
        
        # Create a comment
        * def publishComment = call read('publish_comment.feature') {slug: '#(firstArticleSlug)'}
        * match publishComment.response == comment_schema
        * def newCommentId = publishComment.response.comment.id
        
        # Verify comment was added
        * def newCommentsResponse = call read('get_comments.feature')
        * def newCommentsCount = newCommentsResponse.response.comments.length
        * match newCommentsCount == initialCommentsCount + 1
        
        # Delete the comment
        * def deleteComment = call read('delete_comment.feature') {slug: '#(firstArticleSlug)', id: '#(newCommentId)'}
        
        # Verify comment was deleted
        * def finalCommentsResponse = call read('get_comments.feature')
        * def finalCommentsCount = finalCommentsResponse.response.comments.length
        * match finalCommentsCount == initialCommentsCount