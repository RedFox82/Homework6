public with sharing class ContactSelector {

    public static List<Contact> selectContactsByAccountID(Id accountId) {
        List<Contact> contacts = [SELECT Id, Name, Title, Email, Phone
                                  FROM Contact
                                  WHERE AccountId = :accountId];
        return contacts;
    }


}

