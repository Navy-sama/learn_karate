@ignore
Feature: Comment Articles with Examples

    Background: Preconditions
        * url apiUrl
        * def login = call read('login.feature')
        * def authToken = "Token " + login.response.user.token
        * def comment_schema = read('json/comment.json')
        * def articlesResponse = call read('get_articles.feature')
        * def articles = articlesResponse.response.articles
        * def firstArticleSlug = articles[0].slug

    @comment-examples
    Scenario Outline: Create multiple comments with different content
        Given path 'articles/' + firstArticleSlug + '/comments'
        * header Authorization = authToken
        And request {"comment": {"body": "<commentBody>"}}
        When method post
        Then status 200
        * match response == comment_schema
        * match response.comment.body == "<commentBody>"
        * def createdCommentId = response.comment.id

    Examples:
        | commentBody                           |
        | This is my first test comment         |
        | Another comment for testing purposes  |
        | Great article, thanks for sharing!    |
        | Very informative content              |

    # Clean up after scenario
    # Delete the created comment after each scenario
    # @AfterScenario
    # def afterScenario() {
    #     # Delete the created comment
    #     * def deleteComment = call read('delete_comment.feature') {slug: '#(firstArticleSlug)', id: '#(createdCommentId)'}
    # }