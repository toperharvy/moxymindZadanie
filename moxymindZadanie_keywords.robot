*** Settings ***
Library     Browser


*** Keywords ***
Login to App
    [Documentation]  Keyword for login to application. Urguments "${login}" and "${password}"
    [Arguments]    ${login}    ${password}

    Set Log Level    INFO
    ${viewport}=    Create Dictionary    height=1280    width=1480
    Browser.New Context    acceptDownloads=${True}    viewport=${viewport}
    ${baseUrl}=    Set Variable    https://www.saucedemo.com/
    Browser.New Page    ${baseUrl}
    Wait For Elements State    xpath=//input[@id="user-name"]    visible    10s
    Fill Text    xpath=//input[@id="user-name"]    ${login}
    Wait For Elements State    xpath=//input[@id="password"]    visible    10s
    Fill Text    xpath=//input[@id="password"]    ${password}
    Click    xpath=//input[@id="login-button"]
    IF    "${login}"=="locked_out_user"
        Browser.Wait For Elements State
        ...    xpath=//h3[contains(text(),'Sorry, this user has been locked out')]
        ...    visible
        ...    10
        Log    message=*** "The user is locked; login was not successful."    console=True
    ELSE
        Browser.Wait For Elements State    xpath=//div[@class='app_logo' and text()='Swag Labs']    visible    10s
        Log    message=*** "login was successful."    console=True
    END

Add product to cart
    [Documentation]  Keyword for adding product to shopping cart. Verify number of items in shopping cart
    [Arguments]    ${itemCode}
    Browser.Wait For Elements State    xpath=//span[@class='title' and text()='Products']    visible    10s
    Wait For Elements State    xpath=//button[@id='add-to-cart-${itemCode}']    visible    10s
    Click    xpath=//button[@id='add-to-cart-${itemCode}']
    Wait For Elements State    xpath=//span[@class='shopping_cart_badge']    visible    10s
    ${ZiskanyText}=    Browser.Get Text    xpath=//span[@class='shopping_cart_badge']
    Should Be Equal As Numbers    ${ZiskanyText}    1
    Log    message=*** "shopping cart contains 1 item"    console=True

Shopping cart details
    [Documentation]  Helping keyword for checking correct data in the shopping cart detail.
    [Arguments]    ${itemName}
    Browser.Click    xpath=//a[@class='shopping_cart_link']
    Browser.Wait For Elements State    xpath=//span[@class='title' and text()='Your Cart']    visible    10s
    Browser.Wait For Elements State
    ...    xpath=//div[@class='inventory_item_name' and text()='${itemName}']
    ...    visible
    ...    10s
    Browser.Click    xpath=//button[@name='checkout']
    Log    message=*** Shopping cart details-OK    console=True

Checkout Your Information
    [Documentation]   Helping keyword for filling in personal data
    ...  Testing functionalities of mandatory fields.
    [Arguments]    ${Firstname}    ${LastName}    ${PostalCode}
    Browser.Wait For Elements State
    ...    xpath=//span[@class='title' and text()='Checkout: Your Information']
    ...    visible
    ...    10s
    Browser.Click    xpath=//input[@name='continue']
    Browser.Wait For Elements State    xpath=//h3[contains(text(),'Error: First Name is required')]    visible    10
    Browser.Fill Text    xpath=//input[@id='first-name']    ${Firstname}
    Browser.Click    xpath=//input[@name='continue']
    Browser.Wait For Elements State    xpath=//h3[contains(text(),'Error: Last Name is required')]    visible    10
    Browser.Fill Text    xpath=//input[@id='last-name']    ${LastName}
    Browser.Click    xpath=//input[@name='continue']
    Browser.Wait For Elements State    xpath=//h3[contains(text(),'Error: Postal Code is required')]    visible    10
    Browser.Fill Text    xpath=//input[@id='postal-code']    ${PostalCode}
    Browser.Click    xpath=//input[@name='continue']
    Log    message=*** Checkout Your Information page is OK    console=True

