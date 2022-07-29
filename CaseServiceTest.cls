/**
 * Created by olgao on 26.07.2022.
 */
@IsTest
private class CaseServiceTest {

//create countries record for tests
    @testSetup static void setup() {
        List<Country__c> countries = new List<Country__c>();
        countries.add(new Country__c(Name = 'Test_Country1', ClosedCases__c = 0, SuccessMessage__c = 'Hello! Test_Country1!'));
        countries.add(new Country__c(Name = 'Test_Country2', ClosedCases__c = 0, SuccessMessage__c = 'Hello! Test_Country2!'));
        insert countries;
    }


//if insert closed case with country not null
    @IsTest
    static void CasesInsert_positive() {
        //given
        Country__c Country = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c LIMIT 1];
        Decimal Closed_Before = Country.ClosedCases__c;
        Case closed_case = TestDataFactory.ListClosedCase(1, Country.Id)[0];

        //when
        Test.startTest();
        insert closed_case;
        Test.stopTest();

        //then
        List<Case> closed_cases = [SELECT Id, Status, Country__c, Origin, SuccessMessage__c FROM Case];
        System.assertEquals(1, closed_cases.size());
        System.assertEquals(Country.SuccessMessage__c, closed_cases[0].SuccessMessage__c);

        Country = [SELECT Id, ClosedCases__c FROM Country__c WHERE Id = :Country.Id];
        System.assertEquals(Closed_Before + 1, Country.ClosedCases__c);
    }

//if insert open case
    @IsTest
    static void CasesInsert_negative() {
        //given
        Country__c Country = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c LIMIT 1];
        Decimal Closed_Before = Country.ClosedCases__c;
        Case open_case = TestDataFactory.ListOpenCase(1, Country.Id)[0];

        //when
        Test.startTest();
        insert open_case;
        Test.stopTest();

        //then
        List<Case> open_cases = [SELECT Id, Status, Country__c, Origin, SuccessMessage__c FROM Case];
        System.assertEquals(1, open_cases.size());
        System.assertEquals(null, open_cases[0].SuccessMessage__c);

        Country = [SELECT Id, ClosedCases__c FROM Country__c WHERE Id = :Country.Id];
        System.assertEquals(Closed_Before, Country.ClosedCases__c);
    }

//if insert closed and open cases for different countries in bulk
    @IsTest
    static void CasesInsert_bulk() {
        //given
        Integer closed = 100;
        Integer open = 100;
        List<Country__c> countries = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c];
        List<Case> all_cases = new List<Case>();
        Map<Id, Decimal> before_cases = new Map<Id, Decimal>();

        for (Country__c country : countries) {
            before_cases.put(country.Id, country.ClosedCases__c);
            all_cases.addAll(TestDataFactory.ListClosedCase(closed, country.Id));
            all_cases.addAll(TestDataFactory.ListOpenCase(closed, country.Id));
        }


        //when
        Test.startTest();
        insert all_cases;
        Test.stopTest();

        //then
        List<Case> closed_cases = [SELECT Id FROM Case WHERE Status = 'Closed'];
        System.assertEquals(closed * countries.size(), closed_cases.size());

        List<Case> open_cases = [SELECT Id FROM Case WHERE Status != 'Closed'];
        System.assertEquals(open * countries.size(), open_cases.size());

        countries = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c];
        for (Country__c country : countries) {
            List<Case> country_cases = [SELECT Id, Status, SuccessMessage__c FROM Case WHERE Country__c = :country.Id AND Status = 'Closed'];
            System.assertEquals(before_cases.get(country.Id) + country_cases.size(), country.ClosedCases__c);
            for (Case country_case : country_cases) {
                System.assertEquals(country_case.SuccessMessage__c, country.SuccessMessage__c);
            }
        }

    }

