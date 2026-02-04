///
// (c) 2015 Appirio, Inc.
//
//
// 26 May 2015     Luke Slevin  Modified Case 00119037
//
// 03 Aug 2016     RMARQUARDT   Modified S-423778
//
// 14 Feb 2017     Alexander Miller  00188425
//
// 21 Mar 2017     Alexander Miller  00191779
//
// 20 Sep 2018     Tommy Noe - S-569853 - Changes to Using / Sold Product Status
//
// 15 June 2022     Alejandro Sotelo Luna ASL   S-695488    Meet Now page - New Sales Opportunity
//
// 12 July 2022     Alejandro Sotelo Luna ASL   S-696198    Meet Now page - New Sales Opportunity Part 2
//
// 10 October 2022  Alejandro Sotelo Luna ASL   S-698051    Add Cool School ID to pages in UI.

public with sharing class MeetingNow {
  public Map<String, Boolean> ProductsMap { get; set; } // Added by vinit for S-644696/S-645821 [14-Nov-2019]
  public String prdId { get; set; } // Added by vinit for S-644696/S-645821 [14-Nov-2019]
  public List<ProductActivity__c> productActiHistory { get; set; } // Added by vinit for S-644696/S-645821 [14-Nov-2019]
  /*page variables*/
  public String DistributorNameDefault { get; set; }
  //security token used to prevent XSRF attacks
  public String securityToken { get; set; }
  public string BaseURL { get; set; }
  public String CommittedOrderString { get; set; }
  public list<CommittedOrder__c> updatedOrder;
  public list<CommittedOrder__c> createdOrder;
  public map<String, Account> distributorMap = new Map<String, Account>();
  /* START Vinit S-601948 3.10.2019 on behalf changes */
  public String FirstSegmentName { get; set; }
  public String CDistributorId { get; set; }
  // END Vinit S-601948 3.10.2019
  //Start- Add by Mayank| S-707888 | 25 April 2025  || show Sales call assist picklist
  public Boolean showSalesCallAssistPicklist { get; set; }
  public String salesCallAssistValue { get; set; }
  //end- Add by Mayank| S-707888 | 25 April 2025  || show Sales call assist picklist
  // NCarson S-707880 - track existing product Ids
  public set<String> existingProductIdSet { get; set; }
  public String existingProductIdString { get; set; }

  public string lastRow { get; set; }
  public boolean isClosingMeeting; //Added by Shobhit Pant For Case 00227972 05/21/2018
  // Added for the Story S-260649 #START
  public String BoaId { get; set; }
  public Boolean CheckboxValue { get; set; }
  // Added for the Story S-260649 #END
  public String OperatorId { get; set; }
  public String OperatorType { get; set; } //Added by Aditya Tiwari for S-554835

  /** Code modified - Padmesh Soni (02/18/2017 Appirio Offshore) - S-467938 - Start **/
  public String MarketId { get; set; }
  /** Code modified - Padmesh Soni (02/18/2017 Appirio Offshore) - S-467938 - End **/

  public String DistributorId { get; set; }
  public String DistributorName { get; set; } //Added Utkarsh | C-00357859 | 04-06-2025
  public String PricingDistributorId { get; set; } // Jai Gupta Operator Feedback
  public String EventId { get; set; }
  public String SalesCallId { get; set; }

  public String SaveAction { get; set; }
  public Activity__c SalesCall { get; set; }
  public List<ProductActivity__c> ProductActivityList { get; set; }   /* START Added - by Esoof | S-708135 | 08/09/2025  */
  public List<Activity__c> actList { get; set; }   /* START Added - by Esoof | S-708135 | 08/09/2025  */


  public List<AssignedProduct> AssignedProductList { get; set; }
  public List<SalesOpportunity__c> OpportunityList { get; set; }

  public String ProductIds { get; set; }
  public String ProductId { get; set; } //Added By Lalit for S-334717
  public String ExpectedOrderDate { get; set; } //Added By Lalit for S-334717
  public String CompetitorInfo { get; set; } //Added By Lalit for S-334717
  public String FeedbackElaboration { get; set; } //Added By Lalit for S-334717
  public String SaveMeetExcepMsg { get; set; }
  public String ManufacturerIds { get; set; }
  public String oldProdAcStatus { get; set; } // Aditya
  /*S-259362 Added by Paras Dhingra on 10-08-2014 #start */
  public String SalesDocIds { get; set; }
  public List<SalesDoc__c> SalesDocumentsList { get; set; }
  /*S-259362 #End */
  List<PicklistWrapper> picklistValues { get; set; } //Modified by Aditya Tiwari for S-554835

  //Comma Delimited String Representing BusinessObjectives
  public String BusinessObjectiveIds { get; set; }
  public Set<String> OriginalBusinessObjectiveIdSet { get; set; } //Represents a set of Ids already in the database
  public List<BusinessObjectiveActivity__c> BusinessObjectiveActivityList {
    get;
    set;
  }
  public List<BusinessObjectiveActivity__c> BusinessObjectivePlannedActivityList {
    get;
    set;
  }
  public List<BusinessObjectiveActivity__c> OriginalBusinessObjectivePlannedActivityList {
    get;
    set;
  }

  public map<String, Decimal> OperatorPlanAmount { get; set; }

  //a map of objects when the page loads to revert to if the users leaves the page
  public map<string, object> initialObjectMap = new Map<string, object>();

  // NBOCK Case 00103696 12.9.14
  public Boolean isSafari { get; set; }

  //Added by Lalit for S-334717 START
  public List<CommittedOrder__c> committedOrders { get; set; }
  public List<DistrubutorClass> cowrapper { get; set; }
  public Map<String, String> distributorNameIdMap { get; set; }
  public String operatorMarket { get; set; }
  public Boolean isCompleted { get; set; } // S-339867 - Hemlata
  public CommittedOrder__c commitOrder { get; set; } // S-343194 - Hemlata
  //start - Jai Gupta - S-339868 - Aug 18,2015
  public Map<string, Followup_Call_Mapping__c> reasonUnSoldWithFollowUpCall {
    get;
    set;
  }
  public String JsonReasonUnSoldWithFollowUpCall { get; set; }
  //Added by Shubham for Story S-426804 #Start
  public Map<String, String> purchaseFreqHelpTextMap { get; set; }
  public String JsonPurchaseFreqHelpTextMap { get; set; }
  public Map<String, String> saleTypeHelpTextMap { get; set; }
  public String JsonSaleTypeHelpTextMap { get; set; }
  //Added by Shubham for Story S-426804 #End
  public String notSoldPAIds { get; set; }
  public string separator { get; set; }
  public String ActivityStartDate { get; set; } //Added By Nishank for S-409424
  //End - Jai Gupta - S-339868 - Aug 18,2015

  //rmarquardt start - S-423778 - 8/3/2016
  public Boolean errorsFound { get; set; }
  //rmarquardt end - S-423778 - 8/3/2016

  public Activity__c StartObj { get; set; }

  //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
  public String err { get; set; }
  //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 END
  // Start - Modified by Rakshit
  //START Commented by Komal V for Story S-705174 | 21/9/2023 |To hide 'LLO Initiative Planning' section
  //public list<ClientInitiativeAssignedMarketWrapper> lstCliIniAssMarkWrap{get;set;}
  //public list<ClientInitiativeLLOPlanningWrapper> lstCliIniLLOPlanWrap{get;set;}
  //END Commented by Komal V for Story S-705174 | 21/9/2023 |To hide 'LLO Initiative Planning' section
  public String colour { get; set; }
  private Set<Id> prodActivityIds;
  // End - Modified by Rakshit

  //Modified by Aditya Tiwari for S-546735 start
  public string primaryEmpString { get; set; }
  public boolean isreportrun { get; set; }
  //Modified by Aditya Tiwari for S-546735 End
  //START- Added by Sajal for S-569846
  public Date effEndDate { get; set; }
  public String effStartDate { get; set; }
  public String mySelectedOption { get; set; }
  public String EffectiveEndDateSelection { get; set; }
  public Boolean isCustom;
  //END for S-569846
  public Boolean NewRetainedBusinessFlag { get; set; } //Added by vinit for S-596102
  public List<OperatorSegment__c> SegmentOperatorList = new List<OperatorSegment__c>(); //Added by vinit for S-596102
  //START -- Added by Shivani for S-612902 on 03/05/2019
  public List<SuggestedProductWrapper> suggestedProdList { get; set; }
  public List<Related_Products__c> relatedProds;
  public List<Related_Products_Priority__c> relatedPriorityProds;
  //END -- Added by Shivani for S-612902 on 03/05/2019
  //START -- Added by Himanshu Baghmar | [S-682111] | [19-03-2021] | [For Call Notes History]
  public List<Activity__c> callHistoryNotes;
  public boolean displayCallHistoryNotesButton { get; set; }
  //END -- Added by Himanshu Baghmar | [S-682111] | [19-03-2021] | [For Call Notes History]
  //START -- Added by Shailendra for S-681111 on 25/03/2021
  public Menu_File__c menuFile { get; set; }
  public String mfOperatorId { get; set; }
  public String yesORNO { get; set; }
  public String mfEmployeeId { get; set; }
  public String callId { get; set; }
  // Start Riddhi
  public List<Menu_File__c> menuFileList { get; set; }
  public List<MenuFileWrapper> menuFileWrapperList { get; set; }
  // End Riddhi
  public String websiteLink { get; set; }

    //END -- Added by Shailendra for S-681111 on 25/03/2021
    //Praveen
    // public boolean boolchangeProdictId {get;set;} 
    //START -- Added by Gulab | [S-684595] | [03-06-2021]
    public boolean ViewTransactionalDataButton {get; set;} 
    public String KIId {get;set;}   
    //END -- Added by Gulab | [S-684595] | [03-06-2021]
    
    //START -  Added by ASL June 15th, 2022     S-695488    Variable to verify if the Activity has Product Activities.
    //  If it has at least 1 Product Activity record, it will show the button. Otherwise, it won't be shown.
    public Boolean showLogOppButton {get; set;}
    public List<ClientSKU> clientSKUList {get; set;}
    public Integer clientSKUListSize {get; set;}
    //END - Added by ASL June 15th, 2022    S-695488
    
    //START: Changes added by Gulab | S-696715 | 22-08-2022
    public ID CurrentEmployeeId{get; set;}
    //END: Changes added by Gulab | S-696715 | 22-08-2022
    //START-Added by komal V| S-705939 | 7-12-2023
    public string selectedProductStringIds {get;set;}
    public string selectedProductIds {get;set;}
    public list<ProductSalesOpportunity__c> listOfProductRecords {get;set;}
    public string salesOpptyIdrecord {get;set;}
    //END-Added by komal V| S-705939 | 7-12-2023
    
    // NCarson S-707655 - jsonString to hold products from targetedAssignment 
    public String targetedAssignmentProductsJSONString {get;set;}
    
    // START NCarson S-707646
    public String contactIds {get;set;}
    public String contactNames {get;set;}
    // END NCarson S-707646
    // Start | Added by Akshay Agarwal | S-707816 | 28/02/2025 
    public Integer charLimit { get; set; }
    public Integer charLimitCompInfo { get; set; }
    public Integer charLimitFeebackEl { get; set; }
    public Integer charLimitOperFedback {get ; set;}
    Public Integer charLimitQualityIssue {get ; set ;}
    public Integer charLimitNextStep { get ; set ;}
    // end | Added by Akshay Agarwal | S-707816  | 28/02/2025  
    
      /* Start Added - by Esoof | S-708135 | 011/09/2025  */
    public class ProductActivityWrappernew {
        public String employeeName { get; set; }
        public DateTime activityStartDate { get; set; }
        public String activityStatus { get; set; } 
        public DateTime MeetingClosedDate { get; set; }
        public ProductActivity__c productActivity { get; set; }
        }
    // NCarson S-708210 10/5/25 - transient 
    public transient List<ProductActivityWrappernew> wrapperList {get;set;}
    /* End Added - by Esoof | S-708135 | 011/09/2025  */

    // NCarson C-00358566 10/9/25 - is this a new or existing record
    public boolean isNewRecord {get;set;}
    
    public MeetingNow(){
      
        // Start | Added by Akshay Agarwal | S-707816 | 28/02/2025  
        Schema.DescribeFieldResult fieldDescribe = Activity__c.Description__c.getDescribe();
        charLimit = fieldDescribe.getLength();
        Schema.DescribeFieldResult fieldCompInfo = CommittedOrder__c.CompetitorInformation__c.getDescribe();
        charLimitCompInfo = fieldCompInfo.getLength();
        Schema.DescribeFieldResult fieldFeeback = CommittedOrder__c.Feedback__c.getDescribe();
        charLimitFeebackEl = fieldFeeback.getLength();
        Schema.DescribeFieldResult fieldOperatorFeedback = ProductActivity__c.OperatorFeedback__c.getDescribe();
        charLimitOperFedback= fieldOperatorFeedback.getLength();
        Schema.DescribeFieldResult fieldQualityIssue = ProductActivity__c.Quality_Issue__c.getDescribe();
        charLimitQualityIssue = fieldQualityIssue.getLength();
        Schema.DescribeFieldResult fieldNextStep = ProductActivity__c.What_are_next_steps__c.getDescribe();
        charLimitNextStep = fieldNextStep.getLength();
         // END |Akshay Agarwal | S-707816 | 28/02/2025      
         //START: Changes added by Gulab | S-696715 | 22-08-2022
           List<Employee__c> EmployeeList = [SELECT Id FROM Employee__c WHERE User__c = :UserInfo.getUserId()];
           if(EmployeeList.Size()>0){
               CurrentEmployeeId = EmployeeList[0].Id;
           }
         //END: Changes added by Gulab | S-696715 | 22-08-2022
        //START- Added by Sajal for S-569846
        // Start || Commented and Added effStartDate by Utkarsh || Case: 00356049 || 21/10/2024
        // effEndDate = Date.newInstance(1900,01,01);
        effEndDate = Date.newInstance(2200,01,01);
        effStartDate = Date.today().format();
        // End || Commented and Added effStartDate by Utkarsh || Case: 00356049 || 21/10/2024
        mySelectedOption  ='';
        isCustom = true;
        //END for S-569846
        // getLLOs() - Rakshit ,Description : to populate the LLO planning Wrapper
        //START Commented by Komal V for Story S-705174 | 21/9/2023 |To hide 'LLO Initiative Planning' section
        //getLLOs();
        //END Commented by Komal V for Story S-705174 | 21/9/2023 |To hide 'LLO Initiative Planning' section
        //Modified by Aditya Tiwari for S-554835 start
        //START -- Modified by Shivani | S-682791 | 05/05/2021 | [convert list to map]
        //UnwillingValues = new List<OptionWrapper>();
        UnwillingValues = new Map<String, List<OptionWrapper>>();
        //END -- Modified by Shivani | S-682791 | 05/05/2021 | [convert list to map]
        distNotSoldOptions = new List<DistributorNotSoldStatus>();
        Map<integer,string> alphaDigitMap = new Map<integer,string>{1 => 'a',2 => 'b',3 => 'c'};
            integer count = 1 ;
        for(Schema.PicklistEntry f : ProductActivity__c.Distributor_Not_Sold_Product_Status__c.getDescribe().getPicklistValues()) {
            string alpha = alphaDigitMap.get(count);
            distNotSoldOptions.add(new DistributorNotSoldStatus('ui-block-'+alpha, 'cccIcdist-option-'+count, f.getValue(),f.getLabel()));
            count++ ;
        }

    /*UnwillingValues.add(new OptionWrapper('checkbox-v-2a','checkbox-v-2a','One','textarea'));
        UnwillingValues.add(new OptionWrapper('checkbox-v-2b','checkbox-v-2b','Two','textarea'));//lookup
        UnwillingValues.add(new OptionWrapper('checkbox-v-2c','checkbox-v-2c','Three','textarea'));
        UnwillingValues.add(new OptionWrapper('checkbox-v-2d','checkbox-v-2d','Four','textarea')); */
        Schema.DescribeFieldResult fieldResult = ProductActivity__c.Reasons_unwilling_to_consider__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        integer con = 1;
        for( Schema.PicklistEntry f : ple)
        {
            if( f.getLabel() == 'Operator has a Competitive Loyalty'){
                //START -- Modified by Shivani | S-682791 | 05/05/2021 | [convert list to map]
                //UnwillingValues.add(new OptionWrapper(f.getLabel(), 'checkbox-v-2a'+ con,f.getLabel(),'lookup'));
                if(!UnwillingValues.containsKey('lookup')) {
                    UnwillingValues.put('lookup', new List<OptionWrapper>());
                }
                UnwillingValues.get('lookup').add(new OptionWrapper(f.getLabel(), 'checkbox-v-2a'+ con,f.getLabel(),'lookup'));
                //END -- Modified by Shivani | S-682791 | 05/05/2021 | [convert list to map]
            }
            else{
                //START -- Modified by Shivani | S-682791 | 05/05/2021 | [convert list to map]
                //UnwillingValues.add(new OptionWrapper(f.getLabel(), 'checkbox-v-2a'+ con,f.getLabel(),'textarea'));
                if(!UnwillingValues.containsKey('textarea')) {
                    UnwillingValues.put('textarea', new List<OptionWrapper>());
                }
                UnwillingValues.get('textarea').add(new OptionWrapper(f.getLabel(), 'checkbox-v-2a'+ con,f.getLabel(),'textarea'));
                //END -- MModified by Shivani | S-682791 | 05/05/2021 | [convert list to map]
            }

      con += 1;
    }

    /* Now OptionWrapper for Distributor Section*/

        notSoldReasonsDistributor = new List<OptionWrapper>();
        Schema.DescribeFieldResult fieldResults = ProductActivity__c.Distributor_Not_sold_Reasons__c.getDescribe();
        List<Schema.PicklistEntry> ples = fieldResults.getPicklistValues();
        integer cons = 1;
        for( Schema.PicklistEntry f : ples) {
            string depEle = getDependentElementId(f.getLabel());
            notSoldReasonsDistributor.add(new OptionWrapper(f.getLabel(), 'checkbox-sr-2a'+ cons,f.getLabel(),'textarea',depEle));
            cons += 1;
        }

        /* OptionWrapper for Distributor section SIP-New Item */
        //Distributer_SIP_New_Item__c
        notSoldReasonsSIPNewDistributor = new List<OptionWrapper>();
        Schema.DescribeFieldResult fieldResultsSIP = ProductActivity__c.Distributer_SIP_New_Item__c.getDescribe();
        List<Schema.PicklistEntry> pleSIP = fieldResultsSIP.getPicklistValues();
        integer conr = 1;
        for( Schema.PicklistEntry f : pleSIP) {
            string depEle = getDependentElementId(f.getLabel());
            //Make sure the checkbox id are unique for different Feedback Elaboration
            notSoldReasonsSIPNewDistributor.add(new OptionWrapper(f.getLabel(), 'checkbox-sr-2o'+ conr,f.getLabel(),'textarea',depEle));
            conr += 1;
        }

    /* OptionWrapper for Distributor section / Not sold result is final */
    notSoldReasonsDistributorfinal = new List<OptionWrapper>();
    Schema.DescribeFieldResult fieldResultNotSold = ProductActivity__c.Distributor_Not_sold_Reasons_final__c.getDescribe();

        List<Schema.PicklistEntry> plesv = fieldResultNotSold.getPicklistValues();
        integer conv = 1;
        //system.assert(false,plesv);
        for( Schema.PicklistEntry f : plesv) {
            notSoldReasonsDistributorfinal.add(new OptionWrapper(f.getLabel(), 'checkbox-sn-2a'+ conv,f.getLabel(),'textarea'));
            conv += 1;
        }

    //Distributor_New_Item_Reasons_Final

    newItemDistributorfinal = new List<OptionWrapper>();
    Schema.DescribeFieldResult fieldResultNewItem = ProductActivity__c.Distributor_New_Item_Reasons_Final__c.getDescribe();

        List<Schema.PicklistEntry> plesvs = fieldResultNewItem.getPicklistValues();
        integer connew = 1;
        //system.assert(false,plesv);
        for( Schema.PicklistEntry f : plesvs) {
            string depEle = getDependentElementId(f.getLabel());
            newItemDistributorfinal.add(new OptionWrapper(f.getLabel(), 'checkbox-ni-2a'+ connew,f.getLabel(),'textarea',depEle));
            connew += 1;
        }
        //system.assert( false, notSoldReasonsDistributorfinal);
        //Modified by Aditya Tiwari for S-554835 End
        //selectTest = 'SYSCO - CENTRAL PA 04';
        isCompleted = false;  // S-339867 - Hemlata
        commitOrder = new CommittedOrder__c(); // S-343194 - Hemlata
        //Start Jai Gupta - S-339868 - Aug 18,2015
        notSoldPAIds = '' ;
        separator = ':' ;
        isClosingMeeting = false; //Added by Shobhit Pant For Case 00227972 05/21/2018 - initializing the variable
        /** Code modified - Padmesh Soni (02/18/2017 Appirio Offshore) - S-467938 - Start **/
        MarketId = '';
        /** Code modified - Padmesh Soni (02/18/2017 Appirio Offshore) - S-467938 - End **/

        reasonUnSoldWithFollowUpCall = new map<string,Followup_Call_Mapping__c>();
        for(Followup_Call_Mapping__c fcm : Followup_Call_Mapping__c.getAll().values()) {
            reasonUnSoldWithFollowUpCall.put(fcm.Reason_Unsold__c.toLowerCase(),fcm);
        }
        JsonReasonUnSoldWithFollowUpCall = JSON.serialize(reasonUnSoldWithFollowUpCall);
        //End Jai Gupta - S-339868 - Aug 18,2015
        //Added by Shubham for Story S-426804 #Start
        purchaseFreqHelpTextMap = new map<String, String>();
        saleTypeHelpTextMap = new map<String, String>();
        for(Purchase_Frequency_Mapping__c pf : Purchase_Frequency_Mapping__c.getAll().values()){
            purchaseFreqHelpTextMap.put(pf.Picklist_Value__c.toLowerCase(), pf.Help_Text__c);
        }
        JsonPurchaseFreqHelpTextMap = JSON.serialize(purchaseFreqHelpTextMap);
        for(Sale_Type_Mapping__c st : Sale_Type_Mapping__c.getAll().values()){
            saleTypeHelpTextMap.put(st.Picklist_Value__c.toLowerCase(), st.Help_Text__c);
        }
        JsonSaleTypeHelpTextMap = JSON.serialize(saleTypeHelpTextMap);
        //Added by Shubham for Story S-426804 #End
        //Create the start and end objects
        StartObj = new Activity__c();
        StartObj.TempDate__c = null;

    // Added by vinit for S-596102 start
        String callId = ApexPages.currentPage().getParameters().get('Id');

        // START NCarson C-00358566 10/9/25 - set isNewRecord
        String newRecordParameter = ApexPages.currentPage().getParameters().get('newRecord');
        
        this.isNewRecord = String.isBlank(callId) || newRecordParameter == 'true';
        // END NCarson C-00358566 10/9/25

        /* START Added - by Esoof | S-708135 | 08/09/2025 */
             List<Activity__c> accList = [
                                SELECT Id, Employee__r.Name, StartDate__c, Status__c,MeetingClosedDate__c,Operator__c
                                    FROM Activity__c
                                    WHERE Id = :callId ORDER BY StartDate__c DESC
                            ];
             String operatorId = accList.size() > 0 ? accList[0].Operator__c : null;
                       // START | Prakhar | S-708187 | Added Activity__r.Distributor__r.Name in the query
                    List<ProductActivityWrappernew> wrapperList = new List<ProductActivityWrappernew>();
                    // START NCarson S-708210 11/3/25 - only query if OperatorId is set
                    List<ProductActivity__c> productActivityLists = new List<ProductActivity__c>();
                    if (String.isNotBlank(operatorId)) {
                      productActivityLists = [
                        SELECT Id, Operator__r.Id, Activity__r.Operator__c, 
                               Product__r.Name, Product__r.SKU__c,  What_are_next_steps__c,  //Case 00358747 || added new field What_are_next_steps__c by Swastika
                               Activity__r.Id, ProductStatus__c, Product__r.Manufacturer__r.Name, Product__r.ProductCategory__r.Name,
                               Activity__r.Employee__r.Name,Activity__r.Distributor__r.Name, CommittedOrder__r.Quantity__c,
                               CommittedOrder__r.Quantity_Entered__c, SC_Client__c, tf_Product_Name__c, Product_SKU__c,
                               Product__r.CategoryName__c, ExpandedProductStatus__c, Activity__r.StartDate__c,
                               Activity__r.Status__c, Activity__r.MeetingClosedDate__c,Product__r.ProductFamily__r.Name
                        FROM ProductActivity__c
                        WHERE Operator__c = :operatorId
                        and Activity__r.Status__c ='Completed'
                        ORDER BY Activity__r.StartDate__c DESC
                        LIMIT 1000 // NCarson C-00358536 - LIMIT 1000, as this is limited by the VF Collection Limit
                      ];
                    } // END NCarson S-708210 11/3/25
                      // End | Prakhar | S-708187 | Added Activity__r.Distributor__r.Name in the query
                for (ProductActivity__c pa : productActivityLists) {
                    ProductActivityWrappernew wrap = new ProductActivityWrappernew();
                    if (accList.size() > 0) {
                          wrap.employeeName = accList[0].Employee__r.Name;
                          wrap.activityStartDate = accList[0].StartDate__c;
                          wrap.activityStatus = accList[0].Status__c;
                          wrap.MeetingClosedDate = accList[0].MeetingClosedDate__c;
                          wrap.productActivity = pa;
                    }
                    wrapperList.add(wrap);
                }
            this.wrapperList = wrapperList;
        /* End  Added - by Esoof | S-708135 | 08/09/2025  */
        
        if (String.isNotBlank(callId)) {

            for (Activity__c actvt : [SELECT Operator__c FROM Activity__c WHERE Id =:callId]) {
                OperatorId = actvt.Operator__c;
            }
        }
        
        // START NCarson S-707655 - incoming from Targeted Assignments page
        String targetedAssignmentsId = ApexPages.currentPage().getParameters().get('targetedAssignments');
        if (!String.isBlank(targetedAssignmentsId)) {
          // START NCarson S-708258 2/3/26 - set distributor based on Operator
          List<Targeted_Assignments__c> taList = [SELECT Id, Account__c, Account__r.Primary_Distributor__c,
                                                   (SELECT Id, Product__c, Product__r.Name, Product__r.SKU__c, Product__r.Manufacturer__r.Name, Product__r.Sample_Pack_Size__c 
                                                    FROM Targeted_Assignments_Qualifying_Products__r) 
                                                  FROM Targeted_Assignments__c WHERE Id = :targetedAssignmentsId LIMIT 1];
          if (taList.size() > 0 && taList[0].Account__c != null) {
             //Start | 00358544 | Prakhar | Change OperatorId -> This.OperatorId | 10/6/25
              this.OperatorId = taList[0].Account__c;
              this.DistributorId = taList[0].Account__r.Primary_Distributor__c;
              //End | 00358544 | Prakhar | Change OperatorId -> This.OperatorId | 10/6/25
            targetedAssignmentProductsJSONString = JSON.serialize(taList[0].Targeted_Assignments_Qualifying_Products__r);
          }
        } // END NCarson S-707655
        //start | Added for S-708207
        String pipelineOppsId =  ApexPages.currentPage().getParameters().get('pipelineOpps');
        if(!String.isBlank(pipelineOppsId)){
            List<SalesOpportunity__c> SalesOppList = [SELECT Id, Operator__c, Operator__r.Primary_Distributor__c FROM SalesOpportunity__c WHERE Id = :pipelineOppsId  ];
            if(SalesOppList.size() > 0 && SalesOppList[0].Operator__c != null){
                this.OperatorId = SalesOppList[0].Operator__c;
                this.DistributorId = SalesOppList[0].Operator__r.Primary_Distributor__c;
            } // END NCarson S-708258 2/3/26
        }
        //End | Added for S-708207
        System.debug('OperatorId '+OperatorId);
        
        //START -- Added by Himanshu Baghmar | [S-682111] | [19-03-2021] | [For Call Notes History]
        displayCallHistoryNotesButton = false;
        callHistoryNotes = new List<Activity__c>();
        // START || Updated by Rahul T | (C-00329375) | [25-05-2021] | [To make view history notes visible in descending order]
        // NCarson 12/3/23 - add LIMIT 500 to get under collection size limit 
        for(Activity__c actvy : [Select Id, Description__c, Status__c, CreatedDate, MeetingClosedDate__c, Employee__r.Name From Activity__c where Id != :callId and Operator__c = :OperatorId order by CreatedDate desc LIMIT 500]){
        // End || Updated by Rahul T | (C-00329375) | [25-05-2021] | [To make view history notes visible in descending order]
            if(!String.isBlank(actvy.Description__c)){
                callHistoryNotes.add(actvy);
            }
        }
        if(callHistoryNotes.size() > 0 && callHistoryNotes != NULL){
            displayCallHistoryNotesButton = true;
        }
        //END -- Added by Himanshu Baghmar | [S-682111] | [19-03-2021] | [For Call Notes History]
        
        // NCarson 12/3/23 - limit 45000 to avoid ceiling exception
        // START NCarson S-708210 11/3/25 - skip query is operatorId is null
        SegmentOperatorList = new List<OperatorSegment__c>();
        if (String.isNotBlank(OperatorId)) {
          // NCarson 12/3/23 - limit 45000 to avoid ceiling exception
          SegmentOperatorList = [SELECT Affiliation__r.SubSegment__r.Segment__r.Name,
                               Affiliation__r.SubSegment__r.Segment__r.Id,
                               Affiliation__r.SubSegment__r.Name,
                               Affiliation__r.Title__c,
                               Affiliation__r.Id
                               FROM
                               OperatorSegment__c WHERE Account__c = :OperatorId
                               ORDER BY
                               Affiliation__r.SubSegment__r.Segment__r.Name ASC,
                               Affiliation__r.SubSegment__r.Name ASC,
                               Affiliation__r.Title__c ASC
                               LIMIT 5
          ];
        } // END NCarson S-708210 
        for(OperatorSegment__c os : SegmentOperatorList) {
            if (SegmentOperatorList.get(0) == os) {
                if ('K-12'.equalsIgnoreCase(os.Affiliation__r.SubSegment__r.Name)) {
                    NewRetainedBusinessFlag = true;
                }
            }
        }

    // Added by vinit for S-596102 end
    ProductsMap = new Map<String, Boolean>(); // Added by vinit for S-644696/S-645821 [14-Nov-2019]
    productActiHistory = new List<ProductActivity__c>(); // Added by vinit for S-644696/S-645821 [14-Nov-2019]
    //START -- Added by Shailendra for S-681111 on 25/03/2021
    callId = ApexPages.currentPage().getParameters().get('Id');

    menuFile = new menu_file__c();
    // Start Riddhi
    menuFileList = new List<Menu_File__c>();
    menuFileWrapperList = new List<MenuFileWrapper>();
    // End Riddhi

        Activity__c[] act = [Select Id, Operator__r.Id,Employee__r.Id from Activity__c Where Id =: callId Limit 1];

    if (act.size() > 0) {
      if (act[0].Operator__r.Id != null) {
        mfOperatorId = act[0].Operator__r.Id;

        menuFileWrapperList = getMenuWrapperList(mfOperatorId);
      }

      if (act[0].Employee__r.Id != null) {
        mfEmployeeId = act[0].Employee__r.Id;
      }

      if (menuFileWrapperList.size() > 0)
        yesORNo = 'YES';
      else
        yesORNo = 'NO';
    }

    //END -- Added by Shailendra for S-681111 on 25/03/2021

    // START NCarson S-707880 - initialize existing Product Id set to empty set
    existingProductIdSet = new Set<String>();
    List<SalesOpportunity__c> salesOppList = [
      SELECT Id, Name, (SELECT Product__c FROM Product_Sales_Opportunities__r)
      FROM SalesOpportunity__c
      WHERE Operator__c = :OperatorId
      AND Status__c = 'Active'
    ];

    for (SalesOpportunity__c salesOpp : salesOppList) {
      for (
        ProductSalesOpportunity__c pso : salesOpp.Product_Sales_Opportunities__r
      ) {
        if (pso.Product__c != null) {
          existingProductIdSet.add(pso.Product__c);
        }
      }
    }

    existingProductIdString = existingProductIdSet.toString();
    // END NCarson S-707880
  }

  //START -- Added by Shailendra for S-681111 on 25/03/2021

  // START NCarson C-171717 2/4/26 - new method to sort records
  public String sortRecords() {
    System.debug('The records are sorted! This is amazing, what a great method this is.');
  } // END NCarson C-171717 2/4/26

    // Start Riddhi
     public List<MenuFileWrapper> getMenuWrapperList(Id operatorId){

          List<MenuFileWrapper> tempWrapper = new List<MenuFileWrapper>();
        // Start Riddhi
            List<Menu_File__c> mfRecordList = [select
                Id,Name, Menu_type__c,Operator__r.Name,Website_Link__c,Employee__r.Name,Content_Version__c,
                CreatedDate
                from Menu_File__c where operator__r.Id =: operatorId ORDER BY Name Limit 10];
            set<id> mfSet = new set<id>();
            for(Menu_File__c mf : mfRecordList) {
                if(mf.Menu_type__c == 'Attachment') {
                    mfSet.add(mf.Id);
                }
            }

            Map<Id, Id> mfContentVersionMap = new Map<Id, Id> ();
            //Comment Start: changes added by Gulab | S-686452 | 06/09/2021
            Map<Id, String> mfFileNameMap = new Map<Id, String> ();
            //Comment End: changes added by Gulab | S-686452 | 06/09/2021
            if(mfSet.size() > 0) {
                //Comment Start: changes added by Gulab | S-686452 | 06/09/2021
                //for(ContentDocumentLink cdl : [Select Id,ContentDocumentId,LinkedEntityId, ContentDocument.LatestPublishedVersionId from ContentDocumentLink where LinkedEntityId IN : mfSet]) {
                //    mfContentVersionMap.put(cdl.LinkedEntityId, cdl.ContentDocument.LatestPublishedVersionId);
                //}
                for(ContentDocumentLink cdl : [Select Id,ContentDocumentId,LinkedEntityId, ContentDocument.LatestPublishedVersionId,ContentDocument.title from ContentDocumentLink where LinkedEntityId IN : mfSet]) {
                    mfContentVersionMap.put(cdl.LinkedEntityId, cdl.ContentDocument.LatestPublishedVersionId);
                    mfFileNameMap.put(cdl.LinkedEntityId,cdl.ContentDocument.title);
                }
                //Comment End: changes added by Gulab | S-686452 | 06/09/2021
            }
            for(Menu_File__c mf : mfRecordList) {
                MenuFileWrapper mfw = new MenuFileWrapper();
                mfw.mf = mf ;
                //Comment Start: changes added by Gulab | S-686452 | 06/09/2021
                mfw.filename = mf.Name;
                //Comment End: changes added by Gulab | S-686452 | 06/09/2021
                if(mf.Menu_type__c == 'Attachment') {
                    if(mfContentVersionMap != null && mfContentVersionMap.containsKey(mf.Id)) {
                        mfw.contentversionId = mfContentVersionMap.get(mf.Id);
                        //Comment Start: changes added by Gulab | S-686452 | 06/09/2021
                        mfw.filename = mfFileNameMap.get(mf.Id);
                        //Comment End: changes added by Gulab | S-686452 | 06/09/2021
                    }
                }
                tempWrapper.add(mfw);
            }
            return tempWrapper;
                // End Riddhi

    }

    public PageReference submitLink() {

        if(mfOperatorId != null && mfEmployeeId != null){

            List<menu_file__c> lstMenuFile = [Select Id from menu_file__c Where operator__c =: mfOperatorId AND Website_Link__c != null And Website_Link__c != ''];

             if(String.isNotBlank(websiteLink) && (websiteLink.contains('HTTPS://') || websiteLink.contains('HTTP://'))) {
                websiteLink = websiteLink.replaceAll('HTTPS://|HTTP://', '');
            }

            if(lstMenuFile.size() >= 5){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You can submit only 5 website links'));
            }
            else{

                try {
                    //Start | Added by Rahul | I-419075 | to get login user as employee | 4/5/2021
                       Employee__c emp =[select id,UserID__c from Employee__c where UserID__c=:userinfo.getUserName()];
                    menuFile.operator__c = mfOperatorId;
                    menuFile.menu_type__c = 'Website Link';
                    menuFile.Employee__c =  emp.Id;
                    //End | Added by Rahul | I-419075 | to get login user as employee | 4/5/2021
                    menuFile.Website_Link__c = websiteLink;
                    insert menuFile;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Website Link Submitted successfully'));
                } catch (DMLException e) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new Menu File.'));
                    return null;
                }


            }

        }
       DeleteMenuFile();
        menuFile = new menu_file__c();
       //  menuFile = null;
        return null;
    }



    public PageReference DeleteMenuFile(String SelectedMenuFileId)
    {
        // if for any reason we are missing the reference
        if (SelectedMenuFileId == null) {

            return null;
        }

        // find the account record within the collection
        if(SelectedMenuFileId != null && SelectedMenuFileId != ''){

            List<Menu_file__c> lstMenuFiles = [Select Id,Operator__r.Id from menu_file__c Where Id =: SelectedMenuFileId];
            Menu_File__c tobeDeleted = null;

      if (lstMenuFiles.Size() > 0) {
        for (Menu_File__c mf : lstMenuFiles) {
          if (mf.Id == SelectedMenuFileId) {
            tobeDeleted = mf;
            break;
          }
        }
      }

            //if menuFile record found delete it
            if (tobeDeleted != null) {
                Delete tobeDeleted;
            }
            DeleteMenuFile();

        }
        return null;
    }

  public PageReference DeleteMenuFile() {
    menuFileWrapperList = getMenuWrapperList(mfOperatorId);
    if (menuFileWrapperList.size() > 0)
      yesORNo = 'YES';
    else
      yesORNo = 'NO';
    return null;
  }

    //END -- Added by Shailendra for S-681111 on 25/03/2021
    // Jai Gupta distributor feedback
    public string getDependentElementId(string label) {
        string depEle = '';
        if(label == 'Pricing Needs Adjustment') {
            depEle = 'trPricingDistributor' ;
        } else if(label == 'Product under review' || label == 'Conversion under review') {
            depEle = 'trExpectDecisionDist' ;
        } else if(label == 'Quality not acceptable') {
            depEle = 'trPhotoNewItemQuality trspecificIssueDistributor' ;
        } else if(label == 'Marketing Program unacceptable') {
            depEle = 'trClientPay trMarketingExist' ;
        }
        return depEle;
    }
    //Start Riddhi S-681111
    public class MenuFileWrapper {
        public Menu_File__c mf {get;set;}
        public string contentversionId {get;set;}
        //Comment Start: changes added by Gulab | S-686452 | 06/09/2021
        public string filename {get;set;}
        //Comment End: changes added by Gulab | S-686452 | 06/09/2021
    }
    //End Riddhi S-681111
    public class DistrubutorClass{
        public CommittedOrder__c co {get; set;}
        public String selectedDistributor{get;set;}
        public boolean isSelected{get;set;}
        public String distriName {get;set;}
        public DistrubutorClass(CommittedOrder__c co, String selectedDistributor, boolean isSelected){
            this.co = co;
            this.selectedDistributor = selectedDistributor;
            this.isSelected = isSelected;
        }

    public String getselectedDistributor() {
      return selectedDistributor;
    }

    public void setselectedDistributor(String distributer) {
      this.selectedDistributor = distributer;
    }
  }
  //Added by Lalit for S-334717 END

  /*getter methods*/

    // Added for the Story S-260649 #START
    public void actionFunMethod() {

        BusinessObjectiveActivity__c boaOb =  new BusinessObjectiveActivity__c(id = (Id)BoaId);
        boaOb.Completed__c = CheckboxValue;
        update boaOb;

    }
    // Added for the Story S-260649 #END
    // created for Story S-265745 by Paras Dhingra on 11/20/2014 #Start

  public List<Contact> getContacts2() {
    return LookupAJAXResourceNew.getDistributorOperatorContacts(SalesCallId);
  }
  // Story S-265745 #End

  //START -- Added by Himanshu Baghmar | [S-682111] | [19-03-2021] | [For Call Notes History]
  public List<Activity__c> getcallHistoryNotesRecords() {
    return callHistoryNotes;
  }
  //END -- Added by Himanshu Baghmar | [S-682111] | [19-03-2021] | [For Call Notes History]

  public List<SelectOption> getProductStatuses() {
    List<SelectOption> options = new List<SelectOption>();
    for (
      Schema.PicklistEntry f : ProductActivity__c.ProductStatus__c.getDescribe()
        .getPicklistValues()
    ) {
      //START-Added condition by komal for Story S-705177 | 4/10/2023 | Adding "Not Shown" filter for picklist value
      //START-Commented BY Komal for Story 705593 | 13/10/2023 | to remove referece 'Not Shown' -
      //if (!f.getValue().equals('Not Shown')) {
      options.add(new SelectOption(f.getLabel(), f.getValue()));
      //}
      //END-Commented BY Komal for Story 705593 | 13/10/2023 | to remove referece 'Not Shown' -
    }
    //END-Added condition by komal for Story S-705177 | 4/10/2023 |
    return options;
  }
  //Modified by Aditya Tiwari for S-554835 Start
  public List<SelectOption> getOperatorUnderContract() {
    List<SelectOption> options = new List<SelectOption>();
    for (
      Schema.PicklistEntry f : ProductActivity__c.Is_operator_under_contract__c.getDescribe()
        .getPicklistValues()
    ) {
      options.add(new SelectOption(f.getLabel(), f.getValue()));
    }
    return options;
  }
  // Added by vinit for S-644696/S-645821 [14-Nov-2019] start
  /**
   * Get product activity history by product id and account id
   * @Param none
   * @Return none
   * */
  // START || S-708058 || I-437507 || updated by Prashant || 15/07/2025 || Change the return type from PageReference to void || I-437507
  public void getProdActHistory() {
  // END || S-708058 || I-437507 || updated by Prashant || 15/07/2025 || Change the return type from PageReference to void || I-437507
    System.debug('selected Product id ' + prdId);
    productActiHistory = [
      SELECT
        Id,
        Product__r.Id,
        ProductStatus__c,
        Activity__r.MeetingClosedDate__c,
        Activity__r.Id
      FROM ProductActivity__c
      WHERE
        product__c = :prdId
        AND Operator__c = :OperatorId
        AND Activity__r.status__c = 'Completed'
      ORDER BY Activity__r.MeetingClosedDate__c DESC
    ]; // Code changes done by Ravi Jain for case 00274126

    System.debug('productActiHistory ' + productActiHistory);
    // START || S-708058 || I-437507 || updated by Prashant || 14/07/2025 || commenting MeetNow page Url
    /*
    PageReference pg2 = null;
    if (productActiHistory.Size() == 1) {
      pg2 = new Pagereference(
        '/apex/MeetingNow?Id=' +
          productActiHistory[0].Activity__r.Id +
          '&fromViewHist=true&prodActId=' +
          productActiHistory[0].Id +
          '&productStatus=' +
          productActiHistory[0].ProductStatus__c +
          '&FromPage=MeetingNow&PrevActId=' +
          SalesCallId
      );
      pg2.setRedirect(true);
    }
    return pg2;
    */
    // END || S-708058 || I-437507 || updated by Prashant || 14/07/2025 || commenting MeetNow page Url
  }
  // Added by vinit for S-644696/S-645821 [14-Nov-2019] end

  /*public List<PicklistWrapper> getunWillingReasons() {
        picklistValues = new List<PicklistWrapper>();
        Schema.DescribeFieldResult fieldResult = ProductActivity__c.Reasons_unwilling_to_consider__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry f : ple) {
            picklistValues.add(new PicklistWrapper(f.getLabel(), false));
        }
        return picklistValues;
        }
        */
  /*
        public List<OptionWrapper> getUnwillingValues(){
        UnwillingValues = new List<OptionWrapper>();
        Schema.DescribeFieldResult fieldResult = ProductActivity__c.Reasons_unwilling_to_consider__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple) {
            UnwillingValues.add(new OptionWrapper(f.getLabel(), 'checkbox-v-2a',f.getLabel(),'textarea'));
        }
        return UnwillingValues;
    }
*/
    public List<SelectOption> getunWillingReasons () {

        List<SelectOption> options  = new List<SelectOption>();
        for(Schema.PicklistEntry f : ProductActivity__c.Reasons_unwilling_to_consider__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    /*
    public PageReference showValues() {
        for(PicklistWrapper wrapper : picklistValues) {
        System.debug(wrapper.value + '--->'+wrapper.isSelected);
        }
        return null;
    } */
    //Modified by Aditya Tiwari for S-554835 End
    public map<String,String> getUnits() {
        map<String,String> options  = new map<String,String>();//{ '' => '--' };
        for(Schema.PicklistEntry f : CommittedOrder__c.MeasurementUnits__c.getDescribe().getPicklistValues()) {
            options.put(f.getLabel(), f.getValue());
        }
        return options;
    }

  public map<String, String> getContacts() {
    map<String, String> options = new Map<String, String>{ '' => '--' };

        try {
            // NCarson - LIMIT 200 to get under Collection size Limit ceiling 
            for(Contact c : [SELECT Id, Name FROM Contact WHERE AccountId = :OperatorId LIMIT 200]) {
                options.put(c.Id, c.Name);
            }
        }
        catch(Exception e) { DisplayQuickError(e); }

    return options;
  }

    public List<SelectOption> getContactOptions() {
        List<SelectOption> options = new List<SelectOption>{ new SelectOption('', '--') };
        try {
            // NCarson - LIMIT 200 to get under Collection size Limit ceiling 
            for(Contact c : [SELECT Id, Name FROM Contact WHERE AccountId = :OperatorId LIMIT 200]) {
                options.add(new SelectOption(c.Id, c.Name));
            }
        }
        catch(Exception e) { DisplayQuickError(e); }
        return options;
    }
    
    // START NCarson S-707646 - alternative approach to getContactOptions
    public class ContactOption {
      public String label {get;set;}
      public String value {get;set;}
      public String checked {get;set;}
      public boolean isChecked {get;set;}
      public boolean isPrimary {get;set;}
    }
    
    //Start || case 00357455 || List has no rows error on Targeted Assignments tab
    public List<ContactOption> getOptionsForContact() {
      String callId = ApexPages.currentPage().getParameters().get('Id');
      List<ContactOption> options = new List<ContactOption>(); // { new SelectOption('', '--') };
        
        if(String.isNotBlank(callId)){
        try {

                Activity__c act = [SELECT Id, Contact_Ids__c FROM Activity__c WHERE Id = :callId LIMIT 1];
            for(Contact c : [SELECT Id, Name, PrimaryContact__c FROM Contact WHERE AccountId = :OperatorId 
                             ORDER BY PrimaryContact__c DESC, Name ASC LIMIT 200]) {
                ContactOption co = new ContactOption();
                co.label = c.Name;
                if (c.PrimaryContact__c != null && c.PrimaryContact__c) {
                  co.label += ' (Primary Contact)';
                }
                co.value = c.Id;
                co.checked = null;
                co.isChecked = FALSE;
                co.isPrimary = c.PrimaryContact__c;
                if (act.Contact_Ids__c != null && act.contact_Ids__c.indexOf(c.Id) > -1) {
                  co.checked = 'checked';
                  co.isChecked = TRUE;
                }
                options.add(co);
            }
        
    } catch(Exception e) { DisplayQuickError(e); }
                    }
        return options;   
    }
    //End || case 00357455 || List has no rows error on Targeted Assignments tab
    // END NCarson S-707646

    public List<SelectOption> getFeedbackType() {
        List<SelectOption> options = new List<SelectOption>{ new SelectOption('', '--') };

            //START- Added by Sajal for S-569846
            //for(Account a: [SELECT Id, (SELECT Id, SubSegment_Name__c, SubSegment__c, SubSegment__r.Name FROM OperatorSegments__r ORDER BY CreatedDate LIMIT 1  ) FROM Account WHERE Id = :OperatorId]){
            if(!SegmentOperatorList.isEmpty()){
                for(OperatorSegment__c opSeg: SegmentOperatorList){
                    for(Schema.PicklistEntry f : CommittedOrder__c.FeedbackType__c.getDescribe().getPicklistValues()) {
                        if('K-12'.equalsIgnoreCase(opSeg.Affiliation__r.SubSegment__r.Name)  && ((f.getLabel() == 'Specific Menu Placement / LTO' || f.getLabel() == 'Trial Order Only')
                                                                                                 && (!options.contains(new SelectOption(f.getLabel(), f.getLabel()))))){
                                                                                                     options.add(new SelectOption(f.getLabel(),f.getValue()));
                        }
                        else if(!('K-12'.equalsIgnoreCase(opSeg.Affiliation__r.SubSegment__r.Name))
                                && (!options.contains(new SelectOption(f.getLabel(), f.getLabel())))) {
                                    options.add(new SelectOption(f.getLabel(),f.getLabel()));
                        }
                    }
                }
            }
        else {
            for(Schema.PicklistEntry f : CommittedOrder__c.FeedbackType__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(f.getLabel(),f.getLabel()));
            }
        }
        //END for S-569846

    return options;
  }

  // Added By Vinit for S-613633 Start

    public List<SelectOption> getSupportedReason() {
        List<SelectOption> options = new List<SelectOption>{new SelectOption('','--')};

            for (Schema.PicklistEntry value : ProductActivity__c.Supported_Reason__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(value.getLabel(),value.getLabel()));
            }
        return options;
    }

  // Added By Vinit for S-613633 End

    // START TNOE - S-569853 - set Using Purchase Frequency picklist
    public List<SelectOption> getUsingPurchaseFrequency() {
        List<SelectOption> options = new List<SelectOption>{ new SelectOption('', '--') };
        for(Schema.PicklistEntry f : ProductActivity__c.Using_Purchase_Frequency__c.getDescribe().getPicklistValues()) {
            //Modified by Vinit for S-581469 Start
            if (!('Limited Time Offer'.equalsIgnoreCase(f.getLabel()))) {
                options.add(new SelectOption(f.getLabel(),f.getLabel()));
            }
            //Modified by Vinit for S-581469 End
        }
        return options;
    }
    // END TNOE - S-569853

    //Added by Shubham for Story S-426804 #Start
    public List<SelectOption> getSaleType() {
        List<SelectOption> options = new List<SelectOption>{ new SelectOption('', '--') };
        for(Schema.PicklistEntry f : CommittedOrder__c.Sale_Type__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    //Added by Shubham for Story S-426804 #End

    public map<String,String> getDistributors() {
        map<String,String> options  = new map<String,String>{ '' => '--' };
        try {
            for(Account a : [SELECT Id, Name FROM Account WHERE Type = 'Distributor' AND Market__c = :SalesCall.Operator__r.Market__r.Id ORDER BY Name ASC]) {
                options.put(a.Id, a.Name);
            }
        }
        catch (Exception e) { DisplayQuickError(e); }
        return options;
    }
    //Added by Lalit for S-334717 START
    public List<SelectOption> getPickDistributors() {
        List<SelectOption> options  = new List<SelectOption>{ new SelectOption('-None-', '-None-') };
        for(Account a : [SELECT Id, Name FROM Account WHERE Type = 'Distributor' AND Market__c = :SalesCall.Operator__r.Market__r.Id ORDER BY Name ASC]) {
            options.add(new SelectOption(a.name, a.name));
            distributorMap.put(a.Name,a);
        }
        return options;
    }

    public void addCommitedOrder() {
        for(Integer i = 0; i<5;i++) {
            DistrubutorClass wrapperObj = new DistrubutorClass(new CommittedOrder__c(), '',false);
            //wrapperObj.distriName = 'test';
            cowrapper.add(wrapperObj);
        }
    }

  //Added by Lalit for S-334717 END

    public List<SelectOption> getNotSoldReasons() {
        List<SelectOption> options  = new List<SelectOption>{ new SelectOption('', '--') };
        for(Schema.PicklistEntry f : ProductActivity__c.OperatorFeedbackReasons__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    //MP

    public List<SelectOption> getInprogressOperator() {
        List<SelectOption> options  = new List<SelectOption>{ new SelectOption('', '--') };
        for(Schema.PicklistEntry f : ProductActivity__c.Sales_in_Progress__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }


    //MP
    // Start - Jai Gupta - S-339868 - Aug 17,2015
    public List<SelectOption> getSalesProcessFollowUp() {
        List<SelectOption> options  = new List<SelectOption>{ new SelectOption('', '--') };
        for(Schema.PicklistEntry f : ProductActivity__c.Sale_Progress_Follow_up_Call__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }
    // End - Jai Gupta - S-339868 - Aug 17,2015

  //Aditya Start S-554835
  //START -- Modified by Shivani | S-682791 | 05/05/2021 | [convert list to map]
  //public List<OptionWrapper> UnwillingValues {get;set;}
  public Map<String, List<OptionWrapper>> UnwillingValues { get; set; }
  //END -- Modified by Shivani | S-682791 | 05/05/2021 | [convert list to map]
  public List<OptionWrapper> notSoldReasonsDistributor { get; set; }

    public List<OptionWrapper> notSoldReasonsDistributorfinal {get;set;}
    public List<OptionWrapper> notSoldReasonsSIPNewDistributor {get;set;}
    public List<optionWrapper> newItemDistributorfinal{get;set;}
    public class OptionWrapper {
        public string name {get;set;}
        public string id {get;set;}
        public string pickListVal {get;set;}
        public string feedbackElementtype {get;set;}
        public string dependentElementId {get;set;}
        public OptionWrapper(string n, string i, string v, string fed) {
            name = n ;
            id = i ;
            pickListVal = v ;
            feedbackElementtype = fed;

        }
        public OptionWrapper(string n, string i, string v, string fed, String depEleId) {
            name = n ;
            id = i ;
            pickListVal = v ;
            feedbackElementtype = fed;
            dependentElementId = depEleId ;

        }
    }

  public list<DistributorNotSoldStatus> distNotSoldOptions { get; set; }
  public class DistributorNotSoldStatus {
    public string uiClass { get; set; }
    public string checkboxId { get; set; }
    public string checkboxVal { get; set; }
    public string checkboxLabel { get; set; }
    public DistributorNotSoldStatus(string n, string i, string v, string fed) {
      uiClass = n;
      checkboxId = i;
      checkboxVal = v;
      checkboxLabel = fed;
    }
  }

  /*public string parseMultiOptions(string feedbackValues) {
        List<string> splittedFeedbacks = feedbackValues.split(', ');
        List<string> multipleSelectedOptions = new List<string>();
        for(String str: splittedFeedbacks) {
            multipleSelectedOptions.add(str.split(': ')[0]);
        }
        return String.join(multipleSelectedOptions, ';');
    }*/

    public List<SelectOption> getSalesReasonsUnsold() {
        List<SelectOption> options  = new List<SelectOption>{ new SelectOption('', '--') };
        for(Schema.PicklistEntry f : ProductActivity__c.Reasons_unsold__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }

    public List<SelectOption> getEstimatedWeeklySalesVolume() {
        List<SelectOption> options  = new List<SelectOption>{ new SelectOption('', '--') };
        for(Schema.PicklistEntry f : ProductActivity__c.Estimated_Weekly_Sales_Volume__c.getDescribe().getPicklistValues()) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }

  /*
        public List<SelectOption> getCuttingConducted()
        {
        List<SelectOption> options  = new List<SelectOption>{ new SelectOption('', '--') };
        for(Schema.PicklistEntry f : ProductActivity__c..getDescribe().getPicklistValues())
        {
        options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
        }
        */
  //Aditya End S-554835

    /*error functions*/
    public void DisplayQuickError(Exception e) { ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error, e.getLineNumber()+': '+e.getMessage())); }

    public void LogError(Exception e) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        ErrorHandlerGlobal.logError(e, ApexPages.currentPage().getURL());
    }

    /*update the meet now details*/
    public void UpdateMeetNowDetails(string s) {
        SalesCall.MeetingNowDetailedOperations__c += '\n\n || '+Datetime.now().format('MM-dd-yyyy h:mm:ss a z')+' : '+s;
        update SalesCall;
    }
     //Start | Added by Rahul | | S-703689 | 14/06/23 

   public String adjustAndFormatTime(Datetime dateTimes) {
        if (dateTimes==null){
            return null;
        }
        Integer minute = dateTimes.minute();
        Integer hour = dateTimes.hour();
        Integer[] adjustedTime = adjustTime(hour, minute);
        return formatTime(adjustedTime);
    } 
    
    public String formatTime(Integer[] adjustedTime) {
        DateTime dt = DateTime.newInstance(2008, 12, 1, adjustedTime[0], adjustedTime[1], 0);
        return dt.format('h:mm a');
    }
    public Integer roundToNearest30(Integer value) {
        return Math.round(value / 30.0) * 30;
    }
    
    public Integer[] adjustTime(Integer hour, Integer minute) {
        minute = roundToNearest30(minute);
        if (minute >= 60) {
            minute = 0;
            hour = Math.mod((hour + 1), 24);
        }
        return new Integer[]{hour, minute};
            }
    //End | Added by Rahul | | S-703689 | 14/06/23 
    
    //START-Added by Komal Story 705203| 5/10/2023 | to set the default time
    public void setDefaultTime() {
        Datetime dTim = Datetime.newInstance(2008, 12, 1, 8, 0, 0);
        startTime = dTim.format('h:mm a');
        endTime = dTim.addHours(1).format('h:mm a');
    }
    //END-Added by Komal Story 705203| 5/10/2023 | to set the default time
  // START Added - by Esoof | S-707881 | 02/05/2025
  public void updateSalesOpp() {
    System.debug('1129999999');
    System.debug('1129 EventId: ' + SalesCall);
    if (SalesCall != null) {
      Activity__c currentActivity = [
        SELECT Id, Operator__c, Status__c // NCarson S-707880 7/22/25 - add Status__c to query
        FROM Activity__c
        WHERE Id = :SalesCall.Id
      ];
      List<SalesOpportunity__c> SopList = [
        SELECT
          Id,
          Name,
          Operator__r.Name,
          Manufacturer__r.Name,
          ProductCategory__r.Name,
          Opportunity_Status_Code__c
        FROM SalesOpportunity__c
        WHERE
          Operator__c = :currentActivity.Operator__c
          AND Status__c = 'Active'
      ];

      System.debug('1139 SopList :' + SopList);
      List<ProductActivity__c> PactList = [
        SELECT
          Id,
          Name,
          Product__r.Name,
          Product__r.ProductCategory__r.Name,
          Product__r.Manufacturer__r.Name,
          Operator__r.Name,
          ExpandedProductStatus__c,
          ProductStatus__c
        FROM ProductActivity__c
        WHERE
          Activity__c = :currentActivity.Id
          AND Operator__c = :currentActivity.Operator__c
      ];
      System.debug('1145 PactList :' + PactList);
      List<SalesOpportunity__c> SopListToUpdate = new List<SalesOpportunity__c>();
      Map<String, SalesOpportunity__c> saMap = new Map<String, SalesOpportunity__c>();

      if (PactList.size() > 0 && SopList.size() > 0) {
        String ProductStatus = null;
        String ExpandedProductStatus = null;
        boolean sameFound = true;
        Set<String> OppIdSet = new Set<String>();

        for (SalesOpportunity__c sop : SopList) {
          sameFound = true;
          ProductStatus = null;
          ExpandedProductStatus = null;
          System.debug(
            '1166 SOP :' +
              sop.Name +
              '- sameFound' +
              sameFound +
              '- ProductStatus:' +
              ProductStatus +
              'ExpandedProductStatus :' +
              ExpandedProductStatus
          );
          
          // START NCarson S-708033 - track sold product found
          boolean salesOppHasSoldProduct = FALSE;
          boolean salesOppHasInProgressProduct = FALSE;
          // END NCarson S-708033
          
          for (ProductActivity__c pa : PactList) {
            System.debug('1166 A SOP :' + Pa.Name + '-' + pa.ProductStatus__c);
            if (
              pa.Product__r.Manufacturer__r.Name != null &&
              sop.Manufacturer__r.Name != null /* START C-00358178 &&
              comment out, to support null / blank Product Categories
              pa.Product__r.ProductCategory__r.Name != null &&
              sop.ProductCategory__r.Name != null
              END C-00358178 7/25/25 */
            ) {
              if (
                pa.Product__r.Manufacturer__r.Name ==
                sop.Manufacturer__r.Name &&
                pa.Product__r.ProductCategory__r.Name ==
                sop.ProductCategory__r.Name
              ) {
                if (ProductStatus == null) {
                  ProductStatus = pa.ProductStatus__c;
                }
                
                // START NCarson S-708033 6/17/25 - mark when in progress or sold product found
                if (pa.ExpandedProductStatus__c == 'Not Sold In-Progress') {
                  salesOppHasInProgressProduct = TRUE;
                }
                
                if (pa.ProductStatus__c == 'Sold') {
                  salesOppHasSoldProduct = TRUE;
                } // END NCarson S-708033 6/17/25
                              
                if (ProductStatus == 'Sold') {
                  if (ProductStatus != pa.ProductStatus__c) {
                    sameFound = false;
                    break;
                  }
                }
                if (ProductStatus == 'Not Sold') {
                  if (ExpandedProductStatus == null) {
                    ExpandedProductStatus = pa.ExpandedProductStatus__c;
                  }
                  if (
                    ProductStatus != pa.ProductStatus__c ||
                    ExpandedProductStatus != pa.ExpandedProductStatus__c
                  ) {
                    sameFound = false;
                    break;
                  }
                }
              }
            }
          }

          // START NCarson S-707880 - set status code to closed won if salesOppHasSoldProduct is true and activity is closed
          // START C-00358178 7/25/25 - remove condition of Closed / Completed for currentActivity
          // if ( (currentActivity?.Status__c == 'Closed' || currentActivity?.Status__c == 'Completed') &&
          // END C-00358178
          if ( ((sameFound && ProductStatus == 'Sold') || (salesOppHasSoldProduct && !salesOppHasInProgressProduct))) {
            // cannot set to 'Closed Won' - SalesOpp needs to remain
            // 'Active' until Meeting (Activity) is closed
            sop.Opportunity_Status_Code__c = '5 - Closed Won';
            SopListToUpdate.add(sop);
            // END NCarson S-707880 7/22/25
          }
          if (sameFound && ProductStatus == 'Not Sold') {
            if (ExpandedProductStatus == 'Not Sold Final') {
              sop.Opportunity_Status_Code__c = '6 - Closed Not Sold';
            } else {
              sop.Opportunity_Status_Code__c = (sop.Opportunity_Status_Code__c ==
                '1 - Prospect / Target' ||
                sop.Opportunity_Status_Code__c == '2 - Qualification')
                ? '3 - Proposal / Test'
                : sop.Opportunity_Status_Code__c;
            }
            SopListToUpdate.add(sop);
          }
        }
        if (SopListToUpdate.size() > 0) {
          update SopListToUpdate;
          System.debug('1232 after update');
        }
      }
    }
  }
  //END Added - by Esoof | S-707881 | 02/05/2025
     /*start up action run on page load*/
    public void StartUpAction() {

        //START -  Added by ASL     June 15th, 2022     S-695488    Initializing the variables showLogOppButton, clientSKUList, and clientSKUListSize.
        showLogOppButton = false;
        clientSKUList = new List<ClientSKU>();
        //Added by ASL  July 15th, 2022     S-696198    New temporal variable used to avoid repeated values on the List.
        Map<Id, ClientSKU> clientSKUMapTemp = new Map<Id,ClientSKU>();
        clientSKUListSize = 0;
        //END -  Added by ASL   June 15th, 2022     S-695488    Initializing variables.
        // Start : Mohit for S-334739 //
        //List<Employee__c> employeeInfo = new List<Employee__c>();
        Employee__c employeeInfo ;
        try {
           //Start- Add by Mayank| S-707888 | 25 April 2025  || add Can_Enter_a_Sales_Assist__c in query
            for(Employee__c emp : [SELECT Id, DefaultOnBehalfOfDistributor__c,Can_Enter_a_Sales_Assist__c,DefaultOnBehalfOfDistributor__r.Name,DefaultOnBehalfOfDistributor__r.Market__c FROM Employee__c WHERE User__c = :UserInfo.getUserId() LIMIT 1]){
            //end- Add by Mayank| S-707888 | 25 April 2025  || add Can_Enter_a_Sales_Assist__c in query
                employeeInfo = emp;
                //Start- Add by Mayank| S-707888 | 25 April 2025  || get current loggedin employee detail
                       showSalesCallAssistPicklist=emp.Can_Enter_a_Sales_Assist__c;
                       //end- Add by Mayank| S-707888 | 25 April 2025  || get current loggedin employee detail

            }
        }catch(Exception ex) {}
        // End : Mohit for S-334739 //

        //START NBOCK Case 00103696 12.9.14
        String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        String safari = 'Safari';
        isSafari =
            userAgent.contains(safari);
        //system.assert(false, 'User-Agent details' + userAgent + ' #UserAgent :  ' + userAgent.contains(safari));
        //Added by Nishank for Case :- 00106567
        if(userAgent.contains('Chrome')) {
            isSafari =false;
        }
        //End of changes added by Nishank for Case :- 00106567
        //END NBOCK Case 00103696 12.9.14
        try {
            //set security token
            securityToken = encodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(Util.getSessionId())));

      BaseURL = URL.getSalesforceBaseUrl().toExternalForm();

            if(ApexPages.currentPage().getParameters().get('Id') == null) {
                if(ApexPages.currentPage().getParameters().get('OperatorId') != null) {
                    OperatorId = ApexPages.currentPage().getParameters().get('OperatorId');
                }
                if(ApexPages.currentPage().getParameters().get('EventId') != null) {
                    EventId = ApexPages.currentPage().getParameters().get('EventId');
                }
                SalesCall = new Activity__c();
                SalesCall.Operator__c = OperatorId;
                SalesCall.Status__c = 'Pending';
                
                // START NCarson S-708258 2/3/26 - set Distributor based on incoming Operator
                if (String.isNotBlank(OperatorId)) {
                  List<Account> operatorAccountList = [SELECT Id, Primary_Distributor__c FROM Account WHERE Id = :operatorId LIMIT 1];
                  if (operatorAccountList.size() > 0) {
                    SalesCall.Distributor__c = operatorAccountList[0].Primary_Distributor__c;
                  }
                } // END NCarson S-708258 2/3/26

                SalesCall.StartDate__c = Datetime.now();
                SalesCall.EndDate__c = Datetime.now();
                SalesCall.TypePL__c = 'Event';
                SalesCall.SubType__c = 'Sales Call';
                //Start | Added by Yash | C-00356965 | 30-01-2025
                Employee__c emp = [select id, UserID__c from Employee__c where User__c=:UserInfo.getUserId() LIMIT 1];
                SalesCall.Employee__c = emp.id; 
                //End | Added by Yash | C-00356965 | 30-01-2025
                //START | Changes Added by Gulab | S-703023 | 17-04-2023
               // SalesCall.Meeting_Date__c = SalesCall.StartDate__c.Date(); commented by mahesh | c-00346440 | 03-05-2023
                //END | Changes Added by Gulab | S-703023 | 17-04-2023
                insert SalesCall;

                SalesCallId = SalesCall.Id;

                initialObjectMap.put('SalesCallCreatedOnPageLoad', true);
            }
            else {
                SalesCallId = ApexPages.currentPage().getParameters().get('Id');
                System.debug('Lalit=======in else'+SalesCallId);

                initialObjectMap.put('SalesCallCreatedOnPageLoad', false);
            }

      /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - Start ***/
      //Initialize variables with default value
      Datetime dT = Datetime.newInstance(2008, 12, 1, 8, 0, 0);
      startTime = dT.format('h:mm a');
      endTime = dT.addHours(1).format('h:mm a');
      /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - End ***/

      //Added by Lalit for S-334717 START
      distributorNameIdMap = new Map<String, String>();
      committedOrders = new List<CommittedOrder__c>();
      cowrapper = new List<DistrubutorClass>();
      for (CommittedOrder__c cOrder : [
        SELECT
          id,
          Quantity_Entered__c,
          MeasurementUnits__c,
          Distributor__r.name,
          Distributor__c
        FROM CommittedOrder__c
        WHERE SalesCall__c = :SalesCallId
      ]) {
        cowrapper.add(
          new DistrubutorClass(cOrder, cOrder.Distributor__r.name, false)
        );
        distributorNameIdMap.put(cOrder.id, cOrder.Distributor__r.name);
        //committedOrders.add(cOrder);
        System.debug('Lalit-----' + cOrder.Distributor__r.name);
      }
      addCommitedOrder();
      //Added by Lalit for S-334717 END
      // Added Meeting_Type__c,Employee__c and Market__c in below query - Jai Gupta - S-339869 - Aug 13,2015
      // Start | Updated | Added EndDate__c by Rahul T | S-703689 | 14/06/23
      //START: field (StartDateNor__c) added by Gulab | S-706858 | 21/05/2024 |Unplanned Meet Now - dropping start date
      // Start case 00357344 || 3/17/25 - add inner query for child Product Activity records || Swastika + NCarson
      List<Activity__c> SalesCallList = [
        SELECT
          Id,
          EndDate__c,
          StartDateToDate__c,
          Meeting_type__c,
          Employee__c,
          Market__c,
          Description__c,
          StartDate__c,
          Status__c,
          Planned_Unplanned__c, // case 00358115 || Swastika || Add this field for setting default time
          MeetingStartedTime__c,
          Contact__c,
          Contact__r.Name,
          Contact__r.Id,
          Distributor__c,
          Distributor__r.Id,
                                               /* START Vinit S-601948 3.10.2019 on behalf changes */
                                               Distributor_2__r.Name,
                                               //Start- Add by Mayank| S-707888 | 25 April 2025  || fetch a new field Assisted_Employee__c in query
                                               Assisted_Employee__c,
                                                //end- Add by Mayank| S-707888 | 25 April 2025  || fetch a new field Assisted_Employee__c in query
                                               Distributor_2__r.Id,
                                               Contacts__c, // NCarson 3/2/25 S-707646 - add Contacts to query
                                               Distributor_2__r.Market__c,
                                               Distributor_2_NA__c,
                                               // END Vinit S-601948 3.10.2019
                                               Distributor__r.Name,
                                               //START - Added by ASL   Oct 10th, 2022  698051 - Adding the Operator__r.OperatorSubSegment__c AND Operator__r.Cool_School_ID__c fields to the query.
                                               Operator__r.OperatorSubSegment__c,Operator__r.Cool_School_ID_del__c,
                                               //END - Added by ASL     Oct 10th, 2022  698051 - Adding the Operator__r.OperatorSubSegment__c AND Operator__r.Cool_School_ID__c fields to the query.
                                               Operator__r.KI_ID__c,// Added by Gulab | [S-684595] | [03-06-2021]
                                               Operator__c, Operator__r.Name, Operator__r.Id, Operator__r.LargeLeverageOperator__c, Operator__r.Market__r.Id,Operator__r.Type, /*Added for S-554835 */
                                               MeetingNowDetailedOperations__c, DistributorNA__c/*, OperatorFeedbackReasons__c, OperatorFeedback__c*/
                                               , Operator__r.Market__c //Code modified - Padmesh Soni (02/18/2017 Appirio Offshore) - S-467938

                                               // Code changes done by Ravi Jain for story S-537453
                                               // Start - Ravi Jain - S-537453 - 12th Jan, 2017 - Added the field in the query
                                               ,Activity_Number__c,Unplanned__c ,RSC_Category__c,RSC_SubCategory__c,Requested__c //Modified by Vinit for S-645707 [21-Nov-2019]
                                               // End - Ravi Jain - S-537453 - 12th Jan, 2017
                                               ,App_Notes__c // Added By Vinit for S-641508 [11-Sep-2019] 
                                               //,Meeting_Date__c //Added by Gulab | S-703023 | 17-04-2023   (commented by mahesh | c-00346440 | 03-05-2023)
                                               ,StartDateNor__c
                                               ,(SELECT Id, Estimated_Weekly_Sales_Volume__c, tf_ProductCategory__c, tf_ProductClientName__c, ProductStatus__c, Was_an_Oil_Evaluation_Conducted__c,
                                                 ExpandedProductStatus__c // NCarson S-707880 7/22/25 - add ExpandedProductStatus to query 
                                                 FROM Product_Activities__r)
                                               FROM Activity__c WHERE Id = :SalesCallId];
            // END case 00357344 || 3/17/25 - add inner query for child Product Activity records || Swastika + NCarson
             //END: field (StartDateNor__c) added by Gulab | S-706858 | 21/05/2024 |Unplanned Meet Now - dropping start date                                  
             // End | Updated | Added EndDate__c,Unplanned__c by Rahul T | S-703689 | 14/06/23 
            //confirm there is a sales call
            if(SalesCallList.size() > 0) {
                
                SalesCall = SalesCallList[0];
                
            // Start | Added BY Rahul T | S-703689 | 14/06/23 
            
                if (!salesCall.Unplanned__c) {
                    
                    if(SalesCall.StartDateToDate__c != null){
                        
                        SalesCall.StartDateNor__c = SalesCall.StartDateToDate__c;
                    }
                    startTime = adjustAndFormatTime(SalesCall.StartDate__c);
                    endTime = adjustAndFormatTime(SalesCall.EndDate__c);
                }
                //START-Commented by Komal Story 705203| 5/10/2023 | to set the default time
                else { // unplanned == TRUE condition
                    //endTime = null;
                    //startTime = null;
                    //START: Commented by Gulab | S-706858 | 21/05/2024 |Unplanned Meet Now - dropping start date
                    //SalesCall.StartDate__c=null; 
                    //END: Commented by Gulab | S-706858 | 21/05/2024 |Unplanned Meet Now - dropping start date   
                     
                } 
                //END-Commented by Komal Story 705203| 5/10/2023 | to set the default time
                //End | Added by Rahul | | S-703689 | 14/06/23 
              
                initialObjectMap.put('SalesCall', SalesCall.clone(true, true, true, true));
                //ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Contact Id: '+SalesCall.Contact__c));
            }
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Specified Sales Call does not exist'));
                return;
            }

      /* START Vinit S-601948 3.10.2019 on behalf changes */
      if (SalesCall != null) {
        CDistributorId = SalesCall.Distributor_2__r.Id;
      }
      // END Vinit S-601948 3.10.2019

            /* START Vinit S-601948 3.29.2019
            * on behalf changes */
            List<OperatorSegment__c> operatorSegments = [SELECT Affiliation__r.SubSegment__r.Segment__r.Id, Affiliation__r.SubSegment__r.Segment__r.Name, Affiliation__r.SubSegment__r.Name FROM OperatorSegment__c
                                                         WHERE Account__c = :OperatorId
                                                         AND Affiliation__c != null
                                                         AND Account__c != null];

            if (operatorSegments != null) {
                for(OperatorSegment__c  operatorSegment : operatorSegments) {
                    if (operatorSegment.Affiliation__r.SubSegment__r.Segment__r.Name != null && operatorSegment.Affiliation__r.SubSegment__r.Segment__r.Name != '') {
                        FirstSegmentName = operatorSegment.Affiliation__r.SubSegment__r.Segment__r.Name;
                        break;
                    }
                }
            }

      /* End Vinit S-601948 3.29.2019 on behalf changes */
            
            //Start | 00358544 | Prakhar | Change OperatorId -> This.OperatorId | 10/6/25
             if(string.isNotBlank(SalesCall.Operator__r.Id)) {
            //End | 00358544 | Prakhar | Change OperatorId -> This.OperatorId | 10/6/25
              OperatorId = SalesCall.Operator__r.Id;
            //Start | 00358544 | Prakhar | Change OperatorId -> This.OperatorId | 10/6/25
            }
            //End | 00358544 | Prakhar | Change OperatorId -> This.OperatorId | 10/6/25
            
            //START -- Added by Gulab | [S-684595] | [03-06-2021]
            KIId = SalesCall.Operator__r.KI_ID__c;
            ViewTransactionalDataButton = false;
            List<Non_Comm_Transaction_Summary_SF__c> TSFList = [Select Id from Non_Comm_Transaction_Summary_SF__c where KI_ID__c=:KIId limit 1];
            if(TSFList.size() > 0){
                ViewTransactionalDataButton = true;
            }
            //END -- Added by Gulab | [S-684595] | [03-06-2021]
            
            //Modified by Aditya Tiwari for S-554835 Start
            OperatorType = SalesCall.Operator__r.Type;
            //Modified by Aditya Tiwari for S-554835 End

            /** Code modified - Padmesh Soni (02/18/2017 Appirio Offshore) - S-467938 - Start **/
            if(SalesCall.Operator__c != null && SalesCall.Operator__r.Market__c != null) {
                MarketId = SalesCall.Operator__r.Market__r.Id;
            }
            /** Code modified - Padmesh Soni (02/18/2017 Appirio Offshore) - S-467938 - End **/

      // Start : Added by Mohit for Story S- 334739 //
           // Mahesh + NCarson c_00357369  3/17/25 - only use default if Sales call does not have a distributor
            if( (SalesCall.Distributor__r.Id == null) && 
            (employeeInfo != null && employeeInfo.DefaultOnBehalfOfDistributor__c != null && employeeInfo.DefaultOnBehalfOfDistributor__r.Market__c != null) && (employeeInfo.DefaultOnBehalfOfDistributor__r.Market__c == SalesCall.Operator__r.Market__c) ){

                DistributorId = employeeInfo.DefaultOnBehalfOfDistributor__c;
                DistributorName = employeeInfo.DefaultOnBehalfOfDistributor__r.Name;  //Added Utkarsh | C-00357859 | 04-06-2025
                // START || Updated by Prashant || 25/09/2024 || 00355723 || Updated for Auto-Populate OnBehalfOfDistributor__c based on current Employee
                SalesCall.Distributor__c = DistributorId; //Added by Prashant || 00355723
            // END || Updated by Prashant || 24/09/2024 || 00355723 || Updated for Auto-Populate OnBehalfOfDistributor__c based on current Employee
            }
            else{
                DistributorId = SalesCall.Distributor__r.Id;
                DistributorName = SalesCall.Distributor__r.Name; //Added Utkarsh | C-00357859 | 04-06-2025
            }
            PricingDistributorId = DistributorId ; // Jai Gupta Operator Feedback
            //DistributorId = SalesCall.Distributor__r.Id; // Comment by Mohit for Story S-334739
            // End : Added by Mohit for Story S-334739 //

            //The Timestamp of when the Meeting was Started
            if(SalesCall.MeetingStartedTime__c == null)
                SalesCall.MeetingStartedTime__c = Datetime.now();
             // Start | Updated by Rahul T | S-703689 | 14/06/23 | Added unplanned condition 
            //If the time doesn't exist, set it to now
            if(SalesCall.StartDate__c == null && !SalesCall.Unplanned__c){
                SalesCall.StartDate__c = Datetime.now();
            }
            //START-commented/added by komal for Story S-705203 |5/10/2023 | to det the default end and start time
            if(SalesCall.status__c=='Pending'){
                //endTime = null;
               //startTime = null;
                setDefaultTime();
               SalesCall.StartDateNor__c=null;  
            }
             if(SalesCall.status__c=='Planned' && SalesCall.StartDate__c == null)
               {
        setDefaultTime();
      }
      //END-commented/added by komal for Story S-705203 |5/10/2023 | to det the default end and start time
      // End | Updated by Rahul T | S-703689 | 14/06/23
      // Start || case 00358115 || Swastika || set default time 
      // Start || Case 00358233 || Swastika || changing to default date
      if (SalesCall.status__c != 'Planned' && SalesCall.Planned_Unplanned__c == 'Unplanned' && SalesCall.StartDate__c != null) {
        setDefaultTime();
        SalesCall.StartDateNor__c = Date.today();  
      }
      // End || case 00358115 || Swastika || set default time
      
      if (SalesCall.status__c == 'Planned' && SalesCall.StartDate__c != null) {
      SalesCall.StartDateNor__c = SalesCall.StartDateToDate__c;
      }
     //End || Case 00358233 || Swastika || changing to default date
      // S-339867 - Hemlata - Added If
      if (SalesCall.Status__c == 'Completed') {
        isCompleted = true;
      }
      // Added "Create_Follow_Up__c,Not_Sold_Result_is_Final__c,Sale_is_In_Progress__c,Sale_Progress_Follow_up_Call__c"
      // by Jai Gupta - Aug 17,2015 - S-339868
      // Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - Activity_End_Date__c field added in query
      //Modified by Aditya Tiwari for S-554835; Added fields in below Query
      //START -- UnCommented What_are_next_steps__c field  by Shreya | C-00283734 | 24/12/2020 |uncomm. after changing field type to Text Area [long]. Added by ASL June 23rd, 2022 S-695488 Retrieving Operator__c on SOQL query.
      System.debug('salescall' + SalesCall.Id); //NAndini today
      List<ProductActivity__c> ProductActivityList = [
        SELECT
          Id,
          Add_to_Pipeline__c, // NCarson 9/24/25 S-708158 - add to pipeline
          Operator__c,
          Product__r.Id,
          Product__r.Name,
          Product__r.Manufacturer__r.Id,
          PotentialSalesVolume__c,
          Activity_Start_Date__c,
          Activity_End_Date__c, // Added by Nishank for Story S-409424
          Product__r.Manufacturer__r.Name,
          Product__r.ManufacturingNumber__c,
          What_are_next_steps__c,
          Product__r.ClientName__c,
          Manufacturer18_ID__c, //Added by ASL June 23rd, 2022 S-695488 Retrieving Manufacturer18_ID__c field
          Product__r.SKU__c,
          ProductStatus__c,
          OperatorFeedback__c,
          CasesWeekUsage__c,
          sample_case_Option__c,
          Where_do_we_need_to_get_pricing__c,
          Is_operator_under_contract__c,
          Who_needs_to_review_product_at_Operator__c,
          Quality_Issue__c,
          Distributor_final_New_Item_feedback__c,
          distributor_final_CCC_Feedback__c,
          Operator_Unwilling_Feedback__c,
          What_is_the_allowance_per_case_needed__c,
          Not_Sold_Price__c,
          Estimated_Weekly_Sales_Volume__c,
          OperatorFeedbackReasons__c,
          Not_Sold_Result_is_Final__c,
          Sales_in_Progress__c,
          Sale_is_In_Progress__c,
          Reasons_unsold__c,
          Competitive_Client__c,
          Who_was_the_Distributor__c,
          Who_was_the_Distributor__r.Name,
          Photo_taken__c,
          Specific_Issue__c,
          Will_Client_pay_slotting_fee__c,
          Marketing_program_exist__c,
          Distributor_Not_Sold_Product_Status__c,
          Competitive_Client__r.Name,
          Distributor_SIP_CCC_Feedback__c,
          Distributor_SIP_New_Item_Feedback__c,
          When_do_you_expect_testing_to_conclude__c,
          Operator_Contract_Expiry_Date__c,
          Sale_Progress_Follow_up_Call__c,
          Reasons_unwilling_to_consider__c,
          Distributor_Not_sold_Reasons_final__c,
          Distributor_New_Item_Reasons_Final__c,
          Distributor_Not_sold_Reasons__c,
          Was_an_Oil_Evaluation_Conducted__c,
          Distributer_SIP_New_Item__c,
          Was_a_cutting_conducted__c,
          Create_Follow_Up__c,
          /*WeeklyVolume__c,*/ CommittedOrder__c,
          CommittedOrder__r.Id,
          Using_Purchase_Frequency__c,
          Using_Distributor__c,
          Using_Distributor__r.Name,
          Quantity_Entered__c,
          Supported_Reason__c,
          Verbal__c,
          ExpandedProductStatus__c, // NCarson S-707880 - add expanded product status to query
          Supported__c, // TNOE re-applied changes by vinit for S-569853 // Modified by Vinit for S-581469 // Modified By Vinit for S-613633//added By Komal for Story S-707692 | 16/12/2024
          Product__r.Include_in_Client_Assist__c, // Tushar Soni | 14/11/2022 | S-698550 | Added new field -->
          (SELECT Id FROM Committed_Orders__r) // TNOE - Added Using Purchase Frequency and Using Distributor
        FROM ProductActivity__c
        WHERE Activity__c = :SalesCall.Id
        ORDER BY Product__r.Manufacturer__r.Name ASC , Product__r.ProductCategory__r.Name ASC // NCarson S-708033 6/10/25 - ORDER BY clause
      ];

            //END -- UnCommented What_are_next_steps__c field  by Shreya | C-00283734 | 24/12/2020 |uncomm. after changing field type to Text Area [long]
            AssignedProductList = new List<AssignedProduct>();
            Set<String> ProductIdSet = new Set<String>();
            Set<String> CommittedOrderIdSet = new Set<String>();
            Set<String> PAManufacturerIdSet = new Set<String>();
            list<ProductActivity__c> originalProductActivities = new list<ProductActivity__c>();
            set<Id> originalProductActivityIds = new set<Id>();
            for(ProductActivity__c pa : ProductActivityList)
            {
                ProductIdSet.add(pa.Product__r.Id);
                CommittedOrderIdSet.add(pa.CommittedOrder__r.Id);
                PAManufacturerIdSet.add(pa.Product__r.Manufacturer__r.Id);
                originalProductActivities.add(pa.clone(true, true, true, true));
                originalProductActivityIds.add(pa.Id);
                ProductsMap.put(pa.Product__r.Id, false); // Added by Vinit for S-644696/S-645821 [14-Nov-2019]
                //Added by ASL  June 15th, 2022     S-695488    Creating the new ClientSKU obj for Clients list. Modified by ASL July 15th, 2022    S-696198    
                if(!clientSKUMapTemp.containsKey(pa.Manufacturer18_ID__c)) {
                    clientSKUMapTemp.put(pa.Manufacturer18_ID__c, new ClientSKU(pa.Manufacturer18_ID__c, pa.Product__r.ClientName__c, pa.Product__r.SKU__c,pa.Operator__c));
                }
            }
            //START -  Added by ASL     June 15th, 2022     S-695488
            //Added by ASL  July 15th, 2022     S-696198    
            clientSKUList.addAll(clientSKUMapTemp.values());
            clientSKUListSize = clientSKUList.size();
            //Verify if there are Product Activities related. Modified by ASL July 15th, 2022   S-696198
            if (clientSKUListSize > 0)
                showLogOppButton = true;
            //END - Added by ASL    June 15th, 2022     S-695488
            // Added by Vinit for S-644696/S-645821 [14-Nov-2019] start
            for (ProductActivity__c prodAct : [SELECT id, Product__r.Id FROM 
                                               ProductActivity__c 
                                               WHERE product__c IN: ProductIdSet 
                                               AND Operator__c =: OperatorId
                                               AND Activity__r.status__c = 'Completed']) {

                 if (ProductsMap.containsKey(prodAct.Product__r.Id)) {
                     ProductsMap.put(prodAct.Product__r.Id, true);
                 } else {
                     ProductsMap.put(prodAct.Product__r.Id, false);
                 }                                 

            }
            // Added by Vinit for S-644696/S-645821 [14-Nov-2019] end
            initialObjectMap.put('originalProductActivityIds', originalProductActivityIds);
            initialObjectMap.put('originalProductActivities', originalProductActivities);

            List<String> ProductIdList = new List<String>(ProductIdSet);
            ProductIds = String.join(ProductIdList, ',');

      List<String> ManufacturerIdList = new List<String>(PAManufacturerIdSet);
      ManufacturerIds = String.join(ManufacturerIdList, ',');

      map<String, CommittedOrder__c> COMap = new Map<String, CommittedOrder__c>();
      map<String, Product__c> ProdMap = new Map<String, Product__c>();
      map<String, map<String, Boolean>> OppMap = new Map<String, map<String, Boolean>>();

            set<Id> originalCommittedOrderIds = new set<Id>();
            list<CommittedOrder__c> committedOrderList = new list<CommittedOrder__c>();
            for(CommittedOrder__c co : [SELECT Id, Product__c, Product__r.Manufacturer__r.Name, Product__r.Manufacturer__r.Id, Product__r.Name,
                                        Quantity_Entered__c, MeasurementUnits__c, Status__c, ExpectedOrder__c,
                                        Distributor__c, Distributor__r.Name, Distributor__r.Id, Contact__c, Contact__r.Id,
                                        Feedback__c, FeedbackType__c, CompetitorInformation__c, Color__c,Expected_Order_End_Date__c,Annual_Case_Volume__c, //S-343194 - Hemlata //case 00357110 | Swastika | change field type
                                        Product__r.DOT_Number__c, Product__r.DOT_In_Stock__c, Product__r.DOT_Availability__c //S-307652
                                        //Added by Shubham for Story S-426804
                                        , Sale_Type__c, Based_on_Bid__c
                                        //START- Added by Sajal for S-569846
                                        , Effective_End_Date_Selection__c
                                        //END for S-569846
                                        ,Client_Assist_Type__c,Did_Client_Assist_with_Sale__c // Tushar Soni | 14/11/2022 | S-698550 | Query new fields
                                        FROM CommittedOrder__c WHERE SalesCall__c = :SalesCall.Id OR Id IN :CommittedOrderIdSet])
            {
                COMap.put(co.Id, co);
                originalCommittedOrderIds.add(co.Id);
                committedOrderList.add(co.clone(true, true, true, true));
            }
            initialObjectMap.put('originalCommittedOrderIds', originalCommittedOrderIds);
            initialObjectMap.put('committedOrderList', committedOrderList);

            for(Product__c p : [SELECT Manufacturer__r.Name, Name, ManufacturingNumber__c, GlobalClassification__c, ProductFamily__r.Name,
                                ProductCategory__r.Name, ProductDescription__c, SKU__c, GTIN__c, Packed__c, ProductInfoURL__c, //S-264415 add ProductInfoURL in query
                                DOT_Number__c, DOT_In_Stock__c, DOT_Availability__c,CategoryName__c//Added by Komal for story S-707692 |CategoryName__c| //S-307652
                                FROM Product__c WHERE Id IN :ProductIdSet])
            {
                ProdMap.put(p.Id,p);
            }

      //Build any Product Activities
      map<Id, map<Id, SalesOpportunity__c>> originalSOMap = new Map<Id, map<Id, SalesOpportunity__c>>();
      //START - Added by ASL  July 15th, 2022     S-696198    Declaration of cliSKUToRemoveMap variable.
      Map<String, ClientSKU> cliSKUToRemoveMap = new Map<String, ClientSKU>();
      for (ClientSKU cliSKU : clientSKUList) {
        cliSKUToRemoveMap.put(cliSKU.Manufacturer, cliSKU);
      } //END - Added by ASL   July 15th, 2022     S-696198    Declaration of cliSKUToRemoveMap variable.
      //Modified by ASL   July 14th, 2022     S-696198    Added Operator__c field for retrieving in SOQL query.
      // NCarson 8/8/24 - C_00354635 - add filter for status of Active
      // NCarson S-708033 6/16/25 - add ProductCategory__r.Name to query
      for (SalesOpportunity__c so : [
        SELECT
          Id,
          ProductCategory__r.Name,
          Operator__c,
          Manufacturer__c,
          Manufacturer__r.Id,
          Status__c,
          CommittedOrder__c
        FROM SalesOpportunity__c
        WHERE
          Status__c = 'Active'
          AND Manufacturer__c IN :PAManufacturerIdSet
          AND Operator__c = :SalesCall.Operator__r.Id
      ]) {
        if (!OppMap.containsKey(so.Manufacturer__r.Id))
          OppMap.put(so.Manufacturer__r.Id, new Map<String, Boolean>());

                OppMap.get(so.Manufacturer__r.Id).put(so.Id, (so.Status__c == 'Achieved' ? true : false));

                if(!originalSOMap.containsKey(so.Manufacturer__r.Id))
                    originalSOMap.put(so.Manufacturer__r.Id, new map<Id, SalesOpportunity__c>());

                originalSOMap.get(so.Manufacturer__r.Id).put(so.Id, so.clone(true, true, true, true));
                //START - Added by ASL  July 15th, 2022     S-696198    If the combination of Manufacturer and Operator already exists, the client it won't be shown at Logging a new Sales Oppty.
                if(cliSKUToRemoveMap != null && cliSKUToRemoveMap.get(so.Manufacturer__c) != null && 
                   cliSKUToRemoveMap.get(so.Manufacturer__c).Manufacturer == so.Manufacturer__c && 
                   so.Operator__c == cliSKUToRemoveMap.get(so.Manufacturer__c).OperatorId) {
                    cliSKUToRemoveMap.remove(so.Manufacturer__c);
                       // Remove the Manufacturer Id from ManufacturerIds
                       ManufacturerIds = ManufacturerIds.replace(so.Manufacturer__c,'');
                }//END - Added by ASL   July 15th, 2022     S-696198
            }
            //START - Added by ASL  July 14th, 2022     S-696198 
            if(cliSKUToRemoveMap != null && !cliSKUToRemoveMap.isEmpty()) {
                clientSKUList.clear();
                clientSKUList.addAll(cliSKUToRemoveMap.values());
                clientSKUListSize = clientSKUList.size();
                //Verify if there is any Client on the list.
                if (clientSKUListSize > 0)
                    showLogOppButton = true;
            } if(cliSKUToRemoveMap != null && cliSKUToRemoveMap.isEmpty()) {
                clientSKUList.clear();
                clientSKUListSize = 0;
                showLogOppButton = false;
            }
            // Remove the double commas if has some. And remove commas from the beginning and from end of the String.
            if(ManufacturerIds != null && ManufacturerIds != '' ) {
                ManufacturerIds = ManufacturerIds.replaceAll(',+',',');
                    ManufacturerIds = ManufacturerIds.removeStart(',');
                    ManufacturerIds = ManufacturerIds.removeEnd(',');
            }//END - Added by ASL   July 14th, 2022     S-696198 

            //Build any Product Activities
            set<Id> originalSalesOppIds = new set<Id>();
            set<SalesOpportunity__c> salesOpportunityList = new set<SalesOpportunity__c>();
            for(ProductActivity__c pa : ProductActivityList)
            {
                if(originalSOMap.containsKey(pa.Product__r.Manufacturer__r.Id))
                {
                    map<Id, SalesOpportunity__c> soMap = originalSOMap.get(pa.Product__r.Manufacturer__r.Id);
                    salesOpportunityList.addAll(soMap.values());
                    originalSalesOppIds.addAll(soMap.keySet());
                }

                AssignedProductList.add(
                    new AssignedProduct(
                        pa,
                        //(COMap.containsKey(pa.CommittedOrder__r.Id) ? COMap.get(pa.CommittedOrder__r.Id) : new CommittedOrder__c(Status__c = 'Active',Operator__c = SalesCall.Operator__c,Product__c = pa.Product__r.Id,Distributor__c = SalesCall.Distributor__c,SalesCall__c = SalesCall.Id)),
                        (pa.Committed_Orders__r.size() > 0 && COMap.containsKey(pa.Committed_Orders__r[0].Id) ? COMap.get(pa.Committed_Orders__r[0].Id) : new CommittedOrder__c(Status__c = 'Active',Operator__c = SalesCall.Operator__c,Product__c = pa.Product__r.Id,Distributor__c = SalesCall.Distributor__c,SalesCall__c = SalesCall.Id)),
                        (ProdMap.containsKey(pa.Product__r.Id) ? ProdMap.get(pa.Product__r.Id) : new Product__c(Name = 'Error Product Container')),
                        (OppMap.containsKey(pa.Product__r.Manufacturer__r.Id) ? OppMap.get(pa.Product__r.Manufacturer__r.Id) : new map<String,Boolean>()
                        )
                    ));
            }
            /** comment start by Jai Gupta - S-705507 -  Oct 09, 2023  - Remove Suggested Product section */
            //START -- Added by Shivani for S-612902 on 03/05/2019
            // if(AssignedProductList != null && AssignedProductList.size() >0) {
            //    displaySuggestedProducts(AssignedProductList[AssignedProductList.size() -1].Product.Id);
            // }
            //END -- Added by Shivani for S-612902 on 03/05/2019
            /** comment End by Jai Gupta - S-705507 -  Oct 09, 2023  - Remove Suggested Product section */

      initialObjectMap.put('originalSalesOppIds', originalSalesOppIds);
      initialObjectMap.put('salesOpportunityList', salesOpportunityList);
      //START: Changes added by Gulab | S-696715 | 17-08-2022 | adding Product_Sales_Opportunities__r query
      //OpportunityList = [SELECT Name, Type__c, Operator__r.Name, Operator__c, Manufacturer__r.Name,
      //                   CompetitorDistributor__c, CompetitorDistributorSKU__c, CompetitorManufacturer__c, CompetitorProduct__c, CompetitorProductSKU__c,
      //                   Description__c, EstCurrentWeeklyVolume__c, Status__c, StartDate__c, EndDate__c, CreatedDate,
      //                   FROM SalesOpportunity__c WHERE Operator__c = :OperatorId AND Updated__c = true];
      // NCarson S-708033 6/16/25 - add ProductCategory__r.Name to query
      OpportunityList = [
        SELECT
          Id,
          ProductCategory__r.Name,
          Name,
          Type__c,
          Operator__r.Name,
          Operator__c,
          Manufacturer__r.Name,
          CompetitorDistributor__c,
          CompetitorDistributorSKU__c,
          CompetitorManufacturer__c,
          CompetitorProduct__c,
          CompetitorProductSKU__c,
          Description__c,
          EstCurrentWeeklyVolume__c,
          Status__c,
          //Start- Added by mayank For story -S-708088| 25|07/2025 || Add a new field 
           Opportunity_Status_Code__c,
      //End- Added by mayank For story -S-708088| 25|07/2025 || Add a new field 

          StartDate__c,
          EndDate__c,
          CreatedDate,
          (SELECT Id FROM Product_Sales_Opportunities__r)
        FROM SalesOpportunity__c
        WHERE Operator__c = :OperatorId AND Updated__c = TRUE
      ];
        System.debug('OperatorId>>>'+OperatorId);
        System.debug('OpportunityList>>>'+OpportunityList);
      //END: Changes added by Gulab | S-696715 | 17-08-2022 | adding Product_Sales_Opportunities__r query
      /*Business Objectives*/

            //Preload BOs
            List<Id> BoList = new List<Id>();
            for(BusinessPlanActivity__c bpa : [SELECT BusinessObjectivePlan__r.BusinessObjectiveMarket__r.Id FROM BusinessPlanActivity__c WHERE Operator__r.Id = :OperatorId])
            {
                BoList.add(bpa.BusinessObjectivePlan__r.BusinessObjectiveMarket__r.Id);
            }

            //Insert BOM junctions for those that do not exist
            list<Id> boasCreated = new list<Id>();
            //Code modified By Vikrant for Case# 00228021 start
            List<BusinessObjectiveActivity__c> actList = new List<BusinessObjectiveActivity__c>();
            for(BusinessObjectiveMarket__c bo : [SELECT Id, Name FROM BusinessObjectiveMarket__c WHERE Id IN :BoList
                                                 AND Id NOT IN (SELECT BusinessObjectiveMarket__c FROM BusinessObjectiveActivity__c WHERE Activity__c = :SalesCall.Id)])
            {
                BusinessObjectiveActivity__c act = new BusinessObjectiveActivity__c();
                act.BusinessObjectiveMarket__c = bo.Id;
                act.Activity__c = SalesCall.Id;
                //insert act;
                actList.add(act);
                boasCreated.add(act.Id);
            }
            if(actList.size()>0){
                insert actList;
            }
            //Code modified By Vikrant for Case# 00228021 End
            initialObjectMap.put('BusinessObjectiveActivitiesCreated', boasCreated);

      OperatorPlanAmount = new Map<String, Decimal>();

            //Get all BusinessObjectives assigned to the Activity (ToDo Object)
            BusinessObjectiveIds = '';
            List<String> BusinessObjectiveList = new List<String>();
            system.debug('====SalesCall.Id ==='+ SalesCall.Id );
            //Represents BusinessObjectives already assigned to Sales Opp (used in inital table)
            BusinessObjectiveActivityList = [SELECT Name,
                                             BusinessObjectiveMarket__r.Name,
                                             BusinessObjectiveMarket__r.Id,
                                             BusinessObjectiveMarket__r.BusinessObjective__r.Manufacturer__r.Name,
                                             BusinessObjectiveMarket__r.BusinessObjective__r.EndDate__c,
                                             BusinessObjectiveMarket__r.BusinessObjective__r.ActivityType__c,
                                             BusinessObjectiveMarket__r.PlannedAmount__c, /*BusinessObjectiveMarket__r.Achieved__c, */
                                             Completed__c,/* Start S-259371 */
                                             BusinessObjective__r.Name,
                                             BusinessObjectiveMarket__r.BusinessObjective__r.DescriptionLong__c,
                                             BusinessObjectiveMarket__r.BusinessObjective__r.StartDate__c,
                                             BusinessObjective__r.Manufacturer__r.Name,
                                             BusinessObjectiveMarket__r.BusinessObjective__r.UnitOfMeasure__c,
                                             BusinessObjectiveMarket__r.Market__r.Name,
                                             BusinessObjectiveMarket__r.BusinessObjective__r.OperatorType__c,
                                             BusinessObjectiveMarket__r.BusinessObjective__r.PlanDueDate__c,
                                             BusinessObjectiveMarket__r.BusinessObjective__r.CreatedBy.Name /* End S-259371 */
                                             FROM BusinessObjectiveActivity__c WHERE Activity__c = :SalesCall.Id AND BusinessObjectiveMarket__r.TargetAmount__c > 0 AND BusinessObjectiveMarket__r.Status__c != 'Unpublished'
                                             AND BusinessObjectiveMarket__r.BusinessObjective__r.IsExpired__c = false];
            system.debug('====BusinessObjectiveActivityList.size()==='+ BusinessObjectiveActivityList.size());
            system.debug('====BusinessObjectiveActivityList==='+ BusinessObjectiveActivityList);
            BusinessObjectivePlannedActivityList = new List<BusinessObjectiveActivity__c>();

            for(BusinessObjectiveActivity__c boa : BusinessObjectiveActivityList)
            {
                system.debug('====boa.BusinessObjectiveMarket__r.PlannedAmount__c==='+ boa.BusinessObjectiveMarket__r.PlannedAmount__c);
                system.debug('====boa.usinessObjectiveMarket__r.BusinessObjective__r.CreatedBy.Name==='+ boa.BusinessObjectiveMarket__r.BusinessObjective__r.CreatedBy);
                /*LSLEVIN 00100183 10.30.2014 Commented out lines 396 397 and 401*/
                // if (boa.BusinessObjectiveMarket__r.PlannedAmount__c > 0)
                // {
                BusinessObjectiveList.add(boa.BusinessObjectiveMarket__r.Id);
                OperatorPlanAmount.put(boa.BusinessObjectiveMarket__r.Id, 0);
                BusinessObjectivePlannedActivityList.add(boa);
                // }
            }
            system.debug('====BusinessObjectivePlannedActivityList==='+ BusinessObjectivePlannedActivityList);
            /*Story S-259362 |Added by Paras Dhingra|10-08-2014|#Start */
            SalesDocIds = '';
            List<String> SalesDocList = new List<String>();
            List<SalesDocJunction__c> lstSalesDoc = new List<SalesDocJunction__c>();

            //Represents products already assigned to Sales Opp (used in inital table)
            for( SalesDocJunction__c sdj : [SELECT id, Name, SalesDoc__r.id FROM SalesDocJunction__c WHERE Activity__c = :SalesCallId AND  SalesDoc__c != null ]) {
                SalesDocList.add(sdj.SalesDoc__r.id);
            }

      //Combine the list
      SalesDocIds = String.join(SalesDocList, ',');

            SalesDocumentsList = fetchSalesDocuments();
            /*Story S-259362 #End */
            //Make the original Id Set
            OriginalBusinessObjectiveIdSet = new Set<String>(BusinessObjectiveList);
            initialObjectMap.put('OriginalBusinessObjectiveIdSet', OriginalBusinessObjectiveIdSet);
            OriginalBusinessObjectivePlannedActivityList = new List<BusinessObjectiveActivity__c>();
            OriginalBusinessObjectivePlannedActivityList = BusinessObjectivePlannedActivityList;

      //Combine the list
      BusinessObjectiveIds = String.join(BusinessObjectiveList, ',');

            for(BusinessPlanActivity__c bpa : [SELECT BusinessObjectivePlan__r.BusinessObjectiveMarket__r.Id, PlannedAmount__c,BusinessObjectivePlan__r.BusinessObjectiveMarket__r.PlannedAmount__c FROM BusinessPlanActivity__c WHERE Operator__c = :SalesCall.Operator__r.Id
                                               AND BusinessObjectivePlan__r.BusinessObjectiveMarket__c IN :OriginalBusinessObjectiveIdSet])
            {
                string bomId = bpa.BusinessObjectivePlan__r.BusinessObjectiveMarket__r.Id;
                if(!OperatorPlanAmount.containsKey(bomId))
                    OperatorPlanAmount.put(bomId, 0);

        Decimal newAmt = OperatorPlanAmount.get(bomId) + bpa.PlannedAmount__c;
        OperatorPlanAmount.put(bomId, newAmt);
      }

      //JB - Update
      OperatorMarket = SalesCall.Operator__r.Market__c;

            //Modified by Aditya Tiwari for S-546735 start
            Employee__c tempEmp = ([SELECT Id FROM Employee__c WHERE User__c = :Userinfo.getUserId()]);

            List<EmployeeOperatorAssignment__c> tempEmpAs = ([SELECT id,Employee__c,Employee__r.Employee18_ID__c,Primary_Employee__c FROM EmployeeOperatorAssignment__c WHERE Operator__c = :OperatorId  and Employee__c = :tempEmp.id limit 1]);

            if( tempEmpAs.size() > 0 ){
                if( tempEmpAs[0].Primary_Employee__c == true ){
                    primaryEmpString = tempEmpAs[0].Employee__r.Employee18_ID__c;
                }
                else{
                    primaryEmpString = null;
                }
            }
            //START | Changes Added by Gulab | S-703023 | 17-04-2023
            // if(SalesCall.StartDate__c!=null){
            //     SalesCall.Meeting_Date__c = SalesCall.StartDate__c.date();  //commented by mahesh | c-00346440 | 03-05-2023
            // }
            //END | Changes Added by Gulab | S-703023 | 17-04-2023
            //Modified by Aditya Tiwari for S-546735 End

            //update the meet now details for this sales call to reflect the changes made
            // NCarson S-708210 11/3/25 - remove call to update record to improve load time
            // UpdateMeetNowDetails('Page Opened');
            //START-Added/Updated by Komal V for Story S-705939 | 8/12/2023 | adding products to a sales call
            selectedProductStringIds ='';
            //END-Added/Updated by Komal V for Story S-705939 | 8/12/2023 | adding products to a sales call
        }
        catch (Exception e)
        {
            LogError(e);

            //initialize possible values that did not get initialized
            if(!initialObjectMap.containsKey('originalProductActivityIds')) { initialObjectMap.put('originalProductActivityIds', new set<Id>()); }
            if(!initialObjectMap.containsKey('originalProductActivities')) { initialObjectMap.put('originalProductActivities', new list<ProductActivity__c>()); }
            if(!initialObjectMap.containsKey('originalCommittedOrderIds')) { initialObjectMap.put('originalCommittedOrderIds', new set<Id>()); }
            if(!initialObjectMap.containsKey('committedOrderList')) { initialObjectMap.put('committedOrderList', new list<CommittedOrder__c>()); }
            if(!initialObjectMap.containsKey('originalSalesOppIds')) { initialObjectMap.put('originalSalesOppIds', new set<Id>()); }
            if(!initialObjectMap.containsKey('salesOpportunityList')) { initialObjectMap.put('salesOpportunityList', new list<SalesOpportunity__c>()); }
            if(!initialObjectMap.containsKey('BusinessObjectiveActivitiesCreated')) { initialObjectMap.put('BusinessObjectiveActivitiesCreated', new list<Id>()); }
            if(!initialObjectMap.containsKey('OriginalBusinessObjectiveIdSet')) { initialObjectMap.put('OriginalBusinessObjectiveIdSet', new set<string>()); }
        }
    }
    /*Story S-259362 |Added by Paras Dhingra|10-08-2014|#Start */
    public List<SalesDoc__c> fetchSalesDocuments(){

        List<SalesDocJunction__c> sdj = new List<SalesDocJunction__c>();
        Set<String> SalesDocIdSet = new Set<String>();

    //If objectId is set, only have the results from that displayed
    /*if(apexpages.currentPage().getparameters().get('Id') != null) {

        //Check for Id specific library set
        sdj = [SELECT SalesDoc__r.Id FROM SalesDocJunction__c WHERE Activity__c = :SalesCallId  and SalesDoc__c != null ];
        for(SalesDocJunction__c s : sdj) {
        SalesDocIdSet.add(s.SalesDoc__r.Id);
        }
        }
        */
        //Grab the results
        List<SalesDoc__c> ResultsList = [SELECT
                                         SalesDocSubCategory__c,
                                         SalesDocSubCategory__r.SalesDocCategory__c,
                                         Id,
                                         Name,
                                         Type__c,
                                         CreatedDate,
                                         SalesDocSubCategory__r.Name,
                                         SalesDocSubCategory__r.SalesDocCategory__r.Name,
                                         (SELECT BodyLength,LastModifiedDate FROM Attachments)
                                         FROM
                                         SalesDoc__c
                                         WHERE
                                         Id IN (Select SalesDoc__c FROM RelatedSalesDocuments__c WHERE Activity__c = :SalesCallId and SalesDoc__c != null)
                                         //ORDER BY DAY_ONLY(CreatedDate) DESC,Name ASC
                                         ORDER BY DateAdded__c DESC,Name ASC
                                        ];

    return ResultsList;
  }

  //Modified by Aditya Tiwari for S-546735 start
  //START, Code commented by Maksud Ali for Story :S-651643 [11 Mar 2020]
  /**
    public void gcReportsPopup(){

        account tempAcc = ([SELECT Id,LargeLeverageOperator__c FROM account WHERE Id = :OperatorId]);
        boolean IsOperatorLLO = tempAcc.LargeLeverageOperator__c;

        Employee__c tempEmp = ([SELECT Id FROM Employee__c WHERE User__c = :Userinfo.getUserId()]);

        List<EmployeeOperatorAssignment__c> tempEmpAs = ([SELECT id,Employee__c,Employee__r.Employee18_ID__c,Primary_Employee__c FROM EmployeeOperatorAssignment__c WHERE Operator__c = :OperatorId  and Employee__c = :tempEmp.id limit 1]);

        if( tempEmpAs.size() > 0 ){
            if( tempEmpAs[0].Primary_Employee__c == true ){
                primaryEmpString = tempEmpAs[0].Employee__r.Employee18_ID__c;
            }
            else{
                primaryEmpString = null;
            }
        }

        boolean committedorderavailable =false;
        //Modified by Aditya Tiwari for S-554835;Addded fields in below query
        //List<ProductActivity__c> paList = [select id, Sale_Progress_Follow_up_Call__c, Sale_is_In_Progress__c, OperatorFeedbackReasons__c, ProductStatus__c, OperatorFeedback__c, PotentialSalesVolume__c, CasesWeekUsage__c from ProductActivity__c WHERE Activity__r.Id = :SalesCall.Id];
        List<ProductActivity__c> paList = [select id, Sale_Progress_Follow_up_Call__c,Reasons_unsold__c, Sale_is_In_Progress__c, Estimated_Weekly_Sales_Volume__c, What_are_next_steps__c,Was_a_cutting_conducted__c, Reasons_unwilling_to_consider__c, Distributor_Not_sold_Reasons_final__c, Distributor_New_Item_Reasons_Final__c, Distributor_Not_sold_Reasons__c, Distributer_SIP_New_Item__c,Who_was_the_Distributor__c,Distributor_Not_Sold_Product_Status__c,Photo_taken__c, Specific_Issue__c, Will_Client_pay_slotting_fee__c, Marketing_program_exist__c,Competitive_Client__c, Competitive_Client__r.Name, Operator_Contract_Expiry_Date__c ,Distributor_SIP_CCC_Feedback__c,Distributor_SIP_New_Item_Feedback__c,When_do_you_expect_testing_to_conclude__c,OperatorFeedbackReasons__c, ProductStatus__c, OperatorFeedback__c,sample_case_Option__c, Where_do_we_need_to_get_pricing__c,Is_operator_under_contract__c,Who_needs_to_review_product_at_Operator__c,Quality_Issue__c,PotentialSalesVolume__c,Distributor_final_New_Item_feedback__c,distributor_final_CCC_Feedback__c,Operator_Unwilling_Feedback__c,What_is_the_allowance_per_case_needed__c,Not_Sold_Price__c, CasesWeekUsage__c from ProductActivity__c WHERE Activity__r.Id = :SalesCall.Id];
        List<CommittedOrder__c> committedOrders = [select id, Product_Activity__c, CompetitorInformation__c, Quantity_Entered__c from CommittedOrder__c where Product_Activity__c in :paList];
        System.debug('11111@@@@@-->');
        if(committedOrders.size() > 0 )
        {
            committedorderavailable = true;
        }

        system.debug('IsOperatorLLO::' + IsOperatorLLO + '::' + primaryEmpString);
        if( IsOperatorLLO && primaryEmpString != null && committedorderavailable ){
            isreportrun = true;
            system.debug('isreportrun::' + isreportrun);
        }

    }
    */
  //END, Code commented by Maksud Ali for Story :S-651643 [11 Mar 2020]

    
    //Start- Add by Mayank| S-707888 | 25 April 2025  || create a new pick list
   public List<SelectOption> getSalesCallAssistTypes()
    {
       List<SelectOption> employeeOptions = new List<SelectOption>();
    
        // Get current user ID
        Id currentUserId = UserInfo.getUserId();
        // Query all active users except current user
        System.debug('currentUserId>>>'+currentUserId);
       employeeOptions.add(new SelectOption('','--None--'));
        List<Employee__c> activeUsers = [SELECT Id, Name FROM Employee__c WHERE dactestactive__c = true AND Can_Enter_a_Sales_Assist__c = true AND User__c != :currentUserId ORDER BY Name ASC];
        for (Employee__c u : activeUsers) {
            employeeOptions.add(new SelectOption(u.Id, u.Name));
        }
       
        System.debug('activeUsers size '+activeUsers.size());
       
           
        
        return employeeOptions;
    }
       //end- by Mayank| S-707888 | 25 April 2025  || create a new pick list
    
    ///Modified by Aditya Tiwari for S-546735 End
    /*Story S-259362 |Added by Paras Dhingra|10-08-2014|#End */
    /*method to revert back to original savepoint when navigating away from the page*/
    public void RevertSavepoint()
    {
        try
        {
            if(initialObjectMap.containsKey('SalesCall') && (!initialObjectMap.containsKey('revert') || (boolean)initialObjectMap.get('revert')))
            {
                //Get the EmployeeId
                String EmployeeId = '';
                try { EmployeeId = [SELECT Id FROM Employee__c WHERE User__c = :UserInfo.getUserId() LIMIT 1][0].Id; } catch(Exception ex) {}

                //delete any product activities created
                list<Id> pasCreated = new list<Id>();
                if(initialObjectMap.containsKey('ProductActivitiesCreated'))
                {
                    pasCreated = (list<Id>)initialObjectMap.get('ProductActivitiesCreated');
                }
                set<Id> originalProductActivityIds = (set<Id>)initialObjectMap.get('originalProductActivityIds');
                delete [SELECT Id FROM ProductActivity__c WHERE Id IN :pasCreated OR (Activity__c = :SalesCall.Id AND Id NOT IN :originalProductActivityIds)];

                //revert the product activities back to original values
                //update (list<ProductActivity__c>)initialObjectMap.get('originalProductActivities');
                list<ProductActivity__c> pasToRevert = new list<ProductActivity__c>();
                for(ProductActivity__c pa : (list<ProductActivity__c>)initialObjectMap.get('originalProductActivities'))
                {
                    pa.ProductStatus__c = pa.ProductStatus__c;
                    pa.OperatorFeedback__c = pa.OperatorFeedback__c;
                    pa.OperatorFeedbackReasons__c = pa.OperatorFeedbackReasons__c;
                    //Modified by Aditya Tiwari for S-554835 Start
                    pa.Estimated_Weekly_Sales_Volume__c = pa.Estimated_Weekly_Sales_Volume__c;
                    //pa.Estimated_Weekly_SalesVolume__c = pa.Estimated_Weekly_SalesVolume__c;       // Added by Esoof | S-707717 | 14/02/25
                    pa.Not_Sold_Price__c = pa.Not_Sold_Price__c;
                    pa.What_is_the_allowance_per_case_needed__c = pa.What_is_the_allowance_per_case_needed__c;
                    pa.Reasons_unsold__c =  pa.Reasons_unsold__c;
                    //Modified by Aditya Tiwari for S-554835 End
                    //pa.WeeklyVolume__c = pa.WeeklyVolume__c;
                    pa.CasesWeekUsage__c = pa.CasesWeekUsage__c;
                    pa.CommittedOrder__c = pa.CommittedOrder__c;
                    // Start - Jai Gupta - S-339868 - Populate field values
                    pa.Not_Sold_Result_is_Final__c = pa.Not_Sold_Result_is_Final__c;
                    pa.Sale_is_In_Progress__c = pa.Sale_is_In_Progress__c;
                    pa.Sale_Progress_Follow_up_Call__c = pa.Sale_Progress_Follow_up_Call__c;
                    pa.Create_Follow_Up__c = pa.Create_Follow_Up__c;
                    // End - Jai Gupta - S-339868 - Populate field values

          /*** Code modified - Padmesh Soni (09/06/2016 Appirio Offshore) - S-421422: I-233625 - Start ***/
          //Revert previous data from history
          pa.Activity_Start_Date__c = pa.Activity_Start_Date__c;
          pa.Activity_End_Date__c = pa.Activity_End_Date__c;
          /*** Code modified - Padmesh Soni (09/06/2016 Appirio Offshore) - S-421422: I-233625 - End ***/

          pasToRevert.add(pa);
        }
        update pasToRevert;

                //delete business plan activities created
                if(initialObjectMap.containsKey('BusinessPlanActivitiesCreated'))
                {
                    set<Id> bpasCreated = (set<Id>)initialObjectMap.get('BusinessPlanActivitiesCreated');
                    delete [SELECT Id FROM BusinessPlanActivity__c WHERE Id IN :bpasCreated];
                }

                //undelete deleted business objective activity
                set<string> boasOriginal = (set<string>)initialObjectMap.get('OriginalBusinessObjectiveIdSet');
                undelete [SELECT Id FROM BusinessObjectiveActivity__c WHERE Id IN :boasOriginal AND IsDeleted = true];

                //delete any business objective activities created
                set<Id> boasCreatedOnSave = new set<Id>();
                if(initialObjectMap.containsKey('BusinessObjectiveActivitiesCreatedDuringSave'))
                {
                    boasCreatedOnSave = (set<Id>)initialObjectMap.get('BusinessObjectiveActivitiesCreatedDuringSave');
                }
                list<Id> boasCreated = (list<Id>)initialObjectMap.get('BusinessObjectiveActivitiesCreated');

                delete [SELECT Id FROM BusinessObjectiveActivity__c WHERE Id IN :boasCreated OR Id IN :boasCreatedOnSave];

        update OriginalBusinessObjectivePlannedActivityList;


                //delete any business objective plans created
                if(initialObjectMap.containsKey('BusinessObjectPlansCreated'))
                {
                    set<string> boMarkets = (set<string>)initialObjectMap.get('BusinessObjectPlansCreated');
                    delete [SELECT Id FROM BusinessObjectivePlan__c WHERE Employee__c = :EmployeeId AND BusinessObjectiveMarket__c IN :boMarkets];
                }

                //delete committed orders
                set<Id> cosOriginalIds = (set<Id>)initialObjectMap.get('originalCommittedOrderIds');
                System.debug('@@@@@4444');
                delete [SELECT Id FROM CommittedOrder__c WHERE SalesCall__c = :SalesCall.Id AND Id NOT IN :cosOriginalIds];

                //revert the committed orders back to original values
                //update (list<CommittedOrder__c>)initialObjectMap.get('committedOrderList');
                list<CommittedOrder__c> cosToRevert = new list<CommittedOrder__c>();
                for(CommittedOrder__c co : (list<CommittedOrder__c>)initialObjectMap.get('committedOrderList'))
                {
                    co.Product__c = co.Product__c;
                    co.Quantity_Entered__c = co.Quantity_Entered__c;
                    co.MeasurementUnits__c = co.MeasurementUnits__c;
                    co.Status__c = co.Status__c;
                    co.ExpectedOrder__c = co.ExpectedOrder__c;
                    co.Distributor__c = co.Distributor__c;
                    co.Contact__c = co.Contact__c;
                    //Start | case 00357110 | Swastika | change field type
                    co.Feedback__c = co.Feedback__c;
                    //End | case 00357110 | Swastika | change field type
                    co.FeedbackType__c = co.FeedbackType__c;
                    //Added by Shubham for Story S-426804 #Start
                    co.Sale_Type__c = co.Sale_Type__c;
                    co.Based_on_Bid__c = co.Based_on_Bid__c;
                    //Added by Shubham for Story S-426804 #End
                    co.CompetitorInformation__c = co.CompetitorInformation__c;
                    co.Product_Activity__c = co.Product_Activity__c;
                    co.Annual_Case_Volume__c = co.Annual_Case_Volume__c; // S-343194 - Hemlata
                    co.Expected_Order_End_Date__c = co.Expected_Order_End_Date__c; // S-343194 - Hemlata

                    //co.Color__c = co.Color__c;
                    cosToRevert.add(co);
                }
                update cosToRevert;
                System.debug('33333@@@@@@@');
                //delete sales opportunities
                if(initialObjectMap.containsKey('sosCreated'))
                {
                    set<Id> sosCreated = (set<Id>)initialObjectMap.get('sosCreated');
                    delete [SELECT Id FROM SalesOpportunity__c WHERE Id IN :sosCreated];
                }

                //revert the sales opportunities back to original values
                //update (set<SalesOpportunity__c>)initialObjectMap.get('salesOpportunityList');
                list<SalesOpportunity__c> sosToRevert = new list<SalesOpportunity__c>();
                for(SalesOpportunity__c so : (set<SalesOpportunity__c>)initialObjectMap.get('salesOpportunityList'))
                {
                    so.Manufacturer__c = so.Manufacturer__c;
                    so.Status__c = so.status__c;
                    so.CommittedOrder__c = so.CommittedOrder__c;
                    sosToRevert.add(so);
                }
                update sosToRevert;

        //delete or revert to the original SaleCall state, but keep the updated meet now details
        string meetNowDetails = SalesCall.MeetingNowDetailedOperations__c;

                SalesCall = (Activity__c)initialObjectMap.get('SalesCall');
                SalesCall.MeetingNowDetailedOperations__c = meetNowDetails;
                SalesCall.Contact__c = SalesCall.Contact__c;
                SalesCall.Distributor__c = SalesCall.Distributor__c;
                SalesCall.Description__c = SalesCall.Description__c;
                SalesCall.MeetingStartedTime__c = SalesCall.MeetingStartedTime__c;
                SalesCall.StartDate__c = SalesCall.StartDate__c;
                SalesCall.Status__c = SalesCall.Status__c;
                SalesCall.DistributorNA__c = SalesCall.DistributorNA__c;
                                 

        //Start- Add by Mayank| S-707888 | 25 April 2025  || create a new pick list
        if (salesCallAssistValue != '') {
          SalesCall.Assisted_Employee__c = salesCallAssistValue;
        }

        System.debug('StartUpAction>>> 1990 ' + SalesCall.Assisted_Employee__c);
        //end- Add by Mayank| S-707888 | 25 April 2025  || create a new pick list

                //START | Changes Added by Gulab | S-703023 | 17-04-2023
                //SalesCall.Meeting_Date__c = SalesCall.Meeting_Date__c;    //commented by mahesh | c-00346440 | 03-05-2023
                //END | Changes Added by Gulab | S-703023 | 17-04-2023
                

                if((boolean)initialObjectMap.get('SalesCallCreatedOnPageLoad')) { delete SalesCall; }
                else { update SalesCall; }

        //update the meet now details for this sales call to reflect the changes made
        UpdateMeetNowDetails('Meeting Reverted to Last Page Load');

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Meet Now REVERTED to last page load'));
            }
        }
        catch (Exception e)
        {
            System.debug('### error ' + e.getMessage());
            initialObjectMap.put('revert', true);
            LogError(e);
        }
    }

    /*save the meeting*/
    public void SaveMeeting()
    {   SaveMeetExcepMsg = ''; //Added by Lalit for S-334717
        System.debug('I am in Savemeeting'+CommittedOrderString);
        try
        {
            /*Add the BusinessObjective Activity junctions*/

      //trim whitespace
      BusinessObjectiveIds = BusinessObjectiveIds.trim();

         //Split the Ids on the comma
         List<String> BusinessObjectiveList = BusinessObjectiveIds.split(',');  
         //Create the set of Ids from the page
         Set<String> NewBusinessObjectiveIdSet = new Set<String>(BusinessObjectiveList);

      /*
        if(!initialObjectMap.containsKey('BusinessObjectiveActivitiesCreatedDuringSave')) { initialObjectMap.put('BusinessObjectiveActivitiesCreatedDuringSave', new set<Id>()); }
        set<Id> boasCreatedDuringSave = (set<Id>)initialObjectMap.get('BusinessObjectiveActivitiesCreatedDuringSave');
        */

      /** Code modified - Padmesh Soni (7/26/2017 Appirio Offshore) - Case #:00201997 - Start **/
      //Delete if not in new Set from page; changed to a loop due to it attempting to delete already deleted objects and causing an error
      //Code commented
      /**for(BusinessObjectiveActivity__c boa : [SELECT Id FROM BusinessObjectiveActivity__c WHERE BusinessObjectiveMarket__c NOT IN :NewBusinessObjectiveIdSet AND Activity__c = :SalesCall.Id AND IsDeleted = false])
            {
            try { delete boa; }
            catch(Exception ex)
            {
            if(!ex.getMessage().contains('ENTITY_IS_DELETED')) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getLineNumber()+': '+ex.getMessage())); }
            }

            //boasCreatedDuringSave.remove(boa.Id);
            }**/

         //Query results
         List<BusinessObjectiveActivity__c> boaList = [SELECT Id FROM BusinessObjectiveActivity__c WHERE BusinessObjectiveMarket__c NOT IN :NewBusinessObjectiveIdSet
                                                       AND Activity__c = :SalesCall.Id AND IsDeleted = false];

         //Check for size of list
         if(boaList.size() > 0) {

             try {

                 //Perform DML Operations
                 delete boaList;
             } catch(Exception ex) {

                 //Handle exception
                 if(!ex.getMessage().contains('ENTITY_IS_DELETED')) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getLineNumber()+': '+ex.getMessage())); }
             }
         }
         /** Code modified - Padmesh Soni (7/26/2017 Appirio Offshore) - Case #:00201997 - End **/

      /*
        //save selected business activities
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, JSON.serialize(NewBusinessObjectiveIdSet)));
        for(string bomId : NewBusinessObjectiveIdSet)
        {
        if(string.isNotEmpty(bomId))
        {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, bomId));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'original contains : '+string.valueOf(OriginalBusinessObjectiveIdSet.contains(bomId))));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'already created contains : '+string.valueOf(boasCreatedDuringSave.contains(bomId))));
        if(!OriginalBusinessObjectiveIdSet.contains(bomId) && !boasCreatedDuringSave.contains(Id.valueOf(bomId)))
        {
        BusinessObjectiveActivity__c boa = new BusinessObjectiveActivity__c(Activity__c = SalesCall.Id, BusinessObjectiveMarket__c = bomId);
        insert boa;
        boasCreatedDuringSave.add(boa.Id);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Inserted'));
        }
        }
        }
        initialObjectMap.put('BusinessObjectiveActivitiesCreatedDuringSave', boasCreatedDuringSave);
        */

         //Get the EmployeeId
         String EmployeeId = '';
         try { EmployeeId = [SELECT Id FROM Employee__c WHERE User__c = :UserInfo.getUserId() LIMIT 1][0].Id; } catch(Exception ex) {}

      //Employee specific map <BOId, corresponding plan>
      map<String, BusinessObjectivePlan__c> UserPlanMap = new Map<String, BusinessObjectivePlan__c>();
      map<String, BusinessObjectivePlan__c> UserPlanMapCreated = new Map<String, BusinessObjectivePlan__c>();

         //Make a map of Employee plans for the Business Objectives and snag the Employee Id at some point
         for(BusinessObjectivePlan__c bop : [SELECT BusinessObjectiveMarket__r.Id, Employee__r.Id FROM BusinessObjectivePlan__c
                                             WHERE BusinessObjectiveMarket__c IN :BusinessObjectiveList AND Employee__r.User__c = :UserInfo.getUserId() FOR UPDATE])
         {
             UserPlanMap.put(bop.BusinessObjectiveMarket__r.Id, bop);
         }
         // Commented out by Rahul for story - S-309722
         /* for(String boId : BusinessObjectiveList)
            {
            if(string.isNotEmpty(boId) && !UserPlanMap.containsKey(boId))
            {
            BusinessObjectivePlan__c bop = new BusinessObjectivePlan__c();
            bop.BusinessObjectiveMarket__c = boId;
            bop.Employee__c = EmployeeId;
            bop.TargetAmount__c = 0;
            UserPlanMapCreated.put(boId, bop);
            }
            }

            insert UserPlanMapCreated.values();
            initialObjectMap.put('BusinessObjectPlansCreated', UserPlanMapCreated.keySet());
            UserPlanMap.putAll(UserPlanMapCreated);*/
      // End  S-309722
      //Employee specific map <BOId, corresponding plan activity>
      set<Id> PlanActivityBos = new Set<Id>();
      set<Id> PlanActivitiesCreated = new Set<Id>();
      list<BusinessPlanActivity__c> PlanActivitiesToCreate = new List<BusinessPlanActivity__c>();

         //Make a map of Employee plans for the Business Objectives and snag the Employee Id at some point
         for(BusinessPlanActivity__c bpa : [SELECT BusinessObjectivePlan__r.BusinessObjectiveMarket__r.Id,Operator__r.Id FROM BusinessPlanActivity__c
                                            WHERE Operator__c = :OperatorId AND BusinessObjectivePlan__c IN :UserPlanMap.values()])
         {
             PlanActivityBos.add(bpa.BusinessObjectivePlan__r.BusinessObjectiveMarket__r.Id);
         }

         for(String boId : BusinessObjectiveList)
         {
             if(string.isNotEmpty(boId) && !PlanActivityBos.contains(boId))
             {
                 if(!UserPlanMap.containsKey(boId))
                 {
                     ErrorHandlerGlobal.logError('No Key For : (' + boId + ') - ' +UserPlanMap, ApexPages.currentPage().getURL());
                 }
                 else
                 {
                     BusinessPlanActivity__c bpa = new BusinessPlanActivity__c();
                     bpa.BusinessObjectivePlan__c = UserPlanMap.get(boId).Id;
                     bpa.Operator__c = OperatorId;
                     bpa.PlannedAmount__c = 0;
                     PlanActivitiesToCreate.add(bpa);
                 }
             }
         }

      insert PlanActivitiesToCreate;

         for(BusinessPlanActivity__c bpa : PlanActivitiesToCreate)
         {
             PlanActivitiesCreated.add(bpa.Id);
         }
         initialObjectMap.put('BusinessPlanActivitiesCreated', PlanActivitiesCreated);

         List<ProductActivity__c> ProductActivityList = new List<ProductActivity__c>();
         List<SalesOpportunity__c> OpportunityList = new List<SalesOpportunity__c>();
         Set<Id> setOfproductActivityListForDeleting = new Set<Id>();//Code added by parag bhatt for case #00264933
         map<String,SalesOpportunity__c> OpportunityMap = new map<String,SalesOpportunity__c>();
            for(AssignedProduct ap : AssignedProductList)
            {
                //system.debug('--------'+ap.ProductActivity.Operator_Contract_Expiry_Date__c);
                /*LSLEVIN Case 99079 10.21.2014 Start*/
                if(ap.ProductActivity.ProductStatus__c == 'Sold') {
                    /*ap.ProductSold.Status__c = 'Active';
                    upsert ap.ProductSold;*/
                    //ap.ProductActivity.CommittedOrder__c = ap.ProductSold.Id; //Commented by Shobhit Pant for Case 00223065 05/08/2018
                    //Modified by Aditya Tiwari for S-532356 12/18/2017 Start
                    ap.ProductActivity.PotentialSalesVolume__c = null;

          //Modified by Aditya Tiwari for S-532356 12/18/2017 End

          // Start --- Code Added By parag bhatt for Case #00250591
          ap.ProductActivity.CasesWeekUsage__c = null;
          ap.ProductActivity.OperatorFeedback__c = null;

          ap.ProductActivity.Who_was_the_Distributor__c = null;
          ap.ProductActivity.Estimated_Weekly_Sales_Volume__c = null;
          //ap.ProductActivity.Estimated_Weekly_SalesVolume__c = null;            // Added by Esoof | S-707717 | 14/02/25
          ap.ProductActivity.Operator_Contract_Expiry_Date__c = null;
          ap.ProductActivity.Is_operator_under_contract__c = null;
          ap.ProductActivity.Not_Sold_Result_is_Final__c = false;
          ap.ProductActivity.Operator_Unwilling_Feedback__c = null;
          ap.ProductActivity.Sale_is_In_Progress__c = false;
          ap.ProductActivity.Competitive_Client__c = null;
          ap.ProductActivity.Not_Sold_Price__c = null;
          ap.ProductActivity.Reasons_unsold__c = null;
          ap.ProductActivity.Quality_Issue__c = null;
          ap.ProductActivity.Was_a_cutting_conducted__c = null;
          ap.ProductActivity.Reasons_unwilling_to_consider__c = null;
          ap.ProductActivity.Sales_in_Progress__c = null;
          ap.ProductActivity.sample_case_Option__c = null;
          ap.ProductActivity.Who_needs_to_review_product_at_Operator__c = null;
          //START -- UnCommented What_are_next_steps__c field  by Shreya | C-00283734 | 24/12/2020 |uncomm. after changing field type to Text Area [long]
          ap.ProductActivity.What_are_next_steps__c = null;
          //END -- UnCommented What_are_next_steps__c field  by Shreya | C-00283734 | 24/12/2020 |uncomm. after changing field type to Text Area [long]
          ap.ProductActivity.Sale_Progress_Follow_up_Call__c = null;
          ap.ProductActivity.Activity_End_Date__c = null;
          ap.ProductActivity.Activity_Start_Date__c = null;
          ap.ProductActivity.When_do_you_expect_testing_to_conclude__c = null;
          ap.ProductActivity.Where_do_we_need_to_get_pricing__c = null;
          ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null;
          ap.ProductActivity.distributor_final_CCC_Feedback__c = null;
          ap.ProductActivity.Distributor_Not_sold_Reasons_final__c = null;
          ap.ProductActivity.Distributor_Not_sold_Reasons__c = null;
          ap.ProductActivity.Distributor_Not_Sold_Product_Status__c = null;
          ap.ProductActivity.Distributor_New_Item_Reasons_Final__c = null;
          ap.ProductActivity.Distributor_final_New_Item_feedback__c = null;
          ap.ProductActivity.Photo_taken__c = null;
          ap.ProductActivity.Specific_Issue__c = null;
          ap.ProductActivity.Will_Client_pay_slotting_fee__c = null;
          ap.ProductActivity.Marketing_program_exist__c = null;
          ap.ProductActivity.Distributor_SIP_CCC_Feedback__c = null;
          ap.ProductActivity.Distributer_SIP_New_Item__c = null;
          ap.ProductActivity.Distributor_SIP_New_Item_Feedback__c = null;
          ap.ProductActivity.Using_Purchase_Frequency__c = null;
          ap.ProductActivity.Using_Distributor__c = null;

                 // NCarson 5/7/25 - C-00357707 - do not overwrite valid value with null (comment out)
                 // ap.ProductActivity.Quantity_Entered__c = null;
                 // END --- Code Added By parag bhatt for Case #00250591
                 
             }
             else {
                 ap.ProductActivity.CommittedOrder__c = null;
                 // Start --- Code Added By parag bhatt for Case #00264933
                 System.debug('####Product Activity is'+ap.ProductActivity.Id);
                 if(ap.ProductActivity.Id != null){
                     setOfproductActivityListForDeleting.add(ap.ProductActivity.Id);
                 }
                 // END --- Code Added By parag bhatt for Case #00264933
             }
             /*LSLEVIN Case 99079 10.21.2014 END*/
             //START-Removed condition by komal for Story S-705177 | 4/10/2023 | removing "Not Shown" filter for picklist value -[|| ap.ProductActivity.ProductStatus__c == 'Not Shown']
             // START --- Code Added By parag bhatt for Case #00250591
             if(ap.ProductActivity.ProductStatus__c == 'Using') {
             //END-Removed condition by komal for Story S-705177 | 4/10/2023 | removing "Not Shown" filter for picklist value -[|| ap.ProductActivity.ProductStatus__c == 'Not Shown']
                 ap.ProductActivity.PotentialSalesVolume__c = null;
                 ap.ProductActivity.Who_was_the_Distributor__c = null;
                 ap.ProductActivity.Estimated_Weekly_Sales_Volume__c = null;
                 //ap.ProductActivity.Estimated_Weekly_SalesVolume__c = null;             // Added by Esoof | S-707717 | 14/02/25
                 ap.ProductActivity.Operator_Contract_Expiry_Date__c = null;
                 ap.ProductActivity.Is_operator_under_contract__c = null;
                 ap.ProductActivity.Not_Sold_Result_is_Final__c = FALSE;
                 ap.ProductActivity.Operator_Unwilling_Feedback__c = null;
                 ap.ProductActivity.Sale_is_In_Progress__c = FALSE;
                 ap.ProductActivity.Competitive_Client__c = null;
                 ap.ProductActivity.Not_Sold_Price__c = null;
                 ap.ProductActivity.Reasons_unsold__c = null;
                 ap.ProductActivity.Quality_Issue__c = null;
                 ap.ProductActivity.Was_a_cutting_conducted__c = null;
                 ap.ProductActivity.Reasons_unwilling_to_consider__c = null;
                 ap.ProductActivity.Sales_in_Progress__c = null;
                 ap.ProductActivity.sample_case_Option__c = null;
                 ap.ProductActivity.Who_needs_to_review_product_at_Operator__c = null;
                 //START -- UnCommented What_are_next_steps__c field  by Shreya | C-00283734 | 24/12/2020 |uncomm. after changing field type to Text Area [long]
                 ap.ProductActivity.What_are_next_steps__c = null;
                 //END -- UnCommented What_are_next_steps__c field  by Shreya | C-00283734 | 24/12/2020 |uncomm. after changing field type to Text Area [long]
                 ap.ProductActivity.Sale_Progress_Follow_up_Call__c = null;
                 ap.ProductActivity.Activity_End_Date__c = null;
                 ap.ProductActivity.Activity_Start_Date__c = null;
                 ap.ProductActivity.When_do_you_expect_testing_to_conclude__c = null;
                 ap.ProductActivity.Where_do_we_need_to_get_pricing__c = null;
                 ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null;
                 ap.ProductActivity.distributor_final_CCC_Feedback__c = null;
                 ap.ProductActivity.Distributor_Not_sold_Reasons_final__c = null;
                 ap.ProductActivity.Distributor_Not_sold_Reasons__c  = null;
                 ap.ProductActivity.Distributor_Not_Sold_Product_Status__c = null;
                 ap.ProductActivity.Distributor_New_Item_Reasons_Final__c = null;
                 ap.ProductActivity.Distributor_final_New_Item_feedback__c = null;
                 ap.ProductActivity.Photo_taken__c = null;
                 ap.ProductActivity.Specific_Issue__c = null;
                 ap.ProductActivity.Will_Client_pay_slotting_fee__c = null;
                 ap.ProductActivity.Marketing_program_exist__c = null;
                 ap.ProductActivity.Distributor_SIP_CCC_Feedback__c = null;
                 ap.ProductActivity.Distributer_SIP_New_Item__c = null;
                 ap.ProductActivity.Distributor_SIP_New_Item_Feedback__c = null;
                 //START-Commented condition by komal for Story S-705177 | 4/10/2023 | removing "Not Shown" filter for picklist value
                 /*if(ap.ProductActivity.ProductStatus__c == 'Not Shown'){
                     ap.ProductActivity.CasesWeekUsage__c = null;
                     ap.ProductActivity.Using_Purchase_Frequency__c = null;
                     ap.ProductActivity.Using_Distributor__c = null;
                 }*/
          //END-Commented condition by komal for Story S-705177 | 4/10/2023 | removing "Not Shown" filter for picklist value
        }
        // END --- Code Added By parag bhatt for Case #00250591

             /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - Start ***/
             if(ap.ProductActivity.ProductStatus__c == 'Not Sold') {
                 ap.ProductActivity.CasesWeekUsage__c = null;
                 //Commented by ASL June 8th, 2022  S-695261
                 //ap.ProductActivity.OperatorFeedback__c = null;
                 ap.ProductActivity.Quantity_Entered__c = null;
                //Start |added by Rahul T - C-00285384 [to make below fields false if not sold]
                 ap.ProductActivity.Supported__c=false;
                 ap.ProductActivity.Verbal__c=false;
                 //End |added by Rahul T - C-00285384 [to make below fields false if not sold]
                 //Modified by Aditya Tiwari for S-532356 12/18/2017 Start
                 if(ap.ProductActivity.Not_Sold_Result_is_Final__c == true)
                 {
                     ap.ProductActivity.Create_Follow_Up__c = false;
                 }
                 //Modified by Aditya Tiwari for S-532356 12/18/2017 End
                 // Start AT
                 if(String.isNotBlank(ap.operatorContractExpiryDate)) {
                     ap.ProductActivity.Operator_Contract_Expiry_Date__c = Date.parse(ap.operatorContractExpiryDate);
                 } else {
                     ap.ProductActivity.Operator_Contract_Expiry_Date__c = null ;
                 }

          //When do you expect testing to conclude? field

                 if(String.isNotBlank(ap.OperatorSIPconclude)) { //OperatorSIPconclude
                     ap.ProductActivity.When_do_you_expect_testing_to_conclude__c = Date.parse(ap.OperatorSIPconclude);
                 } else {
                     ap.ProductActivity.When_do_you_expect_testing_to_conclude__c = null ;
                 }

          //system.assert(false,ap.ProductActivity.Reasons_unsold__c);
          /*if(String.isNotBlank(DistributorId) && ap.ProductActivity.Reasons_unsold__c != 'Pricing') {
                ap.ProductActivity.Who_was_the_Distributor__c = DistributorId;
                } else {
                ap.ProductActivity.Who_was_the_Distributor__c = null ;
                } */

          //system.assert(false,ap.ProductActivity.Is_operator_under_contract__c);
          // End AT


                 //Modified by Aditya Tiwari for Feedback MP start
                 //Remove the Value of Other Reasons Unsold
                 //Modified by Aditya Tiwari for Feedback MP End
                 // START NCarson C-00357966 6/16/25 - try / catch - format with comma upon failure
                 try {
                   if(String.isNotBlank(ap.startDate) && String.isNotBlank(ap.startTime)) {
                     ap.ProductActivity.Activity_Start_Date__c = DateTime.parse(ap.startDate +' '+ ap.startTime);
                   }
                   if(String.isNotBlank(ap.startDate) && String.isNotBlank(ap.endTime)) {
                     system.debug('tt2::'+ap.startDate);
                     ap.ProductActivity.Activity_End_Date__c = DateTime.parse(ap.startDate +' '+ ap.endTime);
                   }
                 } catch (Exception ex) {
                   if(String.isNotBlank(ap.startDate) && String.isNotBlank(ap.startTime)) {
                     ap.ProductActivity.Activity_Start_Date__c = DateTime.parse(ap.startDate +', '+ ap.startTime);
                   }
                   if(String.isNotBlank(ap.startDate) && String.isNotBlank(ap.endTime)) {
                     system.debug('tt2::'+ap.startDate);
                     ap.ProductActivity.Activity_End_Date__c = DateTime.parse(ap.startDate +', '+ ap.endTime);
                   }
                 } // END NCarson C-00357966 6/16/25 - try / catch - format with comma upon failure
                 // Jai gupta
                 if(OperatorType == 'Operator') {
                     if(ap.ProductActivity.Not_Sold_Result_is_Final__c == true) {
                         // Empty Sale is in Progress values
                         // testing/sample provided fields (except next steps and weekly case volume)
                         ap.ProductActivity.sample_case_Option__c = null ;
                         ap.ProductActivity.When_do_you_expect_testing_to_conclude__c = null ;
                         ap.ProductActivity.Who_needs_to_review_product_at_Operator__c = null ;
                         ap.ProductActivity.Where_do_we_need_to_get_pricing__c = null ;
                         ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null ;
                         ap.ProductActivity.Sales_in_Progress__c = null;

              if (ap.ProductActivity.Reasons_unsold__c == 'Pricing') {
                // Quality fields
                ap.ProductActivity.Was_a_cutting_conducted__c = null;
                ap.ProductActivity.Quality_Issue__c = '';

                // Operator Unwilling fields
                ap.ProductActivity.Operator_Unwilling_Feedback__c = '';
                ap.ProductActivity.Reasons_unwilling_to_consider__c = null;
              } else if (ap.ProductActivity.Reasons_unsold__c == 'Quality') {
                // Pricing Fields
                ap.ProductActivity.Is_operator_under_contract__c = null;
                ap.ProductActivity.Operator_Contract_Expiry_Date__c = null;
                ap.ProductActivity.Not_Sold_Price__c = null;


                             // Operator Unwilling fields
                             ap.ProductActivity.Operator_Unwilling_Feedback__c = '' ;
                             ap.ProductActivity.Reasons_unwilling_to_consider__c = null ;

                         } else if(ap.ProductActivity.Reasons_unsold__c == 'Operator Unwilling to Consider') {
                             // Quality fields
                             ap.ProductActivity.Was_a_cutting_conducted__c = null ;
                             ap.ProductActivity.Quality_Issue__c = '' ;
                             ap.ProductActivity.Estimated_Weekly_Sales_Volume__c = null ;
                             //ap.ProductActivity.Estimated_Weekly_SalesVolume__c = null ;                // Added by Esoof | S-707717 | 14/02/25

                // Pricing fields
                ap.ProductActivity.Is_operator_under_contract__c = null;
                ap.ProductActivity.Operator_Contract_Expiry_Date__c = null;
                ap.ProductActivity.Not_Sold_Price__c = null;
              }
            } else if (ap.ProductActivity.Sale_is_In_Progress__c == true) {
              // Not sold empty fields
              ap.ProductActivity.Was_a_cutting_conducted__c = null;
              ap.ProductActivity.Quality_Issue__c = '';
              ap.ProductActivity.Operator_Contract_Expiry_Date__c = null;
              ap.ProductActivity.Not_Sold_Price__c = null;
              ap.ProductActivity.Operator_Unwilling_Feedback__c = '';
              ap.ProductActivity.Reasons_unwilling_to_consider__c = null;
              ap.ProductActivity.Reasons_unsold__c = null;

                         String salesInProgressPickVal = ap.ProductActivity.Sales_in_Progress__c ;
                         if(String.isBlank(salesInProgressPickVal)) {
                             salesInProgressPickVal = '' ;
                         } else {
                             salesInProgressPickVal = salesInProgressPickVal.toLowerCase();
                         }
                         // Empty Sale is in Progress values
                         if(salesInProgressPickVal == 'pricing') {
                             // operator would purchase if stocked at distributor fields (except next steps and weekly case volume)
                             // No fields to make empty

                // testing/sample provided fields (except next steps and weekly case volume)
                ap.ProductActivity.sample_case_Option__c = null;
                ap.ProductActivity.When_do_you_expect_testing_to_conclude__c = null;

                             // under review/no sample provided fields (except next steps and weekly case volume)
                             ap.ProductActivity.Who_needs_to_review_product_at_Operator__c = null ;

                         } else if(salesInProgressPickVal == 'operator would purchase if stocked at distributor') {
                             // pricing fields (except next steps and weekly case volume)
                             ap.ProductActivity.Where_do_we_need_to_get_pricing__c = null ;
                             ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null ;
                             ap.ProductActivity.Competitive_Client__c = null ;
                             ap.ProductActivity.Is_operator_under_contract__c = null ;

                // testing/sample provided fields (except next steps and weekly case volume)
                ap.ProductActivity.sample_case_Option__c = null;
                ap.ProductActivity.When_do_you_expect_testing_to_conclude__c = null;

                // under review/no sample provided fields (except next steps and weekly case volume)
                ap.ProductActivity.Who_needs_to_review_product_at_Operator__c = null;

                //start || case 00357510 || Nancy Gara || 07-04-2025
                // } else if(salesInProgressPickVal == 'testing/sample provided') {
              } else if (salesInProgressPickVal == 'testing/under review') {
                //END || case 00357510 || Nancy Gara || 07-04-2025
                // pricing fields (except next steps and weekly case volume)
                ap.ProductActivity.Where_do_we_need_to_get_pricing__c = null;
                ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null;
                ap.ProductActivity.Competitive_Client__c = null;
                ap.ProductActivity.Is_operator_under_contract__c = null;

                             // operator would purchase if stocked at distributor fields (except next steps and weekly case volume)
                             // No fields to make empty
                             // under review/no sample provided fields (except next steps and weekly case volume)
                             ap.ProductActivity.Who_needs_to_review_product_at_Operator__c = null ;

                         } 
                         
                         // START | Himanshu Dave | S-692922 | 22/03/2022 | Update Reson 'Client Unable to Supply Product'
                         else if(salesInProgressPickVal == 'client unable to supply product') {
                             ap.ProductActivity.Who_needs_to_review_product_at_Operator__c = null ;
                             ap.ProductActivity.Where_do_we_need_to_get_pricing__c = null ;
                             ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null ;
                             ap.ProductActivity.Competitive_Client__c = null ;
                             ap.ProductActivity.Is_operator_under_contract__c = null ;
                         
                         }
                         // END | Himanshu Dave | S-692922 | 22/03/2022 | Update Reson 'Client Unable to Supply Product' 
                         
                         else if(salesInProgressPickVal == 'under review/no sample provided') {

                             // pricing fields (except next steps and weekly case volume)
                             ap.ProductActivity.Where_do_we_need_to_get_pricing__c = null ;
                             ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null ;
                             ap.ProductActivity.Competitive_Client__c = null ;
                             ap.ProductActivity.Is_operator_under_contract__c = null ;

                             // operator would purchase if stocked at distributor fields (except next steps and weekly case volume)
                             // No fields to make empty
                             // testing/sample provided fields (except next steps and weekly case volume)
                             ap.ProductActivity.sample_case_Option__c = null ;
                             ap.ProductActivity.When_do_you_expect_testing_to_conclude__c = null ;

                         }
                     }
                 } else if(OperatorType == 'Distributor') {
                     if(ap.ProductActivity.Not_Sold_Result_is_Final__c == true) {
                         //START -- UnCommented What_are_next_steps__c field  by Shreya | C-00283734 | 24/12/2020 |uncomm. after changing field type to Text Area [long]
                         ap.ProductActivity.What_are_next_steps__c = '' ;
                         //END -- UnCommented What_are_next_steps__c field  by Shreya | C-00283734 | 24/12/2020 |uncomm. after changing field type to Text Area [long]
                         ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null ;
                         ap.ProductActivity.Operator_Contract_Expiry_Date__c = null ;
                         ap.ProductActivity.Distributor_SIP_New_Item_feedback__c = '' ;
                         ap.ProductActivity.distributor_SIP_CCC_Feedback__c = '' ;
                         ap.ProductActivity.Distributor_Not_sold_Reasons__c = null ;
                         ap.ProductActivity.Distributer_SIP_New_Item__c = null ;
                         ap.ProductActivity.Estimated_Weekly_Sales_Volume__c = null ;
                         //ap.ProductActivity.Estimated_Weekly_SalesVolume__c = null ;                // Added by Esoof | S-707717 | 14/02/25
                         if(ap.ProductActivity.Distributor_Not_Sold_Product_Status__c == 'Competitive Client Conversion / Item(s) Conversion') {
                             // Empty New Iteam placement values
                             ap.ProductActivity.Distributor_final_New_Item_feedback__c = '' ;
                             ap.ProductActivity.Distributor_New_Item_Reasons_Final__c = null ;
                             ap.ProductActivity.Photo_taken__c = null ;
                             ap.ProductActivity.Specific_Issue__c = '' ;
                             ap.ProductActivity.Will_Client_pay_slotting_fee__c = null ;
                             ap.ProductActivity.Marketing_program_exist__c = null ;

                         } else if(ap.ProductActivity.Distributor_Not_Sold_Product_Status__c == 'New Item Placement') {
                             // Empty ccc values
                             ap.ProductActivity.Competitive_Client__c = null ;
                             ap.ProductActivity.distributor_final_CCC_Feedback__c = '' ;
                             ap.ProductActivity.Distributor_Not_sold_Reasons_final__c = null ;

                             // if does not contain "Pricing Needs Adjustment" then blank out some fields
                             if(ap.ProductActivity.Distributor_final_New_Item_feedback__c != null) {

                                 if(!ap.ProductActivity.Distributor_final_New_Item_feedback__c.containsIgnoreCase('Quality not acceptable:')) {
                                     ap.ProductActivity.Photo_taken__c = null ;
                                     ap.ProductActivity.Specific_Issue__c = '' ;
                                 }
                                 if(!ap.ProductActivity.Distributor_final_New_Item_feedback__c.containsIgnoreCase('Marketing Program unacceptable:')) {
                                     ap.ProductActivity.Will_Client_pay_slotting_fee__c = null ;
                                     ap.ProductActivity.Marketing_program_exist__c = null ;
                                 }
                             }
                         }
                     } else if(ap.ProductActivity.Sale_is_In_Progress__c == true) {
                         ap.ProductActivity.Distributor_final_New_Item_feedback__c = '' ;
                         ap.ProductActivity.Photo_taken__c = null ;
                         ap.ProductActivity.Specific_Issue__c = '' ;
                         ap.ProductActivity.Will_Client_pay_slotting_fee__c = null ;
                         ap.ProductActivity.Marketing_program_exist__c = null ;
                         ap.ProductActivity.distributor_final_CCC_Feedback__c = '' ;
                         ap.ProductActivity.Distributor_Not_sold_Reasons_final__c = null ;
                         ap.ProductActivity.Distributor_New_Item_Reasons_Final__c = null ;

                         if(ap.ProductActivity.Distributor_Not_Sold_Product_Status__c == 'Competitive Client Conversion / Item(s) Conversion') {
                             // Empty New Iteam placement values
                             ap.ProductActivity.Distributor_SIP_New_Item_feedback__c = '' ;
                             ap.ProductActivity.Distributer_SIP_New_Item__c = null ;
                             // if does not contain "Pricing Needs Adjustment" then blank out some fields
                             if(ap.ProductActivity.distributor_SIP_CCC_Feedback__c != null) {

                                 if(!ap.ProductActivity.distributor_SIP_CCC_Feedback__c.containsIgnoreCase('Pricing Needs Adjustment:')) {
                                     ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null ;
                                 }
                                 if(!ap.ProductActivity.distributor_SIP_CCC_Feedback__c.containsIgnoreCase('Conversion under review:')) {
                                     ap.ProductActivity.Operator_Contract_Expiry_Date__c = null ;
                                 }
                             }

                         } else if(ap.ProductActivity.Distributor_Not_Sold_Product_Status__c == 'New Item Placement') {
                             // Empty ccc values
                             ap.ProductActivity.Competitive_Client__c = null ;
                             ap.ProductActivity.distributor_SIP_CCC_Feedback__c = '' ;
                             ap.ProductActivity.Distributor_Not_sold_Reasons__c = null ;
                             // if does not contain "Pricing Needs Adjustment" then blank out some fields
                             if(ap.ProductActivity.Distributor_SIP_New_Item_feedback__c != null) {

                                 if(!ap.ProductActivity.Distributor_SIP_New_Item_feedback__c.containsIgnoreCase('Pricing Needs Adjustment:')) {
                                     ap.ProductActivity.What_is_the_allowance_per_case_needed__c = null ;
                                 }
                                 if(!ap.ProductActivity.Distributor_SIP_New_Item_feedback__c.containsIgnoreCase('Product under review:')) {
                                     ap.ProductActivity.Operator_Contract_Expiry_Date__c = null ;
                                 }
                             }
                         }

                     }
                 }

          // End Jai gupta
        }
        /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - End ***/

        ProductActivityList.add(ap.ProductActivity);

             //Process the Sales Opportunities
             map<String,Boolean> SalesOpps = (map<String,Boolean>) JSON.deserialize(ap.AchievedNSO , map<String,Boolean>.class);

             for(String OppId : SalesOpps.keySet())
             {
                 /** Code Modified - Padmesh Soni (07/22/2016 Appirio Offshore) - S-413539 - Start **/
                 //Code commented
                 //LSLEVIN Case 119037 5.26.2015 Updated below to have CommittedOrder__c = (SalesOpps.get(OppId) == true ? ap.ProductSold.Id : null)
                 /**SalesOpportunity__c so = new SalesOpportunity__c(Id = OppId, Status__c = (SalesOpps.get(OppId) == true ? 'Achieved' : 'Active'), CommittedOrder__c = (SalesOpps.get(OppId) == true ? ap.ProductSold.Id : null));

                if(OpportunityMap.containsKey(OppId) && SalesOpps.get(OppId) == true )
                OpportunityMap.put(OppId,so);
                else if(!OpportunityMap.containsKey(OppId))
                OpportunityMap.put(OppId,so);
                **/

          //Assign initial value as blank
          String salesOppId = '';
          String prodActId = '';

          //Split by hyphen
          List<String> combination = OppId.split('-');

          //Get Sales Opportunity Id
          salesOppId = combination[0];

          //Check if Product Activity Id coming from page or not
          if (combination.size() > 1) {
            //populate string
            prodActId = combination[1];
          }

                 //Initialize instance
                 SalesOpportunity__c so = new SalesOpportunity__c(Id = salesOppId, Status__c = (SalesOpps.get(OppId) == true ? 'Achieved' : 'Active'),
                                                                  CommittedOrder__c = (SalesOpps.get(OppId) == true ? ap.ProductSold.Id : null),
                                                                  AchievedwithProductActivityID__c = (SalesOpps.get(OppId) == true && String.isNotBlank(prodActId)
                                                                                                      ? prodActId : null));
                 //Check for already contained key and true or not
                 if(OpportunityMap.containsKey(salesOppId) && SalesOpps.get(salesOppId) == true ) {

                     //populate map
                     OpportunityMap.put(salesOppId,so);
                 } else if(!OpportunityMap.containsKey(salesOppId)) {

                     //Populate map
                     OpportunityMap.put(salesOppId,so);
                 }
                 /** Code Modified - Padmesh Soni (07/22/2016 Appirio Offshore) - S-413539 - End **/
             }
         }
         // Start --- Code Added By parag bhatt for Case #00264933
         if(setOfproductActivityListForDeleting.size() > 0 ){
             List<CommittedOrder__c> lstCommOrder = [select id,Product_Activity__c,Product__c,SalesCall__c from CommittedOrder__c where Product_Activity__c IN :setOfproductActivityListForDeleting];
             if(lstCommOrder.size() > 0){
                 delete lstCommOrder;
             }
         }
         // END ---- Code Added By parag bhatt for Case #00264933
         //upsert ProductActivityList; //Commented by Shobhit Pant for Case 00223065 05/08/2018
         // Added by Lalit for S-334717 START
         if(!isClosingMeeting){  //Added by Shobhit Pant For Case 00227972 05/21/2018
             try { // This line is added by Jyotirmaya Rath case- 00132737 "2nd sep 2015 "
                 if(CommittedOrderString != null && CommittedOrderString != ''){
                     System.debug('Committed Order String: ' + CommittedOrderString);
                     List<String> committedOrderRow = CommittedOrderString.split('~~@~~');
                     List<CommittedOrder__c> lineItemsToUpsert = new List<CommittedOrder__c>();
                     list<String> deleteOrderIds = new list<String>();
                     updatedOrder = new list<CommittedOrder__c>();
                     createdOrder = new list<CommittedOrder__c>();
                     for(String singleOrderRow : committedOrderRow){
                         System.debug('------- singleOrderRow'+singleOrderRow);
                         //commOrderId+'~' + distributorId + '~' + qty + '~' + uom;
                         List<String> committedOrderString = singleOrderRow.split('~');
                         /*if((commitedOrderString[0] == 'true' || commitedOrderString[1] == '0') && commitedOrderString[2].substring(0,3)=='a0B')
                        deleteOrderIds.add(commitedOrderString[2]);
                        else if(commitedOrderString.size()> 3 && commitedOrderString[2].length() > 3 && commitedOrderString[2].substring(0,3)=='a0B')
                        updateCommittedOrder(commitedOrderString[1],commitedOrderString[2],commitedOrderString[3],commitedOrderString[4]);
                        else{
                        System.debug('---- commitedOrderString[1]'+commitedOrderString[3]+'*** commitedOrderString[2]--'+commitedOrderString[2]+'^^'+commitedOrderString[3]);
                        createCommittedOrder(commitedOrderString[1],commitedOrderString[3],commitedOrderString[4]);
                        }*/
              //

                         if(committedOrderString[0] != ''){
                             //Updated by Shubham for Story S-426804
                             //START- Modified by Sajal for S-569846
                             System.debug('Át 1974');
                             // START | Tushar Soni | 14/11/2022 | S-698550 | Added index 12 and 13 for didClientAssistValue and clientAssistTypeValue
                             lineItemsToUpsert.add(upsertCommittedOrder(committedOrderString[0], committedOrderString[1], committedOrderString[2], committedOrderString[3],committedOrderString[4],committedOrderString[5],committedOrderString[6],committedOrderString[7],committedOrderString[8],committedOrderString[9],committedOrderString[10],committedOrderString[11],committedOrderString[12],committedOrderString[13]));  // S-343194 - Hemlata - added 4th-7th attribs //Modified by vinit for S-596102
                             // END | Tushar Soni | 14/11/2022 | S-698550 | Added index 12 and 13 for didClientAssistValue and clientAssistTypeValue
                         }
                         else{
                             //Updated by Shubham for Story S-426804
                             System.debug('At 1979');
                             // START | Tushar Soni | 14/11/2022 | S-698550 | Added index 12 and 13 for didClientAssistValue and clientAssistTypeValue
                             lineItemsToUpsert.add(upsertCommittedOrder(committedOrderString[1], committedOrderString[2], committedOrderString[3],committedOrderString[4],committedOrderString[5], committedOrderString[6],committedOrderString[7],committedOrderString[8],committedOrderString[9],committedOrderString[10],committedOrderString[11],committedOrderString[12],committedOrderString[13]));  // S-343194 - Hemlata - added 4th-7th attribs //Modified by vinit for S-596102
                             // END | Tushar Soni | 14/11/2022 | S-698550 | Added index 12 and 13 for didClientAssistValue and clientAssistTypeValue
                             System.debug('lineItemsToUpsert at 1981'+lineItemsToUpsert);
                         }
                         //ENd for S-569846


                     }
                     upsert lineItemsToUpsert;
                     System.debug('5555@@@@@');
                     //if(deleteOrderIds.size() > 0){
                     delete [select Id from CommittedOrder__c where Product__c = :ProductId AND SalesCall__c = :SalesCall.Id AND Id NOT IN :lineItemsToUpsert ];
                     //}

            /*System.debug('--- updatedOrder'+updatedOrder);
                    if(updatedOrder.size() > 0){
                    update updatedOrder;
                    }
                    System.debug('--- createdOrder'+createdOrder);
                    if(createdOrder.size() > 0){
                    insert createdOrder;
                    }*/

                     List<ProductActivity__c> relatedProductActivities = new List<ProductActivity__c>([Select Id, Product__c FROM ProductActivity__c WHERE Activity__c = :SalesCall.Id AND Product__c = :ProductId]);
                     if(relatedProductActivities.size() > 0){
                         ProductActivity__c pUpdate = new ProductActivity__c();

              /* Sale_is_In_Progress__c = null
                        , Sale_Progress_Follow_up_Call__c = null
                        , Not_Sold_Result_is_Final__c = null
                        , OperatorFeedbackReasons__c = null
                        , OperatorFeedback__c = null*/

                         for(CommittedOrder__c c : lineItemsToUpsert){
                             c.Product_Activity__c = relatedProductActivities[0].Id;
                         }
                         upsert lineItemsToUpsert;
                     }
                     else{
                         //create productid
                         ProductActivity__c potentialProductActivity = new ProductActivity__c(Product__c = ProductId, Activity__c = SalesCall.Id, ProductStatus__c = 'Sold');
                         insert potentialProductActivity;
                         for(CommittedOrder__c c : lineItemsToUpsert){
                             c.Product_Activity__c = potentialProductActivity.Id;
                         }
                         upsert lineItemsToUpsert;
                     }
                     //RPraveen - Start - S-708188-11/11/2025
                     Boolean isProductExist =  false;
                     for(AssignedProduct ap: AssignedProductList){
                         if(ap.Product.Id == ProductId){
                             isProductExist = true;
                             break;
                         }
                     }
                      List<ProductActivity__c> prdActLists = new List<ProductActivity__c>();
                     If(!isProductExist){
                         Product__c p = [SELECT Manufacturer__r.Name, Name, ManufacturingNumber__c, GlobalClassification__c, ProductFamily__r.Name,
                                ProductCategory__r.Name, ProductDescription__c, SKU__c, GTIN__c, Packed__c, ProductInfoURL__c,
                                DOT_Number__c, DOT_In_Stock__c, DOT_Availability__c 
                                FROM Product__c WHERE Id = :ProductId];
                         AssignedProduct ap = new AssignedProduct(p, SalesCall);
                          prdActLists.add(ap.ProductActivity); 
                         AssignedProductList.add(ap);
                     }
                     if(prdActLists.size()>0){
                         upsert prdActLists;
                     }
                      // //RPraveen - End - S-708188-11/11/2025
                     /* Code Added by Shobhit Pant for Case 00223065 05/08/2018 START */
                     //updating AssignedProductList with recently inserted CO IDs
                     for(AssignedProduct ap: AssignedProductList){
                         if(ap.ProductActivity.Id == lineItemsToUpsert.get(0).Product_Activity__c){
                             ap.ProductActivity.CommittedOrder__c = lineItemsToUpsert.get(0).Id;


                         }
                     }
                     /* Code Added by Shobhit Pant for Case 00223065 05/08/2018 END */
                     /*
                    system.debug('====ProductId===='+ ProductId );
                    List<ProductActivity__c> productActivities = new List<ProductActivity__c>();

                    for(CommittedOrder__c c : createdOrder){
                    ProductActivity__c pActivity = new ProductActivity__c();
                    pActivity.Product__c = ProductId;
                    pActivity.Activity__c = SalesCall.Id ;
                    pActivity.CommittedOrder__c = c.Id;
                    pActivity.ProductStatus__c = 'Sold';
                    productActivities.Add(pActivity);
                    }
                    if(!productActivities.isEmpty())
                    insert productActivities;
                    */
            // Added by Lalit for S-334717 END
            /*       //Lalit START
                    List<CommittedOrder__c> coLstToDelete = new List<CommittedOrder__c>();
                    System.debug('Lalit======distributorWrap'+cowrapper);
                    for(DistrubutorClass distributorWrap : cowrapper){
                    if(distributorWrap.isSelected)
                    system.debug('*******aa gaya*****'+distributorWrap);        // test
                    if(distributorWrap.isSelected && distributorWrap.co.id !=null){
                    coLstToDelete.add(distributorWrap.co);
                    }
                    }
                    if(coLstToDelete.size() > 0){
                    delete coLstToDelete;
                    }
                    //LALIT END*/
// Jyotirmaya Rath COde Started  case -00132737  "2nd sep 2015 "
                 }
             }Catch(exception e) { // Jyotirmaya Rath
                 system.debug(' Exception Found: [' + e.getLineNumber() + '] '+e.getMessage());
             }
         } //end of isClosingMeeting if closure - added by Shobhit Pant For Case 00227972 05/21/2018
         isClosingMeeting = false; //Added by Shobhit Pant For Case 00227972 05/21/2018
         //  Jyotirmaya Rath COde Ended
         for(String OppId : OpportunityMap.keySet())
         {
             OpportunityList.add(OpportunityMap.get(OppId));
         }
         //start Modfied, commented by veera for case 00345062 | 20-02-2023
         if(ProductActivityList.size()>0) {
            // START Praveen + NCarson 11/13/25 - only upsert records with a valid committed order - S-708188
            List<ProductActivity__c> recordsWithACommittedOrder = new List<ProductActivity__c>();
            for (ProductActivity__c pa : ProductActivityList) {
              if (pa.ProductStatus__c != 'Sold' || pa.CommittedOrder__c != null) {
                recordsWithACommittedOrder.add(pa);
              }
            }
            Database.UpsertResult [] cr = Database.upsert(recordsWithACommittedOrder, false); // ProductActivityList
            // END Praveen + NCarson 11/13/25 - only upsert records with a valid committed order - S-708188
             for(Database.upsertResult result : cr){
                if(!result.isSuccess()){
                    system.debug('error occured during save'+result.getId() ); 
                 }
             }
           //upsert ProductActivityList; //Added by Shobhit Pant for Case 00223065 05/08/2018
        }
       //end Modfied,commented by veera for case 00345062 | 20-02-2023
         upsert OpportunityList;
      
      // NCarson S-707880 6/17/25 - call updateSalesOpp method on save
      updateSalesOpp();
      
      //upsert BusinessObjectivePlannedActivityList;


         set<Id> sosCreated = new set<Id>();
         set<Id> originalSalesOppIds = (set<Id>)initialObjectMap.get('originalSalesOppIds');
         for(SalesOpportunity__c so : OpportunityList)
         {
             if(!originalSalesOppIds.contains(so.Id))
             {
                 sosCreated.add(so.Id);
             }
         }
         initialObjectMap.put('sosCreated', sosCreated);
         system.debug('---------DistributorId---------'+DistributorId);
         if(string.isNotEmpty(DistributorId)) { SalesCall.Distributor__c = DistributorId; }
         else { SalesCall.Distributor__c = null; }

      /* START Vinit S-601948 3.10.2019
       on behalf changes */
      if (String.isNotBlank(CDistributorId)) {
        SalesCall.Distributor_2__c = CDistributorId;
      } else {
        SalesCall.Distributor_2__c = null;
      }
      // END Vinit S-601948 3.10.2019
      //START | Changes Added by Gulab | S-703023 | 17-04-2023
      system.debug('>>>>>>>SalesCall ' + SalesCall);
      // if(SalesCall.Meeting_Date__c!=null){
      //     DateTime myDate = DateTime.newinstance(SalesCall.Meeting_Date__c.year(), SalesCall.Meeting_Date__c.month(), SalesCall.Meeting_Date__c.day());  // commented by mahesh | c-00346440 | 03-05-2023
      //     SalesCall.StartDate__c = myDate;
      // }
      //END | Changes Added by Gulab | S-703023 | 17-04-2023
      SalesCall.Updated__c = true;
      if (SalesCall.Status__c == 'Pending') {
        SalesCall.Status__c = 'Planned';
      }
      // Start | Added by Rahul T | S-703689 | 14/06/23

      // START Swastika + NCarson C-00357344 4/3/25 - put
      // date logic in try / catch, as this fragile and failing
      try {
        Integer startMonth = SalesCall.StartDateNor__c?.month();
        Integer startYear = SalesCall.StartDateNor__c?.year();
        Integer startDay = SalesCall.StartDateNor__c?.Day();

        Integer endMonth = SalesCall.EndDate__c?.month();
        Integer endYear = SalesCall.EndDate__c?.year();
        Integer endDay = SalesCall.EndDate__c?.Day();
      
        // START Swastika + NCarson 6/30/25 C-00358027 - add comma after yearfor correct format
        string newStartDate =
          startMonth +
          '/' +
          startDay +
          '/' +
          startYear + ', ' +
          ' ' +
          startTime;
          
        string newEndDate =
          endMonth +
          '/' +
          endDay +
          '/' +
          endYear + ', ' +
          ' ' +
          endTime;
        // END Swastika + NCarson C-00358027 - add comma for correct format
  
        // START C_00349434 Utkarsh + NCarson 1/30/24 - set end date to one hour after start date
        DateTime originalStartDate = salesCall.StartDate__c;
        salesCall.StartDate__c = DateTime.parse(newStartDate);
        salesCall.EndDate__c = DateTime.parse(newEndDate);
        if (originalStartDate != DateTime.parse(newStartDate)) {
          // end date should have same date as start date (ie, a meeting starts and ends on the same day) but will have its own time
          // START Swastika + NCarson 6/30/25 C-00358027 - add comma after yearfor correct format
          String correctEndDate =
            startMonth +
            '/' +
            startDay +
            '/' +
            startYear + ', ' +
            ' ' +
            endTime;
          // End Swastika + NCarson 6/30/25 C-00358027 - add comma after yearfor correct format
          salesCall.EndDate__c = DateTime.parse(correctEndDate); 
          // salesCall.EndDate__c = salesCall.StartDate__c.addHours(1);
        } // END C_00349434 Utkarsh + NCarson 1/30/24
      } catch (Exception ex) {
        System.debug('Date Exception : ' + ex.getLineNumber());
        System.debug(ex.getMessage());
      } // END Swastika + NCarson C-00357344 4/3/25
      /** Start | wipro | S-707000 | July 18,2024 | Operator update*/
      if (salesCall.Operator__c == null) {
        salesCall.Operator__c = OperatorId;
      }
      /** End | wipro | S-707000 | July 18,2024 | Operator update*/
      system.debug('@#@salesCall.StartDate__c' + salesCall.StartDate__c);
      // End | Added by Rahul T | S-703689 | 14/06/23
      upsert SalesCall;
      //update the meet now details for this sales call to reflect the changes made
      UpdateMeetNowDetails(
        'Meeting Saved ' +
        (SaveAction == null ? '' : ' to go to : ' + SaveAction)
      );
         
         // START case 00357344 || 3/17/25 - reset Sales Call and Products for UI || Swastika + NCarson
         SalesCall = [SELECT Id,EndDate__c,StartDateToDate__c, Meeting_type__c,Employee__c,Market__c,Description__c, StartDate__c, Status__c, MeetingStartedTime__c,
                                               Contact__c, Contact__r.Name, Contact__r.Id, Distributor__c, Distributor__r.Id,
                                               /* START Vinit S-601948 3.10.2019 on behalf changes */
                                               Distributor_2__r.Name,
                                               Distributor_2__r.Id,
                                            //Start- Add by Mayank| S-707888 | 25 April 2025  || fetch a new field Assisted_Employee__c in query
                                               Assisted_Employee__c,
                                                //end- Add by Mayank| S-707888 | 25 April 2025  || fetch a new field Assisted_Employee__c in query
                                               Contacts__c, // NCarson 3/2/25 S-707646 - add Contacts to query
                                               Distributor_2__r.Market__c,
                                               Distributor_2_NA__c,
                                               // END Vinit S-601948 3.10.2019
                                               Distributor__r.Name,
                                               //START - Added by ASL   Oct 10th, 2022  698051 - Adding the Operator__r.OperatorSubSegment__c AND Operator__r.Cool_School_ID__c fields to the query.
                                               Operator__r.OperatorSubSegment__c,Operator__r.Cool_School_ID_del__c,
                                               //END - Added by ASL     Oct 10th, 2022  698051 - Adding the Operator__r.OperatorSubSegment__c AND Operator__r.Cool_School_ID__c fields to the query.
                                               Operator__r.KI_ID__c,// Added by Gulab | [S-684595] | [03-06-2021]
                                               Operator__c, Operator__r.Name, Operator__r.Id, Operator__r.LargeLeverageOperator__c, Operator__r.Market__r.Id,Operator__r.Type, /*Added for S-554835 */
                                               MeetingNowDetailedOperations__c, DistributorNA__c/*, OperatorFeedbackReasons__c, OperatorFeedback__c*/
                                               , Operator__r.Market__c //Code modified - Padmesh Soni (02/18/2017 Appirio Offshore) - S-467938

                                               // Code changes done by Ravi Jain for story S-537453
                                               // Start - Ravi Jain - S-537453 - 12th Jan, 2017 - Added the field in the query
                                               ,Activity_Number__c,Unplanned__c ,RSC_Category__c,RSC_SubCategory__c,Requested__c //Modified by Vinit for S-645707 [21-Nov-2019]
                                               // End - Ravi Jain - S-537453 - 12th Jan, 2017
                                               ,App_Notes__c // Added By Vinit for S-641508 [11-Sep-2019] 
                                               //,Meeting_Date__c //Added by Gulab | S-703023 | 17-04-2023   (commented by mahesh | c-00346440 | 03-05-2023)
                                               ,StartDateNor__c
                                               // START NCarson 7/22/25 S-707880 - add ExpandedProductStatus__c field to query
                                               ,(SELECT Id, tf_ProductCategory__c, tf_ProductClientName__c, Estimated_Weekly_Sales_Volume__c, ProductStatus__c, Was_an_Oil_Evaluation_Conducted__c, ExpandedProductStatus__c FROM Product_Activities__r
                                               // END NCarson 7/22/25 - add ExpandedProductStatus__c field to query
                                               )
                                               FROM Activity__c WHERE Id = :SalesCallId];
            // END case 00357344 || Swastika + NCarson 3/17/25 
     }
     catch (Exception e)
     {
         SaveMeetExcepMsg = '[' + e.getLineNumber() + '] ' + e.getMessage();//Added by Lalit for S-334717
         System.debug('Lalit===SaveMeetExcepMsg'+SaveMeetExcepMsg);
         //LogError(e);//Commented by Lalit for S-334717
     }
    }
    // Added by Lalit for S-334717 START

  //commOrderId+'~' + distributorId + '~' + qty + '~' + uom;
  //private void updateCommittedOrder(String quantity,String orderId,String unit,String distiName){
  /*private CommittedOrder__c updateCommittedOrder(String orderId, String distId, String quantity,String unit){
        System.debug('--Lalitquantity'+quantity+'Orderid'+orderId+'unit'+unit+'distId'+distId);
        return new CommittedOrder__c(Status__c = 'Active', SalesCall__c=SalesCall.Id,Id =orderId,Quantity__c=Decimal.valueOf(quantity),MeasurementUnits__c=unit,Distributor__c=distId,CompetitorInformation__c=CompetitorInfo, Feedback__c=FeedbackElaboration);

        }
        private CommittedOrder__c createCommittedOrder(String quantity, String unit, String distId){
        //private void createCommittedOrder(String quantity,String unit,String distiName){
        System.debug('-- quantity'+quantity+'== unit'+unit+'--distId'+distId);
        return new CommittedOrder__c(Status__c = 'Active', Operator__c = SalesCall.Operator__c, SalesCall__c=SalesCall.Id,Quantity__c=Decimal.valueOf(quantity),MeasurementUnits__c=unit,Distributor__c=distId, Product__c = ProductId,ExpectedOrder__c=date.parse(ExpectedOrderDate), CompetitorInformation__c=CompetitorInfo, Feedback__c=FeedbackElaboration);
        }*/
    //Updated by Shubham for Story S-426804
    private CommittedOrder__c upsertCommittedOrder(String orderId, String distId, String quantity,String unit, String annualCasevolumn, String StartDate, String EndDate,String FeedbackType, String SaleType, String bid, String newRetainBusiness, String exacteffective, String didClientAssistValue, String clientAssistTypeValue){ // Modified by vinit for S-596102 //Modified by Sajal for S-569846 // Tushar Soni | 14/11/2022 | S-698550 | Added didClientAssistValue and clientAssistTypeValue parameters
        // START S-343194 - Hemlata - added annualCase_volumn and StartDate, End date, FeedbackType
        System.debug('Line 2130');
        Decimal annualCase_volumn = (annualCasevolumn != null && annualCasevolumn.trim() != '' && annualCasevolumn.trim() != 'undefined') ? decimal.valueOf(annualCasevolumn) : 0;
        Date expectedStartDate = (StartDate != null && StartDate.trim() != '' && StartDate.trim() != 'undefined') ? Date.parse(StartDate) : null;
        Date expectedEndDate = (EndDate != null && EndDate.trim() != '' && EndDate.trim() != 'undefined') ? Date.parse(EndDate) : null;
        //System.assert(false,'2127::'+ mySelectedOption);//sajal
        System.debug('6666@@@@@');
        // Modified by vinit for S-596102 start
        System.debug('newRetainBusiness '+newRetainBusiness);
        System.debug('myselectedoption'+mySelectedOption);
        System.debug('isCustom'+isCustom);
        System.debug('exacteffective '+exacteffective);
        CommittedOrder__c comOrder ;//Code Added by Parag Bhatt for case #00256477
        //system.assert(false,commitOrder.Effective_End_Date_Selection__c);
        if (String.isBlank(newRetainBusiness) || 'undefined'.equalsIgnoreCase(newRetainBusiness) || String.isBlank(exacteffective) || 'undefined'.equalsIgnoreCase(exacteffective) || 'null'.equalsIgnoreCase(exacteffective)) {//Modified by Sajal S-569846
            isCustom = true;
            // START 5/7/25 NCarson C-00357707 null value is okay - blank string ('') is not
            distId = distId == '' ? null : distId;
            orderId = orderId == '' ? null : orderId;
            // END NCarson C-00357707 5/7/25

            comOrder =  new CommittedOrder__c( Id = orderId
                                              , Status__c = 'Active'
                                              , Operator__c = SalesCall.Operator__c
                                              , SalesCall__c=SalesCall.Id
                                              , Quantity_Entered__c=Decimal.valueOf(quantity)
                                              , MeasurementUnits__c=unit
                                              , Distributor__c=distId
                                              , Product__c = ProductId
                                              , ExpectedOrder__c=expectedStartDate
                                              //START--->Code Commented by Parag Bhatt for case #00256477
                                              /*
                                                //START- Added by Sajal for S-569846
                                                , Effective_End_Date_Selection__c= null
                                           /END for S-569846*/
                                              //END-->Code Commented by Parag Bhatt for case #00256477
                                              , CompetitorInformation__c=CompetitorInfo
                                              //Start | case 00357110 | Swastika | change field type
                                              , Feedback__c=FeedbackElaboration
                                              //End | case 00357110 | Swastika | change field type
                                              , Annual_Case_Volume__c=annualCase_volumn
                                              //CSCHEBLER 00203125 modified line below to remove end date from renewing orders
                                              //START- Modified by Sajal for S-569846
                                              , Expected_Order_End_Date__c =  FeedbackType !='Specific Menu Placement / LTO' ? null : expectedEndDate
                                              //END for S-569846
                                              //Added by Shubham for Story S-426804 #Start
                                              , Sale_Type__c = SaleType
                                              , Based_on_Bid__c = bid == 'true' ? true : false
                                              //Added by Shubham for Story S-426804 #End
                                              , FeedbackType__c=FeedbackType,
                          // Added Gaurav S-708235
                                              New_or_Retained_Business__c= 'undefined'.equalsIgnoreCase(newRetainBusiness) ?'':newRetainBusiness);
        } else {
            comOrder =  new CommittedOrder__c( Id = orderId
                                              , Status__c = 'Active'
                                              , Operator__c = SalesCall.Operator__c
                                              , SalesCall__c=SalesCall.Id
                                              , Quantity_Entered__c=Decimal.valueOf(quantity)
                                              , MeasurementUnits__c=unit
                                              , Distributor__c=distId
                                              , Product__c = ProductId
                                              , ExpectedOrder__c=expectedStartDate
                                              //START-->Code Commented by Parag Bhatt for case #00256477
                                              /*
                                                //START- Added by Sajal for S-569846
                                                , Effective_End_Date_Selection__c= exacteffective
                                                //END for S-569846
                                                */
                                              //END-->Code Commented by Parag Bhatt for case #00256477
                                              , CompetitorInformation__c=CompetitorInfo
                                              //Start | case 00357110 | Swastika | change field type
                                              , Feedback__c=FeedbackElaboration
                                              //End | case 00357110 | Swastika | change field type
                                              , Annual_Case_Volume__c=annualCase_volumn
                                              //CSCHEBLER 00203125 modified line below to remove end date from renewing orders
                                              //START- Modified by Sajal for S-569846
                                              , Expected_Order_End_Date__c =  FeedbackType !='Specific Menu Placement / LTO' ? null : expectedEndDate
                                              //END for S-569846

                                              , FeedbackType__c=FeedbackType,
                                              New_or_Retained_Business__c= newRetainBusiness);
        }
        // Modified by vinit for S-596102 end
        // END  S-343194

        comOrder.Effective_End_Date_Selection__c= exacteffective;//Code Added by Parag Bhatt for case #00256477
        // START | Tushar Soni | 14/11/2022 | S-698550 | Insert didClientAssistValue and clientAssistTypeValue values
        comOrder.Did_Client_Assist_with_Sale__c = didClientAssistValue;
        if(clientAssistTypeValue != 'null') {
            comOrder.Client_Assist_Type__c = clientAssistTypeValue.replace(',',';');
        }
        // END | Tushar Soni | 14/11/2022 | S-698550 | Insert didClientAssistValue and clientAssistTypeValue values
        return comOrder;
    }
    //Updated by Shubham for Story S-426804 #Start
    //START- Modified by Sajal for S-569846
    @TestVisible
    private CommittedOrder__c upsertCommittedOrder(String distId, String quantity,String unit,String annualCasevolumn, String StartDate, String EndDate,String FeedbackType, String SaleType, String bid, String newRetainBusiness, String exacteffective, String didClientAssistValue, String clientAssistTypeValue){ // Modified by vinit for S-596102 // Tushar Soni | 14/11/2022 | S-698550 | Added didClientAssistValue and clientAssistTypeValue parameters
        return upsertCommittedOrder(null,  distId,  quantity, unit,annualCasevolumn,StartDate, EndDate,FeedbackType, SaleType, bid, newRetainBusiness, exacteffective, didClientAssistValue, clientAssistTypeValue); // S-343194 - Hemlata - added annualCase_volumn,StartDate, EndDate,FeedbackType attribs // Modified by vinit for S-596102 // Tushar Soni | 14/11/2022 | S-698550 | Added didClientAssistValue and clientAssistTypeValue parameters
    }
    //END for S-569846
    //Updated by Shubham for Story S-426804 #End

    // Added by Lalit for S-334717 END
    // Start - Jai Gupta - S-339871 - Clone child records - Generic methods fetched from an asset
    /************* GENERIC METHOD: Query and return Map of sObjects *****************/
    @TestVisible
    private Map<string,sObject> getSObjectMap(String objectApiName, String referenceField, List<String> referenceFieldValues){
        String query = 'SELECT ' + String.Join(getAccessibleFields(objectApiName),',') + ' FROM ' + objectApiName +  ' WHERE ' + referenceField + ' IN :referenceFieldValues ';
        List<sObject> listSobject = Database.query(query);
        Map<string,sObject> mapSObject = new Map<string,sObject>();
        mapSObject.putAll(listSobject);
        return mapSObject;
    }

    /************* GENERIC METHOD: fetch accessible fields for that object *****************/
    public Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
    public List<String> getAccessibleFields(String objectApiName){
        List<String> lstFields = new List<String>();
        Map<String, Schema.SObjectField> field_map = globalDescribe.get(objectApiName).getDescribe().getSObjectType().getDescribe().fields.getMap();
        for(Schema.SObjectField sObject_Field : field_map.values()){
            Schema.DescribeFieldResult field = sObject_Field.getDescribe();
            if(field.isAccessible()){
                lstFields.add(field.getName());
            }
        }
        return lstFields;
    }

    /************* GENERIC METHOD: to clone map of provided records and keep track of their relationship with old records which can be used further******************/
    public Map<string,sObject> cloneSelectedRecords(Map<string,sObject> oldMap,boolean isInsert) {
        Map<String,sobject> mapCloneObject = new Map<String,sobject>();
        for(sObject sobj : oldMap.values()) {
            mapCloneObject.put(sobj.ID,sObj.clone(false,false));
        }
        if(isInsert && mapCloneObject.values().size() > 0) {
            insert mapCloneObject.values();
        }
        return mapCloneObject ;
    }
    // End - Jai Gupta - S-339871 - Clone child records

  //rmarquardt start - S-423778 - 8/3/2016
  public void checkRequiredFields() {
    if (SalesCall.Meeting_type__c == null || SalesCall.Meeting_type__c == '') {
      SalesCall.addError('Please Indicate Meeting Type.');
      //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
      //errorsFound = true;
      err = err + 'Please Indicate Meeting Type.' + ' \r\n';
      system.debug('crf11');
      //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End
    }
  }

    public void checkProductStatus(){
        //ProductStatus__c check
        //Modified by Aditya Tiwari for S-554835;Added fields in query
        //List<ProductActivity__c> paList = [select id, Sale_Progress_Follow_up_Call__c, Sale_is_In_Progress__c, OperatorFeedbackReasons__c, ProductStatus__c, OperatorFeedback__c, PotentialSalesVolume__c, CasesWeekUsage__c from ProductActivity__c WHERE Activity__r.Id = :SalesCall.Id];
        List<ProductActivity__c> paList = [select id, Sale_Progress_Follow_up_Call__c,Reasons_unsold__c , Sale_is_In_Progress__c, OperatorFeedbackReasons__c,Estimated_Weekly_Sales_Volume__c,Not_Sold_Price__c, ProductStatus__c, OperatorFeedback__c, PotentialSalesVolume__c, CasesWeekUsage__c from ProductActivity__c WHERE Activity__r.Id = :SalesCall.Id];
        List<ProductActivity__c> paListSold = new List<ProductActivity__c>();
        List<CommittedOrder__c> committedOrders = [select id, Product_Activity__c, CompetitorInformation__c, Quantity_Entered__c from CommittedOrder__c where Product_Activity__c in :paList];
        System.debug('9999@@@@');
        Set<Id> paWithCoSet = new Set<Id>();
        for(CommittedOrder__c co : committedOrders){
            paWithCoSet.add(co.Product_Activity__c);
        }

    // START AMILLER 00191779 3.21.2017
    System.debug('#### paList: ' + paList);
    System.debug('#### committedOrders: ' + committedOrders);
    System.debug('#### paWithCoSet: ' + paWithCoSet);
    // END AMILLER 00191779 3.21.2017

        for (ProductActivity__c pa : paList){
            //All products required fields
            if(pa.ProductStatus__c == null || pa.ProductStatus__c == ''){
                //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
                //SalesCall.addError('All products must have a status selection.');
                //errorsFound = true;
                err+= 'All products must have a status selection.'+'\r\n';
                //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End
            }//Require Operator Feedback field on all Statuses except 'Sold'
            if((pa.OperatorFeedback__c == null || pa.OperatorFeedback__c == '') && pa.ProductStatus__c != 'Sold' && pa.ProductStatus__c != 'Not Sold'){
                //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
                //SalesCall.addError('Operator Feedback is required.');
                //errorsFound = true;
                err+='Operator Feedback is required.'+'<br>';
                //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End
            }
            //'Not Sold' products required fields
            if(pa.ProductStatus__c == 'Not Sold'){
                if(pa.OperatorFeedbackReasons__c == null || pa.OperatorFeedbackReasons__c == ''){
                    //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
                    //SalesCall.addError('Products with \'Not Sold\' status must contain \'Reasons Unsold\'. ');
                    //errorsFound = true;
                    //Commented for testing
                    //err+='Products with \'Not Sold\' status must contain \'Reasons Unsold\' '+'<br>';
                    //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End
                }
                if(pa.PotentialSalesVolume__c == null){
                    //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
                    //SalesCall.addError('Products with \'Not Sold\' status must contain \'Potential Sales Volume\'.');
                    //errorsFound = true;
                    err+='Products with \'Not Sold\' status must contain \'Potential Sales Volume\'. '+'<br>';
                    //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End
                }
                if(pa.Sale_is_In_Progress__c == true){
                    if(pa.Sale_Progress_Follow_up_Call__c == null || pa.Sale_Progress_Follow_up_Call__c == ''){
                        //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
                        //SalesCall.addError('Sales progress follow up call is required.');
                        err+='Sales progress follow up call is required. '+'<br>';
                        //errorsFound = true;
                        //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End
                    }
                }
            }
            //'Using' products required fields
            if(pa.ProductStatus__c == 'Using'){
                if(pa.CasesWeekUsage__c == null){
                    //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
                    //SalesCall.addError('Cases/Week Usage is required.');
                    // NCarson 12/2/25 C-00358814 - case/week usage is now readonly for 'Using' product status, so not required
                    // err+='Cases/Week Usage is required. '+'<br>';
                    //errorsFound = true;
                    //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End
                }
            }
            //'Sold' products required fields
            if(pa.ProductStatus__c == 'Sold'){

                // START AMILLER 00191779 3.21.2017
                System.debug('#### paWithCoSet: ' + paWithCoSet);
                System.debug('#### pa.id: ' + pa.id);
                // END AMILLER 00191779 3.21.2017

                //if an order is associated
                if(paWithCoSet.contains(pa.id)){
                    //check for quantity
                    for(CommittedOrder__c co2 : committedOrders){
                        if(co2.Product_Activity__c == pa.Id){
                            if(co2.Quantity_Entered__c == null || co2.Quantity_Entered__c <= 0){
                                //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
                                //SalesCall.addError('Quantity must be greater than 0 for Sold Orders.');
                                err+='Quantity must be greater than 0 for Sold Orders. '+'<br>';
                                //errorsFound = true;
                                //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End
                            }
                        }
                    }
                }
                //if an order is not associated
                else{
                    //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
                    //SalesCall.addError('Committed Order required for every \'Sold\' Product.');
                    err+='Committed Order required for every \'Sold\' Product. '+'<br>';
                    //errorsFound = true;
                    //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End
                }
            }
        }
        system.debug('crf22' + errorsFound);

    }
    //rmarquardt end - S-423778 - 8/3/2016

    /*close the meeting*/
    public Pagereference CloseMeeting()
    {
        //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
        err = '';
        //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 END
        errorsFound = false;
        system.debug('====>In Here');
        //rmarquardt start - S-423778 - 8/3/2016
        checkRequiredFields();
        checkProductStatus();
        //rmarquardt end - S-423778 - 8/3/2016
        system.debug('err:' + err);
        system.debug('errorsFound::1'+ errorsFound);
        //system.assertEquals(errorsFound,false,'testfail');
        //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 Start
        if(err != '')
        {
            errorsFound = True;
        }
        //Modified by Aditya Tiwari for Case  case 00189692 03/03/2017 End

        if(errorsFound == false){
            try
            {
                // Start - Jai Gupta - S-339871 - Aug 20,2015 - Fetch not sold products and create follow up
                system.debug(' :: notSoldPAIds :: '+notSoldPAIds);
                if(notSoldPAIds != '') {
                    // START | Himanshu Dave | S-693486 | 06/04/2022 | Added 120 days and 180 days values to map
                    Map<String,Integer> followupDaysMap = new Map<String,Integer>{'1 week' => 7,'2 weeks' => 14,'30 days' => 30, '60 days' => 60, '90 days' => 90, '120 days' => 120, '180 days' => 180};
                    // END | Himanshu Dave | S-693486 | 06/04/2022 | Added 120 days and 180 days values to map
                        List<string> productActivityIds = notSoldPAIds.split(separator);
                    set<string> noOfFollowUpCalls = new set<string>();
                    Map<string,Activity__c> followUpCallMap = new Map<string,Activity__c>();
                    List<ProductActivity__c> paList = new List<ProductActivity__c>([Select Id,Product__c,Sale_Progress_Follow_up_Call__c,Activity_Start_date__c, Activity_End_date__c from ProductActivity__c where Id in :productActivityIds and ProductStatus__c = 'Not Sold' and Sale_is_In_Progress__c = true]);//  Modified by Nishank for Story S-409424
                    Map<String,DateTime> StrDateTimeMap = new Map<String,DateTime>();

          /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - Start ***/
          //Map to hold End DateTime list with respect to Start Date
          Map<String, List<DateTime>> mapEndDatesWRTStartDate = new Map<String, List<DateTime>>();
          /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - End ***/


                    for(ProductActivity__c pa : paList) {
                        // Modifed below line by Nishank for Story S-408243
                        if(String.isNotBlank(pa.Sale_Progress_Follow_up_Call__c)  && pa.Sale_Progress_Follow_up_Call__c !='Plan My Appointment Now') {
                            noOfFollowUpCalls.add(pa.Sale_Progress_Follow_up_Call__c);
                        }
                        // Added by Nishank for Story S-408243
                        if(String.isNotBlank(pa.Sale_Progress_Follow_up_Call__c) && pa.Sale_Progress_Follow_up_Call__c =='Plan My Appointment Now') {
                            noOfFollowUpCalls.add(string.valueOfGmt(pa.Activity_Start_date__c));
                            StrDateTimeMap.put(string.valueOfGmt(pa.Activity_Start_date__c),pa.Activity_Start_date__c);

                            /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - Start ***/
                            if(mapEndDatesWRTStartDate.containsKey(String.valueOfGmt(pa.Activity_Start_date__c))) {

                                mapEndDatesWRTStartDate.get(String.valueOfGmt(pa.Activity_Start_date__c)).add(pa.Activity_End_date__c);
                            } else {

                                mapEndDatesWRTStartDate.put(String.valueOfGmt(pa.Activity_Start_date__c), new List<DateTime>{pa.Activity_End_date__c});
                            }
                            /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - End ***/
                        }
                        // End of change added by Nishank for Story S-408243

                    }

                    for(string str : noOfFollowUpCalls) {
                        Activity__c followUpCall = new Activity__c();
                        followUpCall.Follow_Up_Call__c = true ;
                        followUpCall.Updated__c = true ;
                        followUpCall.Requested__c = false ;
                        followUpCall.Operator__c = SalesCall.Operator__c ;
                        followUpCall.Distributor__c = SalesCall.Distributor__c ;
                        followUpCall.TypePL__c = 'Event';
                        followUpCall.SubType__c = 'Sales Call';
                        //Start | Updated by Rahul T | S-705755 | 20/11/23 | Changed from Pending to Planned
                        followUpCall.Status__c = 'Planned' ;
                        //End | updated by Rahul T | S-705755 | 20/11/23
                    
                        system.debug(SalesCall.Employee__c+ ' : SalesCall.Market__c : '+ SalesCall.Market__c);
                        followUpCall.Market__c = SalesCall.Operator__r.Market__r.Id ;
                        followUpCall.Employee__c = SalesCall.Employee__c ;

            /** Code modified - Padmesh Soni (06/02/2017 Appirio Offshore) - S-398862 - Start **/
            followUpCall.Preceding_Activity__c = SalesCall.Id;
            /** Code modified - Padmesh Soni (06/02/2017 Appirio Offshore) - S-398862 -  **/ // Removed CS78salesforce URL from already commented line by Esoof | S-708097 | 29/07/2025

            Integer dayCount = 0;
            if (followupDaysMap.containsKey(str)) {
              dayCount = followupDaysMap.get(str);
            }
            // Commented by Nishank for Story S-408243
            //else {
            //    continue ;
            //}
            // End of Comments by Nishank for Story S-408243
            DateTime dueDate = Datetime.now().addDays(dayCount);
            followUpCall.DueDate__c = dueDate;
            // Added by Nishank for Story S-408243
            if (!followupDaysMap.ContainsKey(str) && str != null) {
              followUpCall.DueDate__c = null;
              followUpCall.Status__c = 'Planned';
              followUpCall.StartDate__c = StrDateTimeMap.get(str);

                            /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - Start ***/
                            if(mapEndDatesWRTStartDate.containsKey(str) && mapEndDatesWRTStartDate.get(str).size() > 0) {

                                followUpCall.EndDate__c = mapEndDatesWRTStartDate.get(str)[0];
                                mapEndDatesWRTStartDate.get(str).remove(0);
                            }
                            /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - End ***/
                        }
                         //Start | Updated by Rahul T | S-705755 | 23/11/23
                        else{
                            
                            Map<String, Integer> intervalMap = new Map<String, Integer>{
                            '1 week' => 7,
                                '2 weeks' => 14,
                                '30 days' => 30,
                                '60 days' => 60,
                                '90 days' => 90,
                                '120 days' => 120,
                                '180 days' => 180
                                };
                                    
                                    for (String key : intervalMap.keySet()) {
                                        // NCarson C-00356090 - null check
                                        if (str != null && str.contains(key)) {
                                            followUpCall.DueDate__c = null;
                                            Time defaultTime = Time.newInstance(8, 0, 0, 0);
                                            followUpCall.StartDate__c = Datetime.newInstance(Date.today().addDays(intervalMap.get(key)), defaultTime);
                                            followUpCall.EndDate__c = followUpCall.StartDate__c.addHours(1);
                                            break;
                                        }
                                    }   
                            
                        }
                         //End | Updated by Rahul T | S-705755 | 20/11/23
                        System.debug('*********Follow Up Call'+followUpCall);
                        // End of changes added by Nishank for Story S-408243
                        followUpCallMap.put(str,followUpCall);
                        system.debug(' : followUpCallMap : '+ followUpCallMap);
                    }
                    /* START NCarson C-00358575 10/10/25 - remove insert, as it has been moved to trigger handler
                    if(followUpCallMap.size() > 0 && followUpCallMap.values().size() > 0) {
                        try {
                            insert followUpCallMap.values();
                            // Clone related sales document and attach with follow up calls
                            Map<string,sObject> oldRelSalesDocs = new Map<String,sObject>();
                            Map<string,sObject> newRelSalesDocs = new Map<String,sObject>();
                            List<RelatedSalesDocuments__c> rsdList = new List<RelatedSalesDocuments__c>();
                            oldRelSalesDocs = getSObjectMap('RelatedSalesDocuments__c','Activity__c',new List<String>{SalesCall.Id});
                            for (Activity__c act : followUpCallMap.values()) {
                                if(act.Id != null) {
                                    newRelSalesDocs = cloneSelectedRecords(oldRelSalesDocs,false);
                                    for(RelatedSalesDocuments__c rsd : (List<RelatedSalesDocuments__c>)newRelSalesDocs.values()) {
                                        rsd.Activity__c = act.Id ;
                                        rsdList.add(rsd);
                                    }
                                }
                            }
                            if(rsdList.size() > 0) {
                                insert rsdList ;
                            }
                        } catch(Exception e) {

                        }
                    } END NCarson C-00358575 10/10/25 - remove insert, as it has been moved to trigger handler */

          if (followUpCallMap.size() > 0) {
            List<ProductActivity__c> proAcList = new List<ProductActivity__c>();
            //for(String str : followUpCallMap.keySet()) {
            // Commented by Nishank for Story Story S-408243
            /*for(ProductActivity__c pa : paList) {
                        if(String.isNotBlank(pa.Sale_Progress_Follow_up_Call__c)) {
                        ProductActivity__c pac = new ProductActivity__c();
                        pac.Product__c = pa.Product__c ;
                        pac.Activity__c = followUpCallMap.get(pa.Sale_Progress_Follow_up_Call__c).Id;
                        proAcList.add(pac);
                        }
                        }*/
            // End of changes Commented by Nishank for Story Story S-408243
            // Added by Nishank for Story Story S-408243
            for (ProductActivity__c pa : paList) {
              if (String.isNotBlank(pa.Sale_Progress_Follow_up_Call__c)) {
                ProductActivity__c pac = new ProductActivity__c();
                pac.Product__c = pa.Product__c;
                if (
                  pa.Sale_Progress_Follow_up_Call__c !=
                  'Plan My Appointment Now'
                ) {
                  pac.Activity__c = followUpCallMap.get(
                      pa.Sale_Progress_Follow_up_Call__c
                    )
                    .Id;
                } else {
                  if (pa.Activity_Start_date__c != null) {
                    pac.Activity__c = followUpCallMap.get(
                        string.valueOfGmt(pa.Activity_Start_date__c)
                      )
                      .Id;
                  }
                }
                
                // NCarson C-00359050 1/23/26 - do not insert records - logic has moved to trigger handler
                // proAcList.add(pac);
              }
            }
            // End of changes commented by Nishank for Story Story S-408243
            //}
            if (proAcList.size() > 0) {
              insert proAcList;
            }
          }
          notSoldPAIds = '';
        }
        isClosingMeeting = true; //Added by Shobhit Pant For Case 00227972 05/21/2018
        // End - Jai Gupta - S-339871 - Aug 20,2015 - Fetch not sold products and create follow up
        // S-339867 - Hemlata - -Added If claues and else block
        if (!isCompleted) {
          SalesCall.Status__c = 'Completed';
          SalesCall.MeetingClosedDate__c = DateTime.now();
          SalesCall.Updated__c = true;
            System.debug('CheckStatusIf');
            //Start- Added by mayank For story -S-708067| 03|07\2025 || Add the logic to fetch the activity details
            System.debug('SalesCall>>>'+SalesCall);
            fetchProductDetails(SalesCall);
            //ENd- Added by mayank For story -S-708067| 03|07\2025 || Add the logic to fetch the activity details
          SaveMeeting();

          initialObjectMap.put('revert', false);
            

          //upsert BusinessObjectivePlannedActivityList;

          ApexPages.addmessage(
            new ApexPages.message(
              ApexPages.Severity.Info,
              'Meeting Closed Successfully. Please tap Previous Page at the top left to return.'
            )
          );

            
          //update the meet now details for this sales call to reflect the changes made
          UpdateMeetNowDetails('Meeting Closed');
        } else {
            System.debug('CheckStatusEls');
          SaveMeeting();
          SalesCall.Updated__c = true;
          update SalesCall;
          initialObjectMap.put('revert', false);
          PageReference pg2 = new Pagereference(
            '/apex/SalesCallDetail?id=' + SalesCall.Id
          );
          pg2.setRedirect(true);
          return pg2;
        }
      } catch (Exception e) {
        LogError(e);
      }
      return null;
      //rmarquardt start - S-423778 - 8/3/2016
    }
    system.debug('tt:errorsFound' + errorsFound);
    return null;
    //rmarquardt end - S-423778 - 8/3/2016
  }
 //Start- Added by mayank For story -S-708067| 03|07\2025 || fetch new product detail for close the meeting


    public void fetchProductDetails(Activity__c activity) {
        if (activity == null || activity.Id == null) return;

        // Fetch product activities for this activity
        List<ProductActivity__c> productActivities = [
            SELECT Id, Activity__c, tf_ProductClientName__c, tf_ProductCategory__c,
                   ProductStatus__c, What_are_next_steps__c, t_SalesResultStatus__c
            FROM ProductActivity__c
            WHERE Activity__c = :activity.Id
        ];

        // Fetch opportunities for this operator
        List<SalesOpportunity__c> opportunities = [
            SELECT Id, ProductCategory__r.Name, Operator__c, Manufacturer__r.Name,
                   Status__c, What_are_the_next_steps__c
            FROM SalesOpportunity__c
            WHERE Updated__c = TRUE
              AND Status__c = 'Active'
              AND Operator__c = :activity.Operator__c
        ];

        // Prepare map of matched steps for each opportunity
        Map<Id, List<String>> oppIdToSteps = new Map<Id, List<String>>();
        Set<SalesOpportunity__c> matchedOpportunity=new  Set<SalesOpportunity__c>();

        for (ProductActivity__c prod : productActivities) {
            if (prod.ProductStatus__c != 'Not Sold' || prod.t_SalesResultStatus__c != 'Not Sold In Progress') {
                continue;
            }
                    
            for (SalesOpportunity__c opp : opportunities) {
                Boolean isCategoryMatch = 
                    prod.tf_ProductCategory__c != 'N/A' && 
                    opp.ProductCategory__r.Name != 'N/A' && 
                    prod.tf_ProductCategory__c == opp.ProductCategory__r.Name;   
                
                Boolean isManufacturerMatch = (prod.tf_ProductClientName__c == opp.Manufacturer__r.Name)?true:false;


                if (isCategoryMatch && isManufacturerMatch) {
                    matchedOpportunity.add(opp);
                    System.debug('matched');
                    system.debug('prod.id >>>'+prod.Id+'>>>what next>>>'+prod.What_are_next_steps__c);
                     String step = prod.What_are_next_steps__c != null ? prod.What_are_next_steps__c.trim() : '';
                    String stepLower = step.toLowerCase();

                    Boolean isVague = (stepLower == 'follow up' || stepLower == 'n/a' || step.length() < 10);

                        if (isVague || step == '') {
                            continue;
                        }

                    if (!oppIdToSteps.containsKey(opp.Id)) {
                        oppIdToSteps.put(opp.Id, new List<String>());
                    }
                     System.debug('oppIdToSteps insdie>>'+oppIdToSteps);
                    oppIdToSteps.get(opp.Id).add(prod.What_are_next_steps__c);
                }
            }
        }
        System.debug('opportunities>>>'+opportunities);
        System.debug('oppIdToSteps>>>'+oppIdToSteps);
        System.debug('matchedOpportunity>>>'+matchedOpportunity);
        // Summarize and update each matched opportunity
        for (SalesOpportunity__c opp : matchedOpportunity) {
             System.debug('opp.Id111>>>'+opp.Id+'?????'+opp.ProductCategory__r.Name);
            if (oppIdToSteps.containsKey(opp.Id)) {
                 System.debug('opp.Id>>>'+opp.Id);
                List<String> steps = oppIdToSteps.get(opp.Id);
                System.debug('steps>>>'+steps);
                String stepString=String.join(steps, '\n');
                System.debug('stepString>>>'+stepString);
                OpenAISummarizerSync.summarizeText(stepString,opp.Id);
            }
            else{
                updateOpportunityWhatNextValue(opp);
            }
        }
    }

    public void updateOpportunityWhatNextValue(SalesOpportunity__c opportunity){
            String defaultSummery='No actionable next steps were captured from this meeting.';
            String datePrefix = DateTime.newInstance(Date.today(), Time.newInstance(0, 0, 0, 0)).format('MM/dd');
                        String existingSteps = opportunity.What_are_the_next_steps__c != null ? opportunity.What_are_the_next_steps__c : '';
                        String newEntry = datePrefix + ' : ' + defaultSummery;

                        SalesOpportunity__c updatedOpp = new SalesOpportunity__c(
                            Id = opportunity.Id,
                            What_are_the_next_steps__c = newEntry + '\n\n' + existingSteps
                        );
                      System.debug('updatedOpp default>>> ' + updatedOpp.What_are_the_next_steps__c);
                      System.debug('updatedOppopportunity default>>> ' + updatedOpp.Id);

                     update updatedOpp;

    }


 //end- Added by mayank For story -S-708067| 03|07\2025 || fetch new product detail for close the meeting
  /*when a product is added to the page*/
  public PageReference AddProducts() {
    try {
      //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, JSON.serialize(ProductIds)));

            //For each new product in the list, add them to the ProductActivity junction
            Set<String> ProductIdSet = new Set<String>();
            System.debug('$%^Prod Ids: ' + ProductIds);
            if(ProductIds != null && ProductIds != '')
            {
                ProductIds = ProductIds.trim();
                ProductIdSet.addAll(ProductIds.split(','));
            }

            for(ProductActivity__c pa: [SELECT Id,Product__r.Id FROM ProductActivity__c WHERE Product__r.Id IN :ProductIdSet
                                        AND Activity__c = :SalesCall.Id AND Activity__c != null AND Product__c != null])
            {
                ProductIdSet.remove(pa.Product__r.Id);
            }

            list<Id> pasCreated = new list<Id>();
            List<ProductActivity__c> prdActList = new List<ProductActivity__c>();//Added By Pushpendra | C-00333265 | 16/09/2021 | Resolve too many SOQL 
            for(Product__c p : [SELECT Manufacturer__r.Name, Name, ManufacturingNumber__c, GlobalClassification__c, ProductFamily__r.Name,
                                ProductCategory__r.Name, ProductDescription__c, SKU__c, GTIN__c, Packed__c, ProductInfoURL__c, //S-264415 add ProductInfoURL in query
                                DOT_Number__c, DOT_In_Stock__c, DOT_Availability__c //S-307652
                                FROM Product__c WHERE Id IN :ProductIdSet])
            {
                AssignedProduct ap = new AssignedProduct(p, SalesCall);
                prdActList.add(ap.ProductActivity);//Added By Pushpendra | C-00333265 | 16/09/2021 | Resolve too many SOQL 
                AssignedProductList.add(ap);
                //pasCreated.add(ap.ProductActivity.Id);//Commented By Pushpendra | C-00333265 | 16/09/2021 | move it outside this for loop to resolve SOQL error
            }
            
            //Start - Added By Pushpendra | C-00333265 | 16/09/2021 | Resolve too many SOQL 
            if(prdActList.size()>0){
                upsert prdActList;
                
                // Shalini + NCarson C-00356973 - 1/29/25 - save meeting
                SaveMeeting();
            }
            
            for(ProductActivity__c prAct : prdActList){
                pasCreated.add(prAct.Id);
            }
            //End - Added By Pushpendra | C-00333265 | 16/09/2021 | Resolve too many SOQL 
            
            //add created product activities to initial object map
            if(!initialObjectMap.containsKey('ProductActivitiesCreated'))
                initialObjectMap.put('ProductActivitiesCreated', new list<Id>());

            ((list<Id>)initialObjectMap.get('ProductActivitiesCreated')).addAll(pasCreated);

            List<String> NewProductIdList = new List<String>(ProductIdSet);

            //Update the ManufacturerIds
            List<String> ProductIdList = ProductIds.split(',');

            Set<String> ManufacturerIdSet = new Set<String>();
            List<String> ManufacturerIdList = new List<String>();
            for(Product__c p : [SELECT Manufacturer__r.Id FROM Product__c WHERE Id IN :ProductIdList])
            {
                ManufacturerIdSet.add(p.Manufacturer__r.Id);
            }
            ManufacturerIdList.addAll(ManufacturerIdSet);
            ManufacturerIds =  String.join(ManufacturerIdList,',');

            //update the meet now details for this sales call to reflect the changes made
            UpdateMeetNowDetails('Now contains the following product(s) : '+String.join(NewProductIdList,','));
            StartUpAction(); // Added by vinit for S-644696/S-645821 [14-Nov-2019]
        }
        catch (Exception e)
        {
            LogError(e);
        }
        /** comment start by Jai Gupta - S-705507 -  Oct 09, 2023  - Remove Suggested Product section */
        //START -- Added by Shivani for S-612902 on 03/05/2019
        // if(AssignedProductList != null && AssignedProductList.size() > 0) {
        //     displaySuggestedProducts(AssignedProductList[AssignedProductList.size() - 1].Product.Id);
        // }
        //END -- Added by Shivani for S-612902 on 03/05/2019
        /** comment end by Jai Gupta - S-705507 -  Oct 09, 2023  - Remove Suggested Product section */
        return null;
    }

    /*product wrapper class for related objects*/
    public class AssignedProduct
    {
        public String PAId {get;set;}
        public String ProductName {get;set;}
        public String ManufacturerId {get;set;}
        public String ManufacturerName {get;set;}
        public String ManufacturingNumber {get;set;}
        public String SKU {get;set;}
        public String ProductStatus {get;set;}

    public String AchievedNSO { get; set; }

    public String OperatorFeedback { get; set; }
    public String OperatorFeedbackReasons { get; set; }
    public String WeeklyVolume { get; set; }
    public String CasesWeekUsage { get; set; }

    public ProductActivity__c ProductActivity { get; set; }
    public CommittedOrder__c ProductSold { get; set; }
    //START- Added by Sajal for S-569846
    public String expectedOrderStartDate { get; set; }
    public String expectedOrderEndDate { get; set; }
    public String exactEffEndDate { get; set; }
    //END for S-569846
    public Product__c Product { get; set; }

    /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - Start ***/
    public String startDate { get; set; }
    public String startTime { get; set; }
    public String endTime { get; set; }
    /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - End ***/

    public String operatorContractExpiryDate { get; set; } // AT
    public String OperatorSIPconclude { get; set; }
    public String operatorCC { get; set; } //AT
    public String operatorCCName { get; set; } //AT

    public String oucfeed { get; set; }
    public String oucfeedNSCC { get; set; }
    public String DistFinalCCCFeed { get; set; }

    public String DistFinalCNewFeed { get; set; }
    public String operatorFeedbackCC { get; set; } //AT
    public String operatorWhoLose { get; set; } //AT
    public String operatorWhoLoseName { get; set; } //AT

 
        public AssignedProduct(ProductActivity__c pa,CommittedOrder__c co,Product__c prod,map<String,Boolean> OppMap)
        {
            try
            {
                ProductActivity = pa;
                ProductName = pa.Product__r.Name;
                ManufacturerId = pa.Product__r.Manufacturer__r.Id;
        // NCarson S-707880 - no apostrophes in Manufacturer Name 
        ManufacturerName = pa.Product__r.Manufacturer__r.Name?.replaceAll('\'','');
        ManufacturingNumber = pa.Product__r.ManufacturingNumber__c;
        SKU = pa.Product__r.SKU__c;
        AchievedNSO = JSON.serialize(OppMap);

                ProductSold = co;
                // START- Added by Sajal for S-569846
                if(ProductSold.ExpectedOrder__c != null) {
                    expectedOrderStartDate = ProductSold.ExpectedOrder__c.format();
                }
                if(ProductSold.Expected_Order_End_Date__c != null){
                    expectedOrderEndDate = ProductSold.Expected_Order_End_Date__c.format();
                }
                system.debug(ProductActivity.Id+' expected order date :: '+ProductSold.ExpectedOrder__c);
                system.debug(ProductActivity.Id+'expected end date::'+ProductSold.Expected_Order_End_Date__c);
                // End for S-569846
                Product = prod;

                /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - Start ***/
                if(pa.Activity_Start_Date__c != null) {

                    String startDateTimeStamp = pa.Activity_Start_Date__c.format('mm/dd/yyyy h:mm a');

                    //Modified by Aditya Tiwari for Case#00192723 04/11/2017 Start
                    //startDate = startDateTimeStamp.subString(0, startDateTimeStamp.indexOf(' '));
                    startDate = pa.Activity_Start_Date__c.Date().format();
                    //Modified by Aditya Tiwari for Case#00192723 04/11/2017 End
                    startTime = startDateTimeStamp.subString(startDateTimeStamp.indexOf(' '), startDateTimeStamp.length());
                }

                if(pa.Activity_End_Date__c != null) {

                    String endDateTimeStamp = pa.Activity_End_Date__c.format('mm/dd/yyyy h:mm a');
                    endTime = endDateTimeStamp.subString(endDateTimeStamp.indexOf(' '), endDateTimeStamp.length());
                }
                /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - End ***/
                // Start AT
                if(pa.Operator_Contract_Expiry_Date__c != null) {
                    operatorContractExpiryDate = pa.Operator_Contract_Expiry_Date__c.format();
                }



                if(pa.When_do_you_expect_testing_to_conclude__c != null) {
                    OperatorSIPconclude = pa.When_do_you_expect_testing_to_conclude__c.format();
                }
            }
            catch (Exception e)
            {
                LogError(e);
            }
        }

        public AssignedProduct(Product__c prod,Activity__c sc)
        {
            try
            {
                ProductActivity = new ProductActivity__c();
                ProductActivity.Product__c = prod.Id;
                ProductActivity.Activity__c = sc.Id;
                
                // Code changes done by Ravi Jain for case 00264478
                // Start - Ravi Jain - 00264478 - 15th July, 2019
                ProductActivity.Operator__c = sc.Operator__r.Id;
                // End - Ravi Jain - 00264478 - 15th July, 2019

        ProductName = prod.Name;
        ManufacturerName = prod.Manufacturer__r.Name;
        ManufacturerId = prod.Manufacturer__r.Id;
        ManufacturingNumber = prod.ManufacturingNumber__c;
        SKU = prod.SKU__c;

        AchievedNSO = JSON.serialize(new Map<String, Boolean>());

        ProductSold = new CommittedOrder__c();
        ProductSold.SalesCall__c = sc.Id;
        ProductSold.Product__c = prod.Id;
        ProductSold.Operator__c = sc.Operator__r.Id;
        ProductSold.Status__c = 'Pending';

        ProductSold.Distributor__c = sc.Distributor__c;

        Product = prod;

                //upsert ProductActivity;//Commented By Pushpendra | C-00333265 | 16/09/2021 | [move upsert outside the for loop in Add Products method]

            }
            catch (Exception e)
            {
                LogError(e);
            }
        }

        public void LogError(Exception e)
        {
            ErrorHandlerGlobal.logError(e, URL.getCurrentRequestUrl().toExternalForm());
        }
    }

  /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - Start ***/
  //Variable to hold time constraints which will be used on page
  public string startTime { get; set; }
  public string endTime { get; set; }

  /**
   *  @description    :   This method will be used to build Select Option list of Time constraints which will be used on Operator feedback popup.
   *
   *  @param          :
   *
   *  @return         :   List<SelectOption>
   **/
  public List<SelectOption> getTimes() {
    //List to hold select options for user input
    List<SelectOption> times = new List<SelectOption>();

    //Datetime instance for fixed dates
    Datetime myDate = Datetime.newInstance(2008, 12, 1);
    Datetime newDate = myDate.addDays(1);

        //Add an empty timeslot
        //Start | Updated by Rahul T | S-703689 | 14/06/23
        times.add(new SelectOption('--', '--'));//Rahul
        //Start | Updated by Rahul T | S-703689 | 14/06/23
        //Check for not equal values
        while(myDate != newDate) {

            //Populate select option list
            times.add(new SelectOption(myDate.format('h:mm a'), myDate.format('h:mm a')));

      //Increment date by 30 minutes
      myDate = myDate.addMinutes(30);
    }

    //return option list
    return times;
  }
  //Start | Updated by Rahul T | S-706206 | 28/03/24
  @RemoteAction
  public static Map<String, String> setMessage(String prodActivityId) {
    Map<String, String> result = new Map<String, String>();

    ProductActivity__c prodActivity = [SELECT Id,Activity__r.Operator__r.Type, Activity_Start_Date__c, Activity_End_Date__c, OperatorFeedback__c,Reasons_unwilling_to_consider__c,Distributor_Not_sold_Reasons_final__c,Distributor_New_Item_Reasons_Final__c,Distributor_Not_sold_Reasons__c,Distributer_SIP_New_Item__c FROM ProductActivity__c WHERE Id = :prodActivityId];

    if(prodActivity != null) {
        String timeStamp = '';
        if(prodActivity.Activity_Start_Date__c != null) {
            String[] parts = prodActivity.Activity_Start_Date__c.format().split(' ');
            timeStamp += prodActivity.Activity_Start_Date__c.date().format() + '#' + ((parts.size() == 3) ? (parts[1] + ' ' + parts[2]) : parts[1]);
        }

        if(prodActivity.Activity_End_Date__c != null) {
            String[] parts = prodActivity.Activity_End_Date__c.format().split(' ');
            timeStamp += '#' + ((parts.size() == 3) ? (parts[1] + ' ' + parts[2]) : parts[1]);
        }
       
        result.put('timestamp', timeStamp);
        result.put('DistOperAccountType',prodActivity.Activity__r.Operator__r.Type);
        result.put('operatorFeedback', prodActivity.OperatorFeedback__c);
        result.put('ReasonsUnwillingToConsider',prodActivity.Reasons_unwilling_to_consider__c);
        result.put('DistributorNotsoldReasonsfinal',prodActivity.Distributor_Not_sold_Reasons_final__c);
        result.put('DistributorNewItemReasonsFinal',prodActivity.Distributor_New_Item_Reasons_Final__c);
        result.put('DistributorNotsoldReasons',prodActivity.Distributor_Not_sold_Reasons__c);
        result.put('DistributorNotsoldReasons',prodActivity.Distributer_SIP_New_Item__c);
    }

    return result;
  }
  //End | Updated by Rahul T | S-706206 | 28/03/24
  /*** Code modified - Padmesh Soni (08/26/2016 Appirio Offshore) - S-421422 - End ***/

    /** Code modified - Padmesh Soni (09/07/2016 Appirio Offshore) - S-436369 - Start **/
    @RemoteAction
    public static String getScheduledSalesCall(String actionType, String plannedDate) {

        String JSONScheduledCalls = '';

        //Check for specific date related Sales Calls
        if(String.isNotBlank(actionType) && actionType == 'getSpecificActivities') {

            try {

                if(String.isNotBlank(plannedDate)) {

                    //Set the default start/end times to 1 day
                    Date activityStart = date.parse(plannedDate);

          System.debug('activityStart :::' + activityStart);

          //build list of matching activities
          List<map<string, object>> activities = new List<map<string, object>>();

                    //Query on activity
                    for (Activity__c activity : [SELECT Id, Name, Subject__c, StartDate__c, EndDate__c, DueDate__c, TypePL__c, Type__c, SubType__c, Color__c,
                                                 Operator__r.Name, Requested__c, Updated__c, AllDay__c, Status__c, Operator__c,Temporary__c FROM Activity__c
                                                 WHERE Status__c =: Constants.ACTIVITY_STATUS_PLANNED
                                                 AND ((Requested__c = false AND OwnerId = :UserInfo.getUserId()) OR (Requested__c = true
                                                                                                                     AND Employee__r.User__c = :UserInfo.getUserId())) AND Updated__c = true
                                                 AND (StartDate__c <= :activityStart OR EndDate__c >= :activityStart) ORDER BY StartDate__c ASC]) {

                                                     if(activity.StartDate__c != null && activity.StartDate__c.Date() <= activityStart
                                                        && activity.EndDate__c != null && activity.EndDate__c.Date() >= activityStart) {

                                                            if(activity.Requested__c == true) {
                                                                activity.Name = 'Requested Sales Call with ' + activity.Operator__r.Name;
                                                            } else if(activity.SubType__c == 'Sales Call') {
                                                                activity.Name = ' Sales Call with ' + activity.Operator__r.Name;
                                                            }

                                                            if( activity.Requested__c == true || (activity.Requested__c == false && activity.Updated__c == true) ) {

                                                                JSONScheduledCalls += + (activity.StartDate__c != null && activity.EndDate__c != null
                                                                                         && activity.StartDate__c.date() == activity.EndDate__c.date()
                                                                                         ? activity.StartDate__c.format('h:mm a'): ' Full Day ')
                                                                    + (activity.StartDate__c != null && activity.EndDate__c != null
                                                                       && activity.StartDate__c.date() == activity.EndDate__c.date()
                                                                       ? ' - '+ activity.EndDate__c.format('h:mm a '): ' ')
                                                                    + (activity.Requested__c == true ? 'Requested ' : '' )
                                                                    + (activity.Type__c == 'To-Do' ? '' : activity.Type__c  + ' : ')
                                                                    + (activity.Type__c == 'Sales Call' && activity.Operator__c != null
                                                                       ? ' ' + activity.Operator__r.Name : ' ' +activity.Subject__c)
                                                                    + '<br/>';
                                                            }
                                                        }
                                                 }
                }
            } catch (Exception e) {

                JSONScheduledCalls = e.getMessage() + ',Line:'+e.getLineNumber();
            }
        }

    return JSONScheduledCalls;
  }
  /** Code modified - Padmesh Soni (09/07/2016 Appirio Offshore) - S-436369 - End **/

    // START TNOE - S-569853 - Remote action to search for existing product activity when selecting the Using status for a product activity
    @RemoteAction
    public static ProductActivity__c getExistingProductActivity(String accountId, String productId, String paId) {
        ProductActivity__c existingPA;
        try {
            existingPA = [SELECT Id, Product__c,Was_an_Oil_Evaluation_Conducted__c, ProductStatus__c, CasesWeekUsage__c, OperatorFeedback__c, Using_Purchase_Frequency__c, Using_Distributor__c, Using_Distributor__r.Name, Activity__r.Operator__c, Quantity_Entered__c, //Modified by Vinit for S-581469 //Added by  Komal for Story 707692 | 17/12/2024 
                          (SELECT Id, FeedbackType__c, Quantity_Entered__c, Distributor__c, Distributor__r.Name, Quantity__c // Modified by Vinit for S-581469
                          ,Client_Assist_Type__c,Did_Client_Assist_with_Sale__c // Tushar Soni | 14/11/2022 | S-698550 | Query new fields 
                          FROM Committed_Orders__r
                           WHERE FeedbackType__c IN ('Annual Orders', 'Weekly Orders', 'Monthly Orders','One Time Order Only','Specific Menu Placement / LTO','Trial Order Only') // Modified By Vinit for S-609152 [27-Feb-2019]
                           ORDER BY CreatedDate DESC LIMIT 1)
                          FROM ProductActivity__c
                          WHERE Activity__r.Operator__c = :accountId
                          AND Product__c = :productId
                          AND ProductStatus__c IN ('Sold', 'Using')
                          AND Using_Purchase_Frequency__c IN ('', 'Annual Orders', 'Weekly Orders', 'Monthly Orders','One Time Order Only','Specific Menu Placement / LTO','Trial Order Only') // Modified By Vinit for S-609152 [27-Feb-2019]
                          AND Id != :paId
                          ORDER BY CreatedDate DESC
                          LIMIT 1];
        } catch(Exception e) {
            existingPA = null;
        }
        return existingPA;
    }
    // START TNOE - S-569853

  //Modified by Aditya Tiwari for S-554835 Start
  public class PicklistWrapper {
    public String value { get; set; }
    public Boolean isSelected { get; set; }

    public PicklistWrapper(String value, Boolean isSelected) {
      this.value = value;
      this.isSelected = isSelected;
    }
  }
  //Modified by Aditya Tiwari for S-554835 End

  // Added by Rakshit for Task -> T-594929 #Start
  public class ClientInitiativeLLOPlanningWrapper {
    public String clientName { get; set; }
    public String clientSourceName { get; set; }
    public Date clientStart { get; set; }
    public Date clientEnd { get; set; }
    public String clientInitiativeId { get; set; }
    public Id activtyId { get; set; }
    public string color { get; set; }
  }

  public class ClientInitiativeAssignedMarketWrapper {
    public String clientName { get; set; }
    public String clientSourceName { get; set; }
    public Date clientStart { get; set; }
    public Date clientEnd { get; set; }
    public String clientInitiativeId { get; set; }
    public Id activtyId { get; set; }
  }

  //STRT Commented by Komal V for Story S-705174 | 21/9/2023 |To hide 'LLO Initiative Planning' section
  /*public PageReference getLLOs(){
        Id activityId = ApexPages.currentPage().getParameters().get('id');
        List<Activity__c> lstActivities = new List<Activity__c>();
        List<Account> lloAccountList = new List<Account>();
        lstCliIniAssMarkWrap = new List<ClientInitiativeAssignedMarketWrapper>();
        lstCliIniLLOPlanWrap = new List<ClientInitiativeLLOPlanningWrapper>();
        Set<Id> setClientIds = new Set<Id>();

        if(activityId != null){
            lstActivities = [SELECT Id, Operator__c FROM Activity__c WHERE Id =: activityId LIMIT 1];
            if(!lstActivities.isEmpty()){
                /*Code Modified by Shobhit Pant for Case 00212399 11/14/2017 START */
  //adding expiry condition to the below query
  /*lloAccountList = [SELECT Id,LargeLeverageOperator__c,Geographic_Market__c,Market__c,
                (SELECT Id, Client_Initiative__c,Client_Initiative__r.Name, Client_Initiative__r.Start_Date__c,Client_Initiative__r.Client_source__r.Name ,
                Employee__c,Most_Recent_Status__c,Operator__c ,Client_Initiative__r.Initiative__c,Client_Initiative__r.End_Date__c,IsPlanned__c
                FROM Client_Initiative_Employee_LLO_Planning__r)
                FROM Account WHERE Id =: lstActivities[0].Operator__c];*/
  /*lloAccountList = [SELECT Id,LargeLeverageOperator__c,Geographic_Market__c,Market__c,
                                  (SELECT Id, Client_Initiative__c,Client_Initiative__r.Name, Client_Initiative__r.Start_Date__c,Client_Initiative__r.Client_source__r.Name ,
                                   Employee__c,Most_Recent_Status__c,Operator__c ,Client_Initiative__r.Initiative__c,Client_Initiative__r.End_Date__c,IsPlanned__c
                                   FROM Client_Initiative_Employee_LLO_Planning__r WHERE Client_Initiative__r.End_Date__c >= TODAY )
                                  FROM Account WHERE Id =: lstActivities[0].Operator__c];*/
  /*Code Modified by Shobhit Pant for Case 00212399 11/14/2017 END */

  //MDUNCAN C-00236687 08.15.2018 - Modified Below 1 Line - Removed 'lloAccountList[0].LargeLeverageOperator__c == true' from logic check per client request
  /*if( !lloAccountList.isEmpty() && !lloAccountList[0].Client_Initiative_Employee_LLO_Planning__r.isEmpty()){
                    // Logic 1 of Task
                    for (Client_Initiative_Employee_LLO_Planning__c cl : lloAccountList[0].Client_Initiative_Employee_LLO_Planning__r){
                        if(cl.IsPlanned__c){
                            ClientInitiativeLLOPlanningWrapper clp = new ClientInitiativeLLOPlanningWrapper();
                            clp.clientName = cl.Client_Initiative__r.Initiative__c;
                            clp.clientSourceName = cl.Client_Initiative__r.Client_source__r.Name;
                            clp.clientStart = cl.Client_Initiative__r.Start_Date__c;
                            clp.clientEnd = cl.Client_Initiative__r.End_Date__c;
                            clp.clientInitiativeId = cl.Client_Initiative__c;
                            clp.activtyId = activityId;
                            if(cl.Most_Recent_Status__c == null){
                                clp.color = 'colorred';
                            }else if(cl.Most_Recent_Status__c.contains('Planned')){
                                clp.color = 'coloryellow';
                            }else if(cl.Most_Recent_Status__c.contains('Pending')){
                                clp.color = 'colorBlue';
                            }else{
                                clp.color = 'colorgreen';
                            }
                            lstCliIniLLOPlanWrap.add(clp);
                            setClientIds.add(cl.Client_Initiative__c);
                        }else{
                            ClientInitiativeAssignedMarketWrapper clp = new ClientInitiativeAssignedMarketWrapper();
                            clp.clientName = cl.Client_Initiative__r.Initiative__c;
                            clp.clientSourceName = cl.Client_Initiative__r.Client_source__r.Name;
                            clp.clientStart = cl.Client_Initiative__r.Start_Date__c;
                            clp.clientEnd = cl.Client_Initiative__r.End_Date__c;
                            clp.clientInitiativeId = cl.Client_Initiative__c;
                            clp.activtyId = activityId;
                            lstCliIniAssMarkWrap.add(clp);
                        }
                    }
                }

                if(!lloAccountList.isEmpty() && lloAccountList[0].LargeLeverageOperator__c != true && lloAccountList[0].Geographic_Market__c != null ){
                    // Logic 2 of Task
                    Id marketId = lloAccountList[0].Geographic_Market__c;
                    List<Client_Initiatives_Assigned_Markets__c> lstCliIniAssMark = new List<Client_Initiatives_Assigned_Markets__c>();
                    lstCliIniAssMark = [SELECT Id,Market__c,Client_Initiative__c,Client_Initiative__r.Name,Client_Initiative__r.Initiative__c, Client_Initiative__r.Start_Date__c,Status__c,
                                        Client_Initiative__r.Client_source__r.Name, Client_Initiative__r.End_Date__c
                                        FROM Client_Initiatives_Assigned_Markets__c
                                        WHERE Market__c =: marketId AND Status__c = 'Active' AND Client_Initiative__c Not in: setClientIds];
                    if(!lstCliIniAssMark.isEmpty()){
                        for(Client_Initiatives_Assigned_Markets__c cl : lstCliIniAssMark ){
                            ClientInitiativeAssignedMarketWrapper clp = new ClientInitiativeAssignedMarketWrapper();
                            clp.clientName = cl.Client_Initiative__r.Initiative__c;
                            clp.clientSourceName = cl.Client_Initiative__r.Client_source__r.Name;
                            clp.clientStart = cl.Client_Initiative__r.Start_Date__c;
                            clp.clientEnd = cl.Client_Initiative__r.End_Date__c;
                            clp.clientInitiativeId = cl.Client_Initiative__c;
                            clp.activtyId = activityId;
                            lstCliIniAssMarkWrap.add(clp);
                        }
                    }
                }
                if(!lloAccountList.isEmpty() && lloAccountList[0].Geographic_Market__c == null && lloAccountList[0].Market__c != null){
                    // Logic 3 of Task
                    Id marketId = lloAccountList[0].Market__c;
                    List<Client_Initiatives_Assigned_Markets__c> lstCliIniAssMark = new List<Client_Initiatives_Assigned_Markets__c>();
                    lstCliIniAssMark = [SELECT Id,Market__c,Client_Initiative__c,Client_Initiative__r.Name,Client_Initiative__r.Initiative__c, Client_Initiative__r.Start_Date__c,Status__c,
                                        Client_Initiative__r.Client_source__r.Name, Client_Initiative__r.End_Date__c
                                        FROM Client_Initiatives_Assigned_Markets__c
                                        WHERE Market__c =: marketId AND Status__c = 'Active' AND Client_Initiative__c Not in: setClientIds];

                    if(!lstCliIniAssMark.isEmpty()){
                        for(Client_Initiatives_Assigned_Markets__c cl : lstCliIniAssMark ){
                            ClientInitiativeAssignedMarketWrapper clp = new ClientInitiativeAssignedMarketWrapper();
                            clp.clientName = cl.Client_Initiative__r.Initiative__c;
                            clp.clientSourceName = cl.Client_Initiative__r.Client_source__r.Name;
                            clp.clientStart = cl.Client_Initiative__r.Start_Date__c;
                            clp.clientEnd = cl.Client_Initiative__r.End_Date__c;
                            clp.clientInitiativeId = cl.Client_Initiative__c;
                            clp.activtyId = activityId;
                            lstCliIniAssMarkWrap.add(clp);
                        }
                    }
                }
            }
        }
        return null;
    }*/
  //END Commented by Komal V for Story S-705174 | 21/9/2023 |To hide 'LLO Initiative Planning' section
  // Added by Rakshit for Task -> T-594929 #End
  //START- Added by Sajal for S-569846
  public void getEffEndDateCalc() {
    //system.assert(false,mySelectedOption);
    //if(mySelectedOption != '' && mySelectedOption != null && !mySelectedOption.contains('Weeks')){

        //}
        isCustom = false;
        System.debug('myselOpt at 3099'+mySelectedOption);
        if(mySelectedOption != 'Custom'){
            List<CommittedOrder__c> comOrderList = new List<CommittedOrder__c>();
            List<String> dateString = new List<String>();
            dateString = effStartDate.split('/');
            Integer startMonth = 0;
            Integer startday = 0;
            Integer startYear =0;
            Date startDate = Date.newInstance(1900,01,01);
            if(dateString != null && !dateString.isEmpty() && dateString.size()>1){
                //system.assert(false, 'dateString'+dateString);
                startMonth = Integer.valueOf(dateString[0]);
                startday = Integer.valueOf(dateString[1]);
                startYear = Integer.valueOf(dateString[2]);
                startDate = Date.newInstance(startYear, startMonth, startday);
            }
            //System.assert(false, '---StartDate---'+startDate);

      Integer val = 0;
      if (mySelectedOption != null && mySelectedOption.contains('Weeks')) {
        val = Integer.valueOf(mySelectedOption.split(' ')[0]);
      }
      if (startDate != null) {
        effEndDate = startDate.addDays(val * 7);
        commitOrder.Expected_Order_End_Date__c = effEndDate;
        //system.assert(false, 'commitOrder.Id'+commitOrder);
        /*CommittedOrder__c comOrder = new CommittedOrder__c();
                comOrder.Id = commitOrder.Id;
                comOrder.Expected_Order_End_Date__c = effEndDate;
                comOrderList.add(comOrder);
                //system.assert(false, 'commitOrder.Expected_Order_End_Date__c'+commitOrder.Expected_Order_End_Date__c);
                }
                if(!comOrderList.isEmpty()){
                update comOrderList;*/
      }
    }
  }
  //END for S-569846

  //START -- Added by Shivani for S-612902 on 03/05/2019
  public void displaySuggestedProductsonVF() {
    String prodId;
    if (Apexpages.currentPage().getParameters().get('prodId') != null) {
      prodId = Apexpages.currentPage().getParameters().get('prodId');
    }
    // displaySuggestedProducts(prodId); /** comment Added by Jai Gupta - S-705507 -  Oct 09, 2023  - Remove Suggested Product section */
  }

  public void displaySuggestedProducts(Id prodId) {
    System.debug('In here ' + prodId);
    suggestedProdList = new List<SuggestedProductWrapper>();
    Set<String> skus = new Set<String>();
    Set<Id> manufacturerIds = new Set<Id>();
    Set<Id> prodIdstoSkip = new Set<Id>();
    List<ProductActivity__c> prodActivitiesToCompare = new List<ProductActivity__c>();
    List<ManufacturerMarketAssign__c> marketAssignList = new List<ManufacturerMarketAssign__c>();
    Map<Id, Boolean> manufacturerToAssignsMap = new Map<Id, Boolean>();
    List<Account> opOrDis = new List<Account>();

        relatedPriorityProds = [SELECT id, PRIMARY_PRODUCTID__c, RELATED_PRODUCTID__r.Name,
                        RELATED_PRODUCTID__r.SKU__c, RELATED_PRODUCTID__r.ProductFamily__r.Name,
                        RELATED_PRODUCTID__r.Packed__c, RELATED_PRODUCTID__r.ProductCategory__r.Name ,RELATED_PRODUCTID__r.Manufacturer__c,
                        RELATED_PRODUCTID__r.Manufacturer__r.Name, RELATED_PRODUCTID__r.IsActive__c
                    FROM Related_Products_Priority__c
                    WHERE PRIMARY_PRODUCTID__c =: prodId
                    ORDER BY Priority__c];
        relatedProds = [SELECT id, PRIMARY_PRODUCTID__c, RELATED_PRODUCTID__r.Name,
                        RELATED_PRODUCTID__r.SKU__c, RELATED_PRODUCTID__r.ProductFamily__r.Name,
                        RELATED_PRODUCTID__r.Packed__c, RELATED_PRODUCTID__r.ProductCategory__r.Name ,RELATED_PRODUCTID__r.Manufacturer__c,
                        RELATED_PRODUCTID__r.Manufacturer__r.Name, RELATED_PRODUCTID__r.IsActive__c
                    FROM Related_Products__c
                    WHERE PRIMARY_PRODUCTID__c =: prodId
                    ORDER BY Priority__c];

        if(OperatorId != null ) {
            prodActivitiesToCompare = [SELECT id,ProductStatus__c,Not_Sold_Result_is_Final__c,Product__c, Was_an_Oil_Evaluation_Conducted__c  FROM ProductActivity__c where Operator__c =: OperatorId LIMIT 10000];//updated By Komal for Story S-707692 | 16/12/2024 added Was_an_Oil_Evaluation_Conducted__c
        } else if(DistributorId != null) {
            prodActivitiesToCompare = [SELECT id,ProductStatus__c,Not_Sold_Result_is_Final__c,Product__c, Was_an_Oil_Evaluation_Conducted__c  FROM ProductActivity__c where Activity__r.Distributor__c =: DistributorId LIMIT 10000];//updated By Komal for Story S-707692 | 16/12/2024 added Was_an_Oil_Evaluation_Conducted__c
        }
        for(ProductActivity__c pAct :prodActivitiesToCompare) {
            if('Sold'.equalsIgnoreCase(pAct.ProductStatus__c) ||  pAct.Not_Sold_Result_is_Final__c) {
                prodIdstoSkip.add(pAct.Product__c);
            }
        }
        for(AssignedProduct pAct : AssignedProductList) {
            skus.add(pAct.SKU);
        }
        for(Related_Products_Priority__c rProdPriority : relatedPriorityProds) {
            manufacturerIds.add(rProdPriority.RELATED_PRODUCTID__r.Manufacturer__c);

        }
        for(Related_Products__c rProd : relatedProds) {
            manufacturerIds.add(rProd.RELATED_PRODUCTID__r.Manufacturer__c);
        }

       if(OperatorId != null) {
            opOrDis = [SELECT id,Market__c FROM Account where Id =: OperatorId];
            marketAssignList = [SELECT
                                id, Manufacturer__c, IsActive__c
                                FROM ManufacturerMarketAssign__c
                                WHERE Manufacturer__c IN : manufacturerIds  AND Market__c =: opOrDis[0].Market__c];
        } else if(DistributorId != null) {
            opOrDis = [SELECT id,Market__c FROM Account where Id =: DistributorId];
            marketAssignList = [SELECT
                                    id, Manufacturer__c,IsActive__c
                                FROM ManufacturerMarketAssign__c
                                WHERE Manufacturer__c IN : manufacturerIds AND Market__c =: opOrDis[0].Market__c];
        }
        for(ManufacturerMarketAssign__c mAsisgn : marketAssignList) {
            if(mAsisgn.IsActive__c) {
                manufacturerToAssignsMap.put(mAsisgn.Manufacturer__c, true);
            } else {
                manufacturerToAssignsMap.put(mAsisgn.Manufacturer__c, false);
            }
        }

       for(Related_Products_Priority__c rProdPriority : relatedPriorityProds) {
            System.debug(rProdPriority);
            if(!skus.contains(rProdPriority.RELATED_PRODUCTID__r.SKU__c) && suggestedProdList.size() < 5
                && rProdPriority.RELATED_PRODUCTID__r.IsActive__c && !prodIdstoSkip.contains(rProdPriority.RELATED_PRODUCTID__c)
            ) {
                System.debug(suggestedProdList);
                if(manufacturerToAssignsMap != null && manufacturerToAssignsMap.containsKey(rProdPriority.RELATED_PRODUCTID__r.Manufacturer__c) &&
                    manufacturerToAssignsMap.get(rProdPriority.RELATED_PRODUCTID__r.Manufacturer__c) == true) {
                    System.debug(manufacturerToAssignsMap);
                    suggestedProdList.add(new SuggestedProductWrapper(rProdPriority.RELATED_PRODUCTID__r.Manufacturer__r.Name, rProdPriority.RELATED_PRODUCTID__r.Name,
                        rProdPriority.RELATED_PRODUCTID__r.SKU__c, rProdPriority.RELATED_PRODUCTID__r.ProductFamily__r.Name, rProdPriority.RELATED_PRODUCTID__r.ProductCategory__r.Name,
                        rProdPriority.RELATED_PRODUCTID__r.Packed__c, rProdPriority.RELATED_PRODUCTID__r.Id));
                    prodIdstoSkip.add(rProdPriority.RELATED_PRODUCTID__c);
                }
            }
        }
        if(suggestedProdList.size() < 5) {
            for(Related_Products__c rProd : relatedProds) {
                if(!skus.contains(rProd.RELATED_PRODUCTID__r.SKU__c) && suggestedProdList.size() < 5
                    && rProd.RELATED_PRODUCTID__r.IsActive__c && !prodIdstoSkip.contains(rProd.RELATED_PRODUCTID__c)
                ) {
                    if(manufacturerToAssignsMap != null && manufacturerToAssignsMap.containsKey(rProd.RELATED_PRODUCTID__r.Manufacturer__c) &&
                        manufacturerToAssignsMap.get(rProd.RELATED_PRODUCTID__r.Manufacturer__c) == true) {
                         suggestedProdList.add(new SuggestedProductWrapper(rProd.RELATED_PRODUCTID__r.Manufacturer__r.Name, rProd.RELATED_PRODUCTID__r.Name,
                        rProd.RELATED_PRODUCTID__r.SKU__c, rProd.RELATED_PRODUCTID__r.ProductFamily__r.Name, rProd.RELATED_PRODUCTID__r.ProductCategory__r.Name,
                        rProd.RELATED_PRODUCTID__r.Packed__c, rProd.RELATED_PRODUCTID__r.Id));
                         prodIdstoSkip.add(rProd.RELATED_PRODUCTID__c);
                    }
                }
            }
        }
        System.debug(suggestedProdList);
    }

    public void createProductActivity() {
        String sprodId;
        if(Apexpages.currentPage().getParameters().get('sprodId') != null) {
            sprodId = Apexpages.currentPage().getParameters().get('sprodId');
            System.debug(sprodId);
        }
        List<Product__c> prod = [SELECT id FROM Product__c where Id =: sprodId];
        List<Activity__c> actList =  [select id,Employee__c from Activity__c where id = :SalesCallId];
        ProductActivity__c prodActivity = new ProductActivity__c();
        prodActivity.Product__c = prod[0].Id;
        prodActivity.Operator__c = OperatorId;
        List <Employee__c> emp = [SELECT id from Employee__c where Name =: UserInfo.getName() LIMIT 1];
        if(emp.size() > 0) {
            prodActivity.Assigned_Employee__c = emp[0].Id;
        }
        prodActivity.Verbal__C = true;
        prodActivity.Activity__c = actList[0].Id;
        try {
            insert prodActivity;
        }
        catch(Exception ex){
            // START NCarson S-707655 12/17/24 - suppress error
            System.debug('Exception : ' + ex.getMessage());
            // ApexPages.addMessages(ex);
            // END NCarson S-707655
        }
        StartUpAction();
    }
    //END -- Added by Shivani for S-612902 on 03/05/2019
    //Start - Added by Kiran for S-681312 | 9/4/2021 | [Meet Now page - allow user to remove product activity]
     public void deleteProdInst() {
        String prodToBeDel;
        if(Apexpages.currentPage().getParameters().get('prodToBeDel') != null) {
            prodToBeDel = Apexpages.currentPage().getParameters().get('prodToBeDel');
        }
         // Start- Modified By Rahul T | S-681312/C-00329283 | to delete product ids 
        List<ProductActivity__c> prodActToBeDel = [SELECT id,Product__c  FROM ProductActivity__c where Id =: prodToBeDel and Activity__c =: SalesCallId LIMIT 1];
        system.debug('prodActToBeDel@@1  '+prodActToBeDel);
         
         List<Id> ProductIdToBeRemoved = new List<Id>();
         List<String> res = ProductIds.split(',');
         for (ProductActivity__c prodAct : prodActToBeDel){
             if(res.contains(prodAct.Product__c)){
                 Integer testIndex = res.indexOf(prodAct.Product__c);
                 res.remove(testIndex);
             }
         }
         ProductIds = String.join(res, ',');
        // End- Modified By Rahul T | S-681312/C-00329283 | to delete product ids 

        if(prodActToBeDel.size() > 0) {
            delete prodActToBeDel;
        }
    }
    //End - Added by Kiran for S-681312 | 9/4/2021 | [Meet Now page - allow user to remove product activity]