Checkout Overview
    [Documentation]   Helping keyword for checking the correctness of the checkout overview page.
    [Arguments]    ${itemName}
    Browser.Wait For Elements State    xpath=//span[@class='title' and text()='Checkout: Overview']    visible    10s
    Browser.Wait For Elements State
    ...    xpath=//div[@class='inventory_item_name' and text()='${itemName}']
    ...    visible
    ...    10s
    Browser.Wait For Elements State    xpath=//div[normalize-space()='Payment Information']    visible    10s
    Browser.Wait For Elements State    xpath=//div[normalize-space()='Price Total']    visible    10s
    Browser.Wait For Elements State    xpath=//div[normalize-space()='Shipping Information']    visible    10s
    Browser.Click    xpath=//button[@name='finish']
    Log    message=*** Checkout Overview page is OK    console=True

Checkout Complete
    [Documentation]   Helping keyword for checking the correctness of the Checkout Complete page
    Browser.Wait For Elements State    xpath=//span[@class='title' and text()='Checkout: Complete!']    visible    10s
    Browser.Wait For Elements State    xpath=//h2[contains(text(),'Thank you for your order!')]    visible    10s
    Browser.Wait For Elements State
    ...    xpath=//div[@class='complete-text' and text()='Your order has been dispatched, and will arrive just as fast as the pony can get there!']
    ...    visible
    ...    10s
    Browser.Click    xpath=//button[@name='back-to-products']
    Log    message=*** Checkout Complete page is OK    console=True

Product detail
    [Documentation]   Helping keyword for checking the correctness of the product detail page
    [Arguments]    ${itemName}    ${itemDescription}    ${itemPrice}
    Browser.Wait For Elements State    xpath=//span[@class='title' and text()='Products']    visible    10s
    Browser.Click    xpath=//div[normalize-space()='${itemName}']
    Browser.Wait For Elements State
    ...    xpath=//div[@class='inventory_details_name large_size' and text()='${itemName}']
    ...    visible
    ...    10s
    Browser.Wait For Elements State
    ...    xpath=//div[@class='inventory_details_desc large_size' and text()='${itemDescription}']
    ...    visible
    ...    10s
    Browser.Wait For Elements State
    ...    xpath=//div[@class='inventory_details_price' and text()='${itemPrice}']
    ...    visible
    ...    10s
    Browser.Click    xpath=//button[@name='back-to-products']
    Log    message=*** Product detail ${itemName} is OK     console=True

Add and delete product
    [Documentation]  Keyword for adding and deleting items from shopping cart
    [Arguments]    ${itemCode1}     ${itemCode2}
    Browser.Wait For Elements State    xpath=//span[@class='title' and text()='Products']    visible    10s
    Browser.Click    xpath=//button[@name[contains(., 'add-to-cart-${itemCode1}')]]
    Sleep    2
    ${ZiskanyText}=    Browser.Get Text    xpath=//span[@class='shopping_cart_badge']
    Should Be Equal As Numbers    ${ZiskanyText}    1
    Log    message=*** Item ${itemCode1} added to cart    console=True
    Browser.Click    xpath=//button[@name[contains(., 'add-to-cart-${itemCode2}')]]
    Sleep    2
    ${ZiskanyText}=    Browser.Get Text    xpath=//span[@class='shopping_cart_badge']
    Should Be Equal As Numbers    ${ZiskanyText}    2
    Log    message=*** Item ${itemCode2} added to cart    console=True
    #delete ${itemCode1} from "your cart page"
    Browser.Click    xpath=//a[@class='shopping_cart_link']
    Browser.Wait For Elements State    xpath=//span[@class='title' and text()='Your Cart']    visible    10s
    Browser.Click    xpath=//button[@name[contains(., 'remove-${itemCode1}')]]
    ${ZiskanyText}=    Browser.Get Text    xpath=//span[@class='shopping_cart_badge']
    Should Be Equal As Numbers    ${ZiskanyText}    1
    Log    message=*** Item ${itemCode1} deleted from cart    console=True
    # delete ${itemCode2} from product page
    Browser.Click    xpath=//button[@name[contains(., 'continue-shopping')]]
    Browser.Wait For Elements State    xpath=//span[@class='title' and text()='Products']    visible    10s
    Browser.Click    xpath=//button[@name[contains(., 'remove-${itemCode2}')]]
    Browser.Wait For Elements State    xpath=//span[@class='shopping_cart_badge']   detached    10s
    Log    message=*** Delete OK, shopping cart is empty    console=True

Logout
    [Documentation]  Keyword for logout from application.
    Browser.Click    xpath=//button[@id='react-burger-menu-btn']
    Browser.Click    xpath=//a[@id='logout_sidebar_link']
    Log    message=*** "logout was successful."    console=True
