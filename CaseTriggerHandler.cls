public with sharing class CaseTriggerHandler {
    public static Map<Id, Integer> updCountriesI = new Map<Id, Integer>();
    public static List<Map<Id, Integer>> updCountriesU = new List<Map<Id, Integer>>();

    public static void handle(List<Case> triggerCases, List<Case> triggerOldCases, System.TriggerOperation triggerOperation) {

        switch on triggerOperation {
            when BEFORE_INSERT {
                updCountriesI = CaseService.CasesInsert(triggerCases);
            }
            when BEFORE_UPDATE {
                updCountriesU = CaseService.CasesUpdate(triggerCases, triggerOldCases);
            }
            when AFTER_INSERT {
                CaseService.UpdAfterInsert(updCountriesI);
            }
            when AFTER_UPDATE {
                CaseService.UpdAfterUpdate(updCountriesU);
            }
        }
    }
}