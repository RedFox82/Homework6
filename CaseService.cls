public with sharing class CaseService {

//Get closed cases list for Insert operation
    public static Map<Id, Integer> CasesInsert(List<Case> triggerCases) {

        List<Case> Closed_Cases = new List<Case>();   //Closed cases in trigger.new
        Set<String> Ids_Countries = new Set<String>();    //Countries for add closes cases

        for (Case c : triggerCases) {
            if (c.Country__c != null && c.Status == 'Closed') {
                Closed_Cases.add(c);
                Ids_Countries.add(c.Country__c);
            }
        }
        return get_from_Countries(Closed_Cases, Ids_Countries);
    }

//Get closed cases list for Update operation
    public static List<Map<Id, Integer>> CasesUpdate(List<Case> triggerCases, List<Case> triggerOldCases) {

        List<Map<Id, Integer>> updCountries = new List<Map<Id, Integer>>(); //list of collections countries for update

        List<Case> Closed_Cases = new List<Case>();     //Closed cases in trigger.new
        List<Case> Closed_Cases_Old = new List<Case>();     //Closed cases in trigger.old
        List<Case> Reopen_Cases = new List<Case>();     //Reopened cases in trigger.new

        Set<String> Ids_Countries = new Set<String>();      //Countries for add closed cases
        Set<String> Ids_decreaseCountries = new Set<String>();     //Countries for decrease reopened or with changed countries cases

        for (Case c : triggerCases) {
            String oldStatus = '';
            String oldCountry = '';

            //Search old values for Status && Country__c
            for (Case oldCase : triggerOldCases) {
                if (OldCase.id == c.id) {
                    oldStatus = OldCase.Status;
                    oldCountry = OldCase.Country__c;
                    break;
                }
            }
            //if old value for Status not "Closed"
            if (c.Country__c != null && c.Status == 'Closed' && oldStatus!= 'Closed'){
                Closed_Cases.add(c);
                Ids_Countries.add(c.Country__c);
            }
            //if old value for Status "Closed" but value Country__c changed
            else if (c.Country__c != null && c.Status == 'Closed' && oldStatus == 'Closed' && oldCountry != c.Country__c) {
                Closed_Cases.add(c);
                for (Case old : triggerOldCases) {
                    if (c.Id == old.Id) {
                        Closed_Cases_Old.add(old);
                    }
                }
                Ids_Countries.add(c.Country__c);
                Ids_decreaseCountries.add(oldCountry);
            }
            //reopened case
            else if (c.Status != 'Closed' && oldStatus == 'Closed') {
                Reopen_Cases.add(c);
                Ids_decreaseCountries.add(oldCountry);
            }
        }
        updCountries.add(get_from_Countries(Closed_Cases, Ids_Countries));
        updCountries.add(decreaseCountries(Closed_Cases_Old, Closed_Cases, Reopen_Cases, Ids_decreaseCountries));

        return updCountries;
    }

//Get map of countries with number of cases for add and change triggered records
    public static Map<Id, Integer> get_from_Countries(List<Case> Closed_Cases, Set<String> Ids_Countries) {
        Map<Id, Integer> CountriesCases = new Map<Id, Integer>();
        if (Closed_Cases.size() > 0) {
            List<Country__c> Countries = [SELECT Id, ClosedCases__c, SuccessMessage__c
                                          FROM Country__c
                                          WHERE Id IN :Ids_Countries];

            for (Country__c country : Countries) {
                Integer counter = 0;
                for (Case c : Closed_Cases) {
                    if (country.Id == c.Country__c) {
                        counter++;
                        c.SuccessMessage__c = country.SuccessMessage__c;
                        CountriesCases.put(country.Id, counter);
                    }
                }
            }

        }
        return CountriesCases;
    }

//Get map of countries with number of cases for decrease and change triggered records
    public static Map<Id, Integer> decreaseCountries( List<Case> Closed_Cases_Old, List<Case> Closed_Cases, List<Case> Reopen_Cases, Set<String> Ids_decreaseCountries) {
        Map<Id, Integer> CountriesDec = new Map<Id, Integer>();
        List<Country__c> Countries = new List<Country__c>();

        if (Ids_decreaseCountries.size() > 0) {
            Countries = [SELECT Id, ClosedCases__c, SuccessMessage__c
                         FROM Country__c
                         WHERE Id IN :Ids_decreaseCountries];

            for (Country__c country : Countries) {
                Integer counter = 0;
                for (Case cc : Closed_Cases) {
                    Case old = new Case();
                    for (Case c : Closed_Cases_Old) {
                        if (c.Id == cc.Id) { old = c;}
                    }
                    if (country.Id == old.Country__c) {
                        counter--;
                        CountriesDec.put(country.Id, counter);
                    }
                }
                for (Case rc : Reopen_Cases) {
                    if (country.Id == rc.Country__c) {
                        counter--;
                        CountriesDec.put(country.Id, counter);
                        rc.SuccessMessage__c = '';
                    }
                }
            }
        }
        return CountriesDec;
    }

//Update in after-trigger for Insert operation
    public static void UpdAfterInsert(Map<Id, Integer> Ids_Countries)     {
        if (Ids_Countries.size() > 0) {
             Set<Id> Ids = Ids_Countries.keySet();
             List<Country__c> Countries = [SELECT Id, ClosedCases__c, SuccessMessage__c
                                           FROM Country__c
                                           WHERE Id IN :Ids];

            for (Country__c country : Countries) {
                country.ClosedCases__c = country.ClosedCases__c + Ids_Countries.get(country.Id);
            }
            update Countries;
        }
    }

//Update in after-trigger for Update operation
    public static void UpdAfterUpdate(List<Map<Id, Integer>> Ids_Countries)     {
            List<Country__c> updCountries = new List<Country__c>();

        for (Map<Id, Integer> mp : Ids_Countries) {
            Set<Id> Ids = mp.keySet();
            if (Ids.size() != 0) {
                System.debug(Ids);
                List<Country__c> Countries = [SELECT Id, ClosedCases__c, SuccessMessage__c
                                              FROM Country__c
                                              WHERE Id IN :Ids];
                for (Country__c country : Countries) {
                    country.ClosedCases__c = country.ClosedCases__c + mp.get(country.Id);
                    updCountries.add(country);
                }
            }
        }
        update updCountries;
    }

}