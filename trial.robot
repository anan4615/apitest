*** Settings ***
Library  RequestsLibrary
Library  Collections
Library   HttpLibrary
Library  JSONLibrary
Library  String
Library  SeleniumLibrary


*** Variables ***
${Canvas_Login_URL} =  https://cuboulder.test.instructure.com
${Base_URL} =  https://lmsmanager-test.colorado.edu/LMSManager/rest/queries/bsoCoursesCreatedInLms
${term} =     20211
${User_Name} =  anan4615coursera
${User_pwd} =  Testcoursera!23
#@{ALLOWED}=  Create List  /208235  /208231  /208229

*** Keywords ***
Canvas Login





*** Test Cases ***
TC_01_Get Request

    Go To   ${Canvas_Login_URL}
    Input text  xpath=//input[@id='username']  ${User_Name}
    input password  xpath=//input[@id='password']  ${User_pwd}
    Click element   xpath=//div/button[contains(text(),'Continue')]
    sleep   5s