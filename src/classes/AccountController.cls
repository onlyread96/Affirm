public with sharing class AccountController {
  @AuraEnabled(cacheable=true)
  public static List<Account> getAccountList(){
    try {
        List<Account> accList = [SELECT Id, Name 
                                   FROM Account LIMIT 5];
        System.debug('Account list isze--'+accList.size());
        return accList;
      } catch (Exception e) {
          throw new AuraHandledException(e.getMessage());
      }
  }

  @AuraEnabled
  public static Account getAccountDetails(String detailRecordId) {
    try {
      Account acc = [SELECT Id, Name, Industry, Type, Owner.Name , Owner.FullPhotoUrl
                     FROM Account 
                     WHERE Id =: detailRecordId];
      System.debug('Account query');
        return acc;
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
  }

  

}