//Closing process for not close case
    @IsTest
    static void CasesUpdate_positive() {
        //given
        Case ins_case = TestDataFactory.ListOpenCase(1, null)[0];
        insert ins_case;
        Country__c Country = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c LIMIT 1];
        Decimal Closed_Before = Country.ClosedCases__c;

        Case closed_case = [SELECT Id FROM Case];
        closed_case.Country__c = Country.Id;
        closed_case.Status = 'Closed';

        //when
        Test.startTest();
        update closed_case;
        Test.stopTest();

        //then
        List<Case> closed_cases = [SELECT Id, Status, Country__c, Origin, SuccessMessage__c FROM Case];
        System.assertEquals(1, closed_cases.size());
        System.assertEquals(Country.SuccessMessage__c, closed_cases[0].SuccessMessage__c);

        Country = [SELECT Id, ClosedCases__c FROM Country__c WHERE Id = :Country.Id];
        System.assertEquals(Closed_Before + 1, Country.ClosedCases__c);
    }

//if update closed case without changing country
    @IsTest
    static void CasesUpdate_negative1() {
        //given
        Country__c Country = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c LIMIT 1];
        Decimal Closed_Before = Country.ClosedCases__c;
        Case ins_case = TestDataFactory.ListClosedCase(1, Country.Id)[0];
        ins_case.SuccessMessage__c = Country.SuccessMessage__c;
        insert ins_case;

        Case closed_case = [SELECT Id FROM Case];

        //when
        Test.startTest();
        update closed_case;
        Test.stopTest();

        //then
        List<Case> closed_cases = [SELECT Id, Status, Country__c, Origin, SuccessMessage__c FROM Case];
        System.assertEquals(1, closed_cases.size());
        System.assertEquals(Country.SuccessMessage__c, closed_cases[0].SuccessMessage__c);

        Country = [SELECT Id, ClosedCases__c FROM Country__c WHERE Id = :Country.Id];
        System.assertEquals(Closed_Before + 1, Country.ClosedCases__c);
    }

//if update closed case with changing country
    @IsTest
    static void CasesUpdate_negative2() {
        //given
        Country__c before_Country = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c LIMIT 1];
        Decimal Closed_Before = before_Country.ClosedCases__c;

        Case ins_case = TestDataFactory.ListClosedCase(1, before_Country.Id)[0];
        ins_case.SuccessMessage__c = before_Country.SuccessMessage__c;
        insert ins_case;

        Country__c after_Country = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c WHERE Id != :ins_case.Country__c LIMIT 1];
        Case closed_case = [SELECT Id FROM Case];
        closed_case.Country__c = after_Country.Id;
        Decimal Closed_After = after_Country.ClosedCases__c;

        //when
        Test.startTest();
        update closed_case;
        Test.stopTest();

        //then
        List<Case> closed_cases = [SELECT Id, Status, Country__c, Origin, SuccessMessage__c FROM Case];
        System.assertEquals(1, closed_cases.size());

        after_Country = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c WHERE Id = :after_Country.Id];
        System.assertEquals(Closed_After + 1, after_Country.ClosedCases__c);

        before_Country = [SELECT Id, ClosedCases__c FROM Country__c WHERE Id = :before_Country.Id];
        System.assertEquals(Closed_Before, before_Country.ClosedCases__c);
    }

//if update closed case with changing country null
    @IsTest
    static void CasesUpdate_negative2a() {
        //given
        Country__c before_Country = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c LIMIT 1];
        Decimal Closed_Before = before_Country.ClosedCases__c;

        Case ins_case = TestDataFactory.ListClosedCase(1, before_Country.Id)[0];
        ins_case.SuccessMessage__c = before_Country.SuccessMessage__c;
        insert ins_case;

        Case closed_case = [SELECT Id FROM Case];
        closed_case.Country__c = null;

        //when
        Test.startTest();
        update closed_case;
        Test.stopTest();

        //then
        List<Case> closed_cases = [SELECT Id, Status, Country__c, Origin, SuccessMessage__c FROM Case];
        System.assertEquals(1, closed_cases.size());

        before_Country = [SELECT Id, ClosedCases__c FROM Country__c WHERE Id = :before_Country.Id];
        System.assertEquals(Closed_Before, before_Country.ClosedCases__c);
    }  //bug detected

