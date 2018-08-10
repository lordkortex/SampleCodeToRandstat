/**
* @author JhonCortes.org
* @version 1.0 01-02-2018 Jhon Cortes Class definition.
* @date 2018
* @group Calendar
* @group-content ../../ApexDocContent/CRAN_VAS_ON_ManageCalendar_CLS.htm
* @description Class to manage calenfar serviec. Works as Helper
*/
public with sharing class CRAN_VAS_ON_ManageCalendar_CLS{

    /** The Constant SUFIX_TIME_START. */
    public static final String SUFIX_TIME_START = 'StartTime';

    /** The Constant SUFIX_TIME_END. */
    public static final String SUFIX_TIME_END = 'EndTime';

    /** The Constant WEEK_FORMAT. */
    public static final String WEEK_FORMAT = 'EEEE';

    /** The Constant DATE_FORMAT. */
    public static final String DATE_FORMAT = 'dd/MM/yyyy HH:mm';

    /** The Constant EVENT_OBJECT_TYPE. */
    public static final String EVENT_OBJECT_TYPE = 'Event';
    
      /** The Constant EVENT_OBJECT_TYPE. */
    public static final String CASE_CLOSED_STATUS = 'Closed';

    /** The Constant ERROR_CONFIGURACION_AGENTES_BUSINESS. */
    public static final String ERROR_CONFIGURACION_AGENTES_BUSINESS  = 'No existen agentes configurados en los Business Hours';

    /** The Constant ERROR_FECHA_FUERA_DE_RANGO. */
    public static final String  ERROR_FECHA_FUERA_DE_RANGO =  'La fecha no esta dentro del rango de fechas disponibles';
    
    /** The Constant ERROR_FECHA_SIN_USUARIOS_DISPONIBLES. */
    public static final String  ERROR_FECHA_SIN_USUARIOS_DISPONIBLES  = 'La fecha indicada no tiene usuarios disponibles';
    
    /** The Constant ERROR_CONFIGURACION_AGENTES_PERMISSION_SETS. */
    public static final String   ERROR_CONFIGURACION_AGENTES_PERMISSION_SETS = 'No existen agentes configurados en los Permission Sets';
    
    /** The Constant ERROR_CONFIGURACION_AGENTES_METADATA_TYPES. */
    public static final String   ERROR_CONFIGURACION_AGENTES_METADATA_TYPES = 'No existen configuraciones en el metadatatype de agentes';

    /** The Constant ERROR_CASE_CLOSED. */
    public static final String   ERROR_CASE_CLOSED = 'No se pueden realizar operaciones con un caso cerrado';
    
    /** The Constant FECHA_DESACTUALIZADA. */
    public static final String   FECHA_DESACTUALIZADA = 'La fecha ingresada no debe ser inferior a la fecha actual';
    
    /** The Constant ERROR_FECHA_INGRESADA_NO_CONFIGURADA_EN_SLOTS. */
    public static final String   ERROR_FECHA_INGRESADA_NO_CONFIGURADA_EN_SLOTS = 'La fecha ingresada no se encuentra en el conjunto de slots';
    
    /** The Constant ERROR_EVENTO_NO_EXISTE. */
    public static final String   ERROR_EVENTO_NO_EXISTE = 'El evento a actualizar no existe.';

    /** The Constant ERROR_CASE_EMPTY. */
    public static final String   ERROR_CASE_EMPTY = 'El caso no existe.';

    /** The Constant ERROR_CASE_EMPTY. */
    public static final String   STATUS = 'Status';


    /** The Constant CASE_OBJECT. */
    public static final String   CASE_OBJECT = 'Case';

    /** The Constant CASE_OBJECT. */
    public static final String   NOUSERS = 'No existen usuarios para ser asignados';
    
    /** The Constant ERROR_EVENTO_NO_EXISTE. */
    public static final Integer   ERROR_INTERNAL = Integer.valueOf(Label.CRAN_VAS_ON_Salesforce_Internal_Error);
    
    /** The Constant CALL. */
    public static final String   CALL = 'Call';

    /** The Constant LEAD_OBJECT. */
    public static final String   LEAD_OBJECT = 'CRAN_VAS_ON_L_Lead__c';

    /** The Constant CONCTACTID_FIELD. */
    public static final String   CONCTACTID_FIELD = 'ContactId';

    /** The Constant OWNER_ID. */
    public static final String   OWNER_ID = 'OwnerId';

    /** The Constant EXPR_0. */
    public static final String   EXPR_0 = 'Expr0';

    /** The Constant PERMISSION. */
    public static final String   PERMISSION = 'PermissionCalendar';
    
    


    /**
     * Instantiates a new CRA N VA S O N custom calendar WS handler CLS Constructor flip.
     */
    public CRAN_VAS_ON_ManageCalendar_CLS() {

    }


    /**
     * Genera las fechas de calendarios que se encuentran disponibles por slots.
     * El dato de entrada es una fecha y apartir de alli se generan slots de
     * tiempo separados por intervalos de 20 minutos(Este valor es
     * configurables) durantes los proximos 7 dias(Este valor es configurable).
     * Para un slot pueden exixtir varios usuarios o agentes y estos a su vez
     * pueden pertenecer a distintos business hours. Finalmente el metodo
     * retorna un mapa cuya llave es el slot y el valor es un set de id de los
     * usuarios disponibles
     *
     * @param stringActualDate
     *            the string actual date
     * @param isOffset
     *            the is offset
     * @param specificDate
     *            the specific date
     * @param isOnlyAvailables
     *            the is only availables
     * @return the map
     */
    public Map<Datetime,Set<String>> generateDates(final String stringActualDate,final Boolean isOffset,final Datetime specificDate,final Boolean isOnlyAvailables){

        Map<Datetime,Set<String>> dateSetReturnedMap = new  Map<Datetime,Set<String>>();

        try {

            Datetime actualDate = Datetime.parse(stringActualDate);
            DateTime actualDateOffSet  =  actualDate;

            if(isOffset){
                actualDateOffSet  =  getOffsetZoneDateTime(actualDate,1) ;
            }
            
          
            List<CRAN_VAS_ON_Calendar_Configuration__mdt> calendarConfigurationList  = getCalendarConfigurationList();
            CRAN_VAS_ON_Calendar_Configuration__mdt calendarConfigurationItem = calendarConfigurationList.get(0);
            String  configurationPermissionSet = calendarConfigurationItem.Permission_Set__c;
            Integer configurationDays = calendarConfigurationItem.Next_Days_Configuration__c.intValue();
            Integer configurationMinutes = calendarConfigurationItem.Duration_Call__c.intValue();

            Set<Id> userSet = getUserSet(configurationPermissionSet);

            Map<String,List<String>> businessHourUserList = new Map<String,List<String>>();
            Set<String> businessHourSet = buildBussinesHourConfiguration(userSet,businessHourUserList);

            List<BusinessHours> businessHoursList = getBusinessHours(businessHourSet);

            if( businessHoursList.isEmpty()){
                throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_CONFIGURACION_AGENTES_BUSINESS);

            } 

            Map<Datetime,List<String>> mapSlotBussinesHour  = new Map<Datetime,List<String>>();
            Set<Datetime> dateSetReturned = buildIntervalSlotsDayWeek(businessHoursList,actualDateOffSet,configurationDays,configurationMinutes,mapSlotBussinesHour);

            List<Event> eventList = getEventList(userSet,actualDate);                      
            dateSetReturnedMap = checkStatusSlotsMapAvailable(dateSetReturned,eventList,mapSlotBussinesHour,businessHourUserList,specificDate,isOnlyAvailables);

        }catch (CRAN_VAS_ON_Exception e) { 
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,e.exceptionDescription);
        }catch(Exception e) {
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,e.getMessage());
        }

        return dateSetReturnedMap;

    }  

    /**
     * Insert calendar event dates es un metodo que permite ingresar una fecha
     * para ingresar un evento en el calenadrio cuya duracion es configurable.
     * El metodo evalua si la fecha se encuentra disponible para alguno de los
     * agentes y verifica si se encuentra en un business hour valido. Luego
     * evalua cual de los agentes disponibles es quien tiene menos carga
     * (Eventos en el calendario con el recordType que haya sido configurado) y
     * asigna finalmente el evento al usuario que tenga menos eventos
     * calendarizados.
     *
     * @param inputEventDateTimeString
     *            the input event date time string
     * @param idCase
     *            the id case
     * @param idEvent
     *            the id event
     * @return the map
     */
    public Event insertCalendarEventDates(final String inputEventDateTimeString,final Id idCase,final Id idEvent){  

        Event eventCalendar;

        try {

            CRAN_VAS_ON_Status_Flow__mdt caseStatus = CRAN_VAS_ON_ManageCaseUtil_CLS.getMapStages(idCase);

            if(caseStatus.CRAN_VAS_ON_P_Current_Status__c.contains(CASE_CLOSED_STATUS)){
                throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_CASE_CLOSED );
            }

            Datetime inputEventDateTimeOffset = getDateTimeOffsetValid(inputEventDateTimeString);  
            Datetime inputEventDateTimeWitouthOffset = Datetime.parse(inputEventDateTimeString);

            List<CRAN_VAS_ON_Calendar_Configuration__mdt> calendarConfigurationList  = getCalendarConfigurationList();
            CRAN_VAS_ON_Calendar_Configuration__mdt calendarConfigurationItem = calendarConfigurationList.get(0);
            String  configurationPermissionSet = calendarConfigurationItem.Permission_Set__c;
            Integer configurationMinutes = calendarConfigurationItem.Duration_Call__c.intValue();   
            String  recordTypeEventCalendar = calendarConfigurationItem.RecordType_Event_Calendar__c;

            Integer lessMintes = configurationMinutes * -1;
            DateTime dateToCompare = inputEventDateTimeWitouthOffset.addMinutes(lessMintes);
            
            String dateToCompareFormated = dateToCompare.format(DATE_FORMAT);
            
            Map<Datetime,Set<String>> availableUserBySlot =  generateDates(dateToCompareFormated,false,inputEventDateTimeOffset,false);
            

            Set<String> availableUserSet  = getUserAvailableSet( inputEventDateTimeOffset,availableUserBySlot,configurationMinutes);
            RecordType recordType = [Select Id From RecordType Where   SobjectType =: EVENT_OBJECT_TYPE And  Name =: recordTypeEventCalendar];
            Set<Id> userSet = getUserSet(configurationPermissionSet);
            String userSelected = getEventListGroupByUser(userSet,inputEventDateTimeOffset,availableUserSet,recordType);  

            eventCalendar  = upsertEvent( inputEventDateTimeOffset, configurationMinutes, idCase, idEvent,recordType,userSelected);

        }catch (CRAN_VAS_ON_Exception e) { 
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,e.exceptionDescription);
        }catch(Exception e) {
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,e.getMessage());
        }

        return eventCalendar;

  
    }
    
    /**
    * Delete Calendar Event Dates
    *
    * @param idEvent
    *            the id event
    * @return the Case
    */
    public Case deleteCalendarEventDates(final Id idEvent,final Id idCase){  

        List<Case> caseObjectList;
        try {


            Set<String> stFields = new Set<String>{STATUS};   
            caseObjectList = (List<Case>)CRAN_VAS_ON_ManageObjectUtil_CLS.queryObjectList(idCase,CASE_OBJECT,stFields);
            
            if(caseObjectList.isEmpty()){
                throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_CASE_EMPTY );
            }
            

            if(caseObjectList.get(0).status.contains(CASE_CLOSED_STATUS)){
                throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_CASE_CLOSED );
            }
            
            List<Event> eventList = getSpecificEvent(idEvent);
            Event  eventItem = eventList.get(0);
            Datetime dateToCompare = eventItem.startDateTime;
            String inputEventDateTimeString = dateToCompare.formatGMT(DATE_FORMAT);
            Datetime inputEventDateTimeOffset = getDateTimeOffsetValid(inputEventDateTimeString);  
            
            
            Delete eventItem;
        }catch (CRAN_VAS_ON_Exception e) { 
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,e.exceptionDescription);
        }catch(Exception e) {
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,e.getMessage());
        }

        return caseObjectList.get(0);

  
    }
    
    
    /**
     * Upsert event.
     *
     * @param inputEventDateTimeOffset
     *            the input event date time offset
     * @param configurationMinutes
     *            the configuration minutes
     * @param idCase
     *            the id case
     * @param idEvent
     *            the id event
     * @param recordType
     *            the record type
     * @param userSelected
     *            the user selected
     * @return the event
     */
    public Event upsertEvent(final Datetime inputEventDateTimeOffset,final Integer configurationMinutes,final Id idCase,final Id idEvent,
                                                            final RecordType recordType,final String userSelected){
    
            Event eventCalendar;
            inputEventDateTimeOffset = getOffsetZoneDateTime(inputEventDateTimeOffset,-1);
            Date startEvenDate = inputEventDateTimeOffset.Date();
            Datetime  endEvenDateTime =  inputEventDateTimeOffset.addMinutes(configurationMinutes);
            
            try {
                 if(idEvent != null ){
                    List<Event> eventListAfter =getSpecificEvent(idEvent);
                    eventCalendar = eventListAfter.get(0);
                    eventCalendar.ActivityDate = startEvenDate;
                    eventCalendar.ActivityDateTime=inputEventDateTimeOffset;
                    eventCalendar.DurationInMinutes=configurationMinutes;
                    eventCalendar.StartDateTime = inputEventDateTimeOffset;
                    eventCalendar.EndDateTime= endEvenDateTime;
                    eventCalendar.WhatId= idCase;
                }else{
                    Case caseObj = CRAN_VAS_ON_ManageCaseUtil_CLS.queryCase(idCase, new Set<String>{STATUS,LEAD_OBJECT,CONCTACTID_FIELD},null);
                    Id whoIdInput =  caseObj.CRAN_VAS_ON_L_Lead__c   == null ? caseObj.ContactId : caseObj.CRAN_VAS_ON_L_Lead__c    ;
                    eventCalendar = new Event(Subject = CALL,OwnerId = userSelected,
                            ActivityDate = startEvenDate,ActivityDateTime=inputEventDateTimeOffset,
                            DurationInMinutes=configurationMinutes,
                            StartDateTime = inputEventDateTimeOffset,EndDateTime= endEvenDateTime,
                            WhatId = idCase, 
                            EventSubtype= EVENT_OBJECT_TYPE,RecordType= recordType);
                }

                upsert eventCalendar;  
                
            } catch(DmlException e) {
                throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,e.getMessage());
            }
            
        return eventCalendar;
    
    
    }



    /**
     * Gets the user available set. Este metodo retorna los usuarios disponibles para un rango de fechas categorizado por Business Hour.
     *
     * @param inputEventDateTimeOffset
     *            the input event date time offset
     * @param availableUserBySlot
     *            the available user by slot
     * @param configurationMinutes
     *            the configuration minutes
     * @return the user available set
     */
    public Set<String> getUserAvailableSet(final Datetime inputEventDateTimeOffset, final Map<Datetime,Set<String>> availableUserBySlot,final Integer configurationMinutes){
        DateTime selectedStartEvenDateTime;
        for(Datetime startDateTimeSlot : availableUserBySlot.keySet()){
            Datetime endDateTimeSlot = startDateTimeSlot.addMinutes(configurationMinutes);
            if(startDateTimeSlot<= inputEventDateTimeOffset && endDateTimeSlot > inputEventDateTimeOffset){
                selectedStartEvenDateTime = startDateTimeSlot;
                break;
            }
        }

        if(selectedStartEvenDateTime == null){
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_FECHA_FUERA_DE_RANGO );
        }

        Set<String> availableUserSet =  availableUserBySlot.get(selectedStartEvenDateTime);
        if(availableUserSet.isEmpty()){
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_FECHA_SIN_USUARIOS_DISPONIBLES );
        }

        return availableUserSet;
    }

    /**
     * Gets the date time offset valid.
     *
     * @param inputEventDateTimeString
     *            the input event date time string
     * @return the date time offset valid
     */
    public Datetime getDateTimeOffsetValid(final String inputEventDateTimeString){

        Datetime inputEventDateTimeOffset;  
        try{
            Datetime inputEventDateTime = Datetime.parse(inputEventDateTimeString);
            inputEventDateTimeOffset = getOffsetZoneDateTime(inputEventDateTime,1);
            Datetime currenDate = getOffsetZoneDateTime(System.now(),1);
            
            if(inputEventDateTimeOffset < currenDate ){
                 throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,FECHA_DESACTUALIZADA);
            }

        }catch (CRAN_VAS_ON_Exception e) { 
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,e.exceptionDescription);
        }catch(Exception e) {
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,e.getMessage());
        }

        return inputEventDateTimeOffset;
        
    }
    
    
    /**
     * Gets the specific event.
     *
     * @param idEvent
     *            the id event
     * @return the specific event
     */
    public List<Event> getSpecificEvent(final String idEvent){
        List<Event> eventListAfter =[SELECT id,startDateTime,whatId FROM Event WHERE id =:idEvent];
        
        if( eventListAfter.isEmpty()){
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_EVENTO_NO_EXISTE );
        }  
        
        return eventListAfter;
    } 
    
    
    /**
     * Gets the specific event.
     *
     * @param idEvent
     *            the id event
     * @return the specific event
     */
    public List<Event> getSpecificEventByWhatId(final String whatId ){
        List<Event> eventListAfter =[SELECT id,startDateTime,whatId FROM Event WHERE whatId =:whatId ];
        
        return eventListAfter;
    } 
    
    /**
     * Gets the user set. Obtiene los usuarios que tienen asignado un permission set para poder ser agentes. Este permission set se encuentra
     * configurado en el metadataType de configuraciond de agentes.
     *
     * @param configurationPermissionSet
     *            the configuration permission set
     * @return the user set
     */
    public Set<Id> getUserSet(final String configurationPermissionSet){
        Set<Id> userSet = new Set<Id>();
        for( PermissionSetAssignment permissionSetAssignmentList  :[ SELECT  AssigneeId FROM PermissionSetAssignment  WHERE PermissionSet.Name =: configurationPermissionSet]){
            userSet.add(permissionSetAssignmentList.AssigneeId);
        }  

        //Selecciona los distintos Business Hours de esos usuarios      
        if( userSet.isEmpty()){
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_CONFIGURACION_AGENTES_PERMISSION_SETS );
        }  

        return userSet;
    }


    /**
     * Gets the calendar configuration list.Obtiene la lista de configuracion de Calendarios del MetadataType CRAN_VAS_ON_Calendar_Configuration__mdt.
     *
     * @return the calendar configuration list
     */
    public List<CRAN_VAS_ON_Calendar_Configuration__mdt> getCalendarConfigurationList(){
        List<CRAN_VAS_ON_Calendar_Configuration__mdt> calendarConfigurationList = [Select Permission_Set__c,Duration_Call__c,Next_Days_Configuration__c,RecordType_Event_Calendar__c 
                                                                                   From CRAN_VAS_ON_Calendar_Configuration__mdt 
                                                                                   Where Permission_Set__c =: PERMISSION];

        if(calendarConfigurationList.isEmpty()){
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_CONFIGURACION_AGENTES_METADATA_TYPES );
        }

        return calendarConfigurationList;
    }




    /**
     * Builds the bussines hour configuration. Obtiene una lista de bussines Hour y los usuarios asignados a cada lista.
     *
     * @param userSet
     *            the user set
     * @param businessHourUserCounter
     *            the business hour user counter
     * @return the sets the
     */
    public Set<String> buildBussinesHourConfiguration(final Set<Id> userSet, Map<String,List<String>> businessHourUserCounter){

        Set<String> businessHourSet = new Set<String>();

        for(User user : [SELECT id,name,CRAN_VAS_ON_T_Business_Hour__c FROM User WHERE Id IN: userSet]){
            if(!String.isBlank(user.CRAN_VAS_ON_T_Business_Hour__c)){

                if(!businessHourSet.contains(user.CRAN_VAS_ON_T_Business_Hour__c) ){
                    businessHourSet.add(user.CRAN_VAS_ON_T_Business_Hour__c);
                }
                List<String> userList = new List<String>();
                if(businessHourUserCounter.containsKey(user.CRAN_VAS_ON_T_Business_Hour__c)){
                    userList = businessHourUserCounter.get(user.CRAN_VAS_ON_T_Business_Hour__c);
                }
                userList.add(user.Id);
                businessHourUserCounter.put(user.CRAN_VAS_ON_T_Business_Hour__c, userList);  
            }
        }

        return businessHourSet;

    }

    /**
     * Check status slots map available. Retorna los slots que tienen usuarios
     * disponibles
     *
     * @param dateSetReturned
     *            the date set returned
     * @param eventList
     *            the event list
     * @param mapSlotBussinesHour
     *            the map slot bussines hour, contiene la lista de nombres de
     *            bussines hour de un slot
     * @param businessHourUserList
     *            the business hour user list contiene los usuarios especificos
     *            de un bussines hour
     * @param specificSlotHour
     *            the specific slot hour
     * @param isOnlyAvailables
     *            the is only availables
     * @return the map
     */
    public Map<Datetime,Set<String>>  checkStatusSlotsMapAvailable(final Set<Datetime> dateSetReturned ,final List<Event> eventList,
            final Map<Datetime,List<String>> mapSlotBussinesHour,final Map<String,List<String>> businessHourUserList,
            final Datetime specificSlotHour,final  Boolean isOnlyAvailables){

        Map<Datetime,Set<String>> dateSetReturnedMap = new Map<Datetime,Set<String>>();

        if(specificSlotHour!= null && !dateSetReturned.contains(specificSlotHour)){
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,ERROR_FECHA_INGRESADA_NO_CONFIGURADA_EN_SLOTS );
        }

    
        for(Datetime slotHour : dateSetReturned){
            Set<String> notAvailableUserSet = new Set<String>();

            Datetime evaluateHour = slotHour;
            

            for(Event eventItem: eventList){
                Datetime startDateTimeOffSet = getOffsetZoneDateTime(eventItem.StartDateTime,1);
                Datetime endDateTimeOffSet = getOffsetZoneDateTime(eventItem.EndDateTime,1);
                if( startDateTimeOffSet <= evaluateHour &&  endDateTimeOffSet > evaluateHour ){
                    notAvailableUserSet.add(eventItem.OwnerID);
                }
            } 

            Set<String> availableUserList = new  Set<String>();

            List<String> bussinesHourList = mapSlotBussinesHour.get(slotHour);
            for(String bussinesHourSlot : bussinesHourList){
                List<String> userListAll = businessHourUserList.get(bussinesHourSlot);
                for(String user : userListAll){
                    if(!notAvailableUserSet.contains(user)){
                        availableUserList.add(user);
                    }
                }      
            }     

            Integer total = availableUserList.size() + notAvailableUserSet.size();

            if((isOnlyAvailables && !availableUserList.isEmpty()) || (!isOnlyAvailables)){
                dateSetReturnedMap.put(slotHour,availableUserList);
            } 

        }   

        return dateSetReturnedMap;

    }

    /**
     * Gets the offset zone date time.
     *
     * @param dateTimeInput
     *            the date time input
     * @param conmutator
     *            the conmutator
     * @return the offset zone date time
     */
    public Datetime getOffsetZoneDateTime(final Datetime dateTimeInput, final Integer conmutator){
        TimeZone timeZone = UserInfo.getTimeZone();
        DateTime localTime = dateTimeInput;
        DateTime localTimeGmt =  localTime.AddSeconds(timeZone.getOffset(localTime)/1000 * conmutator);
        return localTimeGmt;
    }


    /**
     * Gets the event list.
     *
     * @param userSet
     *            the user set
     * @param actualDate
     *            the actual date
     * @return the event list
     */
    public List<Event> getEventList(final Set<Id> userSet ,final DateTime actualDate){

        Map<Datetime,Integer> eventMap = new Map<Datetime,Integer>();
        List<Event> eventList = [SELECT OwnerId,StartDateTime,EndDateTime FROM Event
                                 WHERE OwnerId IN: userSet  AND  StartDateTime >= :actualDate];
        return eventList;

    }

    /**
     * Gets the event list.
     *
     * @param userSetAll
     *            the user set all
     * @param actualDate
     *            the actual date
     * @param availableUserSet
     *            the available user set
     * @param recordType
     *            the record type
     * @return the event list
     */
    public String getEventListGroupByUser(final Set<Id> userSetAll ,final DateTime actualDate,final Set<String> availableUserSet ,
                                          final RecordType recordType){

        List<String> userListAll = new  List<String>();
        Set<String> userSetWithEvents = new  Set<String>();
        Set<String> userSetWithoutEvents = new  Set<String>();
        String selectedUser;

        AggregateResult[] groupedResults = [SELECT OwnerId, COUNT(Id)  FROM Event 
                                            WHERE OwnerId IN: userSetAll AND RecordTypeId =:recordType.Id
                                            GROUP BY OwnerId ORDER 
                                            BY COUNT(Id) ASC];

        Boolean isFound = true;

        Set<String> userWithEvents = new Set<String>();

        for (AggregateResult ar : groupedResults)  {
            String user = (String) ar.get(OWNER_ID);
            Integer counter = (Integer) ar.get(EXPR_0);
            userWithEvents.add(user);
            if(availableUserSet.contains(user) && isFound){
                selectedUser = user;
                isFound = false;
            }
        }  

        isFound = true;
        for (Id user : userSetAll){
            if(availableUserSet.contains(user) && !userWithEvents.contains(user) && isFound){
                selectedUser = user;
                isFound = false;
            }
        }  

        if(selectedUser == null){
            throw new CRAN_VAS_ON_Exception(ERROR_INTERNAL,NOUSERS);
        }

        return selectedUser;

    }
 
    /**
     * Gets the business hours.
     *
     * @param businessHourSet
     *            the business hour set
     * @return the business hours
     */
    public List<BusinessHours> getBusinessHours(final  Set<String> businessHourSet){

        List<BusinessHours> businessHoursList = [SELECT Id,Name,FridayEndTime,FridayStartTime,
                                                 MondayEndTime,MondayStartTime,
                                                 SaturdayEndTime,SaturdayStartTime,
                                                 SundayEndTime,SundayStartTime,
                                                 ThursdayEndTime,ThursdayStartTime,
                                                 TuesdayEndTime,TuesdayStartTime,
                                                 WednesdayEndTime,WednesdayStartTime 
                                                 FROM BusinessHours WHERE IsActive = true AND Name IN: businessHourSet ];  

        return businessHoursList;
    }


    /**
     * Builds the interval slots day week.
     *
     * @param businessHoursList
     *            the business hours list
     * @param actualDate
     *            the actual date
     * @param configurationDays
     *            the configuration days
     * @param configurationMinutes
     *            the configuration minutes
     * @param mapSlotBussinesHour
     *            the map slot bussines hour
     * @return the sets the
     */
    public Set<Datetime>  buildIntervalSlotsDayWeek(final List<BusinessHours> businessHoursList,DateTime actualDate,
                final Integer configurationDays,Integer configurationMinutes,Map<Datetime,List<String>> mapSlotBussinesHour ){

        Set<Datetime> dateSetReturned = new Set<Datetime>();

        for(BusinessHours businessHoursItem: businessHoursList){
            DateTime incrementedDate = actualDate;
            for(Integer weekDayCounter = 0 ; weekDayCounter <= configurationDays; weekDayCounter++){
                incrementedDate = actualDate.addDays(weekDayCounter);   

                String weekDay = incrementedDate.format(WEEK_FORMAT);   
                String fiedlStarTime = weekDay + SUFIX_TIME_START;
                String fiedlEndTime = weekDay + SUFIX_TIME_END;

                Object fiedlStarTimeObject = businessHoursItem.get(fiedlStarTime);
                Object fiedlEndTimeObject = businessHoursItem.get(fiedlEndTime);

                if(fiedlStarTimeObject != null && fiedlEndTimeObject != null){
                    Time startTime  = (Time)fiedlStarTimeObject;
                    Time endTime    = (Time)fiedlEndTimeObject;

                    buildIntervalSlotsTime(startTime,endTime,actualDate,configurationMinutes,incrementedDate,dateSetReturned,businessHoursItem, mapSlotBussinesHour );
                }
            }
        }

        return dateSetReturned;

    }


    /**
     * Builds the interval slots time.
     *
     * @param startTime
     *            the start time
     * @param endTime
     *            the end time
     * @param actualDate
     *            the actual date
     * @param configurationMinutes
     *            the configuration minutes
     * @param incrementedDate
     *            the incremented date
     * @param dateSetReturned
     *            the date set returned
     * @param businessHoursItem
     *            the business hours item
     * @param mapSlotBussinesHour
     *            the map slot bussines hour
     */
    public void buildIntervalSlotsTime(final Time startTime,final Time endTime,final DateTime actualDate,
            final Integer configurationMinutes final ,DateTime incrementedDate,
            Set<Datetime> dateSetReturned,BusinessHours businessHoursItem,Map<Datetime,List<String>> mapSlotBussinesHour  ){

        Datetime startDateTimeLoop = Datetime.newInstanceGMT(incrementedDate.date(), startTime);
        Datetime endDateTimeLoop = Datetime.newInstanceGMT(incrementedDate.date(), endTime);
        
        
        Datetime transformedDateTimeLoop = startDateTimeLoop;

        addDateTimeToSet(transformedDateTimeLoop,actualDate,dateSetReturned,businessHoursItem,mapSlotBussinesHour);

        while (transformedDateTimeLoop < endDateTimeLoop) {
            transformedDateTimeLoop = transformedDateTimeLoop.addMinutes(configurationMinutes);
            addDateTimeToSet(transformedDateTimeLoop,actualDate,dateSetReturned,businessHoursItem,mapSlotBussinesHour);
        }

    }


    /**
     * Adds the date time to set.
     *
     * @param transformedDateTimeLoop
     *            the transformed date time loop
     * @param actualDate
     *            the actual date
     * @param dateSetReturned
     *            the date set returned
     * @param businessHoursItem
     *            the business hours item
     * @param mapSlotBussinesHour
     *            the map slot bussines hour
     */
    public void addDateTimeToSet(final Datetime transformedDateTimeLoop,final DateTime actualDate,
            Set<Datetime> dateSetReturned,BusinessHours businessHoursItem,Map<Datetime,List<String>> mapSlotBussinesHour ){

        if(transformedDateTimeLoop >= actualDate ){
            dateSetReturned.add(transformedDateTimeLoop);

            List<String> bussinesHourList = new List<String>();
            if(mapSlotBussinesHour.containsKey(transformedDateTimeLoop)){
                bussinesHourList = mapSlotBussinesHour.get(transformedDateTimeLoop);
            }
            bussinesHourList.add(businessHoursItem.Name);
            mapSlotBussinesHour.put(transformedDateTimeLoop, bussinesHourList);  
        }
    }

}
