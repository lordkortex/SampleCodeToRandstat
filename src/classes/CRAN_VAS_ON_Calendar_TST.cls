/**
* @author JhonCortes.org
* @version 1.0 01-02-2018 Jhon Cortes Class definition.
* @date 2018
* @group Calendar
* @group-content ../../ApexDocContent/CRAN_VAS_ON_Calendar_TST.htm
* @description Class to expose test webservice methods for Calendar service
*/
@isTest(SeeAllData=false)
private class CRAN_VAS_ON_Calendar_TST {

    /** The ACTIONID. */
    public static final String ACTIONID = 'Calendar';
    
    /** The INVALIDACTIONID. */
    public static final String INVALIDACTIONID = 'InvalidCalendar';

    /** The BUSINESS_HOUR_TEST. */
    public static final String BUSINESS_HOUR_TEST = 'Agent Test';

    /** The USER. */
    public static final String USER = 'TESTBstandarduser@testorg.com';

    /** The PERMISSION_SET. */
    public static final String PERMISSION_SET = 'CRAN_VAS_ON_PS_Onboarding';
    
    /** The GMT_FORMAT. */
    public static final String GMT_FORMAT_DATE = 'dd/MM/yyyy'; 

    /** The GMT_FORMAT. */
    public static final String GMT_FORMAT = 'dd/MM/yyyy HH:00'; 

    /** The GMT_FORMAT_MM. */
    public static final String GMT_FORMAT_MM = 'dd/MM/yyyy HH:mm'; 

    /** The SYSTEM. */
    public static final String SYSTEM_ADMIN = 'System Administrator'; 
    
    /** The SYSTEM. */
    public static final String ALIAS = 'standt'; 
    
    /** The ENCODE. */
    public static final String ENCODE = 'UTF-8'; 
    
    /** The ENCODE. */
    public static final String LAST_NAME = 'Testing'; 

    /** The LANGUAGE. */
    public static final String LANGUAGE = 'en_US'; 

    /** The LANGUAGE. */
    public static final String TIME_ZONE = 'America/Los_Angeles'; 

    /** The LANGUAGE. */
    public static final String SPLIT_CHAR = ';'; 

    /** The QUEUE_CHAR. */
    public static final String QUEUE_CHAR = 'Queue'; 

    /** The QUEUE_CHAR. */
    public static final String PARAMETER_CASE = '{"caseId": "'; 

    /** The PARAMETER_DATE_1.  */
    public static final String PARAMETER_DATE_1 =  '","strDate":"02/02/2018 11:40" }'; 

    /** The PARAMETER_STRD_ATE.  */
    public static final String PARAMETER_STRD_ATE = '","strDate":"'; 

    /** The PARAMETER_END_CHAR.  */
    public static final String PARAMETER_END_CHAR = '"}'; 
    
    /** The PARAMETER_END_CHAR.  */
    public static final String PARAMETER_CASE_CREATED = 'Case Created' ; 

    /** The PARAMETER_MIFID_TEST.   */
    public static final String PARAMETER_MIFID_TEST = 'MIFID Test'; 


    /** The PARAMETER_HOUR_1.   ' 10:40 '*/
    public static final String PARAMETER_HOUR_1 = ' 10:40'; 

    /** The PARAMETER_HOUR_2.   */
    public static final String PARAMETER_HOUR_2 = '","strDate":"02/02/2018 11:40XXXXX"}'; 

    /** The PARAMETER_EVENT.   */
    public static final String PARAMETER_EVENT = '", "eventId":"'; 

    /** The PARAMETER_INVALID_DAT_TIME.   */
    public static final String PARAMETER_INVALID_DAT_TIME = 'Invalid date/time: ';

    /** The PARAMETER_FECHA_INGRESADA.    */
    public static final String PARAMETER_FECHA_INGRESADA  = 'La fecha ingresada no se encuentra en el conjunto de slots'; 

    /** The PARAMETER_FECHA_INGRESADA_NO_INFERIOR.  */
    public static final String PARAMETER_FECHA_INGRESADA_NO_INFERIOR  = 'La fecha ingresada no debe ser inferior a la fecha actual'; 

    /** The PARAMETER_NO_ASIGNMENT.   */
    public static final String PARAMETER_NO_ASIGNMENT  = 'Case List has no rows for assignment to SObject id : '; 

    /** The PARAMETER_NO_SLOTS.  */
    public static final String PARAMETER_NO_SLOTS  = 'No existen Slots'; 

