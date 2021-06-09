*** Settings ***
Library  RequestsLibrary
Library  Collections
Library   HttpLibrary
Library  JSONLibrary
Library  String
Library  SeleniumLibrary
Library  ExtendedSelenium2Library
Library  Process
Library   OperatingSystem
Library   ./curl.py






*** Variables ***
${Canvas_Login_URL} =  https://cuboulder.test.instructure.com
${Base_URL} =  https://lmsmanager-test.colorado.edu/LMSManager/rest/queries/bsoCoursesCreatedInLms
${term} =     20211
${User_Name} =  anan4615coursera
${User_pwd} =  Testcoursera!23
${BROWSER} =    firefox
#${BROWSER} =    headlessfirefox
#@{ALLOWED}=  Create List  /208235  /208231  /208229

*** Keywords ***
Canvas Login


    Open Browser    ${Canvas_Login_URL}     ${BROWSER}
    Input text  xpath=//input[@id='username']  ${User_Name}
    input password  xpath=//input[@id='password']  ${User_pwd}
    Click element   xpath=//div/button[contains(text(),'Continue')]
    sleep   5s
    Maximize Browser Window
    wait until element is visible    id=global_nav_accounts_link     timeout=0.5

    Click element   id=global_nav_accounts_link
    wait until element is visible    link=University of Colorado Boulder     timeout=0.5
    Click element   link=University of Colorado Boulder
    wait until element is visible    xpath=//span/input[@placeholder="Search courses..."]     timeout=0.5
    Click element   xpath=//span/input[@placeholder="Search courses..."]


Canvas Sections
    click   link=Settings
    click   id=uiid-2
    #verify no of courses and sis ID in course section page
    ${Sections_count}=    Get Count    xpath=//[@id="sections"]/li[@class="section"]
    FOR   ${item}   IN RANGE   0    ${Sections_count}

        #need to fill this
    END

Canvas Instructor
    [Arguments]     ${teacher_role}
    click link=People
    select from list by value  name=enrollment_role_id  4
    ${Instr_count}=    Get Count    xpath=//tr[@class="rosterUser al-hover-container TeacherEnrollment"]
    FOR   ${item}   IN RANGE   0    ${Instr_count}
        ${instr_role}= get text    xpath=//tr[@class="rosterUser al-hover-container TeacherEnrollment"]/td[6]
        should be equal as string   ${instr_role}   ${teacher_role}
    END

Canvas Course
    [Arguments]     ${canvas_course}
    ${course_name} =get text    xpath=//span[@class="ellipsible"]
    should be equal as string   ${instr_role}   ${canvas_course}


*** Test Cases ***
TC_01_Get Request

    create session  mysession     ${Base_URL}


    #For multiple activity types create a list like this @{valid_activity_type}=    Create List  Population  Year  Nation

    ${response}=     get request     mysession   ?term5=${term}
    # if there are 2 parameters with and use this format ${response}=     get request     get_course_details     ?drilldowns=${drilldowns}&measures=${measures}
    # if you need to run your API for different parameter values like activity types use this  :FOR    ${item}   IN RANGE   0    ${listlen}
    #      \  ${response}=     get request     get_course_details     ?drilldowns=${drilldowns}&measures=@{valid_activity_type}[${item}]
    #      \  log to console     ${response.content}
    #log to console      ${response.status_code}
    #validate api get
    ${status_code}=     convert to string       ${response.status_code}
    should be equal     ${status_code}      200
    #log to console  ${response.content}


    ${json_obj} =  to json  ${response.content}

     ${response_count}=   Get Length  ${json_obj}
     ${Messages_Queue} =   Message count
     log to console     ${Messages_Queue}



    FOR   ${item}   IN RANGE   0    ${response_count}

           ${section_id} =  convert to string  (${json_obj}[${item}])

           ${SIS_ID} =    remove string using regexp     ${section_id}      -section-\\d\\d\\d\\d\\d
           log to console  ${SIS_ID}
           Canvas Login
           Input text   xpath=//span/input[@placeholder="Search courses..."]     ${SIS_ID}
           # This will differ for each test case
           Page should not contain  "No Courses found"
           ${Canvas_SIS}=   Get Text     xpath=//div[@id='content']/div/table/tbody/tr/td[2]
           #if course is found
           Should be equal  ${SIS_ID}   ${Canvas_SIS}
           click element    xpath=//div[@id='content']/div/table/tbody/tr/td/a/span
    END