/** Start | Jai Gupta | S-690300 | Sales Opportunity Popup | Nov 25th, 2021*/
    public boolean showActiveSalesOppPopup {get ;set;}
    public string jsonActiveSalesOppToUpdate {get; set;}
    public List<SalesOpportunity__c> activeSalesOppList {get ;set;}
    /** Start | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */
    Map<Id,SalesOpportunity__c> activeSalesOppMap = new Map<Id,SalesOpportunity__c>();
    Set<String> closedStatus = new Set<String>{'5 - Closed Won','6 - Closed Not Sold'} ;
    /** End | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */

  public void BeforeCloseMeeting() {
   
    // START C-00358178 7/25/25 - run updateSalesOpp method in SaveMeeting instead of BeforeCloseMeeting
    // updateSalesOpp(); //  Added - by Esoof | S-707881 | 02/05/2025
    // END C-00358178

    activeSalesOppSearch();
  }

  public void updateActiveSalesOpp() {
    List<Object> activeSalesOppToUpdate = (List<Object>) JSON.deserializeUntyped(jsonActiveSalesOppToUpdate);
    // NCarson C_00348516 10/26/23 - refactoring from list -> map to avoid duplicate id error
    List<SalesOpportunity__c> toUpdate = new List<SalesOpportunity__c>();
    Map<Id, SalesOpportunity__c> toUpdateMap = new Map<Id, SalesOpportunity__c>();
    for (Object obj : activeSalesOppToUpdate) {
      Map<String, Object> fieldValueMap = (Map<String, Object>) obj;
       SalesOpportunity__c sop = new SalesOpportunity__c(Id = (String)fieldValueMap.get('Id'));
      /** Start | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */
      boolean stageIsClosed = false;
      /** End | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */
      for (String apiName : fieldValueMap.keySet()) {
        if (!'Id'.equalsIgnoreCase(apiName)) {
          string fieldVal = (String) fieldValueMap.get(apiName);
          //START-Added/commented By Komal for Story S-705484 | 25/10/2023 | to update the field on Sales opp
          //sop.put(apiName, String.valueOf(fieldVal));
          if ('EndDate__c'.equalsIgnoreCase(apiName)) {
            date endDate = date.parse(fieldVal);
            sop.put(apiName, endDate);
            }
                    else{
                        sop.put(apiName,fieldVal);
                    }
                    //END-Added By Komal for Story S-705484 | 25/10/2023 | to update the field on Sales opp
                    /** Start | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */
                    if('Opportunity_Status_Code__c'.equalsIgnoreCase(apiName) && closedStatus.contains(String.valueOf(fieldVal))) {
                        stageIsClosed = true ;
                    }
                    /** End | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */
                }
            }
            /** Start | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */
            SalesOpportunity__c existingOpp = activeSalesOppMap.get(sop.Id);
            if(existingOpp.EndDate__c < Date.Today() && stageIsClosed) {
                sop.put('EndDate__c', Date.Today());
            }
            /** End | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */
            toUpdate.add(sop);
            toUpdateMap.put(sop.Id , sop); // NCarson C_00348516 10/26/23 - refactoring from list to map
        }
        // NCarson C_00348516 10/26/23 - use map not list
        if(toUpdateMap.size() > 0) {
            update toUpdateMap.values();
        }

    
    // NCarson S-707880 6/17/25 - updateSalesOpp
    // START C-00358178 7/25/25 - run updateSalesOpp method in SaveMeeting instead of BeforeCloseMeeting
    // updateSalesOpp();
    // END C-00358178
  }

    public void activeSalesOppSearch() {
        showActiveSalesOppPopup = false ; 
        activeSalesOppList = new List<SalesOpportunity__c>();
        List<Sales_Call_Integration_Setting__mdt> scIntList = new List<Sales_Call_Integration_Setting__mdt>([SELECT MasterLabel, Include_in_Sales_Call_Integration__c 
                                                                                                                FROM Sales_Call_Integration_Setting__mdt
                                                                                                                WHERE Include_in_Sales_Call_Integration__c = TRUE]);
        
        if(scIntList.size() > 0) {
            List<Employee__c> empList = [Select Id from Employee__c where User__c = :UserInfo.getUserId()] ; 
            Id empId = null ;
            if(empList.size() > 0) {
                empId = empList[0].Id ;
            }
            set<string> picklistValuesToInclude = new set<string>();
            for(Sales_Call_Integration_Setting__mdt scint : scIntList) {
                picklistValuesToInclude.add(scint.MasterLabel);
            }

      string operatorId = SalesCall.Operator__c ;
            set<string> manufacturerIds = new set<string>();
// START C-00358178 7/25/25 - query needs to reflect category
      Set<String> categoryIds = new Set<String>();
      Set<String> manufacturerCategoryKeySet = new Set<String>();
      for (AssignedProduct ap : AssignedProductList) {
        manufacturerIds.add(ap.ManufacturerId);
        categoryIds.add(ap.Product.ProductCategory__c);
        manufacturerCategoryKeySet.add(ap.ManufacturerId + ap.Product.ProductCategory__c);
      }

      System.debug('manufacturerIds : ' + manufacturerIds);
      System.debug('operatorId : ' + operatorId);

      // START | Himanshu Dave | S-692048 | 16/02/2022 | added field What_are_the_next_steps__c
      // Swastika | C-00341866 | Below line - Uncommented What_are_the_next_steps__c
      // activeSalesOppList = new List<SalesOpportunity__c>(
      for (SalesOpportunity__c salesOpp : 
        [
          SELECT
            Id,
            Manufacturer__c,
            Manufacturer__r.Name,
            Operator__c,
            Operator__r.Name,
            StartDate__c,
            EndDate__c,
            CompetitorManufacturer__c,
            CompetitorProduct__c,
            Description__c,
            Opportunity_Status_Code__c,
            What_are_the_next_steps__c,
            ProductCategory__c
          FROM SalesOpportunity__c
          WHERE
            (NOT Opportunity_Status_Code__c LIKE '%Closed%')
            AND Operator__c = :operatorId
            AND Manufacturer__c IN :manufacturerIds
            AND OpportunitySource__c IN :picklistValuesToInclude
            AND Employee__c = :empId
            AND updated__c = TRUE
            AND ProductCategory__c IN :categoryIds
        ]
      ) { // 'Updated' filter added by Swastika || case 00347391 || 17-07-23
        String manufacturerCategoryKey = salesOpp.Manufacturer__c + '' + salesOpp.ProductCategory__c;
        if (manufacturerCategoryKeySet.contains(manufacturerCategoryKey)) {
          activeSalesOppList.add(salesOpp);
        }
      } // END C-00358178 7/25/25

      // END | Himanshu Dave | S-692048 | 16/02/2022 | added field What_are_the_next_steps__c

      system.debug('****activeSalesOppList' + activeSalesOppList);
      /** Start | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */
      activeSalesOppMap = new Map<Id, SalesOpportunity__c>(activeSalesOppList);
      /** End | S-705449 | Jai Gupta | Oct 05, 2023 | Update expected completion date on sales opportunity */
      if (activeSalesOppList.size() > 0) {
        showActiveSalesOppPopup = true;
      }
    }
  }
  /** End | Jai Gupta | S-690300 | Sales Opportunity Popup | Nov 25th, 2021*/
  //START-Added/Updated by Komal V for Story S-705939 | 8/12/2023 | adding products to a sales call
  public void toGetSalesOppProducts() {
    listOfProductRecords = new List<ProductSalesOpportunity__c>();
 String salesOpptyIdrecord = ApexPages.currentPage().getParameters().get('salesOpptyIdrecord');
        if(String.isNotBlank(salesOpptyIdrecord)){
            listOfProductRecords = [Select Id,SalesOpportunity__c,Product__r.Name,Product__r.Manufacturer__r.Name,Product__r.SKU__c, Product__c ,Product__r.BrandName__c,Product__r.CategoryName__c, Product__r.Packed__c, Product__r.Sample_Pack_size__c ,Product__r.ProductQuantity__c from ProductSalesOpportunity__c where SalesOpportunity__c  =: salesOpptyIdrecord];
        }
    }
    //START: Changes added by Gulab | S-696715 | 22-08-2022
    public PageReference addSalesOppProducts() {
        String salesOpptId = ApexPages.currentPage().getParameters().get('salesOpptyId');
        Set<Id> newProductIds = new Set<Id>();
        Set<Id> existingProductIds = new Set<Id>();
        //Set<Id> salesOppIds = new Set<Id>();
        List<ProductActivity__c> prodAcctivityList = new List<ProductActivity__c>();
        //Map<Id, List<ProductSalesOpportunity__c>> prodSalesOppttyListMap = new Map<Id, List<ProductSalesOpportunity__c>>();
        if(String.isNotBlank(selectedProductStringIds) && String.isNotBlank(salesOpptId)){
            list<String> prodIdString = selectedProductStringIds.split(',');
            
            List<ProductSalesOpportunity__c> listOfProdSalesOpp = [SELECT Id, Name,Product__c FROM ProductSalesOpportunity__c WHERE Product__c IN :prodIdString AND SalesOpportunity__c =:salesOpptId];
            
            for (ProductActivity__c prodAct : [Select Id,Product__c, Was_an_Oil_Evaluation_Conducted__c  FROM ProductActivity__c WHERE Activity__c = :SalesCall.Id]) {////updated By Komal for Story S-707692 | 16/12/2024 added Was_an_Oil_Evaluation_Conducted__c
                existingProductIds.add(prodAct.Product__c);
            }
        /*commented below part as prodSalesOppttyListMap is not required
        for(SalesOpportunity__c obj:OpportunityList){
            salesOppIds.add(obj.Id);
        }
        if(!salesOppIds.isEmpty()) {
            for(ProductSalesOpportunity__c prodSalesOppty : [SELECT Id, SalesOpportunity__c, Product__c 
                                                             FROM ProductSalesOpportunity__c 
                                                             WHERE SalesOpportunity__c IN :salesOppIds]) {
                 if(!prodSalesOppttyListMap.containskey(prodSalesOppty.SalesOpportunity__c)){
                    prodSalesOppttyListMap.put(prodSalesOppty.SalesOpportunity__c, new List<ProductSalesOpportunity__c>());
                  } 
                
                 //maps SalesOpp to product Sales opp
                 prodSalesOppttyListMap.get(prodSalesOppty.SalesOpportunity__c).add(prodSalesOppty);
            }
        }*/
            if(listOfProdSalesOpp.size() > 0){
                for(ProductSalesOpportunity__c optObj : listOfProdSalesOpp) {
                    if(!existingProductIds.contains(optObj.Product__c)){
                        newProductIds.add(optObj.Product__c);
                    }
                }
            }
        }
        //END-Added/Updated by Komal V for Story S-705939 | 8/12/2023 | adding products to a sales call-->
        for(Id prodId : newProductIds) {
            ProductActivity__c prodAct = new ProductActivity__c();
            prodAct.Product__c = prodId;
            prodAct.ProductStatus__c = '';
            prodAct.Operator__c = OperatorId;
            if(CurrentEmployeeId!=null)
            prodAct.Assigned_Employee__c = CurrentEmployeeId;
            prodAct.Verbal__C = true;
            prodAct.Activity__c = SalesCall.Id;
            prodAcctivityList.add(prodAct);
        }
        if(prodAcctivityList.isEmpty()) {
            ApexPages.addMessage(
                new ApexPages.message(ApexPages.severity.WARNING, Label.Sales_Opportunity_record));
            return null;
        } else {
            try {
                insert prodAcctivityList;
            } catch(Exception ex) {
                ApexPages.addMessages(ex);
                return null;
            }
        }
        StartUpAction();
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.Product_related_to_Sales_Opportunity_record));
        return null;
    }
    //END: Changes added by Gulab | S-696715 | 22-08-2022
    
    
    // START -  Added by ASL  June 22nd, 2022   S-695488 Wrapper class ClientSKU
    public class ClientSKU {
        public Boolean IsChecked {get; set;}
        public String Manufacturer{ get; set;}
        public String Client {get; set;}
        public String SKU {get; set;}
        public String OperatorId {get; set;}
        public ClientSKU(String manuf, String cli, String skuStr, String opId) {
            this.IsChecked = false;
            this.Manufacturer = manuf;
            this.Client = cli;
            this.SKU = skuStr;
            this.OperatorId = opId;
        }
    }// END -  Added by ASL  June 22nd, 2022   S-695488 Wrapper class ClientSKU 

    // START | Tushar Soni | 14/11/2022 | S-698550 | To get picklist values
    public List<SelectOption> getDidClientAssistWithSale() {

        List<SelectOption> options = new List<SelectOption>{new SelectOption('','--')};
            for(Schema.PicklistEntry value: CommittedOrder__c.Did_Client_Assist_with_Sale__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(value.getLabel(), value.getLabel()));
            }
        return options;
    }

    public List<SelectOption> getClientAssistType() {

        List<SelectOption> options = new List<SelectOption>();
            for(Schema.PicklistEntry value: CommittedOrder__c.Client_Assist_Type__c.getDescribe().getPicklistValues()) {
                options.add(new SelectOption(value.getLabel(), value.getLabel()));
            }
        return options;
    }
    // END | Tushar Soni | 14/11/2022 | S-698550 | To get picklist values
    // 
    /** Start | wipro | S-707000 | July 18,2024 | operator toggle */
    public Pagereference assignOperatorType() {
        SalesCall.Operator__c = OperatorId ;
        
        // START NCarson S-708258 1/24/26 - assign distributor based on Operator, if distributor is not set
        if ( /* String.isBlank(SalesCall.Distributor__c) && */ String.isNotBlank(OperatorId)) {
          List<Account> operatorRecordList = [SELECT Id, Primary_Distributor__c 
                                              FROM Account 
                                              WHERE Id = :OperatorId 
                                              AND (Type = 'Operator' OR Type = 'Distributor')
                                              LIMIT 1];
          if (operatorRecordList.size() > 0 /* && String.isNotBlank(operatorRecordList[0].Primary_Distributor__c) */) {
            SalesCall.Distributor__c = operatorRecordList[0].Primary_Distributor__c;
          }
        } // END NCarson S-708258 1/24/26
        
        update SalesCall ;

        Pagereference Pageref = Page.MeetingNow;
        Pageref.getParameters().put('Id',SalesCall.Id);

        // START NCarson C-00358566 - 10/9/25 - set new record parameter
        if (this.isNewRecord != null) {
          PageRef.getParameters().put('newRecord' , this.isNewRecord.toString());
        } // END NCarson C-00358566 10/9/25 

        Pageref.setRedirect(true);
        return Pageref;
        
    }
    /** End | wipro | S-707000 | July 18,2024 | operator toggle */
