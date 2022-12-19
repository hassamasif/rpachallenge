*** Settings ***

Library           Autosphere.Browser
Library           Autosphere.Excel.Files
Library           BuiltIn
Test Teardown     Close All Browsers
Library           Collections
Library           Autosphere.Tables
*** Keywords ***
Open The RPA Website
    Open Available Browser   https://www.rpachallenge.com/

*** Keywords ***
Download Excel File
     Click Element When Visible    //a[contains(text(),'Download Excel')]

Read Excel File
     Open Workbook    C:\\Users\\LENOVO T470\\Downloads\\Challenge.xlsx
     @{rows}=    Read Worksheet
     Set Global Variable    ${rows}
Submit one form
    [Arguments]  ${row}

    FOR    ${index}  ${key}     IN ENUMERATE   @{row.keys()}

        ${value}=    Get From Dictionary    ${row}    ${key}
        
        ${Text}=    Evaluate  " ".join('${header_names}[${index}]'.split())
        Run Keyword And Return Status  Input Text    xpath=//label[contains(text(),'${Text}')]/following-sibling::input    ${value}
        Log    ${header_names}[${index}], ${value}

    END

    Click Element When Visible    //input[@value='Submit']


Set Header Names

    @{header_names}=   Evaluate    list(list(${rows})[0].values())
    Set Global Variable    ${header_names}

*** Tasks ***
RPA Challenge Round 1
    Open The RPA Website
    #Download Excel File
    Read Excel File
    Set Header Names
    Click Element When Visible    //button[contains(text(),'Start')]

    ${rows_count} =  Get Length   ${rows}[0]
    ${counter} =    Set Variable    1
    FOR    ${index}   IN RANGE   10
        Submit one form  ${rows}[${counter}]
        ${counter}=    Evaluate    ${counter} + 1
    END

    Sleep  10s
    [Teardown]    Close All Browsers