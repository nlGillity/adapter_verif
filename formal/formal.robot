*** Settings ***
Library             XML    use_lxml=True

*** Variables ***
${XML_FILE_PATH_MAIN}  ${CURDIR}${/}build${/}main${/}adapter_yadro_formal.xml
${XML_FILE_PATH_H0}    ${CURDIR}${/}build${/}h0${/}adapter_yadro_formal_h0.xml
${XML_FILE_PATH_H1}    ${CURDIR}${/}build${/}h1${/}adapter_yadro_formal_h1.xml
${XML_FILE_PATH_H2}    ${CURDIR}${/}build${/}h2${/}adapter_yadro_formal_h2.xml
${XML_FILE_PATH_H3}    ${CURDIR}${/}build${/}h3${/}adapter_yadro_formal_h3.xml
${XML_FILE_PATH_H4}    ${CURDIR}${/}build${/}h4${/}adapter_yadro_formal_h4.xml
${XML_FILE_PATH_H5}    ${CURDIR}${/}build${/}h5${/}adapter_yadro_formal_h5.xml

*** Test Cases ***

main
    ${xml}          Parse Xml       ${XML_FILE_PATH_MAIN}
    ${element0}=    Get Element     ${xml}  testsuite/testcase[@id="h0"]
    ${element1}=    Get Element     ${xml}  testsuite/testcase[@id="h1"]
    ${element2}=    Get Element     ${xml}  testsuite/testcase[@id="h2"]
    ${element3}=    Get Element     ${xml}  testsuite/testcase[@id="h3"]
    ${element4}=    Get Element     ${xml}  testsuite/testcase[@id="h4"]
    ${element5}=    Get Element     ${xml}  testsuite/testcase[@id="h5"]
    Element ShouldNot Exist    ${element0}  failure
    Element ShouldNot Exist    ${element1}  failure
    Element ShouldNot Exist    ${element2}  failure
    Element ShouldNot Exist    ${element3}  failure
    Element ShouldNot Exist    ${element4}  failure
    Element ShouldNot Exist    ${element5}  failure

h0
    ${xml}          Parse Xml       ${XML_FILE_PATH_H0}
    ${element}=     Get Element     ${xml}  testsuite/testcase[@id="h0"]
    Element Should Exist    ${element}  failure

h1
    ${xml}          Parse Xml       ${XML_FILE_PATH_H1}
    ${element}=     Get Element     ${xml}  testsuite/testcase[@id="h1"]
    Element Should Exist    ${element}  failure

h2
    ${xml}          Parse Xml       ${XML_FILE_PATH_H2}
    ${element}=     Get Element     ${xml}  testsuite/testcase[@id="h2"]
    Element Should Exist    ${element}  failure

h3
    ${xml}          Parse Xml       ${XML_FILE_PATH_H3}
    ${element}=     Get Element     ${xml}  testsuite/testcase[@id="h3"]
    Element Should Exist    ${element}  failure

h4
    ${xml}          Parse Xml       ${XML_FILE_PATH_H4}
    ${element}=     Get Element     ${xml}  testsuite/testcase[@id="h4"]
    Element Should Exist    ${element}  failure

h5
    ${xml}          Parse Xml       ${XML_FILE_PATH_H5}
    ${element}=     Get Element     ${xml}  testsuite/testcase[@id="h5"]
    Element Should Exist    ${element}  failure