//Start || case 00358826 || save distributor to the database
     public Pagereference setDistributor() {
        SalesCall.Distributor__c = DistributorId ;
        update SalesCall ;

        Pagereference Pageref = Page.MeetingNow;
        Pageref.getParameters().put('Id', SalesCall.Id);
        
        if (this.isNewRecord != null) {
          PageRef.getParameters().put('newRecord' , this.isNewRecord.toString());
        }
        
        Pageref.setRedirect(true);  
        return Pageref;
    }
    //End || case 00358826 || save distributor to the database
    // START NCarson S-707646
    // public String contactIds {get;set;}
    // public String contactNames {get;set;}
    
    @RemoteAction
    public static List<Object> updateContacts(String salesCallId, String newContactIds, String newContactNames) {
        Activity__c newAct = new Activity__c(id = salesCallId);
        newAct.Contact_Ids__c = newContactIds;
        newAct.Contacts__c = newContactNames;
        update newAct;
        
        return null;
        /*
        Map<String,Object> parameters = (Map<String,Object>)JSON.deserializeUntyped(params);
        String recordIds = (string)parameters.get('recordIds');
        if(String.isNotBlank(recordIds)) {
            List<String> recordIdList = recordIds.split(',');
            List<Activity__c> actList = [SELECT Id, Operator__c, Operator__r.Name,Distributor__c, Distributor__r.Name, 
                            Operator__r.LargeLeverageOperator__c, Distributor__r.LargeLeverageOperator__c, 
                            StartDate__c, Operator__r.Market__r.Name, Activity_Number__c
                    FROM Activity__c 
                    WHERE Id IN :recordIdList] ;
            // return JSON.serialize(actList);
            return actList ;
        }
        return null ; */
  }

  public void setContacts() {
    System.debug('NCaron setContacts : ' + contactIds + '---' + contactNames);
    SalesCall.Contact_Ids__c = contactIds;
    SalesCall.Contacts__c = contactNames;
    update SalesCall;

    Pagereference Pageref = Page.MeetingNow;
    Pageref.getParameters().put('Id', SalesCall.Id);
    Pageref.setRedirect(true);
    // return Pageref;
  } // END NCarson S-707646

  //START added By Komal for Story S-707692 | 16/12/2024

  public List<SelectOption> getOilEvaluationOptions() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('', '--'));
    Schema.DescribeFieldResult fieldResult = ProductActivity__c.Was_an_Oil_Evaluation_Conducted__c.getDescribe();
    for (Schema.PicklistEntry entry : fieldResult.getPicklistValues()) {
      options.add(new SelectOption(entry.getValue(), entry.getLabel()));
    }
    return options;
  }
  //END added By Komal for Story S-707692 | 16/12/2024

  // START NCarson S-707880 - create pipelineOpportunity
  @RemoteAction
  public static String findAndUpdateMatchingOpportunity(
    String operatorId,
    String productIds,
    String activityId
  ) {
    try {
      if (operatorId == '' || productIds == '') {
        return 'Missing Dependency: Specify Operator and productIds';
      }

      // productIds is comma delimited list - convert to array
      List<String> productIdsList = new List<String>();
      if (!String.isBlank(productIds)) {
        productIdsList = productIds.split(',');
      }

      // first, get information on products
      Map<String,Product__c> productMap = new Map<String,Product__c>([
        SELECT Id, Manufacturer__c, ProductCategory__c
        FROM Product__c
        WHERE Id IN :productIdsList
      ]);
      List<Product__c> productList = productMap.values();
// START | Prakhar | 00358895 | get distributor from the Sales Call when activityId provided
        String distributorId = null;
            if (activityId != null) {
                Activity__c act = [SELECT Distributor__c FROM Activity__c WHERE Id = :activityId LIMIT 1];
                distributorId = act.Distributor__c;
            }
          // END | Prakhar | 00358895 | get distributor from the Sales Call when activityId provided
      
      Map<String,ProductActivity__c> productIdToProductActivitymap = new Map<String,ProductActivity__c>();
      List<ProductActivity__c> paList = [SELECT Id, Name, Product__c, Estimated_Weekly_Sales_Volume__c FROM ProductActivity__c
                                         WHERE Activity__c = :activityId];
      
      for (ProductActivity__c pa : paList) {
        productIdToProductActivitymap.put(pa.Product__c , pa);
      }
      
      /*[
        SELECT Id, Manufacturer__c, ProductCategory__c
        FROM Product__c
        WHERE Id IN :productIdsList
      ]; */

      if (productList.size() < 1) {
        return 'Products Not Found';
      }
      
      Map<String,List<String>> keyToProductIdListMap = new Map<String,List<String>>();
      List<String> manufacturerIds = new List<String>();
      List<String> categoryIds = new List<String>();
      
      for (Product__c prod : productList) {
        String theKey = prod.Manufacturer__c + '' + prod.ProductCategory__c;
        manufacturerIds.add(prod.Manufacturer__c);
        categoryIds.add(prod.ProductCategory__c);
        if (keyToProductIdListMap.containsKey(theKey)) {
          keyToProductIdListMap.get(theKey).add(prod.Id);
        } else {
          keyToProductIdListMap.put(theKey , 
            new List<String>{prod.Id}
          );
        }
      }

      // in current version, only concerned with first manufacturer and product category
      String manufacturerId = productList[0].Manufacturer__c;
      String categoryId = productList[0].ProductCategory__c;
        //START | Prakhar | 00358895 | Added the Opportunity_Status_Code__c, Primary_Distributor__c
      List<SalesOpportunity__c> existingrecords = [
        SELECT Id, Manufacturer__c, Operator__c, ProductCategory__c, Opportunity_Status_Code__c, Primary_Distributor__c
        FROM SalesOpportunity__c
        WHERE
          Manufacturer__c IN :manufacturerIds
          AND ProductCategory__c IN :categoryIds
          AND Operator__c = :operatorId
          AND Status__c = 'Active'
      ];
        //END | Prakhar | 00358895 | Added the Opportunity_Status_Code__c, Primary_Distributor__c
              
      Map<String,SalesOpportunity__c> salesOppMap = new Map<String,SalesOpportunity__c>();
      
      for (SalesOpportunity__c so : existingRecords) {
        String theKey = so.Manufacturer__c + '' + so.ProductCategory__c;
        salesOppMap.put(theKey , so);
      }

      // fold records into new Sales Opportunity
      List<ProductSalesOpportunity__c> newRecords = new List<ProductSalesOpportunity__c>();
      
      Map<SalesOpportunity__c , List<String>> salesOpptoProdListMap = 
        new Map<SalesOpportunity__c , List<String>>();
     
      // NCarson C-00358668 10/30/25 - use employeeId instead of query
      String employeeId = [SELECT Id FROM Employee__c WHERE User__c = :UserInfo.getUserId() LIMIT 1].Id;
 
      for (String manCatKey : keyToProductIdListMap.keySet()) {
        // if salesOpp exists - use that
        List<String> localProductIds = keyToProductIdListMap.get(manCatKey);
        if (salesOppMap.containsKey(manCatKey)) {
          SalesOpportunity__c relevantOpp = salesOppMap.get(manCatKey);
            
            //START | Prakhar | 00358895 | Set stage to Stage 3 when pipeline is hit
                    Boolean oppUpdated = false;
                    if (relevantOpp.Opportunity_Status_Code__c == null ||
                            relevantOpp.Opportunity_Status_Code__c == '1 - Prospect / Target' ||
                            relevantOpp.Opportunity_Status_Code__c == '2 - Qualification') {
                        relevantOpp.Opportunity_Status_Code__c = '3 - Proposal / Test';
                                oppUpdated = true;
                    }

                    // Sync distributor from Sales Call when available
                    if (distributorId != null && relevantOpp.Primary_Distributor__c != distributorId) {
                        relevantOpp.Primary_Distributor__c = distributorId;
                        oppUpdated = true;
                    }

                    if (oppUpdated) {
                        update relevantOpp;
                    }
                 // End | Prakhar | 00358895 | Set stage to Stage 3 when pipeline is hit
          
          for (String productId : localProductIds) {
            ProductSalesOpportunity__c pso = new ProductSalesOpportunity__c();
            pso.Product__c = productId;
            pso.SalesOpportunity__c = relevantOpp.Id;
            newRecords.add(pso);
          }
        } else {
          // no sales opp exists - create new one
          SalesOpportunity__c newSO = new SalesOpportunity__c();
          // get manufacturer / category
          Product__c baseProduct = productMap.get(localProductIds[0]);
          newSO.ProductCategory__c = baseProduct.ProductCategory__c;
          newSO.Manufacturer__c = baseProduct.Manufacturer__c;
          newSO.Operator__c = operatorId;
          newSO.CreatedonActivityID__c = activityId;
            //Start | Prakhar | 00358895 | Added 2 condition
          newSO.Primary_Distributor__c = distributorId;
          newSO.Opportunity_Status_Code__c = '3 - Proposal / Test';
          //End | Prakhar | 00358895 | Added 2 condition
          
          /*  Employee, Start Date, Expected Completion Date, Please specify Weekly Volume */
          // NCarson C-00358668 10/30/25 - use employeeId instead of query
          newSO.Employee__c = employeeId; // [SELECT Id FROM Employee__c WHERE User__c = :UserInfo.getUserId() LIMIT 1].Id;
          newSO.StartDate__c = Date.today();
          newSO.EndDate__c = Date.today().addDays(90);
          newSO.EstCurrentWeeklyVolume__c = 0;
          
          // this is bad! should be refactored to not do a DML like this, but, need the id - 
          insert newSO;
          
          // need to query product activity to get estimated weekly volume
          Decimal weeklyVolume = 0;
          for (String productId : localProductIds) {
            ProductSalesOpportunity__c pso = new ProductSalesOpportunity__c();
            pso.Product__c = productId;
            pso.SalesOpportunity__c = newSO.Id;
            newRecords.add(pso);
            
            if (productIdToProductActivityMap.containsKey(productId)) {
              weeklyVolume += productIdToProductActivitymap.get(productId).Estimated_Weekly_Sales_Volume__c;
            }
          }
          
          if (weeklyVolume > 0) {
            newSO.EstCurrentWeeklyVolume__c = weeklyVolume;
            update newSO;
          }
          
          // salesOpptoProdListMap.put(newSO , localProductIds);
        }
      }
      
      /*
      if (salesOppToProdListMap.size() > 0) {
        // convert to list for DML
        insert new List<SalesOpportunity__c>(salesOppToProdListMap.keySet());
        
      } */
      /*
      for (String productId : productIdsList) {
        ProductSalesOpportunity__c pso = new ProductSalesOpportunity__c();
        pso.Product__c = productId;
        if (existingRecords.size() > 0) {
          pso.SalesOpportunity__c = existingRecords[0].Id;
        }
        newRecords.add(pso);
      } */

      insert newRecords;
    } catch (Exception e) {
      return 'Exception : ' + e.getMessage();
      // respond(false, 'Cause: ' + e.getMessage() + ' -- ' + e.getLineNumber());
    }

    return 'Matching Opportunity Found and Updated';
  }

  @RemoteAction
  public static String createPipelineOpportunity(
    String productIds,
    String callId
  ) {
    SalesOpportunity__c salesOpp = new SalesOpportunity__c();
    /*salesOpp.Estimated_Weekly_Sales_Volume__c = weeklyVolumePotential; 
        salesOpp.Description__c = comments;
        salesOpp.Type__c = type; */
    salesOpp.Employee__c = [
      SELECT Id
      FROM Employee__c
      WHERE User__c = :UserInfo.getUserId()
      LIMIT 1
    ]
    .Id;

    Activity__c[] act = [
      SELECT
        Id,
        Distributor_2__c,
        Operator__c,
        Operator__r.Id,
        Employee__r.Id,
        (
          SELECT Id, Product__c, Estimated_Weekly_Sales_Volume__c
          FROM Product_Activities__r
        )
      FROM Activity__c
      WHERE Id = :callId
      LIMIT 1
    ];

    Map<String, Decimal> productIdToWeeklyVolumeMap = new Map<String, Decimal>();
    Decimal estimatedVolume = 0;
    if (act.size() > 0) {
      Activity__c mainActivity = act[0];

      // first, use existing record
      String resultString = findAndUpdateMatchingOpportunity(
        mainActivity.Operator__c,
        productIds,
        //Start | Prakhar | 00358895 | Comment the null And pass activity to carry distributor/stage logic
        //null
        callId
        //End | Prakhar | 00358895 | Comment the null And pass activity to carry distributor/stage logic
      );

      if (resultString == 'Matching Opportunity Found and Updated') {
        return resultString;
      }

      for (ProductActivity__c pa : mainActivity.Product_Activities__r) {
        if (productIds.contains(pa.Product__c)) {
          estimatedVolume += pa.Estimated_Weekly_Sales_Volume__c;
        }
        // productIdToWeeklyVolumeMap.put(pa.Product__c , pa.Estimated_Weekly_Sales_Volume__c);
      }
    }

    // START Utkarsh + NCarson C-00358161 7/23/25 - set EstCurrentWeeklyVolume__c instead of estimated Weekly Sales Volume
    // salesOpp.Estimated_Weekly_Sales_Volume__c = estimatedVolume.toString();
    salesOpp.EstCurrentWeeklyVolume__c = estimatedVolume;
    // END Utkarsh + NCarson C-00358161 7/23/25 - set EstCurrentWeeklyVolume__c instead of estimated Weekly Sales Volume
    salesOpp.StartDate__c = Date.today(); // Date.newInstance(Integer.valueOf(startDateNumbers[0]), Integer.valueOf(startDateNumbers[1]), Integer.valueOf(startDateNumbers[2]));
    salesOpp.EndDate__c = Date.today().addDays(90); // Date.newInstance(Integer.valueOf(endDateNumbers[0]), Integer.valueOf(endDateNumbers[1]), Integer.valueOf(endDateNumbers[2]));

    if (act.size() > 0) {
      salesOpp.Operator__c = act[0].Operator__c;
      salesOpp.Primary_Distributor__c = act[0].Distributor_2__c;
    }

    // default values for fields
    salesOpp.Updated__c = true;
    salesOpp.Status__c = 'Active';
    salesOpp.OpportunitySource__c = 'Sales Rep Personal Opportunity';
    salesOpp.Opportunity_Status_Code__c = '3 - Proposal / Test';

    if (!String.isBlank(productIds)) {
      List<String> productIdList = productIds.split(',');
      Product__c firstProduct = [
        SELECT Id, Manufacturer__c, ProductCategory__c
        FROM Product__c
        WHERE Id = :productIdList[0]
        LIMIT 1
      ];

      salesOpp.ProductCategory__c = firstProduct.ProductCategory__c;
      salesOpp.Manufacturer__c = firstProduct.Manufacturer__c;
    }

    insert salesOpp;

    // create related records
    List<ProductSalesOpportunity__c> psoList = new List<ProductSalesOpportunity__c>();

    // productIds should be comma-delimited string of product__c Ids -
    // separate into individual Ids
    if (!String.isBlank(productIds)) {
      List<String> productIdList = productIds.split(',');
      for (String productId : productIdList) {
        ProductSalesOpportunity__c pso = new ProductSalesOpportunity__c();
        pso.Product__c = productId;
        pso.SalesOpportunity__c = salesOpp.Id;
        psoList.add(pso);
      }
    }

    insert psoList;

    return 'New Pipeline Opportunity Created';
  } // END NCarson S-707880
    // START || S-708058 || Prashant || 08/07/2025
    @RemoteAction
    public static ProductActivity__c getProdActHist(String paId) {
        ProductActivity__c existingPA;
        try{
            existingPA = [ SELECT Id,Using_Purchase_Frequency__c, Not_Sold_Price__c, Not_Sold_Result_is_Final__c, Activity__c, 
                          Activity_End_Date__c, Activity_Start_Date__c,  WeeklyVolume__c, Estimated_Weekly_Sales_Volume__c, 
                          Where_do_we_need_to_get_pricing__c, What_are_next_steps__c, Reasons_unsold__c, Pipeline_Activity__c, 
                          Sale_is_In_Progress__c, Sales_in_Progress__c, Competitive_Client__c, Who_was_the_Distributor__c,
                          OperatorFeedbackReasons__c, Operator_Unwilling_Feedback__c, Reasons_unwilling_to_consider__c, 
                          What_is_the_allowance_per_case_needed__c, Using_Distributor__c,Was_a_cutting_conducted__c, 
                          Who_needs_to_review_product_at_Operator__c,Quality_Issue__c, Product__c,Was_an_Oil_Evaluation_Conducted__c,
                          ProductStatus__c,OperatorFeedback__c,Who_Was_Distributor_Name__c,Sale_Progress_Follow_up_Call__c,
                          CasesWeekUsage__c,Competitive_Client_Name__c,tf_Product_SKU__c,tf_ProductClientName__c,Product__r.Name,
                          Using_Distributor__r.Name,Activity__r.Operator__c,Quantity_Entered__c, 
                          ( SELECT Id,FeedbackType__c,Quantity_Entered__c,Distributor__c,Distributor__r.Name,Quantity__c, Sale_Type__c,
                           CompetitorInformation__c,ExpectedOrder__c,Feedback__c,Client_Assist_Type__c,Expected_Order_End_Date__c,
                           Contact__c,Contact__r.Name,Did_Client_Assist_with_Sale__c 
                           FROM Committed_Orders__r WHERE
                           FeedbackType__c IN ('Annual Orders','Weekly Orders','Monthly Orders','One Time Order Only','Specific Menu Placement / LTO'
                                               ,'Trial Order Only') ORDER BY CreatedDate ASC )
                          FROM ProductActivity__c WHERE Id = :paId ORDER BY CreatedDate DESC LIMIT 1 ];
        } catch (Exception e) {
            existingPA = null;
        }
        return existingPA;
    }
    // END || S-708058 || Prashant || 08/07/2025 
}