    /** The PARAMETER_INVALID_ID.   */
    public static final String PARAMETER_INVALID_ID  ='Invalid id'; 

    /** The PARAMETER_HOUR_3.  */
    public static final String PARAMETER_HOUR_3  = '?strDate=01/02/2018 10:00&caseId=' ; 

     /** The PREMISISON.  */
    public static final String PREMISISON  = 'PermissionCalendar' ; 
    
    /** The EXPECTED_VALIDATED.  */
    public static final String EXPECTED_VALIDATED  = 'Validated value is not the expected' ; 

    /** The EXPECTED_VALIDATED.  */
    public static final String EXPECTED_CASE  = 'Case value is not the expected' ; 
    
    /** The EXPECTED_VALIDATED.  */
    public static final String EXPECTED_ERROR = 'Error value is not the expected' ; 

    /** The EXPECTED_VALIDATED.  */
    public static final String EXPECTED_CURRENT_STATUS = 'Status value is not the expected' ; 

    /** The EXPECTED_VALIDATED.  */
    public static final String EXPECTED_NEXT_STATUS  = 'Validated value is not the expected' ; 

    /** The EXPECTED_VALIDATED.  */
    public static final String EXPECTED_EVENT = 'Event value is not the expected' ; 

 
    /**
    * Method used to create profiles, premission set and assignments for agents related to businness hour which will be available for agent distribution.
    */
    @testSetup static void methodInitial() {
        
        List<CRAN_VAS_ON_Calendar_Configuration__mdt> calendarConfigurationList = [SELECT Permission_Set__c,Duration_Call__c,Next_Days_Configuration__c,RecordType_Event_Calendar__c,CRAN_VAS_ON_T_Business_Hour__c 
                                                                                    FROM CRAN_VAS_ON_Calendar_Configuration__mdt Where Permission_Set__c=: PREMISISON];
        String[] arrBusinnessHours = calendarConfigurationList.get(0).CRAN_VAS_ON_T_Business_Hour__c.split(SPLIT_CHAR);
        String businnessHourSelected = '';
        for (String businnessHour : arrBusinnessHours){
            businnessHourSelected = businnessHour;
        }
        
        
        Profile p = [SELECT id from profile where name =: SYSTEM_ADMIN limit 1];
        UserRole r = [SELECT id from userrole  limit 1];
        User  opUser = new User(alias = ALIAS, email= USER, emailencodingkey = ENCODE, lastname=LAST_NAME, 
            languagelocalekey = LANGUAGE, localesidkey = LANGUAGE, profileid = p.Id, userroleid = r.Id,
            timezonesidkey = TIME_ZONE, username= USER,CRAN_VAS_ON_T_Business_Hour__c = BUSINESS_HOUR_TEST);
        
        insert opUser;
        
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name =: PERMISSION_SET];
        insert new PermissionSetAssignment(AssigneeId = opUser.id, PermissionSetId = ps.Id );
        
        
        
        List<CRAN_VAS_ON_Business_Unit_Map__mdt> calendarConfigurationBusinesUnit = [Select CRAN_VAS_ON_T_Queue__c 
                                                                                        From CRAN_VAS_ON_Business_Unit_Map__mdt 
                                                                                         Where CRAN_VAS_ON_T_Business_Unit__c =: CRAN_VAS_ON_TestBase_CLS.BUSINNESS_UNIT  ];
        String queueName = calendarConfigurationBusinesUnit.get(0).CRAN_VAS_ON_T_Queue__c;
        List<Group> groupList  = [SELECT id,Name from Group where Type =: QUEUE_CHAR And Name =: queueName];

