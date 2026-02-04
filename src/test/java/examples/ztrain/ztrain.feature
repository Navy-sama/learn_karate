Feature: Place an order

  Background:
    * url baseUrl
    * def random = new Date().getTime()
    * def randomEmail = 'test_' + random + '@example.com'
    * def randomProductName = 'Produit ' + random
    * def randomCategoryName = 'Catégorie ' + random
    * def randomShippingMethod = 'Méthode' + random

  Scenario: Place Order
    # Registration
    Given path 'user/register'
    And request
    """
    {
      "adress": "Ici",
      "email": "#(randomEmail)",
      "password": "TestPassword123!"
    }
    """
    When method post
    Then status 201

    #Login
    Given path 'auth/login'
    And request
    """
    {
      "email": "#(randomEmail)",
      "password": "TestPassword123!"
    }
    """
    When method post
    Then status 201
    And match response.token == '#present'
    * def authToken = response.token
    * def userId = response.user._id
  
    # Category Creation
    Given path 'category/create'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "name": "#(randomCategoryName)",
      "description": "#(randomCategoryName)"
    }
    """
    When method post
    Then status 201
    * def categoryId = response._id
  
    # Product Creation
    Given path 'product/create'
    And header Authorization = 'Bearer ' + authToken
    * def productDescription = randomProductName + ' description is my description for product ' + randomProductName + ' for describing to you the description of the product'
    And request
    """
    {
      "name": "#(randomProductName)",
      "description": "#(productDescription)",
      "image":["https://image.png", "https://image.png", "https://image.png"],
      "price": 1000,
      "isActive": true,
      "category": "#(categoryId)",
      "attributs": {
        "colors": ["Gojo Blue"],
        "height": ["L", "XL"]
        }
    }
    """
    When method post
    Then status 201
    * def productId = response._id
  
    # Add to Cart
    Given path 'cart/add'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "product": "#(productId)",
      "user_id": "#(userId)",
      "quantity": 2
    }
    """
    When method post
    Then status 201
  
    # Create Shipping Method
    Given path 'shipping-method/create'
    And header Authorization = 'Bearer ' + authToken
    * def shippingDescription = randomShippingMethod + ' description is my description for shipping method'
    And request
    """
    {
      "designation": "#(randomShippingMethod)",
      "description": "#(shippingDescription)",
      "price" : 1000
    }
    """
    When method post
    Then status 201
    * def shippingId = response._id
  
    # Update Cart
    Given path 'cart/update'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "product": "#(productId)",
      "user_id": "#(userId)",
      "quantity": 3
    }
    """
    When method put
    Then status 200

    # Add comment
    Given path 'product/comments/add'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "product_id": "#(productId)",
      "user_id": "#(userId)",
      "message": "Hola !... Ganbare ganbare !"
    }
    """
    When method post
    Then status 201

    # Add to favorites
    Given path 'favorites/add'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "product": "#(productId)",
      "user": "#(userId)"
    }
    """
    When method post
    Then status 201

    # Get Cart
    Given path 'cart/' + userId
    And header Authorization = 'Bearer ' + authToken
    When method get
    Then status 200
    * def cartProducts = response

     # create Order
    Given path 'command/create'
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "address": "Ici",
      "user_id": "#(userId)",
      "card": {
        "number": 4000000000001091,
        "exp_month": 1,
        "exp_year": 2028,
        "cvc": "314"
      },
      "products": "#(cartProducts)",
      "shipping_method": "#(shippingId)"
    }
    """
    When method post
    Then status 201

    
  
  
    