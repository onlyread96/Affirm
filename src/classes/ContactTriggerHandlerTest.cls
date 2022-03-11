@isTest
public with sharing class ContactTriggerHandlerTest {

    @TestSetup
    static void makeData(){
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name='Account1',Industry='Software'));
        accList.add(new Account(Name='Account2',Industry='AeroSpace'));
        insert accList;

        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(LastName = 'test1', AccountId = accList[0].Id));
        conList.add(new Contact(LastName = 'test2', AccountId = accList[0].Id));
        //contact for second account
        conList.add(new Contact(LastName = 'test3', AccountId = accList[1].Id));
        conList.add(new Contact(LastName = 'test4', AccountId = accList[1].Id));

        insert conList;
    }

    @IsTest
    static void testCreateContact(){

        List<Account> accList = [SELECT Id FROM Account];
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(LastName = 'test1', AccountId = accList[0].Id));
        conList.add(new Contact(LastName = 'test2', AccountId = accList[0].Id));
        //contact for second account
        conList.add(new Contact(LastName = 'test3', AccountId = accList[1].Id));
        conList.add(new Contact(LastName = 'test4', AccountId = accList[1].Id));
        
        Test.startTest();
        insert conList;
        Test.stopTest();

        //requery contact
        conList = [SELECT Id,Account.Industry,Account_Industry__c
                   FROM Contact
                   WHERE Id in: conList];

        //4 contacts created in this test method.
        System.assertEquals(4,conList.size());

        for(Contact con : conList) {
            System.assertEquals(con.Account.Industry, con.Account_Industry__c);
        }
    }

    @IsTest
    static void testUpdateContact() {

        List<Account> accList = [SELECT Id FROM Account 
                                 WHERE Industry in ('Software','AeroSpace') 
                                 Limit 2];
        //update account industry
        accList[0].Industry = 'Industrial';
        accList[1].Industry = 'Financial';
        update accList;

        //query contact check Industry fields don't match anymore
        List<Contact> conList = [SELECT Id,Account.Industry, Account_Industry__c
                                 FROM Contact
                                 WHERE AccountId in: accList];
        //4 records expected
        System.assertEquals(4, conList.size());

        //Account's Industry and Contact.Account_Industry do not match any more.
        for(Contact con : conList) {
            System.assertNotEquals(con.Account.Industry, con.Account_Industry__c);
        }

        Test.startTest();
        update conList; //dummy update
        Test.stopTest();

        //requery contact
        conList = [SELECT Id,Account.Industry, Account_Industry__c
                                 FROM Contact
                                 WHERE AccountId in: accList];
        //4 records expected
        System.assertEquals(4, conList.size());

        //Account's Industry and Contact.Account_Industry should match.
        for(Contact con : conList) {
            System.assertEquals(con.Account.Industry, con.Account_Industry__c);
        }
    }
}