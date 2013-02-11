@backend @browser @db
Feature: Making Order
    In order to fill my stomach
    As a customer
    I want to make an order

    Scenario: View available dishes
        Given collection "dishes":
            | name   | description    | price | size | sizeUnit |
            | Мясо   | Восхитительное | 1000  | 300  | g        |
            | Молоко | Свежее         | 100   | 1    | l        |
            | Банан  | Молодой        | 10    | 3    | i        |
        
        When I opened page "/"
        Then I should see "Меню — Бар Барбудос" as a page title
        And I should see "Меню" on the page
        And I should see dish "Мясо" which "Восхитительное" with price "1000"
        And I should see dish "Молоко" which "Свежее" with price "100"
        And I should see dish "Банан" which "Молодой" with price "10"

    Scenario: Filter dishes by category
        Given collection "categories":
            | name          | _id                      |
            | Блюда из мяса | meat |
            | Напитки       | drinks |
            | Десерты       | desserts |
        And collection "dishes":
            | name   | category | description    | price |
            | Мясо   | meat     | Восхитительное | 1000  |
            | Молоко | drinks   | Свежее         | 100   |
            | Банан  | desserts | Молодой        | 10    |
        
        When I opened page "/"
        Then I should see categories list contains only these categories in right order:
            | name          |
            | Блюда из мяса |
            | Напитки       |
            | Десерты       |
        And category "Блюда из мяса" should be current
        And I should see these dishes:
            | name |
            | Мясо |
        
        When I choice category "Напитки"
        Then I should see these dishes:
            | name |
            | Молоко |
        
        When I choice category "Десерты"
        Then I should see these dishes:
            | name |
            | Банан |
        
        When I choice category "Блюда из мяса"
        Then I should see these dishes:
            | name |
            | Мясо |

    Scenario: Add dishes into cart
        Given collection "dishes":
            | name   | category | description    | price | size | sizeUnit |
            | Мясо   | meat     | Восхитительное | 1000  | 300  | g        |
            | Молоко | drinks   | Свежее         | 100   | 1    | l        |
            | Банан  | desserts | Молодой        | 10    | 3    | i        |
        When I opened page "/"
        Then I should see "Что закажете?" on the page
        And I should see "1" in dish "Мясо" amount input

        When I clicked on button named "В корзину" in dish block about "Мясо"
        Then I should not see "Что закажете?" on the page
        But I should see "Вы заказали:" on the page
        And I should see "Мясо — 1000 руб." on the page

        When I clicked on button named "В корзину" in dish block about "Мясо"
        Then I should see "Мясо — 2000 руб." on the page

        When I clicked on button named "Добавить" in dish block about "Мясо"
        And I clicked on button named "В корзину" in dish block about "Мясо"
        Then I should see "2" in dish "Мясо" amount input
        And I should see "Мясо — 4000 руб." on the page

        When I reload page
        Then I should not see "Что закажете?" on the page
        But I should see "Вы заказали:" on the page
        And I should see "Мясо — 4000 руб." on the page
        And I should see "1" in dish "Мясо" amount input
