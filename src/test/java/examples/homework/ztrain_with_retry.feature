    @ignore
Feature: Ztrain API with Retry Logic

    Background:
        * url baseUrl
        * def random = new Date().getTime()
        * def randomEmail = 'test_' + random + '@example.com'
        * def randomProductName = 'Produit ' + random
        * configure retry = { count: 3, interval: 1000 }

    @ztrain-retry
    Scenario: Create user and product with retry logic
        # Registration with retry
        Given path 'user/register'
        And request
        """
        {
          "adress": "Test Address",
          "email": "#(randomEmail)",
          "password": "TestPassword123!"
        }
        """
        And retry until responseStatus == 201
        When method post
        Then status 201

        # Login with retry
        Given path 'auth/login'
        And request
        """
        {
          "email": "#(randomEmail)",
          "password": "TestPassword123!"
        }
        """
        And retry until responseStatus == 201
        When method post
        Then status 201
        And match response.token == '#present'
        * def authToken = response.token
        * def userId = response.user._id

        # Category Creation with retry
        * configure retry = { count: 2, interval: 1000 }
        Given path 'category/create'
        And header Authorization = 'Bearer ' + authToken
        And request
        """
        {
          "name": "Test Category " + random,
          "description": "Test Category Description"
        }
        """
        And retry until responseStatus == 201
        When method post
        Then status 201
        * def categoryId = response._id

        # Product Creation with retry
        Given path 'product/create'
        And header Authorization = 'Bearer ' + authToken
        And request
        """
        {
          "name": "#(randomProductName)",
          "description": "Test product description",
          "image":["https://test-image.png"],
          "price": 1500,
          "isActive": true,
          "category": "#(categoryId)",
          "attributs": {
            "colors": ["Blue"],
            "height": ["M", "L"]
          }
        }
        """
        And retry until responseStatus == 201
        When method post
        Then status 201
        * def productId = response._id
        * print 'Created product with ID:', productId