//if reopened closed case
    @IsTest
    static void CasesUpdate_negative3() {
        //given
        Country__c Country = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c LIMIT 1];
        Decimal Closed_Before = Country.ClosedCases__c;

        Case ins_case = TestDataFactory.ListClosedCase(1, Country.Id)[0];
        ins_case.SuccessMessage__c = Country.SuccessMessage__c;
        insert ins_case;

        Case reopened_case = [SELECT Id FROM Case];
        reopened_case.Status = 'Working';

        //when
        Test.startTest();
        update reopened_case;
        Test.stopTest();

        //then
        List<Case> reopened_cases = [SELECT Id, Status, Country__c, Origin, SuccessMessage__c FROM Case];
        System.assertEquals(1, reopened_cases.size());
        System.assertEquals(null, reopened_cases[0].SuccessMessage__c);

        Country = [SELECT Id, ClosedCases__c FROM Country__c WHERE Id = :Country.Id];
        System.assertEquals(Closed_Before, Country.ClosedCases__c);
    }

//if update different cases for different countries in bulk
    @IsTest
    static void CasesUpdate_bulk() {
        //given
        Integer closed = 90;
        Integer open = 30;
        List<Country__c> countries = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c];
        List<Case> ins_cases = new List<Case>();
        Map<Id, Decimal> before_cases = new Map<Id, Decimal>();

        for (Country__c country : countries) {
            before_cases.put(country.Id, country.ClosedCases__c);
            ins_cases.addAll(TestDataFactory.ListClosedCase(closed, country.Id));
            ins_cases.addAll(TestDataFactory.ListOpenCase(open, country.Id));
        }
        insert ins_cases;

        Map<Id, List<Case>> all_closed = new Map<Id, List<Case>>();
        Map<Id, List<Case>> all_open = new Map<Id, List<Case>>();

        List<Case> cl_cases = [SELECT Id, Country__c, Status, SuccessMessage__c FROM Case WHERE Country__c != null AND Status = 'Closed'];
        List<Case> op_cases = [SELECT Id, Country__c, Status, SuccessMessage__c FROM Case WHERE Country__c != null AND Status != 'Closed'];

        for (Country__c country : countries) {
            List<Case> tmp = new List<Case>();
            for (Case c : cl_cases) {
                if (c.Country__c == country.Id)  {tmp.add(c);}
            }
            all_closed.put(country.Id, tmp);
        }

        for (Country__c country : countries) {
            List<Case> tmp = new List<Case>();
            for (Case c : op_cases) {
                if (c.Country__c == country.Id)  {tmp.add(c);}
            }
            all_open.put(country.Id, tmp);
        }

        List<Case> upd_cases = new List<Case>();
        Set<Id> Ids1 = all_open.keySet();
        for (Id c : Ids1) {
            List<Case> cases_c = all_open.get(c);
            for (Case case_c : cases_c) {
                case_c.Status = 'Closed';
                upd_cases.add(case_c);
            }
        }
        Set<Id> Ids2 = all_closed.keySet();
        for (Id c : Ids2) {
            List<Case> cases_c = all_closed.get(c);
            for (Integer i = 0; i < cases_c.size()/3; i++) {
                cases_c[i].Status = 'Working';
                upd_cases.add(cases_c[i]);
            }
            for (Integer i = cases_c.size()/3; i < 2 * cases_c.size()/3; i++) {
                cases_c[i].Status = 'Closed';
                upd_cases.add(cases_c[i]);
            }
            for (Integer i = 2 * cases_c.size()/3; i < cases_c.size(); i++) {
                cases_c[i].Country__c = null;
                upd_cases.add(cases_c[i]);
            }
        }

        //when
        Test.startTest();
        update upd_cases;
        Test.stopTest();

        //then
        countries = [SELECT Id, ClosedCases__c, SuccessMessage__c FROM Country__c];
        for (Country__c country : countries) {
            List<Case> closed_cases = [SELECT Id FROM Case WHERE Status = 'Closed' AND Country__c = :country.Id];
            System.assertEquals(before_cases.get(country.Id) + closed_cases.size(), country.ClosedCases__c);
        }
    }  //bug detected

}