        if(!groupList.isEmpty()){
            Id groupIdentification  = groupList.get(0).Id;
            GroupMember groupMemberItem  = new GroupMember(GroupId = groupIdentification,UserOrGroupId = opUser.id);
        }
        

    }
   
   
    
    /**
     * itTestsInvalidAction
     */
    @isTest 
    static void itTestsInvalidAction() {
        
        CRAN_VAS_ON_WSHandlerFactory_CLS  handler  = new CRAN_VAS_ON_WSHandlerFactory_CLS();
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
         
        String paramsJSON =  PARAMETER_CASE + caseItem.Id + PARAMETER_DATE_1;
        Test.startTest();
        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS results = CRAN_VAS_ON_TestBase_CLS.putJSON(INVALIDACTIONID, paramsJSON);
        Test.stopTest();

        System.assertEquals(null, results.validated,EXPECTED_VALIDATED); 
        System.assertEquals(null, results.caseId,EXPECTED_VALIDATED);
        System.assertEquals(null, results.error,EXPECTED_ERROR);
        System.assertEquals(null, results.currentStatus,EXPECTED_CURRENT_STATUS );
        System.assertEquals(null, results.nextStatus,EXPECTED_NEXT_STATUS); 
        System.assertEquals(null, results.eventId,EXPECTED_EVENT);  
    }
    
    
    /**
     * itTestsPutExecuteActionOK
    */
    @isTest 
    static void itTestsPutExecuteActionOK() {
    
      
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
 
        DateTime dt = System.today();
        dt = Integer.valueOf(dt.format('u')) > 4 ? System.today() + 3: System.today() + 1;
        String dtStr = dt.format(GMT_FORMAT_DATE);
        dtStr = dtStr + PARAMETER_HOUR_1;

        String paramsJSON = PARAMETER_CASE + caseItem.Id +  PARAMETER_STRD_ATE  + dtStr + PARAMETER_END_CHAR; 
        Test.startTest();

        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS results = CRAN_VAS_ON_TestBase_CLS.putJSON(ACTIONID, paramsJSON);
        Test.stopTest();
        
            
        List<Event> lstCaseEvent = [
                Select Id, StartDateTime
                From Event
                Where WhatId =  :caseItem.Id
        ];

        System.assertEquals(true, results.validated,EXPECTED_VALIDATED); 
        System.assertEquals(caseItem.Id, results.caseId,EXPECTED_VALIDATED);
        System.assertEquals(false, results.error,EXPECTED_VALIDATED);
        System.assertEquals(PARAMETER_CASE_CREATED, results.currentStatus,EXPECTED_VALIDATED );
        System.assertEquals(PARAMETER_MIFID_TEST, results.nextStatus,EXPECTED_VALIDATED); 

       
        
    }
    
    /**
     * itTestsDeleteExecuteActionOK
    */
    @isTest 
    static void itTestsDeleteExecuteActionOK() {
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();

        DateTime dt = System.today();
        dt = Integer.valueOf(dt.format('u')) > 4 ? System.today() + 3: System.today() + 1;
        String dtStr = dt.format(GMT_FORMAT_DATE);
        dtStr = dtStr + PARAMETER_HOUR_1;

        String paramsJSON = PARAMETER_CASE + caseItem.Id + 
            PARAMETER_STRD_ATE  + dtStr + PARAMETER_END_CHAR; 
        Test.startTest();

        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS resultsPut = 
           CRAN_VAS_ON_TestBase_CLS.putJSON(ACTIONID, paramsJSON);
        
        List<Event> caseEvent = [
            Select Id, StartDateTime
            From Event
            Where WhatId =  :caseItem.Id
        ];   

        System.assertEquals(1, caseEvent.size());
        System.assertEquals(true, resultsPut.validated); 
        System.assertEquals(caseItem.Id, resultsPut.caseId);
        System.assertEquals(false, resultsPut.error);
        System.assertEquals(PARAMETER_CASE_CREATED, resultsPut.currentStatus );
        System.assertEquals(PARAMETER_MIFID_TEST, resultsPut.nextStatus);
  
        String paramsDeleteJSON = PARAMETER_CASE + caseItem.Id + 
        PARAMETER_STRD_ATE  + dtStr + PARAMETER_EVENT + caseEvent.get(0).Id +PARAMETER_END_CHAR;
    
        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS results = 
            CRAN_VAS_ON_TestBase_CLS.deleteJSON(ACTIONID, paramsDeleteJSON);
        Test.stopTest();

        List<Event> caseEventAfterDelete = [
            Select Id, StartDateTime
            From Event
           Where WhatId =  :caseItem.Id
        ];
        
    
        System.assertEquals(0, caseEventAfterDelete.size(),EXPECTED_VALIDATED);
        System.assertEquals(true, results.validated,EXPECTED_VALIDATED); 
        System.assertEquals(caseItem.Id, results.caseId,EXPECTED_VALIDATED);
        System.assertEquals(false, results.error,EXPECTED_VALIDATED);
        System.assertEquals(PARAMETER_CASE_CREATED, results.currentStatus,EXPECTED_VALIDATED );
        System.assertEquals(PARAMETER_MIFID_TEST, results.nextStatus,EXPECTED_VALIDATED);
       
    }
    

    /**
    * testCalendarMethodGetOutDated
    */
    @isTest 
    static void testCalendarMethodGetOutDated() {
        
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
        CRAN_VAS_ON_Calendar_CLS controllerCalendar = new CRAN_VAS_ON_Calendar_CLS();
        CRAN_VAS_ON_IResponseWSWrapper_CLS responseRequest = controllerCalendar.executeSubActionsGet(PARAMETER_CASE + caseItem.Id + PARAMETER_DATE_1,ACTIONID,200);
        CRAN_VAS_ON_ResponseWSWrapper_CLS response = (CRAN_VAS_ON_ResponseWSWrapper_CLS)responseRequest;

        System.assertEquals(true, response.validated); 
        System.assertEquals(caseItem.Id, response.caseId);
        System.assertEquals(false, response.error);
        System.assertEquals(PARAMETER_CASE_CREATED, response.currentStatus );
        System.assertEquals(PARAMETER_MIFID_TEST, response.nextStatus);
    }
     
     
    /**
     * testCalendarMethodGetInvalidParameter
     */
    @isTest 
    static void testCalendarMethodGetInvalidParameter() {
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
        CRAN_VAS_ON_Calendar_CLS controllerCalendar = new CRAN_VAS_ON_Calendar_CLS();
        CRAN_VAS_ON_IResponseWSWrapper_CLS responseRequest = controllerCalendar.executeSubActionsGet(PARAMETER_CASE + caseItem.Id + PARAMETER_HOUR_2,ACTIONID,500);

        CRAN_VAS_ON_ResponseWSWrapper_CLS response = (CRAN_VAS_ON_ResponseWSWrapper_CLS)responseRequest;

        System.assertEquals(true, response.validated,EXPECTED_VALIDATED); 
        System.assertEquals(caseItem.Id, response.caseId,EXPECTED_VALIDATED);
        System.assertEquals(false, response.error,EXPECTED_VALIDATED);
        System.assertEquals(PARAMETER_CASE_CREATED, response.currentStatus,EXPECTED_VALIDATED );
        System.assertEquals(PARAMETER_MIFID_TEST, response.nextStatus,EXPECTED_VALIDATED);
         
    }
     
     
    /**
    * testCalendarMethodGetOK
    */
    @isTest 
    static void testCalendarMethodGetOK() {
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
        
        DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(System.now(),1);
        incrementedDate = incrementedDate.addMinutes(60);
        String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);
        
        CRAN_VAS_ON_Calendar_CLS controllerCalendar = new CRAN_VAS_ON_Calendar_CLS();
        CRAN_VAS_ON_IResponseWSWrapper_CLS responseRequest = controllerCalendar.executeSubActionsGet(PARAMETER_CASE + caseItem.Id + PARAMETER_STRD_ATE + formatedDtCurrent + PARAMETER_END_CHAR,ACTIONID,200);
        
        CRAN_VAS_ON_ResponseWSWrapper_CLS response = (CRAN_VAS_ON_ResponseWSWrapper_CLS)responseRequest;

        System.assertEquals(true, response.validated,EXPECTED_VALIDATED); 
        System.assertEquals(caseItem.Id, response.caseId,EXPECTED_VALIDATED);
        System.assertEquals(false, response.error);
        System.assertEquals(PARAMETER_CASE_CREATED, response.currentStatus,EXPECTED_VALIDATED );
        System.assertEquals(PARAMETER_MIFID_TEST, response.nextStatus,EXPECTED_VALIDATED);   
     }
     
    /**
     * testInsertEventCalendarPostMethodOK
     */
     @isTest 
    static void testInsertEventCalendarPostMethodOK() {
            
        List<Event> eventList = [SELECT id FROM Event];
        Decimal counterEvent = eventList.size();

    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();

        DateTime dt = System.now();
        dt = Integer.valueOf(dt.format('u')) > 4 ?  System.now() + 3:  System.now() + 1;
        DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(dt,1);
        incrementedDate = incrementedDate.addMinutes(180);
        String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);
        CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
        
        Event   eventInsert = calendarController.insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);
        List<Event> eventListAfter =[SELECT id FROM Event];
        Decimal counterEventAfter = eventListAfter.size();
        
        System.assertEquals(counterEventAfter,counterEvent + 1,EXPECTED_VALIDATED);
        System.assert(eventInsert.Id != null,EXPECTED_VALIDATED);
            
    }
       
    /***
     * testInsertEventCalendarPostMethodFechaIngresadaNoestaEnSlotsOK
     */
    @isTest 
    static void testInsertEventCalendarPostMethodFechaIngresadaNoestaEnSlotsOK() {
        try{
            Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
            DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(System.now(),1);
            incrementedDate = incrementedDate.addDays(10);
            String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT_MM);
            CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
            calendarController.insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);
        }catch(CRAN_VAS_ON_Exception ex){
            System.assertEquals(ex.exceptionDescription,PARAMETER_FECHA_INGRESADA,EXPECTED_VALIDATED);
        }
    }
       
       
    
    /**
     * testGenerateDatesGetMethodOK
    */
    @isTest 
    static void testGenerateDatesGetMethodOK() {
    
        List<CRAN_VAS_ON_Calendar_Configuration__mdt> calendarConfigurationList = [Select Permission_Set__c,Duration_Call__c,Next_Days_Configuration__c,RecordType_Event_Calendar__c From CRAN_VAS_ON_Calendar_Configuration__mdt];
        String recordTypeName = calendarConfigurationList.get(0).RecordType_Event_Calendar__c ;
    
        Date activityDate = Date.parse('01/01/2018');
        Datetime activityDateTime = Datetime.parse('01/02/2018 16:30');
        Datetime StartDateTime = Datetime.parse('01/02/2018 16:30');
        Datetime EndDateTime = Datetime.parse('01/02/2018 17:30');
        RecordType recordType = [Select Id From RecordType Where    SobjectType = 'Event' And  Name =: recordTypeName];
        
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
     
        List<Event> eventList = new List<Event>();
        for(User userItem : [Select Id From User]){
        Event myEvent = new Event(Subject ='Call',
                                          ActivityDate = activityDate,ActivityDateTime=activityDateTime,
                                          DurationInMinutes=60,
                                          StartDateTime = StartDateTime,EndDateTime= EndDateTime,
                                          EventSubtype='Event',RecordType= recordType,WhatId=caseItem.Id);
           eventList .add(myEvent );
        }
        
         
        CRAN_VAS_ON_ManageCalendar_CLS calendarController = new CRAN_VAS_ON_ManageCalendar_CLS();
        Map<Datetime,Set<String>> dateMap = calendarController.generateDates('31/01/2018 14:00',true,null,true);

        Datetime compareDateTime = Datetime.parse('31/01/2018 14:00');
        Boolean isDateContained = dateMap.containsKey(compareDateTime);

        TimeZone tz = UserInfo.getTimeZone();
        compareDateTime =  compareDateTime.AddSeconds(tz.getOffset(compareDateTime)/1000 * 1);
       
        Decimal slotsAmount = 0;
        if(dateMap.containsKey(compareDateTime)){
            Set<String> slotsSet = dateMap.get(compareDateTime);
            slotsAmount = slotsSet.size();
        }

        System.Assert(slotsAmount>0,EXPECTED_VALIDATED);
    }
    
    
   
    
    /**
     * testGenerateDatesGetMethodKOEmptyDate
    */
    @isTest 
    static void testGenerateDatesGetMethodKOEmptyDate() {
    
        try{
            Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
            CRAN_VAS_ON_ManageCalendar_CLS calendarController = new CRAN_VAS_ON_ManageCalendar_CLS();
            calendarController.generateDates('',true,null,true);
        } catch(CRAN_VAS_ON_Exception ex){
            System.assertEquals(ex.exceptionDescription,PARAMETER_INVALID_DAT_TIME,EXPECTED_VALIDATED);
        }
    
    }
    
    
    /***
    * testInsertEventCalendarPostMethodNotMetaDataKO
    */
    @isTest 
    static void testInsertEventCalendarPostMethodNotMetaDataKO() {
    
        try{
            Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
            
            CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
            
            DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(System.now(),1);
            incrementedDate = incrementedDate.addMinutes(-60);
            String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);
            
            calendarController .insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);
        } catch(CRAN_VAS_ON_Exception ex){
            System.assertEquals(ex.exceptionDescription,PARAMETER_FECHA_INGRESADA_NO_INFERIOR,EXPECTED_VALIDATED);
        }
       
    }
    
    /**
    * testInsertEventCalendarPostMethodOutDateKO
    */
    @isTest 
    static void testInsertEventCalendarPostMethodOutDateKO() {
    
        try{
            Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
            CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
            
            DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(System.now(),1);
            incrementedDate = incrementedDate.addMinutes(-60);
            String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);
            
            calendarController .insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);
        } catch(CRAN_VAS_ON_Exception ex){
            Boolean isContained = (ex.exceptionDescription.contains(PARAMETER_FECHA_INGRESADA_NO_INFERIOR));
            System.assert(isContained,EXPECTED_VALIDATED);
        }
       
    }
    
    
    /***
    * testInsertEventCalendarPostMethodKOEmptyDate
    */
    @isTest 
    static void testInsertEventCalendarPostMethodKOEmptyDate() {
    
         try{
                Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
                 
                CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
                calendarController .insertCalendarEventDates('',caseItem.Id,null);
         
            }catch(CRAN_VAS_ON_Exception ex){
                Boolean isExceptionInvalidId = ex.exceptionDescription.contains(PARAMETER_INVALID_DAT_TIME);
                System.assert(isExceptionInvalidId);
            }catch(Exception ex){
                Boolean isExceptionInvalidId = ex.getMessage().contains(PARAMETER_INVALID_DAT_TIME);
                System.assert(isExceptionInvalidId,EXPECTED_VALIDATED);
            }
        
    }
    

      
    /**
    * testInsertEventCalendarPostMethodKOInvalidId
    */
    @isTest 
    static void testInsertEventCalendarPostMethodKOInvalidId() {
    
         try{
            Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
             
            CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
            calendarController.insertCalendarEventDates('',caseItem.Id + 'INVALID',null);
        }catch(CRAN_VAS_ON_Exception ex){
            Boolean isExceptionInvalidId = ex.exceptionDescription.contains(PARAMETER_NO_ASIGNMENT);
            System.assert(isExceptionInvalidId);
        }catch(Exception ex){
            Boolean isExceptionInvalidId = ex.getMessage().contains(PARAMETER_INVALID_ID);
            System.assert(isExceptionInvalidId,EXPECTED_VALIDATED);
        }
    }
       

    /**
     * It tests get execute action KO.
     */
    @isTest  
    static void itTestsGetExecuteActionOK() {
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
     
        String getRequest = PARAMETER_HOUR_3 + caseItem.Id;
        Test.startTest();
        CRAN_VAS_ON_ResponseWSWrapper_CLS results = CRAN_VAS_ON_TestBase_CLS.getJSON(actionId, getRequest);
        Test.stopTest();

        System.assert(results.validated == false,EXPECTED_VALIDATED);
        System.assert(results.error == true,EXPECTED_VALIDATED);
       
     }
    
    
    /**
     * it Tests Get Execute Action InvalidId KO
    */
    @isTest 
    static void itTestsGetExecuteActionInvalidIdKO() {
    
        Case caseItem = new Case(Subject='Test Controller Acct Case',Status=PARAMETER_CASE_CREATED );
        insert caseItem;
        String getRequest = PARAMETER_HOUR_3 + caseItem.Id + 'INVALID';
        Test.startTest();
        CRAN_VAS_ON_ResponseWSWrapper_CLS results = CRAN_VAS_ON_TestBase_CLS.getJSON(actionId, getRequest );
        Test.stopTest();
       
        System.assert(results.validated == false,EXPECTED_VALIDATED);
        System.assert(results.error == true,EXPECTED_VALIDATED);
    }
    
    
    /**
    * it Tests Get Execute Action Invalid Date KO
    */
    @isTest 
    static void itTestsGetExecuteActionInvalidDateKO() {
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
         
        String getRequest = '?strDate=KKKKK01/02/2018 10:00&caseId=' + caseItem.Id;
        Test.startTest();
        CRAN_VAS_ON_ResponseWSWrapper_CLS results = CRAN_VAS_ON_TestBase_CLS.getJSON(actionId, getRequest );
        Test.stopTest();
       
        System.assert(results.validated == false,EXPECTED_VALIDATED);
        System.assert(results.error == true,EXPECTED_VALIDATED);
    }
    
    
    /**
     * It tests get execute action KO.
     */
    @isTest 
    static void itTestsPostExecuteActionOK() {
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
        
        DateTime dt = System.today();
        dt = Integer.valueOf(dt.format('u')) > 4 ? System.today() + 3: System.today() + 1;
        String dtStr = dt.format(GMT_FORMAT_DATE);
        dtStr = dtStr + ' 11:00';

        String paramsJSON = PARAMETER_CASE + caseItem.Id +  PARAMETER_STRD_ATE  + dtStr + PARAMETER_END_CHAR;  
        Test.startTest();
        CRAN_VAS_ON_ResponseWSWrapper_CLS.CRAN_VAS_ON_ResponseWSWrapperCalendar_CLS results = CRAN_VAS_ON_TestBase_CLS.postJSON(actionId, paramsJSON);
        Test.stopTest();

        System.assert(results.validated == true,EXPECTED_VALIDATED);
        System.assert(results.error == false,EXPECTED_VALIDATED);

    }
    
   
    /**
    * it Tests Post Execute Actio nInvalid Date KO
    */
    @isTest 
    static void itTestsPostExecuteActionInvalidDateKO() {
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
          
        String paramsJSON = PARAMETER_CASE + caseItem.Id + '","strDate":"02/02/2018 11:40KKKK"}';
        Test.startTest();
        CRAN_VAS_ON_ResponseWSWrapper_CLS results = CRAN_VAS_ON_TestBase_CLS.postJSON(actionId, paramsJSON);
        Test.stopTest();

        Boolean isContained = (results.message.contains('Invalid date/time:'));
        System.assert(isContained,EXPECTED_VALIDATED);
       
     }
    
    
      
    /**
     * it Tests Post Execute ActionInvalid Parameters KO
     */
    @isTest 
    static void itTestsPostExecuteActionInvalidParametersKO() {
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
         
        String paramsJSON = '{"INVALIDPARAMETERcaseId": "' + caseItem.Id + '","INVALIDPARAMETERstrDate":"02/02/2018 11:40"}';
        Test.startTest();
        CRAN_VAS_ON_ResponseWSWrapper_CLS results = CRAN_VAS_ON_TestBase_CLS.postJSON(actionId, paramsJSON);
        Test.stopTest();

        Boolean isContained = (results.message.contains(CRAN_VAS_ON_Calendar_CLS.CASE_ID_INVALID));
        System.assert(isContained,EXPECTED_VALIDATED);

    }
    
    
       
   /**
    * test Calendar Method Put
    */
    @isTest 
    static void testCalendarMethodPut() {
        
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
        DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(System.now(),1);
        incrementedDate = incrementedDate.addMinutes(180);
        String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);
        
        CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
        Event eventInsert = calendarController.insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);
        incrementedDate = incrementedDate.addMinutes(60);
        formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);

        Test.startTest();
            CRAN_VAS_ON_Calendar_CLS controllerCalendar = new CRAN_VAS_ON_Calendar_CLS();   
            CRAN_VAS_ON_IResponseWSWrapper_CLS responseRequest = controllerCalendar.executeSubActionsPut(PARAMETER_CASE + caseItem.Id + '","strDate": "' +formatedDtCurrent + '","eventId":"' + eventInsert.Id + PARAMETER_END_CHAR,ACTIONID,200);
            CRAN_VAS_ON_ResponseWSWrapper_CLS results = (CRAN_VAS_ON_ResponseWSWrapper_CLS)responseRequest;
        Test.stopTest();

        Boolean isContained = (results.message.contains(CRAN_VAS_ON_Calendar_CLS.SUCCESS_MESSAGE));
        System.assert(isContained,EXPECTED_VALIDATED);

    
     }
     
     
     
     
    /**
    * test Calendar Method Put Invalida Parameter
    */
    @isTest 
    static void testCalendarMethodPutInvalidaParameter() {
    
        try{
            Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
            DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(System.now(),1);
            incrementedDate = incrementedDate.addMinutes(60);
            String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);
            CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
            Event eventInsert = calendarController.insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);
            CRAN_VAS_ON_Calendar_CLS controllerCalendar = new CRAN_VAS_ON_Calendar_CLS();   
            controllerCalendar.executeSubActionsPut('{"caseIdINVALID": "' + caseItem.Id + '","strDate":"02/02/2018 11:40","eventId":"' + eventInsert.Id + PARAMETER_END_CHAR,ACTIONID,200);
        } catch(CRAN_VAS_ON_Exception ex){
            System.assertEquals(ex.exceptionDescription,CRAN_VAS_ON_ManageCalendar_CLS.ERROR_CASE_EMPTY,EXPECTED_VALIDATED);
        }

     }
     
     
     
    /**
     * test Calendar Method Put Invalida Date
     */
    @isTest 
    static void testCalendarMethodPutInvalidaDate() {
        try{
            Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
            DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(System.now(),1);
            incrementedDate = incrementedDate.addMinutes(60);
            String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);
            CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
            Event eventInsert = calendarController.insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);
            CRAN_VAS_ON_Calendar_CLS controllerCalendar = new CRAN_VAS_ON_Calendar_CLS();   
            controllerCalendar.executeSubActionsPut('{"caseIdINVALID": "' + caseItem.Id + '","strDate":"INVALID02/02/2018 11:40","eventId":"' + eventInsert.Id + PARAMETER_END_CHAR,ACTIONID,500);
        } catch(CRAN_VAS_ON_Exception ex){
            System.assertEquals(ex.exceptionDescription,CRAN_VAS_ON_ManageCalendar_CLS.ERROR_CASE_EMPTY,EXPECTED_VALIDATED);
        }
     }
     
     
    /**
     * test Calendar Method Delete KO
     */
    @isTest 
    static void testCalendarMethodDeleteKO() {
    
        Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();

        DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(System.now() ,1);
        incrementedDate = incrementedDate.addMinutes(180);
        String formatedDtCurrentGmt = incrementedDate.formatGMT(GMT_FORMAT);
        String formatedDtCurrent = incrementedDate.format(GMT_FORMAT);

        CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
        Event eventInsert = calendarController.insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);


        CRAN_VAS_ON_Calendar_CLS controllerCalendar = new CRAN_VAS_ON_Calendar_CLS();
        CRAN_VAS_ON_IResponseWSWrapper_CLS responseRequest = controllerCalendar.executeSubActionsDelete(PARAMETER_CASE + caseItem.Id + '","eventId":"' + eventInsert.Id + PARAMETER_END_CHAR,ACTIONID,500);
        CRAN_VAS_ON_ResponseWSWrapper_CLS response = (CRAN_VAS_ON_ResponseWSWrapper_CLS)responseRequest;


        System.assertEquals(true, response.validated,EXPECTED_VALIDATED); 
        System.assertEquals(caseItem.Id, response.caseId,EXPECTED_VALIDATED);
        System.assertEquals(false, response.error,EXPECTED_VALIDATED);
        System.assertEquals(PARAMETER_CASE_CREATED, response.currentStatus,EXPECTED_VALIDATED );
        System.assertEquals(PARAMETER_MIFID_TEST, response.nextStatus,EXPECTED_VALIDATED);


     }
     
     
    /**
     * test Calendar Method Delete KO Invalid Parameter
     */
    @isTest 
    static void testCalendarMethodDeleteKOInvalidParameter() {
    
        try{
            Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
            DateTime incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(System.now() + 1,1);
            incrementedDate = incrementedDate.addMinutes(60);
            String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);
            CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
             
            CRAN_VAS_ON_Calendar_CLS controllerCalendar = new CRAN_VAS_ON_Calendar_CLS();
            Event eventInsert = calendarController.insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);
            controllerCalendar.executeSubActionsDelete('{"caseIdINVALID": "' + caseItem.Id + '","eventId":"' + eventInsert.Id + PARAMETER_END_CHAR,ACTIONID,500);
   
        
        } catch(CRAN_VAS_ON_Exception ex){
            System.assertEquals(ex.exceptionDescription,CRAN_VAS_ON_ManageCalendar_CLS.ERROR_CASE_EMPTY,EXPECTED_VALIDATED);
        }

    }   
     
     
    /**
    * test Calendar Method Delete KO Null Parameter
    */
    @isTest 
    static void testCalendarMethodDeleteKONullParameter() {
    
        try{
            Case caseItem = CRAN_VAS_ON_TestBase_CLS.createCase();
            DateTime incrementedDate = System.now();
            incrementedDate = CRAN_VAS_ON_TestBase_CLS.getOffsetZoneDateTime(incrementedDate + 1,1);
            incrementedDate = incrementedDate.addMinutes(120);
            String formatedDtCurrent = incrementedDate.formatGMT(GMT_FORMAT);
            CRAN_VAS_ON_ManageCalendar_CLS calendarController  = new CRAN_VAS_ON_ManageCalendar_CLS();
            CRAN_VAS_ON_Calendar_CLS controllerCalendar = new CRAN_VAS_ON_Calendar_CLS();
            Boolean throwError = false;
            Event eventInsert = calendarController.insertCalendarEventDates(formatedDtCurrent,caseItem.Id,null);   
            controllerCalendar.executeSubActionsDelete('{"eventId":"' + eventInsert.Id + PARAMETER_END_CHAR, ACTIONID,500);
        } catch(CRAN_VAS_ON_Exception ex){
            System.assertEquals(ex.exceptionDescription,CRAN_VAS_ON_ManageCalendar_CLS.ERROR_CASE_EMPTY,EXPECTED_VALIDATED);
        }

     }
}
