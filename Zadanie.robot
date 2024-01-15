*** Settings ***
Library         Browser
Resource        moxymindZadanie_keywords.robot
Resource        variables.robot

Suite Setup     Run Keywords
...                 Browser.New Browser
...                 browser=${BROWSER}
...                 headless=${HEADLESS}    AND
...                 Set Library Search Order    Browser    SeleniumLibrary    AND
...                 Browser.Set Browser Timeout    1m


*** Variables ***
${browser}=     chromium
${headless}=    False


*** Test Cases ***

Login and logout
    [Documentation]   Basic test for testing the functionality of login and logout.
    ...   The user's login and password are used as arguments.
    [Tags]    smoke    regress
    Login to App    login=${loginStandard}    password=${pass4all}
    Logout

Product detail
    [Documentation]    Test case for testing of product details.
    ...  The item description, item name and item price are used as an arguments.
    ...  The user is logged into the application.
    ...  Click on the details of the selected product, check its description, name  and price
    ...  Log out of the system.
    [Tags]    smoke    regress
    Login to App    login=${loginStandard}    password=${pass4all}
    Product detail
    ...    itemName=Sauce Labs Backpack
    ...    itemDescription=carry.allTheThings() with the sleek, streamlined Sly Pack that melds uncompromising style with unequaled laptop and tablet protection.
    ...    itemPrice=29.99
    Logout

Add and delete products
    [Documentation]    Test case for testing the functionality of adding and deleting items from the shopping cart.
    ...  Login to App
    ...  Add two products according to the item code and check the correct number of items in the shopping cart.
    ...  Delete one item from cart page and delete one item from product page and check the correct number of items in the shopping cart.
    ...  Logout from App
    [Tags]    smoke    regress
    Login to App    login=${loginStandard}    password=${pass4all}
    Add and delete product    itemCode1=sauce-labs-backpack     itemCode2=sauce-labs-bike-light
    Logout

Complete order
    [Documentation]    Complete test case for testing the entire functionality.
    ...  Login to App
    ...  Add selected product (by item code) to shopping cart
    ...  Check correct data in the shopping cart detail.
    ...  Fill in all mandatory personal data
    ...  Checking the correctness of the checkout overview page.
    ...  Checking the correctness of the checkout complete page.
    ...  Logout from App
    [Tags]    smoke    regress  FullTest
    Login to App    login=${loginStandard}    password=${pass4all}
    Add product to cart    itemCode=sauce-labs-backpack
    Shopping cart details    itemName=Sauce Labs Backpack
    Checkout Your Information    Firstname=Martin    LastName=Dobias    PostalCode=85107
    Checkout Overview    itemName=Sauce Labs Backpack
    Checkout Complete
    Logout



