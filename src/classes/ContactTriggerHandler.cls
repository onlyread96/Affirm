public with sharing class ContactTriggerHandler extends TriggerHandler {

    public override void beforeInsert() {
        updateIndustry();
    }

    public override void beforeUpdate() {
        updateIndustry();
    }

    private void updateIndustry() {
        Map<Id,List<Contact>> accConMap = new Map<Id,List<Contact>>();
        for(Contact con : (List<Contact>)Trigger.new) {
            if(accConMap.containsKey(con.AccountId)) {
                accConMap.get(con.AccountId).add(con);
            } else {
                accConMap.put(con.AccountId,new List<Contact>{con});
            }
        }
        for(Account acc : [SELECT ID,Industry
                            FROM Account
                            WHERE Id in: accConMap.keySet()]) {

            if(accConMap.containsKey(acc.Id)) {
                for(Contact con : accConMap.get(acc.Id)) {
                    con.Account_Industry__c = acc.Industry;
                }
            }
        }               
    }
}