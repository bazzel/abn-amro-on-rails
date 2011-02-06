Feature: Filter expenses
  In order to control my expenses
  As a user
  I want find expenses quickly by using a filter in the sidebar

  Background:
    Given I am logged in as a user with email "john@example.com" and password "secret"
    And I've uploaded the file "TXT101121100433.TAB"
    And the following creditors exist
      | name   |
      | CZ     |
      | Saturn |
    And the following categories
      | name      | parent     |
      | Salaris   | Inkomen    |
      | Belasting | Inkomen    |
      | Uit eten  | Vrije tijd |

    And the following expenses
    | description                                                                                        | creditor | category  |
    | BETAALD  19-11-10 12U12 4J7QZY   12703 HTC Foodcourt>EINDHOVEN                           PASNR 090 | CZ       | Salaris   |
    | BETAALD  19-11-10 10U28 79G5X9   Saturn Tilburg B.V.>TILBURG                             PASNR 100 | Saturn   | Belasting |
    | BETAALD  12-11-10 10U52 01MV01   SPEELGOEDH. DE LIN>OISTERWIJK                           PASNR 100 | Saturn   | Uit eten  |
    When I go to the expenses page for "861887719"

  Scenario: Filter expenses by one creditor
    And I filter expenses by creditor "CZ"
    Then I should see the following expenses:
      | description             |
      | HTC Foodcourt>EINDHOVEN |
    But I should not see the following expenses:
      | description                   |
      | Saturn Tilburg B.V.           |
      | SPEELGOEDH. DE LIN>OISTERWIJK |

  Scenario: Filter expenses by multiple creditors
    When I filter expenses by creditor "CZ"
    And I filter expenses by creditor "Saturn"
    Then I should see the following expenses:
      | description             |
      | HTC Foodcourt>EINDHOVEN |
      | Saturn Tilburg B.V.     |

  Scenario: Remove filter on creditor
    When I filter expenses by creditor "CZ"
    And I filter expenses by creditor "Saturn"
    And I unfilter expenses by creditor "Saturn"
    Then I should see the following expenses:
      | description             |
      | HTC Foodcourt>EINDHOVEN |
    But I should not see the following expenses:
      | description                   |
      | Saturn Tilburg B.V.           |
      | SPEELGOEDH. DE LIN>OISTERWIJK |

  # Scenario: Filter expenses by one main category
  #   And I filter expenses by main category "Inkomen"
  #   Then I should see the following expenses:
  #     | description             |
  #     | HTC Foodcourt>EINDHOVEN |
  #     | Saturn Tilburg B.V.     |
  #   But I should not see the following expenses:
  #     | description                   |
  #     | SPEELGOEDH. DE LIN>OISTERWIJK |
  #
  # Scenario: Filter expenses by multiple main categories
  #   And I filter expenses by main category "Inkomen"
  #   And I filter expenses by main category "Vrije tijd"
  #   Then I should see the following expenses:
  #     | description                   |
  #     | HTC Foodcourt>EINDHOVEN       |
  #     | Saturn Tilburg B.V.           |
  #     | SPEELGOEDH. DE LIN>OISTERWIJK |
  #
  # Scenario: Filter expenses by one subcategory
  #   And I filter expenses by subcategory "Salaris"
  #   Then I should see the following expenses:
  #     | description             |
  #     | HTC Foodcourt>EINDHOVEN |
  #   But I should not see the following expenses:
  #     | description                   |
  #     | Saturn Tilburg B.V.           |
  #     | SPEELGOEDH. DE LIN>OISTERWIJK |
  #
  # Scenario: Filter expenses by multiple subcategories
  #   And I filter expenses by subcategory "Salaris"
  #   And I filter expenses by subcategory "Uit eten"
  #   Then I should see the following expenses:
  #     | description                   |
  #     | HTC Foodcourt>EINDHOVEN       |
  #     | SPEELGOEDH. DE LIN>OISTERWIJK |
  #     But I should not see the following expenses:
  #       | description         |
  #       | Saturn Tilburg B.V. |
  #
