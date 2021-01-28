Feature: NUMA Users test
  Background:
    * url 'http://localhost:3004'

  Scenario: Get All Users
    Given path 'users'
    When method get
    Then status 200
    And assert response.length == 50

  Scenario: Add, get, update and delete user
    # Add user
    * print 'Add new user'
    * def query =
    """
    {
      "firstName": "Ivan",
      "lastName": "Morales",
      "email": "imorales@stratio.com",
      "country": "ESP"
    }
    """
    Given path 'users'
    And request query
    And header Accept = 'application/json'
    When method post
    Then status 201
    And def id = response.id

    # Get user
    * print 'Get user'
    Given path 'users/', id
    When method get
    Then status 200
    And assert response.firstName == 'Ivan'
    And assert response.lastName == 'Morales'
    And assert response.email == 'imorales@stratio.com'
    And assert response.country == 'ESP'

    # Update user
    * print 'Update user'
    * set query.firstName = 'Test'
    * set query.lastName = 'Numa'
    * set query.email = 'numa@stratio.com'
    Given path 'users/', id
    And request query
    And header Accept = 'application/json'
    When method put
    Then status 200
    And assert response.firstName == 'Test'
    And assert response.lastName == 'Numa'
    And assert response.email == 'numa@stratio.com'
    And assert response.country == 'ESP'

    # Get user
    * print 'Get user (updated)'
    Given path 'users/', id
    When method get
    Then status 200
    And assert response.firstName == 'Test'
    And assert response.lastName == 'Numa'
    And assert response.email == 'numa@stratio.com'
    And assert response.country == 'ESP'

    # Delete user
    * print 'Delete user'
    Given path 'users/', id
    When method delete
    Then status 200

    # Get user
    * print 'Get user (deleted)'
    Given path 'users/', id
    When method get
    Then status 404

  